# 06 — Cluster Catalog

**Status:** IMPLEMENTED / PROFILE_SCHEMA_VALIDATED TARGET

A cluster profile is a versioned contract describing the intended platform, topology, network, storage, security and lifecycle posture.

Canonical files live under `catalog/profiles/` and are validated against `catalog/schema/cluster-profile.schema.json`.

## Current profiles

| Profile | Platform | Evidence target |
|---|---|---|
| `k8s-ci-multinode` | Kind/Kubernetes | CI runtime |
| `k8s-dev-standard` | Kubernetes | reference |
| `ocp-preprod-standard` | OpenShift | reference |
| `ocp-prod-critical` | OpenShift | reference |
| `rke2-lab-standard` | RKE2 | reference |

## Dimensions

Every profile defines:

- platform/distribution;
- environment;
- expected evidence level;
- control-plane and worker topology;
- Pod and Service CIDRs;
- network-policy posture;
- storage class and snapshot expectation;
- Pod Security posture;
- policy engine;
- lifecycle/upgrade contract;
- optional features.

## Factory gates

A profile becomes meaningful only through the gates in `docs/governance/FACTORY_GATES.md`.

`PROFILE_DEFINED` is not the same as `CLUSTER_CREATED`.

## Change policy

Changes to a profile should be reviewed as platform changes because they may alter cost, topology, failure domains, security posture or upgrade behavior.
