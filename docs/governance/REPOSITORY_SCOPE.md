# Cluster Factory Repository Scope

**Status:** ACTIVE IMPLEMENTATION / O2 CLEANUP  
**Date:** 2026-10-01

## Mission

This repository is the canonical **Cluster Lifecycle / CaaS / Day-2 / N2-N3** implementation repository of the MayaBank platform portfolio.

It owns the engineering required to create, baseline, qualify, operate, upgrade and retire Kubernetes/OpenShift clusters.

## Owned here

- cluster catalog and profiles;
- provisioning workflow and provider adapters;
- local executable Kubernetes factory;
- OpenShift cluster lifecycle reference;
- RKE2/Rancher integration reference;
- network/storage/security baseline contracts;
- baseline manifests;
- policy validation;
- cluster health checks;
- capacity checks;
- maintenance/drain/upgrade runbooks;
- evidence collection;
- N2/N3 operational model.

## Not owned here

| Capability | Canonical owner |
|---|---|
| OpenShift architecture/standards | `zdmooc/openshift-platform-blueprints` |
| Shared GitOps/IAM/observability/quality services | `zdmooc/shared-platform-services-openshift` |
| Deep Argo CD training/runtime evidence | `zdmooc/argocd-expert-pack` |
| Deep Keycloak/IAM training/runtime evidence | `zdmooc/keycloak-enterprise-roadmap-v7` |
| Workload migration assessment | `zdmooc/openshift-migration-framework` |
| Kubernetes internals/manual bootstrap | `zdmooc/kubernetes-the-hard-way-vagrant-architect-v29` |

## Evidence vocabulary

`REFERENCE | IMPLEMENTED | STATIC_VALIDATED | CI_RUNTIME_PROVEN | CRC_RUNTIME_PROVEN | MULTINODE_PROVEN | PRODUCTION_REFERENCE | STALE_REQUALIFICATION_REQUIRED`

A provider adapter that has not been executed is never presented as provisioned infrastructure.
