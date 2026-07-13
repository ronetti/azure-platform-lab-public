data "terraform_remote_state" "compute" {
  backend = "azurerm"

  config = merge(local.environment_config.terraform_backend, {
    key = "platform/compute/${local.environment_config.environment}.tfstate"
  })
}
