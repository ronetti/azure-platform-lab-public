# Shared Services Stack

## Zweck

Dieser Root-Stack erstellt Log Analytics und die Resource-Group-Grenzen für
Key Vault und Storage. Key Vault und Storage Accounts selbst bleiben sichtbar
als nächste Implementierungsstufe gekennzeichnet.

## Konfiguration

- Quelle: `environments/<environment>/<environment>.yaml`
- Abschnitt: `shared_services`
- Abhängigkeiten: keine
- Outputs: `monitoring`, `key_vault`, `storage`

## Verwenden

```bash
./scripts/terraform-stack.sh validate shared-services nonproduction
./scripts/terraform-stack.sh init shared-services nonproduction
./scripts/terraform-stack.sh plan shared-services nonproduction
```

Pipeline-Consumer:

```yaml
terraform_root: terraform/stacks/shared-services
state_key: platform/shared-services/nonproduction.tfstate
```

Siehe [Terraform Pipeline Blueprint](../../../pipeline-blueprints/terraform/README.md).
