output "route_tables" {
  description = "Route table deployment intent after resolving subnet IDs."
  value       = local.route_tables
}
