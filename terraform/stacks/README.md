# Terraform Stacks

## Deutsch

Jeder Ordner in diesem Verzeichnis repräsentiert ein eigenständiges Fach- und
Root-Repository. Im zugrundeliegenden Modell besitzen Network, Firewall,
Application Gateway, Compute und weitere Bereiche jeweils eigene
Multi-Environment-YAMLs, Pipelines, Approvals, Security-Assets, READMEs und
State-Dateien.

Das Muster zeigt bewusst, wie Plattformteile ineinandergreifen, ohne eng
gekoppelt zu sein: Upstream-Stacks veröffentlichen Outputs, Downstream-Stacks
konsumieren diese Outputs über `terraform_remote_state`.

## Muster

Das öffentliche Lab konsolidiert die Environment-Verträge, um die
Repository-Beziehungen ohne wiederholte Beispieldateien lesbar zu zeigen:

```text
environments/
  nonproduction/
    nonproduction.yaml
    nonproduction.azurerm.tfbackend.example
  production/
    production.yaml
    production.azurerm.tfbackend.example

terraform/stacks/<stack>/
  versions.tf
  variables.tf
  main.tf
  outputs.tf
  remote-state.tf  # nur wenn der Stack Upstream-Outputs konsumiert
```

## Übergabepunkte

- Upstream-Stacks veröffentlichen stabile Outputs.
- Downstream-Stacks konsumieren diese Outputs mit `terraform_remote_state`.
- Im Lab lesen alle Stacks ihren Abschnitt aus der konsolidierten YAML ihrer
  Subscription-Grenze. Im getrennten Modell besitzt jedes Fach-Repository den
  entsprechenden eigenen Environment-Vertrag.
- Nonproduction und Production verwenden getrennte State-Resource-Groups,
  Storage Accounts, State-Schlüssel und Pipeline-Berechtigungen.
- `-var environment=...` wählt genau eine zentrale Konfiguration. `main.tf`
  lädt daraus nur den eigenen Abschnitt.
- Die Backend-Basis ist je Subscription einmal definiert. Der Stackname wird
  durch `scripts/terraform-stack.sh` als eindeutiger State-Key abgeleitet.
- Routinemäßige Plattformdaten sollen ohne Terraform-Codeänderung ergänzt
  werden können.
- `configuration-management` nutzt Compute-Outputs als Inventory-Quelle für
  getrennte Ansible-Pipelines.

## Deployment-Reihenfolge

```text
1. network
2. shared-services
3. routing
4. firewall
5. application-gateway
6. compute
7. configuration-management
8. aks
```

Die genaue Reihenfolge kann variieren, sobald Abhängigkeiten erfüllt sind.
`routing`, `firewall` und `application-gateway` hängen von `network` ab,
`compute` und `aks` hängen von `network` und `shared-services` ab.
`configuration-management` nutzt `compute`-Outputs als Inventory-Quelle
für Ansible-Pipelines.

## English

Each directory in this folder represents a separate domain and root repository.
In the underlying model, network, firewall, Application Gateway, compute and
other domains each own multi-environment YAML, pipelines, approvals, security
assets, READMEs and state files.

The pattern intentionally shows how platform parts integrate without becoming
tightly coupled: upstream stacks publish outputs, downstream stacks consume
those outputs through `terraform_remote_state`.

## Handover Points

- Upstream stacks expose stable outputs.
- Downstream stacks consume those outputs with `terraform_remote_state`.
- In the lab, every stack reads its section from the consolidated YAML for its
  subscription boundary. In the separated model, each domain repository owns
  the corresponding environment contract.
- Nonproduction and production use separate state resource groups, storage
  accounts, state keys and pipeline permissions.
- `-var environment=...` selects one central configuration. `main.tf` reads
  only its own section.
- The backend base is defined once per subscription. The stack name is passed
  by `scripts/terraform-stack.sh` as the unique state key.
- Adding routine platform data should not require Terraform code changes.
- `configuration-management` consumes compute outputs as the inventory source
  for separate Ansible pipelines.

## Deployment Order

```text
1. network
2. shared-services
3. routing
4. firewall
5. application-gateway
6. compute
7. configuration-management
8. aks
```

The exact order can vary once dependencies are satisfied. `routing`,
`firewall` and `application-gateway` depend on `network`, while `compute` and
`aks` depend on both `network` and `shared-services`.
`configuration-management` consumes `compute` outputs as an inventory source
for Ansible pipelines.
