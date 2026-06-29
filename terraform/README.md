# Terraform

## Deutsch

Diese Terraform-Struktur zeigt zwei Ebenen einer Azure-Plattform:

- `modules/` enthält wiederverwendbare Bausteine.
- `stacks/` simuliert getrennte Root-Repositories mit eigenem State.

Damit ist das Lab näher an einer Enterprise-Plattform modelliert: Netzwerk,
Shared Services, Firewall, Compute, AKS und Application Gateway können getrennt
geplant und deployed werden. Die Stacks greifen über `terraform_remote_state`
ineinander, nicht über direkte lokale Modulreferenzen.

Konfigurationsdaten liegen bewusst in YAML-Dateien. Typische Änderungen wie
neue Subnetze, Firewall-Regeln, VMs, Listener, Backends oder Node Pools sollen
im Regelfall über `config/<environment>.yaml` passieren, ohne Terraform-Code zu
ändern.

## English

This Terraform structure shows two layers of an Azure platform:

- `modules/` contains reusable building blocks.
- `stacks/` simulates separate root repositories with their own state.

This makes the lab closer to an enterprise platform setup: network, shared
services, firewall, compute, AKS and Application Gateway can be planned and
deployed separately. Stacks integrate through `terraform_remote_state`, not by
direct local module references.

Configuration data intentionally lives in YAML files. Common changes such as
new subnets, firewall rules, VMs, listeners, backends or node pools should
normally be made in `config/<environment>.yaml` without changing Terraform code.

## Stack-Abhängigkeiten / Stack Dependency Flow

```text
network
  -> routing
  -> firewall
  -> application-gateway
  -> compute
  -> aks

shared-services
  -> compute
  -> aks

compute
  -> configuration-management
```

`configuration-management` nutzt Compute-Outputs als Inventory-Quelle
für getrennte Ansible-Pipelines mit eigenen Guardrails.

`configuration-management` consumes compute outputs as the inventory source
for separate Ansible pipelines with their own guardrails.

## Befehle / Commands

Example for the network stack:

```bash
cd terraform/stacks/network
terraform init -backend-config=backend/testing.azurerm.tfbackend.example
terraform fmt -recursive
terraform validate
terraform plan -var environment=testing
```

Example for a dependent stack:

```bash
cd terraform/stacks/compute
terraform init -backend-config=backend/testing.azurerm.tfbackend.example
terraform plan -var environment=testing
```
