# Terraform Contracts — Cluster Factory

**Status:** IMPLEMENTED / STATIC_VALIDATION TARGET

The Terraform area defines **provider-neutral cluster contracts** and environment composition.

It deliberately does **not** claim that AKS/EKS/GKE/OpenShift infrastructure is provisioned by these modules today.

## Why this design

The previous repository contained empty provider placeholders. Those placeholders have been replaced by explicit contracts for:

- network;
- cluster;
- node pool;
- IAM;
- addons.

The contracts are useful for validating environment composition and defining the interface an actual provider adapter must satisfy.

## Structure

```text
terraform/
├── modules/
│   ├── network/
│   ├── cluster/
│   ├── nodepool/
│   ├── iam/
│   └── addons/
├── env/
│   ├── sandbox/
│   ├── build/
│   ├── preprod/
│   └── prod/
└── examples/
    ├── aws-eks/
    ├── azure-aks/
    ├── gcp-gke/
    └── openshift-ipi/
```

## Evidence boundary

- `terraform fmt -check` + `terraform validate` = static validation only.
- An example README is not provider runtime evidence.
- Cloud provisioning becomes a runtime claim only after plan/apply/verify/destroy evidence is captured against an authorized account.

## Provider adapter contract

A future provider implementation must map the normalized contracts to real resources while preserving:

- environment isolation;
- network CIDRs;
- cluster topology;
- node-pool roles;
- IAM group mappings;
- addon requirements;
- traceability tags.

Until then, examples remain `REFERENCE`.
