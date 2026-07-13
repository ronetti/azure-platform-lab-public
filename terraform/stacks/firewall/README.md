# Firewall Stack

## Zweck

Dieser Root-Stack modelliert Firewall-Platzierung und versionierte
Network-Rule-Collections. Er konsumiert nur veröffentlichte Network-Outputs;
die konkrete Azure-Firewall- oder NVA-Ressource ist noch nicht implementiert.

## Konfiguration

- Quelle: `environments/<environment>/<environment>.yaml`
- Abschnitt: `firewall`
- Abhängigkeit: `network`
- Outputs: `virtual_network_id`, `firewall_subnet_id`,
  `network_rule_collections`

## Verwenden

```bash
./scripts/terraform-stack.sh validate firewall nonproduction
./scripts/terraform-stack.sh init firewall nonproduction
./scripts/terraform-stack.sh plan firewall nonproduction
```

Pipeline-Consumer:

```yaml
terraform_root: terraform/stacks/firewall
state_key: platform/firewall/nonproduction.tfstate
```

Siehe [Terraform Pipeline Blueprint](../../../pipeline-blueprints/terraform/README.md).
