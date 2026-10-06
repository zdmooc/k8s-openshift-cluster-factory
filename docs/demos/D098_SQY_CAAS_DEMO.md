# D-098 — Expert Kubernetes / OpenShift SQY — Demo Storyline

**Target duration:** 10–15 minutes  
**Audience:** recruiter, platform lead, infrastructure architect, OpenShift operations team

## 1 — Mission framing

Core message:
**I design and operate the CaaS platform; the Data Lakehouse is one workload proving that the platform can host a complex stack.**

## 2 — CaaS architecture

Show:
- infrastructure contracts;
- OpenShift cluster layer;
- GitOps;
- security/IAM;
- network/storage;
- observability;
- Day-2/N3.

## 3 — OpenShift-specific proof

Use CRC evidence:
- SCC `restricted-v2`;
- Projects/Namespaces;
- Argo Synced/Healthy;
- Platform Operator consumer onboarding;
- RBAC/NetworkPolicy;
- Shared OIDC/OTel.

## 4 — GitOps proof

Show drift -> detection -> self-heal, prune and rollback evidence already captured in D-093.

## 5 — Day-2 / N3

Explain the four D-098 incident scenarios and the RCA method.

## 6 — Upgrade / migration

Explain:
- supported update path;
- Operator/CRD/deprecated API checks;
- pre/post checks;
- workload migration waves;
- rollback/recovery boundary.

## 7 — Enterprise extensions

Position without false claims:
- RKE2/Rancher;
- Cilium/BGP/F5;
- CSI/Longhorn/Portworx/Trident;
- AD/CMDB integration.

## 8 — Complex workload proof

Use only 1–2 slides:
`Kafka -> Spark -> Iceberg/S3 -> Polaris -> Trino -> Jupyter` on 3-node Kind.

Observed gate:
3 Ready nodes / 45 healthy-completed pods / 7 PVC / 2 Argo Apps Synced-Healthy / 6 SQL rows.

## 9 — Truth boundaries

- CRC single-node != HA production;
- Kind multi-node != OpenShift production;
- reference technologies are not claimed runtime;
- no customer topology is inferred.

## Signature

**Zidane Djamal**  
Architecte Solutions / Technique & Transverse  
Kubernetes · OpenShift · CaaS · GitOps · Security · Day-2 / N3
