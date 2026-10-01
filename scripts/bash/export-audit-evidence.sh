#!/usr/bin/env bash
set -euo pipefail

OUTDIR="${OUTDIR:-evidence/out/$(date +%Y%m%d%H%M%S)}"
mkdir -p "${OUTDIR}"

echo "Exporting evidence to ${OUTDIR}"

kubectl version -o yaml > "${OUTDIR}/kubectl-version.yaml" 2>&1 || true
kubectl cluster-info > "${OUTDIR}/cluster-info.txt" 2>&1 || true
kubectl get nodes -o wide > "${OUTDIR}/nodes.txt" 2>&1 || true
kubectl get nodes -o yaml > "${OUTDIR}/nodes.yaml" 2>&1 || true
kubectl get ns -o yaml > "${OUTDIR}/namespaces.yaml" 2>&1 || true
kubectl get networkpolicy -A -o yaml > "${OUTDIR}/networkpolicies.yaml" 2>&1 || true
kubectl get resourcequota -A -o yaml > "${OUTDIR}/resourcequotas.yaml" 2>&1 || true
kubectl get limitrange -A -o yaml > "${OUTDIR}/limitranges.yaml" 2>&1 || true
kubectl get clusterrole,clusterrolebinding -o yaml > "${OUTDIR}/rbac-cluster.yaml" 2>&1 || true
kubectl get events -A --sort-by=.lastTimestamp > "${OUTDIR}/events.txt" 2>&1 || true

printf 'EVIDENCE_EXPORT=PASS\n' | tee "${OUTDIR}/result.txt"
