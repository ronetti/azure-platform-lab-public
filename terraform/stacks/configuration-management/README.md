# Configuration Management Stack

## Zweck

Dieser Root-Stack übersetzt Compute-Outputs in ein stabiles
Ansible-Inventory. Terraform bleibt Quelle der Infrastruktur; Ansible
läuft in einer getrennten Pipeline mit eigenen Guardrails.

## Konfiguration

- Quelle: `environments/<environment>/<environment>.yaml`
- Abschnitt: `configuration_management`
- Abhängigkeit: `compute`
- Outputs: `ansible_inventory`, `pipeline_model`

## Verwenden

```bash
./scripts/terraform-stack.sh validate configuration-management nonproduction
./scripts/terraform-stack.sh init configuration-management nonproduction
./scripts/terraform-stack.sh plan configuration-management nonproduction
```

Pipeline-Consumer:

```yaml
terraform_root: terraform/stacks/configuration-management
state_key: platform/configuration-management/nonproduction.tfstate
```

Siehe [Terraform Pipeline Blueprint](../../../pipeline-blueprints/terraform/README.md).
