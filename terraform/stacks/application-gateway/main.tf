locals {
  config_path        = coalesce(var.config_file, "${path.module}/../../../environments/${var.environment}/${var.environment}.yaml")
  environment_config = yamldecode(file(local.config_path))
  config             = local.environment_config.application_gateway

  application_gateway = merge(local.config, {
    subnet_id = data.terraform_remote_state.network.outputs.subnet_ids[local.config.subnet_key]
  })
}

# Boundary stack:
# A production implementation would pass local.application_gateway into the App Gateway module.
# Listener, probe and backend changes are modeled as YAML data.
