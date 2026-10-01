variable "name" {
  type        = string
  description = "Logical cluster name."
}

variable "environment" {
  type        = string
  description = "sandbox|build|preprod|prod"
  validation {
    condition     = contains(["sandbox", "build", "preprod", "prod"], var.environment)
    error_message = "environment must be sandbox|build|preprod|prod"
  }
}

variable "platform" {
  type        = string
  description = "Target Kubernetes distribution."
  default     = "kubernetes"
  validation {
    condition     = contains(["kubernetes", "openshift", "rke2"], var.platform)
    error_message = "platform must be kubernetes|openshift|rke2"
  }
}

variable "kubernetes_version" {
  type        = string
  description = "Requested Kubernetes/OpenShift compatibility version or channel."
  default     = "stable"
}

variable "control_plane_count" {
  type        = number
  description = "Desired control-plane count."
  default     = 1
  validation {
    condition     = var.control_plane_count >= 1
    error_message = "control_plane_count must be >= 1"
  }
}

variable "worker_count" {
  type        = number
  description = "Desired worker count."
  default     = 2
  validation {
    condition     = var.worker_count >= 0
    error_message = "worker_count must be >= 0"
  }
}

variable "network_id" {
  type        = string
  description = "Logical network contract identifier."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Traceability / FinOps tags."
  default     = {}
}
