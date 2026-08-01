# Compute Stack

## Zweck

Dieser Root-Stack modelliert VM-Namen, Größen, Images, private IPs und
Subnet-Zuordnungen. Er stellt die VM-Daten für das Configuration
Management bereit; der vollständige VM-Lifecycle ist noch nicht implementiert.

## Konfiguration

- Quelle: `environments/<environment>/<environment>.yaml`
- Abschnitt: `compute`
- Abhängigkeiten: `network`, `shared-services`
- Outputs: `virtual_machines`, `monitoring_workspace_id`

## Verwenden

```bash
./scripts/terraform-stack.sh validate compute nonproduction
./scripts/terraform-stack.sh init compute nonproduction
./scripts/terraform-stack.sh plan compute nonproduction
```

Pipeline-Consumer:

```yaml
terraform_root: terraform/stacks/compute
state_key: platform/compute/nonproduction.tfstate
```

Siehe [Terraform Pipeline Blueprint](../../../pipeline-blueprints/terraform/README.md).
