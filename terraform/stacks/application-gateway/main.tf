locals {
  config_path = coalesce(var.config_file, "${path.module}/config/${var.environment}.yaml")
  config      = yamldecode(file(local.config_path))

  application_gateway = merge(local.config.application_gateway, {
    subnet_id = data.terraform_remote_state.network.outputs.subnet_ids[local.config.application_gateway.subnet_key]
  })
}

# Boundary stack:
# A production implementation would pass local.application_gateway into the App Gateway module.
# Listener, probe and backend changes are modeled as YAML data.
