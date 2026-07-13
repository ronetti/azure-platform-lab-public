# Application Gateway und WAF / Application Gateway and WAF

## Ziel

Dieses Pattern beschreibt eine zentrale Edge-Schicht für mehrere webnahe
Workload-Instanzen. Ziel ist der Schutz vor direktem Internetzugriff bei
gleichzeitig nachvollziehbarem und betriebssicherem Routing.

## Purpose

This pattern describes a central edge layer for multiple web-facing workload
instances. The goal is to protect workloads from direct internet exposure while
keeping routing predictable and operationally safe.

## Designziele

- Ingress über Application Gateway und WAF zentralisieren
- direkten Public-IP-Zugriff auf Backend-VMs vermeiden
- Host-Header-basiertes Routing erhalten, wenn Workloads ihren externen
  Hostnamen benötigen
- Session-Affinity für stateful Backends unterstützen
- zuerst eine robuste Implementierung wählen, bevor komplexes
  identitätsbasiertes Routing ergänzt wird

## Design Goals

- centralize ingress through Application Gateway and WAF
- avoid direct public access to backend virtual machines
- preserve host-header based routing where workloads depend on their external
  hostname
- support session affinity for stateful backends
- keep the first implementation robust before adding complex identity-aware
  routing

## Bevorzugtes Startmodell

```text
solution-001.platform.example -> Application Gateway/WAF -> backend pool 001
solution-002.platform.example -> Application Gateway/WAF -> backend pool 002
solution-003.platform.example -> Application Gateway/WAF -> backend pool 003
```

Jede Solution oder jeder Mandant erhält einen eigenen Hostnamen. Das
Application Gateway routet anhand des Host-Headers in den passenden Backend
Pool.

Das ist absichtlich einfach gehalten: Die Routingentscheidung bleibt sichtbar,
testbar und gut erklärbar.

## Umsetzungsstand

In diesem Repository ist der erste Vorschlag als Lab-Pattern modelliert: ein
Application Gateway als zentrale Edge-Schicht mit WAF, eigenem Hostnamen pro
Solution oder Workload und klar getrennten Listenern, Backends und Probe-Pfaden
in YAML. Der vollständige produktive Kundencode ist hier bewusst nicht
enthalten.

Der zweite Vorschlag, eine gemeinsame URL mit zusätzlicher Routing-Logik, ist
bewusst als nächster Ausbauschritt beschrieben. Ich würde ihn erst angehen,
wenn der einfache Hostname-pro-Solution-Ansatz stabil läuft und die
Fehlerfälle ausreichend getestet sind.

## Preferred Starting Model

Each solution or tenant receives its own hostname. Application Gateway routes
requests by host header to the matching backend pool.

This keeps the routing decision visible, testable and easy to reason about.

## Implementation Status

This repository models the first proposal as a lab pattern: an Application
Gateway as the central edge layer with WAF, one hostname per solution or
workload, and clearly separated listeners, backends and probe paths in YAML.
The full production customer implementation is intentionally not included here.

The second proposal, a shared URL with additional routing logic, is documented
as the next possible step. I would only move there once the simpler
hostname-per-solution approach is stable and the failure cases have been tested
well enough.

## Stateful-Backend-Betrachtung

Nicht jeder Enterprise-Workload ist eine stateless Web-App. Manche Systeme
halten Sessions, Laufzeitdaten oder lokale Service-Annahmen, wodurch
transparentes Load Balancing riskant werden kann.

Für diese Workloads sollte das Edge-Design Folgendes berücksichtigen:

- Host-Header-Erhaltung
- Cookie-basierte Session-Affinity, wo nötig
- Health Probes, die echte Applikationsbereitschaft abbilden
- Validierung in einer Testumgebung vor Hochverfügbarkeitsänderungen
- explizite Support-Grenzen, wenn die Applikation Vendor-Limitierungen hat

## Stateful Backend Considerations

Some enterprise workloads are not stateless web apps. They may keep sessions,
runtime state or local service assumptions that make transparent load balancing
risky.

For these workloads the edge design should consider:

- host-header preservation
- cookie-based session affinity where needed
- backend health probes that reflect real application readiness
- validation in a test environment before high-availability changes
- explicit support boundaries where the application vendor has limitations

## Optionale Interne Hochverfügbarkeit

Das zentrale Application Gateway wird nicht pauschal pro Workload kopiert.
Wenn eine stateful Applikation mehrere interne Knoten benötigt, aber selbst
keine unterstützte Lastverteilung bietet, kann eine interne Layer-7-Komponente
mit Cookie- oder Header-Affinity geprüft werden. Diese zusätzliche Schicht ist
nur sinnvoll, wenn eine konkrete Hochverfügbarkeitsanforderung ihre Kosten und
Betriebskomplexität rechtfertigt.

Vor einer Umsetzung müssen Vendor-Support, Session-Verhalten, Failover und
Health Checks in einer geeigneten Testumgebung validiert werden. Ein reiner
Layer-4-Load-Balancer darf nicht als ausreichend angenommen werden, wenn die
Applikation sessionspezifisches Routing benötigt. Diese optionale interne
Schicht ist im Repository bewusst nicht implementiert.

## Optional Internal High Availability

The central Application Gateway is not duplicated for every workload by
default. If a stateful application needs multiple internal nodes but offers no
supported native load balancing, an internal Layer 7 component with cookie or
header affinity can be evaluated. This additional layer is justified only by a
specific availability requirement that outweighs its cost and operational
complexity.

Vendor support, session behavior, failover and health checks must be validated
in a suitable test environment first. A Layer 4 load balancer should not be
assumed sufficient where the application requires session-aware routing. This
optional internal layer is intentionally not implemented in the repository.

## Logging und Reaktion

Ein Application Gateway/WAF ist erst dann betrieblich brauchbar, wenn seine
Signale im Plattformbetrieb ankommen. In diesem Pattern werden Diagnostic Logs
und Metriken an Log Analytics angebunden. Darauf aufbauend können Alerts oder
KQL-Abfragen relevante Ereignisse erkennen, zum Beispiel:

- WAF-Blocks oder auffällige WAF-Matches
- erhöhte 4xx- oder 5xx-Raten
- Backend-Unhealthy-Status
- ungewöhnliche Latenzen
- fehlgeschlagene Health Probes

Für Team-Reaktionen kann ein leichtgewichtiger Integrationspfad genutzt werden:

```text
Application Gateway / WAF
        |
        v
Diagnostic Settings
        |
        v
Log Analytics
        |
        v
Alert Rule / KQL
        |
        v
Azure Function
        |
        v
Teams Webhook
```

Die Azure Function kapselt die Benachrichtigungslogik. Dadurch bleibt die
Alarmierung austauschbar, und Teams erhält handlungsrelevante Meldungen statt
roher Logdaten.

## Logging and Response

An Application Gateway/WAF becomes operationally useful only when its signals
reach the platform team. In this pattern, diagnostic logs and metrics are sent
to Log Analytics. Alert rules or KQL queries can then detect relevant events,
for example:

- WAF blocks or suspicious WAF matches
- increased 4xx or 5xx rates
- unhealthy backend status
- unusual latency
- failed health probes

A lightweight team notification path can be implemented through an Azure
Function and a Teams webhook:

```text
Application Gateway / WAF
        |
        v
Diagnostic Settings
        |
        v
Log Analytics
        |
        v
Alert Rule / KQL
        |
        v
Azure Function
        |
        v
Teams Webhook
```

The Azure Function encapsulates notification logic. This keeps alerting
replaceable and gives the team actionable messages instead of raw log data.

## WAF-Konfiguration Als YAML-Schichten

WAF-Konfiguration sollte im Review sichtbar bleiben und später wiederholbar
sein. Ein praktikables Modell ist die Trennung in mehrere YAML-Schichten:

- `custom-rules.yaml`: eigene Allow-, Block- oder Match-Regeln
- `exclusions.yaml`: gezielte Ausnahmen für bekannte legitime Requests
- `managed-rule-overrides.yaml`: Anpassungen an Managed Rule Sets, zum Beispiel
  deaktivierte oder geänderte Regelgruppen

Falls eine Umgebung zusätzlich globale Policy Settings trennt, kann diese
Schicht auch als `policy-settings.yaml` geführt werden. Entscheidend ist die
Trennung der Verantwortlichkeiten: eigene Regeln, Ausnahmen und Managed-Rule-
Anpassungen werden getrennt geprüft, aber gemeinsam in eine WAF Policy
zusammengeführt.

## WAF Configuration as YAML Layers

WAF configuration should stay visible in review and be repeatable later. A
practical model is to split it into multiple YAML layers:

- `custom-rules.yaml`: custom allow, block or match rules
- `exclusions.yaml`: targeted exceptions for known legitimate requests
- `managed-rule-overrides.yaml`: adjustments to managed rule sets, such as
  disabled or modified rule groups

If an environment separates global policy settings as well, that layer can be
represented as `policy-settings.yaml`. The key point is responsibility
separation: custom rules, exclusions and managed-rule adjustments are checked
separately but composed into one WAF policy.

## Vorschlag 2: Eine Gemeinsame URL

Eine gemeinsame URL kann aus Anwendersicht attraktiv sein, benötigt aber häufig
zusätzliche Routing-Intelligenz:

- mandantenbezogene Identitätsauflösung
- Token- oder Claim-Auswertung
- Middleware oder eigene Routing-Services
- sehr sorgfältige Header-, Cookie- und Pfadbehandlung
- deutlich umfangreichere Fehlerfalltests

Das ist als spätere Ausbaustufe geplant, hat aber mehr Implementierungs- und
Betriebsrisiko als Host-Header-basiertes Routing. Deshalb steht vorher der
einfachere erste Schritt.

## Proposal 2: Single Shared URL

A single shared URL can be attractive for user experience, but it often requires
additional routing intelligence:

- identity-aware tenant resolution
- token or claim inspection
- middleware or custom routing services
- careful header, cookie and path handling
- more extensive failure-mode testing

This is planned as a later extension, but it carries higher implementation and
operational risk than host-header based routing. That is why the simpler first
step comes before it.

## Entscheidungsmatrix

| Kriterium | Hostname pro Solution | Gemeinsame URL |
| --- | --- | --- |
| Implementierungsaufwand | niedriger | höher |
| Routing-Transparenz | hoch | mittel |
| Session-Risiko | niedriger | höher |
| Identity-Integration | optional | meist erforderlich |
| User Experience | weniger einheitlich | einheitlicher |
| Betriebskomplexität | niedriger | höher |

## Decision Matrix

| Criterion | Hostname per solution | Single shared URL |
| --- | --- | --- |
| Implementation effort | lower | higher |
| Routing transparency | high | medium |
| Session risk | lower | higher |
| Identity integration | optional | usually required |
| User experience | less uniform | more uniform |
| Operational complexity | lower | higher |

## Repo-Bezug

- `application_gateway` in
  `environments/nonproduction/nonproduction.yaml` modelliert Listener,
  Backends und Probe-Pfade.
- `terraform/stacks/application-gateway/remote-state.tf` konsumiert den
  Network Stack.
- `terraform/stacks/shared-services` stellt Monitoring und Log Analytics als
  gemeinsame Plattformbasis dar.
- `docs/security-considerations.md` dokumentiert die größere Security-Absicht.

## Repository Mapping

- `application_gateway` in
  `environments/nonproduction/nonproduction.yaml` models listeners, backends
  and probe paths.
- `terraform/stacks/application-gateway/remote-state.tf` consumes the network
  stack.
- `terraform/stacks/shared-services` provides monitoring and Log Analytics as
  shared platform foundations.
- `docs/security-considerations.md` documents the broader security intent.
