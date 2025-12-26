# 06 — Catalogue de clusters (profils)

## Modèle
Un profil = un ensemble de paramètres + baseline + options (features).

### Exemple de profils
- `k8s-dev-standard` : coût réduit, non-HA, quotas stricts
- `k8s-build-ha` : HA, perf CI, accès registry renforcé
- `ocp-preprod-standard` : proche prod, policies en `enforce`
- `ocp-prod-critical` : HA, DR/backup renforcé, audit complet

## Dimensions
- Sizing : nodes, types, autoscaling
- Réseau : ingress, egress, network segmentation
- Stockage : tiers, snapshots, encryption
- Sécurité : PSA/PSS, policies, registries, exceptions
- Observabilité : dashboards, alerting, log retention
- Exploitation : patching window, upgrade cadence, SLO

## Fiche de profil (template)
Voir `docs/templates/RFC-template.md`.
