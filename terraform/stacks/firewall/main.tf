locals {
  config_path        = coalesce(var.config_file, "${path.module}/../../../environments/${var.environment}/${var.environment}.yaml")
  environment_config = yamldecode(file(local.config_path))
  config             = local.environment_config.firewall

  firewall_subnet_id = data.terraform_remote_state.network.outputs.subnet_ids[local.config.subnet_key]
}

# Boundary stack:
# In production this root module would call the firewall module or a vendor appliance module.
# The important part for this lab is the boundary: network is consumed via remote state,
# while rules and IP groups are changed through YAML rather than Terraform code.
