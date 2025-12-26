# 00 — Overview

## Contexte
La plateforme fournit des clusters Kubernetes/OpenShift prêts à l’emploi (sécurisés, automatisés, intégrés au SI)
pour des équipes applicatives consommatrices.

## Objectifs mesurables (exemples)
- Time-to-cluster < 2 jours (variantes catalogue), < 4h pour profils standard
- SLO plateforme : 99,9% sur services critiques (API, ingress, DNS, auth, registry access)
- MTTR -30% sur incidents récurrents via runbooks + automatisation

## Périmètre
- Support N2/N3, MCO, capacity, upgrades, sécurité, conformité
- Industrialisation IaC (Terraform) et automatisation day-2 (scripts/outil interne)

## Livrables de référence
- docs/01-architecture-hld.md
- docs/02-operating-model.md
- docs/03-security-baseline.md
- docs/04-observability.md
- docs/05-upgrade-strategy.md
- docs/06-cluster-catalog.md
