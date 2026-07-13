# Network Stack

## Zweck

Dieser Root-Stack erstellt die konkrete Netzwerkbasis: Resource Group, Virtual
Network und Subnets. Er ist die Quelle für Subnet-IDs, die nachgelagerte
Stacks ausschließlich über Remote State konsumieren.

## Konfiguration

- Quelle: `environments/<environment>/<environment>.yaml`
- Abschnitt: `network`
- Abhängigkeiten: keine
- Outputs: `resource_group_name`, `virtual_network_id`, `subnet_ids`

## Verwenden

```bash
./scripts/terraform-stack.sh validate network nonproduction
./scripts/terraform-stack.sh init network nonproduction
./scripts/terraform-stack.sh plan network nonproduction
```

Pipeline-Consumer:

```yaml
terraform_root: terraform/stacks/network
state_key: platform/network/nonproduction.tfstate
```

Siehe [Terraform Pipeline Blueprint](../../../pipeline-blueprints/terraform/README.md).
