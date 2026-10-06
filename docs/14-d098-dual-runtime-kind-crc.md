# D-098 — Dual Local Runtime Strategy: Kind <-> CRC

**Status:** OPERATING MODEL READY / SWITCH MECHANISM ALREADY PROVEN BY DATA LAKEHOUSE H2

## Principle

The workstation does not need Kind Data Lakehouse and CRC/OpenShift to run as heavy runtimes at the same time.

~~~text
Kind / edl-lab active
   -> stop exact Kind node containers, do not delete cluster
   -> start CRC / OpenShift Local
   -> execute OpenShift-specific evidence
   -> stop CRC
   -> restart exact Kind node containers
   -> validate retained Data Lakehouse state
~~~

## Why two runtimes

### Kind
Used for:
- multi-node Kubernetes factory mechanics;
- 1 control-plane + 2 workers;
- Data Lakehouse workload;
- scheduling/distribution;
- generic Kubernetes GitOps/NetworkPolicy/runtime evidence.

### CRC / OpenShift Local
Used for:
- Projects;
- Routes;
- SCC;
- Operators/OLM;
- OpenShift GitOps;
- Platform Operator consumer onboarding;
- OpenShift-specific security and lifecycle checks.

## Safety rules

- never use `kind delete cluster` for a normal switch;
- verify kube/oc context before every runtime test;
- do not source scripts that enable `set -euo pipefail` into an interactive shell; execute them as scripts/subshells;
- preserve retained Data Lakehouse storage;
- stop one heavy runtime before starting the other when workstation capacity requires it.

## Data Lakehouse recovery boundary

The Data Lakehouse H2 proof already demonstrated:
- exact Kind containers stopped and restarted;
- preserved node IP mapping;
- retained S3/Iceberg data;
- no Kafka replay;
- no Spark rewrite;
- no S3/Iceberg rewrite;
- metadata-only Polaris registration when the in-memory catalog was empty.

Polaris in-memory metadata remains a lab limitation.

## D-098 runtime discipline

Use:
- SQY-2, SQY-3, SQY-4, SQY-5 OpenShift-specific checks -> CRC;
- Data Lakehouse workload proof -> Kind;
- final presentation -> combine evidence, not runtimes.

This is a deliberate dual-runtime lab strategy, not a production topology claim.
