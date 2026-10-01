#!/usr/bin/env bash
set -euo pipefail

PROFILE="${1:-catalog/profiles/k8s-ci-multinode.yaml}"
CLUSTER_NAME="${CLUSTER_NAME:-factory-ci}"
TMP_CONFIG="${TMPDIR:-/tmp}/${CLUSTER_NAME}-kind.yaml"

command -v kind >/dev/null 2>&1 || { echo "kind not found"; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "python3 not found"; exit 1; }

python3 scripts/python/render_kind_config.py "${PROFILE}" > "${TMP_CONFIG}"

echo "== Creating Kind cluster ${CLUSTER_NAME}"
kind create cluster --name "${CLUSTER_NAME}" --config "${TMP_CONFIG}" --wait 180s

echo "== Waiting for nodes"
kubectl wait --for=condition=Ready node --all --timeout=180s
kubectl get nodes -o wide

echo "FACTORY_CLUSTER_CREATED=PASS"
