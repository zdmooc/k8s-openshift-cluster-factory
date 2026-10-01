# Cluster Factory Gates

**Date:** 2026-10-01

A cluster profile progresses through explicit gates.

| Gate | Required evidence |
|---|---|
| G0 PROFILE_DEFINED | profile passes schema validation |
| G1 CONFIG_RENDERED | provider/runtime configuration renders successfully |
| G2 CLUSTER_CREATED | cluster API reachable and nodes Ready |
| G3 BASELINE_APPLIED | namespace/RBAC/quota/network/security baseline applied |
| G4 HEALTHCHECK_PASS | healthcheck and smoke tests pass |
| G5 EVIDENCE_CAPTURED | version/nodes/resources/policies exported |
| G6 DAY2_TESTED | controlled maintenance/drain/upgrade scenario validated where applicable |
| G7 RETIRED | cluster destroyed/decommissioned and evidence closed |

## Truth boundary

- CI Kind can prove local Kubernetes lifecycle and multi-node mechanics.
- CI Kind does not prove OpenShift.
- CRC proves OpenShift Local only.
- RKE2/Rancher docs are `REFERENCE` until executed.
- Cloud Terraform contracts are not cloud provisioning evidence.
