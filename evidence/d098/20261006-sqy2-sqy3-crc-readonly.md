# D-098 — SQY-2 / SQY-3 CRC Read-Only Runtime Evidence — 2026-10-06

**Environment:** OpenShift Local / CRC  
**OpenShift:** 4.22.7  
**Kubernetes:** v1.35.6  
**Context:** `crc-admin`  
**Execution mode:** read-only

## Result summary

### SQY-2

Observed current OpenShift platform state:

- ClusterVersion 4.22.7: Available=True / Progressing=False;
- all listed ClusterOperators: Available=True / Progressing=False / Degraded=False;
- node `crc`: Ready;
- Projects present for:
  - instant-payments-local;
  - openshift-gitops;
  - openshift-pipelines;
  - shared-identity;
  - shared-observability;
  - shared-platform-services;
  - tradeops;
  - mayabank-api;
  - mayabank-mq-local;
  - wero-poc;
- OpenShift Routes observed across product and platform namespaces;
- SCC catalog includes `restricted-v2` and `restricted-v3`;
- OLM Subscriptions observed for:
  - Red Hat OpenShift GitOps;
  - Red Hat OpenShift Pipelines;
  - Red Hat build of Keycloak;
- OpenShift GitOps Application
  `instant-payments-tech-lead-shared-platform` observed `Synced / Healthy`;
- `CapabilityConsumption/instant-payments-crc` observed in `Manage` mode.

The current `CapabilityConsumption` status was `Ready=False`.
Current events show resource pressure after CRC was deliberately started with 16384 MiB:
multiple product/platform pods are Pending with `Insufficient memory`, including the Platform Operator and Shared OTel.

This current capacity condition does not erase the prior D-093/I5 runtime evidence. D-098 therefore reuses:
- D-093 CRC GitOps reconciliation evidence;
- D-093 Platform Operator Observe -> Manage evidence;
- D-093 SCC/RBAC/NetworkPolicy evidence;
- D-093 Shared OIDC/OTel and product non-regression evidence.

Additional current incident findings:
- Redpanda Console: `ImagePullBackOff`;
- RHBK Operator CSV showed transient Installing/availability waits;
- several application startup probes failed while the node was resource constrained.

**SQY-2 conclusion:** `OPENSHIFT_CAAS_RUNTIME_PACK_READY`.

This means the mission evidence pack is ready. It does **not** mean every currently deployed CRC workload is healthy at 16 GiB.

## SQY-3 — upgrade readiness

Read-only upgrade assessment executed successfully.

Observed:
- channel: `stable-4.22`;
- available updates were retrieved;
- no upgrade was triggered;
- PDB inventory captured;
- Operator/CSV/InstallPlan state captured;
- storage, PVCs and node state captured.

### Upgrade blocker

ClusterVersion condition:

`Upgradeable=False / ClusterVersionOverridesSet`.

Message observed:
ownership disabled through ClusterVersion overrides prevents minor/major upgrades until the overrides are removed.

This is a valid upgrade-readiness finding and is intentionally **not** changed during the read-only assessment.

### SQY-3 conclusion

`D098_UPGRADE_READINESS_READONLY=PASS`

Status:
`RUNTIME_ASSESSED / UPGRADE_BLOCKER_IDENTIFIED / MIGRATION_REHEARSAL_PENDING`.

No OpenShift upgrade was attempted.

## Operational finding promoted to SQY-4

The 16 GiB CRC restart produced a real N3 capacity scenario:

`FailedScheduling -> Insufficient memory -> multiple platform/product replicas Pending`.

This is preferable to inventing an artificial failure. It will be used as the first D-098 N3/RCA case.

## Truth boundaries

- CRC is single-node and is not HA evidence.
- Current ClusterOperators are healthy, while several optional/product workloads are resource constrained.
- A read-only upgrade assessment is not an upgrade execution.
- Prior D-093 runtime evidence remains separately attributable to its original execution.
