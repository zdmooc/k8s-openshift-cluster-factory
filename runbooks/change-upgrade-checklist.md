# Change — checklist upgrade cluster

## Pré-check
- [ ] Fenêtre validée + communication
- [ ] Santé cluster OK (API, nodes, pods platform)
- [ ] Sauvegardes / snapshots (selon standard)
- [ ] Capacity suffisante (headroom)
- [ ] Liste exceptions/policies revue
- [ ] Runbook rollback prêt

## Pendant
- [ ] Upgrade control plane (selon distribution)
- [ ] Upgrade nodepools (rolling)
- [ ] Vérifications à chaque étape (smoke tests)

## Post-check
- [ ] SLO OK (latency/error)
- [ ] Workloads critiques OK
- [ ] Documentation + evidence + postmortem si incident
