output "resource_group_name" {
  description = "Network resource group name. Consumed by dependent stacks."
  value       = module.network.resource_group_name
}

output "virtual_network_id" {
  description = "Virtual network resource ID. Consumed by routing, firewall, AKS and compute stacks."
  value       = module.network.virtual_network_id
}

output "subnet_ids" {
  description = "Subnet IDs keyed by logical subnet name."
  value       = module.network.subnet_ids
}
