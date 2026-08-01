output "monitoring" {
  description = "Monitoring metadata consumed by workload stacks."
  value = {
    workspace_id   = module.monitoring.workspace_id
    workspace_name = module.monitoring.workspace_name
  }
}

output "key_vault" {
  description = "Key Vault metadata consumed by workload stacks."
  value = {
    resource_group_name = module.key_vault.resource_group_name
  }
}

output "storage" {
  description = "Storage metadata consumed by workload stacks."
  value = {
    resource_group_name = module.storage.resource_group_name
  }
}
