# D-098 — Enterprise Extension Decision Matrix

**Status:** ACCEPTED FOR MISSION PACK  
**Purpose:** complete SQY-6 without installing every technology.

## Decision principles

1. Prefer supported platform defaults before adding alternatives.
2. Install one technology only when it proves a mission-relevant mechanism.
3. Separate architecture literacy from runtime evidence.
4. Avoid multiple competing CNI/CSI stacks on the same local lab.
5. Keep vendor-specific production claims at REFERENCE unless observed.

## Cluster distribution / management

| Option | Best fit | Local D-098 action | Claim |
|---|---|---|---|
| OpenShift | mission core / enterprise CaaS | CRC evidence | bounded CRC runtime |
| RKE2 | lightweight on-prem/private cloud Kubernetes | design + prepared profile; runtime optional | REFERENCE until executed |
| Rancher | multi-cluster management for downstream Kubernetes/RKE2 | architecture/lifecycle only unless needed | REFERENCE |
| Kind | local multi-node Kubernetes / CI | existing runtime | CI/local runtime proof |

Decision: **do not replace OpenShift mission proof with RKE2/Rancher**. Treat them as enterprise extensions.

## Network

| Technology | Role | D-098 position |
|---|---|---|
| OVN-Kubernetes | OpenShift default CNI | primary OpenShift reference |
| Calico | Kubernetes/RKE2 CNI option | existing portfolio familiarity |
| Cilium | eBPF CNI / observability / policy option | architecture + troubleshooting reference |
| BGP | data-center routing integration | infrastructure contract |
| F5 | external LB / north-south integration | infrastructure contract |

Runtime decision: no multi-CNI installation. Use the active platform CNI and demonstrate policy/troubleshooting there.

## Storage

| Technology | Role | D-098 position |
|---|---|---|
| CSI contract | mandatory abstraction | core mission knowledge |
| ODF/Ceph | OpenShift storage reference | architecture/reference |
| Longhorn | RKE2/Kubernetes lab-friendly distributed storage | preferred optional local proof if a second storage runtime is justified |
| Trident | NetApp CSI | enterprise integration reference |
| Portworx | enterprise data services | enterprise integration reference |
| S3 | object storage | already proven by Data Lakehouse workload |

Runtime decision: if a new storage proof is needed, choose **one**. Do not deploy Longhorn + Trident + Portworx merely for keyword coverage.

## IAM / enterprise integration

| Capability | Owner / pattern | D-098 position |
|---|---|---|
| OIDC / Keycloak-RHBK | Keycloak specialist + Shared Platform | runtime/reference already available |
| LDAP / AD federation | Keycloak specialist | architecture/reference |
| OpenShift groups/RBAC | OpenShift CaaS | mission core |
| Vault / CyberArk | external secret-store integration | pattern unless runtime available |
| PKI | enterprise infrastructure contract | architecture/operations |
| ServiceNow CMDB | service/infrastructure inventory integration | architecture/operating model |

## Security

| Technology | Position |
|---|---|
| Kyverno | primary policy-as-code candidate already used |
| OPA Gatekeeper | alternative/reference |
| Trivy | preferred scan for SQY-5 |
| Grype | optional second scanner, not mandatory |
| Cosign | signing/verification target |
| Falco | runtime detection reference |
| NeuVector | Rancher/SUSE-aligned runtime security reference |

## Accepted SQY-6 output

The mission pack demonstrates:
- when each technology is relevant;
- which owner/layer it belongs to;
- how it integrates with CaaS;
- what is runtime-proven vs reference;
- why unnecessary local deployment is avoided.

## Gate

`ENTERPRISE_EXTENSION_PACK_READY=TRUE`.

Runtime claims remain independent and evidence-driven.
