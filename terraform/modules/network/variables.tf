variable "name" {
  type        = string
  description = "Logical network contract name."
}

variable "environment" {
  type        = string
  description = "sandbox|build|preprod|prod"
  validation {
    condition     = contains(["sandbox", "build", "preprod", "prod"], var.environment)
    error_message = "environment must be sandbox|build|preprod|prod"
  }
}

variable "provider_family" {
  type        = string
  description = "Target family for the adapter contract."
  default     = "onprem"
  validation {
    condition     = contains(["onprem", "aws", "azure", "gcp", "openshift", "rke2"], var.provider_family)
    error_message = "provider_family must be onprem|aws|azure|gcp|openshift|rke2"
  }
}

variable "pod_cidr" {
  type        = string
  description = "Pod CIDR contract."
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  type        = string
  description = "Service CIDR contract."
  default     = "10.96.0.0/16"
}

variable "private_api" {
  type        = bool
  description = "Whether the target cluster API is expected to be private."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Traceability / FinOps tags."
  default     = {}
}
