locals {
  name_prefix = "${var.platform_name}-${var.environment}"

  common_tags = {
    platform    = var.platform_name
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "platform-showcase"
  }
}

module "network" {
  source = "./modules/network"

  name_prefix   = local.name_prefix
  location      = var.location
  address_space = var.address_space
  subnets       = var.subnets
  tags          = local.common_tags
}

module "monitoring" {
  source = "./modules/monitoring"

  name_prefix    = local.name_prefix
  location       = var.location
  retention_days = var.log_retention_days
  tags           = local.common_tags
}

module "key_vault" {
  source = "./modules/key-vault"

  name_prefix = local.name_prefix
  location    = var.location
  tags        = local.common_tags
}

module "storage" {
  source = "./modules/storage"

  name_prefix = local.name_prefix
  location    = var.location
  tags        = local.common_tags
}
