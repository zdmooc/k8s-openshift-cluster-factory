# 00 — Overview

**Status:** ACTIVE CLUSTER FACTORY IMPLEMENTATION

## Mission

Provide a governed Cluster-as-a-Service engineering model for Kubernetes/OpenShift platforms, with explicit profiles, validation gates, Day-2 operations and evidence.

## Current proven scope

The first fully executed vertical is:

```text
catalog profile
 -> validate
 -> render Kind configuration
 -> create multi-node Kubernetes cluster
 -> apply baseline
 -> healthcheck
 -> smoke
 -> export evidence
 -> destroy cluster
```

This is `CI_RUNTIME_PROVEN` for local Kind/Kubernetes when the corresponding workflow succeeds.

## Current reference-only scope

- OpenShift cluster adapter;
- RKE2/Rancher adapter;
- AWS EKS;
- Azure AKS;
- GCP GKE;
- OpenShift IPI.

These are not runtime claims until provider-authorized evidence exists.

## Objectives

The repository is designed to improve:
- repeatability;
- security baseline consistency;
- upgrade discipline;
- supportability;
- evidence quality;
- N2/N3 troubleshooting.

Targets such as time-to-cluster, platform SLO or MTTR improvement must be measured in the actual target environment before being reported as results.

## Core references

- `docs/01-architecture-hld.md`
- `docs/05-upgrade-strategy.md`
- `docs/06-cluster-catalog.md`
- `docs/07-rke2-rancher.md`
- `docs/09-operational-readiness.md`
- `docs/governance/FACTORY_GATES.md`
