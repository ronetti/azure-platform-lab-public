# Network Module

## Deutsch

Dieses Basismodul erstellt Resource Group, Virtual Network und Subnets. Es ist
die Grundlage für Routing, Firewall, Application Gateway, Compute und AKS.

Subnetze und Adressräume sollen aus versionierter YAML-Konfiguration oder
tfvars-Dateien kommen. Der Stack veröffentlicht stabile Outputs wie
`virtual_network_id`, `subnet_ids` und `resource_group_name`, damit
Downstream-Stacks nur diese Outputs nutzen und nicht die interne
Implementierung kennen müssen.

## English

This baseline module creates the resource group, virtual network and subnets.
It is the foundation for routing, firewall, Application Gateway, compute and
AKS.

Subnets and address spaces should come from versioned YAML or tfvars
configuration. The stack publishes stable outputs such as `virtual_network_id`,
`subnet_ids` and `resource_group_name` so downstream stacks consume only the
outputs, not the internal implementation.
