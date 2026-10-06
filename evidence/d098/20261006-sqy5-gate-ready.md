# D-098 — SQY-5 Security / Observability / IAM Gate

**Date:** 2026-10-06  
**Status:** `CAAS_SECOPS_OBSERVABILITY_PACK_READY=TRUE`

## Runtime observability

CRC/OpenShift evidence:
- Alertmanager running;
- Prometheus running;
- Prometheus alert API queried successfully;
- PrometheusRule inventory captured;
- Alloy running;
- Loki running and Ready;
- live Loki query returned product log streams;
- Shared OTel Collector running 1/1.

Evidence:
- `evidence/d098/20261006-sqy5-observability-runtime-proven.md`.

## OpenShift admission security

Disposable server-side admission proof:
- compliant pod accepted;
- privileged pod rejected by SCC;
- `restricted-v2` and `restricted-v3` observed.

Evidence:
- `evidence/d098/20261006-sqy5-scc-admission-runtime-proven.md`.

## IAM / secrets

Reused runtime evidence from Instant Payments I22:
- OAuth2 client credentials;
- anonymous request denied;
- least-privilege negative authorization;
- secured E2E;
- client-secret rotation;
- old secret rejected;
- new secret accepted.

Reused D-093/I33 evidence:
- Shared Keycloak/OIDC;
- real payment-orchestrator trace through Shared OTel.

Vault/CyberArk remains an integration pattern, not a runtime claim.

## Supply-chain security

Canonical specialist:
`maya-secure-agentic-devsecops-platform`.

Public GitHub Actions run:
`37517552045`.

Head:
`e4f73d3e66f4aa1c751273276b2df198ef8c709e`.

Observed successful proof:
- Trivy 0.70.0 image scan;
- immutable OCI digest;
- Cosign v2.4.3 sign/verify;
- negative verification with an untrusted key;
- Kyverno v1.19.1 positive policy evaluation;
- Kyverno negative mutable-tag policy evaluation.

Specialist evidence:
`evidence/D098_SUPPLY_CHAIN_PROOF_2026-10-06.md`.

## Gate decision

The D-098 mission pack now has evidence for:
- metrics/alerting;
- live searchable logs;
- OpenShift admission security;
- OAuth2/OIDC and secret rotation;
- tracing;
- image scanning;
- image signing/verification;
- policy-as-code positive/negative behavior.

Therefore:

`CAAS_SECOPS_OBSERVABILITY_PACK_READY=TRUE`.

## Truth boundaries

This does not claim:
- production alert paging/on-call integration;
- production log retention;
- production Vault/CyberArk runtime;
- cluster-side Kyverno webhook runtime on CRC;
- enterprise HSM/KMS signing;
- multi-cluster security enforcement.

The cluster-side admission runtime proof is SCC; the Kyverno proof is a bounded CI policy-as-code evaluation.
