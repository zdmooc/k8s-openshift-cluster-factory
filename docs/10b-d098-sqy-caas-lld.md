# D-098 — SQY CaaS Low-Level Design

**Status:** LLD_READY / MISSION PACK

## Cluster profile contract

Production-like target profile:

- platform: OpenShift;
- control plane: 3 nodes target;
- workers: at least 3, sized by workload and N+1 policy;
- separate infra/worker pools where justified;
- supported stable update channel;
- backup responsibilities explicit;
- default-deny network baseline;
- restricted workload security baseline.

The local CRC proof remains single-node and does not instantiate this target topology.

## Namespace / Project standard

Required metadata:
- `app.kubernetes.io/part-of`;
- environment;
- owner/team;
- criticality;
- data-classification where applicable.

Per project:
- ResourceQuota;
- LimitRange;
- ServiceAccount;
- least-privilege Role/RoleBinding;
- baseline NetworkPolicy;
- approved Route/Ingress pattern;
- observability onboarding.

## RBAC

Roles:
- platform-admin;
- platform-ops;
- product-deployer;
- product-reader/auditor.

Rules:
- group bindings preferred over individual users;
- cluster-admin exceptional;
- no broad wildcard permissions for product workloads;
- break-glass path documented and audited.

## SCC / Pod Security

Default:
- no privileged container;
- no hostNetwork/hostPID/hostPath unless explicitly approved;
- non-root / OpenShift arbitrary UID compatible;
- `allowPrivilegeEscalation: false`;
- capabilities dropped unless required;
- seccomp RuntimeDefault where supported;
- requests/limits mandatory.

SCC exceptions:
- owner;
- justification;
- scope;
- expiry/review date;
- compensating controls.

## Network

Baseline:
1. deny ingress by default for product namespaces where compatible;
2. deny egress by default when operational model supports it;
3. allow DNS explicitly;
4. allow only documented service-to-service flows;
5. separate north-south exposure from east-west policies.

External dependencies:
- DNS/IPAM;
- firewall;
- proxy;
- F5/LB;
- BGP routing when used.

## Routes / TLS

For each Route:
- hostname owner;
- TLS termination mode;
- certificate owner;
- backend Service;
- authentication requirement;
- public/internal classification.

Admin consoles should not be exposed by the same policy as public APIs.

## OLM / Operators

For every Operator:
- owner;
- source/catalog;
- channel;
- approval strategy;
- target namespace/install mode;
- CRDs owned;
- upgrade compatibility;
- rollback/recovery notes;
- monitoring and support contact.

## Storage

For each StorageClass:
- CSI driver;
- reclaim policy;
- expansion support;
- snapshot support;
- topology awareness;
- encryption;
- performance class;
- backup owner.

PVC is persistence, not backup.

## GitOps

Platform path:
`Git -> Argo/OpenShift GitOps -> platform resources`.

Product path:
`Product Git -> Argo -> product resources`.

Brownfield:
`Observe -> compare ownership -> explicit adoption -> Manage`.

## Monitoring / logging

Required minimum:
- node readiness/capacity;
- ClusterOperator health;
- API/DNS/ingress;
- PVC/storage failures;
- workload availability;
- policy/admission denials;
- GitOps sync/health.

Logs must support incident timestamp correlation.

## Secrets

- no cleartext secrets in Git;
- secret source documented;
- rotation documented;
- emergency revoke path;
- certificates with expiry monitoring;
- Vault/CyberArk remains external unless implemented.

## Day-2 handover artifacts

- cluster profile;
- access model;
- maintenance window;
- upgrade procedure;
- N3 runbooks;
- backup/restore responsibility;
- escalation matrix;
- known limitations;
- evidence index.

## Gate

Together with `10-d098-sqy-caas-onprem-hld.md`:
`CAAS_ARCHITECTURE_PACK_READY=TRUE`.
