#!/usr/bin/env bash
set -Eeuo pipefail

# D-098 SQY-5 — read-only observability evidence.
# Queries OpenShift monitoring and Loki without changing alerting/logging configuration.

for cmd in oc curl python; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "[FAIL] $cmd not found"; exit 1; }
done

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="evidence/out/d098-observability-$STAMP"
mkdir -p "$OUT"

echo "===== MONITORING PODS ====="
oc -n openshift-monitoring get pods -o wide | tee "$OUT/openshift-monitoring-pods.txt"
oc -n instant-payments-local get pods -o wide   | grep -E 'prometheus|grafana|loki|alloy'   | tee "$OUT/product-observability-pods.txt" || true

echo "===== ALERTMANAGER / PROMETHEUS OBJECTS ====="
oc -n openshift-monitoring get sts,svc,route 2>/dev/null   | grep -E 'alertmanager|prometheus|thanos'   | tee "$OUT/monitoring-objects.txt" || true

oc get prometheusrule -A -o name | tee "$OUT/prometheus-rules.txt" || true

echo "===== PROMETHEUS ALERT API ====="
TOKEN="$(oc whoami -t)"
PROM_HOST="$(oc -n openshift-monitoring get route prometheus-k8s -o jsonpath='{.spec.host}' 2>/dev/null || true)"
THANOS_HOST="$(oc -n openshift-monitoring get route thanos-querier -o jsonpath='{.spec.host}' 2>/dev/null || true)"

ALERT_QUERY_OK=false
if [ -n "$PROM_HOST" ]; then
  if curl -kfsS -H "Authorization: Bearer $TOKEN" "https://$PROM_HOST/api/v1/alerts"       > "$OUT/prometheus-alerts.json"; then
    ALERT_QUERY_OK=true
    echo "prometheus_alert_api=PASS host=$PROM_HOST"
  fi
fi

if [ "$ALERT_QUERY_OK" != true ] && [ -n "$THANOS_HOST" ]; then
  if curl -kfsS -H "Authorization: Bearer $TOKEN" "https://$THANOS_HOST/api/v1/rules?type=alert"       > "$OUT/thanos-alert-rules.json"; then
    ALERT_QUERY_OK=true
    echo "thanos_alert_api=PASS host=$THANOS_HOST"
  fi
fi

if [ "$ALERT_QUERY_OK" = true ]; then
  python - "$OUT" <<'PY'
import json,sys,pathlib
out=pathlib.Path(sys.argv[1])
files=[out/"prometheus-alerts.json",out/"thanos-alert-rules.json"]
for f in files:
    if not f.exists():
        continue
    try:
        d=json.loads(f.read_text())
    except Exception:
        continue
    print(f"alert_api_file={f.name} status={d.get('status')}")
PY
else
  echo "[WARN] direct alert API query not available through discovered routes"
fi
unset TOKEN

echo "===== LOKI SEARCHABILITY ====="
LOKI_SVC="$(oc -n instant-payments-local get svc -o jsonpath='{range .items[*]}{.metadata.name}{" "}{range .spec.ports[*]}{.port}{" "}{end}{"\n"}{end}'   | awk '$1 ~ /loki/ {print $1; exit}')"

if [ -z "$LOKI_SVC" ]; then
  echo "[FAIL] no Loki service discovered in instant-payments-local"
  exit 1
fi

echo "loki_service=$LOKI_SVC"
LOCAL_PORT=13100
PF_LOG="$OUT/loki-port-forward.log"
oc -n instant-payments-local port-forward "svc/$LOKI_SVC" "$LOCAL_PORT:3100" >"$PF_LOG" 2>&1 &
PF_PID=$!

cleanup_pf() {
  kill "$PF_PID" >/dev/null 2>&1 || true
  wait "$PF_PID" >/dev/null 2>&1 || true
}
trap cleanup_pf EXIT

READY=false
for attempt in $(seq 1 30); do
  if curl -fsS "http://127.0.0.1:$LOCAL_PORT/ready" >"$OUT/loki-ready.txt" 2>/dev/null; then
    READY=true
    break
  fi
  sleep 1
done
[ "$READY" = true ] || {
  cat "$PF_LOG" || true
  echo "[FAIL] Loki port-forward/readiness failed"
  exit 1
}
echo "D098_LOKI_READY=PASS"

curl -fsS "http://127.0.0.1:$LOCAL_PORT/loki/api/v1/labels" > "$OUT/loki-labels.json"

FOUND=false
for selector in   '{namespace="instant-payments-local"}'   '{namespace_name="instant-payments-local"}'   '{k8s_namespace_name="instant-payments-local"}'; do
  curl -fsSG "http://127.0.0.1:$LOCAL_PORT/loki/api/v1/query_range"     --data-urlencode "query=$selector"     --data-urlencode "limit=20"     > "$OUT/loki-query.json" || true

  if python - "$OUT/loki-query.json" <<'PY'
import json,sys
try:
    d=json.load(open(sys.argv[1]))
    ok=d.get("status")=="success" and bool(d.get("data",{}).get("result"))
except Exception:
    ok=False
raise SystemExit(0 if ok else 1)
PY
  then
    echo "loki_selector=$selector" | tee "$OUT/loki-selector.txt"
    FOUND=true
    break
  fi
done

[ "$FOUND" = true ] || {
  echo "[FAIL] Loki is Ready but no namespace log stream was found with expected label conventions"
  exit 1
}

python - "$OUT/loki-query.json" <<'PY' | tee "$OUT/loki-query-summary.txt"
import json,sys
d=json.load(open(sys.argv[1]))
r=d["data"]["result"]
print(f"streams={len(r)}")
for item in r[:5]:
    print("stream_labels="+json.dumps(item.get("stream",{}),sort_keys=True))
    vals=item.get("values",[])
    print(f"sample_entries={len(vals)}")
PY

echo "D098_LOKI_QUERY_RUNTIME_PROVEN=PASS"

echo "===== CURRENT OIDC / OTEL COMPONENTS ====="
oc -n keycloak-system get pods -o wide | tee "$OUT/keycloak-pods.txt"
oc -n shared-observability get deploy,pods,svc -o wide | tee "$OUT/shared-otel.txt"

echo "D098_OBSERVABILITY_RUNTIME_EVIDENCE=PASS" | tee "$OUT/result.txt"
echo "Evidence directory: $OUT"

cleanup_pf
trap - EXIT
