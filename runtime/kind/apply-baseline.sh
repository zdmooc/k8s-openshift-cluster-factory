#!/usr/bin/env bash
set -euo pipefail

kubectl kustomize kubernetes/baseline >/tmp/factory-baseline.yaml
test -s /tmp/factory-baseline.yaml
kubectl apply -f /tmp/factory-baseline.yaml

kubectl get namespace platform-system
kubectl -n platform-system get resourcequota platform-quota
kubectl -n platform-system get limitrange platform-default-limits
kubectl -n platform-system get networkpolicy default-deny-all
kubectl get clusterrole platform-readonly
kubectl get clusterrolebinding platform-readonly-binding

echo "FACTORY_BASELINE_APPLIED=PASS"
