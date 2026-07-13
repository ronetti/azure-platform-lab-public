locals {
  config_path        = coalesce(var.config_file, "${path.module}/../../../environments/${var.environment}/${var.environment}.yaml")
  environment_config = yamldecode(file(local.config_path))
  config             = local.environment_config.compute

  virtual_machines = {
    for vm in local.config.virtual_machines : vm.name => merge(vm, {
      subnet_id = data.terraform_remote_state.network.outputs.subnet_ids[vm.subnet_key]
    })
  }
}

# Boundary stack:
# A production implementation would pass local.virtual_machines into the compute module.
# Adding a VM, changing a size or moving it to another logical subnet is a YAML-only change.
