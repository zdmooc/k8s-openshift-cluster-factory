variable "environment" {
  type        = string
  description = "sandbox|build|preprod|prod"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
