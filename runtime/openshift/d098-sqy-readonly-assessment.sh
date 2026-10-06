#!/usr/bin/env bash
set -euo pipefail

# D-098 read-only assessment. It does not mutate the cluster.
# Run only after explicitly switching to the intended CRC/OpenShift context.

echo "===== CONTEXT ====="
oc whoami
oc whoami --show-server
oc version

echo "===== CLUSTER VERSION ====="
oc get clusterversion
oc get clusteroperators

echo "===== NODES ====="
oc get nodes -o wide

echo "===== PROJECTS ====="
oc get projects

echo "===== ROUTES ====="
oc get routes -A || true

echo "===== SCC ====="
oc get scc

echo "===== OLM ====="
oc get subscriptions.operators.coreos.com -A || true
oc get csv -A || true
oc get installplans.operators.coreos.com -A || true

echo "===== STORAGE ====="
oc get storageclass
oc get pvc -A

echo "===== NETWORKPOLICIES ====="
oc get networkpolicy -A

echo "===== ARGO / OPENSHIFT GITOPS ====="
oc get applications.argoproj.io -A 2>/dev/null || true
oc get argocd.argoproj.io -A 2>/dev/null || true

echo "===== PLATFORM OPERATOR ====="
oc get capabilityconsumptions.platform.mayabank.example -A 2>/dev/null || true

echo "===== EVENTS (LATEST) ====="
oc get events -A --sort-by=.lastTimestamp | tail -80 || true

echo "D098_READONLY_ASSESSMENT=PASS"
