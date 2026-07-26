# Stateful Workloads und Self-Healing / Stateful Workloads and Self-Healing

## Ziel

Dieses Pattern beschreibt Plattformüberlegungen für stateful Enterprise-
Workloads. Ziel ist, Recovery, Automatisierung und Betrieb möglich zu machen,
ohne so zu tun, als wären alle Workloads stateless Cloud-Native-Services.

## Purpose

This pattern describes platform considerations for stateful enterprise
workloads. The goal is to make recovery, automation and operations possible
without pretending that every workload behaves like a stateless cloud-native
service.

## Problem

Lokaler VM-Storage kann Recovery unzuverlässig machen. Wenn Laufzeitdaten, Logs,
Task-Zustand, Print-Daten oder Applikationsordner nur auf einer Maschine liegen,
können automatischer Neustart oder Ersatz inkonsistentes Verhalten erzeugen.

Self-Healing setzt voraus, dass alle relevanten Komponenten denselben
erforderlichen Zustand sehen können.

## Problem

Local VM storage can make recovery unreliable. If runtime data, logs, task
state, print data or application folders live only on one machine, automated
restart or replacement can produce inconsistent behavior.

Self-healing requires that all relevant components can see the same required
state.

## Bevorzugte Richtung

Für Workloads mit gemeinsam benötigten Laufzeitdaten sollte pro Solution eine
gemeinsame Storage-Grenze modelliert werden.

Typisches Azure-Design:

- dedizierter Storage Account oder Share pro Solution
- Private Endpoint für netzwerklokalen Zugriff
- system-assigned oder user-assigned Managed Identities
- Azure RBAC für Zugriffskontrolle
- NSG- und Routing-Kontrollen, damit Zugriff nur aus freigegebenen Subnetzen
  möglich ist
- Diagnostic Settings für Auditierbarkeit und Betrieb

## Preferred Direction

Use per-solution shared storage where the workload requires shared
runtime files.

Typical Azure design:

- dedicated storage account or share per solution
- private endpoint for network-local access
- system-assigned or user-assigned managed identities
- Azure RBAC for access control
- NSG and routing controls so access is possible only from approved subnets
- diagnostic settings for later checks and operations

## Fallback-Betrachtung

Wenn ein verwalteter File Service nicht erlaubt ist, kann ein VM-basierter File
Share als Fallback genutzt werden. Dieses Design muss als Risikoentscheidung
behandelt werden, weil es einen Single Point of Failure erzeugen kann.

Mögliche Gegenmaßnahmen:

- Snapshots
- Backup- und Restore-Tests
- Failover-Design
- Monitoring der Share-Verfügbarkeit
- dokumentierte Recovery-Schritte

## Fallback Considerations

If a managed file service is not allowed, a VM-hosted file share may be used as
a fallback. That design must be treated as a risk decision because it can create
a single point of failure.

Required mitigations may include:

- snapshots
- backup and restore testing
- failover design
- monitoring of share availability
- documented recovery steps

## Restore-Automatisierung

Für eine Solution mit besonderen Recovery-Anforderungen habe ich in der Praxis
einen modularen Recovery-Orchestrator mit Bash-Einstieg, Python-Modulen, Azure
CLI, Terraform und Pipeline-Anbindung umgesetzt. In diesem Repository ist der
Ablauf als Pattern dokumentiert, weil der konkrete Code nicht veröffentlicht
wird. Wichtig war dabei, dass die mehrstufige Solution nach dem Restore nicht
nur wieder läuft, sondern als Gesamtsystem in einen gemeinsam freigegebenen,
technisch vollständigen Zustand zurückkehrt: Daten, Zuordnung, Zugriff und
Konfiguration müssen zusammenpassen.

Die Grundlage dafür waren automatische Azure-Backups der betroffenen VMs nach
definierten Policies. Auch das ist hier als Betriebslogik dokumentiert, nicht
als produktiver Policy-Code. Diese Regeln bestimmen, welche Maschinen geschützt
sind, wie oft gesichert wird und welche Recovery Points für einen Restore zur
Verfügung stehen. Erst dadurch kann man RPO sinnvoll prüfen, statt nur darüber
zu sprechen.

Am Anfang gab es dabei noch Terraform Drift. Das war genau die Art Problem, die
man nur findet, wenn Restore nicht nur theoretisch beschrieben, sondern wirklich
durchgespielt und geloggt wird. Der Ablauf wurde so angepasst, dass der Restore
nicht gegen Terraform arbeitet und die Umgebung danach wieder sauber erklärbar
bleibt.

## Restore Automation

For a solution with specific recovery requirements, I implemented a modular
recovery orchestrator with a Bash entry point, Python modules, Azure CLI,
Terraform and pipeline integration. In this repository, the flow is documented
as a pattern because the concrete code is not published. The important point
was that the multi-tier solution did not merely run again after restore, but
returned as one system to a jointly approved, technically complete state:
data, assignment, access and configuration had to fit together.

The foundation for this was automatic Azure backups of the affected VMs based
on defined policies. This is documented here as operating logic, not as
production policy code. These rules define which machines are protected, how
often backups run and which recovery points are available for restore. Only
then can RPO be checked in a meaningful way instead of only discussed.

At the beginning, this still created Terraform drift. That was exactly the kind
of issue that only appears when restore is not only described in theory, but
actually tested and logged. The flow was adjusted so the restore does not work
against Terraform and the environment remains explainable afterwards.

## Automatisierungsmodell

Das gewünschte Betriebsmodell kombiniert:

- Terraform für Infrastruktur und Zugriffsgrenzen
- YAML-Konfiguration für Solution-Intent
- Ansible oder vergleichbare Werkzeuge für VM-Konfiguration
- CI/CD-Pipelines für wiederholbare Bereitstellung
- Azure VM Backup Policies für automatische Sicherungen nach definierten
  Regeln
- Monitoring und Alerting für Laufzeitfeedback
- Runbooks für bekannte Fehler- und Recovery-Pfade
- Python-basierte Restore-Automatisierung für Abläufe, die Schrittfolge,
  Logging und Drift-Prüfung brauchen

## Automation Model

The desired operating model combines:

- Terraform for infrastructure and access boundaries
- YAML configuration for solution-level intent
- Ansible or similar tooling for VM configuration
- CI/CD pipelines for repeatable delivery
- Azure VM Backup policies for automatic backups based on defined rules
- monitoring and alerting for runtime feedback
- runbooks for known failure and recovery paths
- Python-based restore automation for flows that need step orchestration,
  logging and drift checks

## Repo-Bezug

- `terraform/stacks/shared-services` modelliert gemeinsame Monitoring-,
  Key-Vault- und Storage-Grenzen.
- `compute.virtual_machines` in
  `environments/nonproduction/nonproduction.yaml` modelliert VM-Intent als
  Daten.
- `docs/monitoring.md`, `docs/runbook.md` und `docs/operating-model.md`
  dokumentieren die Betriebsseite.
- `docs/restore-automation-pattern.md` beschreibt Azure VM Backup Policies,
  Restore-Ablauf, Logging, RTO/RPO-Ableitung und Drift-Vermeidung.

## Repository Mapping

- `terraform/stacks/shared-services` models shared monitoring, Key Vault and
  storage boundaries.
- `compute.virtual_machines` in
  `environments/nonproduction/nonproduction.yaml` models VM intent as data.
- `docs/monitoring.md`, `docs/runbook.md` and `docs/operating-model.md`
  document the operational side.
- `docs/restore-automation-pattern.md` describes Azure VM Backup policies,
  restore flow, logging, RTO/RPO derivation and drift avoidance.
