# Architektur / Architecture

## Zielbild

Das Ziel ist eine Azure-Plattformbasis für Enterprise-Workloads, die
wiederholbar, im Review verständlich und modular erweiterbar ist. Die Plattform soll nicht
nur Ressourcen erzeugen, sondern einen Betriebsrahmen abbilden: Netzwerk,
Security, Edge, Monitoring, Storage, Compute, Remote State,
Umgebungskonfiguration und Kubernetes-Zielstrukturen.

## Target State

The goal is an Azure platform baseline for enterprise workloads that can be
reproduced, checked in review and extended modularly. The platform should not only
create resources, but also model an operating foundation: networking, security,
edge, monitoring, storage, compute, remote state, environment configuration and
Kubernetes target structures.

## Logische Architektur

```text
YAML-Konfiguration
  config/testing.yaml
        |
        v
Root-Stack
  backend/*.tfbackend.example
  remote-state.tf
  main.tf
  outputs.tf
        |
        v
Remote-State-Outputs
        |
        v
Abhängiger Stack
```

Das Repository trennt zwei Ebenen:

- `terraform/modules/` enthält wiederverwendbare Implementierungsbausteine.
- `terraform/stacks/` modelliert deploybare Root-Module mit eigener
  Backend-Konfiguration und klaren Übergabepunkten.

In einer echten Plattform könnten diese Stacks in getrennten Repositories mit
eigenen Pipelines, Freigaben und State-Dateien liegen. In diesem Lab liegen sie
zusammen, damit die Architektur an einem Ort geprüft werden kann.

Nicht jeder Stack ist in diesem Repository gleich tief implementiert. `network`
und `shared-services` zeigen konkrete Basisressourcen. Andere Stacks zeigen
bewusst die Schnittstelle, die Konfigurationsform und die Betriebsgrenze. Diese
Unterscheidung ist wichtig: Eine saubere Schnittstelle ist nützlich, aber sie
ist noch nicht dasselbe wie eine produktionsreife Implementierung.

## Logical Architecture

```text
YAML configuration
  config/testing.yaml
        |
        v
Root stack
  backend/*.tfbackend.example
  remote-state.tf
  main.tf
  outputs.tf
        |
        v
Remote-state outputs
        |
        v
Dependent stack
```

The repository keeps two layers separate:

- `terraform/modules/` contains reusable implementation building blocks.
- `terraform/stacks/` models deployable root modules with independent backend
  configuration and clear handover points.

In a real platform, each stack could live in a separate repository with its own
pipeline, approvals and state file. In this lab they live together so the
architecture can be checked in one place.

Not every stack is implemented at the same depth in this repository. `network`
and `shared-services` show concrete baseline resources. Other stacks
intentionally show the interface, configuration shape and operational
line of responsibility. That distinction matters: a clear interface is useful, but it is not
the same thing as a production-ready implementation.

## Stack-Abhängigkeiten

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

Der Abhängigkeitsfluss trennt gemeinsame Grundlagen von konsumierenden
Workload- oder Plattform-Stacks. Downstream-Stacks konsumieren nur
veröffentlichte Outputs, nicht die interne Implementierung der Upstream-Stacks.
`configuration-management` hängt bewusst hinter `compute`: Terraform
veröffentlicht VM-Metadaten, und Ansible-Pipelines nutzen diese Metadaten als
Inventory-Quelle.

## Stack Dependency Flow

The dependency flow keeps shared foundations separate from consuming workload
or platform stacks. Downstream stacks consume only published outputs, not the
internal implementation of upstream stacks.
`configuration-management` is deliberately downstream of `compute`: Terraform
publishes VM metadata, and Ansible pipelines consume that metadata as their
inventory source.

## Modulgrenzen

Die Module sind nach Verantwortlichkeiten getrennt:

- `network`: virtuelle Netzwerke, Subnetze und Adressräume
- `routing`: Route Tables und Routing-Muster
- `firewall`: Firewall-Integration und zentrale Egress-Kontrolle
- `application-gateway`: Edge, WAF, Listener und Backend Pools
- `monitoring`: Log Analytics, Diagnostics und Metriken
- `key-vault`: Secret- und Zertifikatsbasis
- `storage`: Plattform-Storage, zum Beispiel Terraform State, Artefakte oder
  Workload-Daten
- `compute`: VM- oder Agent-Pool-nahe Bausteine
- `aks`: Kubernetes-Zielstruktur
- `configuration-management`: Ansible-Inventory auf Basis von Terraform Outputs

## Module Boundaries

The modules are separated by responsibility:

- `network`: virtual networks, subnets and address spaces
- `routing`: route tables and routing patterns
- `firewall`: firewall integration and central egress control
- `application-gateway`: edge, WAF, listeners and backend pools
- `monitoring`: Log Analytics, diagnostics and metrics
- `key-vault`: secret and certificate foundation
- `storage`: platform storage, for example Terraform state, artifacts or
  workload data
- `compute`: VM or agent-pool-like building blocks
- `aks`: Kubernetes target structure
- `configuration-management`: Ansible inventory based on Terraform outputs

## Konfigurationsmodell

Routinemäßige Plattformänderungen sollen Datenänderungen sein, keine
Terraform-Codeänderungen. Beispiele:

- Subnetz in `terraform/stacks/network/config/testing.yaml` ergänzen
- Route in `terraform/stacks/routing/config/testing.yaml` ergänzen
- Firewall-Regel in `terraform/stacks/firewall/config/testing.yaml` ergänzen
- VM in `terraform/stacks/compute/config/testing.yaml` ergänzen
- Host-Gruppen oder Ansible-Guardrails in
  `terraform/stacks/configuration-management/config/testing.yaml` ergänzen
- Application-Gateway-Backend in
  `terraform/stacks/application-gateway/config/testing.yaml` ergänzen
- AKS Node Pool in `terraform/stacks/aks/config/testing.yaml` ergänzen

## Configuration Model

Routine platform changes should be data changes, not Terraform code changes.
Examples:

- add a subnet in `terraform/stacks/network/config/testing.yaml`
- add a route in `terraform/stacks/routing/config/testing.yaml`
- add a firewall rule in `terraform/stacks/firewall/config/testing.yaml`
- add a VM in `terraform/stacks/compute/config/testing.yaml`
- add host groups or Ansible guardrails in
  `terraform/stacks/configuration-management/config/testing.yaml`
- add an Application Gateway backend in
  `terraform/stacks/application-gateway/config/testing.yaml`
- add an AKS node pool in `terraform/stacks/aks/config/testing.yaml`

## Remote-State-Outputs

Upstream-Stacks veröffentlichen stabile Outputs. Downstream-Stacks konsumieren
nur diese Outputs über `terraform_remote_state`.

Beispiele:

- `network` veröffentlicht `virtual_network_id`, `subnet_ids` und
  `resource_group_name`.
- `shared-services` veröffentlicht Referenzen auf Monitoring, Key Vault und
  Storage.
- `compute`, `aks`, `routing`, `firewall` und `application-gateway`
  nutzen diese Outputs, ohne in die Implementierung anderer Stacks zu
  greifen.
- `configuration-management` konsumiert Compute-Outputs und macht daraus ein
  Ansible-Inventory für nachgelagerte Konfiguration.

## Remote-State Outputs

Upstream stacks expose stable outputs. Downstream stacks consume only those
outputs through `terraform_remote_state`.

Examples:

- `network` exposes `virtual_network_id`, `subnet_ids` and
  `resource_group_name`.
- `shared-services` exposes monitoring, Key Vault and storage references.
- `compute`, `aks`, `routing`, `firewall` and `application-gateway` consume
  these outputs rather than reaching into another stack's implementation.
- `configuration-management` consumes compute outputs and turns them into an
  Ansible inventory for downstream configuration.

## Betriebsmodell

Eine Plattform ist erst dann brauchbar, wenn Betrieb mitgedacht ist.
Monitoring, Diagnoseeinstellungen, Runbooks, Rollback-Gedanken,
Kostenbewusstsein, Security-Grenzen und klare Ownership gehören deshalb zur
Architektur.

## Operating Model

A platform is only useful when operations are included from the beginning.
Monitoring, diagnostic settings, runbooks, rollback thinking, cost awareness,
security boundaries and clear ownership are therefore part of the architecture.

## Anonymisierung

Das Repository abstrahiert die Muster bewusst. Kundennamen, produktive
IP-Adressräume, Secrets, Domains und interne Projekthistorie werden nicht
veröffentlicht.

## Sanitization

The repository intentionally abstracts the patterns. Customer names, production
IP ranges, secrets, domains and internal delivery history are not published.
