# 01 — Architecture (HLD)

## Vue d’ensemble
La plateforme est conçue comme un produit : **Cluster-as-a-Product**.

### Chaîne de valeur
1. **Catalogue** : profils standard (dev/build/preprod/prod), variantes contrôlées
2. **Provisioning** : IaC Terraform + intégrations SI
3. **Baseline** : manifests et politiques (sécurité, quotas, RBAC, réseau)
4. **Day-2 Ops** : patching, upgrades, capacity, remédiations, rotation secrets/certifs
5. **Support N2/N3** : runbooks, KEDB, postmortems, problem management

## Intégrations SI (cibles)
- IAM/SSO : groupes → RBAC (cluster + namespace)
- Réseau : DNS interne, ingress, egress control (proxy), firewall rules
- Registry : registries autorisés, pull secrets, scanning (si existant)
- Stockage : CSI + StorageClasses (tiers performance), snapshots, encryption (si supporté)
- Observabilité : métriques/alertes (Prometheus), logs (Loki/ELK), traces (si existant)

## Composants “plateforme”
- Control Plane / API
- CNI + DNS
- Ingress Controller (OpenShift Router / Ingress Nginx selon cible)
- CSI driver + backup/snapshot
- Policy engine (Kyverno / Gatekeeper)
- Monitoring stack (kube-prometheus-stack ou équivalent)
- Log shipping (Promtail/Fluentbit) et stockage logs (Loki/ELK)

## Diagramme (Mermaid)
Voir `diagrams/architecture.mmd`.
