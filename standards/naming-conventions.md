# Conventions de nommage

## Clusters
Format recommandé : `<org>-<site>-<env>-<type>-<nn>`
- env: sandbox|build|preprod|prod
- type: k8s|ocp
- nn: 2 digits

## Namespaces
- plateforme: `platform-*`
- équipes produit: `p-<product>-<env>`
- shared: `shared-*`

## Labels recommandés
- `app.kubernetes.io/name`
- `app.kubernetes.io/part-of`
- `app.kubernetes.io/managed-by`
- `owner`
- `environment`
