#!/usr/bin/env bash
set -euo pipefail

# D-098 OpenShift upgrade-readiness assessment.
# Read-only: does not approve, trigger or apply an upgrade.

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="${1:-evidence/out/d098-upgrade-readiness-$STAMP}"
mkdir -p "$OUT"

capture() {
  local name="$1"; shift
  echo "===== $name ====="
  "$@" 2>&1 | tee "$OUT/$name.txt"
}

capture whoami oc whoami
capture server oc whoami --show-server
capture version oc version
capture clusterversion oc get clusterversion version -o yaml
capture clusteroperators oc get clusteroperators
capture nodes oc get nodes -o wide
capture mcp oc get machineconfigpools
capture subscriptions oc get subscriptions.operators.coreos.com -A
capture csv oc get csv -A
capture installplans oc get installplans.operators.coreos.com -A
capture storageclasses oc get storageclass
capture pvc oc get pvc -A
capture pdb oc get pdb -A

# OpenShift API request counts are useful for deprecated API assessment when available.
oc get apirequestcounts.apiserver.openshift.io > "$OUT/apirequestcounts.txt" 2>&1 || true

# Available update information is read-only.
oc adm upgrade > "$OUT/adm-upgrade.txt" 2>&1 || true

# Capture alerts only if the OpenShift monitoring API is accessible to the current identity.
oc -n openshift-monitoring get pods > "$OUT/openshift-monitoring-pods.txt" 2>&1 || true

echo "D098_UPGRADE_READINESS_READONLY=PASS" | tee "$OUT/result.txt"
echo "Evidence directory: $OUT"
echo "No upgrade was triggered."
