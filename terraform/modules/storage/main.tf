resource "azurerm_resource_group" "storage" {
  name     = "rg-${var.name_prefix}-storage"
  location = var.location
  tags     = var.tags
}

# Boundary module note:
# In a real platform this module would create storage accounts for
# Terraform state, artifacts, diagnostics or application data.
