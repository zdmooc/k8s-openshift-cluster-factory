# D-098 — SQY-4 Storage RCA — Runtime Proven

**Date:** 2026-10-06  
**Runtime:** OpenShift Local / CRC 4.22.7  
**Result:** `D098_N3_STORAGE_RCA_RUNTIME_PROVEN=PASS`

## Injection

A disposable namespace `d098-n3-storage` was created.

A PVC was intentionally created with the nonexistent StorageClass:

`d098-nonexistent-storageclass`.

Observed:
- PVC phase: `Pending`;
- event: `ProvisioningFailed`;
- controller message: StorageClass not found.

## RCA

Root cause:

`StorageClass 'd098-nonexistent-storageclass' does not exist`.

The failure was isolated to the disposable fixture and did not touch retained business data.

## Recovery

The bad PVC was deleted.

A replacement PVC was created with the valid CRC class:

`crc-csi-hostpath-provisioner`.

A disposable consumer pod triggered provisioning because the class uses
`WaitForFirstConsumer`.

Observed recovery:
- PVC phase: `Bound`;
- provisioner: `kubevirt.io.hostpath-provisioner`;
- event: `ProvisioningSucceeded`;
- RWO volume successfully created and bound to node `crc`.

## Cleanup

The disposable namespace is removed by the guarded fixture cleanup.

## Truth boundary

This proves:
- PVC/StorageClass diagnosis;
- CSI dynamic provisioning on the CRC hostpath provider;
- recovery from a bad StorageClass reference.

It does not prove:
- enterprise CSI arrays;
- snapshot/restore;
- multi-node storage HA;
- Longhorn/Portworx/Trident runtime.

## Marker

`D098_N3_STORAGE_RCA_RUNTIME_PROVEN=PASS`
