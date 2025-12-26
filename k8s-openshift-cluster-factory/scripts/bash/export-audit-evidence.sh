#!/usr/bin/env bash
set -euo pipefail

OUTDIR="evidence/out/$(date +%Y%m%d%H%M%S)"
mkdir -p "${OUTDIR}"

echo "Exporting evidence to ${OUTDIR}"

kubectl version -o yaml > "${OUTDIR}/kubectl-version.yaml" 2>/dev/null || true
kubectl get nodes -o wide > "${OUTDIR}/nodes.txt" || true
kubectl get ns -o yaml > "${OUTDIR}/namespaces.yaml" || true
kubectl get networkpolicy -A -o yaml > "${OUTDIR}/networkpolicies.yaml" || true
kubectl get resourcequota -A -o yaml > "${OUTDIR}/resourcequotas.yaml" || true
kubectl get limitrange -A -o yaml > "${OUTDIR}/limitranges.yaml" || true
kubectl get clusterrole,clusterrolebinding -o yaml > "${OUTDIR}/rbac-cluster.yaml" || true

echo "OK"
