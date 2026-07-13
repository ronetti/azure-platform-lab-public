locals {
  config_path        = coalesce(var.config_file, "${path.module}/../../../environments/${var.environment}/${var.environment}.yaml")
  environment_config = yamldecode(file(local.config_path))
  config             = local.environment_config.network

  name_prefix = "${local.environment_config.platform_name}-${local.environment_config.environment}"

  common_tags = merge(
    {
      platform    = local.environment_config.platform_name
      environment = local.environment_config.environment
      managed_by  = "terraform"
      stack       = "network"
    },
    local.environment_config.tags
  )
}

module "network" {
  source = "../../modules/network"

  name_prefix   = local.name_prefix
  location      = local.environment_config.location
  address_space = local.config.address_space
  subnets       = local.config.subnets
  tags          = local.common_tags
}
