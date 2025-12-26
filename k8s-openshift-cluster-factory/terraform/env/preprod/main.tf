terraform {
  required_version = ">= 1.6.0"
}

# Exemple d’usage (à adapter)
module "network" {
  source      = "../../modules/network"
  name        = "net-${var.environment}"
  environment = var.environment
  tags        = var.tags
}

module "cluster" {
  source      = "../../modules/cluster"
  name        = "cluster-${var.environment}"
  environment = var.environment
  tags        = var.tags
}
