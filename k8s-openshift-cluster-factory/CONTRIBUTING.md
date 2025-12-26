# Contribuer

## Règles
- Toute évolution doit être liée à un ticket (Incident/Problem/Change/RFC).
- Les modifications “platform critical” nécessitent une revue croisée + validation sécurité.
- Les runbooks doivent être testés en environnement non-prod avant publication.

## Workflow
1. Créer une branche `feature/<topic>` ou `fix/<topic>`
2. Mettre à jour la doc + runbooks si nécessaire
3. Vérifier localement :
   ```bash
   make check
   ```
4. Pull request avec :
   - contexte, risque, rollback
   - impacts (SLO, sécurité, coût)
   - preuves (evidence/)
