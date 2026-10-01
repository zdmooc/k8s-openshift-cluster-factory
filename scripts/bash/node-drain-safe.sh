#!/usr/bin/env bash
set -euo pipefail

NODE="${1:-}"
if [[ -z "${NODE}" ]]; then
  echo "Usage: CONFIRM_DRAIN=YES $0 <node>"
  exit 1
fi

kubectl get node "${NODE}" >/dev/null
kubectl get node "${NODE}" -o wide

ready="$(kubectl get node "${NODE}" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')"
if [[ "${ready}" != "True" ]]; then
  echo "ERROR: node ${NODE} is not Ready before maintenance."
  exit 1
fi

echo "== PodDisruptionBudgets"
kubectl get pdb -A || true

drain_args=(--ignore-daemonsets --grace-period=60 --timeout=15m)
if [[ "${ALLOW_EMPTYDIR:-NO}" == "YES" ]]; then
  drain_args+=(--delete-emptydir-data)
fi

echo "== Drain preflight"
kubectl drain "${NODE}" "${drain_args[@]}" --dry-run=client

if [[ "${CONFIRM_DRAIN:-NO}" != "YES" ]]; then
  echo "DRY-RUN ONLY. Set CONFIRM_DRAIN=YES to cordon and drain."
  exit 0
fi

echo "== Cordon ${NODE}"
kubectl cordon "${NODE}"

echo "== Drain ${NODE}"
if ! kubectl drain "${NODE}" "${drain_args[@]}"; then
  echo "ERROR: drain failed; node remains cordoned for investigation."
  exit 1
fi

echo "NODE_DRAIN=PASS"
echo "Node remains cordoned. Uncordon only after maintenance validation."
