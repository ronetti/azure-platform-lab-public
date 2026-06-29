resource "azurerm_resource_group" "monitoring" {
  name     = "rg-${var.name_prefix}-monitoring"
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "platform" {
  name                = "log-${var.name_prefix}"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
  tags                = var.tags
}
