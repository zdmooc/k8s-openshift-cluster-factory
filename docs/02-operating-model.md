# 02 — Operating Model (N2/N3)

## Processus
- Incident (N2/N3) : triage → diag → mitigation → résolution → postmortem si majeur
- Problem : analyse causes racines (RCA), backlog actions, suppression du récurrent
- Change : standard (pré-approuvé) vs majeur (CAB), plan + rollback + validation

## Astreinte
- Périmètre : composants plateforme (API, ingress, DNS, CNI, CSI, policy engine, monitoring)
- Escalade : N2 → N3 → éditeur / cloud provider
- Artefacts : runbook, checklist, scripts de collecte d’évidences

## KEDB (Known Error DB)
- Maintenir une base des erreurs connues : symptômes, cause, contournement, résolution définitive

## Rituels
- Revue incidents (quotidienne)
- Revue problèmes (hebdomadaire)
- Revue capacité (mensuelle)
- Revue sécurité/conformité (mensuelle)
