variable "name" {
  type        = string
  description = "Nom du composant"
}

variable "environment" {
  type        = string
  description = "sandbox|build|preprod|prod"
  validation {
    condition     = contains(["sandbox","build","preprod","prod"], var.environment)
    error_message = "environment must be sandbox|build|preprod|prod"
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags/labels (cloud) pour traçabilité et FinOps"
  default     = {}
}
