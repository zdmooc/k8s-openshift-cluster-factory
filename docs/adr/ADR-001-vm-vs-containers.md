# ADR-001 — VM hosting vs container platform

Date: 2026-10-04  
Status: ACCEPTED AS DECISION FRAME

## Context

Modernization programs often mix legacy VM workloads and cloud-native workloads. A blanket "containerize everything" decision creates migration and operational risk.

## Decision

Use workload characteristics to choose the hosting model.

Keep or modernize on VM when:
- OS coupling is strong;
- vendor support requires VM;
- privileged/kernel dependencies prevent safe containerization;
- migration value is low relative to risk.

Prefer Kubernetes/OpenShift when:
- horizontal scaling and immutable delivery add value;
- application lifecycle can be containerized;
- standardized health/readiness, policy and observability are useful;
- deployment frequency or portability justify platform overhead.

Use hybrid placement when stateful or external middleware remains outside the cluster while application services move to Kubernetes/OpenShift.

## Consequences

- migration becomes workload-driven rather than ideology-driven;
- VM and Kubernetes operating models coexist during transition;
- inventory and dependency analysis are mandatory;
- rollback remains possible for migration waves.

## Evidence boundary

This ADR is an architecture decision framework, not proof of a client migration.
