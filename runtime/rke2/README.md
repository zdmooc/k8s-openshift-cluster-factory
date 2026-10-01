# RKE2 / Rancher Adapter

**Current evidence level:** REFERENCE  
**Runtime proof:** NOT YET CLAIMED

This directory defines the configuration contract for a future RKE2 runtime slice managed or imported by Rancher.

## Intended topology

Default reference profile: `catalog/profiles/rke2-lab-standard.yaml`.

```text
3 x RKE2 server
2 x RKE2 agent
        |
        v
optional Rancher management/import
```

## Covered reference topics

- HA server topology;
- embedded etcd snapshot design;
- server/agent configuration boundaries;
- Pod/Service CIDRs;
- baseline application after cluster creation;
- Rancher import/management readiness.

## Not claimed

- no RKE2 nodes are currently provisioned by CI;
- no Rancher server is deployed by this repository;
- no NeuVector/Longhorn production configuration is claimed;
- no HA failover evidence is claimed.

Runtime promotion requires explicit installation, failure tests and evidence.
