# Kubernetes Platform Pattern

## Ziel

Dieses Pattern beschreibt Kubernetes als Teil einer Plattform, nicht als
isolierten Cluster. Workloads sollen wiederholbar, sicher, beobachtbar und
über Konfiguration steuerbar sein.

## Purpose

This pattern describes Kubernetes as part of a platform, not as an isolated
cluster. Workloads should be reproducible, secure, observable and controlled
through configuration.

## Plattformprinzipien

- Namespaces trennen Workloads, Umgebungen und Betriebsbereiche.
- Manifeste und Helm Values liegen versioniert im Repository.
- Ressourcenrequests und Limits sind Pflicht.
- Readiness- und Liveness-Probes gehören dazu, damit der Betrieb später
  erkennen kann, ob ein Workload wirklich bereit ist.
- Container laufen ohne Root-Rechte und ohne Privilege Escalation.
- Services bleiben intern, wenn kein expliziter Edge-Zugriff notwendig ist.
- Ingress wird bewusst über eine definierte Edge-Schicht modelliert.
- Monitoring und Alerting sind Teil des Workload-Standards.

## Platform Principles

- namespaces separate workloads, environments and operational areas
- manifests and Helm values are versioned in the repository
- resource requests and limits are required
- readiness and liveness probes help operations understand whether a workload
  is really ready
- containers run without root privileges and without privilege escalation
- services stay internal unless explicit edge access is required
- ingress is modeled through a defined edge layer
- monitoring and alerting are part of the workload standard

## Konfiguration In Git

Kubernetes-Konfiguration soll nicht manuell im Cluster entstehen. Die gewünschte
Form liegt in Git:

- Namespace-Definitionen
- Deployment- und Service-Manifeste
- Ingress-Regeln
- PVCs und Storage-Anforderungen
- Helm Values für Monitoring-Komponenten
- Guardrails und Policy-Vorgaben

Änderungen laufen über Pull Requests, Validierung und Approvals.

## Configuration In Git

Kubernetes configuration should not be created manually in the cluster. The
desired shape lives in Git:

- namespace definitions
- deployment and service manifests
- ingress rules
- PVCs and storage requirements
- Helm values for monitoring components
- guardrails and policy requirements

Changes go through pull requests, validation and approvals.

## Availability Engineering

Kubernetes-SLIs können sein:

- Deployment Availability
- Pod Restart Rate
- Readiness-Probe-Erfolgsrate
- Liveness-Probe-Fehler
- CPU-, Memory- und Storage-Sättigung
- Ingress-Latenz und Fehlerrate
- PVC-Verfügbarkeit für stateful Workloads

Diese Signale können in SLOs und Error Budgets übersetzt werden. Wenn ein Error
Budget stark verbraucht ist, sollten Stabilisierung und Ursachenanalyse Vorrang
vor neuen Rollouts bekommen.

## Availability Engineering

Kubernetes SLIs can include:

- deployment availability
- pod restart rate
- readiness probe success rate
- liveness probe failures
- CPU, memory and storage saturation
- ingress latency and error rate
- PVC availability for stateful workloads

These signals can be translated into SLOs and error budgets. If an error budget
is heavily consumed, stabilization and root-cause analysis should take priority
over new rollouts.

## Dynamische Skalierfähigkeit

Skalierfähigkeit soll über Konfiguration gesteuert werden:

- Replica-Anzahl
- Ressourcenrequests und Limits
- Node-Pool-Zuordnung
- Storage-Größe
- Ingress-Hosts
- Helm Values
- Alerting- und Dashboard-Konfiguration

Das Muster ist dasselbe wie bei Terraform: Die generische Plattformlogik bleibt
stabil, die konkrete Ausprägung wird über versionierte Konfiguration geändert.

## Dynamic Scalability

Scalability should be controlled through configuration:

- replica count
- resource requests and limits
- node pool placement
- storage size
- ingress hosts
- Helm values
- alerting and dashboard configuration

The pattern is the same as with Terraform: generic platform logic remains
stable, while the concrete shape is changed through versioned configuration.

## Repo-Bezug

- `kubernetes/apps/sample-app.yaml` zeigt Probes, Ressourcenlimits und
  Security Context.
- `kubernetes/namespaces/` zeigt Namespace-Grenzen.
- `kubernetes/ingress/` zeigt kontrollierten Ingress.
- `kubernetes/storage/` zeigt Storage-Anforderungen.
- `helm/` zeigt Prometheus- und Grafana-Konfiguration.
- `observability/prometheus-grafana-notes.md` beschreibt Signale und
  Observability-Zielbild.

## Repository Mapping

- `kubernetes/apps/sample-app.yaml` shows probes, resource limits and security
  context.
- `kubernetes/namespaces/` shows namespace boundaries.
- `kubernetes/ingress/` shows controlled ingress.
- `kubernetes/storage/` shows storage requirements.
- `helm/` shows Prometheus and Grafana configuration.
- `observability/prometheus-grafana-notes.md` describes signals and the
  observability target model.
