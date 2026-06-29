locals {
  config_path = coalesce(var.config_file, "${path.module}/config/${var.environment}.yaml")
  config      = yamldecode(file(local.config_path))

  route_tables = {
    for table in local.config.route_tables : table.name => merge(table, {
      subnet_ids = [
        for subnet_key in table.subnet_keys :
        data.terraform_remote_state.network.outputs.subnet_ids[subnet_key]
      ]
    })
  }
}

# Boundary stack:
# A production implementation would pass local.route_tables into the routing module.
# Route additions and subnet associations are modeled as YAML data.
