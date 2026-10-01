# Azure AKS Provider Adapter

**Status:** REFERENCE_ONLY

Target mapping: Cluster Factory contracts -> VNet/subnets/managed identity/AKS/node pools/addons.

Required runtime promotion evidence:
1. authorized Azure subscription;
2. plan/apply;
3. API/nodes/baseline verification;
4. identity/network/storage validation;
5. evidence export;
6. destroy.

No AKS runtime is currently claimed by this directory.


## Canonical profile

The first MayaBank AKS execution profile is:

`catalog/profiles/aks-ephemeral-lab.yaml`

It represents a short-lived sandbox proof. Infrastructure creation remains owned by
`zdmooc/mayabank-azure-cloud-ai-platform`; this repository owns the cluster-lifecycle gates.

Expected promotion path:

```text
REFERENCE
-> STATIC_VALIDATED
-> CLOUD_RUNTIME_PROVEN_AKS_EPHEMERAL
```

Required retirement gate:
- AKS cluster destroyed;
- node resource group removed;
- no unexpected residual load balancer/public IP/disk;
- evidence closed.
