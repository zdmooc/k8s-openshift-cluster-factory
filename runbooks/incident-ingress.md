# Incident — Ingress / Router

## Symptômes
- 404/502, timeouts, certificat TLS invalide
- Latence élevée

## Diagnostic
1. Vérifier contrôleur ingress
   - Kubernetes : `ingress-nginx` / `Gateway` selon standard
   - OpenShift : router + status operators
2. Vérifier ressource Ingress/Route
   ```bash
   kubectl describe ingress <name> -n <ns>
   ```
3. Logs controller
   ```bash
   kubectl -n ingress-nginx logs deploy/ingress-nginx-controller --tail=200
   ```

## Causes fréquentes
- Backend non prêt (readiness)
- Mauvaise targetPort/service
- Certificat/secret absent
- Policy réseau bloquante

## Evidence
- describe ingress/service/endpoints, logs controller, events
