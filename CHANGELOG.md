# Changelog / Änderungsverlauf

Alle relevanten Änderungen an diesem anonymisierten Azure Platform Lab werden
hier dokumentiert.

All notable changes to this anonymized Azure Platform Lab are documented here.

## Unveröffentlicht / Unreleased

### Hinzugefügt / Added

- Begründetes Azure-Landing-Zone-Denkmodell mit Management-Group-
  Entscheidungslogik, Einordnung der bestehenden Workload-Subscriptions,
  gestuftem Policy-Lifecycle, Subscription-Vending-Vertrag und expliziter
  Trennung zwischen dokumentiertem Zielbild und noch nicht implementierter
  Tenant-Governance.
- Reasoned Azure Landing Zone model covering management-group decisions,
  placement of the existing workload subscriptions, staged policy lifecycle,
  subscription vending and the explicit boundary between the documented target
  state and tenant governance that has not yet been implemented.
- Kleinster verantwortbarer ALZ-Core-Vertrag mit explizitem Scope, eigenem
  State, nicht erzwingendem Policy-Einstieg, Review-Gates, Rücknahmepfad und
  offenen Entscheidungen vor einer späteren Terraform-Implementierung.
- Smallest responsible ALZ Core contract with explicit scope, independent
  state, non-enforcing policy entry point, review gates, rollback path and open
  decisions before a later Terraform implementation.
- Verbindliche Projektregeln für Landing-Zone-Entscheidungen sowie ein
  belegtes Release- und Tag-Prinzip: Semantic Versioning bezieht sich primär
  auf den öffentlichen Workflow-Vertrag; reine Dokumentationsänderungen
  erzwingen keinen Release und Tag-Unveränderlichkeit wird nur bei technisch
  geprüfter Durchsetzung behauptet.
- Binding project rules for Landing Zone decisions and an evidence-based
  release and tag principle: Semantic Versioning primarily applies to the
  public workflow contract, documentation-only changes do not force a release,
  and tag immutability is claimed only when technically enforced and verified.
- GitHub-Workflow-Härtung durch explizite minimale Token-Rechte und deaktivierte
  persistierte Checkout-Anmeldedaten, wenn keine authentifizierten Git-Befehle
  benötigt werden.
- GitHub workflow hardening through explicit minimum token permissions and
  disabled persisted checkout credentials where authenticated Git commands are
  not required.
- Aktualisierung und Verifikation der vollständigen Action-SHAs für
  `actions/checkout` `v7.0.1` und `actions/setup-go` `v7.0.0`.
- Updated and verified full action SHAs for `actions/checkout` `v7.0.1` and
  `actions/setup-go` `v7.0.0`.
- Geprüfte Aktualisierung der gepinnten Terraform-Standardversion des
  reusable Workflows von `1.10.5` auf `1.15.8`.
- Verified update of the reusable workflow's pinned default Terraform version
  from `1.10.5` to `1.15.8`.
- Flux-GitOps-Pattern als Reconciliation-Schicht zwischen freigegebenem
  Git-Zustand und laufendem Kubernetes-Cluster, einschließlich Sources,
  Kustomizations, Helm Releases, Health, Events, Drift-Sichtbarkeit,
  Secret-Grenzen und Betriebsfragen.
- Flux GitOps pattern as the reconciliation layer between approved Git state
  and the running Kubernetes cluster, including sources, kustomizations, Helm
  releases, health, events, drift visibility, secret boundaries and operating
  questions.
- AI-assisted Platform-Governance-Pattern als zusätzliche Review-Schicht für
  Terraform, Kubernetes, YAML, Pipelines, Security-Hinweise und
  Betriebsstandards mit klarer Grenze: AI erzeugt Findings und Kontext, ersetzt
  aber keine Verantwortung, Approvals oder Production-Validierung.
- AI-assisted platform governance pattern as an additional review layer for
  Terraform, Kubernetes, YAML, pipelines, security signals and operational
  standards with a clear boundary: AI creates findings and context but does not
  replace accountability, approvals or production validation.
- Schneller README-Einstieg mit CI-Badge, kompakten Portfolio-Signalen,
  empfohlenen Deep-Dive-Links und englischem Snapshot für bessere
  Erstbewertung durch Recruiter und Hiring Manager.
- Faster README entry with CI badge, compact portfolio signals, recommended
  deep-dive links and an English snapshot for quicker evaluation by recruiters
  and hiring managers.
- AI-Workload-Platform-Pattern mit modelliertem AKS/GPU-Nodepool-Intent,
  Inference-Workload-Blueprint, Scheduling-, Kosten-, Secret-, Observability-
  und Approval-Grenzen als klar abgegrenzter nächster Ausbauschritt.
- AI workload platform pattern with modeled AKS/GPU nodepool intent, inference
  workload blueprint, scheduling, cost, secret, observability and approval
  boundaries as a clearly separated next expansion step.

### Geändert / Changed

- Die Ansible-Dokumentation präzisiert den Übergabevertrag zwischen Terraform
  Outputs beziehungsweise Remote State und getrennten
  Configuration-Management-Pipelines einschließlich ihrer Guardrails.
- The Ansible documentation now clarifies the handover contract between
  Terraform outputs or remote state and separate configuration-management
  pipelines, including their guardrails.
- Die Solution-weite Recovery-Automatisierung wird als integrierter
  Betriebsablauf aus VM-spezifischen Restore-/Rebuild-Pfaden, Validierungen,
  Logging und kontrollierter Terraform-Re-Adoption beschrieben.
- Solution-wide recovery automation is now described as an integrated
  operating flow with VM-specific restore or rebuild paths, validation,
  logging and controlled Terraform re-adoption.
- Landing-Zone-, Application-Gateway-, Security- und Guardrail-Dokumentation
  verwendet aktive Entscheidungs- und Prüfsprache, ohne modellierte oder noch
  nicht implementierte Plattformteile als produktiv auszugeben.
- Landing Zone, Application Gateway, security and guardrail documentation now
  uses active decision and verification language without presenting modeled or
  not-yet-implemented platform parts as production deployments.

## 1.0.0 - 2026-07-13

### Hinzugefügt

- Kurze anonymisierte Plattform-Fallstudie mit im Repository überprüfbaren
  Ergebnissen und klarer Abgrenzung zu produktiven Kundenkennzahlen.
- Kubernetes Platform Baseline und Web Workload Blueprints mit Kustomize.
- Kosten- und verfügbarkeitsbewusste AKS-Intents und Kubernetes-Overlays für
  Testing, Staging und Production.
- Namespace-, Ressourcen-, Netzwerk- und Pod-Security-Guardrails als
  wiederverwendbarer Plattformvertrag.
- Zentrale `assets/security_checks`-Konvention und wiederverwendbare
  Pipeline-Action für begründete, verantwortete und befristete Scanner-
  Ausnahmen.
- Wiederverwendbarer GitHub-Actions-Terraform-Workflow mit Check, Validate,
  Plan-Artefakt, Entra OIDC, geschütztem Apply, versionsgepinntem
  Consumer-Beispiel sowie Nutzungs-READMEs für alle Terraform-Root-Stacks.

- Stack-basierte Terraform-Struktur unter `terraform/stacks/`, um getrennte
  Root-Repositories und Remote-State-Übergaben zu modellieren.
- YAML-getriebene Konfigurationsbeispiele für Network, Routing, Firewall,
  Compute, AKS, Application Gateway und Shared Services.
- Architektur-Pattern für Netzwerksegmentierung, Application Gateway/WAF,
  stateful Workloads, Availability Engineering, Change Governance,
  Kubernetes-Plattformmuster und Guardrails.
- Betriebsdokumentation für SLI/SLO/SLA-Denken, Error Budgets, Monitoring,
  Runbooks, Reviews, Approvals und Pipeline-Gates.
- Ansible-Configuration-Management-Pattern mit Terraform Outputs als
  Inventory-Quelle und getrennten Pipeline-Guardrails.
- Anonymisiertes Restore-Automatisierungs-Pattern mit Azure VM Backup
  Policies, automatischen Backups nach definierten Regeln,
  Python-Orchestrierungslogik, Logging, RTO/RPO-Ableitung und
  Terraform-Drift-Vermeidung.
- Governance-, Guardrail- und Availability-Felder in zentralen Environment-
  und Stack-YAML-Dateien.
- README-Dateien für alle Basismodule.
- Copyright- und No-License-Hinweis für Portfolio- und Architekturbeispiele.

### Geändert

- Externe GitHub Actions sind auf vollständige Commit-SHAs und aktuelle
  Node.js-24-fähige Releases gepinnt; lesbare Versionskommentare dokumentieren
  den jeweiligen Release-Stand.
- Terraform-Provider-Auswahlen der ausführbaren Root-Stacks sind über
  eingecheckte Lockfiles reproduzierbar; der kubeconform-Download in CI wird
  vor der Ausführung per SHA-256 geprüft.
- Lose Kubernetes-Beispiele wurden durch renderbare Blueprints und
  Environment-Overlays ersetzt.
- Kubernetes-CI rendert und validiert Nonproduction mit Testing und Staging
  sowie Production als getrennte Infrastrukturgrenzen.
- Zwei kompakte Environment-Bereiche beschreiben Nonproduction und Production.
- Testing und Staging teilen die kostenintensiven Nonproduction-Dienste;
  Blue-Green ist als Delivery-Strategie für Staging und Production modelliert.
- Alle Terraform-Root-Stacks besitzen parallele Nonproduction- und
  Production-Konfigurationen mit getrennten State-Accounts und State-Schlüsseln.
- Kubernetes gruppiert Testing und Staging unter Nonproduction und hält das
  Production-Overlay als eigene Infrastrukturgrenze.
- Nicht angebundene Helm-Beispielwerte und doppelte Observability-Notizen
  wurden entfernt; das Zielbild liegt kompakt in `docs/monitoring.md`.
- Der Kubernetes-Datenpfad ist durchgängig als Application Gateway/WAF,
  interner AKS-Ingress und Workload-Service modelliert; TLS-Referenzen und eine
  Blue-Green-fähige Production-Quota sind sichtbar.
- Der alte monolithische Terraform-Root und nicht implementierte README-only
  Module wurden zugunsten der eindeutigen Stack-Struktur entfernt.
- Stack-spezifische Kopien von Environment- und Backend-Daten wurden durch
  genau eine YAML- und Backend-Basis je Subscription-Grenze ersetzt.

- Die Haupt-README wurde auf einen kompakten Recruiter-/Tech-Lead-Einstieg mit
  Architektur, Wirkung, Implementierungsstatus und gezielten Deep Dives
  reduziert.
- GitHub Actions validieren zusätzlich Terraform-Stacks und YAML-Dateien unter
  `terraform/stacks`.
- GitHub Actions prüfen die Configuration-Management-Guardrails.

### Hinweise

- Dieses Repository ist bewusst anonymisiert und enthält keine Kundennamen,
  produktiven IP-Adressräume, Secrets oder vertraulichen Architekturdetails.

### Added

- Short anonymized platform case study with repository-verifiable results and
  a clear boundary from production customer metrics.
- Stack-based Terraform structure under `terraform/stacks/` to model separate
  root repositories and remote-state handovers.
- YAML-driven configuration examples for network, routing, firewall, compute,
  AKS, Application Gateway and shared services.
- Architecture pattern documents for network segmentation, Application
  Gateway/WAF, stateful workloads, availability engineering, change governance,
  Kubernetes platform patterns and guardrails.
- Operational documentation for SLI/SLO/SLA thinking, error budgets, monitoring,
  runbooks, reviews, approvals and pipeline-gated delivery.
- Ansible configuration-management pattern with Terraform outputs as inventory
  source and separate pipeline guardrails.
- Anonymized restore automation pattern with Azure VM Backup policies,
  automatic backups based on defined rules, Python orchestration logic,
  logging, RTO/RPO derivation and Terraform drift avoidance.
- Governance, guardrail and availability fields in central environment and
  stack YAML files.
- README files for all baseline modules.
- Copyright and no-license notice for portfolio and architecture examples.

### Changed

- External GitHub Actions are pinned to full commit SHAs and current
  Node.js-24-capable releases, with readable version comments documenting the
  corresponding release.
- Reworked the main README into a bilingual portfolio cover and architecture
  overview.
- Extended GitHub Actions validation to include Terraform stack validation and
  YAML files below `terraform/stacks`.
- GitHub Actions check the configuration-management guardrails.

### Notes

- This repository is intentionally anonymized and does not contain customer
  names, production IP ranges, secrets or confidential architecture details.
