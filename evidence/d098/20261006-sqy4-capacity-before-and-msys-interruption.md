# D-098 — SQY-4 N3 Capacity Incident — Windows restart interruption

**Date:** 2026-10-06  
**Status:** BEFORE_CAPTURED / CRC_STOPPED / MANUAL_RESTART_REQUIRED

## Real incident before remediation

CRC was running at 16384 MiB.

Observed before restart:
- 238 scheduled pods;
- 34 unscheduled pods;
- scheduled memory requests: 22249 MiB;
- unscheduled memory requests: 8842 MiB;
- many `FailedScheduling / Insufficient memory` events;
- affected scopes included OpenShift GitOps, Instant Payments, Keycloak, MQ,
  Shared Platform, Shared Observability and TradeOps.

This is a valid N3 capacity-pressure scenario.

## Recovery attempt

Target CRC memory:
`24576 MiB`.

The script successfully:
1. captured the BEFORE state;
2. stopped CRC;
3. set the target memory configuration.

Then Git for Windows/MSYS itself failed while the Bash script invoked `crc start`:

```text
fatal error - Internal error: TP_NUM_C_BUFS too small: 50
Hangup crc start
```

The attempted automatic fallback configuration command was also interrupted by the same Bash/MSYS process failure.

## Classification

The MSYS/Bash failure is **not** classified as an OpenShift/CRC platform failure.
It is a local shell/process-execution issue.

The capacity incident remains valid; its recovery proof is pending.

## Corrected recovery path

Repository fix:
- `runtime/openshift/d098-n3-capacity-recovery.sh` no longer runs `crc start` from the long script on Windows Git Bash;
- `runtime/openshift/d098-n3-capacity-verify-after-manual-start.sh` validates the recovery after an interactive manual `crc start`.

Expected continuation:
1. confirm/set CRC memory to 24576 MiB while CRC is stopped;
2. run `crc start` manually from a fresh Git Bash terminal;
3. execute the verifier;
4. compare Pending pods and memory requests;
5. promote the RCA only if recovery evidence supports it.

## Truth boundary

No recovery PASS is claimed yet.
