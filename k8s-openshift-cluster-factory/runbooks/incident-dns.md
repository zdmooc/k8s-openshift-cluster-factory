# Incident — DNS (CoreDNS) / résolution

## Symptômes
- Pods ne résolvent plus `*.svc` ou domaines externes
- Timeouts applicatifs

## Diagnostic
1. Vérifier CoreDNS
   ```bash
   kubectl -n kube-system get pods -l k8s-app=kube-dns
   kubectl -n kube-system logs -l k8s-app=kube-dns --tail=200
   ```
2. Test depuis un pod
   ```bash
   kubectl run -it --rm dns-test --image=busybox:1.36 --restart=Never -- nslookup kubernetes.default.svc
   ```
3. Vérifier NetworkPolicy (egress DNS) et proxy

## Mitigation
- Restart CoreDNS si nécessaire (avec prudence)
- Débloquer egress DNS via policy (temporaire et tracée)

## Evidence
- logs CoreDNS, test nslookup, NetworkPolicies pertinentes
