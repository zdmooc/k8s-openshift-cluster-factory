#!/usr/bin/env bash
set -euo pipefail

command -v oc >/dev/null 2>&1 || { echo "oc not found"; exit 1; }

echo "== Identity"
oc whoami

echo "== API"
oc whoami --show-server

echo "== Cluster version"
oc get clusterversion version -o jsonpath='{.status.desired.version}{"\n"}'

echo "== Nodes"
oc get nodes -o wide

echo "== Operators not Available=True"
oc get clusteroperators -o json | python3 -c '
import json,sys
data=json.load(sys.stdin)
bad=[]
for item in data["items"]:
    cond={c["type"]:c["status"] for c in item.get("status",{}).get("conditions",[])}
    if cond.get("Available") != "True" or cond.get("Degraded") == "True":
        bad.append(item["metadata"]["name"])
print("\n".join(bad))
sys.exit(1 if bad else 0)
'

echo "OPENSHIFT_PREFLIGHT=PASS"
