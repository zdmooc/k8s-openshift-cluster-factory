# Labels & annotations (baseline)

## Labels namespace
- `environment`: sandbox|build|preprod|prod
- `owner`: équipe responsable
- `cost-center`: si applicable

## PSA/PSS
- `pod-security.kubernetes.io/enforce`: baseline|restricted
- `pod-security.kubernetes.io/audit`: baseline|restricted
- `pod-security.kubernetes.io/warn`: baseline|restricted

## Traçabilité (exemples)
- `platform.company.tld/ticket`: INC-1234 / CHG-5678
- `platform.company.tld/exception-until`: YYYY-MM-DD
