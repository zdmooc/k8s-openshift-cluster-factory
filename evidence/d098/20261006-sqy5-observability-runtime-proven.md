# D-098 — SQY-5 Alerting / Logging / IAM Runtime Evidence

**Date:** 2026-10-06  
**Runtime:** OpenShift Local / CRC 4.22.7  
**Result:** `D098_OBSERVABILITY_RUNTIME_EVIDENCE=PASS`

## Monitoring and alerting

Observed running:
- Alertmanager;
- Prometheus;
- Prometheus Operator;
- Thanos Querier;
- product Prometheus/Grafana.

The Prometheus alert API was queried successfully through the OpenShift Route.

Observed:
- `prometheus_alert_api=PASS`;
- response status: `success`.

PrometheusRule inventory included platform and product rules, including GitOps and MQ rules.

## Logging

Observed:
- Alloy Running;
- Loki Running.

Loki readiness passed.

A real Loki query for namespace `instant-payments-local` returned streams.

Observed examples included:
- MongoDB read model;
- payment-orchestrator;
- Wero UI.

Markers:
- `D098_LOKI_READY=PASS`;
- `D098_LOKI_QUERY_RUNTIME_PROVEN=PASS`.

## IAM and telemetry runtime presence

Observed:
- Keycloak 1/1 Running;
- Keycloak PostgreSQL 1/1 Running;
- RHBK Operator 1/1 Running;
- Shared OTel Collector Deployment 1/1.

Existing runtime evidence reused:
- I22 OAuth2/JWT least privilege and client-secret rotation;
- D-093/I33 real payment-orchestrator trace in Shared OTel.

## Boundary

This proves:
- operational Prometheus/Alertmanager presence and alert API access;
- searchable live Loki logs;
- current IAM/OTel component health.

It does not by itself prove:
- production paging/on-call delivery;
- production log retention;
- multi-cluster observability;
- production IdP HA.

## Marker

`D098_OBSERVABILITY_RUNTIME_EVIDENCE=PASS`
