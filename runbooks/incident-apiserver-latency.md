# Incident — API Server latency / erreurs

## Symptômes
- `kubectl` lent, timeouts, erreurs 5xx
- Alertes “API server error rate/latency”

## Diagnostic
1. Vérifier santé API
   ```bash
   kubectl get --raw='/readyz?verbose'
   kubectl get --raw='/livez?verbose'
   ```
2. Contrôle saturation (top nodes)
   ```bash
   kubectl top nodes
   kubectl top pods -A --sort-by=cpu | head
   ```
3. Vérifier etcd (si accès)
   - OpenShift: regarder les alerts etcd et status operators

## Mitigation
- Réduire charge : stopper jobs massifs, limiter controllers, augmenter resources control-plane (si géré)
- Déclencher cellule support infra/cloud si souci réseau/IO

## Résolution
- RCA : etcd IO, CPU saturation, surcharge admission webhooks, réseau
- Actions durables : capacity, tuning, rate limiting, nettoyage objets, révision policies

## Evidence
- outputs readyz/livez, alerts, top, logs apiserver/etcd (si accessible)
