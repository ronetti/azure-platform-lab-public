# Changelog / Änderungsverlauf

Alle relevanten Änderungen an diesem anonymisierten Azure Platform Lab werden
hier dokumentiert.

All notable changes to this anonymized Azure Platform Lab are documented here.

## Unreleased / Unveröffentlicht

### Hinzugefügt

- Stack-basierte Terraform-Struktur unter `terraform/stacks/`, um getrennte
  Root-Repositories und Remote-State-Übergaben zu modellieren.
- YAML-getriebene Konfigurationsbeispiele für Network, Routing, Firewall,
  Compute, AKS, Application Gateway und Shared Services.
- Architektur-Pattern für Netzwerksegmentierung, Application Gateway/WAF,
  stateful Workloads, Availability Engineering, Change Governance,
  Kubernetes-Plattformmuster und Guardrails.
- Betriebsdokumentation für SLI/SLO/SLA-Denken, Error Budgets, Monitoring,
  Runbooks, Reviews, Approvals und Pipeline-Gates.
- Ansible-Configuration-Management-Pattern mit Terraform Outputs als
  Inventory-Quelle und getrennten Pipeline-Guardrails.
- Anonymisiertes Restore-Automatisierungs-Pattern mit Azure VM Backup
  Policies, automatischen Backups nach definierten Regeln,
  Python-Orchestrierungslogik, Logging, RTO/RPO-Ableitung und
  Terraform-Drift-Vermeidung.
- Governance-, Guardrail- und Availability-Felder in zentralen Environment-
  und Stack-YAML-Dateien.
- README-Dateien für alle Basismodule.
- Copyright- und No-License-Hinweis für Portfolio- und Architekturbeispiele.

### Geändert

- Die Haupt-README wurde zu einem zweisprachigen Portfolio-Einstieg mit
  Architekturüberblick erweitert.
- GitHub Actions validieren zusätzlich Terraform-Stacks und YAML-Dateien unter
  `terraform/stacks`.
- GitHub Actions prüfen die Configuration-Management-Guardrails.

### Hinweise

- Dieses Repository ist bewusst anonymisiert und enthält keine Kundennamen,
  produktiven IP-Adressräume, Secrets oder vertraulichen Architekturdetails.

### Added

- Stack-based Terraform structure under `terraform/stacks/` to model separate
  root repositories and remote-state handovers.
- YAML-driven configuration examples for network, routing, firewall, compute,
  AKS, Application Gateway and shared services.
- Architecture pattern documents for network segmentation, Application
  Gateway/WAF, stateful workloads, availability engineering, change governance,
  Kubernetes platform patterns and guardrails.
- Operational documentation for SLI/SLO/SLA thinking, error budgets, monitoring,
  runbooks, reviews, approvals and pipeline-gated delivery.
- Ansible configuration-management pattern with Terraform outputs as inventory
  source and separate pipeline guardrails.
- Anonymized restore automation pattern with Azure VM Backup policies,
  automatic backups based on defined rules, Python orchestration logic,
  logging, RTO/RPO derivation and Terraform drift avoidance.
- Governance, guardrail and availability fields in central environment and
  stack YAML files.
- README files for all baseline modules.
- Copyright and no-license notice for portfolio and architecture examples.

### Changed

- Reworked the main README into a bilingual portfolio cover and architecture
  overview.
- Extended GitHub Actions validation to include Terraform stack validation and
  YAML files below `terraform/stacks`.
- GitHub Actions check the configuration-management guardrails.

### Notes

- This repository is intentionally anonymized and does not contain customer
  names, production IP ranges, secrets or confidential architecture details.
