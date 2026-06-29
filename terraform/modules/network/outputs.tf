output "resource_group_name" {
  value = azurerm_resource_group.network.name
}

output "virtual_network_id" {
  value = azurerm_virtual_network.platform.id
}

output "subnet_ids" {
  value = { for key, subnet in azurerm_subnet.platform : key => subnet.id }
}
