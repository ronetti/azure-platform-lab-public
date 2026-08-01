# Anonymisierte Fallstudie: Vom Einzelaufbau Zum Plattformvertrag

Diese Fallstudie bündelt wiederkehrende Fragestellungen aus meiner
Infrastruktur- und Automatisierungspraxis in einem eigenständig entwickelten
Portfoliomodell. Sie bildet keine konkrete Organisation oder Kundenumgebung
1:1 ab. Entscheidend sind die technische Methode und die im Repository
überprüfbaren Ergebnisse.

Der Kern ist meine Arbeitsweise: Ich versuche nicht, möglichst viele Services
nebeneinanderzustellen. Ich schneide Verantwortung, State, Delivery und
Betrieb so, dass ein Team später verstehen kann, wo die Wahrheit liegt, welche
Änderung erlaubt ist, was geprüft wurde und wie der Rückweg aussieht.

## Ausgangslage

Mehrere Workloads sollen wiederholbar bereitgestellt werden. Testing und
Staging dürfen aus Kostengründen gemeinsame Plattformdienste verwenden,
Production muss davon technisch und organisatorisch getrennt bleiben.
Gleichzeitig sollen Änderungen nicht durch kopierte Terraform-Verzeichnisse,
manuelle Portalkonfiguration oder Wissen einzelner Personen gesteuert werden.

## Aufgabe

Gesucht ist ein einfach lesbarer Plattformvertrag, der vier Anforderungen
verbindet:

- eine verantwortete Konfigurationsquelle je Fach-Repository und
  Environment-Grenze
- klare Übergaben zwischen NetOps, SysOps und Platform Engineering
- wiederverwendbare Delivery mit überprüfbaren Security- und
  Freigabegrenzen
- ein Betriebsmodell, das Kosten, Verfügbarkeit und Wiederherstellung nicht
  erst nach dem Deployment betrachtet

## Entscheidungsprinzip

Die Lösung soll nicht möglichst viele Azure-Dienste verwenden, sondern das
einfachste Modell, das die fachlichen und technischen Risiken beherrscht.
Deshalb werden Alternativen nach Sicherheit, Applikationsverhalten,
Betriebsaufwand, Testbarkeit und Kosten verglichen. Komplexere Erweiterungen
wie identitätsbasiertes Routing, zusätzliche interne Layer-7-Verteilung oder
feingranulare ASG-Regeln folgen erst bei einem belegten Bedarf und nach
geeigneten Tests. Die Roadmap trennt dabei Ist-Stand, Zielbild und noch offene
Voraussetzungen. Wissenstransfer, Support-Grenzen und realistische
Teamkapazität gehören zur Architekturentscheidung und werden nicht durch ein
zu optimistisches Automatisierungsversprechen ersetzt.

Das ist bewusst eine Platform-Engineering-Entscheidung und keine reine
Diagrammübung. Für mich ist eine Lösung erst stark, wenn sie Code,
Konfiguration, Reviews, CI, Betriebsreaktionen und Recovery zusammenbringt.
Einzelne Ressourcen sind wichtig; belastbar wird die Plattform erst durch die
Verträge dazwischen.

## Methode

1. Jeder Plattformbereich besitzt im zugrundeliegenden Modell ein eigenes,
   multi-environment-fähiges Repository mit YAML-Konfiguration,
   Backend-/State-Grenze, Pipeline, Security-Assets und README. Das kompakte
   Lab konsolidiert diese Verträge in je einer Nonproduction- und
   Production-Datei.
2. Fachlich getrennte Root-Stacks für Network, Routing, Firewall, Application
   Gateway, Compute, AKS und Shared Services lesen denselben
   Environment-Vertrag und tauschen nur definierte Outputs über Remote State
   aus.
3. Testing und Staging teilen zentrale Nonproduction-Dienste wie Network,
   Edge/WAF, Firewall, AKS, Registry, Key Vault und Monitoring. Innerhalb von
   Kubernetes bleiben sie über Namespaces, Quotas und NetworkPolicies
   getrennt. Der zentrale Request-Pfad führt über Application Gateway/WAF zum
   internen Ingress und nicht über eine Plattformkopie pro Workload.
4. Production verwendet eine eigene Subscription mit eigenen States,
   Ressourcen, Identitäten, Secrets und Betriebsdaten und konsumiert keine
   Nonproduction-Runtime-Ressourcen.
5. Ein wiederverwendbarer GitHub-Actions-Workflow standardisiert Check,
   Validate, Plan-Artefakt und geschützten Apply. Ein Produkt-README-Template
   hält Verwendung, Ownership, Outputs und Betrieb direkt beim Consumer fest.
6. Kubernetes-Blueprints liefern Namespace-, Netzwerk-, Ressourcen- und
   Pod-Security-Guardrails. Sie zeigen Kubernetes als Plattformvertrag:
   Desired State in Git, renderbare Overlays, getrennte Verantwortungen und
   Verifikation vor dem Apply. Testing nutzt Rolling Deployments; Staging und
   Production modellieren Blue-Green mit Freigabe und Rückwechsel.
7. Flux ergänzt dieses Modell als GitOps-Reconciliation-Layer: Nach Review und
   CI bleibt Git die Source of Truth, und der Cluster kann den freigegebenen
   Zustand über Kustomizations oder Helm Releases fortlaufend abgleichen.
8. Terraform-Outputs bilden den stabilen Übergabevertrag von Compute zu einer
   getrennten Ansible-Konfigurationspipeline, statt Hosts doppelt zu pflegen.
9. Security-Ausnahmen, Monitoring, Runbooks sowie Backup- und Restore-Muster
   werden versioniert und gehören damit zum Plattformvertrag.
10. Logische Namen dienen als stabile Schlüssel für konfigurationsgetriebenen
   VM-Intent. Ein Terraform-Plan muss sichtbar machen, ob eine Änderung
   aktualisiert, ergänzt oder ersetzt, bevor ein Apply freigegeben wird.

## Im Repository Nachweisbares Ergebnis

| Ergebnis | Nachweis |
| --- | --- |
| Das Lab macht Nonproduction und Production kompakt sichtbar und dokumentiert zugleich die Single Source of Truth je eigenständigem Fach-Repository. | [`environments/`](../environments/README.md) und [`terraform/`](../terraform/README.md) |
| Die CI prüft getrennte Backends und verhindert Production-Verweise auf Nonproduction- sowie Testing-/Staging-Kubernetes-Ressourcen. | [`.github/workflows/validate.yml`](../.github/workflows/validate.yml) |
| Routing- und Segmentierungsalternativen werden mit Nutzen, Risiko und begründeter Empfehlung dokumentiert. | [`docs/application-gateway-waf-pattern.md`](application-gateway-waf-pattern.md) und [`docs/network-segmentation-pattern.md`](network-segmentation-pattern.md) |
| Produkt-Repositories können denselben Terraform-Ablauf mit eigenen Parametern konsumieren; OIDC-, Plan-, Apply- und README-Verträge sind gemeinsam dokumentiert. | [`pipeline-blueprints/terraform/`](../pipeline-blueprints/terraform/README.md) |
| Testing, Staging und Production werden aus gemeinsamen Kubernetes-Blueprints mit eigenen Overlays und Guardrails gerendert. Kubernetes ist als Plattformvertrag mit Desired State, Security-Grenzen, Ressourcensteuerung und CI-Validierung sichtbar. | [`kubernetes/`](../kubernetes/README.md) |
| Flux beschreibt die GitOps-Schicht zwischen freigegebenem Git-Zustand und laufendem Clusterzustand: Sources, Kustomizations, Helm Releases, Health, Events und Drift-Sichtbarkeit. | [`docs/flux-gitops-pattern.md`](flux-gitops-pattern.md) |
| Compute-Outputs werden als Inventory-Vertrag für getrenntes Konfigurationsmanagement veröffentlicht. | [`terraform/stacks/configuration-management/`](../terraform/stacks/configuration-management/README.md) |
| Security-Ausnahmen benötigen Rule-ID, Begründung, Owner und Ablaufdatum und werden automatisch validiert. | [`assets/security_checks/`](../assets/security_checks/README.md) |
| Monitoring, Availability Engineering, Restore-Prüfungen und Betriebsreaktionen sind als zusammenhängendes Modell dokumentiert. | [`docs/availability-engineering.md`](availability-engineering.md) und [`docs/runbook.md`](runbook.md) |
| VM-Intent wird aus YAML über einen stabilen logischen Namen abgebildet; die tatsächliche Änderungswirkung bleibt im Terraform-Plan prüfbar. | [`terraform/stacks/compute/main.tf`](../terraform/stacks/compute/main.tf) |

## Gezielte Wirkung

Der Ansatz ist darauf ausgelegt, routinemäßige Plattformänderungen als kleine,
reviewbare Datenänderungen abzubilden. Wiederverwendbare Verträge reduzieren
Copy-Paste und manuelle Portalabhängigkeit. Klare Outputs und dokumentierte
Übergabepunkte machen Verantwortung sichtbar. Die harte Production-Grenze
verhindert, dass Kostenoptimierung in Nonproduction zur Sicherheits- oder
Runtime-Abhängigkeit für Production wird. Blue-Green verdoppelt während eines
Releases nur die betroffene Workload und nicht die gesamte Plattformbasis.

## Ergebnisgrenze

Die genannten Ergebnisse sind anhand der Dateien und CI-Prüfungen dieses
Portfolio-Repositories nachvollziehbar. Sie sind keine Behauptung über eine
vollständig provisionierte Kundenplattform. Es werden bewusst keine internen
Größenordnungen, Kundendaten oder nicht freigegebenen Zeit-, Kosten- und
Qualitätskennzahlen veröffentlicht. Entra-OIDC-Federation, echte Azure-
Deployments und der Blue-Green-Traffic-Wechsel benötigen externe Konfiguration
beziehungsweise einen Rollout-Controller und werden nicht als bereits
implementiert ausgegeben.

## English Summary

This case study turns recurring infrastructure and automation problems into an
anonymized platform model. The focus is not a diagram or a list of Azure
services, but the operating contract between teams: source of truth,
environment boundaries, state ownership, reusable delivery, Kubernetes desired
state, Flux GitOps reconciliation, monitoring, runbooks and recovery.

The repository shows reviewable results: consolidated nonproduction and
production contracts, Terraform root-stack boundaries, CI validation,
Kubernetes blueprints, Flux as the planned GitOps layer, configuration-
management handover through Terraform outputs and documented security and
recovery patterns. It does not publish internal implementation details,
customer data, real identifiers or organization-specific metrics.
