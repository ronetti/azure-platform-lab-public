output "virtual_machines" {
  description = "VM deployment intent after resolving subnet IDs from the network stack."
  value       = local.virtual_machines
}

output "monitoring_workspace_id" {
  description = "Monitoring workspace consumed from the shared-services stack."
  value       = data.terraform_remote_state.shared_services.outputs.monitoring.workspace_id
}
