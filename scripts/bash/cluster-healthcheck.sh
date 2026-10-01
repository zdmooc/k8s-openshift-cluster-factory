#!/usr/bin/env bash
set -euo pipefail

echo "== Context"
kubectl config current-context

echo
echo "== API readiness"
kubectl get --raw='/readyz?verbose' >/tmp/factory-readyz.txt
cat /tmp/factory-readyz.txt
grep -q 'readyz check passed' /tmp/factory-readyz.txt

echo
echo "== Nodes"
kubectl get nodes -o wide
not_ready="$(kubectl get nodes --no-headers | awk '$2 !~ /^Ready/ {print $1}')"
if [[ -n "${not_ready}" ]]; then
  echo "ERROR: non-ready nodes:"
  echo "${not_ready}"
  exit 1
fi

echo
echo "== Failed/pending pods"
bad_pods="$(kubectl get pods -A --no-headers 2>/dev/null | awk '$4 ~ /Pending|Failed|Unknown/ {print}')"
if [[ -n "${bad_pods}" ]]; then
  echo "${bad_pods}"
  exit 1
fi

echo
echo "== ResourceQuotas"
kubectl get resourcequota -A || true

echo
echo "== NetworkPolicies"
kubectl get networkpolicy -A || true

echo
echo "== Recent warning events"
kubectl get events -A --field-selector type=Warning --sort-by=.lastTimestamp | tail -n 30 || true

echo "CLUSTER_HEALTHCHECK=PASS"
