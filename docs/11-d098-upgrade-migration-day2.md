# D-098 — Upgrade, Migration and Day-2 Pack

**Status:** DESIGN_READY / RUNTIME EXECUTION PENDING WHERE NOT ALREADY PROVEN

## Goal

Provide one mission-facing lifecycle model linking cluster upgrades, workload migrations, maintenance,
incident handling and evidence.

## Lifecycle flow

~~~text
Assess
 -> compatibility
 -> prechecks
 -> maintenance/change approval
 -> non-prod/canary
 -> execute
 -> observe convergence
 -> smoke
 -> evidence
 -> promote or recover
~~~

## OpenShift upgrade gate

### Before
- capture `clusterversion`, `clusteroperators`, nodes and MachineConfigPools;
- inspect available/supported update path;
- inspect Operator Subscriptions, CSVs and InstallPlans;
- detect deprecated/removed APIs used by workloads;
- validate ingress, DNS, storage and monitoring;
- check capacity/PDB constraints;
- confirm stateful backup/restore responsibilities;
- select critical workload smoke tests.

### During
- follow supported update graph;
- observe ClusterVersion progression;
- observe ClusterOperators and MachineConfigPools;
- do not force a second hop before convergence;
- retain incident timeline and events.

### After
- all expected nodes Ready;
- ClusterOperators Available and not Degraded beyond accepted exceptions;
- ingress/routes, DNS and storage functional;
- Argo applications reconcile;
- SCC/RBAC/NetworkPolicy behavior unchanged;
- smoke tests pass;
- evidence bundle stored.

## Recovery model

OpenShift cluster downgrade is not treated as a generic rollback mechanism.

Recovery choices are component-specific:
- pause further upgrade hops;
- restore workload configuration through Git;
- restore a failed product release independently;
- restore state from validated backup where applicable;
- use vendor-supported cluster recovery procedures for platform failures.

## Workload migration integration

The canonical workload migration owner is `openshift-migration-framework`.

The migration sequence is:
`inventory -> assess -> target readiness -> dry-run -> cutover -> hypercare -> decommission`.

Cluster lifecycle and workload migration must not be conflated:
- cluster upgrade changes the execution platform;
- workload migration changes where/how an application runs;
- both require independent rollback/recovery boundaries.

## Day-2 minimum controls

- node drain/uncordon;
- certificate/secret expiry visibility;
- storage capacity and PVC health;
- API/DNS/ingress health;
- policy/admission visibility;
- GitOps drift visibility;
- alert/log/trace correlation;
- incident evidence capture.

## Evidence template

Each execution record should capture:
- environment/context;
- before/after versions;
- start/end timestamps;
- precheck outputs;
- compatibility decisions;
- deviations;
- recovery actions;
- smoke results;
- final claim level.

## Gate

`LIFECYCLE_UPGRADE_MIGRATION_PACK_READY` is architecture/runbook-ready now.
Runtime promotion requires an observed execution and an evidence file.
