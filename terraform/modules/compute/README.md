# Compute Module

## Deutsch

Dieses Rahmenmodul steht für VM- oder Agent-Pool-nahe Bausteine, zum
Beispiel skalierbare Build-/Automation-Runner oder klassische
Multi-Tier-Komponenten.

Neue VMs, Größen, private IPs und Subnetzzuteilungen sollten über YAML
konfigurierbar sein, damit Skalierung ohne Terraform-Codeänderung möglich
bleibt.

Compute veröffentlicht VM-Metadaten als Output. Der
`configuration-management`-Stack nutzt diese Outputs als Inventory-Quelle für
getrennte Ansible-Pipelines mit eigenen Guardrails.

## English

This module frame represents VM or agent-pool-like building blocks, for
example scalable build/automation runners or classic multi-tier components.

New VMs, sizes, private IPs and subnet assignments should be configurable
through YAML so scaling remains possible without changing Terraform code.

Compute publishes VM metadata as output. The `configuration-management` stack
uses these outputs as the inventory source for separate Ansible pipelines
with their own guardrails.
