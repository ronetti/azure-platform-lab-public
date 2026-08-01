# Pipeline Blueprints

Dieses Verzeichnis enthält wiederverwendbare Pipeline-Vorlagen. Produkt-
Repositories halten ihre Pipeline dadurch klein: Sie pinnen eine Blueprint-
Version und liefern nur ihre eigenen Pfade, Environments, Service Connections
und State-Keys.

| Blueprint | Zweck | Verwendung |
| --- | --- | --- |
| [Terraform](terraform/README.md) | Check, Validate, Plan und freigegebener Apply | GitHub `workflow_call` |

Blueprint-Code enthält keine produktbezogenen Namen, Subscription-IDs,
Credentials oder Backend-Secrets.

Jedes konsumierende Produkt dokumentiert seine eigenen Werte und Abläufe in
einer README. Dafür liegt beim Terraform-Blueprint eine
[Produkt-README-Vorlage](terraform/product-readme-template.md).
