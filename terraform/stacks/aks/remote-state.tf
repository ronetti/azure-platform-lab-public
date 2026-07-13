data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = merge(local.environment_config.terraform_backend, {
    key = "platform/network/${local.environment_config.environment}.tfstate"
  })
}

data "terraform_remote_state" "shared_services" {
  backend = "azurerm"

  config = merge(local.environment_config.terraform_backend, {
    key = "platform/shared-services/${local.environment_config.environment}.tfstate"
  })
}
