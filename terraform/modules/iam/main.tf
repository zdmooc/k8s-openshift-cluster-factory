locals {
  contract = {
    kind            = "IamContract"
    name            = var.name
    environment     = var.environment
    oidc_enabled    = var.oidc_enabled
    admin_groups    = var.admin_groups
    readonly_groups = var.readonly_groups
    tags            = merge(var.tags, {
      managed-by = "k8s-openshift-cluster-factory"
      env        = var.environment
    })
  }
}
