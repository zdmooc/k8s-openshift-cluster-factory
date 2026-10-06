#!/usr/bin/env bash
set -Eeuo pipefail

# D-098 SQY-4 — real N3 capacity recovery.
# Scenario: CRC restarted at 16 GiB -> many FailedScheduling/Insufficient memory.
# Recovery: increase CRC VM memory, restart CRC, verify mission-critical platform slices.
#
# This script changes only the local CRC VM memory configuration and restarts CRC.
# It does not delete Kind, namespaces, PVCs or workloads.

[ "${CONFIRM_D098_CAPACITY_RECOVERY:-}" = "yes" ] || {
  echo "[STOP] Re-run with CONFIRM_D098_CAPACITY_RECOVERY=yes"
  exit 2
}

TARGET_MB="${D098_CRC_MEMORY_MB:-24576}"
case "$TARGET_MB" in
  ''|*[!0-9]*) echo "[FAIL] D098_CRC_MEMORY_MB must be an integer MiB value"; exit 2 ;;
esac

if [ "$TARGET_MB" -lt 16384 ] || [ "$TARGET_MB" -gt 28672 ]; then
  echo "[FAIL] target memory must stay between 16384 and 28672 MiB for this workstation safety envelope"
  exit 2
fi

for cmd in crc oc kubectl python; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "[FAIL] $cmd not found"; exit 1; }
done

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="evidence/out/d098-n3-capacity-$STAMP"
mkdir -p "$OUT"
umask 077

PREVIOUS_MB="$(crc config view 2>&1 | sed -nE 's/.*memory[^0-9]*([0-9]+).*/\1/p' | tail -1)"
[ -n "$PREVIOUS_MB" ] || PREVIOUS_MB=16384

echo "===== D098 N3 CAPACITY — BEFORE ====="
echo "previous_crc_memory_mb=$PREVIOUS_MB" | tee "$OUT/config-before.txt"
crc status | tee "$OUT/crc-status-before.txt"

# Ensure we are really on CRC/OpenShift before capturing the incident.
oc whoami | tee "$OUT/whoami-before.txt"
oc whoami --show-server | tee "$OUT/server-before.txt"
oc get clusterversion | tee "$OUT/clusterversion-before.txt"
oc get nodes -o wide | tee "$OUT/nodes-before.txt"
oc get pods -A --field-selector=status.phase=Pending -o wide | tee "$OUT/pending-before.txt" || true
oc get events -A --sort-by=.lastTimestamp | grep -E 'FailedScheduling|Insufficient memory|ImagePullBackOff' | tail -120   | tee "$OUT/relevant-events-before.txt" || true

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
' | tee "$OUT/request-summary-before.txt"

echo "===== D098 N3 CAPACITY — RESTART CRC AT ${TARGET_MB} MiB ====="
crc stop | tee "$OUT/crc-stop.txt"
crc config set memory "$TARGET_MB" | tee "$OUT/crc-config-set.txt"

START_LOG="$OUT/crc-start-private.log"
if ! crc start >"$START_LOG" 2>&1; then
  echo "[FAIL] CRC failed to start at ${TARGET_MB} MiB."
  echo "[RECOVERY] restoring previous CRC memory configuration: ${PREVIOUS_MB} MiB"
  crc config set memory "$PREVIOUS_MB" >/dev/null 2>&1 || true
  crc start >/dev/null 2>&1 || true
  exit 1
fi

eval "$(crc oc-env)"

if kubectl config get-contexts -o name 2>/dev/null | grep -Fxq crc-admin; then
  kubectl config use-context crc-admin >/dev/null
else
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
  [ -n "$ADMIN_PASSWORD" ] || { echo "[FAIL] unable to recover kubeadmin login"; exit 1; }

  LOGIN_OK=false
  for attempt in $(seq 1 18); do
    if oc login -u kubeadmin -p "$ADMIN_PASSWORD" https://api.crc.testing:6443 >/dev/null 2>&1; then
      LOGIN_OK=true
      break
    fi
    sleep 10
  done
  unset ADMIN_PASSWORD CRC_CREDS
  [ "$LOGIN_OK" = true ] || { echo "[FAIL] CRC started but admin login failed"; exit 1; }
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

# Allow product/platform Deployments a short window to reschedule.
sleep 60

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

echo "D098_N3_CAPACITY_RECOVERY_EXECUTED=PASS" | tee "$OUT/result.txt"
echo "Evidence directory: $OUT"
echo "CRC remains active for the next SQY runtime scenarios."
