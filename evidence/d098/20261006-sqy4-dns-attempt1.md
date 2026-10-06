# D-098 — SQY-4 DNS / NetworkPolicy Attempt 1

**Date:** 2026-10-06  
**Status:** BASELINE_AND_DENY_PROVEN / RECOVERY_FAILED / FIX_PREPARED

## Baseline

Disposable namespace:
`d098-n3-dns`.

DNS baseline succeeded:

`kubernetes.default.svc.cluster.local -> 10.217.4.1`.

Marker:
`D098_DNS_BASELINE=PASS`.

## Injection

A deny-all egress NetworkPolicy was applied.

DNS resolution failed as expected.

Marker:
`D098_DNS_DENIED_BY_NETWORKPOLICY=PASS`.

## Recovery attempt 1

The first recovery policy allowed TCP/UDP destination port 53 only.

DNS did not recover.

This is a useful OpenShift-specific finding:
the DNS Service exposes port 53, while OVN-Kubernetes policy evaluation may see the post-DNAT DNS pod target port.

## Correction

The fixture was corrected to:
- target namespace `openshift-dns`;
- allow TCP/UDP 53;
- allow TCP/UDP 5353;
- capture `dns-default` Service and Endpoints;
- capture pod `/etc/resolv.conf`;
- add `runAsNonRoot=true` and `RuntimeDefault` seccomp to remove the PodSecurity warning.

Corrected script:
`runtime/openshift/d098-n3-dns-networkpolicy-fixture.sh`.

## Claim boundary

No DNS recovery PASS is claimed from attempt 1.

Status:
`D098_N3_DNS_NETWORKPOLICY=REVALIDATION_PENDING`.
