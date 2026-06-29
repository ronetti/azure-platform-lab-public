data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = local.config.remote_state.network
}
