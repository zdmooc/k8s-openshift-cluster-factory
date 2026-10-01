variable "name" {
  type        = string
  description = "Logical addon-set name."
}

variable "environment" {
  type        = string
  description = "sandbox|build|preprod|prod"
  validation {
    condition     = contains(["sandbox", "build", "preprod", "prod"], var.environment)
    error_message = "environment must be sandbox|build|preprod|prod"
  }
}

variable "addons" {
  type        = set(string)
  description = "Provider-neutral addon contracts requested for the cluster."
  default     = ["metrics", "policy", "logging"]
}

variable "tags" {
  type        = map(string)
  description = "Traceability / FinOps tags."
  default     = {}
}
