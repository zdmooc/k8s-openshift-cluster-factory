# 08 — Network, Storage and Runtime Security Options

**Status:** REFERENCE / TECHNOLOGY PLACEMENT

This document maps technologies often seen in enterprise Kubernetes/OpenShift missions to the Cluster Factory ownership model.

## Networking

| Technology | Factory role |
|---|---|
| OVN-Kubernetes | OpenShift default networking reference |
| Calico | Kubernetes/RKE2 CNI option where selected |
| Cilium | Kubernetes CNI/eBPF option where selected |
| F5 | external load-balancing / ingress integration pattern |
| BGP | network integration mechanism, environment-specific |

Selection must be driven by support matrix, network requirements and operational ownership. The factory must not install multiple CNIs just to demonstrate breadth.

## Storage

| Technology | Factory role |
|---|---|
| CSI | required storage integration contract |
| ODF/Ceph | OpenShift storage reference |
| Trident | NetApp CSI integration pattern |
| Portworx | enterprise Kubernetes storage option |
| Longhorn | RKE2/Kubernetes lab/private-cloud option |
| S3 | object-storage service contract |

Storage HA, snapshots and backup are separate claims.

## Runtime security / supply chain

| Technology | Placement |
|---|---|
| Kyverno | policy-as-code baseline supported in this repo |
| Gatekeeper/OPA | alternative policy engine reference |
| Trivy | configuration/image scanning gate |
| Cosign | signature verification/signing pattern |
| Falco | runtime detection option |
| NeuVector | Rancher/SUSE-aligned runtime security option |

The repository will add executable integration only when a selected technology is needed by a concrete profile. Until then these remain architecture placements, not mastery claims.
