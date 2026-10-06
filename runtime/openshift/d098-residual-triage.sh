#!/usr/bin/env bash
set -Eeuo pipefail

# D-098 read-only triage of residual CRC issues after capacity recovery.

for cmd in oc kubectl crc; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "[FAIL] $cmd not found"; exit 1; }
done

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="evidence/out/d098-residual-triage-$STAMP"
mkdir -p "$OUT"

echo "===== CRC HEALTH ====="
crc status | tee "$OUT/crc-status.txt"
oc get clusterversion | tee "$OUT/clusterversion.txt"
oc get clusteroperators | tee "$OUT/clusteroperators.txt"
oc get nodes -o wide | tee "$OUT/nodes.txt"

echo "===== CURRENT NON-RUNNING PODS ====="
oc get pods -A --field-selector=status.phase=Pending -o wide | tee "$OUT/pending.txt" || true
oc get pods -A | grep -E 'ImagePullBackOff|ErrImagePull|CrashLoopBackOff|Pending' | tee "$OUT/non-running-summary.txt" || true

echo "===== REDPANDA CONSOLE IMAGEPULLBACKOFF ====="
RP_POD="$(oc -n instant-payments-local get pods -l app=redpanda-console -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
if [ -z "$RP_POD" ]; then
  RP_POD="$(oc -n instant-payments-local get pods -o name 2>/dev/null | grep redpanda-console | head -1 | cut -d/ -f2 || true)"
fi

if [ -n "$RP_POD" ]; then
  echo "pod=$RP_POD" | tee "$OUT/redpanda-pod-name.txt"
  oc -n instant-payments-local get pod "$RP_POD" -o wide | tee "$OUT/redpanda-pod.txt"
  oc -n instant-payments-local get pod "$RP_POD" -o jsonpath='{range .spec.containers[*]}{.name}{" image="}{.image}{" imagePullPolicy="}{.imagePullPolicy}{"\n"}{end}'     | tee "$OUT/redpanda-image.txt"
  oc -n instant-payments-local describe pod "$RP_POD" | tee "$OUT/redpanda-describe.txt"
  oc -n instant-payments-local get sa default -o yaml | sed '/token:/d' | tee "$OUT/redpanda-default-sa.txt"
else
  echo "[INFO] no Redpanda Console pod found" | tee "$OUT/redpanda-not-found.txt"
fi

echo "===== MQ PENDING ====="
MQ_POD="$(oc -n mayabank-mq-local get pods -l app=mq -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
if [ -z "$MQ_POD" ]; then
  MQ_POD="$(oc -n mayabank-mq-local get pods -o name 2>/dev/null | grep '/mq-' | head -1 | cut -d/ -f2 || true)"
fi

if [ -n "$MQ_POD" ]; then
  echo "pod=$MQ_POD" | tee "$OUT/mq-pod-name.txt"
  oc -n mayabank-mq-local get pod "$MQ_POD" -o wide | tee "$OUT/mq-pod.txt"
  oc -n mayabank-mq-local get pod "$MQ_POD" -o jsonpath='{range .spec.containers[*]}{.name}{" requests="}{.resources.requests}{" limits="}{.resources.limits}{"\n"}{end}'     | tee "$OUT/mq-resources.txt"
  oc -n mayabank-mq-local describe pod "$MQ_POD" | tee "$OUT/mq-describe.txt"
fi

echo "===== NODE ALLOCATION ====="
oc describe node crc | sed -n '/Allocated resources:/,/Events:/p' | tee "$OUT/node-allocation.txt" || true

echo "===== RELEVANT RECENT EVENTS ====="
oc get events -A --sort-by=.lastTimestamp   | grep -E 'ImagePullBackOff|ErrImagePull|FailedScheduling|Insufficient memory'   | tail -120 | tee "$OUT/relevant-events.txt" || true

echo "D098_RESIDUAL_TRIAGE=PASS" | tee "$OUT/result.txt"
echo "Evidence directory: $OUT"
