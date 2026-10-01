# Claim / Evidence Matrix

**Date:** 2026-10-01

| Capability | Evidence level | Evidence |
|---|---|---|
| Repository scope / ownership | IMPLEMENTED | governance docs |
| Cluster profile schema | STATIC_VALIDATED | Static CI run `36857552519` |
| 5 cluster profiles | STATIC_VALIDATED | profile validator PASS |
| Terraform environment contracts | STATIC_VALIDATED | 4 envs `terraform validate` PASS |
| Kubernetes baseline | STATIC_VALIDATED | Kustomize + kubeconform PASS |
| Shell/Python helper syntax | STATIC_VALIDATED | Static CI run `36857552519` |
| Kind multi-node cluster creation | CI_RUNTIME_PROVEN | Runtime run `36857415894` |
| Kind baseline application | CI_RUNTIME_PROVEN | `FACTORY_BASELINE_APPLIED=PASS` |
| Kind cluster health | CI_RUNTIME_PROVEN | `CLUSTER_HEALTHCHECK=PASS` |
| Kind smoke workload | CI_RUNTIME_PROVEN | `FACTORY_SMOKE=PASS` |
| Kind topology | CI_RUNTIME_PROVEN | 1 control-plane + 2 workers / 3 nodes |
| Runtime evidence export | CI_RUNTIME_PROVEN | `EVIDENCE_EXPORT=PASS` + artifact |
| Cluster retirement | CI_RUNTIME_PROVEN | `FACTORY_CLUSTER_RETIRED=PASS` |
| OpenShift adapter | REFERENCE / IMPLEMENTED SCRIPTS | no CRC run yet |
| RKE2/Rancher adapter | REFERENCE | no runtime yet |
| EKS/AKS/GKE/OpenShift IPI adapters | REFERENCE_ONLY | no authorized provider runtime |
| OpenShift multi-node HA | NOT_PROVEN | no evidence |
| Production readiness | NOT_CLAIMED | requires target-environment qualification |

## Runtime proof details

Workflow: `Cluster Factory Kind Runtime`  
Run: `36857415894`  
Commit: `f16f27e004a1e38a0950e5d2420efe38d82f33a1`  
Result: **SUCCESS**

Observed markers:

```text
PROFILE_VALIDATION=PASS count=5
FACTORY_CLUSTER_CREATED=PASS
FACTORY_BASELINE_APPLIED=PASS
CLUSTER_HEALTHCHECK=PASS
FACTORY_EXPECTED_CONTROL_PLANES=1
FACTORY_EXPECTED_WORKERS=2
FACTORY_ACTUAL_NODES=3
FACTORY_SMOKE=PASS
EVIDENCE_EXPORT=PASS
FACTORY_CLUSTER_RETIRED=PASS
```

## Static proof details

Workflow: `Cluster Factory Static CI`  
Run: `36857552519`  
Commit: `fd466547a7c5c7b464ffad951c5643ee9e46c8b7`  
Result: **SUCCESS**

The static workflow validates:
- Terraform formatting;
- Terraform environment validation;
- catalog schema;
- YAML lint;
- Kustomize rendering;
- Python compilation;
- kubeconform;
- shell syntax.

## Truth boundary

Kind multi-node proves Kubernetes cluster-factory mechanics in CI. It does **not** prove OpenShift, RKE2, Rancher, cloud-provider infrastructure or production HA.
