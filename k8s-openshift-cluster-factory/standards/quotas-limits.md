# Quotas & limits

## Objectif
Protéger la plateforme contre les “noisy neighbors” et garantir l’équité.

## Recommandations
- ResourceQuota par namespace (CPU/mem, pods, services, PV/PVC si nécessaire)
- LimitRange : requests/limits par défaut, max, min
- Interdire les workloads sans requests/limits via policy (Kyverno/Gatekeeper)
