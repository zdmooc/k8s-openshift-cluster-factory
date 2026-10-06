# D-098 — Residual ImagePullBackOff RCA — Diagnosed

**Date:** 2026-10-06  
**Runtime:** OpenShift Local / CRC 4.22.7  
**Status:** `ROOT_CAUSE_IDENTIFIED / RECOVERY_NOT_REQUIRED_FOR_CORE_GATE`

## Symptom

`instant-payments-local/redpanda-console` remained:

`ImagePullBackOff`.

The pod was scheduled successfully on node `crc`, so this is not a scheduler-capacity failure.

## Image

`docker.redpanda.com/redpandadata/console:v3.12.0`

`imagePullPolicy=Always`.

## Observed root cause

Kubelet image-pull events reported:

`toomanyrequests: You have reached your unauthenticated pull rate limit`.

The failure is therefore an external registry / unauthenticated pull-limit issue.

## Security / platform observations

- pod is admitted under SCC `restricted-v2`;
- seccomp profile is RuntimeDefault;
- requests are small (64Mi memory), so the current ImagePullBackOff is not caused by the prior CRC memory shortage;
- the namespace ServiceAccount only exposes the OpenShift internal-registry dockercfg secret, not credentials for the external Redpanda registry.

## Remediation options

Preferred enterprise order:
1. mirror the required image by immutable digest into the enterprise/internal registry;
2. reference the internal registry digest from Git;
3. or provide an approved authenticated pull secret for the external registry;
4. avoid relying on unauthenticated public-registry pulls in a critical CaaS runtime.

Do not weaken registry policy merely to clear the demo.

## Truth boundary

This is a valid N3 root-cause diagnosis.
No runtime recovery is claimed by this file.

The D-098 N3 core gate can use the independent disposable Pod/Deployment fixture for the recoverable scenario;
this real Redpanda incident remains supplementary evidence.
