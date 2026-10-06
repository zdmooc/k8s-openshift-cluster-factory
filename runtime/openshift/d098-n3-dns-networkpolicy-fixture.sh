#!/usr/bin/env bash
set -Eeuo pipefail

# D-098 SQY-4 — disposable DNS / NetworkPolicy RCA proof.

[ "${CONFIRM_D098_DNS_FIXTURE:-}" = "yes" ] || {
  echo "[STOP] Re-run with CONFIRM_D098_DNS_FIXTURE=yes"
  exit 2
}

NS="d098-n3-dns"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="evidence/out/d098-n3-dns-$STAMP"
mkdir -p "$OUT"

cleanup() {
  oc delete ns "$NS" --ignore-not-found --wait=false >/dev/null 2>&1 || true
}
trap cleanup EXIT

oc delete ns "$NS" --ignore-not-found --wait=true >/dev/null 2>&1 || true
oc create ns "$NS" | tee "$OUT/namespace.txt"

cat <<EOF | oc apply -f - | tee "$OUT/pod-apply.txt"
apiVersion: v1
kind: Pod
metadata:
  name: dns-client
  namespace: $NS
  labels:
    app: dns-client
spec:
  restartPolicy: Never
  containers:
  - name: client
    image: registry.redhat.io/ubi9/ubi:latest
    command: ["/bin/sh","-c","sleep 600"]
    resources:
      requests:
        cpu: 5m
        memory: 16Mi
      limits:
        cpu: 50m
        memory: 96Mi
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
EOF

if ! oc -n "$NS" wait --for=condition=Ready pod/dns-client --timeout=180s; then
  oc -n "$NS" get pod dns-client -o wide | tee "$OUT/pod-not-ready.txt" || true
  oc -n "$NS" describe pod dns-client | tee "$OUT/pod-not-ready-describe.txt" || true
  echo "[FAIL] DNS fixture pod did not become Ready"
  exit 1
fi

echo "===== DNS BASELINE ====="
BASE="$(oc -n "$NS" exec dns-client -- getent hosts kubernetes.default.svc.cluster.local 2>&1 || true)"
printf '%s\n' "$BASE" | tee "$OUT/dns-baseline.txt"
[ -n "$BASE" ] || { echo "[FAIL] baseline DNS resolution failed"; exit 1; }
echo "D098_DNS_BASELINE=PASS"

echo "===== INJECT DEFAULT-DENY EGRESS ====="
cat <<EOF | oc apply -f - | tee "$OUT/deny-policy.txt"
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-egress
  namespace: $NS
spec:
  podSelector:
    matchLabels:
      app: dns-client
  policyTypes:
  - Egress
  egress: []
EOF

sleep 3
set +e
oc -n "$NS" exec dns-client -- getent hosts kubernetes.default.svc.cluster.local   >"$OUT/dns-denied-stdout.txt" 2>"$OUT/dns-denied-stderr.txt"
DENY_RC=$?
set -e

if [ "$DENY_RC" -eq 0 ]; then
  echo "[FAIL] DNS unexpectedly succeeded under deny-all egress"
  cat "$OUT/dns-denied-stdout.txt"
  exit 1
fi
echo "D098_DNS_DENIED_BY_NETWORKPOLICY=PASS"

echo "===== RECOVER DNS EGRESS ====="
cat <<EOF | oc apply -f - | tee "$OUT/allow-dns-policy.txt"
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-egress
  namespace: $NS
spec:
  podSelector:
    matchLabels:
      app: dns-client
  policyTypes:
  - Egress
  egress:
  - ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
EOF

RECOVERED=false
for attempt in $(seq 1 12); do
  if oc -n "$NS" exec dns-client -- getent hosts kubernetes.default.svc.cluster.local       >"$OUT/dns-recovered.txt" 2>&1; then
    RECOVERED=true
    break
  fi
  sleep 2
done

cat "$OUT/dns-recovered.txt" || true
[ "$RECOVERED" = true ] || { echo "[FAIL] DNS did not recover after explicit port-53 egress"; exit 1; }

echo "D098_DNS_RECOVERED=PASS"
oc -n "$NS" get networkpolicy -o yaml | tee "$OUT/networkpolicies.yaml" >/dev/null

echo "D098_N3_DNS_NETWORKPOLICY_RUNTIME_PROVEN=PASS" | tee "$OUT/result.txt"
echo "Evidence directory: $OUT"

cleanup
trap - EXIT
