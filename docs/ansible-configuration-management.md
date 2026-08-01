# Ansible Configuration Management

## Ziel

Dieses Pattern beschreibt die Trennung zwischen Infrastruktur-Provisionierung
und Betriebssystem-/Applikationskonfiguration. Terraform stellt Infrastruktur
bereit und veröffentlicht Inventory-relevante Outputs. Ansible nutzt diese
Outputs als Quelle für die Konfiguration von VMs.

In meiner beruflichen Umsetzung habe ich VM-Konfiguration bewusst nicht in
Terraform versteckt. Terraform liefert die Infrastruktur und die nötigen
Outputs. Was auf einer VM installiert, konfiguriert oder regelmäßig angepasst
wird, liegt in einer eigenen Configuration-Management-Pipeline.

Der wichtige Punkt ist der Übergabepunkt dazwischen: Terraform veröffentlicht die
Host-Daten, Ansible konsumiert sie. So muss niemand Hosts doppelt pflegen, und
Änderungen an Betriebssystem oder Services laufen nicht unbemerkt als
Infrastrukturänderung mit.

## Purpose

This pattern describes the separation between infrastructure provisioning and
operating-system or application configuration. Terraform provisions
infrastructure and publishes inventory-relevant outputs. Ansible consumes these
outputs as the inventory source for VM configuration.

In my professional implementation, I deliberately kept VM configuration out of
Terraform. Terraform provides the infrastructure and the required outputs.
What gets installed, configured or changed regularly on a VM belongs in a
separate configuration-management pipeline.

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

Terraform erzeugt nicht nur VMs, sondern veröffentlicht die relevanten Daten
für Configuration Management:

- VM-Name
- private IP
- Subnetz oder Rolle
- Umgebung
- Tags
- Monitoring- oder Log-Analytics-Bezug
- optionale Gruppen wie `management`, `app`, `data`, `runner`

Ansible leitet daraus das Inventory ab. Dadurch müssen Hosts nicht manuell
parallel gepflegt werden.

Beruflich habe ich diese Trennung mit modularen Rollen und Playbooks,
containerisierten ephemeren Ausführungsumgebungen, Azure-DevOps-Pipelines und
Agent Pools umgesetzt. Inventory-Daten kamen aus Terraform Outputs
beziehungsweise Remote State; Linting, Syntax Check, Check Mode, Reviews und
Approvals sicherten die Abläufe ab.

Dieses öffentliche Repository bildet davon bewusst nur die anonymisierte
Übergabe ab. Nicht veröffentlichte Originalimplementierungen bleiben
außen vor. Ein späteres
`ansible/`-Portfolio-Beispiel kann Inventory-Generierung, eine eigenständig
geschriebene Demo-Rolle, ein Playbook und `ansible-lint` zeigen. Die
berufliche Umsetzung und die öffentlich sichtbare Demo-Tiefe bleiben dabei
bewusst getrennt.

## Terraform as Inventory Source

Terraform does not only create VMs. It also publishes the relevant data for
configuration management:

- VM name
- private IP
- subnet or role
- environment
- tags
- monitoring or Log Analytics reference
- optional groups such as `management`, `app`, `data`, `runner`

Ansible derives its inventory from this data. Hosts do not need to be
maintained manually in parallel.

I implemented this separation professionally with modular roles and playbooks,
containerized ephemeral execution environments, Azure DevOps pipelines and
agent pools. Inventory data came from Terraform outputs or remote state;
linting, syntax checks, check mode, reviews and approvals protected the flows.

This public repository intentionally represents only the anonymized handover
pattern, not original non-public source code. A later `ansible/` portfolio example can
show inventory generation, an independently written demo role, a playbook and
`ansible-lint`. Professional implementation and the depth of the public demo
remain deliberately separate.

## Azure DevOps Pipelines Und Agent Pools

Ich habe Ansible über eigene Azure DevOps Pipelines auf Agent Pools ausgeführt.
Containerisierte, ephemere Ausführungsumgebungen hielten Abhängigkeiten
reproduzierbar und trennten Configuration Management von Terraform-
Provisionierung.

Mir ist diese Trennung wichtig, weil Terraform-Pläne sonst schnell zu viel
Verantwortung bekommen. Ein Plan soll Infrastrukturänderungen sichtbar machen.
Ein Ansible-Lauf soll Konfigurationsänderungen sichtbar machen. Beides braucht
Reviews, aber nicht zwingend denselben Ablauf.

Die Pipeline-Struktur umfasste:

- Linting für YAML und Ansible Playbooks
- Syntax Check
- Inventory-Generierung aus Terraform Outputs oder Remote State
- Dry Run beziehungsweise Check Mode
- Approval für produktionsnahe Zielgruppen
- Ausführung gegen definierte Host-Gruppen
- Changelog oder Deployment-Notiz

## Azure DevOps Pipelines And Agent Pools

I ran Ansible through dedicated Azure DevOps pipelines on agent pools.
Containerized ephemeral execution environments kept dependencies reproducible
and separated configuration management from Terraform provisioning.

This separation matters because Terraform plans can otherwise take on too much
responsibility. A plan should make infrastructure changes visible. An Ansible
run should make configuration changes visible. Both need reviews, but not
necessarily the same workflow.

The pipeline structure included:

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
