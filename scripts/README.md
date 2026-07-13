# Repository Scripts

## Terraform-Stack verwenden

`terraform-stack.sh` hält Backend-Pfad und State-Key an einer Stelle. Es
akzeptiert nur bekannte Root-Stacks und die beiden Subscription-Grenzen.

```bash
./scripts/terraform-stack.sh validate network nonproduction
./scripts/terraform-stack.sh init network nonproduction
./scripts/terraform-stack.sh plan network nonproduction
```

Vor `init` müssen die anonymisierten Werte in
`environments/<environment>/<environment>.azurerm.tfbackend.example` durch
reale Backend-Werte ersetzt oder in eine nicht eingecheckte Datei übernommen
werden. Das Script führt bewusst kein `apply` aus; Apply gehört in die
freigegebene Pipeline.
