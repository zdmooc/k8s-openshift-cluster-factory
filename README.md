# Cluster Factory — Kubernetes / OpenShift (plateforme industrialisée)

Dépôt “prêt à cloner” pour construire et opérer une plateforme Kubernetes/OpenShift **orientée expertise & support** (N2/N3),
dans un environnement Cloud industriel **fortement régulé**.

## Objectif
Fournir des **clusters prêts à l’emploi**, **sécurisés**, **automatisés** et **intégrés au SI** (IAM, réseau, registre, observabilité),
avec un socle standard (golden baseline) et des variantes maîtrisées (catalogue).

## Ce que contient le dépôt
- **Docs** : architecture (HLD), operating model, sécurité, observabilité, stratégie d’upgrade, catalogue de clusters
- **Standards** : conventions, RBAC, quotas/limites, baseline réseau
- **Runbooks N2/N3** : incidents fréquents + checklists de changements
- **IaC Terraform** : structure de modules + environnements (sandbox/build/preprod/prod) + exemples (AKS/EKS/GKE/OpenShift IPI)
- **Manifests baseline** : namespaces, quotas, limitranges, networkpolicies, RBAC, PSA/PSS labels
- **Policies** : Kyverno (exemples) + Gatekeeper/OPA (squelettes)
- **Observabilité** : règles d’alerting Prometheus (exemples) + dashboards Grafana (squelettes)
- **Scripts Ops** : healthcheck, drain sûr, export d’évidences, synchronisation kubeconfig

## Quickstart
1. Lire **docs/00-overview.md** et **docs/06-cluster-catalog.md**
2. Choisir un profil de cluster (ex: `ocp-prod-standard`)
3. Déployer le socle (manifests) :
   ```bash
   kubectl apply -k kubernetes/baseline
   # OpenShift: oc apply -k kubernetes/baseline
   ```
4. Initialiser l’IaC (Terraform) :
   ```bash
   cd terraform/env/sandbox
   terraform init
   terraform plan
   ```
5. Installer les policies (optionnel mais recommandé) :
   ```bash
   kubectl apply -f policies/kyverno
   ```

## Périmètre (important)
- Rôle **plateforme** (stabilité, performance, sécurité, évolution cluster)
- Pas un dépôt CI/CD applicatif : la CI ici sert à **qualifier le dépôt plateforme** (lint, validate, security checks)

## Structure
Voir la table des matières dans **docs/** et **runbooks/**.

## Roadmap (vision)
- Policy-as-Code “enforce by default” + exceptions tracées
- Signatures d’images + SBOM (supply chain)
- Self-service contrôlé (catalogue + automatisation day-2)
- Upgrades continus (N/N-1) avec canary clusters et rollback

---
Mainteneurs : équipe plateforme Kubernetes/OpenShift
