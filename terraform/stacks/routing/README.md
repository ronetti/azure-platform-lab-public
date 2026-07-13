# Routing Stack

## Zweck

Dieser Root-Stack modelliert Route Tables, Routen und Subnet-Zuordnungen. Er
zeigt den Deployment-Vertrag und löst Subnet-IDs aus dem Network-State auf;
reale Azure-Routing-Ressourcen sind noch nicht implementiert.

## Konfiguration

- Quelle: `environments/<environment>/<environment>.yaml`
- Abschnitt: `routing`
- Abhängigkeit: `network`
- Output: `route_tables`

## Verwenden

```bash
./scripts/terraform-stack.sh validate routing nonproduction
./scripts/terraform-stack.sh init routing nonproduction
./scripts/terraform-stack.sh plan routing nonproduction
```

Pipeline-Consumer:

```yaml
terraform_root: terraform/stacks/routing
state_key: platform/routing/nonproduction.tfstate
```

Siehe [Terraform Pipeline Blueprint](../../../pipeline-blueprints/terraform/README.md).
