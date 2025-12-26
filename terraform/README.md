# Terraform — Cluster Factory

Objectif : fournir une structure **modulaire** et **multi-environnements**.

> Les ressources exactes dépendent du cloud (AKS/EKS/GKE/OpenShift IPI, etc.).
> Ce dépôt fournit un **cadre** et des **interfaces** de modules, à implémenter selon votre provider.

## Structure
- modules/ : interfaces de modules (cluster, nodepool, network, iam, addons)
- env/ : environnements (sandbox/build/preprod/prod)
- examples/ : exemples cloud (placeholders)

## Bonnes pratiques
- variables explicites + validations
- outputs contractuels
- séparation state par environnement
- tagging systématique (owner, env, cost-center)
