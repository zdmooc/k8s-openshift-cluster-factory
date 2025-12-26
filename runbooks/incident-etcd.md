# Incident — etcd (control plane)

## Symptômes
- API instable, timeouts, erreurs 5xx
- Alertes etcd (latence, leader changes)

## Diagnostic (selon accès)
- Vérifier santé API (`/readyz`) + métriques (Prometheus)
- Vérifier IO control-plane (disk latency), CPU, memory
- OpenShift: status operators + alerts etcd

## Mitigation
- Réduire charge (controllers, jobs)
- Si issue IO : escalade infra/cloud

## Résolution
- Plan d’action : capacity/IO, tuning compaction, nettoyage objets, upgrade etcd (selon distribution)

## Evidence
- alerts, métriques, logs apiserver/etcd si accessibles
