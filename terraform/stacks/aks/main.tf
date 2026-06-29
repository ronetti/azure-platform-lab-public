locals {
  config_path = coalesce(var.config_file, "${path.module}/config/${var.environment}.yaml")
  config      = yamldecode(file(local.config_path))

  cluster = merge(local.config.cluster, {
    subnet_id               = data.terraform_remote_state.network.outputs.subnet_ids[local.config.cluster.subnet_key]
    monitoring_workspace_id = data.terraform_remote_state.shared_services.outputs.monitoring.workspace_id
  })
}

# Boundary stack:
# A production implementation would pass local.cluster into the AKS module.
# Node pools, versions and subnet placement are configured through YAML.
