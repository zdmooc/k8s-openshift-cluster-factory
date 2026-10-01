variable "name" {
  type        = string
  description = "Logical IAM contract name."
}

variable "environment" {
  type        = string
  description = "sandbox|build|preprod|prod"
  validation {
    condition     = contains(["sandbox", "build", "preprod", "prod"], var.environment)
    error_message = "environment must be sandbox|build|preprod|prod"
  }
}

variable "oidc_enabled" {
  type        = bool
  description = "Whether OIDC integration is expected."
  default     = true
}

variable "admin_groups" {
  type        = list(string)
  description = "External groups mapped to cluster administration."
  default     = ["platform-admins"]
}

variable "readonly_groups" {
  type        = list(string)
  description = "External groups mapped to read-only access."
  default     = ["platform-readonly"]
}

variable "tags" {
  type        = map(string)
  description = "Traceability / FinOps tags."
  default     = {}
}
