data "terraform_remote_state" "compute" {
  backend = "azurerm"

  config = local.config.remote_state.compute
}
