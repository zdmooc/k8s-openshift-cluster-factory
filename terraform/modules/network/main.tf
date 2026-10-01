locals {
  contract = {
    kind            = "NetworkContract"
    name            = var.name
    environment     = var.environment
    provider_family = var.provider_family
    pod_cidr        = var.pod_cidr
    service_cidr    = var.service_cidr
    private_api     = var.private_api
    tags            = merge(var.tags, {
      managed-by = "k8s-openshift-cluster-factory"
      env        = var.environment
    })
  }
}
