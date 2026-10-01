output "id" {
  description = "Stable logical node-pool identifier."
  value       = "${var.environment}:${var.role}:${var.name}"
}

output "contract" {
  description = "Normalized provider-neutral node-pool contract."
  value       = local.contract
}
