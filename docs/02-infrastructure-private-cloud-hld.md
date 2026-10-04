# D-095 — Infrastructure / Private Cloud Architecture HLD

**Status:** ARCHITECTURE_PACK_READY / REFERENCE + EXISTING EVIDENCE REUSE  
**Date:** 2026-10-04  
**Owner:** `k8s-openshift-cluster-factory`

## 1. Objective

Extend the Cluster Factory from a Kubernetes-centric lifecycle view to an explicit **Infrastructure Solution Architecture** view without turning this repository into a generic virtualization product.

The target role is:

> **Architecte Solutions Infrastructure — Cloud, Kubernetes/OpenShift & Infrastructure as Code**

A stronger **Private Cloud / Hybrid** claim requires separate runtime evidence.

## 2. Architecture question

How should a regulated enterprise modernize infrastructure from VM-centric hosting toward Kubernetes/OpenShift while preserving explicit ownership for compute, network, storage, security, operations and rollback?

## 3. Layered target architecture

```text
Business / Data / AI workloads
            |
            v
Kubernetes / OpenShift workload platform
            |
            +-- ingress / routes / API exposure
            +-- policy / RBAC / quotas
            +-- observability / shared services
            +-- GitOps / platform API
            |
            v
Cluster Lifecycle / CaaS
            |
            +-- profile / topology
            +-- baseline
            +-- capacity
            +-- health / upgrade / recovery
            +-- evidence
            |
            v
Infrastructure integration contract
            |
            +-- Compute / VM / bare metal
            +-- Network / VLAN / routing / firewall / LB / DNS / IPAM
            +-- Storage / SAN / NAS / CSI / snapshots
            +-- IAM / PKI / secrets
            +-- Backup / restore
            +-- Monitoring / logs / metrics
            +-- CMDB / service catalog
            |
            v
Private / Hybrid Infrastructure
            |
            +-- vSphere      REFERENCE
            +-- OpenStack    REFERENCE
            +-- Nutanix      REFERENCE
            +-- KVM/libvirt  LOCAL LAB TARGET
            +-- Bare metal   REFERENCE
```

## 4. Responsibility model

| Layer | Main responsibility | Canonical owner |
|---|---|---|
| Infrastructure architecture | target design, constraints, NFR, provider decision | this repository |
| OpenShift standards | tenancy, SCC/Pod Security, routes, storage references, Operators | `openshift-platform-blueprints` |
| Provider/IaaS lab | provider-specific learning adapters | `kubernetes-the-hard-way-multicloud` |
| VM/Linux/Ansible lab | low-level OS and Kubernetes internals | `kubernetes-the-hard-way-vagrant-architect-v29` |
| Migration | inventory, waves, dry-run, cutover, rollback | `openshift-migration-framework` |
| Shared platform services | identity, telemetry, quality, platform contracts | `shared-platform-services-openshift` |

## 5. Infrastructure design domains

### Compute
- VM vs container placement criteria;
- control-plane and worker sizing;
- CPU/RAM headroom;
- failure domains;
- affinity / anti-affinity expectations;
- maintenance and lifecycle.

### Network
- management, node and workload networks;
- ingress / egress;
- load-balancing;
- DNS/IPAM;
- firewall and proxy boundaries;
- CNI and NetworkPolicy boundary.

### Storage
- block/file/object requirements;
- CSI integration;
- snapshot / backup;
- performance and durability classes;
- stateful workload placement criteria.

### Security
- IAM/SSO;
- machine identity;
- PKI/certificates;
- secrets;
- administrative access;
- audit and least privilege.

### Operations
- monitoring, logs, traces;
- capacity and alerting;
- upgrades;
- backup/restore;
- incident response;
- CMDB/service catalog;
- evidence and change records.

## 6. NFR decision frame

Every target architecture must explicitly score:

| NFR | Questions |
|---|---|
| Availability | Which component fails? node, rack, cluster, site? |
| Performance | latency, throughput, storage IOPS, network constraints |
| Capacity | CPU/RAM/storage headroom and growth |
| Security | identity, admin access, segmentation, secrets, patching |
| Recoverability | backup, restore, RTO/RPO, rollback |
| Operability | monitoring, runbooks, upgrade, incident handling |
| Portability | provider coupling, Kubernetes/OpenShift portability |
| Cost | licenses, infrastructure, operations, skills |
| Sustainability | rightsizing, consolidation, utilization, lifecycle |

## 7. AS-IS -> GAP -> TARGET method

```text
Inventory AS-IS
   -> workloads / VM / dependencies
   -> service levels / failure domains
   -> operational model
   -> constraints

GAP
   -> unsupported automation
   -> manual configuration
   -> SPOF
   -> weak observability
   -> missing rollback/evidence

TARGET
   -> infrastructure integration contract
   -> qualified cluster
   -> platform services
   -> GitOps / automation
   -> Day-2 and evidence
```

## 8. Provisioning/control-plane separation

```text
Terraform
= infrastructure provisioning and lifecycle

Ansible
= operating-system configuration and Day-2 configuration management

Kubernetes/OpenShift Operators
= cluster-native infrastructure/platform controllers

GitOps
= desired state delivery/reconciliation for Kubernetes resources
```

No tool should be introduced only because it appears in a job description. Each tool needs a clear control-plane responsibility.

## 9. Private Cloud options

The repository does **not** choose a private-cloud product globally.

Provider selection is based on:
- existing enterprise estate;
- support model;
- automation APIs/providers;
- network/storage integration;
- OpenShift/Kubernetes support;
- HA/failure-domain capabilities;
- lifecycle and patching;
- security/compliance;
- licensing/TCO;
- skills and operational maturity.

See ADR-003.

## 10. Evidence boundary

Current proofs reused by this HLD:
- Kind 1 control-plane + 2 workers Cluster Factory runtime;
- static Terraform cluster contracts;
- OpenShift existing-cluster adapter;
- separate CRC/OpenShift product/platform proofs in portfolio repositories.

Not proven by this HLD:
- VMware/vSphere runtime;
- OpenStack runtime;
- Nutanix runtime;
- KVM/libvirt Terraform apply;
- private-cloud HA;
- production topology.

## 11. D-095 gates

- INFRA-1: **ARCHITECTURE_PACK_READY** — this HLD + ADR set.
- INFRA-2: VM/Linux/Ansible runtime replay — external specialist lab.
- INFRA-3: private-infra IaC proof — provider lab.
- INFRA-4: platform industrialization synthesis.
- INFRA-5: interview/demo pack.
