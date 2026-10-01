output "id" {
  description = "Stable logical identifier for downstream contract wiring."
  value       = "${var.platform}:${var.environment}:${var.name}"
}

output "contract" {
  description = "Normalized provider-neutral cluster contract."
  value       = local.contract
}
