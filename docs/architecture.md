# Architektur / Architecture

## Zielbild

Das Ziel ist eine Azure-Plattformbasis für Enterprise-Workloads, die
wiederholbar, im Review verständlich und modular erweiterbar ist. Die Plattform soll nicht
nur Ressourcen erzeugen, sondern auch den späteren Betrieb abbilden: Netzwerk,
Security, Edge, Monitoring, Storage, Compute, Remote State,
Umgebungskonfiguration und Kubernetes-Zielstrukturen.

Mir ist dabei wichtig, dass Architektur nicht als Schaubild stehen bleibt. Die
entscheidenden Fragen sind: Wo liegt die Source of Truth? Welche Grenze braucht
einen eigenen State? Welche Änderung ist Konfiguration und welche verändert
das Betriebsmodell? Wie erkennt ein Team später, ob der Ist-Zustand noch zum
gewünschten Zustand passt?

## Target State

The goal is an Azure platform baseline for enterprise workloads that can be
reproduced, checked in review and extended modularly. The platform should not only
create resources, but also model an operating foundation: networking, security,
edge, monitoring, storage, compute, remote state, environment configuration and
Kubernetes target structures.

Architecture should not stop at a diagram. The important questions are where
the source of truth lives, which boundary needs its own state, which change is
configuration and which one changes the operating model, and how a team later
checks whether actual state still matches desired state.

## Übergeordnete Landing-Zone-Ebene

Die in diesem Repository sichtbaren Nonproduction- und
Production-Subscriptions bilden Workload-Grenzen. In einer vollständigen Azure
Landing Zone liegen darüber Management Groups, tenantweite Policy-Regeln,
Platform-Subscriptions und ein kontrollierter Subscription-Vending-Prozess.

Diese übergeordnete Ebene ist hier als
[Landing-Zone-Denkweg](landing-zone-thinking.md) dokumentiert, aber noch nicht
implementiert. Management Groups werden dabei aus gemeinsamen Governance-,
Compliance- und Konnektivitätsanforderungen abgeleitet, nicht aus den Namen
Testing, Staging und Production.

## Higher-Level Landing Zone

The nonproduction and production subscriptions visible in this repository
represent workload boundaries. A complete Azure Landing Zone adds management
groups, tenant-wide policy rules, platform subscriptions and controlled
subscription vending above those boundaries.

This higher level is documented as a
[Landing Zone reasoning path](landing-zone-thinking.md), but it is not yet
implemented. Management groups are derived from shared governance, compliance
and connectivity requirements rather than from the names testing, staging and
production.

## Logische Architektur

```text
Environment-Auswahl
  -var environment=nonproduction|production
        |
        v
YAML-Konfiguration
  environments/<environment>/<environment>.yaml
        |
        v
Root-Stack
  locals + yamldecode
  remote-state.tf
  main.tf
  outputs.tf
        |
        v
Remote-State-Outputs
        |
        v
Abhängiger Stack
```

Das Repository trennt zwei Ebenen:

- `terraform/modules/` enthält unabhängig geschriebene Demo-Bausteine und
  keine übernommenen Originalmodule.
- `terraform/stacks/` modelliert deploybare Root-Module mit eigenem
  State-Key und klaren Übergabepunkten.
- `environments/` konsolidiert Konfiguration und Backend-Beispiele für
  diese kompakte Portfolio-Darstellung.

`environments/` zeigt das Betriebsmodell in zwei sichtbaren Grenzen: Testing
und Staging teilen `nonproduction/nonproduction.yaml`; Production nutzt
`production/production.yaml` allein.
Blue-Green ist eine Deployment-Strategie und keine zusätzliche Umgebung.
Die Entscheidung verbindet Kostenbewusstsein mit Sicherheitsgrenze: Testing
und Staging teilen teure Plattformbasis, Production bleibt eine eigene
Subscription-, State-, Identity-, Secret-, Netzwerk- und Betriebsdatengrenze.

Das zugrundeliegende Plattformmodell führt Network, Firewall, Application
Gateway, Compute und weitere Bereiche als eigenständige Repositories. Jedes
besitzt eigene Multi-Environment-YAMLs, Pipeline, Security-Assets, README und
State-Grenze. In diesem Lab liegen die Repräsentanten zusammen, damit die
Architektur an einem Ort geprüft werden kann.

Ich habe mich bewusst gegen ein großes gemeinsames Terraform-Projekt
entschieden. Es wäre am Anfang vielleicht einfacher zu überblicken, würde aber
später zu viele Verantwortungen, Abhängigkeiten und State-Änderungen in einem
Ort bündeln. Wenn ich eine VM-Konfiguration ändere, möchte ich nicht
gleichzeitig Netzwerk, Firewall oder Kubernetes neu planen müssen. Getrennte
Root-Stacks verkleinern den Fehlerbereich, machen Reviews gezielter und geben
Teams eine klare Ownership-Grenze. Jeder Bereich veröffentlicht nur die
benötigten Outputs und nutzt andere Plattformteile über definierte
Übergabepunkte.

Dieselbe Logik gilt für Kubernetes. Ich habe mich bewusst gegen kopierte
YAML-Dateien pro Umgebung entschieden. Gemeinsame Plattformstandards wie
Security Defaults, Labels, Network Policies oder Resource Limits sollen nur an
einer Stelle gepflegt werden. Kustomize-Bases bilden deshalb die gemeinsame
Plattformbasis, Overlays beschreiben nur die echten Unterschiede zwischen
Testing, Staging und Production. Dadurch bleiben Guardrails konsistent, und
Änderungen sind zentral nachvollziehbar statt über mehrere fast gleiche Dateien
verteilt.

Terraform State ist dabei eine zentral betriebene Plattformfähigkeit je
Subscription- und Environment-Grenze. Teams oder Produkte erhalten eigene
Blob-Container und ausschließlich die dafür benötigten Entra-RBAC-Rechte.
Innerhalb des Containers trennt ein eindeutiger Key die States der
Fach-Repositories. Azure Blob Locking schützt schreibende State-Operationen vor
gleichzeitigen Änderungen. Production und Nonproduction verwenden getrennte
State-Storage-Grenzen.

Nicht jeder Stack ist in diesem Repository gleich tief implementiert. `network`
und `shared-services` zeigen konkrete Basisressourcen. Andere Stacks zeigen
bewusst die Struktur, die Konfigurationsform und die Betriebsgrenze. Das
ist kein Platzhalter ohne Inhalt: Genau diese Übergaben entscheiden später, ob
Teams unabhängig arbeiten können, ob Remote State sauber konsumiert wird und
ob eine Änderung vor dem Apply verständlich bleibt. Wo eine reale Ressource
noch nicht provisioniert wird, ist das kenntlich gemacht.

## Logical Architecture

```text
Environment selection
  -var environment=nonproduction|production
        |
        v
YAML configuration
  environments/<environment>/<environment>.yaml
        |
        v
Root stack
  locals + yamldecode
  remote-state.tf
  main.tf
  outputs.tf
        |
        v
Remote-state outputs
        |
        v
Dependent stack
```

The repository keeps two layers separate:

- `terraform/modules/` contains independently written demonstration building
  blocks, not original non-public module code.
- `terraform/stacks/` models deployable root modules with independent state
  keys and clear handover points.
- `environments/` consolidates configuration and backend examples for this
  compact portfolio representation.

In addition, `environments/` keeps the operating model in two visible
boundaries. Testing and staging share `nonproduction/nonproduction.yaml`;
production uses `production/production.yaml`.
Blue-green is a delivery strategy, not another environment.
This decision balances cost and isolation: testing and staging share expensive
platform baseline services, while production keeps its own subscription,
state, identity, secret, network and operational-data boundary.

The underlying platform model keeps network, firewall, Application Gateway,
compute and other domains in separate repositories. Each repository owns
multi-environment YAML, pipeline, security assets, README and a state boundary.
Their representatives live together in this lab so the architecture can be
reviewed in one place.

I deliberately avoid one large shared Terraform project. It may look simpler
at the beginning, but it collects too many responsibilities, dependencies and
state changes in one place. A VM configuration change should not require
planning network, firewall or Kubernetes changes at the same time. Separate
root stacks reduce the blast radius, make reviews more focused and give teams
a clear ownership boundary. Each domain publishes only the outputs others need
and consumes platform dependencies through defined handover points.

The same decision applies to Kubernetes. I deliberately avoid copied YAML files
per environment. Shared platform standards such as security defaults, labels,
NetworkPolicies or resource limits should be maintained in one place.
Kustomize bases define the common platform baseline, while overlays describe
only the real differences between testing, staging and production. This keeps
guardrails consistent and makes changes traceable instead of spreading them
across several almost identical files.

Terraform state is operated as a central platform capability within each
subscription and environment boundary. Teams or products receive dedicated
blob containers and only the Entra RBAC permissions required for their own
container. Unique keys separate domain-repository states inside a container,
while Azure blob locking protects write operations from concurrent changes.
Production and nonproduction use separate state-storage boundaries.

Not every stack is implemented at the same depth in this repository. `network`
and `shared-services` show concrete baseline resources. Other stacks
intentionally show the structure, configuration shape and operational
responsibility boundary. That is not empty placeholder work: these handovers
decide whether teams can work independently, whether remote state is consumed
cleanly and whether a change remains understandable before apply. Where a real
resource is not provisioned yet, the repository says so explicitly.

## Stack-Abhängigkeiten

```text
network
  -> routing
  -> firewall
  -> application-gateway
  -> compute
  -> aks

shared-services
  -> compute
  -> aks

compute
  -> configuration-management
```

Der Abhängigkeitsfluss trennt gemeinsame Grundlagen von konsumierenden
Workload- oder Plattform-Stacks. Downstream-Stacks konsumieren nur
veröffentlichte Outputs, nicht die interne Implementierung der Upstream-Stacks.
`configuration-management` hängt bewusst hinter `compute`: Terraform
veröffentlicht VM-Metadaten, und Ansible-Pipelines nutzen diese Metadaten als
Inventory-Quelle.

Für Kubernetes ergänzt Flux den Abhängigkeitsfluss nach dem AKS-Intent. Das
ist für mich die saubere Grenze: AKS beschreibt die Plattformbasis, Flux
verbindet den freigegebenen Git-Zustand mit dem laufenden Cluster.

```text
aks intent
  -> kubernetes blueprints
  -> optional inference workload blueprint
  -> flux sources
  -> flux kustomizations / helm releases
  -> reconciled cluster state
```

Damit bleibt Git die Source of Truth. CI prüft den gewünschten Zustand vor dem
Merge; Flux gleicht danach den freigegebenen Zustand im Cluster ab. Wenn etwas
nicht passt, muss es über Status, Events, Health oder Drift sichtbar werden.

AI-Workloads hängen an dieser Grenze bewusst hinter dem AKS-Intent. Der
AKS-Intent modelliert GPU-Kapazität, Taints, Labels, Kosten- und
Approval-Grenzen. Der Inference-Blueprint beschreibt erst danach den
Kubernetes-Workload-Modell. So bleibt klar, ob ein Problem aus Cluster- und
Kapazitätsplanung, aus dem Workload-Blueprint oder aus dem GitOps-Abgleich
kommt.

## Stack Dependency Flow

The dependency flow keeps shared foundations separate from consuming workload
or platform stacks. Downstream stacks consume only published outputs, not the
internal implementation of upstream stacks.
`configuration-management` is deliberately downstream of `compute`: Terraform
publishes VM metadata, and Ansible pipelines consume that metadata as their
inventory source.

For Kubernetes, Flux extends the dependency flow after AKS intent:

```text
aks intent
  -> kubernetes blueprints
  -> optional inference workload blueprint
  -> flux sources
  -> flux kustomizations / helm releases
  -> reconciled cluster state
```

Git remains the source of truth. CI validates desired state before merge; Flux
then reconciles the approved state in the cluster and exposes status, events,
health and drift.

## Modulgrenzen

Die Module sind nach Verantwortlichkeiten getrennt:

- `network`: virtuelle Netzwerke, Subnetze und Adressräume
- `routing`: Route Tables und Routing-Muster
- `firewall`: Firewall-Integration und zentrale Egress-Kontrolle
- `application-gateway`: Edge, WAF, Listener und Backend Pools
- `monitoring`: Log Analytics, Diagnostics und Metriken
- `key-vault`: Secret- und Zertifikatsbasis
- `storage`: Plattform-Storage, zum Beispiel Terraform State, Artefakte oder
  Workload-Daten
- `compute`: VM- oder Agent-Pool-nahe Bausteine
- `aks`: Kubernetes-Zielstruktur
- `configuration-management`: Ansible-Inventory auf Basis von Terraform Outputs

## Module Boundaries

The modules are separated by responsibility:

- `network`: virtual networks, subnets and address spaces
- `routing`: route tables and routing patterns
- `firewall`: firewall integration and central egress control
- `application-gateway`: edge, WAF, listeners and backend pools
- `monitoring`: Log Analytics, diagnostics and metrics
- `key-vault`: secret and certificate foundation
- `storage`: platform storage, for example Terraform state, artifacts or
  workload data
- `compute`: VM or agent-pool-like building blocks
- `aks`: Kubernetes target structure
- `configuration-management`: Ansible inventory based on Terraform outputs

## Konfigurationsmodell

Routinemäßige Plattformänderungen sollen Datenänderungen sein, keine
Terraform-Codeänderungen. Beispiele:

- `network.subnets` in `environments/nonproduction/nonproduction.yaml` ergänzen
- Route unter `routing.route_tables` ergänzen
- Firewall-Regel unter `firewall.network_rule_collections` ergänzen
- VM unter `compute.virtual_machines` ergänzen
- Host-Gruppen oder Ansible-Guardrails unter `configuration_management` ergänzen
- Backend unter `application_gateway.backends` ergänzen
- Node Pool unter `aks.cluster.node_pools` ergänzen

## Configuration Model

Routine platform changes should be data changes, not Terraform code changes.
Examples:

- add a subnet below `network.subnets` in
  `environments/nonproduction/nonproduction.yaml`
- add a route below `routing.route_tables`
- add a firewall rule below `firewall.network_rule_collections`
- add a VM below `compute.virtual_machines`
- add host groups or Ansible guardrails below `configuration_management`
- add a backend below `application_gateway.backends`
- add a node pool below `aks.cluster.node_pools`

## Remote-State-Outputs

Upstream-Stacks veröffentlichen stabile Outputs. Downstream-Stacks konsumieren
nur diese Outputs über `terraform_remote_state`.

Beispiele:

- `network` veröffentlicht `virtual_network_id`, `subnet_ids` und
  `resource_group_name`.
- `shared-services` veröffentlicht Referenzen auf Monitoring, Key Vault und
  Storage.
- `compute`, `aks`, `routing`, `firewall` und `application-gateway`
  nutzen diese Outputs, ohne in die Implementierung anderer Stacks zu
  greifen.
- `configuration-management` konsumiert Compute-Outputs und macht daraus ein
  Ansible-Inventory für nachgelagerte Konfiguration.

## Remote-State Outputs

Upstream stacks expose stable outputs. Downstream stacks consume only those
outputs through `terraform_remote_state`.

Examples:

- `network` exposes `virtual_network_id`, `subnet_ids` and
  `resource_group_name`.
- `shared-services` exposes monitoring, Key Vault and storage references.
- `compute`, `aks`, `routing`, `firewall` and `application-gateway` consume
  these outputs rather than reaching into another stack's implementation.
- `configuration-management` consumes compute outputs and turns them into an
  Ansible inventory for downstream configuration.

## Betriebsmodell

Eine Plattform ist erst dann brauchbar, wenn Betrieb mitgedacht ist.
Monitoring, Diagnoseeinstellungen, Runbooks, Rollback-Gedanken,
Kostenbewusstsein, Security-Grenzen und klare Ownership gehören deshalb zur
Architektur.

Runbooks sind deshalb mehr als Dokumentation. Sie zeigen im Fehlerfall den
nächsten sinnvollen Schritt: Kontext prüfen, Schicht eingrenzen, Signale
auswerten, Rückweg bewerten und erst dann handeln. Damit wird sichtbar,
welche Betriebsabläufe später gezielt automatisiert werden können.

Monitoring und Logs sind dabei bewusst Plattformbasis und keine spätere
Einzelaufgabe jedes Workload-Teams. Teams können eigene fachliche Metriken,
Dashboards und Alerts ergänzen, aber Diagnostic Settings, zentrale Log-Ziele,
Alert-Grundmuster und gemeinsame Begriffe für Verfügbarkeit, Fehler, Latenz
und Sättigung müssen aus der Plattform kommen. Sonst entstehen getrennte
Einzellösungen, die im Fehlerfall zuerst die Frage offenlassen, wo die
relevanten Daten überhaupt liegen.

## Operating Model

A platform is only useful when operations are included from the beginning.
Monitoring, diagnostic settings, runbooks, rollback thinking, cost awareness,
security boundaries and clear ownership are therefore part of the architecture.

Runbooks are more than documentation. During an incident they show the next
useful step: check context, identify the affected layer, evaluate signals,
assess the rollback path and only then act. That also shows which operational
steps can later be automated safely.

Monitoring and logs are deliberately part of the platform baseline, not a late
task for each workload team. Teams can add domain-specific metrics, dashboards
and alerts, while diagnostic settings, central log targets, alerting patterns
and shared language for availability, errors, latency and saturation come from
the platform. Without that baseline, incident response starts by searching for
the relevant data.

## Anonymisierung

Das Repository abstrahiert die Muster bewusst. Kundennamen, produktive
IP-Adressräume, Secrets, Domains und interne Projekthistorie werden nicht
veröffentlicht.

## Sanitization

The repository intentionally abstracts the patterns. Customer names, production
IP ranges, secrets, domains and internal delivery history are not published.
