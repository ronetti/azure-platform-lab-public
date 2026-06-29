resource "azurerm_resource_group" "network" {
  name     = "rg-${var.name_prefix}-network"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "platform" {
  name                = "vnet-${var.name_prefix}"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "platform" {
  for_each = var.subnets

  name                 = "snet-${each.key}"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = [each.value]
}
