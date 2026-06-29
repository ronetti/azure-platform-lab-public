# Availability Engineering

## Ziel

Availability Engineering übersetzt Verfügbarkeit in messbare Ziele,
betriebliche Entscheidungen und kontrollierte Änderungsprozesse. Es geht nicht
nur darum, Infrastruktur hochverfügbar zu bauen, sondern Verfügbarkeit im
Alltag steuerbar zu machen.

## Purpose

Availability engineering turns availability into measurable objectives,
operational decisions and controlled change processes. It is not only about
building highly available infrastructure, but about making availability
manageable in daily operations.

## Drei Bausteine

Die drei zentralen Bausteine sind:

- `SLI`: Service Level Indicator. Was wird gemessen?
- `SLO`: Service Level Objective. Welches Ziel wird angestrebt?
- `SLA`: Service Level Agreement. Welche Zusage gilt gegenüber Kunden oder
  Stakeholdern?

Das Error Budget verbindet diese Bausteine mit Delivery-Entscheidungen. Wenn
das Budget gesund ist, kann ein Team schneller liefern. Wenn das Budget
verbraucht ist, werden Stabilisierung, Ursachenanalyse und präventive Maßnahmen
wichtiger als neue Features.

## Three Building Blocks

The three central building blocks are:

- `SLI`: Service Level Indicator. What is measured?
- `SLO`: Service Level Objective. Which target is expected?
- `SLA`: Service Level Agreement. Which commitment applies to customers or
  stakeholders?

The error budget connects these building blocks with delivery decisions. If the
budget is healthy, a team can ship faster. If the budget is consumed,
stabilization, root-cause analysis and preventive work become more important
than new features.

## Beispielhafte SLIs

Für eine Azure-Plattform können typische SLIs sein:

- Verfügbarkeit des Application Gateway Listeners
- Anteil erfolgreicher Requests
- 5xx-Fehlerrate
- Backend-Health des Application Gateway
- WAF-Blockrate und auffällige WAF-Matches
- Latenz am Edge
- VM- oder Pod-Verfügbarkeit
- Storage-Erreichbarkeit für stateful Workloads
- erfolgreiche Azure VM Backups nach definierter Policy
- Alter des letzten erfolgreichen Recovery Points
- erfolgreiche Pipeline-Deployments
- Zeit bis zur Reaktion auf kritische Alerts
- gemessene Restore-Dauer und Datenverlustfenster für stateful Solutions

## Example SLIs

Typical SLIs for an Azure platform can include:

- availability of the Application Gateway listener
- ratio of successful requests
- 5xx error rate
- Application Gateway backend health
- WAF block rate and suspicious WAF matches
- edge latency
- VM or pod availability
- storage reachability for stateful workloads
- successful Azure VM backups according to the defined policy
- age of the last successful recovery point
- successful pipeline deployments
- time to react to critical alerts
- measured restore duration and data-loss window for stateful solutions

## SLO- und Error-Budget-Modell

Ein SLO sollte so formuliert sein, dass es technisch messbar und betrieblich
nützlich ist. Beispiel:

```text
99.5 Prozent erfolgreiche Requests pro Kalendermonat
bei gleichzeitig definierten Latenz- und Backend-Health-Grenzen.
```

Das Error Budget ist die erlaubte Abweichung vom Ziel. Es hilft bei der Frage,
ob eine Änderung sofort umgesetzt werden kann oder ob zuerst Stabilität
verbessert werden muss.

Für Restore-Abläufe sind RTO und RPO besonders wichtig:

- `RTO`: Wie lange darf die Wiederherstellung dauern?
- `RPO`: Wie viel Datenverlust ist maximal akzeptabel?

Diese Werte sollten nicht geraten werden. In einer praktischen Umsetzung mit
einem Python-basierten Restore-Modul konnten sie aus Logs und gemessenen
Abläufen abgeleitet werden. Das macht Recovery-Ziele realistischer und zeigt
auch, wo der Ablauf noch zu langsam oder zu riskant ist.

Bei VM-basierten Workloads gehört dazu auch die Backup-Policy: Wie oft wird
gesichert, wie lange werden Recovery Points gehalten und wann war die letzte
erfolgreiche Sicherung? Die Policy beeinflusst das RPO, der gemessene
Restore-Ablauf beeinflusst das RTO. Beides muss zusammen betrachtet werden.

## SLO and Error Budget Model

An SLO should be technically measurable and operationally useful. Example:

```text
99.5 percent successful requests per calendar month
while also respecting defined latency and backend-health thresholds.
```

The error budget is the allowed deviation from the target. It helps determine
whether a change can be shipped immediately or whether stability must be
improved first.

For restore flows, RTO and RPO are especially important:

- `RTO`: How long may recovery take?
- `RPO`: How much data loss is acceptable at most?

These values should not be guessed. In a practical implementation with a
Python-based restore module, they could be derived from logs and measured
restore runs. That makes recovery goals more realistic and also shows where the
flow is still too slow or too risky.

For VM-based workloads, the backup policy is part of that discussion: how often
backups run, how long recovery points are retained and when the last successful
backup happened. The policy influences RPO, the measured restore flow
influences RTO. Both have to be looked at together.

## Dynamische Skalierfähigkeit

Skalierfähigkeit sollte nicht bedeuten, Terraform-Code für jede neue
Anforderung anzufassen. Routineänderungen gehören in Konfigurationsdateien:

- neue Subnetze
- neue Solutions oder Mandanten
- neue VMs
- neue private IPs
- neue Firewall-Regeln
- neue WAF Custom Rules oder Exclusions
- neue Application-Gateway-Backends
- neue AKS Node Pools

Terraform-Module und Root-Stacks bilden die generische Logik. YAML-Dateien
beschreiben die gewünschte Plattformform. Reviews und Pipelines prüfen, ob die
Änderung sicher, nachvollziehbar und genehmigt ist.

## Dynamic Scalability

Scalability should not mean changing Terraform code for every new requirement.
Routine changes belong in configuration files:

- new subnets
- new solutions or tenants
- new VMs
- new private IPs
- new firewall rules
- new WAF custom rules or exclusions
- new Application Gateway backends
- new AKS node pools

Terraform modules and root stacks contain the generic logic. YAML files
describe the desired platform shape. Reviews and pipelines check whether the
change is safe, understandable later and approved.

## Dokumentation, Reviews und Approvals

Ein belastbares Plattformmodell braucht nicht nur Code, sondern auch
Dokumentation und Governance:

- Wiki oder Doku-Repository für Architekturentscheidungen
- README-Dateien pro Modul, Stack oder Betriebsbereich
- versionierte YAML-, Terraform- und Dokumentationsdateien statt versteckter
  Änderungen im Portal
- Pull Requests für Infrastrukturänderungen
- Pipeline-Validierung für Terraform, YAML und Kubernetes-Manifeste
- Approvals für produktionsnahe Änderungen
- Changelog-Einträge für relevante Plattformänderungen
- nachvollziehbare Review-Historie
- Runbooks für wiederkehrende Betriebsfälle

Diese Struktur macht Wissen teilbar. Entscheidungen bleiben nicht nur im Kopf
einzelner Personen, sondern können später gelesen, geprüft und übergeben
werden.

## Documentation, Reviews and Approvals

A reliable platform model needs not only code, but also documentation and
governance:

- wiki or documentation repository for architecture decisions
- README files per module, stack or operational area
- versioned YAML, Terraform and documentation files instead of hidden portal
  changes
- pull requests for infrastructure changes
- pipeline validation for Terraform, YAML and Kubernetes manifests
- approvals for production-like changes
- changelog entries for relevant platform changes
- review history that can be understood later
- runbooks for recurring operational cases

This structure makes knowledge easier to share. Decisions do not stay only in
one person's head; they can be read, checked and handed over later.

## Repo-Bezug

- `terraform/stacks/*/config/testing.yaml` zeigt YAML-getriebene
  Plattformkonfiguration.
- `.github/workflows/validate.yml` zeigt Pipeline-Validierung.
- `docs/change-governance.md` beschreibt nachvollziehbare Änderungen, Reviews,
  Approvals und Changelogs.
- `docs/monitoring.md` beschreibt Signale für SLIs.
- `docs/runbook.md` beschreibt Betriebsreaktion und Nachbereitung.
- `docs/restore-automation-pattern.md` beschreibt Azure VM Backup Policies,
  gemessene Restore-Abläufe, RTO/RPO und Drift-Vermeidung.
- `docs/application-gateway-waf-pattern.md` zeigt Edge-Logging und
  Team-Alerting.

## Repository Mapping

- `terraform/stacks/*/config/testing.yaml` shows YAML-driven platform
  configuration.
- `.github/workflows/validate.yml` shows pipeline validation.
- `docs/change-governance.md` describes understandable changes, reviews,
  approvals and changelogs.
- `docs/monitoring.md` describes signals for SLIs.
- `docs/runbook.md` describes operational response and follow-up.
- `docs/restore-automation-pattern.md` describes Azure VM Backup policies,
  measured restore flows, RTO/RPO and drift avoidance.
- `docs/application-gateway-waf-pattern.md` shows edge logging and team
  alerting.
