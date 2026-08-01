output "cluster" {
  description = "AKS deployment intent after resolving platform dependencies."
  value       = local.cluster
}

output "cost" {
  description = "Cost posture kept separate from the technical cluster shape."
  value       = local.environment_config.costs
}

output "used_for" {
  description = "Testing, staging or production uses hosted by this environment."
  value       = local.environment_config.used_for
}

output "governance" {
  description = "Review and source-of-truth contract for this environment."
  value       = local.config.governance
}

output "ai_workload_platform" {
  description = "Modeled AI workload platform intent for GPU scheduling, cost controls and inference boundaries."
  value       = try(local.config.cluster.ai_workload_platform, null)
}
