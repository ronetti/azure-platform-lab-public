locals {
  config_path        = coalesce(var.config_file, "${path.module}/../../../environments/${var.environment}/${var.environment}.yaml")
  environment_config = yamldecode(file(local.config_path))
  config             = local.environment_config.configuration_management

  inventory_hosts = {
    for name, vm in data.terraform_remote_state.compute.outputs.virtual_machines : name => {
      ansible_host = vm.private_ip
      groups       = concat([vm.subnet_key], lookup(local.config.host_groups, name, []))
      variables = {
        vm_size    = vm.size
        subnet_key = vm.subnet_key
      }
    }
  }
}

# Boundary stack:
# Terraform remains the source for infrastructure and inventory data.
# Ansible consumes these outputs through its own pipeline and guardrails.
