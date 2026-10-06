# D-098 — SQY CaaS On-Premise Architecture Pack

**Status:** ARCHITECTURE_READY / RUNTIME EVIDENCE REUSED WHERE EXPLICIT  
**Mission:** Expert Kubernetes / OpenShift — Saint-Quentin-en-Yvelines  
**Owner:** `k8s-openshift-cluster-factory`

## Purpose

This document is the mission-oriented HLD for a critical on-premise Kubernetes/OpenShift CaaS.
It reuses existing portfolio evidence instead of creating a new platform or duplicating runtime proofs.

## Target architecture

~~~text
Users / Dev / Ops / Platform
          |
          v
Identity / AD / OIDC / PKI
          |
          v
Git / CI / Registry -----> Vulnerability + signature gates
          |
          v
Argo CD / OpenShift GitOps
          |
          v
+---------------------------------------------------------------+
| Kubernetes / OpenShift CaaS                                  |
|                                                               |
| Control plane          Worker pools          Platform services |
| API / etcd             app / data / infra    OLM / Operators   |
| schedulers             taints/tolerations    ingress/routes    |
| controllers            quotas/limits         monitoring        |
|                                                               |
| CNI / NetworkPolicy / LB / DNS / Firewall / BGP               |
| CSI / StorageClass / snapshots / backup                       |
| RBAC / SCC-PSS / secrets / policy-as-code                     |
+---------------------------------------------------------------+
          |
          v
Shared platform contracts
          |
          v
Business / Data / AI workloads
~~~

## OpenShift mapping

| CaaS concern | OpenShift mechanism | Evidence level in portfolio |
|---|---|---|
| Tenancy | Project / Namespace | CRC labs + D-093 consumer proof |
| Workload security | SCC `restricted-v2` + securityContext | CRC_RUNTIME_PROVEN on bounded consumer |
| Exposure | Route / Ingress | reference + CRC labs |
| Operator lifecycle | OLM / Subscription / CSV | reference/lab assets |
| GitOps | OpenShift GitOps / Argo CD | D-093 K1 CRC runtime proof |
| Policy | RBAC / NetworkPolicy / Kyverno | runtime + static depending control |
| Platform API | `CapabilityConsumption` CRD | Kind runtime + CRC consumer proof |
| Observability | metrics/logs/traces contracts | Prometheus/Grafana + Shared OTel evidence |
| Storage | CSI / StorageClass / PVC / snapshots | Kubernetes runtime; enterprise CSI remains reference |

## On-premise infrastructure contracts

The CaaS consumes, but does not own, these external infrastructure capabilities:

- compute/bare-metal/VM capacity;
- DNS, NTP and IPAM;
- load balancers and firewall changes;
- PKI and certificate lifecycle;
- enterprise registry/proxy;
- storage arrays/object storage;
- backup targets;
- Active Directory / enterprise IdP;
- CMDB / service catalog.

Each dependency needs an owner, SLO, support path and change contract.

## Tenancy model

Recommended layers:

1. platform/system namespaces;
2. shared technical capabilities;
3. product namespaces/projects;
4. sandbox zones with reduced guarantees.

Mandatory baseline per product zone:
- owner labels;
- ResourceQuota / LimitRange;
- least-privilege RBAC;
- default-deny NetworkPolicy plus explicit flows;
- restricted workload security;
- resource requests/limits;
- probes;
- GitOps ownership;
- observability onboarding.

## Non-functional requirements

### Availability
- multi-control-plane target for enterprise production;
- failure-domain aware workers;
- PodDisruptionBudget and N+1 capacity where required;
- no HA claim derived from CRC.

### Security
- centralized identity;
- least privilege;
- SCC/PSS restricted baseline;
- supply-chain verification;
- secret rotation;
- auditable policy exceptions.

### Operability
- health/capacity checks;
- N2/N3 escalation;
- alerting/logging/tracing;
- controlled maintenance windows;
- evidence after upgrades and incidents.

### Recoverability
- etcd/platform recovery owned by cluster operations;
- application/data recovery owned by respective platform/product owners;
- storage snapshots are not equivalent to application-consistent backup;
- migration rollback is workload-specific.

## GitOps ownership

~~~text
Git platform intent
   -> Argo CD / OpenShift GitOps
      -> cluster baseline / platform CRs

Git product intent
   -> Argo CD
      -> product-owned workloads

CapabilityConsumption
   -> Platform Operator
      -> platform-owned onboarding resources
~~~

No silent ownership takeover is allowed for brownfield resources.

## Mission demo evidence split

**Kind multi-node** demonstrates Kubernetes cluster-factory mechanics and a complex Data workload.

**CRC/OpenShift Local** demonstrates OpenShift-specific behavior: SCC, Routes, Operators, OpenShift GitOps, Platform Operator consumer onboarding.

The two runtimes are complementary and are not presented as simultaneous production clusters.

## Architecture gate

`CAAS_ARCHITECTURE_PACK_READY` requires:
- target layers documented;
- ownership explicit;
- NFR documented;
- OpenShift-specific mapping explicit;
- runtime claims bounded;
- Day-2 and migration paths referenced.
