data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = local.config.remote_state.network
}

data "terraform_remote_state" "shared_services" {
  backend = "azurerm"

  config = local.config.remote_state.shared_services
}
