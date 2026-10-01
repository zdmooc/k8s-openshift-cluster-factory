output "id" {
  description = "Stable logical identifier for downstream contract wiring."
  value       = "${var.provider_family}:${var.environment}:${var.name}"
}

output "contract" {
  description = "Normalized provider-neutral network contract."
  value       = local.contract
}
