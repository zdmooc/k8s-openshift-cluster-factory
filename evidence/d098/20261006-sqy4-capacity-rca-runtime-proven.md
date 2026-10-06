# D-098 — SQY-4 N3 Capacity RCA — Runtime Proven

**Date:** 2026-10-06  
**Environment:** OpenShift Local / CRC 4.22.7  
**Scenario:** real scheduler capacity pressure after CRC was started at 16384 MiB  
**Result:** `D098_N3_CAPACITY_RECOVERY_VERIFY=PASS`

## Symptom

At 16384 MiB CRC memory:
- 238 pods scheduled;
- 34 pods unscheduled;
- scheduled memory requests: 22249 MiB;
- unscheduled memory requests: 8842 MiB;
- widespread `FailedScheduling / Insufficient memory`;
- platform and product impact included OpenShift GitOps, Keycloak, MQ,
  Instant Payments, Shared Platform, Shared Observability and TradeOps.

## Diagnosis

The OpenShift control plane itself remained healthy, but the single CRC worker/control-plane node
did not have enough allocatable memory for the aggregate workload requests.

This was a local lab capacity condition, not an OpenShift control-plane failure.

## First recovery attempt

The target was raised to 24576 MiB.

A first long-script attempt to invoke `crc start` hit a Git for Windows/MSYS process-buffer failure
(`TP_NUM_C_BUFS too small`).

That failure was classified separately as a local shell/process boundary, not as a CRC/OpenShift defect.

The recovery flow was then split:
1. set CRC memory while stopped;
2. run `crc start` manually from a fresh Git Bash terminal;
3. run `d098-n3-capacity-verify-after-manual-start.sh`.

## After state at 24576 MiB

Observed:
- CRC VM Running;
- OpenShift 4.22.7 Running;
- node `crc` Ready;
- all listed ClusterOperators Available=True / Progressing=False / Degraded=False;
- OpenShift GitOps server: 1/1 Ready;
- Mayabank Platform Operator: 1/1 Ready;
- Shared OTel Collector: 1/1 Ready;
- 269 pods scheduled;
- 1 pod unscheduled;
- scheduled memory requests: 30067 MiB;
- unscheduled memory requests: 1024 MiB.

Compared with the 16 GiB state:
- scheduled pod count increased by 31;
- unscheduled pod count fell from 34 to 1;
- unscheduled memory requests fell from 8842 MiB to 1024 MiB;
- 33 previously-unscheduled pods were recovered.

Residual conditions:
- `mayabank-mq-local/mq` remained Pending with current scheduler pressure;
- `instant-payments-local/redpanda-console` remained `ImagePullBackOff`, which is a separate image/repository/runtime issue and not attributed to memory capacity.

## RCA

**Root cause:** local single-node CRC capacity was undersized for the aggregate retained portfolio workloads at 16384 MiB.

**Recovery:** increase CRC VM memory to 24576 MiB and restart CRC from a fresh Windows/Git-Bash process boundary.

**Preventive controls:**
- inspect aggregate resource requests before loading multiple portfolio products;
- keep a workstation capacity envelope;
- distinguish platform/operator critical slices from optional demo workloads;
- scale down or stop unrelated workloads before runtime exercises when appropriate;
- preserve the Windows-safe manual CRC restart boundary.

## Truth boundary

This proves recovery from a local CRC scheduler-memory-pressure incident.

It does not prove:
- production OpenShift capacity planning;
- HA/failure-domain recovery;
- that every retained demo workload is healthy;
- that 24576 MiB is sufficient for all future combinations of workloads.

## Marker

`D098_N3_CAPACITY_RECOVERY_VERIFY=PASS`
