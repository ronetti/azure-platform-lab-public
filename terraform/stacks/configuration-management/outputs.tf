output "ansible_inventory" {
  description = "Inventory data for Ansible pipelines derived from compute remote state."
  value       = local.inventory_hosts
}

output "pipeline_model" {
  description = "Configuration-management pipeline intent."
  value       = local.config.pipeline
}
