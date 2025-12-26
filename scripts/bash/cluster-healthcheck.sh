#!/usr/bin/env bash
set -euo pipefail

echo "== Nodes"
kubectl get nodes -o wide

echo
echo "== Non-running pods (top 50)"
kubectl get pods -A --field-selector=status.phase!=Running,status.phase!=Succeeded | head -n 50 || true

echo
echo "== API readiness"
kubectl get --raw='/readyz?verbose' | head -n 50 || true

echo
echo "== ResourceQuotas (all)"
kubectl get resourcequota -A || true

echo
echo "== NetworkPolicies count"
kubectl get networkpolicy -A | wc -l || true
