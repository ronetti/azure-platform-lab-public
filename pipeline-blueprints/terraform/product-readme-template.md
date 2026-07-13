# <Produktname>

## Zweck

Kurze Beschreibung des Produkts, seiner Nutzer und der bereitgestellten
Azure-Ressourcen.

## Verantwortungsgrenze

- Dieses Repository verwaltet: `<Ressourcen und Konfiguration>`
- Nicht Bestandteil: `<bewusst ausgeschlossene Bereiche>`
- Technische Verantwortung: `<Team>`
- Fachliche Verantwortung: `<Team oder Rolle>`

## Environments

| Stage | Infrastrukturgrenze | Subscription | Verwendung |
| --- | --- | --- | --- |
| Testing | Nonproduction | `<nonproduction>` | frühe Produktvalidierung |
| Staging | Nonproduction | `<nonproduction>` | produktionsnahe Abnahme |
| Production | Production | `<production>` | produktiver Betrieb |

Testing und Staging dürfen kostenintensive Nonproduction-Ressourcen gemeinsam
nutzen. Production verwendet keine Nonproduction-Ressourcen, Identitäten,
Backends oder State-Dateien.

## Verzeichnisstruktur

```text
.github/workflows/       dünner Consumer des Pipeline-Blueprints
assets/security_checks/ begründete Scanner-Ausnahmen
environments/           Nonproduction-/Production-Konfiguration
terraform/              Terraform-Root oder Root-Stacks
```

## Konfiguration

Beschreibe fachliche Eingaben und die zentrale Konfigurationsdatei. Werte
werden nur an einer Stelle gepflegt; abgeleitete Kopien gehören nicht in das
Repository.

## Workflow verwenden

`.github/workflows/terraform.yml` bindet eine feste Blueprint-Version ein:

```yaml
permissions:
  contents: read
  id-token: write

jobs:
  nonproduction:
    uses: ronetti/azure-platform-lab-public/.github/workflows/terraform-blueprint.yml@v1.0.0
    with:
      terraform_root: terraform/<produkt-root>
      environment: nonproduction
      backend_config: environments/nonproduction/nonproduction.azurerm.tfbackend
      state_key: <produkt>/<stack>/nonproduction.tfstate
      plan_environment: <produkt>-nonproduction-plan
      apply_environment: <produkt>-nonproduction
      enable_plan: ${{ github.event_name != 'pull_request' }}
      enable_apply: ${{ github.event_name != 'pull_request' }}

  production:
    needs: nonproduction
    uses: ronetti/azure-platform-lab-public/.github/workflows/terraform-blueprint.yml@v1.0.0
    with:
      terraform_root: terraform/<produkt-root>
      environment: production
      backend_config: environments/production/production.azurerm.tfbackend
      state_key: <produkt>/<stack>/production.tfstate
      plan_environment: <produkt>-production-plan
      apply_environment: <produkt>-production
      enable_plan: ${{ github.event_name != 'pull_request' }}
      enable_apply: ${{ github.event_name != 'pull_request' }}
```

Workflow-Logik wird nicht in das Produkt kopiert. Ein Blueprint-Upgrade erfolgt
durch einen Pull Request, der ausschließlich Tag oder Commit-SHA ändert.

## GitHub Environments

Dokumentiere die vier Environments:

- `<produkt>-nonproduction-plan`
- `<produkt>-nonproduction`
- `<produkt>-production-plan`
- `<produkt>-production`

Jedes enthält `AZURE_CLIENT_ID`, `AZURE_TENANT_ID` und
`AZURE_SUBSCRIPTION_ID`. Production Apply besitzt Required Reviewers und eine
eigene OIDC-Identität für die Production-Subscription.

## Lokal prüfen

```bash
terraform -chdir=terraform/<produkt-root> fmt -check
terraform -chdir=terraform/<produkt-root> init -backend=false
terraform -chdir=terraform/<produkt-root> validate
```

## Security

- Änderungen erfolgen über Pull Request und Review.
- Azure-Anmeldung verwendet OIDC statt langlebiger Client-Secrets.
- Production Apply verwendet ein geschütztes GitHub Environment.
- Plan- und Apply-Identitäten folgen Least Privilege.
- Ausnahmen unter `assets/security_checks` enthalten Regel-ID, Begründung,
  Owner und Ablaufdatum.

## Outputs und Abhängigkeiten

Dokumentiere konsumierbare Outputs, Remote-State-Abhängigkeiten und die
erforderliche Deployment-Reihenfolge.

## Betrieb

Beschreibe Monitoring, Alarmierung, Rollback, Wiederanlauf und die zuständige
Betriebsrolle.
