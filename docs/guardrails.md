# Guardrails

## Ziel

Guardrails setzen sichere Leitplanken, ohne Plattformteams in manuellen
Prozessen zu blockieren. Sie machen sichtbar, welche Änderungen erlaubt,
reviewpflichtig oder nicht akzeptabel sind.

## Purpose

Guardrails provide safe boundaries without blocking platform teams in manual
processes. They make it visible which changes are allowed, require review or
are not acceptable.

## Guardrail-Ebenen

- Repository-Struktur und README-Konventionen
- YAML als nachvollziehbare Quelle für Konfiguration
- Terraform- und Kubernetes-Validierung in Pipelines
- zentrale, toolbezogene Security-Check-Ausnahmen unter `assets/`
- Security Defaults in Kubernetes-Manifests
- Flux GitOps-Reconciliation für freigegebene Kubernetes-Zustände
- AI-assisted Reviews als zusätzliche Risiko- und Konsistenzprüfung vor dem
  Merge
- WAF-Regeln, Exclusions und Managed-Rule-Overrides als Konfiguration, die im
  Review sichtbar bleibt
- Ansible Playbooks, Rollen und Inventory-Mapping mit eigenen Pipeline-Gates
- Reviews und Approvals für produktionsnahe Änderungen
- Changelogs für relevante Plattformänderungen

## Guardrail Layers

- repository structure and README conventions
- YAML as the understandable source for configuration
- Terraform and Kubernetes validation in pipelines
- centralized, tool-specific security-check exceptions under `assets/`
- security defaults in Kubernetes manifests
- Flux GitOps reconciliation for approved Kubernetes desired state
- AI-assisted reviews as an additional risk and consistency check before merge
- WAF rules, exclusions and managed-rule overrides as configuration that stays
  visible in review
- Ansible playbooks, roles and inventory mapping with dedicated pipeline gates
- reviews and approvals for production-like changes
- changelogs for relevant platform changes

## Kubernetes-Guardrails

Beispiele für Kubernetes-Guardrails:

- Namespace erzwingt den Pod Security Standard `restricted`
- Default-Deny für Ingress und Egress
- explizite Freigaben für DNS, Namespace-internen Verkehr und Managed Ingress
- ResourceQuota und LimitRange als Kosten- und Stabilitätsgrenze
- `runAsNonRoot: true`
- `allowPrivilegeEscalation: false`
- `seccompProfile: RuntimeDefault`
- Drop aller Linux Capabilities, sofern möglich
- kein automatisch eingebundenes Service-Account-Token
- definierte CPU- und Memory-Requests
- definierte CPU- und Memory-Limits
- GPU-Ressourcen nur in dafür vorgesehenen Inference-Blueprints
- Readiness- und Liveness-Probes
- Startup-Probe, PodDisruptionBudget und HorizontalPodAutoscaler
- interne Services als `ClusterIP`
- Namespace-Labels für Umgebung und Ownership
- Labels für die Zuordnung zu Nonproduction oder Production
- keine Secrets als Klartext in Git

Die Guardrails sind nicht nur dokumentiert. Sie liegen im
`kubernetes/blueprint-templates/platform-baseline` und werden von allen
Environment-
Overlays konsumiert. Änderungen am Blueprint wirken damit kontrolliert auf
Testing, Staging und Production.

Flux ergänzt diese Guardrails nach dem Merge. Ein freigegebener Zustand wird
nicht manuell im Cluster nachgebaut, sondern über GitOps abgeglichen. Damit
werden Drift, Reconcile-Fehler und Health-Probleme als Betriebszustand
sichtbar.

## Kubernetes Guardrails

Examples of Kubernetes guardrails:

- restricted Pod Security Standard on workload namespaces
- default-deny ingress and egress with explicit network paths
- ResourceQuota and LimitRange as cost and stability boundaries
- `runAsNonRoot: true`
- `allowPrivilegeEscalation: false`
- `seccompProfile: RuntimeDefault`
- drop all Linux capabilities where possible
- defined CPU and memory requests
- defined CPU and memory limits
- GPU resources only in dedicated inference blueprints
- readiness and liveness probes
- internal services as `ClusterIP`
- namespace labels for environment and ownership
- no plaintext secrets in Git

## Pipeline-Gates

Dieses Repository nutzt bewusst einfache, nachvollziehbare Gates:

- Terraform formatting
- GitHub Actions syntax with actionlint
- Terraform stack validation
- YAML linting
- Kubernetes schema validation
- Flux source and kustomization status checks
- getrennte Ansible-Pipeline mit Linting, Syntax Check und Check Mode
- validierter Security-Ausnahmen für IaC-Scanner
- versionsgepinntes Terraform-Pipeline-Blueprint für Produkt-Repositories

Scanner-Ausnahmen liegen zentral in `assets/security_checks`. Jede aktive
Rule-ID braucht eine Begründung, einen Owner und ein Ablaufdatum. Leere Dateien
bedeuten bewusst, dass keine Ausnahme genehmigt ist. Die wiederverwendbare
Action `.github/actions/security-exceptions` validiert dieses Format und gibt
die IDs für nachgelagerte Scanner-Schritte aus.

Der wiederverwendbare GitHub-Actions-Workflow unter
`.github/workflows/terraform-blueprint.yml` trennt Produktparameter vom
gemeinsamen Delivery-Ablauf. Consumer pinnen eine Blueprint-Version;
Production-Approvals liegen als Protection Rules am GitHub Environment.
Plan und Apply verwenden getrennte, environmentbezogene Entra-OIDC-
Identitäten.

In einer produktionsnahen Plattform könnten weitere Gates ergänzt werden:

- Policy-as-Code, zum Beispiel OPA Gatekeeper, Kyverno oder Azure Policy
- AI-assisted Review für Terraform, Kubernetes, YAML, Pipelines,
  Security-Hinweise und Betriebsstandards
- Container Image Scanning
- Secret Scanning
- Terraform Security Scanning
- Drift Detection
- manuelle Approval-Stages für produktionsnahe Umgebungen

Für alert-gesteuerte Ansible-, Update- oder Restore-Pipelines wären zusätzliche
Regeln nötig:

- Alerts starten keine unkontrollierten Reparaturen.
- Pipeline-Parameter wie Solution, Umgebung, Fehlerart und Recovery Point
  müssen explizit gesetzt oder aus vertrauenswürdigen Signalen abgeleitet
  werden.
- Kritische Schritte wie Restore, Rollback oder datenbanknahe Änderungen
  brauchen ein Approval.
- Secrets oder Tokens für Webhooks und Pipeline-Starts liegen nicht im Code.
- Jeder automatische Schritt schreibt Logdaten für spätere RTO-/RPO- und
  Incident-Auswertung.
- Restore- oder Self-Healing-Schritte müssen idempotent oder sicher
  wiederholbar sein.

## Pipeline Gates

This repository intentionally uses simple, understandable gates:

- Terraform formatting
- GitHub Actions syntax with actionlint
- Terraform stack validation
- YAML linting
- Kubernetes schema validation
- Flux source and kustomization status checks
- environment and delivery validation
- separate Ansible pipeline with linting, syntax check and check mode
- validated security-exception files for IaC scanners
- version-pinned Terraform pipeline blueprint for product repositories

In a production-like platform, additional gates could be added:

- policy as code, for example OPA Gatekeeper, Kyverno or Azure Policy
- AI-assisted review for Terraform, Kubernetes, YAML, pipelines, security
  signals and operational standards
- container image scanning
- secret scanning
- Terraform security scanning
- drift detection
- manual approval stages for production-like environments

Alert-driven Ansible, update or restore pipelines require additional rules:

- Alerts do not start uncontrolled repairs.
- Pipeline parameters such as solution, environment, failure type and recovery
  point must be explicit or derived from trusted signals.
- Critical steps such as restore, rollback or database-related changes require
  approval.
- Secrets or tokens for webhooks and pipeline starts are not stored in code.
- Each automated step writes logs for later RTO/RPO and incident analysis.
- Restore or self-healing steps must be idempotent or safely repeatable.

## Repo-Bezug

- `.github/workflows/validate.yml` enthält die aktuellen Pipeline-Gates.
- `assets/security_checks` enthält zentrale Ausnahmen für Checkov, Terrascan,
  TFLint und tfsec.
- `.github/actions/security-exceptions` ist das gemeinsame Pipeline-Template
  zum Validieren und Einlesen dieser Ausnahmen.
- `.github/workflows/terraform-blueprint.yml` enthält den wiederverwendbaren
  GitHub-Actions-Ablauf für Check, Validate, Plan und freigegebenen Apply.
- `pipeline-blueprints/terraform` enthält Consumer-Beispiel und
  Nutzungsdokumentation.
- `environments/` beschreibt Nonproduction und Production in zwei Dateien;
  CI prüft Testing, Staging und Blue-Green-Zuordnung.
- `kubernetes/blueprint-templates/platform-baseline` enthält gemeinsame
  Namespace-, Netzwerk- und Ressourcen-Guardrails.
- `kubernetes/blueprint-templates/web-workload` enthält gemeinsame Security-
  und Availability-Defaults für Workloads.
- `kubernetes/blueprint-templates/inference-workload` enthält die vorbereitete
  Basis für spätere AI-Inference-Workloads mit GPU-Scheduling,
  Ressourcenlimits und interner Service-Grenze.
- `docs/change-governance.md` beschreibt Reviews, Approvals und Changelog.
- `docs/ai-assisted-platform-governance.md` beschreibt AI als zusätzliche
  Review- und Governance-Schicht ohne automatische Verantwortungsübernahme.
- `docs/ai-workload-platform-pattern.md` beschreibt AKS als möglichen
  Unterbau für AI-Workloads, ohne laufende GPU- oder Model-Serving-Plattform
  zu behaupten.
- `docs/availability-engineering.md` verbindet Guardrails mit Error Budgets.

## Repository Mapping

- `.github/workflows/validate.yml` contains the current pipeline gates.
- `assets/security_checks` contains centralized Checkov, Terrascan, TFLint and
  tfsec exceptions.
- `.github/actions/security-exceptions` is the shared pipeline template for
  validating and reading those exceptions.
- `.github/workflows/terraform-blueprint.yml` contains the reusable GitHub
  Actions workflow for checks, validation, planning and approved apply.
- `pipeline-blueprints/terraform` contains the consumer example and usage
  documentation.
- `kubernetes/blueprint-templates/platform-baseline` contains shared namespace,
  network and resource guardrails.
- `kubernetes/blueprint-templates/web-workload` contains shared workload security and
  availability defaults.
- `kubernetes/blueprint-templates/inference-workload` contains the modeled
  baseline for future AI inference workloads with GPU scheduling, resource
  boundaries and internal service exposure.
- `docs/flux-gitops-pattern.md` describes Flux as the GitOps reconciliation
  layer between approved Git state and runtime cluster state.
- `platform.azure-lab.io/guardrails` labels mark the intended guardrail profile
  on example Kubernetes resources.
- `docs/change-governance.md` describes reviews, approvals and changelog.
- `docs/ai-assisted-platform-governance.md` describes AI as an additional
  review and governance layer without automatic accountability transfer.
- `docs/ai-workload-platform-pattern.md` describes AKS as a possible
  foundation for AI workloads without claiming a running GPU or model-serving
  platform.
- `docs/availability-engineering.md` connects guardrails with error budgets.
