locals {
  config_path        = coalesce(var.config_file, "${path.module}/../../../environments/${var.environment}/${var.environment}.yaml")
  environment_config = yamldecode(file(local.config_path))
  config             = local.environment_config.shared_services

  name_prefix = "${local.environment_config.platform_name}-${local.environment_config.environment}"

  common_tags = merge(
    {
      platform    = local.environment_config.platform_name
      environment = local.environment_config.environment
      managed_by  = "terraform"
      stack       = "shared-services"
    },
    local.environment_config.tags
  )
}

module "monitoring" {
  source = "../../modules/monitoring"

  name_prefix    = local.name_prefix
  location       = local.environment_config.location
  retention_days = local.config.monitoring.retention_days
  tags           = local.common_tags
}

module "key_vault" {
  source = "../../modules/key-vault"

  name_prefix = local.name_prefix
  location    = local.environment_config.location
  tags        = local.common_tags
}

module "storage" {
  source = "../../modules/storage"

  name_prefix = local.name_prefix
  location    = local.environment_config.location
  tags        = local.common_tags
}
