# 03 — Sécurité (baseline)

## Principes
- Least privilege (RBAC), séparation des rôles plateforme vs équipes produit
- “Secure by default” : quotas/limits, policies, network segmentation
- Exceptions tracées et temporisées (avec justification)

## Baseline recommandée
- RBAC : groupes IAM → ClusterRoles/RoleBindings
- PSA/PSS : labels au niveau namespace
- NetworkPolicies : deny-by-default + allowlist egress/ingress
- Images : provenance registry, interdiction `:latest`, scan si disponible
- Secrets : éviter les secrets en clair, rotation, chiffrement au repos si possible
- Audit logging : activé + conservation et accès contrôlé

## Mise en œuvre
- Manifests : `kubernetes/baseline/`
- Policies (optionnel) : `policies/kyverno/` ou `policies/gatekeeper/`
