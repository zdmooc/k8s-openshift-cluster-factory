# D-098 — SQY Runtime Execution Plan

**Status:** PREPARED / USER-ASSISTED LOCAL EXECUTION REQUIRED  
**Workstation:** Windows + Git Bash + Docker Desktop + CRC/OpenShift Local

This plan is intentionally split into read-only capture first, then bounded runtime tests.

## 0. Preconditions

Do not source repository helper files that enable `set -euo pipefail` into the interactive shell.
Execute scripts as child processes.

Before switching:
- save/close unrelated terminal work;
- confirm no important port-forward/session depends on Kind;
- ensure Git worktrees are clean or understood;
- do not delete Kind or CRC.

## 1. Switch Kind -> CRC

From `enterprise-data-lakehouse-kubernetes-openshift`, branch `runtime/kind-edl-lab`:

~~~bash
git pull --ff-only origin runtime/kind-edl-lab
CONFIRM_DEMO_SWITCH=yes bash demo/scripts/00-switch-kind-to-crc.sh
~~~

Expected:
- retained Kind node containers stopped, not deleted;
- CRC Running;
- context `crc-admin`;
- OpenShift node Ready.

Stop immediately if the switch helper fails. Its failure trap attempts to restore Kind.

## 2. SQY-2 — CaaS / OpenShift read-only capture

From `k8s-openshift-cluster-factory`:

~~~bash
git pull --ff-only origin main
bash runtime/openshift/d098-sqy-readonly-assessment.sh
~~~

Then from `shared-platform-services-openshift`:

~~~bash
git pull --ff-only origin main
bash scripts/d098-sqy-readonly-evidence.sh
~~~

Capture:
- ClusterVersion / ClusterOperators;
- Projects;
- Routes;
- SCC;
- OLM Subscriptions / CSV / InstallPlans;
- StorageClasses / PVC;
- NetworkPolicies;
- Argo Applications;
- CapabilityConsumption objects.

No mutation is required for this first pass.

## 3. SQY-3 — Upgrade readiness

From `k8s-openshift-cluster-factory`:

~~~bash
bash runtime/openshift/d098-upgrade-readiness.sh
~~~

This command is read-only. It must **not** trigger `oc adm upgrade --to...`.

Review:
- available update path;
- degraded Operators;
- MachineConfigPools;
- APIRequestCounts / deprecated API usage when available;
- Operator compatibility;
- PDB/capacity;
- storage.

### Migration rehearsal

Follow:
`openshift-migration-framework/migration/runbooks/D098_SQY_REHEARSAL.md`.

Use only the disposable fixture. No retained payment/Data/MQ state.

## 4. SQY-4 — N3 / RCA

Follow:
`runbooks/d098-n3-rca-execution-pack.md`.

Execute one scenario at a time:
1. DNS / NetworkPolicy;
2. pod/deployment;
3. PVC/storage;
4. OIDC or telemetry.

For each scenario, copy:
`evidence/D098_SQY_RUNTIME_EVIDENCE_TEMPLATE.md`
to a timestamped evidence record.

Do not execute multiple failure injections concurrently.

## 5. SQY-5 — Security / Observability / IAM

First, inventory only:

~~~bash
bash scripts/bash/d098-secops-observability-preflight.sh
~~~

Then use:
- Shared Platform D-098 runtime pack;
- Keycloak D-098 IAM/secrets pack;
- ELK D-098 logging integration;
- Secure DevSecOps D-098 generic supply-chain reuse;
- Argo D-098 GitOps evidence reuse.

Minimum live proof:
- one alert/event/log correlation;
- one Trivy scan;
- one Kyverno positive + negative admission case;
- OIDC positive + negative validation;
- Cosign only if trust/signature enforcement is actually wired.

## 6. Capture final CRC health

~~~bash
oc get clusterversion
oc get clusteroperators
oc get nodes -o wide
oc get pods -A
oc get events -A --sort-by=.lastTimestamp | tail -100
~~~

Sanitize any evidence before commit.

## 7. Return CRC -> Kind

From `enterprise-data-lakehouse-kubernetes-openshift`:

~~~bash
CONFIRM_DEMO_SWITCH=yes bash demo/scripts/01-switch-crc-to-kind.sh
bash demo/scripts/02-preflight.sh
~~~

If Polaris metadata is missing:

~~~bash
CONFIRM_DEMO_RECOVERY=yes bash demo/scripts/03-restore-i12.sh
~~~

This is metadata-only recovery of retained Iceberg state.

## 8. Final gates

After evidence review:

~~~text
SQY-2 -> OPENSHIFT_CAAS_RUNTIME_PACK_READY
SQY-3 -> LIFECYCLE_UPGRADE_MIGRATION_PACK_READY
SQY-4 -> N3_RCA_PACK_RUNTIME_PROVEN
SQY-5 -> CAAS_SECOPS_OBSERVABILITY_PACK_READY
SQY-7 -> IT_EXPLORER_SQY_PORTFOLIO_READY
~~~

No gate is promoted merely because a script exists.
