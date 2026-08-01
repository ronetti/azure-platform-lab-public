# Kubernetes Platform Pattern

## Ziel

Dieses Pattern beschreibt Kubernetes als Teil einer Plattform, nicht als
isolierten Cluster. Workloads sollen wiederholbar, sicher, beobachtbar und
über Konfiguration steuerbar sein.

Die Darstellung folgt bewusst meiner Kubernetes-Lab-Arbeit: Ich baue
Schichten nacheinander auf, prüfe Voraussetzungen vor der Automatisierung und
trenne den gewünschten Zustand von der späteren Verifikation im laufenden
System. Genau daraus entsteht mein Kubernetes-Verständnis: nicht einzelne
YAML-Dateien sammeln, sondern Desired State, Verantwortungsgrenzen,
Netzwerkpfade, Storage, RBAC, Helm, Rollout-Verhalten und Troubleshooting als
zusammenhängendes Betriebsmodell sehen.

## Meine Plattformfragen

- Welche Schicht entsteht gerade?
- Welche Entscheidung ist Day 0 und später nur schwer änderbar?
- Was stellt die Plattform bereit und was konfiguriert ein Workload-Team?
- Welche sichere Vorgabe gilt automatisch?
- Wie wird eine Änderung vor dem Apply sichtbar?
- Wie werden Kosten, Verfügbarkeit und Betrieb gegeneinander abgewogen?

Diese Fragen sind wichtiger als die Anzahl vorhandener Kubernetes-Manifeste.
Ein Cluster ist für mich erst dann sinnvoll modelliert, wenn ein Team sehen
kann, was die Plattform vorgibt, was ein Workload-Team ändern darf, wie eine
Änderung vor dem Apply gerendert wird und woran man später erkennt, ob der
tatsächliche Zustand noch zum gewünschten Zustand passt.

## Blueprint-Modell

Das Repository nutzt keine Azure-Blueprint-Definitionen. Stattdessen bilden
Terraform-Stacks und versionierte Kustomize-Bases die wiederverwendbaren
Blueprints:

- Der Platform Baseline Blueprint definiert Namespace-, Security-, Netzwerk-
  und Ressourcen-Guardrails.
- Der Web Workload Blueprint definiert einen sicheren und beobachtbaren
  Workload-Vertrag.
- Environment-Overlays konfigurieren Testing, Staging und Production, ohne die
  Blueprint-Logik zu kopieren.

Ich habe mich bewusst gegen kopierte YAML-Dateien pro Umgebung entschieden.
Der wichtigste Grund ist die Single Source of Truth: Gemeinsame Standards
sollen nur an einer Stelle gepflegt werden. Wenn sich Security Defaults,
Labels, Network Policies oder Resource Limits ändern, soll diese Änderung
einmal in der gemeinsamen Basis passieren und nicht mehrfach in fast gleichen
Dateien nachgezogen werden. Kustomize macht genau diese Trennung sichtbar:
Bases beschreiben den Plattformstandard, Overlays nur die notwendigen
Unterschiede der jeweiligen Umgebung.

Flux ist die GitOps-Schicht, die in dieses Modell gehört, sobald ein Cluster
den freigegebenen Zustand selbst abgleichen soll. CI rendert und prüft die
Overlays vor dem Merge. Flux liest danach die freigegebenen Quellen aus Git
oder OCI, gleicht `Kustomization`- und `HelmRelease`-Objekte ab und macht über
Status, Events und Health Checks sichtbar, ob der Cluster den gewünschten
Zustand erreicht.

Testing und Staging laufen getrennt in einer gemeinsamen
Nonproduction-Umgebung. Namespaces, RBAC, Quotas und Network Policies halten ihre
Verantwortung getrennt, während Cluster, Edge, Egress und Monitoring gemeinsam
bezahlt werden. Production behält eine eigene Plattformgrenze, Redundanz und
Zonenverteilung; Kostenoptimierung erfolgt dort über Messwerte, Autoscaling und
später gegebenenfalls Reservierungen statt über den Abbau notwendiger
Verfügbarkeit.

Monitoring ist dabei Teil der Plattformbasis. Workload-Teams können eigene
Metriken und fachliche Alerts ergänzen, aber Diagnostic Settings, Log-Ziele und
grundlegende Betriebsstandards sollen nicht pro Team neu erfunden werden.

Blue-Green gehört zur Delivery, nicht zur Plattformtopologie. Staging soll den
parallelen Slot und den Traffic-Switch proben; dasselbe freigegebene Image wird
anschließend in Production mit zusätzlicher Freigabe ausgerollt. Während des
Wechsels wird Workload-Kapazität doppelt benötigt, die Plattformbasis aber
nicht kopiert. Die vorhandenen Kubernetes-Overlays nutzen noch RollingUpdate;
für den echten Traffic-Switch fehlt bewusst noch eine Pipeline oder ein
Rollout-Controller.

Flux löst Blue-Green nicht allein. Es liefert den Reconciliation-Vertrag. Für
Traffic-Wechsel, progressive Delivery oder automatisierte Promotion braucht es
zusätzlich einen bewusst gewählten Rollout-Mechanismus und klare Approval-
Regeln.

GitHub Actions und Flux lösen dabei unterschiedliche Aufgaben. GitHub Actions
prüft vor dem Merge, ob eine Änderung technisch korrekt ist und freigegeben
werden darf. Flux prüft danach fortlaufend, ob der Cluster noch dem
freigegebenen Git-Zustand entspricht. Ein einmaliges `kubectl apply` würde
diese dauerhafte Drift-Frage nicht beantworten.

## Purpose

This pattern describes Kubernetes as part of a platform, not as an isolated
cluster. Workloads should be reproducible, secure, observable and controlled
through configuration.

This follows my practical Kubernetes lab work: build layers step by step,
check prerequisites before automation and keep desired state separate from
runtime verification. That is the Kubernetes skill I want to make visible here:
not collecting YAML files, but understanding desired state, ownership
boundaries, network paths, storage, RBAC, Helm, rollout behavior and
troubleshooting as one operating model.

The blueprint model deliberately avoids copied YAML files per environment.
The reason is Single Source of Truth: shared standards should be maintained in
one place. Security defaults, labels, NetworkPolicies and resource limits live
in the common base; overlays only carry the real differences between testing,
staging and production.

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

Nach dem Merge ergänzt Flux den Cluster-seitigen Reconcile-Loop: Der Cluster
holt den freigegebenen Zustand aus Git oder OCI, wendet Kustomize- oder
Helm-Konfiguration an und zeigt Status, Events und Health-Informationen für
den Betrieb.

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

After merge, Flux adds the cluster-side reconciliation loop: the cluster pulls
the approved state from Git or OCI sources, applies Kustomize or Helm
configuration and exposes status, events and health information for operations.

GitHub Actions validates whether a change may be delivered. Flux validates
continuously whether the cluster still matches the approved Git state. A single
`kubectl apply` would not answer that drift question later.

Secrets are intentionally outside the blueprints and overlays. Git describes
the platform contract and non-sensitive references; a protected secret store
manages passwords, certificates and tokens.

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

- `kubernetes/blueprint-templates/platform-baseline/` definiert
  Plattform-Guardrails.
- `kubernetes/blueprint-templates/web-workload/` definiert den
  Workload-Vertrag.
- `kubernetes/environments/` zeigt kosten- und verfügbarkeitsbewusste
  Ausprägungen.
- `docs/monitoring.md` beschreibt Signale und das Observability-Zielbild.

## Repository Mapping

- `kubernetes/blueprint-templates/platform-baseline/` defines platform
  guardrails.
- `kubernetes/blueprint-templates/web-workload/` defines the workload
  contract.
- `kubernetes/environments/` contains cost- and availability-aware variants.
- `docs/monitoring.md` describes signals and the observability target model.
