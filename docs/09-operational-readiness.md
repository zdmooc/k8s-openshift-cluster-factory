# 09 — Operational Readiness Gate

A cluster is not handed to consumers simply because its API is reachable.

## Minimum readiness

- profile validated;
- expected nodes Ready;
- baseline applied;
- RBAC contract present;
- resource guardrails present;
- network-policy baseline present;
- healthcheck passes;
- evidence captured;
- ownership/escalation documented;
- maintenance and upgrade path documented;
- backup/restore responsibility explicit;
- monitoring integration contract explicit.

## Production-like additional gates

- failure-domain and N+1 capacity review;
- CNI/CSI support matrix;
- restore test evidence for critical state;
- policy exception process;
- certificate/secret lifecycle;
- change window and escalation chain;
- security scan/policy gates;
- workload smoke tests;
- upgrade rehearsal on lower environment.

## Handover

The receiving platform/product team gets:
- cluster profile/version;
- access/RBAC contract;
- supported integrations;
- SLO/support boundary;
- runbooks;
- known limitations;
- evidence index.

A cluster with missing evidence remains `IMPLEMENTED` or `REFERENCE`, not production-ready.
