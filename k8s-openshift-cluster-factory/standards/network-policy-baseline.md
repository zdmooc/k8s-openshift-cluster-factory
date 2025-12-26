# NetworkPolicy baseline

## Objectif
Segmentation et contrôle des flux (approche deny-by-default).

## Baseline
- Ingress: deny all
- Egress: deny all (ou allow DNS + proxy)
- Exceptions via policies dédiées, tracées, revues

## Remarques OpenShift
- S’assurer de la compatibilité CNI et du mode NetworkPolicy
