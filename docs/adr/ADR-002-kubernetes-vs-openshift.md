# ADR-002 — Kubernetes upstream vs Red Hat OpenShift

Date: 2026-10-04  
Status: ACCEPTED AS DECISION FRAME

## Context

A private/hybrid infrastructure may host upstream Kubernetes or an enterprise distribution such as OpenShift. The choice affects lifecycle, security, integration and support.

## Decision

Use explicit decision criteria rather than selecting a platform by habit.

Evaluate:
- enterprise support and lifecycle;
- identity/RBAC integration;
- policy/security baseline;
- registry/build capabilities;
- Operators;
- observability integration;
- storage/network ecosystem;
- GitOps/automation;
- upgrade and Day-2 operations;
- skills and licensing.

OpenShift is preferred when the organization values an integrated enterprise platform and supported lifecycle sufficiently to justify its operational/licensing model.

Upstream/RKE2-style Kubernetes remains valid when a lighter stack, different support model or infrastructure constraints dominate.

## Consequences

The Cluster Factory keeps a provider/distribution-neutral contract while OpenShift-specific standards remain in `openshift-platform-blueprints`.

## Evidence boundary

Kind runtime proves Kubernetes factory mechanics. OpenShift Local/CRC proofs elsewhere in the portfolio do not prove an enterprise multi-node OpenShift production topology.
