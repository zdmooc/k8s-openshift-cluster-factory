#!/usr/bin/env bash
set -euo pipefail

NODE="${1:-}"
if [[ -z "${NODE}" ]]; then
  echo "Usage: $0 <node>"
  exit 1
fi

echo "== cordon ${NODE}"
kubectl cordon "${NODE}"

echo "== drain ${NODE}"
kubectl drain "${NODE}" --ignore-daemonsets --delete-emptydir-data --grace-period=60 --timeout=15m

echo "OK: drained."
