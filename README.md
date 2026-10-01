# Kubernetes / OpenShift Cluster Factory

**Canonical role:** Cluster Lifecycle / CaaS / Day-2 / N2-N3  
**Portfolio status:** ACTIVE IMPLEMENTATION / O2  
**Last governance review:** 2026-10-01

This repository is the canonical cluster engineering repository of the MayaBank platform portfolio.

Its purpose is to turn a **cluster profile** into a qualified Kubernetes/OpenShift execution platform through explicit lifecycle gates: profile, render, create, baseline, health-check, evidence, Day-2 and retirement.

## What is proven vs referenced

### Executable target
The first fully automated runtime proof in this repository is a **local multi-node Kubernetes factory using Kind**.

### Reference adapters
OpenShift, RKE2/Rancher and public-cloud provider adapters are maintained as architecture/implementation references until explicit runtime evidence exists.

The repository does not claim OpenShift, RKE2, Rancher, AKS, EKS or GKE runtime merely because their configuration exists.

## Factory flow

```text
Cluster profile
    |
    v
Validate catalog
    |
    v
Render runtime/provider configuration
    |
    v
Create cluster
    |
    v
Apply baseline
    |
    v
Health + smoke
    |
    v
Capture evidence
    |
    v
Day-2 / maintenance
    |
    v
Retire
```

## Repository responsibilities

- cluster catalog and profiles;
- provisioning orchestration;
- cluster security/network/resource baseline;
- local Kind factory;
- OpenShift lifecycle reference;
- RKE2/Rancher reference adapter;
- provider contracts for Terraform;
- health, capacity and maintenance tooling;
- upgrade/recovery runbooks;
- evidence capture and claim discipline.

## Portfolio boundary

| Capability | Owner |
|---|---|
| OpenShift architecture/standards | `openshift-platform-blueprints` |
| Cluster lifecycle / CaaS | **this repository** |
| Shared platform services | `shared-platform-services-openshift` |
| Argo CD specialist | `argocd-expert-pack` |
| Keycloak specialist | `keycloak-enterprise-roadmap-v7` |
| Workload migration | `openshift-migration-framework` |

## Quick paths

- `docs/governance/REPOSITORY_SCOPE.md`
- `docs/governance/FACTORY_GATES.md`
- `docs/06-cluster-catalog.md`
- `catalog/profiles/`
- `runtime/kind/`
- `kubernetes/baseline/`
- `runbooks/`
- `evidence/`

## Evidence vocabulary

`REFERENCE | IMPLEMENTED | STATIC_VALIDATED | CI_RUNTIME_PROVEN | CRC_RUNTIME_PROVEN | MULTINODE_PROVEN | PRODUCTION_REFERENCE | STALE_REQUALIFICATION_REQUIRED`

## Important truth boundary

A Terraform module validating a cluster specification is not cloud provisioning evidence.

A Kind multi-node cluster proves Kubernetes factory mechanics locally, not OpenShift production readiness.

A CRC run proves OpenShift Local only, not multi-node HA.
