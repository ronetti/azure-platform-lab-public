locals {
  config_path = coalesce(var.config_file, "${path.module}/config/${var.environment}.yaml")
  config      = yamldecode(file(local.config_path))

  name_prefix = "${local.config.platform_name}-${local.config.environment}"

  common_tags = merge(
    {
      platform    = local.config.platform_name
      environment = local.config.environment
      managed_by  = "terraform"
      stack       = "network"
    },
    lookup(local.config, "tags", {})
  )
}

module "network" {
  source = "../../modules/network"

  name_prefix   = local.name_prefix
  location      = local.config.location
  address_space = local.config.address_space
  subnets       = local.config.subnets
  tags          = local.common_tags
}
