# D-098 — SQY-5 OpenShift SCC Admission — Runtime Proven

**Date:** 2026-10-06  
**Runtime:** OpenShift Local / CRC 4.22.7  
**Result:** `D098_SCC_ADMISSION_RUNTIME_PROVEN=PASS`

## Positive case

A disposable ServiceAccount in namespace `d098-scc-admission` was granted only pod creation rights.

A compliant pod definition was evaluated with server-side dry-run and was admitted.

Observed marker:

`D098_SCC_COMPLIANT_ADMISSION=PASS`.

## Negative case

A second disposable pod requested:

`securityContext.privileged: true`.

The OpenShift API rejected the pod with an SCC validation error.

Observed:
- `restricted-v2`: privileged containers not allowed;
- `restricted-v3`: privileged containers not allowed;
- privileged SCC not usable by the ServiceAccount.

Observed marker:

`D098_SCC_PRIVILEGED_DENIED=PASS`.

## SCC catalog

Observed restricted profiles:
- `restricted-v2`;
- `restricted-v3`.

## Conclusion

This proves a positive and negative OpenShift admission-security control on CRC.

It does not prove:
- production cluster-wide policy governance;
- Kyverno image verification;
- privileged workload exception approval;
- multi-cluster enforcement.

## Marker

`D098_SCC_ADMISSION_RUNTIME_PROVEN=PASS`
