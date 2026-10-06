# D-098 — SQY-4 DNS / NetworkPolicy RCA — Runtime Proven

**Date:** 2026-10-06  
**Runtime:** OpenShift Local / CRC 4.22.7  
**Result:** `D098_N3_DNS_NETWORKPOLICY_RUNTIME_PROVEN=PASS`

## Baseline

Disposable namespace:
`d098-n3-dns`.

Baseline resolution succeeded:

`kubernetes.default.svc.cluster.local -> 10.217.4.1`.

Marker:
`D098_DNS_BASELINE=PASS`.

## Injection

A deny-all egress NetworkPolicy was applied.

DNS resolution then failed as expected.

Marker:
`D098_DNS_DENIED_BY_NETWORKPOLICY=PASS`.

## Diagnosis

OpenShift DNS Service observed:
- Service `dns-default`;
- ClusterIP `10.217.4.10`;
- Service port 53/UDP and 53/TCP;
- backing endpoint on pod-side target port 5353.

The first recovery attempt that allowed only destination port 53 was insufficient.

## Recovery

The corrected recovery policy:
- targeted namespace `openshift-dns`;
- allowed TCP/UDP 53;
- allowed TCP/UDP 5353.

DNS resolution recovered successfully.

Marker:
`D098_DNS_RECOVERED=PASS`.

## Additional finding

An attempt to read `/etc/resolv.conf` from the container emitted a Git-for-Windows path translation warning:

`cat: 'C:/Program Files/Git/etc/resolv.conf': No such file or directory`.

This did not affect the network proof and is classified as a local MSYS path-conversion issue.

## RCA

**Root cause:** egress NetworkPolicy blocked required DNS flow; the first recovery rule was incomplete for the OpenShift DNS target-port behavior.

**Prevention:** validate both Service and endpoint/target-port behavior when authoring OpenShift egress policy.

## Truth boundary

This proves a disposable OpenShift Local NetworkPolicy/DNS incident and recovery.

It does not prove:
- production DNS HA;
- multi-node OVN-Kubernetes failure recovery;
- external corporate DNS dependencies.

## Marker

`D098_N3_DNS_NETWORKPOLICY_RUNTIME_PROVEN=PASS`
