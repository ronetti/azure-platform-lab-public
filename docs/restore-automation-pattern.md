# Restore-Automatisierung / Restore Automation

## Ziel

Dieses Pattern beschreibt eine Restore-Automatisierung für eine Solution mit
besonderen Recovery-Anforderungen. Das Ziel war nicht nur, Ressourcen wieder
hochzufahren. Die Solution musste so wiederhergestellt werden, dass Zustand,
Konfiguration und Zuordnung wieder wie vorher nachvollziehbar zusammenpassen.

In der praktischen Umsetzung habe ich dafür einen modularen
Recovery-Orchestrator mit Bash-Einstieg, Python-Modulen, Azure CLI, Terraform
und Pipeline-Anbindung entwickelt. Er behandelt die mehrstufige Solution als
zusammengehöriges System und führt sie auf einen gemeinsam freigegebenen,
technisch vollständigen Wiederherstellungsstand zurück. Der konkrete Code ist
hier nicht veröffentlicht. Das Pattern zeigt die Struktur, die Betriebslogik
und die Fragen, die dadurch prüfbar wurden.

Gerade dieses Logging war wichtig: Damit konnte ich später sehen, welche
Schritte wie lange dauern, wo Risiken liegen und wie realistische RTO- und
RPO-Ziele aussehen können.

## Purpose

This pattern describes restore automation for a solution with specific recovery
requirements. The goal was not only to bring resources back. The solution had
to be restored so that state, configuration and assignment matched the previous
shape in an understandable way.

In the practical implementation, I developed a modular recovery orchestrator
with a Bash entry point, Python modules, Azure CLI, Terraform and pipeline
integration. It treats the multi-tier solution as one connected system and
returns it to a jointly approved, technically complete recovery state. The
concrete code is not published here. This pattern shows the structure,
operating logic and questions that became checkable through that work.

That logging mattered: it made it possible to see how long individual steps
took, where the risks were and how realistic RTO and RPO targets could be
defined.

## Backup-Policies Vor Dem Restore

Vor dem Restore steht die Frage, ob es überhaupt verlässliche Restore-Punkte
gibt. In der realen Umsetzung wurden für die betroffenen VMs automatische
Azure-Backups nach definierten Regeln eingerichtet. In diesem Repository ist
das als Betriebs-Pattern dokumentiert, nicht als veröffentlichter produktiver
Policy-Code. Die Policies legen fest, welche VMs geschützt werden, wie oft
gesichert wird und wie lange Recovery Points aufbewahrt werden.

Das war kein losgelöster Backup-Haken im Portal, sondern Teil des
Betriebsmodells:

- Backup-Regeln müssen zur Wichtigkeit der Solution passen.
- Die letzte erfolgreiche Sicherung muss prüfbar sein.
- Das Alter des Recovery Points beeinflusst das RPO.
- Die gemessene Restore-Dauer beeinflusst das RTO.
- Nach dem Restore darf kein Terraform Drift übrig bleiben.

Die Backup-Policy erzeugt also die Grundlage. Die Restore-Automatisierung zeigt
danach, ob diese Grundlage im Ernstfall wirklich nutzbar ist.

## Backup Policies Before Restore

Before restore, the first question is whether reliable restore points exist at
all. In the real implementation, automatic Azure backups were configured for
the affected VMs according to defined rules. In this repository, that is
documented as an operating pattern, not as published production policy code.
The policies define which VMs are protected, how often backups run and how long
recovery points are retained.

This was not just a disconnected backup checkbox in the portal. It was part of
the operating model:

- backup rules must fit the importance of the solution
- the last successful backup must be checkable
- the age of the recovery point influences RPO
- the measured restore duration influences RTO
- after restore, no Terraform drift should remain

The backup policy creates the foundation. The restore automation then proves
whether that foundation can actually be used during recovery.

## Warum Das Wichtig War

Bei stateful Workloads reicht es nicht, eine VM oder einen Storage-Baustein neu
zu erstellen. Entscheidend ist, ob die Solution danach fachlich wieder gleich
funktioniert:

- Sind die richtigen Daten wieder am richtigen Ort?
- Stimmen Netzzuordnung, Zugriff und Konfiguration?
- Ist der Restore-Ablauf wiederholbar?
- Kann man später nachvollziehen, welcher Schritt was getan hat?
- Entsteht nach dem Restore Terraform Drift?

Am Anfang gab es noch Drift zwischen Restore-Ablauf und Terraform-Zustand. Das
war ein wichtiger Fund, weil ein erfolgreicher Restore wenig hilft, wenn danach
die Infrastruktur nicht mehr sauber über Terraform erklärbar ist. Der Ablauf
wurde so angepasst, dass der Restore nicht gegen Terraform arbeitet.

## Why This Mattered

For stateful workloads, recreating a VM or storage component is not enough. The
important question is whether the solution works the same way afterwards:

- Are the right data restored to the right place?
- Do network placement, access and configuration still match?
- Is the restore flow repeatable?
- Can the individual steps be understood later?
- Does the restore create Terraform drift?

At the beginning, there was still drift between the restore flow and Terraform
state. That was an important finding, because a successful restore is not very
useful if the infrastructure is no longer explainable through Terraform
afterwards. The flow was adjusted so the restore does not work against
Terraform.

## Technisches Muster

Der Recovery-Orchestrator war für den zeitlich begrenzten Ablauf zuständig,
nicht für die
dauerhafte Beschreibung der Infrastruktur. Diese Grenze war wichtig:

- Terraform beschreibt die Infrastruktur und ihre gewünschten Eigenschaften.
- Azure Backup Policies sichern die betroffenen VMs nach definierten Regeln.
- Das Restore-Modul führt den zeitlich begrenzten Recovery-Ablauf aus.
- Logging hält jeden Schritt, jede Dauer und relevante Ergebnisse fest.
- Nach dem Restore wird geprüft, ob Terraform weiterhin die Umgebung erklären
  kann.
- RTO und RPO werden nicht geraten, sondern aus gemessenen Restore-Abläufen
  abgeleitet.

In der beruflichen Umsetzung wählte der Orchestrator je VM den passenden
Classic-, Full-Disk-, Terraform-Rebuild- oder Ad-hoc-Snapshot-Pfad. Er
behandelte auch gemischte VM-Zustände innerhalb derselben Solution und führte
Netzwerkzuordnung, statische IPs, OS- und Data-Disks, LUN-Zuordnungen,
Service-Kontext, Monitoring-Anbindung und Terraform-Lifecycle kontrolliert
zusammen. Dry-Run, exakte Recovery-Point-Auswahl, Pre-/Post-Checks,
Disk-/IP-Prüfungen, definierte Reihenfolgen, Stop-Kriterien und
VM-spezifisches Logging sicherten den Ablauf ab.

Für fehlgeschlagene Patches oder Updates muss der Restore die Solution als
Multi-Tier-System behandeln. Es reicht nicht, nur eine einzelne VM
zurückzusetzen. Der Ablauf muss erkennen, welche Solution betroffen ist, welche
Tier-Komponenten dazu gehören und welcher Stand wiederhergestellt werden soll.

Ein sinnvoller Pipeline-Ablauf ist:

- Alert oder Update-Fehler erkennt die betroffene Solution.
- Mail oder Teams informiert das Betriebsteam.
- Die Restore-Pipeline wird mit Parametern gestartet, zum Beispiel Solution,
  Umgebung und Recovery Point.
- Vor dem Restore wird geprüft, ob ein Approval erforderlich ist.
- App-, SQL-, PRT- und weitere betroffene VM- oder Service-Komponenten werden
  in einer definierten Reihenfolge behandelt.
- Nach dem Restore laufen Ansible-Konfiguration, Health Checks und
  Applikationsprüfungen.
- Danach wird ein Terraform Plan gegen Drift geprüft.
- Logging hält Dauer, Ergebnis, Recovery Point und Abweichungen fest.

## Technical Pattern

The recovery orchestrator handled the time-bound flow, not the long-term
description of the infrastructure. That line mattered:

- Terraform describes the infrastructure and its intended shape.
- Azure Backup policies protect the affected VMs according to defined rules.
- The restore module runs the time-bound recovery flow.
- Logging records each step, duration and relevant result.
- After the restore, Terraform is checked again as the source for explaining
  the environment.
- RTO and RPO are not guessed; they are derived from measured restore runs.

In the professional implementation, the orchestrator selected the appropriate
classic, full-disk, Terraform rebuild or ad-hoc snapshot path for each VM. It
also handled mixed VM states within one solution and brought network
assignment, static IPs, OS and data disks, LUN mappings, service context,
monitoring integration and Terraform lifecycle back together in a controlled
way. Dry runs, exact recovery-point selection, pre- and post-checks, disk and
IP validation, defined execution order, stop criteria and VM-specific logging
protected the flow.

For failed patches or updates, restore has to treat the solution as a
multi-tier system. Resetting only one VM is not enough. The flow has to detect
which solution is affected, which tier components belong to it and which state
should be restored.

A useful pipeline flow is:

- An alert or update failure identifies the affected solution.
- Email or Teams notifies the operations team.
- The restore pipeline is started with parameters, for example solution,
  environment and recovery point.
- Before restore, the flow checks whether approval is required.
- App, SQL, PRT and other affected VM or service components are handled in a
  defined order.
- After restore, Ansible configuration, health checks and application checks
  run.
- A Terraform plan is run afterwards to check for drift.
- Logging records duration, result, recovery point and deviations.

## Was Ich Daraus Mitnehme

Der wichtigste Punkt war für mich: Restore ist kein einzelner Knopf. Restore
ist ein Ablauf, der beweisen muss, dass eine Solution danach wieder fachlich
brauchbar ist und trotzdem sauber zur Infrastruktur-Automatisierung passt.

Darum gehören Backup-Policies, Restore-Automatisierung, Monitoring, Runbooks,
Terraform Drift Checks und Availability Engineering für mich zusammen. Ohne
Messung bleiben RTO und RPO theoretisch. Mit sauberem Logging werden sie
diskutierbar.

## What I Take From It

The most important point for me was: restore is not a single button. Restore is
a flow that has to prove that a solution is useful again afterwards and still
fits the infrastructure automation around it.

That is why backup policies, restore automation, monitoring, runbooks,
Terraform drift checks and availability engineering belong together for me.
Without measurement, RTO and RPO stay theoretical. With useful logging, they
become something a team can discuss.

## Repo-Bezug

- `docs/stateful-workload-self-healing.md` beschreibt die Recovery-Fragen für
  stateful Workloads.
- `docs/availability-engineering.md` ordnet RTO, RPO, SLO und Error Budget in
  Betriebsentscheidungen ein.
- `docs/runbook.md` enthält Prüfungen für Drift, Monitoring und
  Incident-Nachbereitung.
- Der konkrete Python-Code ist hier nicht enthalten, weil dieses Repository
  anonymisiert ist. Das Pattern dokumentiert die Architektur- und
  Betriebslogik.

## Repository Mapping

- `docs/stateful-workload-self-healing.md` describes the recovery questions for
  stateful workloads.
- `docs/availability-engineering.md` connects RTO, RPO, SLO and error budget to
  operational decisions.
- `docs/runbook.md` contains checks for drift, monitoring and incident
  follow-up.
- The concrete Python code is not included here because this repository is
  anonymized. This pattern documents the architecture and operating logic.
