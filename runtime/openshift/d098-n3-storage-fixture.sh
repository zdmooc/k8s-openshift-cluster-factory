#!/usr/bin/env bash
set -Eeuo pipefail

# D-098 SQY-4 disposable storage RCA fixture.
# Creates only a dedicated temporary namespace and PVCs, then removes them.

[ "${CONFIRM_D098_STORAGE_FIXTURE:-}" = "yes" ] || {
  echo "[STOP] Re-run with CONFIRM_D098_STORAGE_FIXTURE=yes"
  exit 2
}

for cmd in oc kubectl; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "[FAIL] $cmd not found"; exit 1; }
done

NS="d098-n3-storage"
BAD_SC="d098-nonexistent-storageclass"
GOOD_SC="${D098_STORAGECLASS:-crc-csi-hostpath-provisioner}"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="evidence/out/d098-n3-storage-$STAMP"
mkdir -p "$OUT"

cleanup() {
  oc delete ns "$NS" --ignore-not-found --wait=false >/dev/null 2>&1 || true
}
trap cleanup EXIT

oc delete ns "$NS" --ignore-not-found --wait=true >/dev/null 2>&1 || true
oc create ns "$NS" | tee "$OUT/namespace-create.txt"

echo "===== STORAGE SCENARIO — INJECT BAD STORAGECLASS ====="
cat <<EOF | oc apply -f - | tee "$OUT/bad-pvc-apply.txt"
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: bad-storageclass
  namespace: $NS
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: $BAD_SC
  resources:
    requests:
      storage: 128Mi
EOF

sleep 8
oc -n "$NS" get pvc -o wide | tee "$OUT/bad-pvc-state.txt"
oc -n "$NS" describe pvc bad-storageclass | tee "$OUT/bad-pvc-describe.txt"

BAD_PHASE="$(oc -n "$NS" get pvc bad-storageclass -o jsonpath='{.status.phase}')"
if [ "$BAD_PHASE" != "Pending" ]; then
  echo "[FAIL] expected bad PVC Pending, got $BAD_PHASE"
  exit 1
fi

echo "===== STORAGE SCENARIO — RCA ====="
if ! oc get storageclass "$BAD_SC" >/dev/null 2>&1; then
  echo "root_cause=StorageClass '$BAD_SC' does not exist" | tee "$OUT/rca.txt"
else
  echo "[FAIL] bad StorageClass unexpectedly exists"
  exit 1
fi

echo "===== STORAGE SCENARIO — RECOVER WITH VALID STORAGECLASS ====="
oc -n "$NS" delete pvc bad-storageclass --wait=true | tee "$OUT/bad-pvc-delete.txt"

cat <<EOF | oc apply -f - | tee "$OUT/good-pvc-apply.txt"
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: recovered-storage
  namespace: $NS
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: $GOOD_SC
  resources:
    requests:
      storage: 128Mi
EOF

# WaitForFirstConsumer classes may keep a PVC Pending until a pod consumes it.
cat <<EOF | oc apply -f - | tee "$OUT/consumer-pod-apply.txt"
apiVersion: v1
kind: Pod
metadata:
  name: storage-consumer
  namespace: $NS
spec:
  restartPolicy: Never
  containers:
    - name: consumer
      image: registry.redhat.io/ubi9/ubi-minimal:latest
      command: ["/bin/sh","-c","sleep 300"]
      volumeMounts:
        - name: data
          mountPath: /data
      resources:
        requests:
          cpu: 5m
          memory: 16Mi
        limits:
          cpu: 50m
          memory: 64Mi
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: recovered-storage
EOF

deadline=$((SECONDS + 180))
while true; do
  phase="$(oc -n "$NS" get pvc recovered-storage -o jsonpath='{.status.phase}' 2>/dev/null || true)"
  if [ "$phase" = "Bound" ]; then break; fi
  if [ "$SECONDS" -ge "$deadline" ]; then
    oc -n "$NS" get pvc,pod -o wide | tee "$OUT/recovery-timeout-state.txt" || true
    oc -n "$NS" describe pvc recovered-storage | tee "$OUT/recovery-timeout-pvc.txt" || true
    echo "[FAIL] recovered PVC did not become Bound"
    exit 1
  fi
  sleep 5
done

oc -n "$NS" get pvc,pod -o wide | tee "$OUT/recovered-state.txt"
oc -n "$NS" describe pvc recovered-storage | tee "$OUT/recovered-pvc-describe.txt"

echo "D098_N3_STORAGE_RCA_RUNTIME_PROVEN=PASS" | tee "$OUT/result.txt"
echo "Evidence directory: $OUT"

cleanup
trap - EXIT
