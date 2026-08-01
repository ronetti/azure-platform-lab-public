# Terraform Pipeline Blueprint

## Zweck

[`terraform-blueprint.yml`](../../.github/workflows/terraform-blueprint.yml)
ist ein wiederverwendbarer GitHub-Actions-Workflow für Terraform-Produkte.
Produkt-Repositories behalten ihren Terraform-Code, ihre Konfiguration und
eine kleine aufrufende Workflow-Datei. Der Delivery-Ablauf bleibt zentral.

## Was ich damit zeige

Der Workflow ist ein ausführbarer Architektur- und Delivery-Entwurf, keine
Behauptung einer angeschlossenen Produktpipeline. Für Bewerbungen macht er
folgende Entscheidungen im Code sichtbar:

- Produktteams übergeben Parameter, kopieren aber keine zentrale Pipeline.
- Testing und Staging teilen die Nonproduction-Infrastruktur; Production
  bleibt eine eigene Sicherheits- und Fehlergrenze.
- Plan und Apply verwenden getrennte Identitäten und Verantwortungen.
- Production braucht neben einem erlaubten Branch eine menschliche Freigabe.
- Genau der geprüfte Plan wird angewendet; ein neuer Plan entsteht nicht
  unbemerkt während des Apply.
- Gleichzeitige Änderungen am selben State werden technisch verhindert.
- Dokumentation liegt direkt beim wiederverwendbaren Blueprint und beim
  konsumierenden Produkt.

```text
Produkt-Repository
  .github/workflows/terraform.yml
    -> gepinnte Blueprint-Version
    -> Produktparameter
       -> Check
       -> Validate
       -> Plan mit Plan-Identität
       -> geschützter Apply mit Apply-Identität
```

GitHub verlangt wiederverwendbare Workflows direkt unter
`.github/workflows/`. Dieses Verzeichnis enthält deshalb Dokumentation,
Consumer-Beispiel und Produkt-README-Vorlage; der ausführbare Blueprint liegt
am von GitHub vorgegebenen Ort.

## Voraussetzungen Im Produkt-Repository

Ein konsumierendes Produkt-Repository stellt bereit:

```text
.github/workflows/
  terraform.yml
assets/security_checks/
  checkov_exceptions.txt
  terrascan_exceptions.txt
  tflint_exceptions.txt
  tfsec_exceptions.txt
environments/
  nonproduction/
    nonproduction.azurerm.tfbackend
  production/
    production.azurerm.tfbackend
terraform/
  <produkt-root>/
README.md
```

Die Produkt-README beschreibt Zweck, Verantwortungsgrenze,
Environment-Zuordnung, Konfiguration, Workflow-Verwendung, Outputs,
Security-Ausnahmen und Betrieb. Dafür dient
[product-readme-template.md](product-readme-template.md).

## Verwenden

Der Produkt-Workflow pinnt ein bewusst freigegebenes Release-Tag oder einen
vollständigen Commit-SHA. `main` ist dafür keine stabile Referenz. Ein
vollständiger Commit-SHA bietet laut GitHub die stärkste Stabilitäts- und
Sicherheitsbindung; das Release-Tag bleibt die besser lesbare, explizit zu
aktualisierende Variante. Das vollständige Beispiel liegt in
[github-actions.example.yml](github-actions.example.yml). Das
[Release- und Tag-Prinzip](../../docs/change-governance.md)
definiert die Projektregeln.

```yaml
permissions:
  contents: read
  id-token: write

jobs:
  nonproduction:
    uses: ronetti/azure-platform-lab-public/.github/workflows/terraform-blueprint.yml@v1.0.0
    with:
      terraform_root: terraform/stacks/network
      environment: nonproduction
      backend_config: environments/nonproduction/nonproduction.azurerm.tfbackend
      state_key: products/example/network/nonproduction.tfstate
      plan_environment: platform-nonproduction-plan
      apply_environment: platform-nonproduction
      enable_plan: true
      enable_apply: true
```

## Inputs

| Input | Pflicht | Bedeutung |
| --- | --- | --- |
| `terraform_root` | ja | Terraform-Root relativ zum Produkt-Repository |
| `environment` | ja | Wert für `-var environment=...` |
| `backend_config` | ja | Backend-Basis relativ zum Produkt-Repository |
| `state_key` | ja | Eindeutiger State-Key für Produkt, Stack und Grenze |
| `plan_environment` | ja | GitHub Environment mit Plan-OIDC-Identität |
| `apply_environment` | ja | Geschütztes GitHub Environment mit Apply-Identität |
| `terraform_version` | nein | Gepinnte Terraform-Version |
| `tfvars` | nein | Optionale tfvars-Datei |
| `security_exceptions_path` | nein | Pfad zu den vier Ausnahmedateien |
| `enable_plan` | nein | Aktiviert Azure Login und Plan |
| `enable_apply` | nein | Aktiviert Apply; Standard ist `false` |
| `allowed_apply_ref` | nein | Erlaubter Apply-Ref; Standard ist `refs/heads/main` |
| `parallelism` | nein | Maximale Terraform-Parallelität |

## GitHub Environments und OIDC

Je Infrastrukturgrenze werden zwei GitHub Environments angelegt:

| Environment | Azure-Rechte | Protection |
| --- | --- | --- |
| `platform-<grenze>-plan` | Reader plus notwendiger State-Zugriff | keine manuelle Freigabe |
| `platform-<grenze>` | Apply-Rechte im eigenen Scope | Required Reviewers für Production |

Jedes Environment enthält nur diese nicht geheimen Variablen:

```text
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
```

Die zugehörige Entra-Anwendung besitzt eine Federated Identity Credential für
genau dieses Repository und GitHub Environment. Es werden keine Client-Secrets
gespeichert. Der aufrufende Workflow muss `id-token: write` und
`contents: read` erlauben.

Die Plan-Identität darf Azure-Ressourcen lesen und den State sperren, aber keine
Plattformressourcen ändern. Die Apply-Identität erhält nur Rechte innerhalb
ihrer eigenen Subscription- und State-Grenze.

## Nonproduction und Production

Der Consumer ruft den Blueprint zweimal auf:

1. `nonproduction` verwaltet gemeinsam genutzte Infrastruktur für Testing und
   Staging.
2. `production` startet erst nach erfolgreichem Nonproduction-Job und verwendet
   eigene GitHub Environments, OIDC-Identitäten, Subscription, Backend und
   State-Keys.

Testing und Staging bleiben getrennte Produkt- oder Workload-Stages, starten
aber keine parallelen Infrastruktur-Applies gegen denselben
Nonproduction-State.

## Ablauf und Guardrails

1. **Check:** Terraform-Format und Security-Ausnahmen.
2. **Validate:** `terraform init -backend=false` und `terraform validate`.
3. **Plan:** OIDC-Login über das Plan-Environment und gespeicherter Plan.
4. **Artifact:** Der Plan wird für einen Tag als Run-Artefakt gespeichert.
5. **Apply:** Nur bei Änderungen, aktiviertem Apply und erlaubtem Git-Ref.
6. **Approval:** Das Apply-Environment erzwingt seine Protection Rules.

Eine Concurrency-Gruppe pro Repository, Environment und State-Key verhindert
gleichzeitige Läufe gegen denselben Terraform-State.

Scanner-Ausnahmen brauchen Rule-ID, Begründung, Owner und Ablaufdatum. Dieser
öffentliche Blueprint validiert die Eingaben dafür, behauptet aber nicht, die
organisationsspezifischen Checkov-, TFLint-, Terrascan- oder tfsec-Installationen
auszuführen. Solche Scanner werden als eigener zentraler GitHub-Workflow vor
den Terraform-Aufrufen eingebunden.

## Für eine reale Übertragung nötig

- GitHub Actions erlaubt den Zugriff auf das Blueprint-Repository
- vollständige Commit-SHAs oder bewusst freigegebene Release-Tags; technische
  Unveränderlichkeit nur dann behaupten, wenn sie durch GitHub-Einstellungen
  tatsächlich erzwungen und geprüft ist
- vier GitHub Environments pro Produkt bei Nonproduction und Production
- OIDC Federation zwischen GitHub und Microsoft Entra ID
- getrennte Azure-Rollen für Plan und Apply
- vorbereitete Azure-Storage-Backends mit Entra-basierter Authentifizierung
- Required Reviewers und optional Branch Protection für Production

Diese externen Verbindungen sind im Portfolio-Repository bewusst nicht
eingerichtet. Namen und Werte im Consumer sind anonymisierte Platzhalter, an
denen sich das beabsichtigte Verhalten erkennen lässt.
