# Incident — Storage / CSI

## Symptômes
- PVC en `Pending`
- Pods bloqués sur `ContainerCreating` (mount)
- Erreurs CSI

## Diagnostic
1. PVC/PV
   ```bash
   kubectl get pvc -A
   kubectl describe pvc <pvc> -n <ns>
   kubectl get sc
   ```
2. Logs CSI controller/node (selon driver)
   ```bash
   kubectl -n kube-system get pods | grep -i csi
   ```

## Causes fréquentes
- StorageClass inexistante/mal paramétrée
- Quota stockage atteint
- Problème backend storage
- Permissions / encryption / snapshot issues

## Evidence
- describe pvc/pod, logs CSI, métriques storage si disponibles
