terraform {
  required_version = ">= 1.6.0"
}

locals {
  platform            = "openshift"
  control_plane_count = 3
  worker_count        = 6
}

module "network" {
  source          = "../../modules/network"
  name            = "net-${var.environment}"
  environment     = var.environment
  provider_family = local.platform == "openshift" ? "openshift" : "onprem"
  tags            = var.tags
}

module "cluster" {
  source              = "../../modules/cluster"
  name                = "cluster-${var.environment}"
  environment         = var.environment
  platform            = local.platform
  control_plane_count = local.control_plane_count
  worker_count        = local.worker_count
  network_id          = module.network.id
  tags                = var.tags
}

module "nodepool" {
  source         = "../../modules/nodepool"
  name           = "worker-${var.environment}"
  environment    = var.environment
  role           = "worker"
  desired        = local.worker_count
  instance_class = "large"
  autoscaling    = true
  tags           = var.tags
}

module "iam" {
  source      = "../../modules/iam"
  name        = "iam-${var.environment}"
  environment = var.environment
  tags        = var.tags
}

module "addons" {
  source      = "../../modules/addons"
  name        = "addons-${var.environment}"
  environment = var.environment
  addons      = ["metrics", "policy", "logging"]
  tags        = var.tags
}

output "factory_contract" {
  value = {
    network  = module.network.contract
    cluster  = module.cluster.contract
    nodepool = module.nodepool.contract
    iam      = module.iam.contract
    addons   = module.addons.contract
  }
}
