locals {
  contract = {
    kind           = "NodePoolContract"
    name           = var.name
    environment    = var.environment
    role           = var.role
    desired        = var.desired
    instance_class = var.instance_class
    autoscaling    = var.autoscaling
    tags = merge(var.tags, {
      managed-by = "k8s-openshift-cluster-factory"
      env        = var.environment
    })
  }
}
