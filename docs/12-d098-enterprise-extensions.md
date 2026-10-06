# D-098 — Enterprise Extensions Decision Pack

**Status:** ARCHITECTURE_READY / SELECTIVE RUNTIME ONLY

The mission lists a broad enterprise ecosystem. The objective is to demonstrate architecture judgement,
not to install every technology on one workstation.

## RKE2 / Rancher

Target use:
- RKE2 for on-prem/private-cloud Kubernetes;
- Rancher as optional multi-cluster management/governance plane.

Required design controls:
- 3-server etcd quorum target for production;
- server/agent separation;
- etcd snapshot/restore;
- Rancher/RKE2 compatibility matrix;
- controlled server then worker upgrade sequence;
- CIS-oriented configuration where supported;
- cluster registration and least-privilege project roles.

Current claim remains `REFERENCE` until runtime evidence is captured.

## Network

| Technology | Mission interpretation |
|---|---|
| OVN-Kubernetes | default OpenShift network reference |
| Calico | proven/known Kubernetes CNI context |
| Cilium | eBPF/CNI option, architecture/troubleshooting scope |
| BGP | data-center routing integration contract |
| F5 | north-south LB/ingress integration contract |

Do not install multiple CNIs in the same lab to demonstrate breadth.

Network troubleshooting must follow:
`DNS -> Service/Endpoints -> NetworkPolicy -> CNI -> node route -> LB/firewall`.

## Storage

Common CSI contract:
- StorageClass;
- access mode;
- reclaim policy;
- expansion;
- VolumeSnapshot;
- backup/restore ownership;
- topology/failure domains;
- performance/SLO.

Technology placement:
- Longhorn: practical RKE2/Kubernetes lab option;
- Trident: NetApp CSI enterprise integration;
- Portworx: enterprise Kubernetes data services;
- ODF/Ceph: OpenShift-native storage reference.

Only one local runtime should be selected if a storage proof is needed.

## Active Directory / IAM

Enterprise pattern:
`AD / IdP -> OIDC/SAML federation -> OpenShift OAuth / Keycloak -> groups -> RBAC`.

Do not claim enterprise AD integration from a local Keycloak lab.
The portfolio already contains LDAP/AD federation architecture in the IAM specialist repository.

## ServiceNow / CMDB

Integration target:
`Cluster profile -> provisioning evidence -> CMDB/Service Catalog -> ownership/support metadata -> change/incident/problem records`.

Minimum CI relationship model:
- business/application service;
- CaaS cluster;
- node/pool;
- namespace/project;
- platform capability;
- owning team;
- environment;
- criticality.

No ServiceNow runtime is required to prove the integration architecture.

## Selection rule

A technology is promoted from `REFERENCE` only if:
1. the mission requires hands-on proof;
2. the workstation/runtime can support it safely;
3. a clear acceptance gate exists;
4. evidence can be captured without false production claims.

## Gate

`ENTERPRISE_EXTENSION_PACK_READY` = architecture and selection rationale complete.
Runtime-specific claims remain separately gated.
