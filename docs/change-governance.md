# Change Governance und Single Source of Truth / Change Governance and Single Source of Truth

## Ziel

Dieses Pattern beschreibt, wie Plattformänderungen nachvollziehbar bleiben.
Der Kern ist einfach: Konfiguration, Dokumentation und Änderungsverlauf liegen
versioniert im Repository. Das Repository ist damit die Single Source of Truth.
Änderungen sollen nicht im Portal, in lokalen Notizen oder in den Köpfen
einzelner Personen verschwinden.

## Purpose

This pattern describes how platform changes stay understandable later. The core
is simple: configuration, documentation and change history are versioned in the
repository. The repository is the single source of truth. Changes should not
disappear into the portal, local notes or individual people's heads.

## Versionierte Grundlage

Die gewünschte Plattformform soll aus versionierten Dateien ableitbar sein:

- YAML-Dateien beschreiben Umgebung, Solutions, Subnetze, Regeln, Backends und
  Workload-Intent.
- Terraform-Stacks interpretieren diese Konfiguration und erzeugen die
  Infrastruktur.
- Terraform Outputs und Remote State bilden die Übergabe zwischen Stacks.
- Ansible konsumiert veröffentlichte Outputs als Inventory-Quelle für
  VM-Konfiguration.
- README-Dateien erklären Zweck, Eingaben, Outputs und Betriebsgrenzen.
- Pattern-Dokumente halten Architekturentscheidungen und Betriebsmodelle fest.
- Changelogs dokumentieren relevante Änderungen und Migrationshinweise.

Damit bleibt das Repository die Single Source of Truth. Es gibt keine
versteckte Wahrheit in manuellen Portaleinstellungen, lokalen Notizen oder
einzelnen Personen.

## Versioned Foundation

The desired platform shape should be derivable from versioned files:

- YAML files describe environment, solutions, subnets, rules, backends and
  workload intent.
- Terraform stacks interpret this configuration and create the infrastructure.
- Terraform outputs and remote state form the handover between stacks.
- Ansible consumes published outputs as the inventory source for VM
  configuration.
- README files explain purpose, inputs, outputs and operational boundaries.
- Pattern documents capture architecture decisions and operating models.
- Changelogs document relevant changes and migration notes.

This keeps the repository as the single source of truth. It avoids hidden truth
in manual portal settings, local notes or individual people's heads.

## Review- und Approval-Modell

Plattformänderungen sollten über Pull Requests laufen:

- Änderung an YAML, Terraform, Kubernetes oder Doku
- automatische Validierung über Pipeline
- Review durch fachlich passende Personen
- Approval für produktionsnahe Änderungen
- Merge erst nach erfolgreicher Validierung
- Changelog-Eintrag für relevante Änderungen

Dieses Modell macht Änderungen nachvollziehbar. Man sieht später, was geändert
wurde, wer geprüft hat und welche Pipeline gelaufen ist.

## Review and Approval Model

Platform changes should go through pull requests:

- change to YAML, Terraform, Kubernetes or documentation
- automatic validation through pipeline
- review by suitable subject-matter owners
- approval for production-like changes
- merge only after successful validation
- changelog entry for relevant changes

This model keeps changes understandable later. It shows what changed, who
checked it and which pipeline ran.

## Changelog-Prinzip

Changelogs helfen, technische Entwicklung nachvollziehbar zu halten. Sie sollten
nicht jede Kleinigkeit wiederholen, sondern relevante Änderungen erklären:

- neue Plattformfähigkeit
- Änderung an Netzwerk-, WAF- oder Firewall-Verhalten
- neue Konfigurationsoption
- Breaking Change
- Migration oder manuelle Nacharbeit
- relevante Betriebs- oder Security-Auswirkung

## Changelog Principle

Changelogs help keep technical evolution understandable later. They should not
repeat every small edit, but explain relevant changes:

- new platform capability
- change to network, WAF or firewall behavior
- new configuration option
- breaking change
- migration or manual follow-up
- relevant operational or security impact

## Pipeline-Gates

Typische Gates:

- Terraform formatting
- Terraform validation
- YAML linting
- Kubernetes schema validation
- Configuration-management output checks
- optionale Policy- oder Security-Prüfungen
- manuelle Approval-Stufe für produktionsnahe Änderungen

## Pipeline Gates

Typical gates:

- Terraform formatting
- Terraform validation
- YAML linting
- Kubernetes schema validation
- configuration-management output checks
- optional policy or security checks
- manual approval stage for production-like changes

## Repo-Bezug

- `.github/workflows/validate.yml` zeigt automatische Validierung.
- `terraform/stacks/*/config/testing.yaml` zeigt Konfiguration als
  versionierte Quelle.
- `kubernetes/` und `helm/` zeigen Kubernetes-Konfiguration als versionierte
  Quelle.
- `terraform/stacks/configuration-management` zeigt Terraform Outputs als
  Inventory-Quelle für Ansible.
- `CHANGELOG.md` dokumentiert die Entwicklung dieses Repositories.
- `docs/availability-engineering.md` verbindet Changes mit SLI/SLO,
  Error Budget und Betriebsentscheidungen.

## Repository Mapping

- `.github/workflows/validate.yml` shows automatic validation.
- `terraform/stacks/*/config/testing.yaml` shows configuration as versioned
  source.
- `kubernetes/` and `helm/` show Kubernetes configuration as versioned source.
- `terraform/stacks/configuration-management` shows Terraform outputs as an
  inventory source for Ansible.
- `CHANGELOG.md` documents the evolution of this repository.
- `docs/availability-engineering.md` connects changes with SLI/SLO, error
  budgets and operational decisions.
