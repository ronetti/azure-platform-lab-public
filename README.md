# Azure Platform Lab

## Deckblatt / Cover

**Annett Berlinger**

**Platform Engineering | DevOps | Azure Infrastructure Automation**

Dieses Repository ist kein Versuch, eine komplette Enterprise Landing Zone
nachzubauen. Es ist ein anonymisiertes Beispiel dafür, wie ich Plattformarbeit
strukturieren würde: klare Grenzen, versionierte Konfiguration,
Remote-State-Übergaben, Betriebsdenken und eine realistische Roadmap für
Erweiterung.

Mir geht es dabei nicht darum, möglichst viele Azure-Ressourcen zu zeigen. Der
spannende Teil beginnt für mich danach: Wer ändert was? Wo liegt der State?
Welche Änderung braucht Review? Wie bleibt eine Plattform nachvollziehbar, wenn
sie wächst? Und woran merkt man, dass ein Rollout gerade zu viel Risiko in den
Betrieb bringt?

This repository is not an attempt to rebuild a full enterprise landing zone. It
is an anonymized example for how I structure platform work: clear boundaries,
versioned configuration, remote-state handovers, operational thinking and a
realistic path for extension.

For me, the point is not to show as many Azure resources as possible. The
interesting part starts after that: who changes what? Where is the state? Which
change needs review? How does a platform stay understandable when it grows? And
how do you notice that a rollout is putting too much risk into operations?

## Kurzfassung

Der Fokus liegt auf der Plattformbasis, nicht auf einer Demo-App:

- Wie werden Umgebungen und Verantwortlichkeiten geschnitten?
- Wie greifen getrennte Root-Stacks über Remote State ineinander?
- Wie werden Routineänderungen über YAML statt Terraform-Code abgebildet?
- Wie bleibt das Repository die Single Source of Truth, statt dass Wahrheit im
  Portal, in alten Tickets oder in den Köpfen einzelner Personen liegt?
- Wie werden Verfügbarkeit, Error Budget, Reviews und Approvals gesteuert?
- Welche Guardrails schützen Terraform-, Azure- und Kubernetes-Änderungen?
- Wie wird VM-Konfiguration über Ansible getrennt, aber aus Terraform-Outputs
  abgeleitet?

## Short Summary

The focus is the platform foundation, not a demo application:

- How are environments and responsibilities separated?
- How do independent root stacks integrate through remote state?
- How are routine changes modeled through YAML instead of Terraform code?
- How does the repository remain the single source of truth instead of leaving
  truth in portals, old tickets or individual people's heads?
- How are availability, error budgets, reviews and approvals controlled?
- Which guardrails protect Terraform, Azure and Kubernetes changes?
- How is VM configuration separated through Ansible while being derived from
  Terraform outputs?

## Umsetzungsstand Auf Einen Blick

| Bereich | Status |
| --- | --- |
| Network | Implementiertes Basismodul und eigener Root-Stack |
| Monitoring | Implementiertes Basismodul und Shared-Services-Übergabepunkt |
| Key Vault | Implementierter Modulrahmen für Security-Basis |
| Storage | Implementierter Modulrahmen für Plattform-Storage |
| Routing, Firewall, Application Gateway | Rahmen-Stacks mit YAML-Intent und klaren Remote-State-Outputs |
| Compute | Rahmen-Stack mit VM-Intent und Outputs für nachgelagerte Tools |
| Configuration Management | Terraform-Outputs als Inventory-Quelle für getrennte Ansible-Pipelines |
| AKS/Kubernetes | Zielstruktur, Beispiel-Manifeste und Guardrails |

Dieses Repository zeigt bewusst nicht produktiven Kundencode. Es trennt
sichtbare Lab-Implementierung, modellierte Schnittstellen und dokumentierte
Praxismuster. Das ist kein Verstecken von Lücken. Ich möchte zeigen, wie ich
eine Plattform strukturiere, wo ich Grenzen ziehen würde und welche Fragen im
Betrieb nicht verloren gehen dürfen.

## Status At A Glance

| Area | Status |
| --- | --- |
| Network | Implemented baseline module and dedicated root stack |
| Monitoring | Implemented baseline module and shared-services handover point |
| Key Vault | Implemented module frame for the security baseline |
| Storage | Implemented module frame for platform storage |
| Routing, Firewall, Application Gateway | Stack frames with YAML intent and clear remote-state outputs |
| Compute | Stack frame with VM intent and outputs for downstream tooling |
| Configuration Management | Terraform outputs as inventory source for separate Ansible pipelines |
| AKS/Kubernetes | Target structure, example manifests and guardrails |

This repository intentionally does not publish production customer code. It
separates visible lab implementation, modeled interfaces and documented
real-world patterns. That is not hiding gaps. I want to show how I structure a
platform, where I would draw boundaries and which operational questions must
not get lost.

## Warum Ich Das So Geschnitten Habe

Ich habe in Infrastrukturarbeit gelernt, dass der schwierige Teil selten nur
das Erzeugen einer Ressource ist. Schwieriger ist, Änderungen später noch sauber
zu verstehen: Welche Umgebung ist betroffen? Wer prüft die Änderung? Welcher
State ist die Quelle? Welche Betriebswirkung hat die Änderung?

Darum trennt dieses Lab Module, Root-Stacks, YAML-Konfiguration,
Remote-State-Outputs und Betriebsdokumentation. Eine Plattform soll nicht nur
einmal funktionieren. Sie soll auch dann noch verständlich sein, wenn jemand
anderes sie prüft, erweitert oder im Incident-Fall verstehen muss.

## Why I Structured It This Way

In infrastructure work, I learned that the hard part is rarely only creating a
resource. The harder part is understanding changes later: which environment is
affected? Who reviews the change? Which state is the source? What operational
impact does the change have?

That is why this lab separates modules, root stacks, YAML configuration,
remote-state outputs and operational documentation. A platform should not only
work once. It should still be understandable when someone else has to review,
extend or debug it during an incident.

## Was Dieses Repository Zeigt

- Azure-Landing-Zone-nahe Plattformstruktur
- Wiederverwendbare Terraform-Module und getrennte Root-Stack-Simulationen
- Remote-State- und Backend-Konfiguration pro Stack
- YAML-basierte Konfiguration für routinemäßige Plattformänderungen
- Netzwerksegmentierung für getrennte Solutions oder Mandanten
- Application Gateway/WAF als zentrales Edge-Pattern
- Monitoring, Security, Storage und Key-Vault-Rahmen als Betriebsbasis
- Availability Engineering mit SLI, SLO, SLA und Error Budget
- Review-, Approval- und Pipeline-basierte Delivery-Prozesse
- Single Source of Truth über versionierte Konfiguration, Dokumentation und
  Changelogs
- Guardrails für Terraform, Kubernetes, Security und Betrieb
- Ansible Configuration Management mit Terraform Outputs als Inventory-Quelle
- Kubernetes-Zielstruktur für spätere AKS- oder k3s-nahe Workloads
- GitHub Actions für Terraform-, YAML- und Kubernetes-Validierung
- Technische Dokumentation auf Deutsch und Englisch

## What This Repository Shows

- Azure landing-zone-like platform structure
- Reusable Terraform modules and separated root-stack simulations
- Remote-state and backend configuration per stack
- YAML-based configuration for routine platform changes
- Network segmentation for separated solutions or tenants
- Application Gateway/WAF as a central edge pattern
- Monitoring, security, storage and Key Vault framing as an operational basis
- Availability engineering with SLI, SLO, SLA and error budgets
- Review, approval and pipeline-based delivery processes
- Single source of truth through versioned configuration, documentation and
  changelogs
- Guardrails for Terraform, Kubernetes, security and operations
- Ansible configuration management with Terraform outputs as inventory source
- Kubernetes target structure for future AKS or k3s-like workloads
- GitHub Actions for Terraform, YAML and Kubernetes validation
- Technical documentation in German and English

## Abstrahierte Praxismuster

| Praxismuster | Im Repo sichtbar durch |
| --- | --- |
| Mandanten- oder Solution-orientierte Netzwerksegmentierung | `terraform/stacks/network`, `routing`, `firewall`, `docs/network-segmentation-pattern.md` |
| Zentrale Edge-Security mit Application Gateway/WAF | `terraform/stacks/application-gateway`, `docs/application-gateway-waf-pattern.md` |
| Konfigurationsgetriebene Skalierung | YAML-Dateien unter `terraform/stacks/*/config/` |
| Getrennte Root-Repositories mit eigenem State | `terraform/stacks/*`, Backend-Beispiele, `remote-state.tf` |
| Gemeinsame Plattformdienste | `terraform/stacks/shared-services` |
| Stateful Workloads und Self-Healing | `docs/stateful-workload-self-healing.md` |
| Azure VM Backup Policies und Restore-Automatisierung | `docs/restore-automation-pattern.md`, `docs/runbook.md` |
| Availability Engineering mit SLI, SLO, SLA und Error Budget | `docs/availability-engineering.md`, `docs/monitoring.md`, `docs/runbook.md` |
| Reviews, Pipelines und Approvals | `.github/workflows/validate.yml`, Stack-READMEs, Doku-Pattern |
| Single Source of Truth und Changelog | `docs/change-governance.md`, `CHANGELOG.md`, YAML-Konfiguration |
| Kubernetes-Zielstruktur | `docs/kubernetes-platform-pattern.md`, `kubernetes/`, `helm/`, `observability/` |
| Guardrails | `docs/guardrails.md`, `.github/workflows/validate.yml`, Kubernetes Security Contexts |
| Ansible Configuration Management | `docs/ansible-configuration-management.md`, `terraform/stacks/configuration-management` |
| Betrieb, Monitoring und Security | `docs/operating-model.md`, `docs/monitoring.md`, `docs/security-considerations.md`, `docs/runbook.md` |

## Real-World Patterns Reflected Here

| Real-world platform pattern | Reflected in this lab |
| --- | --- |
| Tenant- or solution-aware network segmentation | `terraform/stacks/network`, `routing`, `firewall`, `docs/network-segmentation-pattern.md` |
| Central edge security with Application Gateway/WAF | `terraform/stacks/application-gateway`, `docs/application-gateway-waf-pattern.md` |
| Configuration-driven scaling | YAML files below `terraform/stacks/*/config/` |
| Separate root repositories with independent state | `terraform/stacks/*`, backend examples, `remote-state.tf` |
| Shared platform services | `terraform/stacks/shared-services` |
| Stateful workload and self-healing considerations | `docs/stateful-workload-self-healing.md` |
| Azure VM Backup policies and restore automation | `docs/restore-automation-pattern.md`, `docs/runbook.md` |
| Availability engineering with SLI, SLO, SLA and error budgets | `docs/availability-engineering.md`, `docs/monitoring.md`, `docs/runbook.md` |
| Reviews, pipelines and approvals | `.github/workflows/validate.yml`, stack READMEs, documentation patterns |
| Single source of truth and changelog | `docs/change-governance.md`, `CHANGELOG.md`, YAML configuration |
| Kubernetes target structure | `docs/kubernetes-platform-pattern.md`, `kubernetes/`, `helm/`, `observability/` |
| Guardrails | `docs/guardrails.md`, `.github/workflows/validate.yml`, Kubernetes security contexts |
| Ansible configuration management | `docs/ansible-configuration-management.md`, `terraform/stacks/configuration-management` |
| Operations, monitoring and security thinking | `docs/operating-model.md`, `docs/monitoring.md`, `docs/security-considerations.md`, `docs/runbook.md` |

## Umsetzungsstand

Dieses Repository ist bewusst als **anonymisiertes Plattformbeispiel**
aufgebaut. Es ist kein 1:1-Abbild einer produktiven Kundenumgebung und keine
vollständige Enterprise Landing Zone.

Das Lab trennt drei Ebenen: sichtbar implementierte Terraform-Bausteine,
Architektur- oder Boundary-Stacks und Praxismuster, die aus Erfahrung
dokumentiert sind:

- `terraform/modules/` enthält wiederverwendbare Bausteine.
- `terraform/stacks/` simuliert getrennte Root-Repositories mit eigener
  Backend-Konfiguration und Remote-State-Übergaben.
- Einige Stacks modellieren bewusst Schnittstellen, Konfigurationsform und
  Integrationspunkte, ohne kundenspezifische Implementierungsdetails oder
  nicht freigabefähigen Code zu veröffentlichen.

Sichtbare Basismodule und Modulrahmen:

- `network`: Resource Group, Virtual Network und Subnets
- `monitoring`: Resource Group und Log Analytics Workspace
- `key-vault`: Security Resource Group als Key-Vault-Modulrahmen
- `storage`: Storage Resource Group als Plattform-Storage-Modulrahmen

Modellierte Boundary- und Ziel-Stacks:

- `routing`
- `firewall`
- `application-gateway`
- `compute`
- `aks`

## Implementation Status

This repository is intentionally structured as an **anonymized platform
showcase**. It is not a one-to-one copy of a production customer environment
and not a full enterprise landing zone implementation.

The lab separates three layers: visibly implemented Terraform building blocks,
architecture or boundary stacks and real-world patterns documented from
experience:

- `terraform/modules/` contains reusable building blocks.
- `terraform/stacks/` simulates separate root repositories with independent
  backend configuration and remote-state handovers.
- Some stacks intentionally model interfaces, configuration shape and
  integration points without publishing customer-specific implementation
  details or code that cannot be shared.

Visible baseline modules and module frames:

- `network`: resource group, virtual network and subnets
- `monitoring`: resource group and Log Analytics workspace
- `key-vault`: security resource group as Key Vault module frame
- `storage`: storage resource group as platform storage module frame

Modeled boundary and target stacks:

- `routing`
- `firewall`
- `application-gateway`
- `compute`
- `aks`

## Bezug Zu Meinem Profil

Dieses Lab spiegelt meine produktive Erfahrung und fachliche Zielrichtung wider:

- Azure Infrastructure und Platform Engineering
- Terraform-basierte Plattformstrukturen mit Environment-Trennung und Remote
  State
- YAML- und konfigurationsgetriebene Multi-Environment-Setups
- Availability Engineering mit SLI, SLO, SLA, Error Budget und
  handlungsrelevanten Alerts
- Netzwerk, Routing, Security, Firewall-Integration und Application Gateway/WAF
- RBAC- und IAM-Grenzen für Plattform- und Automatisierungszugriffe
- Azure DevOps Pipelines, Agent Pools und Git-basierte Delivery-Prozesse
- Ansible-basiertes Konfigurationsmanagement für Multi-Tier-VM-Workloads
- Terraform Outputs als Inventory-Quelle für getrennte Ansible-Pipelines
- Azure VM Backup Policies und automatische Backups nach definierten Regeln
  als dokumentiertes Betriebsmuster
- Python-basierte Restore-Automatisierung für stateful Solutions als
  anonymisiertes Pattern mit Logging, Drift-Vermeidung sowie
  RTO-/RPO-Ableitung
- Monitoring mit Azure Monitor, Log Analytics, PRTG-Erfahrung sowie
  Prometheus/Grafana-Zielbildern
- Kubernetes und Cloud Native als gezielte Weiterentwicklung

## Profile Fit

This lab reflects my production background and professional direction:

- Azure infrastructure and platform engineering
- Terraform-based platform structures with environment separation and remote
  state
- YAML- and configuration-driven multi-environment setups
- Availability engineering with SLI, SLO, SLA, error budgets and actionable
  alerts
- Networking, routing, security, firewall integration and Application
  Gateway/WAF
- RBAC and IAM boundaries for platform and automation access
- Azure DevOps pipelines, agent pools and Git-based delivery processes
- Ansible-based configuration management for multi-tier VM workloads
- Terraform outputs as inventory source for separate Ansible pipelines
- Azure VM Backup policies and automatic backups based on defined rules as a
  documented operating pattern
- Python-based restore automation for stateful solutions as an anonymized
  pattern with logging, drift avoidance and RTO/RPO derivation
- Monitoring with Azure Monitor, Log Analytics, PRTG experience and
  Prometheus/Grafana target patterns
- Kubernetes and cloud native as a deliberate professional development path

## Architekturidee

```text
YAML-Konfiguration
        |
        v
Root-Stack pro Plattformverantwortung
        |
        v
Remote-State-Outputs
        |
        v
Abhängiger Plattform-Stack
```

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

Der Ordner `environments/` dokumentiert einen ergänzenden zentralisierten
Konfigurationsstil. Der wichtigere Pfad in diesem Repository ist
`terraform/stacks/`, weil er getrennte Root-Repositories und unabhängige
State-Dateien modelliert.
`configuration-management` nutzt Compute-Outputs als Inventory-Quelle für
getrennte Ansible-Pipelines.

## Architecture Idea

```text
YAML configuration
        |
        v
Root stack per platform responsibility
        |
        v
Remote-state outputs
        |
        v
Dependent platform stack
```

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

The `environments/` folder documents a supplementary centralized
configuration style. The more important path in this repository is
`terraform/stacks/`, which models separate root repositories and independent
state files.
`configuration-management` consumes compute outputs as the inventory source for
separate Ansible pipelines.

## Repository-Struktur

```text
docs/
  architecture.md
  network-segmentation-pattern.md
  application-gateway-waf-pattern.md
  stateful-workload-self-healing.md
  restore-automation-pattern.md
  availability-engineering.md
  change-governance.md
  kubernetes-platform-pattern.md
  guardrails.md
  ansible-configuration-management.md
  platform-engineering-experience.md
  operating-model.md
  security-considerations.md
  monitoring.md
  cost-notes.md
  runbook.md

environments/
  testing|staging|production/
    backend.config.example
    terraform.tfvars.example
    platform.yaml

terraform/
  modules/
  stacks/

kubernetes/
helm/
observability/
```

## Repository Structure

The repository keeps documentation, Terraform modules, Terraform stack
simulations, Kubernetes examples, Helm values and observability notes in one
place that can be checked later.

## Designprinzipien

- Infrastruktur wird deklarativ beschrieben und versioniert.
- Module enthalten generische Plattformbausteine.
- Root-Stacks besitzen Deployment-Grenzen und klar definierte Outputs.
- Umgebungsspezifische Daten gehören in YAML oder tfvars-Dateien, nicht hart in
  Module.
- Security, Monitoring und Betrieb werden von Anfang an mitmodelliert.
- Plattformteams sollen Services wiederholbar bereitstellen können, ohne jedes
  Mal von vorne zu bauen.
- Keine Secrets, Kundennamen, kundenspezifischen IP-Adressräume oder
  produktiven Konfigurationen in Git.

## Design Principles

- Infrastructure is described declaratively and versioned.
- Modules contain generic platform building blocks.
- Root stacks own deployment boundaries and clearly defined outputs.
- Environment-specific data belongs in YAML or tfvars files, not hard-coded
  into modules.
- Security, monitoring and operations are modeled from the beginning.
- Platform teams should be able to provide services repeatedly without
  rebuilding everything from scratch.
- No secrets, customer names, customer-specific IP ranges or production
  configuration are stored in Git.

## Lokale Validierung

```bash
terraform -chdir=terraform fmt -check -recursive
yamllint environments kubernetes helm terraform/stacks .github/workflows
```

Beispiel für einen Stack:

```bash
cd terraform/stacks/network
terraform init -backend-config=backend/testing.azurerm.tfbackend.example
terraform plan -var environment=testing
```

Optionale Kubernetes-Validierung:

```bash
kubeconform -summary -strict kubernetes
```

## Local Validation

```bash
terraform -chdir=terraform fmt -check -recursive
yamllint environments kubernetes helm terraform/stacks .github/workflows
```

Example for a stack:

```bash
cd terraform/stacks/network
terraform init -backend-config=backend/testing.azurerm.tfbackend.example
terraform plan -var environment=testing
```

Optional Kubernetes validation:

```bash
kubeconform -summary -strict kubernetes
```

## Hinweise

Dieses Repository ist bewusst anonymisiert. Es enthält keine produktiven
Kundendaten, kundenspezifischen IP-Adressräume, Tokens oder vertraulichen
Architekturdetails.

## Notes

This repository is intentionally anonymized. It does not contain production
customer data, customer-specific IP ranges, tokens or confidential architecture
details.

## License / Usage

Copyright (c) 2026 Annett Berlinger. All rights reserved.

Dieses Repository ist ein persönliches Portfolio und anonymisiertes
Architekturbeispiel. Eine Nutzung, Kopie, Weiterveröffentlichung oder
Bearbeitung der Inhalte, Dokumentation, Beispiele, Struktur, Diagramme oder
Code-Dateien ist ohne vorherige schriftliche Zustimmung nicht erlaubt.

This repository is a personal portfolio and anonymized architecture-pattern
example. No license is granted for copying, reuse, redistribution,
publication, sublicensing, sale or derivative works based on the content,
documentation, examples, structure, diagrams or code without prior written
permission.

See [LICENSE](LICENSE) for the full notice.
