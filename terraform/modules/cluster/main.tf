locals {
  contract = {
    kind                = "ClusterContract"
    name                = var.name
    environment         = var.environment
    platform            = var.platform
    kubernetes_version  = var.kubernetes_version
    control_plane_count = var.control_plane_count
    worker_count        = var.worker_count
    network_id          = var.network_id
    tags                = merge(var.tags, {
      managed-by = "k8s-openshift-cluster-factory"
      env        = var.environment
    })
  }
}
