# D-098 — SQY Runtime Execution Plan

**Status:** CLOSED FOR MISSION / OPTIONAL LOCAL RUNTIME OPERATIONS REMAIN  
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

### Windows / Git Bash CRC restart rule

On this workstation, a long-running Bash script must **not** invoke `crc start` after many prior
subprocesses/pipelines. One observed run failed inside Git for Windows/MSYS with:

`fatal error - Internal error: TP_NUM_C_BUFS too small: 50`.

For CRC memory/capacity recovery:
1. use `d098-n3-capacity-recovery.sh` only to capture BEFORE state, stop CRC and set target memory;
2. on Windows/Git Bash the script exits safely with `D098_N3_CAPACITY_PREPARED_FOR_MANUAL_START=PASS`;
3. open a fresh Git Bash terminal and run `crc start` interactively;
4. run `runtime/openshift/d098-n3-capacity-verify-after-manual-start.sh`.

This is a shell/process-boundary issue, not a valid OpenShift failure claim.

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

## 7. Optional return CRC -> Kind

The CRC -> Kind return is not required to close D-098 mission preparation. Keep CRC active when OpenShift-specific demonstration work is the priority.

When resuming the retained Data Lakehouse lab, use:

~~~bash
CONFIRM_DEMO_SWITCH=yes bash demo/scripts/01-switch-crc-to-kind.sh
bash demo/scripts/02-preflight.sh
~~~

If Polaris metadata is missing:

~~~bash
CONFIRM_DEMO_RECOVERY=yes bash demo/scripts/03-restore-i12.sh
~~~

This remains a bounded local-lab operation and metadata-only recovery of retained Iceberg state.

## 8. Final gates

After evidence review:

~~~text
SQY-2 -> OPENSHIFT_CAAS_RUNTIME_PACK_READY
SQY-3 -> LIFECYCLE_UPGRADE_MIGRATION_PACK_READY
SQY-4 -> N3_RCA_PACK_RUNTIME_PROVEN
SQY-5 -> CAAS_SECOPS_OBSERVABILITY_PACK_READY
SQY-7 -> IT_EXPLORER_SQY_PORTFOLIO_READY / CLOSED
D-098 -> D098_MISSION_PREPARATION=CLOSED
~~~

No gate is promoted merely because a script exists.
