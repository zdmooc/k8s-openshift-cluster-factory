# D-098 — SQY-4 Pod / Deployment RCA — Runtime Proven

**Date:** 2026-10-06  
**Runtime:** OpenShift Local / CRC 4.22.7  
**Result:** `D098_N3_POD_DEPLOYMENT_RCA_RUNTIME_PROVEN=PASS`

## Context

The final SQY-4 pod/deployment scenario was executed as part of the bounded SQY-3 migration rehearsal
owned by `openshift-migration-framework`.

Canonical migration evidence:
`evidence/D098_SQY3_MIGRATION_RUNTIME_PROVEN_2026-10-06.md`.

## Healthy baseline

Disposable Deployment:
`d098-migration-pilot-api`.

Observed:
- Deployment successfully rolled out;
- pod 1/1 Running;
- Service endpoint on port 8080;
- OpenShift Route HTTP smoke PASS;
- SCC `restricted-v2`.

## Injection

The Deployment image was changed to:

`registry.access.redhat.com/ubi9/definitely-not-a-real-image:d098`.

Observed:
- replacement pod scheduled successfully;
- `ErrImagePull`;
- `ImagePullBackOff`;
- registry error: repository/image not found.

Marker:
`D098_MIGRATION_DEFECT_OBSERVED=PASS`.

## Diagnosis

Root cause:
invalid/nonexistent container image reference.

This is a workload release defect, not:
- scheduler capacity pressure;
- SCC rejection;
- NetworkPolicy/DNS failure;
- OpenShift control-plane failure.

## Service continuity

The previous healthy revision remained available through the Route while the new ReplicaSet was broken.

Marker:
`D098_MIGRATION_OLD_REVISION_STILL_SERVING=PASS`.

## Recovery

Executed:
`oc rollout undo deployment/d098-migration-pilot-api`.

Observed:
- approved image restored:
  `registry.access.redhat.com/ubi9/python-312:latest`;
- rollout succeeded;
- Route HTTP smoke succeeded after rollback;
- ClusterVersion and ClusterOperators remained healthy.

Markers:

```text
D098_MIGRATION_ROLLBACK=PASS
D098_MIGRATION_POST_ROLLBACK_SMOKE=PASS
D098_MIGRATION_REHEARSAL_RUNTIME_PROVEN=PASS
```

## Preventive controls

- immutable image references/digests;
- CI image existence and vulnerability checks;
- signed image verification;
- staged rollout with readiness gates;
- explicit rollback boundary;
- GitOps revision traceability.

## Truth boundary

This is a disposable single-node CRC/OpenShift Local scenario.
It does not imply production deployment rollback or multi-zone availability.

## Marker

`D098_N3_POD_DEPLOYMENT_RCA_RUNTIME_PROVEN=PASS`
