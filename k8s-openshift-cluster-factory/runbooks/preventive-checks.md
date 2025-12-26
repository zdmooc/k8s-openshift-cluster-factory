# Préventif — contrôles réguliers

## Hebdo
- Nodes : NotReady, pressure, versions, reboot
- Capacity : CPU/mem/ephemeral trends
- Quotas : saturation
- Alerts : top noisy alerts, action plan

## Mensuel
- Patch level / CVEs (selon process)
- Revue exceptions policies
- Test restore (PV snapshots / procédures)

## Commandes utiles
```bash
kubectl get nodes -o wide
kubectl top nodes
kubectl get pods -A --field-selector=status.phase!=Running,status.phase!=Succeeded
kubectl get resourcequota -A
kubectl get networkpolicy -A
```
