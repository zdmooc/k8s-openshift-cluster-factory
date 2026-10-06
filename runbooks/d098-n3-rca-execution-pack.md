# D-098 — N3 / Troubleshooting / RCA Execution Pack

**Status:** PREPARED / RUNTIME EXECUTION PENDING

Each scenario follows:
`inject -> observe -> diagnose -> RCA -> recover -> prevent -> evidence`.

## Scenario 1 — DNS / NetworkPolicy

Injection options:
- deny egress to DNS on an isolated fixture namespace; or
- apply an intentionally incomplete allow policy to a disposable test workload.

Observe:
- resolution timeout;
- application connection errors;
- NetworkPolicy state/events.

Diagnose:
- verify DNS pods/services;
- test direct ClusterIP then service-name resolution;
- inspect namespace/pod selectors and egress rules.

Recover:
- restore explicit DNS egress and required workload flow.

RCA expected:
policy blocked a required dependency while DNS/control plane remained healthy.

## Scenario 2 — Pod / Deployment failure

Injection:
- invalid image tag or failed readiness probe on a disposable fixture.

Observe:
- ImagePullBackOff / unavailable replica / failed readiness.

Diagnose:
- `oc describe pod`;
- events;
- image/reference/probe configuration;
- ReplicaSet and rollout status.

Recover:
- revert Git revision / corrected manifest and reconcile via GitOps.

## Scenario 3 — PVC / storage

Injection:
- isolated fixture with impossible StorageClass or bounded mount/config error.

Observe:
- Pending PVC / Pending pod / mount error.

Diagnose:
- PVC/PV/StorageClass;
- events;
- CSI components when applicable;
- access mode/capacity/topology.

Recover:
- restore supported StorageClass or fixture configuration.

Do not manipulate retained business data.

## Scenario 4 — OIDC or telemetry

Injection:
- disposable wrong issuer/audience, or isolated telemetry endpoint misconfiguration.

Observe:
- 401/403, JWKS/issuer error, or missing trace/metric.

Diagnose:
- discovery/JWKS reachability;
- token claims/scopes;
- NetworkPolicy;
- collector/exporter health.

Recover:
- restore canonical identity/telemetry contract.

## Evidence bundle per incident

Capture:
- timestamp;
- Git revision;
- kube context;
- exact injected change;
- symptoms;
- commands and relevant outputs;
- root cause;
- recovery;
- preventive control;
- final health;
- truth boundary.

## Safety

Only disposable fixtures are intentionally broken.
Never inject failures into retained stateful business data without explicit approval.

## Gate

After all four scenarios are executed and evidenced:
`N3_RCA_PACK_RUNTIME_PROVEN`.
