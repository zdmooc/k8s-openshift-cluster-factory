# 07 — RKE2 / Rancher Reference Architecture

**Status:** REFERENCE

## Role in the factory

RKE2 is treated as an additional Kubernetes distribution option for on-prem/private-cloud scenarios. Rancher is treated as an optional management plane for lifecycle, fleet visibility and downstream cluster governance.

## Reference topology

```text
Rancher management plane (optional)
              |
              v
     RKE2 cluster registration
              |
      +-------+-------+
      |               |
  3 server         N agents
  embedded etcd    workloads
```

## Factory responsibilities

- generate/validate RKE2 profile;
- document server/agent configuration contract;
- define etcd snapshot/recovery expectations;
- apply common Kubernetes baseline after cluster creation;
- expose health/evidence hooks;
- keep Rancher management separate from workload ownership.

## Security

Reference target:
- CIS-oriented profile where supported;
- secrets encryption;
- secure bootstrap token handling;
- API endpoint restricted to approved management networks;
- least-privilege Rancher projects/roles;
- auditable cluster import/registration.

## Lifecycle

RKE2 upgrades must be coordinated with:
- supported RKE2 version path;
- Rancher compatibility;
- etcd snapshot;
- server sequencing;
- worker drain/uncordon;
- CNI/CSI compatibility.

## Evidence boundary

No RKE2 or Rancher runtime is claimed until the installation and failure tests are executed and evidence is stored.
