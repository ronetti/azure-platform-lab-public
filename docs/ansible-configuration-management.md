# Ansible Configuration Management

## Ziel

Dieses Pattern beschreibt die Trennung zwischen Infrastruktur-Provisionierung
und Betriebssystem-/Applikationskonfiguration. Terraform stellt Infrastruktur
bereit und veröffentlicht Inventory-relevante Outputs. Ansible nutzt diese
Outputs als Quelle für die Konfiguration von VMs.

Ich würde VM-Konfiguration nicht in Terraform verstecken. Terraform soll die
Infrastruktur und die nötigen Outputs liefern. Was auf einer VM installiert,
konfiguriert oder regelmäßig angepasst wird, gehört für mich in eine eigene
Configuration-Management-Pipeline.

Der wichtige Punkt ist der Übergabepunkt dazwischen: Terraform veröffentlicht die
Host-Daten, Ansible konsumiert sie. So muss niemand Hosts doppelt pflegen, und
Änderungen an Betriebssystem oder Services laufen nicht unbemerkt als
Infrastrukturänderung mit.

## Purpose

This pattern describes the separation between infrastructure provisioning and
operating-system or application configuration. Terraform provisions
infrastructure and publishes inventory-relevant outputs. Ansible consumes these
outputs as the single source of truth for VM configuration.

I would not hide VM configuration inside Terraform. Terraform should provide
the infrastructure and the required outputs. What gets installed, configured or
changed regularly on a VM belongs in a separate configuration-management
pipeline.

The important part is the handover point between both sides: Terraform publishes host
data, Ansible consumes it. Hosts do not need to be maintained twice, and
operating-system or service changes do not silently ride along as
infrastructure changes.

## Verantwortungsgrenzen

- Terraform erstellt Ressourcen, Netzwerkzuordnung, Identitäten und Outputs.
- Terraform Remote State liefert die VM-Daten für das Inventory.
- Ansible konfiguriert Betriebssystem, Packages, Services, Laufzeitordner und
  Applikationsparameter.
- Dazu können auch Monitoring-Agenten oder Exporter gehören, mit denen VM-,
  Service- oder SQL-nahe Metriken später in Prometheus/Grafana oder Log
  Analytics sichtbar werden.
- Ansible-Pipelines laufen getrennt von Terraform-Pipelines.
- Reviews, Approvals und Guardrails gelten auch für Playbooks, Rollen und
  Inventory-Mapping.

## Responsibility Boundaries

- Terraform creates resources, network placement, identities and outputs.
- Terraform remote state provides the VM data for the inventory.
- Ansible configures operating system, packages, services, runtime folders and
  application parameters.
- This can also include monitoring agents or exporters that make VM, service or
  SQL-related metrics visible later in Prometheus/Grafana or Log Analytics.
- Ansible pipelines run separately from Terraform pipelines.
- Reviews, approvals and guardrails also apply to playbooks, roles and
  inventory mapping.

## Terraform Als Inventory-Quelle

Terraform sollte nicht nur VMs erzeugen, sondern die relevanten Daten für
Configuration Management veröffentlichen:

- VM-Name
- private IP
- Subnetz oder Rolle
- Umgebung
- Tags
- Monitoring- oder Log-Analytics-Bezug
- optionale Gruppen wie `management`, `app`, `data`, `runner`

Ansible kann daraus dynamisches Inventory ableiten. Dadurch müssen Hosts nicht
manuell gepflegt werden.

In diesem Repository ist das bewusst als Übergabepunkt modelliert, nicht als
vollständige Ansible-Landschaft. Der nächste sinnvolle Schritt wäre ein kleines
`ansible/`-Beispiel mit Inventory-Generierung, Rolle, Playbook und
`ansible-lint`. Für dieses Repository ist zuerst wichtig, dass die Grenze sauber
sichtbar ist.

## Terraform as Inventory Source

Terraform should not only create VMs, but publish the relevant data for
configuration management:

- VM name
- private IP
- subnet or role
- environment
- tags
- monitoring or Log Analytics reference
- optional groups such as `management`, `app`, `data`, `runner`

Ansible can derive dynamic inventory from this. Hosts do not need to be managed
manually.

In this repository, this is intentionally modeled as a handover point, not as a full
Ansible implementation. A useful next step would be a small `ansible/` example
with inventory generation, a role, a playbook and `ansible-lint`. For this
repository, the first important part is making the line between Terraform and
Ansible visible.

## Azure DevOps Managed Pools

Ein sinnvolles Betriebsmodell ist die Ausführung von Ansible über eigene Azure
DevOps Pipelines und Managed DevOps Pools. Dadurch bleibt Configuration
Management getrennt, wiederholbar und nachvollziehbar.

Mir ist diese Trennung wichtig, weil Terraform-Pläne sonst schnell zu viel
Verantwortung bekommen. Ein Plan soll Infrastrukturänderungen sichtbar machen.
Ein Ansible-Lauf soll Konfigurationsänderungen sichtbar machen. Beides braucht
Reviews, aber nicht zwingend denselben Ablauf.

Typische Pipeline-Schritte:

- Linting für YAML und Ansible Playbooks
- Syntax Check
- Inventory-Generierung aus Terraform Outputs oder Remote State
- Dry Run beziehungsweise Check Mode
- Approval für produktionsnahe Zielgruppen
- Ausführung gegen definierte Host-Gruppen
- Changelog oder Deployment-Notiz

## Azure DevOps Managed Pools

A useful operating model is running Ansible through dedicated Azure DevOps
pipelines and managed DevOps pools. This keeps configuration management
separate, repeatable and understandable later.

This separation matters because Terraform plans can otherwise take on too much
responsibility. A plan should make infrastructure changes visible. An Ansible
run should make configuration changes visible. Both need reviews, but not
necessarily the same workflow.

Typical pipeline steps:

- linting for YAML and Ansible playbooks
- syntax check
- inventory generation from Terraform outputs or remote state
- dry run or check mode
- approval for production-like target groups
- execution against defined host groups
- changelog or deployment note

## Ansible-Guardrails

Beispiele für Guardrails:

- Playbooks sind idempotent.
- Rollen sind modular und wiederverwendbar.
- Secrets liegen nicht im Repository.
- Änderungen laufen über Pull Requests.
- Pipeline prüft Syntax und Linting.
- Check Mode wird vor produktionsnaher Ausführung genutzt.
- Inventory wird aus Terraform Outputs abgeleitet.
- Änderungen an kritischen Rollen benötigen Approval.

## Ansible Guardrails

Examples of guardrails:

- playbooks are idempotent
- roles are modular and reusable
- secrets are not stored in the repository
- changes go through pull requests
- pipeline checks syntax and linting
- check mode is used before production-like execution
- inventory is derived from Terraform outputs
- changes to critical roles require approval

## Repo-Bezug

- `terraform/stacks/compute/outputs.tf` veröffentlicht VM-Intent.
- `terraform/stacks/configuration-management` modelliert die Inventory-Quelle
  für Ansible.
- `docs/change-governance.md` beschreibt Reviews, Approvals und Changelog.
- `docs/guardrails.md` beschreibt Pipeline- und Security-Leitplanken.

## Repository Mapping

- `terraform/stacks/compute/outputs.tf` publishes VM intent.
- `terraform/stacks/configuration-management` models the inventory source for
  Ansible.
- `docs/change-governance.md` describes reviews, approvals and changelog.
- `docs/guardrails.md` describes pipeline and security guardrails.
