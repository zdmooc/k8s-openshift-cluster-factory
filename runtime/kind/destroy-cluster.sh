#!/usr/bin/env bash
set -euo pipefail
CLUSTER_NAME="${CLUSTER_NAME:-factory-ci}"
kind delete cluster --name "${CLUSTER_NAME}"
echo "FACTORY_CLUSTER_RETIRED=PASS"
