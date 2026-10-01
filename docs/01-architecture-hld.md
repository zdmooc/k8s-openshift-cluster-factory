# 01 — Cluster Factory Architecture (HLD)

**Status:** REFERENCE + IMPLEMENTED FACTORY CORE

## Product model

The repository implements a **Cluster-as-a-Product** lifecycle:

1. **Catalog** — versioned cluster profiles;
2. **Validation** — schema, Terraform contract and manifest validation;
3. **Provisioning adapter** — Kind today, provider adapters later;
4. **Baseline** — namespace, quotas/limits, RBAC, network/security guardrails;
5. **Qualification** — healthcheck, smoke and evidence;
6. **Day-2** — maintenance, capacity, drain, upgrade and incident handling;
7. **Retirement** — controlled decommissioning.

## Layering

```text
Infrastructure / provider
        |
        v
Cluster lifecycle / CaaS       <- this repository
        |
        v
Shared platform services       <- shared-platform-services-openshift
        |
        v
Specialized platforms
        |
        v
Products
```

## Factory components

### Catalog
`catalog/profiles/` + JSON Schema.

### Provider/runtime adapters
- `runtime/kind/` — executable CI vertical;
- `runtime/openshift/` — existing-cluster adapter;
- `runtime/rke2/` — reference adapter;
- `terraform/examples/` — cloud/OpenShift provider reference adapters.

### Baseline
`kubernetes/baseline/`.

### Policy
Kyverno examples are present; Gatekeeper remains an alternative reference.

### Day-2
Health, drain/uncordon, capacity, upgrades, incident runbooks and evidence export.

## Enterprise integration contracts

Target integrations may include:
- IAM/SSO group mappings;
- DNS/LB/firewall/proxy;
- CNI and NetworkPolicy;
- CSI/storage/snapshots;
- registry and image-policy gates;
- monitoring/logging/tracing contracts;
- backup/restore;
- CMDB/service catalog.

The actual product/runtime services above the cluster are not owned by this repository.

## Evidence discipline

A provider adapter is not considered implemented merely because configuration exists.

See `docs/governance/FACTORY_GATES.md`.
