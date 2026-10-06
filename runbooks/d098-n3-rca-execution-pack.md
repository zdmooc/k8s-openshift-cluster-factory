# D-098 — N3 / Troubleshooting / RCA Execution Pack

**Status:** CLOSED / N3_RCA_PACK_RUNTIME_PROVEN

Each scenario follows:
`inject/real incident -> observe -> diagnose -> RCA -> recover -> prevent -> evidence`.

## Scenario 0 — Capacity pressure (real incident) — RUNTIME PROVEN

Observed on CRC at 16384 MiB:
- 34 unscheduled pods;
- 8842 MiB unscheduled memory requests;
- broad FailedScheduling/Insufficient memory impact.

Recovered at 24576 MiB:
- 1 unscheduled pod;
- 1024 MiB unscheduled memory requests;
- GitOps server, Platform Operator and OTel Collector 1/1 Ready.

Evidence:
`evidence/d098/20261006-sqy4-capacity-rca-runtime-proven.md`.

This real incident replaces the need to manufacture a scheduler-memory fault.

## Scenario 1 — DNS / NetworkPolicy — RUNTIME PROVEN

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

Attempt 1:
- baseline DNS PASS;
- deny-all egress PASS;
- first recovery allowing port 53 only FAILED;
- OpenShift DNS target-port behavior identified as the missing recovery detail.

Correction:
allow `openshift-dns` namespace on TCP/UDP 53 and 5353 and capture the DNS Service/Endpoints.

Evidence:
`evidence/d098/20261006-sqy4-dns-attempt1.md`.

Corrected automation:
`runtime/openshift/d098-n3-dns-networkpolicy-fixture.sh`.

Runtime evidence:
`evidence/d098/20261006-sqy4-dns-networkpolicy-runtime-proven.md`.

Observed marker:
`D098_N3_DNS_NETWORKPOLICY_RUNTIME_PROVEN=PASS`.

Residual live triage:
`runtime/openshift/d098-residual-triage.sh`.

Supplementary real ImagePullBackOff RCA:
`evidence/d098/20261006-redpanda-imagepullbackoff-rca.md`.

Observed root cause: unauthenticated external registry pull-rate limit.
Recovery remains intentionally separate from the core gate.

## Scenario 2 — Pod / Deployment failure — RUNTIME PROVEN

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

Disposable pod/deployment automation:
`runtime/openshift/d098-n3-pod-deployment-fixture.sh`.

The bounded scenario was executed through the SQY-3 migration rehearsal:
- healthy Route smoke;
- invalid image injection;
- `ErrImagePull/ImagePullBackOff`;
- previous revision kept serving;
- `oc rollout undo`;
- approved image restored;
- post-rollback smoke PASS.

Runtime evidence:
`evidence/d098/20261006-sqy4-pod-deployment-rca-runtime-proven.md`.

## Scenario 3 — PVC / storage — RUNTIME PROVEN

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

Disposable storage automation:
`runtime/openshift/d098-n3-storage-fixture.sh`.

Runtime evidence:
`evidence/d098/20261006-sqy4-storage-rca-runtime-proven.md`.

Observed marker:
`D098_N3_STORAGE_RCA_RUNTIME_PROVEN=PASS`.

## Scenario 4 — OIDC / telemetry — RUNTIME PROVEN BY REUSE

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

Reused runtime evidence:
- I22 OAuth2/JWT: anonymous denied, wrong-scope 403, least-privilege enforcement, client-secret rotation with old secret rejected and new secret accepted;
- D-093/I33: authenticated product request produced a real `payment-orchestrator` trace in Shared OTel and collector configuration was restored.

This satisfies the identity/telemetry RCA slice without manufacturing a second destructive fault.

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

All required core slices are now evidenced:
- DNS/NetworkPolicy;
- pod/deployment;
- PVC/storage;
- OIDC/telemetry.

Supplementary real incident:
- CRC scheduler memory pressure/capacity recovery.

Final gate:
`N3_RCA_PACK_RUNTIME_PROVEN=TRUE`.
