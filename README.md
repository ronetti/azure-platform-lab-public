# Azure Platform Lab

**Annett Berlinger · Platform Engineering · DevOps · Azure Infrastructure**

Anonymisiertes Architektur- und Codebeispiel dafür, wie ich Azure-Plattformen
strukturiere: klare Verantwortungsgrenzen, datengetriebene Terraform-Stacks,
getrennte Subscriptions, Kubernetes-Guardrails und nachvollziehbarer Betrieb.

An anonymized architecture and code example showing how I structure Azure
platforms: clear ownership boundaries, configuration-driven Terraform stacks,
separate subscriptions, Kubernetes guardrails and operational readiness.

## In 60 Sekunden

```text
Nonproduction Subscription
  ├── Testing
  ├── Staging
  └── gemeinsam: State, Network, Edge, AKS, Registry, Key Vault, Monitoring

Production Subscription
  └── Production
      └── eigene States, Ressourcen, Identitäten, Secrets und Betriebsdaten
```

Testing und Staging teilen kostenintensive Ressourcen innerhalb von
Nonproduction. Production ist eine eigene Sicherheits-, Berechtigungs-,
Kosten- und Fehlergrenze und konsumiert keine Nonproduction-Runtime-Ressourcen.
Diese beiden Subscriptions bilden die aktuelle Workload-Grenze. Das
tenantweite [Landing-Zone-Denkmodell](docs/landing-zone-thinking.md) ordnet sie
darüber in Management Groups, Platform- und Application-Landing-Zone-
Verantwortungen ein, ohne diese Ebene als bereits implementiert auszugeben.

```text
Environment-Auswahl
  → environments/<environment>/<environment>.yaml
  → yamldecode + locals
  → Ressourcen oder Deployment-Intent
  → Outputs
  → Remote State für abhängige Root-Stacks
```

## Was Das Zeigt

- **Kostenbewusstsein:** Testing und Staging teilen eine kleine
  Nonproduction-Grundlast; Production bleibt verfügbarkeitsorientiert.
- **Security by design:** getrennte Subscriptions, State-Accounts, Netzwerke,
  Identitäten, Secrets, Cluster und Monitoring-Ziele.
- **Klare Ownership:** NetOps-, SysOps- und Kubernetes-Verantwortungen besitzen
  eigene Root-Stacks und stabile Übergabepunkte.
- **Daten statt Copy-Paste:** Environment-YAML, Maps und Locals steuern
  routinemäßige Änderungen.
- **Wiederverwendbare Delivery:** Produkt-Repositories konsumieren ein
  versionsgepinntes Terraform-Pipeline-Blueprint mit eigenen Parametern.
- **Betriebsfähigkeit:** Guardrails, Reviews, Diagnostics, Availability
  Engineering, Backup-/Restore- und Configuration-Management-Patterns.

Das Repository ist dabei ein ausführbarer Denkansatz für Bewerbungen. Es soll
nicht behaupten, eine reale Organisation, Subscription-Landschaft oder
Deployment-Strecke vollständig abzubilden. Sichtbar werden sollen die Fragen,
die ich vor einer Umsetzung kläre, die Grenzen, die ich bewusst ziehe, und die
Struktur, mit der andere Menschen meine Entscheidungen schnell prüfen und
weiterführen können.

## Methode Und Gezielte Wirkung

| Schwerpunkt | Allgemeine Methode | Gezielte Wirkung |
| --- | --- | --- |
| Skalierbare Plattformstruktur | Wiederverwendbare Terraform- und Kubernetes-Blueprints verbinden generische Logik mit konfigurationsgetriebenen Workload-Parametern. | Weitere Workload-Instanzen lassen sich über geprüfte Datenänderungen einordnen, während Sicherheits-, Verantwortungs- und Betriebsgrenzen konsistent bleiben. |
| Nachvollziehbare Delivery | Versionierte YAML-Konfiguration, Pipeline-Gates, Outputs und stabile Übergabepunkte verbinden NetOps, SysOps und Platform Engineering. | Manuelle Portalabhängigkeit und personengebundenes Wissen werden gezielt reduziert; Änderungen werden wiederholbar, reviewbar und nachvollziehbar. |

Die beschriebene Wirkung ist das Ziel des Architekturansatzes und keine
veröffentlichte Kennzahl aus einer konkreten Organisation oder
Kundenumgebung.

## Architektur

```text
network ───────────────→ routing
   │                    → firewall
   │                    → application-gateway
   │                    → compute
   │                    → aks
   │
shared-services ───────→ compute
   │                    → aks
   │
compute ───────────────→ configuration-management
```

Dieses kompakte Portfolio-Repository führt die fachlich getrennten
Repositories an einem Ort zusammen. Im realen Repository-Modell besitzt jeder
Bereich wie Network, Firewall, Application Gateway oder Compute seine eigene
Multi-Environment-YAML, Backend-/State-Grenze, Pipeline, Security-Assets und
README. Die Single Source of Truth liegt damit je Verantwortungsbereich im
zuständigen Repository.

Für die lesbare Lab-Darstellung sind diese Verträge je Subscription-Grenze
konsolidiert:

```text
environments/
  nonproduction/
    nonproduction.yaml
    nonproduction.azurerm.tfbackend.example
  production/
    production.yaml
    production.azurerm.tfbackend.example
```

Jeder Ordner unter `terraform/stacks/` repräsentiert eines dieser eigenständigen
Fach-Repositories und behält einen eigenen State-Key. Im Lab liest er nur
seinen Abschnitt aus dem konsolidierten Environment-Vertrag. Upstream-Stacks
veröffentlichen Outputs; abhängige Stacks konsumieren ausschließlich diese
Verträge über `terraform_remote_state`.

Das zugrundeliegende Multi-Team-Modell betreibt den Terraform-State zentral je
Subscription- und Environment-Grenze in Azure Storage. Jedes Team oder Produkt
besitzt einen eigenen Container mit Entra-RBAC auf Container-Scope; jedes
Fach-Repository verwendet darin einen eindeutigen State-Key. So bleibt der
Backend-Service zentral betreibbar, ohne anderen Teams Zugriff auf fremde
States zu geben. Production und Nonproduction teilen keinen State-Storage.

## Umsetzungsstand

| Bereich | Im Repository implementiert | Bewusst als Ziel/Intent modelliert |
| --- | --- | --- |
| Network | unabhängig geschriebener Demo-Baustein und Root-Stack | produktiver Modul- und Repository-Code |
| Shared Services | Log Analytics; Key Vault/Storage als Resource-Group-Rahmen | produktionsreife Service-Ausprägung |
| Routing, Firewall, App Gateway | YAML-Verträge, Remote State, Outputs | reale Ressourcenimplementierung |
| Compute | VM-Vertrag und Ansible-Übergabe | vollständiger VM-Lifecycle |
| AKS | Environment-, Security-, Node-Pool- und Kosten-Intent | Cluster-Provisionierung |
| Kubernetes | Blueprints, Testing/Staging/Production-Overlays, Guardrails | Rollout-Controller für Blue-Green |
| Landing Zone Governance | begründeter Denkweg, ALZ-Core-Vertrag und stufenweise Verifikation | Management Groups, Policy-Lifecycle, Platform-Subscriptions und Subscription Vending |
| CI | Terraform-, YAML-, Schema-, Isolation- und Security-Ausnahmevertrag | reale Deployment- und Scanner-Pipelines |
| Pipeline Blueprint | GitHub Actions Check, Validate, Plan-Artefakt und geschützter Apply | reale Entra-OIDC-Federation und Environment-Approvals |

Die Trennung ist absichtlich sichtbar: Das Repository behauptet nicht,
modellierte Schnittstellen seien bereits produktiv provisioniert.

## Kubernetes

```text
kubernetes/
  blueprint-templates/
    platform-baseline/
    web-workload/
  environments/
    nonproduction/
      testing/
      staging/
    production/
```

Die Blueprints liefern unter anderem:

- Pod Security Standard `restricted`
- Default-Deny-NetworkPolicies mit expliziten Freigaben
- ResourceQuota und LimitRange
- Non-Root-Container und deaktivierte Service-Account-Tokens
- Probes, HPA, PDB und Topology Spread

Nonproduction rendert Testing und Staging gemeinsam. Production rendert nur
Production-Ressourcen und wird in CI auf Cross-Environment-Verweise geprüft.
Der sichtbare Request-Pfad führt über Application Gateway/WAF zum internen
AKS-Ingress und anschließend zum Workload-Service.

## Verantwortungen

| Verantwortung | Beispiele im Lab |
| --- | --- |
| NetOps | Network, Routing, Firewall, Application Gateway/WAF, DNS |
| SysOps | Compute, Monitoring, Backup/Restore, Configuration Management |
| Platform/Kubernetes | AKS-Intent, Blueprints, Guardrails, Workload-Overlays |
| Governance | Remote State, Reviews, Approvals, CI und Changelog |

## Einstiegspunkte

| Thema | Dokument |
| --- | --- |
| Praxiserfahrung und technische Denkweise | [Platform Engineering Experience](docs/platform-engineering-experience.md) |
| Anonymisierte Fallstudie mit überprüfbaren Ergebnissen | [Platform Case Study](docs/anonymized-platform-case-study.md) |
| Landing-Zone-Denkweg, Management Groups und Subscription Vending | [Landing Zone Thinking](docs/landing-zone-thinking.md) |
| Kleinster verantwortbarer Tenant-Governance-Slice | [ALZ Core Contract](docs/alz-core-contract.md) |
| Gesamtarchitektur und Datenfluss | [Architecture](docs/architecture.md) |
| Nonproduction/Production-Modell | [Environments](environments/README.md) |
| Terraform-Root-Stacks | [Terraform Stacks](terraform/stacks/README.md) |
| Wiederverwendbare Terraform-Pipeline | [Pipeline Blueprint](pipeline-blueprints/terraform/README.md) |
| Kubernetes und Blueprints | [Kubernetes](kubernetes/README.md) |
| Security und Subscription-Trennung | [Security](docs/security-considerations.md) |
| Guardrails und Pipeline-Gates | [Guardrails](docs/guardrails.md) |
| Availability Engineering | [Availability](docs/availability-engineering.md) |
| Betrieb und Verifikation | [Runbook](docs/runbook.md) |
| Kostenentscheidungen | [Cost Notes](docs/cost-notes.md) |
| Ansible-Übergabe | [Configuration Management](docs/ansible-configuration-management.md) |

## Repository

```text
environments/       verständliches Betriebsmodell
assets/              zentrale, begründete Security-Check-Ausnahmen
scripts/             sichere, einfache Stack-Befehle
pipeline-blueprints/ wiederverwendbare Produkt-Pipelines
terraform/modules/  unabhängig geschriebene Demo-Bausteine
terraform/stacks/   Root-Stacks und Remote-State-Verträge
kubernetes/         Blueprints und Environment-Overlays
docs/               Architektur- und Betriebsmuster
```

## Validierung

```bash
terraform -chdir=terraform fmt -check -recursive
yamllint environments kubernetes terraform/stacks .github

for environment in nonproduction production; do
  kubectl kustomize "kubernetes/environments/${environment}" \
    > "/tmp/${environment}.yaml"
  kubeconform -summary -strict "/tmp/${environment}.yaml"
done
```

Die GitHub-Action prüft zusätzlich, dass Production keinen Nonproduction-State
und keine Testing-/Staging-Kubernetes-Ressourcen konsumiert. Security-Ausnahmen
liegen toolbezogen unter `assets/security_checks`; eine lokale Pipeline-Action
validiert Begründung, Owner und Ablaufdatum.

## Rahmen

Dieses Repository ist ein persönliches, anonymisiertes Portfolio-Beispiel. Es
enthält keine Kundennamen, produktiven IDs, Secrets oder vertraulichen
Architekturwerte und ist keine vollständig angeschlossene Enterprise Landing
Zone. Ausführbare Beispiele zeigen die beabsichtigten Verträge; externe
Identitäten, Approvals und Azure-Ressourcen bleiben bewusst unkonfiguriert.

This is a personal, anonymized portfolio example. It contains no customer
names, production identifiers, secrets or confidential architecture values
and is not a complete enterprise landing zone.

Copyright (c) 2026 Annett Berlinger. All rights reserved. See
[LICENSE](LICENSE).
