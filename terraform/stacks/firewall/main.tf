locals {
  config_path = coalesce(var.config_file, "${path.module}/config/${var.environment}.yaml")
  config      = yamldecode(file(local.config_path))

  firewall_subnet_id = data.terraform_remote_state.network.outputs.subnet_ids[local.config.firewall.subnet_key]
}

# Boundary stack:
# In production this root module would call the firewall module or a vendor appliance module.
# The important part for this lab is the contract: network is consumed via remote state,
# while rules and IP groups are changed through YAML rather than Terraform code.
