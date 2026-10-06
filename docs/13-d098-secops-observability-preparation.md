# D-098 — Security / Observability / IAM Preparation Pack

**Status:** PREPARED / RUNTIME EXECUTION PENDING

## Goal

Prepare SQY-5 without duplicating specialist repositories or creating a new observability/security platform.

## Reuse map

| Capability | Canonical source | D-098 use |
|---|---|---|
| Prometheus / Grafana / alerts | Cluster Factory + workload stacks | platform operations |
| Shared tracing | `shared-platform-services-openshift` | OpenTelemetry contract/runtime evidence |
| Logging/search | `elk-log-data-platform` | incident log correlation |
| IAM / OIDC | `keycloak-enterprise-roadmap-v7` | identity, scopes, rotation, AD federation architecture |
| Kyverno | Cluster Factory + shared patterns | admission policy |
| Trivy / Cosign | `maya-secure-agentic-devsecops-platform` generic controls only | supply-chain proof |
| GitOps | `argocd-expert-pack` | policy/config delivery |

## SQY-5 minimum demonstration

### Observability
1. one disposable workload is healthy;
2. one bounded failure is injected;
3. Prometheus signal or Kubernetes event shows the failure;
4. Alertmanager receives or evaluates an alert when available;
5. the corresponding workload/platform log is found in the selected logging backend;
6. recovery clears the condition;
7. evidence correlates timestamps across alert/event/log.

### Container security
1. scan one selected image with Trivy;
2. record image digest;
3. capture SBOM if tooling is available;
4. apply a Kyverno policy to a disposable fixture;
5. prove one compliant workload admitted;
6. prove one violating workload denied;
7. add Cosign verification only after trust material and verification mode are explicitly chosen.

### IAM / secrets
1. OIDC discovery and JWKS reachable;
2. valid token path;
3. invalid audience denied;
4. insufficient scope/role denied;
5. bounded client secret rotation/replacement or a documented replay if the current lab is not safe to mutate;
6. no secret committed to Git.

## Alerting truth boundary

Prometheus metrics being visible is not the same as Alertmanager delivery being proven.
An alert rule file is not runtime evidence until evaluated/fired in the target environment.

## Logging truth boundary

A logging architecture is not a live logging proof.
The D-098 runtime gate requires one searchable incident log linked to the same incident timeline.

## Cosign truth boundary

Do not claim signature enforcement until:
- a signed image exists;
- trust material/identity is explicit;
- admission verification is wired;
- unsigned/untrusted control case is rejected.

## Gate

`CAAS_SECOPS_OBSERVABILITY_PACK_READY` only after observed runtime evidence closes all required slices.
