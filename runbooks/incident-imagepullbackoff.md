# Incident — ImagePullBackOff

## Symptômes
- Pods en `ImagePullBackOff` / `ErrImagePull`

## Diagnostic
1. Décrire le pod
   ```bash
   kubectl describe pod <pod> -n <ns>
   ```
2. Vérifier le secret de pull (registry)
   ```bash
   kubectl get secret -n <ns>
   kubectl get sa default -n <ns> -o yaml
   ```
3. Tester connectivité registry (si possible via pod debug)

## Causes fréquentes
- Tag inexistant
- Registry non autorisé par policy
- Problème de credentials / token expiré
- Problème réseau/proxy

## Résolution
- Corriger image/tag
- Corriger pull secret / serviceAccount
- Ajuster allowlist registry (si politique) avec une exception tracée

## Evidence
- describe pod, events, config secret/SA, logs policy engine si applicable
