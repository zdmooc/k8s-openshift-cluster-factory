# Incident — Node NotReady

## Symptômes
- `kubectl get nodes` montre un node `NotReady`
- Pods en `Pending` / `Unknown`

## Diagnostic
1. État node + events
   ```bash
   kubectl describe node <node>
   kubectl get events -A --sort-by=.lastTimestamp | tail -n 50
   ```
2. Conditions et pression
   ```bash
   kubectl get node <node> -o jsonpath='{.status.conditions}'
   ```
3. Vérifier kubelet / runtime (selon accès)
   - OpenShift: `oc debug node/<node>` puis logs kubelet

## Mitigation
- Cordon + drain (si node instable)
  ```bash
  kubectl cordon <node>
  kubectl drain <node> --ignore-daemonsets --delete-emptydir-data --grace-period=60 --timeout=10m
  ```

## Résolution
- Identifier la cause : disque plein, CNI, runtime, certifs, réseau, kernel
- Remettre en service:
  ```bash
  kubectl uncordon <node>
  ```

## Evidence
- `describe node`, `events`, logs kubelet/runtime, métriques node
