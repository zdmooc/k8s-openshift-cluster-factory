# Kubernetes / OpenShift Cluster Factory

**Canonical role:** Cluster Lifecycle / CaaS / Day-2 / N2-N3  
**Portfolio status:** O2 COMPLETE / STATIC_VALIDATED + CI_RUNTIME_PROVEN  
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


## O2 baseline completed — 2026-10-01

The major O2 implementation program is complete.

Validated evidence:
- Static CI run `36857552519` — **SUCCESS**;
- Kind multi-node runtime run `36857415894` — **SUCCESS**;
- runtime topology: **1 control-plane + 2 workers**;
- create → baseline → healthcheck → smoke → evidence → destroy all passed.

Current runtime claim: **CI_RUNTIME_PROVEN for local multi-node Kubernetes/Kind factory mechanics**.

OpenShift, RKE2/Rancher and cloud adapters remain at their documented lower evidence levels.

Completion record: `docs/governance/O2_COMPLETION.md`.
