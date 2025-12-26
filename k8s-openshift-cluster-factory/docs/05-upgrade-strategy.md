# 05 — Stratégie d’upgrade

## Objectif
Maintenir les clusters en version supportée (N/N-1), réduire le risque et standardiser.

## Approche
1. Canary cluster (ou environnement pilote)
2. Fenêtre de maintenance + communication
3. Checklist pré-upgrade (health, backups, capacity)
4. Upgrade + validations (smoke tests)
5. Rollback plan (si possible) / plan de repli

## Checklists
- `runbooks/change-upgrade-checklist.md`
