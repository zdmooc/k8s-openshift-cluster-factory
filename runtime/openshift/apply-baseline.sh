#!/usr/bin/env bash
set -euo pipefail

command -v oc >/dev/null 2>&1 || { echo "oc not found"; exit 1; }

oc kustomize kubernetes/baseline >/tmp/cluster-factory-baseline.yaml
test -s /tmp/cluster-factory-baseline.yaml
oc apply -f /tmp/cluster-factory-baseline.yaml

oc get namespace platform-system
oc -n platform-system get resourcequota platform-quota
oc -n platform-system get limitrange platform-default-limits
oc -n platform-system get networkpolicy default-deny-all
oc get clusterrole platform-readonly

echo "OPENSHIFT_BASELINE_APPLIED=PASS"
