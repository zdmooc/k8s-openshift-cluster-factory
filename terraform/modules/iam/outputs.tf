output "id" {
  description = "Stable logical IAM identifier."
  value       = "${var.environment}:${var.name}"
}

output "contract" {
  description = "Normalized provider-neutral IAM contract."
  value       = local.contract
}
