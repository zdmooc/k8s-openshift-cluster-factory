#!/usr/bin/env bash
set -Eeuo pipefail

# D-098 SQY-4 — disposable pod/deployment ImagePullBackOff RCA.
# Uses an invalid image reference, captures the failure, then recovers by
# switching to a valid Red Hat UBI image.

[ "${CONFIRM_D098_POD_FIXTURE:-}" = "yes" ] || {
  echo "[STOP] Re-run with CONFIRM_D098_POD_FIXTURE=yes"
  exit 2
}

NS="d098-n3-pod"
DEPLOY="imagepull-fixture"
BAD_IMAGE="registry.redhat.io/ubi9/definitely-not-a-real-image:d098"
GOOD_IMAGE="${D098_RECOVERY_IMAGE:-registry.redhat.io/ubi9/ubi-minimal:latest}"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="evidence/out/d098-n3-pod-$STAMP"
mkdir -p "$OUT"

cleanup() {
  oc delete ns "$NS" --ignore-not-found --wait=false >/dev/null 2>&1 || true
}
trap cleanup EXIT

oc delete ns "$NS" --ignore-not-found --wait=true >/dev/null 2>&1 || true
oc create ns "$NS" | tee "$OUT/namespace.txt"

cat <<EOF | oc apply -f - | tee "$OUT/deployment-apply.txt"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $DEPLOY
  namespace: $NS
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $DEPLOY
  template:
    metadata:
      labels:
        app: $DEPLOY
    spec:
      containers:
      - name: app
        image: $BAD_IMAGE
        command: ["/bin/sh","-c","sleep 600"]
        resources:
          requests:
            cpu: 5m
            memory: 16Mi
          limits:
            cpu: 50m
            memory: 64Mi
        securityContext:
          runAsNonRoot: true
          allowPrivilegeEscalation: false
          capabilities:
            drop: ["ALL"]
          seccompProfile:
            type: RuntimeDefault
EOF

echo "===== POD/DEPLOYMENT — OBSERVE IMAGE PULL FAILURE ====="
FOUND=false
for attempt in $(seq 1 40); do
  POD="$(oc -n "$NS" get pods -l app="$DEPLOY" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
  if [ -n "$POD" ]; then
    REASON="$(oc -n "$NS" get pod "$POD" -o jsonpath='{.status.containerStatuses[0].state.waiting.reason}' 2>/dev/null || true)"
    if [ "$REASON" = "ImagePullBackOff" ] || [ "$REASON" = "ErrImagePull" ]; then
      FOUND=true
      break
    fi
  fi
  sleep 3
done

[ "$FOUND" = true ] || {
  oc -n "$NS" get pods -o wide | tee "$OUT/failure-not-observed.txt" || true
  echo "[FAIL] expected ImagePullBackOff/ErrImagePull was not observed"
  exit 1
}

oc -n "$NS" get pod "$POD" -o wide | tee "$OUT/broken-pod.txt"
oc -n "$NS" describe pod "$POD" | tee "$OUT/broken-pod-describe.txt"
echo "root_cause=invalid/nonexistent image reference: $BAD_IMAGE" | tee "$OUT/rca.txt"
echo "D098_POD_IMAGEPULL_FAILURE_OBSERVED=PASS"

echo "===== POD/DEPLOYMENT — RECOVER ====="
oc -n "$NS" set image "deployment/$DEPLOY" "app=$GOOD_IMAGE" | tee "$OUT/set-valid-image.txt"

if ! oc -n "$NS" rollout status "deployment/$DEPLOY" --timeout=240s | tee "$OUT/rollout-status.txt"; then
  oc -n "$NS" get pods -o wide | tee "$OUT/recovery-failed-pods.txt" || true
  oc -n "$NS" describe pods | tee "$OUT/recovery-failed-describe.txt" || true
  echo "[FAIL] deployment did not recover with $GOOD_IMAGE"
  exit 1
fi

RECOVERED_POD="$(oc -n "$NS" get pods -l app="$DEPLOY" -o jsonpath='{.items[0].metadata.name}')"
oc -n "$NS" get pod "$RECOVERED_POD" -o wide | tee "$OUT/recovered-pod.txt"

READY="$(oc -n "$NS" get pod "$RECOVERED_POD" -o jsonpath='{.status.containerStatuses[0].ready}')"
[ "$READY" = "true" ] || { echo "[FAIL] recovered pod not Ready"; exit 1; }

echo "D098_N3_POD_DEPLOYMENT_RCA_RUNTIME_PROVEN=PASS" | tee "$OUT/result.txt"
echo "Evidence directory: $OUT"

cleanup
trap - EXIT
