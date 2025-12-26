# 04 — Observabilité

## KPIs / SLO recommandés
- API Server : latency (P99), error rate, saturation
- Nodes : pressure (CPU/mem/disk), NotReady, reboot/upgrade success
- Ingress/DNS : taux erreurs, latence, disponibilité
- Storage : latence, saturation, erreurs CSI

## Alerting
- Alertes actionnables + runbook associé (lien direct)
- Réduction du bruit : seuils, inhibition, regroupements

## Artefacts
- Règles Prometheus : `observability/prometheus/alerts/platform.rules.yaml`
- Dashboards Grafana : `observability/prometheus/dashboards/`
