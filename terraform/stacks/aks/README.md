# AKS Stack

## Zweck

Dieser Root-Stack modelliert Cluster, Netzwerk, Identität, Security,
Ingress, Node Pools, Kosten und Betriebsparameter. Er löst Subnet und
Monitoring-Workspace aus Remote State auf; ein AKS-Cluster wird noch nicht
provisioniert.

## Konfiguration

- Quelle: `environments/<environment>/<environment>.yaml`
- Abschnitte: `aks`, `used_for`, `costs`
- Abhängigkeiten: `network`, `shared-services`
- Outputs: `cluster`, `cost`, `used_for`, `governance`

## Verwenden

```bash
./scripts/terraform-stack.sh validate aks nonproduction
./scripts/terraform-stack.sh init aks nonproduction
./scripts/terraform-stack.sh plan aks nonproduction
```

Pipeline-Consumer:

```yaml
terraform_root: terraform/stacks/aks
state_key: platform/aks/nonproduction.tfstate
```

Siehe [Terraform Pipeline Blueprint](../../../pipeline-blueprints/terraform/README.md).
