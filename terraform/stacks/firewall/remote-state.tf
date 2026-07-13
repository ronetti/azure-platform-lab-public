data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = merge(local.environment_config.terraform_backend, {
    key = "platform/network/${local.environment_config.environment}.tfstate"
  })
}
