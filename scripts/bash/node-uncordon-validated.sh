#!/usr/bin/env bash
set -euo pipefail

NODE="${1:-}"
if [[ -z "${NODE}" ]]; then
  echo "Usage: CONFIRM_UNCORDON=YES $0 <node>"
  exit 1
fi

kubectl get node "${NODE}" -o wide
ready="$(kubectl get node "${NODE}" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')"
if [[ "${ready}" != "True" ]]; then
  echo "ERROR: node is not Ready; refusing uncordon."
  exit 1
fi

if [[ "${CONFIRM_UNCORDON:-NO}" != "YES" ]]; then
  echo "Set CONFIRM_UNCORDON=YES after maintenance validation."
  exit 2
fi

kubectl uncordon "${NODE}"
kubectl get node "${NODE}" -o wide
echo "NODE_UNCORDON=PASS"
