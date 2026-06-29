# Terraform Stacks

## Deutsch

Jeder Ordner in diesem Verzeichnis ist so modelliert, als wäre er ein eigenes
Root-Repository. In einer echten Plattform könnten diese Stacks in getrennten
Git-Repositories mit eigenen Pipelines, Approvals und State-Dateien liegen.

Das Muster zeigt bewusst, wie Plattformteile ineinandergreifen, ohne eng
gekoppelt zu sein: Upstream-Stacks veröffentlichen Outputs, Downstream-Stacks
konsumieren diese Outputs über `terraform_remote_state`.

## Muster

```text
stack/
  backend/
    testing.azurerm.tfbackend.example
  config/
    testing.yaml
  versions.tf
  variables.tf
  main.tf
  outputs.tf
  remote-state.tf
```

## Übergabepunkte

- Upstream-Stacks veröffentlichen stabile Outputs.
- Downstream-Stacks konsumieren diese Outputs mit `terraform_remote_state`.
- Umgebungsspezifische Konfiguration liegt in YAML.
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

Each directory in this folder is modeled as if it were a separate root
repository. In a real platform these stacks could live in different Git
repositories and have independent pipelines, approvals and state files.

The pattern intentionally shows how platform parts integrate without becoming
tightly coupled: upstream stacks publish outputs, downstream stacks consume
those outputs through `terraform_remote_state`.

## Handover Points

- Upstream stacks expose stable outputs.
- Downstream stacks consume those outputs with `terraform_remote_state`.
- Environment-specific configuration lives in YAML.
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
