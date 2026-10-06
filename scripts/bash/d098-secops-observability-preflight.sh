#!/usr/bin/env bash
set -euo pipefail

# Read-only D-098 inventory for SQY-5.
# Does not install or mutate any resource.

echo "===== CONTEXT ====="
kubectl config current-context

echo "===== MONITORING / ALERTING ====="
kubectl get pods -A | grep -Ei 'prometheus|grafana|alertmanager' || true

echo "===== LOGGING ====="
kubectl get pods -A | grep -Ei 'loki|alloy|opensearch|elastic|fluent|vector' || true

echo "===== POLICY ====="
kubectl get pods -A | grep -Ei 'kyverno|gatekeeper' || true
kubectl get clusterpolicy 2>/dev/null || true
kubectl get constrainttemplates 2>/dev/null || true

echo "===== IAM / SECRETS ====="
kubectl get pods -A | grep -Ei 'keycloak|rhbk|vault|external-secrets|sealed-secrets' || true

echo "===== SECURITY TOOL AVAILABILITY ON WORKSTATION ====="
for cmd in trivy cosign grype syft; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '%-10s %s\n' "$cmd" "$($cmd version 2>/dev/null | head -1 || true)"
  else
    printf '%-10s NOT_INSTALLED\n' "$cmd"
  fi
done

echo "D098_SECOPS_OBSERVABILITY_PREFLIGHT=PASS"
