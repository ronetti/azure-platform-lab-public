resource "azurerm_resource_group" "security" {
  name     = "rg-${var.name_prefix}-security"
  location = var.location
  tags     = var.tags
}

# Boundary module note:
# A production Key Vault module would include tenant ID, RBAC model,
# private endpoint decisions, diagnostic settings and soft-delete policy.
