locals {
  contract = {
    kind        = "AddonContract"
    name        = var.name
    environment = var.environment
    addons      = sort(tolist(var.addons))
    tags        = merge(var.tags, {
      managed-by = "k8s-openshift-cluster-factory"
      env        = var.environment
    })
  }
}
