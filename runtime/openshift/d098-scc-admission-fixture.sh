#!/usr/bin/env bash
set -Eeuo pipefail

# D-098 SQY-5 — OpenShift native admission/SCC positive + negative proof.
# Uses server-side dry-run for pods; only temporary RBAC/namespace objects are persisted.

[ "${CONFIRM_D098_SCC_FIXTURE:-}" = "yes" ] || {
  echo "[STOP] Re-run with CONFIRM_D098_SCC_FIXTURE=yes"
  exit 2
}

NS="d098-scc-admission"
SA="tester"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="evidence/out/d098-scc-admission-$STAMP"
mkdir -p "$OUT"

cleanup() {
  oc delete ns "$NS" --ignore-not-found --wait=false >/dev/null 2>&1 || true
}
trap cleanup EXIT

oc delete ns "$NS" --ignore-not-found --wait=true >/dev/null 2>&1 || true
oc create ns "$NS" | tee "$OUT/namespace.txt"
oc -n "$NS" create serviceaccount "$SA" | tee "$OUT/serviceaccount.txt"

cat <<EOF | oc apply -f - | tee "$OUT/rbac.txt"
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-creator
  namespace: $NS
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["create","get","list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-creator
  namespace: $NS
subjects:
- kind: ServiceAccount
  name: $SA
  namespace: $NS
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pod-creator
EOF

USER="system:serviceaccount:$NS:$SA"

echo "===== SCC POSITIVE CASE ====="
cat > "$OUT/normal-pod.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: compliant
  namespace: $NS
spec:
  serviceAccountName: $SA
  restartPolicy: Never
  containers:
  - name: app
    image: registry.redhat.io/ubi9/ubi-minimal:latest
    command: ["/bin/sh","-c","sleep 60"]
    resources:
      requests:
        cpu: 5m
        memory: 16Mi
      limits:
        cpu: 50m
        memory: 64Mi
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
      seccompProfile:
        type: RuntimeDefault
EOF

oc --as="$USER" create --dry-run=server -f "$OUT/normal-pod.yaml" -o yaml   | tee "$OUT/normal-admission.yaml" >/dev/null

echo "D098_SCC_COMPLIANT_ADMISSION=PASS"

echo "===== SCC NEGATIVE CASE ====="
cat > "$OUT/privileged-pod.yaml" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: privileged
  namespace: $NS
spec:
  serviceAccountName: $SA
  restartPolicy: Never
  containers:
  - name: app
    image: registry.redhat.io/ubi9/ubi-minimal:latest
    command: ["/bin/sh","-c","sleep 60"]
    securityContext:
      privileged: true
EOF

set +e
oc --as="$USER" create --dry-run=server -f "$OUT/privileged-pod.yaml"   >"$OUT/privileged-stdout.txt" 2>"$OUT/privileged-stderr.txt"
RC=$?
set -e

cat "$OUT/privileged-stderr.txt"

if [ "$RC" -eq 0 ]; then
  echo "[FAIL] privileged pod was unexpectedly admitted"
  exit 1
fi

if ! grep -Eqi 'security context constraint|privileged|forbidden|unable to validate' "$OUT/privileged-stderr.txt"; then
  echo "[FAIL] privileged pod was rejected, but SCC/security cause was not explicit"
  exit 1
fi

echo "D098_SCC_PRIVILEGED_DENIED=PASS"

echo "===== SCC CATALOG ====="
oc get scc restricted-v2 restricted-v3 -o wide | tee "$OUT/scc-catalog.txt" || true

echo "D098_SCC_ADMISSION_RUNTIME_PROVEN=PASS" | tee "$OUT/result.txt"
echo "Evidence directory: $OUT"

cleanup
trap - EXIT
