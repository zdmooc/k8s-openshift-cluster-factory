variable "name" {
  type        = string
  description = "Logical node pool name."
}

variable "environment" {
  type        = string
  description = "sandbox|build|preprod|prod"
  validation {
    condition     = contains(["sandbox", "build", "preprod", "prod"], var.environment)
    error_message = "environment must be sandbox|build|preprod|prod"
  }
}

variable "role" {
  type        = string
  description = "Node role."
  default     = "worker"
  validation {
    condition     = contains(["worker", "infra", "storage", "build"], var.role)
    error_message = "role must be worker|infra|storage|build"
  }
}

variable "desired" {
  type        = number
  description = "Desired node count."
  default     = 2
  validation {
    condition     = var.desired >= 0
    error_message = "desired must be >= 0"
  }
}

variable "instance_class" {
  type        = string
  description = "Provider-neutral sizing class."
  default     = "medium"
}

variable "autoscaling" {
  type        = bool
  description = "Whether autoscaling is expected for this pool."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Traceability / FinOps tags."
  default     = {}
}
