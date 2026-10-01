# Changelog

## 2026-10-01 — O2 Cluster Factory baseline

- repository repositioned as canonical Cluster Lifecycle / CaaS / Day-2 / N2-N3 owner;
- cluster profile catalog + JSON Schema;
- executable Kind multi-node factory;
- Kubernetes baseline repaired;
- Terraform placeholders replaced with validated contracts;
- OpenShift existing-cluster adapter;
- RKE2/Rancher reference adapter;
- realistic upgrade strategy;
- hardened N2/N3 health, drain and readiness controls;
- static CI fully green;
- Kind runtime CI fully green with evidence artifact;
- cloud adapters reclassified as reference-only until executed.

Evidence:
- Static CI run `36857552519`: SUCCESS;
- Kind runtime run `36857415894`: SUCCESS.

## Previous

- Initial repository scaffold.
