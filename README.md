# Azure Platform Engineering Portfolio

[![Validate](https://github.com/ronetti/azure-platform-lab-public/actions/workflows/validate.yml/badge.svg)](https://github.com/ronetti/azure-platform-lab-public/actions/workflows/validate.yml)

**Annett Berlinger · Senior Azure Platform Engineer · Terraform · Secure Delivery · Platform Operations**

Ich baue Azure-Plattformen so, dass Teams Änderungen nicht nur deployen,
sondern später auch verstehen, prüfen und im Fehlerfall wiederherstellen
können.

## Schneller Einstieg

| Signal | Was sichtbar ist |
| --- | --- |
| Azure Platform Engineering | Terraform-Root-Stacks, Environment-Verträge, Remote-State-Übergaben und Landing-Zone-Denkmodell |
| Secure Delivery | GitHub-Actions-Validierung, gepinnte Actions, Security-Ausnahmen mit Owner und Ablaufdatum |
| Kubernetes / AKS | Kustomize-Blueprints, Nonproduction-/Production-Overlays, Pod Security, NetworkPolicies, Quotas, HPA und PDB |
| GitOps / Flux | Reconciliation-Pattern zwischen freigegebenem Git-Zustand und laufendem Cluster |
| Betriebsmodell | Monitoring, Runbooks, Restore-Automatisierung, RCA-Denken und klare Rückwege |
| AI-assisted Governance | AI als zusätzliche Review-Schicht für Risiken, Konsistenz und wiederkehrende Plattformregeln |
| AI Workload Platform | Modellierter AKS/GPU-Intent und Inference-Blueprint als nächster Plattformausbau |

Die beste kurze Prüfung beginnt hier:

- [Platform Engineering Experience](docs/platform-engineering-experience.md)
- [Architecture](docs/architecture.md)
- [Kubernetes Platform Pattern](docs/kubernetes-platform-pattern.md)
- [AI-assisted Platform Governance](docs/ai-assisted-platform-governance.md)
- [AI Workload Platform Pattern](docs/ai-workload-platform-pattern.md)

## English Snapshot

This repository is an anonymized Azure Platform Engineering portfolio. It
shows how I structure platform work across Terraform root stacks, environment
contracts, remote-state handovers, Kubernetes blueprints, GitOps reasoning,
security guardrails, monitoring, runbooks and AI-assisted governance.

It is not presented as a fully provisioned enterprise landing zone. The
repository deliberately separates implemented code, modeled contracts, target
architecture and later integration steps.

Dieses anonymisierte Portfolio ist keine isolierte Übungsumgebung. Es
übersetzt reale Azure-Plattformarbeit in eine prüfbare Arbeitsprobe:
Terraform-Stacks, Environment-Verträge, Netzwerk- und Security-Grenzen,
Application Gateway/WAF, Firewall-Integration, Delivery-Pipelines,
Configuration Management, Monitoring, Backup/Restore und Runbook-Denken.

Im Mittelpunkt stehen begründete Architekturentscheidungen, klare Ownership
und ein Plattformweg, den Teams gemeinsam prüfen und weiterentwickeln können.
Der Umsetzungsstand trennt transparent zwischen ausführbarem Code,
modellierten Verträgen, Zielbild und noch notwendiger realer Integration.
Ich zeige hier bewusst, wie ich denke und strukturiere: nicht nur einzelne
Ressourcen, sondern Zusammenhänge, Abhängigkeiten, Risiken, Betrieb und
Rückwege. Genau diese Gesamtsicht ist meine Stärke.

## Mein Plattformansatz In 60 Sekunden

- **Ich denke Infrastruktur als Betriebsmodell:** Governance, Netzwerk,
  Security, Delivery, Configuration Management, Monitoring und Recovery müssen
  über klare Schnittstellen zusammenpassen.
- **Teams brauchen Freiheit innerhalb klarer Grenzen:** Fachbereiche besitzen
  eigene Root-Stacks und States; gemeinsame Verträge schützen Ownership,
  Security und die Single Source of Truth.
- **Changes müssen prüfbar bleiben:** Environment-Daten, Terraform-Pläne,
  Pipeline-Blueprints und Approvals machen Infrastrukturveränderungen
  nachvollziehbar, bevor sie im Betrieb ankommen.
- **Betrieb beginnt nicht nach dem Deployment:** Observability, Backup,
  Restore, Fehlergrenzen und Runbooks gehören für mich zum Plattformvertrag.
- **Automatisierung reduziert Fehlerquellen:** Was zuverlässig als Code,
  Pipeline oder Runbook beschrieben werden kann, sollte nicht dauerhaft von
  manueller Erinnerung abhängen.
- **AI unterstützt Governance, ersetzt sie aber nicht:** AI-assisted Reviews
  können Risiken früher sichtbar machen; Verantwortung, Approval-Grenzen und
  Production-Validierung bleiben menschlich und nachvollziehbar.

## Berufliche Umsetzung Hinter Der Arbeitsprobe

Die gezeigten Prinzipien sind nicht nur theoretisch. Mit Azure arbeite ich seit
2018 in unterschiedlichen beruflichen Zusammenhängen; in meiner jüngeren
Plattformarbeit habe ich unter anderem Azure-Infrastruktur mit Terraform und
getrennten Environment-Verträgen, Azure DevOps Pipelines und Agent Pools sowie
modulares Ansible-Konfigurationsmanagement umgesetzt.
Containerisierte, ephemere Ansible-Ausführungsumgebungen, Terraform Outputs
beziehungsweise Remote State als Inventory-Quelle sowie Linting, Syntax Check,
Check Mode, Reviews und Approvals gehörten dabei zum Delivery-Modell.

Bei der Recovery einer mehrstufigen stateful Solution orchestrierte ich nicht
nur einzelne VM-Restores, sondern den gemeinsamen technischen
Wiederherstellungsstand der gesamten Solution. VM-spezifische Restore- oder
Rebuild-Pfade, Pre-/Post-Checks, Stop-Kriterien, Logging und kontrollierte
Terraform-Re-Adoption verbanden Recovery und Infrastructure as Code zu einem
nachvollziehbaren Betriebsablauf.

Nicht freigegebener Originalcode wird hier nicht veröffentlicht. Dieses
Repository formuliert die dahinterliegenden Architektur-, Übergabe- und
Betriebsprinzipien unabhängig und anonymisiert neu. Die genaue Abgrenzung zeigen
[Plattform-Erfahrung](docs/platform-engineering-experience.md),
[Ansible Configuration Management](docs/ansible-configuration-management.md)
und [Restore-Automatisierung](docs/restore-automation-pattern.md).

### Workload- Und Environment-Grenze

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

- **Platform Engineering mit Delivery-Fokus:** Infrastruktur wird nicht nur
  provisioniert. Entscheidend ist, ob ein Team die Änderung später prüfen,
  betreiben und im Fehlerfall verstehen kann.
- **Kostenbewusstsein:** Testing und Staging teilen eine kleine
  Nonproduction-Grundlast; Production bleibt verfügbarkeitsorientiert.
- **Security by design:** getrennte Subscriptions, State-Accounts, Netzwerke,
  Identitäten, Secrets, Cluster und Monitoring-Ziele.
- **Klare Ownership:** NetOps-, SysOps- und Kubernetes-Verantwortungen besitzen
  eigene Root-Stacks und stabile Übergabepunkte.
- **Daten statt Copy-Paste:** Environment-YAML, Maps und Locals steuern
  routinemäßige Änderungen.
- **Wiederverwendbare Delivery:** Das Terraform-Pipeline-Blueprint ist für die
  versionsgepinnte Nutzung durch Produkt-Repositories mit eigenen Parametern
  ausgelegt.
- **Betriebsdenken:** Guardrails, Reviews, Diagnostics, Availability
  Engineering sowie Backup-/Restore- und Configuration-Management-Patterns.
- **Technische Urteilskraft mit KI-Unterstützung:** KI kann Analyse und
  Umsetzung beschleunigen. Die Verantwortung bleibt bei der Frage: Was ist
  richtig, was ist riskant, was ist nur plausibel formuliert und was wurde
  wirklich geprüft?
- **AI-assisted Platform Governance:** Ein AI Agent kann Terraform,
  Kubernetes, YAML, Pipelines und Security-Hinweise gegen wiederkehrende
  Plattformregeln prüfen. Er erzeugt Findings und Kontext, aber keine blinde
  Freigabe.
- **AI Workload Platform:** AKS kann als Unterbau für spätere AI-Inference-
  Workloads dienen. Dieses Repository modelliert dafür GPU-Nodepool-Intent,
  Scheduling-, Kosten-, Secret-, Observability- und Approval-Grenzen, ohne
  laufende GPU-Kapazität oder eine produktive Modellplattform zu behaupten.

Das Repository ist ein ausführbarer, anonymisierter Denkansatz und keine
Behauptung über eine vollständig provisionierte Organisation,
Subscription-Landschaft oder Deployment-Strecke. Sichtbar werden die Fragen,
die ich vor einer Umsetzung kläre, die Grenzen, die ich bewusst ziehe, und die
Struktur, mit der andere Menschen meine Entscheidungen prüfen und weiterführen
können.

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

Im dargestellten Multi-Team-Betriebsmodell ist der Terraform-State zentral je
Subscription- und Environment-Grenze in Azure Storage vorgesehen. Jedes Team
oder Produkt erhält einen eigenen Container mit Entra-RBAC auf Container-Scope;
jedes Fach-Repository verwendet darin einen eindeutigen State-Key. So bleibt
der Backend-Service zentral betreibbar, ohne anderen Teams Zugriff auf fremde
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

Die Trennung ist absichtlich sichtbar: Direkt prüfbarer Code, modellierte
Verträge und nächste Integrationsschritte bleiben getrennt, damit ein Review
erkennen kann, was heute ausführbar ist und was bewusst als Plattformvertrag
vorbereitet wurde.

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

Kubernetes/AKS ist in diesem Portfolio eine echte Plattformschicht. Aus der
praktischen Kubernetes-Lab-Arbeit bringe ich Verständnis für Desired State,
Namespaces, Ingress, Storage, RBAC, Helm, Troubleshooting und den Unterschied
zwischen gewünschtem und tatsächlichem Clusterzustand mit. In diesem
öffentlichen Repository übersetze ich dieses Verständnis in AKS-Intent,
Kustomize-Blueprints, Security Defaults, NetworkPolicies, Ressourcensteuerung,
Rollout-Verhalten und CI-Validierung.
Damit ist Kubernetes ein sichtbarer Teil meiner Plattformarbeit: nicht als
isolierte YAML-Sammlung, sondern als Betriebsmodell mit klaren Grenzen,
Validierung und überprüfbarem gewünschtem Zustand.

Flux ergänzt dieses Modell als GitOps-Schicht. Für mich beantwortet Flux eine
einfache Betriebsfrage: Wenn Git die Source of Truth ist, wer sorgt später im
Cluster dafür, dass dieser Zustand wirklich ankommt und sichtbar bleibt? CI
prüft vor dem Merge. Flux gleicht danach Kustomize- oder Helm-basierte
Konfiguration im Cluster ab und macht Status, Events, Health und Drift
sichtbar.

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
| Betriebs-, Review- und Verantwortungsmodell | [Operating Model](docs/operating-model.md) |
| Landing-Zone-Denkweg, Management Groups und Subscription Vending | [Landing Zone Thinking](docs/landing-zone-thinking.md) |
| Kleinster verantwortbarer Tenant-Governance-Slice | [ALZ Core Contract](docs/alz-core-contract.md) |
| Gesamtarchitektur und Datenfluss | [Architecture](docs/architecture.md) |
| Nonproduction/Production-Modell | [Environments](environments/README.md) |
| Terraform-Root-Stacks | [Terraform Stacks](terraform/stacks/README.md) |
| Wiederverwendbare Terraform-Pipeline | [Pipeline Blueprint](pipeline-blueprints/terraform/README.md) |
| AI-assisted Platform Governance | [AI Governance](docs/ai-assisted-platform-governance.md) |
| AI Workload Platform auf AKS | [AI Workload Platform](docs/ai-workload-platform-pattern.md) |
| Kubernetes und Blueprints | [Kubernetes](kubernetes/README.md) |
| Flux GitOps und Reconciliation | [Flux GitOps Pattern](docs/flux-gitops-pattern.md) |
| Security und Subscription-Trennung | [Security](docs/security-considerations.md) |
| Guardrails und Pipeline-Gates | [Guardrails](docs/guardrails.md) |
| Change-, Release- und Tag-Governance | [Change Governance](docs/change-governance.md) |
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
