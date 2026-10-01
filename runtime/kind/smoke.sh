#!/usr/bin/env bash
set -euo pipefail

PROFILE="${1:-catalog/profiles/k8s-ci-multinode.yaml}"

expected_cp="$(python3 -c 'import sys,yaml; print(yaml.safe_load(open(sys.argv[1]))["spec"]["topology"]["controlPlane"])' "${PROFILE}")"
expected_workers="$(python3 -c 'import sys,yaml; print(yaml.safe_load(open(sys.argv[1]))["spec"]["topology"]["workers"])' "${PROFILE}")"
expected_total="$((expected_cp + expected_workers))"

actual_total="$(kubectl get nodes --no-headers | wc -l | tr -d ' ')"
actual_cp="$(kubectl get nodes -l node-role.kubernetes.io/control-plane --no-headers | wc -l | tr -d ' ')"
actual_workers="$((actual_total - actual_cp))"

test "${actual_total}" -eq "${expected_total}"
test "${actual_cp}" -eq "${expected_cp}"
test "${actual_workers}" -eq "${expected_workers}"

kubectl wait --for=condition=Ready node --all --timeout=120s

kubectl -n platform-system create deployment factory-smoke --image=registry.k8s.io/pause:3.10
kubectl -n platform-system rollout status deployment/factory-smoke --timeout=120s
kubectl -n platform-system get pod -l app=factory-smoke -o wide
kubectl -n platform-system delete deployment factory-smoke --wait=true

echo "FACTORY_EXPECTED_CONTROL_PLANES=${expected_cp}"
echo "FACTORY_EXPECTED_WORKERS=${expected_workers}"
echo "FACTORY_ACTUAL_NODES=${actual_total}"
echo "FACTORY_SMOKE=PASS"
