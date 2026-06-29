# Platform Engineering Experience / Plattform-Erfahrung

## Deutsch

Dieses Dokument beschreibt die Plattformmuster, die dieses Repository als
bereinigtes Beispiel abbildet. Es ist kein 1:1-Abbild einer produktiven
Kundenumgebung. Es zeigt, welche Fragen ich bei Infrastrukturarbeit wichtig
finde: Wo liegt die Grenze zwischen Plattform und Workload? Was kann ein Team
selbst ändern? Welche Änderung braucht Review? Und wie bleibt eine Umgebung
auch später noch erklärbar?

Ich möchte mit diesem Repo nicht behaupten, dass jede Komponente fertig
produktreif implementiert ist. Einige Teile sind bewusst als Schnittstellen
oder Rahmen-Stacks modelliert. Für mich ist das ein wichtiger Teil von
Plattformarbeit: nicht nur Ressourcen bauen, sondern Verantwortung sauber
schneiden.

## Technische Führung

Für mich gehört zu Platform Engineering auch technische Führung: Risiken
sichtbar machen, Entscheidungen nachvollziehbar erklären und Wissen so
ablegen, dass Betrieb nicht an einzelnen Personen hängt. Eine gute Plattform
hilft nicht nur beim Deployment. Sie hilft einem Team, Änderungen zu prüfen,
Fehler einzugrenzen, Verantwortung zu übernehmen und später sicher
weiterzubauen.

Deshalb lege ich Wert auf klare Übergabepunkte, Runbooks, Reviews, Approvals,
Changelogs und eine Single Source of Truth im Repository. Das ist für mich
keine Bürokratie, sondern die Grundlage dafür, dass Automatisierung im Team
funktioniert.

## Praktische Muster

- Terraform-basierte Azure-Infrastruktur mit Environment-Trennung
- YAML- oder konfigurationsgetriebene Beschreibung von Plattform- und Solution-Parametern
- Remote-State- und Backend-Strukturen für nachvollziehbare Deployments
- Netzwerksegmentierung mit Subnetzen, NSGs, Routing und zentralen Egress-/Ingress-Grenzen
- Application Gateway und WAF als zentraler Edge- und Reverse-Proxy-Baustein
- Firewall-Integration für kontrollierte Netzwerkpfade und Monitoring-Anbindung
- RBAC- und IAM-Überlegungen für Plattform- und Automatisierungszugriffe
- Azure DevOps Pipelines und Agent Pools für wiederholbare Bereitstellung
- Ansible-basiertes Konfigurationsmanagement für Multi-Tier-VM-Workloads
- Terraform Outputs als Inventory-Quelle für getrennte Ansible-Pipelines
- Azure VM Backup Policies und automatische Sicherungen nach definierten
  Regeln als dokumentiertes Betriebsmuster
- Python-basierte Restore-Automatisierung für stateful Solutions als
  anonymisiertes Pattern
- Logging von Restore-Abläufen zur Ableitung von RTO und RPO
- Behebung von Terraform Drift nach Restore-Abläufen
- Monitoring- und Observability-Strategien mit Azure Monitor, Log Analytics, PRTG-Erfahrung sowie Prometheus/Grafana-Zielbildern
- Self-Healing- und Recovery-Gedanken für zustandsbehaftete Workloads
- Kosten-, Risiko- und Betriebsbewertung als Teil technischer Architekturentscheidungen

## Architekturprinzipien

- Plattformen müssen wiederholbar, im Review verständlich und erweiterbar sein.
- Umgebungskonfiguration gehört in klar getrennte Dateien, nicht hart in
  Module.
- Netzwerk, Security, Monitoring und Betrieb gehören von Anfang an zur
  Architektur.
- Automatisierung muss im Team funktionieren: modular, dokumentiert und
  nachvollziehbar.
- Stateful Workloads brauchen klare Entscheidungen zu Storage,
  Session-Verhalten und Recovery.
- Komplexere Routing- oder IAM-Lösungen müssen gegen Betriebsrisiko und
  Testaufwand abgewogen werden.
- Ein Diagramm ist noch kein Betrieb. Entscheidend ist, ob ein Team die
  Änderung später prüfen, deployen und im Fehlerfall verstehen kann.

## Übertragbarkeit

Die Umsetzung in diesem Repository ist Azure-fokussiert. Die
Plattformprinzipien sind jedoch auf andere Umgebungen übertragbar: AWS, Google
Cloud, private Infrastruktur und Kubernetes-basierte Plattformen. Die konkreten
Dienste ändern sich, aber die Grundfragen bleiben gleich: Umgebungstrennung,
Netzwerkgrenzen, RBAC/IAM, Automatisierung, Monitoring, Recovery und Betrieb.

## Warum Dieses Repository So Geschnitten Ist

Das Repository trennt bewusst zwischen wiederverwendbaren Modulen und
deploybaren Root-Stacks. Dadurch zeigt es zwei Dinge gleichzeitig:

- eine konkret lauffähige Terraform-Basis für Netzwerk, Monitoring,
  Security- und Storage-Rahmen
- ein Stack-Modell, das getrennte Root-Repositories, Remote State,
  YAML-Konfiguration und klare Übergabepunkte simuliert

Diese Trennung ist wichtig, weil ein gutes Plattformdesign nicht nur aus Code
besteht. Es braucht auch klare Grenzen, Betriebsmodelle,
Entscheidungsgrundlagen und eine realistische Roadmap.

Ich mag keine Plattformen, bei denen die eigentliche Wahrheit im Portal, in
alten Tickets oder im Kopf einzelner Personen liegt. Deshalb liegt in diesem
Repository so viel Gewicht auf YAML-Konfiguration, Outputs, READMEs, Runbooks und
Changelogs.

## English

This document describes the platform patterns represented by this repository as
a sanitized example. It is not a one-to-one copy of a production customer
environment. It shows the questions I care about in infrastructure work: where
does the platform end and the workload begin? What can a team change by itself?
Which change needs review? And how does an environment stay explainable later?

I do not use this repository to claim that every component is production-ready.
Some parts are intentionally modeled as interfaces or stack frames. For me,
that is part of platform work: not only building resources, but also drawing
responsibility boundaries clearly.

## Technical Leadership

For me, platform engineering also includes technical leadership: making risks
visible, explaining decisions in a way others can follow and storing knowledge
so operations do not depend on individual people. A good platform does not only
help with deployment. It helps a team review changes, narrow down incidents,
take responsibility and safely continue the work later.

That is why I care about clear handover points, runbooks, reviews, approvals,
changelogs and a single source of truth in the repository. For me, this is not
bureaucracy. It is the foundation for automation that works in a team.

## Practical Patterns

- Terraform-based Azure infrastructure with environment separation
- YAML- or configuration-driven platform and solution parameters
- Remote-state and backend structures for understandable deployments
- Network segmentation with subnets, NSGs, routing and central ingress/egress boundaries
- Application Gateway and WAF as central edge and reverse-proxy building blocks
- Firewall integration for controlled network paths and monitoring connectivity
- RBAC and IAM considerations for platform and automation access
- Azure DevOps pipelines and agent pools for repeatable delivery
- Ansible-based configuration management for multi-tier VM workloads
- Terraform outputs as inventory source for separate Ansible pipelines
- Azure VM Backup policies and automatic backups based on defined rules as a
  documented operating pattern
- Python-based restore automation for stateful solutions as an anonymized
  pattern
- logging of restore flows to derive RTO and RPO
- fixing Terraform drift after restore flows
- Monitoring and observability strategies with Azure Monitor, Log Analytics, PRTG experience and Prometheus/Grafana target patterns
- Self-healing and recovery thinking for stateful workloads
- Cost, risk and operational assessment as part of technical architecture decisions

## Architecture Principles

- Platforms must be repeatable, understandable in review and extensible.
- Environment configuration belongs in clearly separated files, not hard-coded into modules.
- Networking, security, monitoring and operations belong in the architecture from the beginning.
- Automation must become team-ready: modular, documented and understandable.
- Stateful workloads need clear decisions around storage, session behavior and recovery.
- More complex routing or IAM designs must be weighed against operational risk and test effort.
- A diagram is not operations yet. What matters is whether a team can review,
  deploy and understand the change later, including during an incident.

## Transferability

The implementation in this repository is Azure-focused. The platform principles are transferable to other environments: AWS, Google Cloud, private infrastructure and Kubernetes-based platforms. The concrete services change, but the core questions stay the same: environment separation, network boundaries, RBAC/IAM, automation, monitoring, recovery and operations.

## Why This Repository Is Structured This Way

The repository intentionally separates reusable modules from deployable root
stacks. This shows two things at the same time:

- a concrete Terraform baseline for networking, monitoring, security and storage framing
- a stack model that simulates separate root repositories, remote state,
  YAML-based configuration and clear handover points

This separation matters because good platform design is not only code. It also needs clear boundaries, operating models, decision records and a realistic roadmap.

I do not like platforms where the real truth lives in the portal, in old
tickets or in individual people's heads. That is why this repository gives so
much weight to YAML configuration, outputs, READMEs, runbooks and changelogs.
