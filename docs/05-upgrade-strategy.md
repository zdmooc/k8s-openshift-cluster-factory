# 05 — Upgrade Strategy

**Status:** REFERENCE / DAY-2 STANDARD

## Objective

Keep clusters on supported versions and perform upgrades as controlled platform changes with explicit prechecks, compatibility validation, workload smoke tests and recovery planning.

## Important distinction

A generic "rollback" statement is not sufficient.

For OpenShift in particular, a normal cluster downgrade is **not** treated as the standard recovery path. Recovery planning must instead consider:

- supported update paths and channels;
- pausing before the next hop;
- operator compatibility;
- backup/restore where applicable;
- workload rollback independent from cluster version;
- vendor-supported recovery procedures for failed updates.

## Generic upgrade gate

1. verify current health;
2. confirm target version is supported from the current version;
3. validate CNI/CSI/operator/addon compatibility;
4. validate available capacity and disruption budget;
5. confirm backup/restore readiness for stateful dependencies;
6. communicate maintenance scope;
7. execute on canary/non-production first;
8. validate control plane, nodes, DNS, ingress, storage and policy components;
9. run workload smoke tests;
10. capture evidence and only then promote the next environment.

## OpenShift specifics

Before an OpenShift update:

- check `ClusterVersion` and available updates;
- inspect all `ClusterOperator` conditions;
- review admin acknowledgements and blocked updates;
- validate Operator Lifecycle Manager subscriptions/install plans;
- validate MachineConfigPool state;
- verify storage and ingress health;
- check deprecated/removed APIs relevant to workloads;
- confirm monitoring/alerting visibility during the change.

During and after the update:

- follow the supported update graph/channel;
- observe control-plane/operator convergence;
- verify MachineConfigPools;
- verify nodes Ready and workloads recovered;
- validate API, DNS, routes/ingress, CSI and critical operators;
- run agreed smoke tests.

## Kubernetes/RKE2 specifics

For upstream Kubernetes/RKE2:

- respect version-skew rules;
- upgrade control-plane/server nodes before or according to distribution guidance;
- drain/uncordon workers in a controlled sequence;
- preserve etcd snapshots and restore procedures;
- validate CNI/CSI compatibility;
- test Rancher compatibility before managed RKE2 upgrades.

## Evidence

Each upgrade record should include:

- before/after versions;
- precheck output;
- affected nodes/operators;
- start/end timestamps;
- smoke-test results;
- incidents or deviations;
- recovery actions if any.

See `runbooks/change-upgrade-checklist.md`.
