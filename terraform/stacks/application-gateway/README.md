# Application Gateway Stack

## Zweck

Dieser Root-Stack modelliert Application Gateway/WAF, Listener, Backends,
Probes und den internen AKS-Ingress als Ziel. Er löst das Ingress-Subnetz aus
dem Network-State auf; die Azure-Ressourcen sind noch nicht implementiert.

## Konfiguration

- Quelle: `environments/<environment>/<environment>.yaml`
- Abschnitt: `application_gateway`
- Abhängigkeit: `network`
- Output: `application_gateway`

## Verwenden

```bash
./scripts/terraform-stack.sh validate application-gateway nonproduction
./scripts/terraform-stack.sh init application-gateway nonproduction
./scripts/terraform-stack.sh plan application-gateway nonproduction
```

Pipeline-Consumer:

```yaml
terraform_root: terraform/stacks/application-gateway
state_key: platform/application-gateway/nonproduction.tfstate
```

Siehe [Terraform Pipeline Blueprint](../../../pipeline-blueprints/terraform/README.md).
