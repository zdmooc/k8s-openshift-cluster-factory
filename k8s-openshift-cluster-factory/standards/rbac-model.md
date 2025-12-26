# Modèle RBAC

## Rôles plateforme (exemples)
- `platform-admin` : cluster-admin (très restreint)
- `platform-operator` : opérations day-2 + troubleshooting
- `platform-readonly` : lecture pour audit/support

## Rôles équipes produit (namespace-scoped)
- `ns-admin` : admin namespace (sans cluster-level)
- `ns-editor` : déploiement workloads
- `ns-viewer` : lecture

## Mapping IAM
Groupe IAM → ClusterRoleBinding/RoleBinding (défini par environnement)
