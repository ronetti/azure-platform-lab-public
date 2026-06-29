locals {
  config_path = coalesce(var.config_file, "${path.module}/config/${var.environment}.yaml")
  config      = yamldecode(file(local.config_path))

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
# Ansible consumes this contract through its own pipeline and guardrails.
