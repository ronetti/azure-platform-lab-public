locals {
  config_path = coalesce(var.config_file, "${path.module}/config/${var.environment}.yaml")
  config      = yamldecode(file(local.config_path))

  name_prefix = "${local.config.platform_name}-${local.config.environment}"

  common_tags = merge(
    {
      platform    = local.config.platform_name
      environment = local.config.environment
      managed_by  = "terraform"
      stack       = "shared-services"
    },
    lookup(local.config, "tags", {})
  )
}

module "monitoring" {
  source = "../../modules/monitoring"

  name_prefix    = local.name_prefix
  location       = local.config.location
  retention_days = local.config.monitoring.retention_days
  tags           = local.common_tags
}

module "key_vault" {
  source = "../../modules/key-vault"

  name_prefix = local.name_prefix
  location    = local.config.location
  tags        = local.common_tags
}

module "storage" {
  source = "../../modules/storage"

  name_prefix = local.name_prefix
  location    = local.config.location
  tags        = local.common_tags
}
