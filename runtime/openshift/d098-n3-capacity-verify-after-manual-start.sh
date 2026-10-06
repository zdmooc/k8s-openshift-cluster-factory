#!/usr/bin/env bash
set -Eeuo pipefail

# D-098 SQY-4 — verify capacity recovery after a MANUAL interactive 'crc start'.
# Windows/Git Bash note:
# keep 'crc start' outside this long-running script to avoid MSYS/Git-Bash
# process-buffer failures such as TP_NUM_C_BUFS.

for cmd in crc oc kubectl python; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "[FAIL] $cmd not found"; exit 1; }
done

EXPECTED_MB="${D098_CRC_MEMORY_MB:-24576}"
case "$EXPECTED_MB" in
  ''|*[!0-9]*) echo "[FAIL] D098_CRC_MEMORY_MB must be an integer MiB value"; exit 2 ;;
esac

echo "===== D098 N3 CAPACITY — VERIFY AFTER MANUAL START ====="

CONFIG_MB="$(crc config view 2>&1 | sed -nE 's/.*memory[^0-9]*([0-9]+).*/\1/p' | tail -1)"
echo "crc_config_memory_mb=${CONFIG_MB:-unknown}"
echo "expected_memory_mb=$EXPECTED_MB"

if [ -n "$CONFIG_MB" ] && [ "$CONFIG_MB" != "$EXPECTED_MB" ]; then
  echo "[FAIL] CRC memory is $CONFIG_MB MiB, expected $EXPECTED_MB MiB."
  echo "[FIX] Stop CRC, set memory, then run 'crc start' manually in a fresh terminal."
  exit 2
fi

STATUS="$(crc status 2>&1 || true)"
printf '%s\n' "$STATUS"
printf '%s\n' "$STATUS" | grep -Eq 'CRC VM:.*Running' || {
  echo "[FAIL] CRC VM is not Running. Run 'crc start' manually first."
  exit 2
}
printf '%s\n' "$STATUS" | grep -Eq 'OpenShift:.*Running' || {
  echo "[FAIL] OpenShift is not Running. Wait for 'crc start' to finish."
  exit 2
}

eval "$(crc oc-env)"

if kubectl config get-contexts -o name 2>/dev/null | grep -Fxq crc-admin; then
  kubectl config use-context crc-admin >/dev/null
else
  echo "[WARN] crc-admin context missing; recovering admin login without printing credentials."
  CRC_CREDS="$(crc console --credentials 2>&1 || true)"
  ADMIN_PASSWORD="$(printf '%s\n' "$CRC_CREDS" | awk '
    /Username:[[:space:]]*kubeadmin/ {seen=1; next}
    seen && /Password:/ {
      sub(/^.*Password:[[:space:]]*/, "", $0)
      print
      exit
    }
  ')"
  if [ -z "$ADMIN_PASSWORD" ]; then
    ADMIN_PASSWORD="$(printf '%s\n' "$CRC_CREDS" | sed -nE 's/.*-u[[:space:]]+kubeadmin[[:space:]]+-p[[:space:]]+([^[:space:]]+).*/\1/p' | head -1)"
  fi
  [ -n "$ADMIN_PASSWORD" ] || { echo "[FAIL] unable to recover kubeadmin credential"; exit 1; }

  LOGIN_OK=false
  for attempt in $(seq 1 18); do
    if oc login -u kubeadmin -p "$ADMIN_PASSWORD" https://api.crc.testing:6443 >/dev/null 2>&1; then
      LOGIN_OK=true
      break
    fi
    echo "[INFO] waiting for API/OAuth login ($attempt/18)"
    sleep 10
  done
  unset ADMIN_PASSWORD CRC_CREDS
  [ "$LOGIN_OK" = true ] || { echo "[FAIL] admin login failed"; exit 1; }
fi

oc wait --for=condition=Ready nodes --all --timeout=600s

deadline=$((SECONDS + 600))
while true; do
  unhealthy="$(oc get clusteroperators --no-headers | awk '$3!="True" || $4!="False" || $5!="False" {print}')"
  if [ -z "$unhealthy" ]; then
    break
  fi
  if [ "$SECONDS" -ge "$deadline" ]; then
    echo "$unhealthy"
    echo "[FAIL] ClusterOperators did not converge within 600s"
    exit 1
  fi
  sleep 10
done

# Give non-core workloads time to schedule after the platform is stable.
sleep 60

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="evidence/out/d098-n3-capacity-verify-$STAMP"
mkdir -p "$OUT"
umask 077

echo "===== D098 N3 CAPACITY — AFTER ====="
crc status | tee "$OUT/crc-status-after.txt"
oc get clusterversion | tee "$OUT/clusterversion-after.txt"
oc get clusteroperators | tee "$OUT/clusteroperators-after.txt"
oc get nodes -o wide | tee "$OUT/nodes-after.txt"
oc get pods -A --field-selector=status.phase=Pending -o wide | tee "$OUT/pending-after.txt" || true

for target in   "openshift-gitops deployment/openshift-gitops-server"   "shared-platform-services deployment/mayabank-platform-operator"   "shared-observability deployment/otel-collector"; do
  ns="${target%% *}"
  obj="${target#* }"
  echo "--- $ns $obj"
  oc -n "$ns" get "$obj" -o wide 2>&1 || true
done | tee "$OUT/mission-platform-after.txt"

oc get pods -A -o json | python -c '
import json,sys,re
d=json.load(sys.stdin)
units={"Ki":1/1024,"Mi":1,"Gi":1024,"Ti":1024*1024}
def mem_mi(v):
    if not v: return 0.0
    m=re.fullmatch(r"([0-9.]+)(Ki|Mi|Gi|Ti)?",v)
    if not m: return 0.0
    return float(m.group(1))*units.get(m.group(2) or "Mi",1)
scheduled=pending=0.0
scheduled_pods=pending_pods=0
for p in d["items"]:
    total=sum(mem_mi(c.get("resources",{}).get("requests",{}).get("memory")) for c in p["spec"].get("containers",[]))
    if p["spec"].get("nodeName"):
        scheduled+=total; scheduled_pods+=1
    else:
        pending+=total; pending_pods+=1
print(f"scheduled_pods={scheduled_pods} scheduled_memory_requests_mi={scheduled:.1f}")
print(f"unscheduled_pods={pending_pods} unscheduled_memory_requests_mi={pending:.1f}")
' | tee "$OUT/request-summary-after.txt"

oc get events -A --sort-by=.lastTimestamp   | grep -E 'FailedScheduling|Insufficient memory|ImagePullBackOff'   | tail -120 | tee "$OUT/relevant-events-after.txt" || true

echo "D098_N3_CAPACITY_RECOVERY_VERIFY=PASS" | tee "$OUT/result.txt"
echo "Evidence directory: $OUT"
echo "CRC remains active for the next SQY runtime scenarios."
