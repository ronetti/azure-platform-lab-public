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
- Security Defaults in Kubernetes-Manifests
- WAF-Regeln, Exclusions und Managed-Rule-Overrides als Konfiguration, die im
  Review sichtbar bleibt
- Ansible Playbooks, Rollen und Inventory-Mapping mit eigenen Pipeline-Gates
- Reviews und Approvals für produktionsnahe Änderungen
- Changelogs für relevante Plattformänderungen

## Guardrail Layers

- repository structure and README conventions
- YAML as the understandable source for configuration
- Terraform and Kubernetes validation in pipelines
- security defaults in Kubernetes manifests
- WAF rules, exclusions and managed-rule overrides as configuration that stays
  visible in review
- Ansible playbooks, roles and inventory mapping with dedicated pipeline gates
- reviews and approvals for production-like changes
- changelogs for relevant platform changes

## Kubernetes-Guardrails

Beispiele für Kubernetes-Guardrails:

- `runAsNonRoot: true`
- `allowPrivilegeEscalation: false`
- `seccompProfile: RuntimeDefault`
- Drop aller Linux Capabilities, sofern möglich
- definierte CPU- und Memory-Requests
- definierte CPU- und Memory-Limits
- Readiness- und Liveness-Probes
- interne Services als `ClusterIP`
- Namespace-Labels für Umgebung und Ownership
- keine Secrets als Klartext in Git

## Kubernetes Guardrails

Examples of Kubernetes guardrails:

- `runAsNonRoot: true`
- `allowPrivilegeEscalation: false`
- `seccompProfile: RuntimeDefault`
- drop all Linux capabilities where possible
- defined CPU and memory requests
- defined CPU and memory limits
- readiness and liveness probes
- internal services as `ClusterIP`
- namespace labels for environment and ownership
- no plaintext secrets in Git

## Pipeline-Gates

Dieses Repository nutzt bewusst einfache, nachvollziehbare Gates:

- Terraform formatting
- Terraform stack validation
- YAML linting
- Kubernetes schema validation
- getrennte Ansible-Pipeline mit Linting, Syntax Check und Check Mode

In einer produktionsnahen Plattform könnten weitere Gates ergänzt werden:

- Policy-as-Code, zum Beispiel OPA Gatekeeper, Kyverno oder Azure Policy
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
- Terraform stack validation
- YAML linting
- Kubernetes schema validation
- separate Ansible pipeline with linting, syntax check and check mode

In a production-like platform, additional gates could be added:

- policy as code, for example OPA Gatekeeper, Kyverno or Azure Policy
- container image scanning
- secret scanning
- Terraform security scanning
- drift detection
- manual approval stages for production-like environments

Alert-driven Ansible, update or restore pipelines would need additional rules:

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
- `kubernetes/apps/sample-app.yaml` zeigt Security- und Availability-Defaults.
- `docs/change-governance.md` beschreibt Reviews, Approvals und Changelog.
- `docs/availability-engineering.md` verbindet Guardrails mit Error Budgets.

## Repository Mapping

- `.github/workflows/validate.yml` contains the current pipeline gates.
- `kubernetes/apps/sample-app.yaml` shows security and availability defaults.
- `platform.azure-lab.io/guardrails` labels mark the intended guardrail profile
  on example Kubernetes resources.
- `docs/change-governance.md` describes reviews, approvals and changelog.
- `docs/availability-engineering.md` connects guardrails with error budgets.
