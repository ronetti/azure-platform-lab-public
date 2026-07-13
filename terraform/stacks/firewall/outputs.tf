output "virtual_network_id" {
  description = "Virtual network ID consumed from the network stack."
  value       = data.terraform_remote_state.network.outputs.virtual_network_id
}

output "firewall_subnet_id" {
  description = "Subnet selected for firewall placement."
  value       = local.firewall_subnet_id
}

output "network_rule_collections" {
  description = "Firewall network rule collections loaded from YAML."
  value       = local.config.network_rule_collections
}
