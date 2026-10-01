output "id" {
  description = "Stable logical addon-set identifier."
  value       = "${var.environment}:${var.name}"
}

output "contract" {
  description = "Normalized provider-neutral addon contract."
  value       = local.contract
}
