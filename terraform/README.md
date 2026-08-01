# Terraform

## Deutsch

Diese Terraform-Struktur zeigt zwei Ebenen einer Azure-Plattform:

- `modules/` enthält kleine, unabhängig geschriebene Demo-Bausteine für das
  Portfolio. Sie sind kein Abdruck privater oder beruflicher Modul-Repositories.
- `stacks/` repräsentiert getrennte Fach- und Root-Repositories mit eigenem
  State.

Im zugrundeliegenden Betriebsmodell besitzt jeder Bereich wie Network,
Firewall, Application Gateway oder Compute ein eigenes Repository. Jedes ist
über eigene Environment-YAMLs multi-environment-fähig und enthält die
zugehörige Backend-/State-Konfiguration, Pipeline, Security-Assets und README.
Die Single Source of Truth liegt pro Verantwortungsbereich im jeweiligen
Repository.

Es gibt bewusst keinen zusätzlichen monolithischen Terraform-Root. Jeder
ausführbare Einstieg liegt unter `stacks/<stack>`; damit bleiben State,
Ownership und Deployment-Reihenfolge eindeutig.

Damit ist das Lab näher an einer Enterprise-Plattform modelliert: Netzwerk,
Shared Services, Firewall, Compute, AKS und Application Gateway können getrennt
geplant und deployed werden. Die Stacks greifen über `terraform_remote_state`
ineinander, nicht über direkte lokale Modulreferenzen.

Damit das öffentliche Lab kompakt lesbar bleibt, sind die fachlichen
Environment-Strukturen hier in genau einer YAML-Datei je Subscription-Grenze
unter `environments/` zusammengeführt. Typische Änderungen wie neue Subnetze,
Firewall-Regeln, VMs, Listener, Backends oder Node Pools ändern den passenden
Abschnitt dieser Datei, nicht Terraform-Code oder Stack-Kopien.

Provider-Lockfiles gehören zu ausführbaren Root-Stacks und werden dort
versioniert, sobald ein Stack externe Provider verwendet. So verwenden lokale
Prüfung und CI dieselbe Provider-Auswahl.

## English

This Terraform structure shows two layers of an Azure platform:

- `modules/` contains small, independently written portfolio demonstration
  modules. They are not copies of private or professional module repositories.
- `stacks/` represents separate domain and root repositories with their own
  state.

In the underlying operating model, each domain such as network, firewall,
Application Gateway or compute owns a repository with multi-environment YAML,
backend and state configuration, pipeline, security assets and README. Each
repository is the single source of truth for its responsibility boundary.

There is intentionally no additional monolithic Terraform root. Every
executable entry point lives below `stacks/<stack>`, keeping state, ownership
and deployment order unambiguous.

This makes the lab closer to an enterprise platform setup: network, shared
services, firewall, compute, AKS and Application Gateway can be planned and
deployed separately. Stacks integrate through `terraform_remote_state`, not by
direct local module references.

To keep the public lab compact, its domain configuration is consolidated into one
YAML file per subscription boundary below `environments/`. Common changes
update the appropriate section there rather than Terraform code or stack
copies.

Provider lock files belong to deployable root stacks and are committed where a
stack uses external providers. This keeps local validation and CI on the same
provider selection.

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

Vom Repository-Root aus:

```bash
./scripts/terraform-stack.sh init network nonproduction
./scripts/terraform-stack.sh plan network nonproduction
```

Das Script validiert Stack und Environment und leitet den State-Key
deterministisch als `platform/<stack>/<environment>.tfstate` ab.

```bash
./scripts/terraform-stack.sh validate compute nonproduction
```
