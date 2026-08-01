# Azure Landing Zone: Mein Denkweg / My Reasoning

## Status Und Ergebnisgrenze

Dieses Dokument ist ein begründetes Zielbild. Es zeigt, wie ich eine Azure
Landing Zone analysiere und schrittweise aufbaue. Management Groups,
Plattform-Subscriptions, Azure-Policy-Zuweisungen und Subscription Vending
sind hier als nächster Governance-Layer beschrieben; die Umsetzung gehört in
eine autorisierte Lern- oder Zielumgebung mit eigenem Plan, Review und Rückweg.

Die bestehende Nonproduction-/Production-Struktur bildet
Workload-Subscription-Grenzen ab. Eine tenantweite Platform Landing Zone ist
die nächste Architekturebene darüber.

## Meine Ausgangsfrage

Ich beginne nicht mit einer fertigen Management-Group-Hierarchie. Ich beginne
mit den Grenzen, die Governance, Ownership, Sicherheit und Betrieb tatsächlich
benötigen:

- Welche Regeln müssen für alle Subscriptions gelten?
- Welche Regeln gelten nur für bestimmte Workload-Archetypen?
- Welche Plattformdienste werden zentral verantwortet?
- Wo braucht ein Workload eine eigene Sicherheits-, Kosten-, State- und
  Fehlergrenze?
- Welche Verantwortung kann an ein Workload-Team übergeben werden?
- Wie wird eine neue Subscription wiederholbar in die Plattform aufgenommen?
- Wie kann eine Policy zuerst beobachtet, dann bewertet und erst danach
  kontrolliert durchgesetzt werden?
- Wie lässt sich prüfen, dass Vererbung, Berechtigungen und Ausnahmen so
  funktionieren wie beabsichtigt?

Die Microsoft-Referenzarchitektur ist dabei mein Ausgangspunkt, aber nicht
meine Entscheidung. Die konkrete Struktur muss aus Anforderungen und
Verantwortungsgrenzen ableitbar bleiben.

## Verbindliche Regeln Für Dieses Portfolio

- Die Referenzarchitektur liefert Begriffe und einen prüfbaren Ausgangspunkt;
  die konkrete Hierarchie wird aus Anforderungen abgeleitet.
- Management Groups entstehen aus gemeinsamen Policy-, Compliance-,
  Konnektivitäts- oder Ownership-Anforderungen, nicht aus SDLC-Namen oder
  einem Organigramm.
- Testing, Staging und Production werden nicht allein wegen ihrer
  Environment-Namen zu eigenen Management Groups.
- Die vorhandenen Nonproduction- und Production-Grenzen sind
  Workload-Subscriptions. Sie werden nicht nachträglich als Management Groups
  dargestellt.
- Nonproduction und Production können demselben Workload-Archetyp zugeordnet
  sein und bleiben trotzdem getrennte Subscription-, State-, Identity-,
  Secret-, Netzwerk-, Cluster- und Betriebsgrenzen.
- `corp` oder `online` bleibt für das Beispiel offen, bis Konnektivität,
  Exposition und Betriebsverantwortung belegt sind.
- Dieses Dokument und der ALZ-Core-Vertrag sind modellierte Zielbilder für
  den nächsten Governance-Layer.
- Terraform wird nicht allein für Vollständigkeit ergänzt. Vor Code wird
  entschieden, ob ein ausführbarer Governance-Slice genügend Lern- und
  Portfoliowert besitzt.
- Ein späterer erster Slice hält die Grenzen aus
  [ALZ Core](alz-core-contract.md) ein: eigener State, kleine Hierarchie,
  höchstens ein nicht erzwingender Policy-Test und keine Subscription-Moves,
  Workload-RBAC- oder Platform-Ressourcen.
- Statusangaben bleiben explizit: implementiert, modelliert oder Roadmap.

## Von Der Anforderung Zur Grenze

Ich trenne die Entscheidungen in dieser Reihenfolge:

1. **Tenant und Berechtigungen:** Welcher Entra-Tenant, welches
   Abrechnungsmodell und welche privilegierten Rollen sind die reale
   Ausgangslage?
2. **Tenantweite Baseline:** Welche wenigen Guardrails müssen unterhalb einer
   gemeinsamen Intermediate Root Management Group vererbt werden?
3. **Plattformverantwortung:** Brauchen Management, Security, Connectivity
   oder Identity getrennte Subscriptions, States und Betriebsverantwortungen?
4. **Workload-Archetypen:** Unterscheiden sich Workloads durch
   Konnektivität, Compliance oder Sicherheitsanforderungen so deutlich, dass
   sie verschiedene Policy-Sets benötigen?
5. **Subscription-Grenzen:** Welche Umgebungen müssen aus Gründen von
   Berechtigung, Blast Radius, Kosten, Quotas oder Lifecycle getrennt sein?
6. **Onboarding:** Welche Eingaben braucht ein wiederholbarer
   Subscription-Vending-Prozess, und was stellt die Plattform automatisch
   bereit?
7. **Betrieb:** Wie werden Policy-Verstöße, Berechtigungsänderungen,
   Plattformzustand, Kosten und Drift sichtbar?

So entsteht die Hierarchie aus Anforderungen. Sie wird nicht aus einem
Organigramm oder aus den Namen `development`, `testing` und `production`
kopiert.

## Abgeleitetes Zielbild

Das folgende Bild ist ein sinnvoller Startpunkt für dieses Lab. Optionale
Äste werden erst ergänzt, wenn eine echte Anforderung sie rechtfertigt.

```text
Tenant Root Group
└── Intermediate Root Management Group
    ├── Platform
    │   ├── Security
    │   ├── Management
    │   ├── Connectivity
    │   └── Identity                 optional bei eigener Identity-Infrastruktur
    ├── Landing Zones
    │   ├── Corp                     private oder hybride Konnektivität
    │   ├── Online                   internetnahe Workloads
    │   └── Local                    optional für Azure-Local-Anforderungen
    ├── Sandboxes                    isoliertes Lernen und Erproben
    └── Decommissioned               kontrollierte Stilllegung
```

Ich halte diese Struktur bewusst flach. Eine neue Management Group
braucht einen nachvollziehbaren Unterschied bei Policy, Compliance,
Konnektivität oder Plattform-Ownership. Tags und Resource-Graph-Abfragen sind
für reine Such- und Berichtssichten geeigneter als zusätzliche Hierarchie.

## Einordnung Des Bestehenden Labs

Die vorhandenen Environment-Grenzen werden nicht zu Management Groups
umbenannt. Sie bilden Application-Landing-Zone-Subscriptions eines Workloads:

```text
Landing Zones
└── Corp oder Online
    ├── Workload Nonproduction Subscription
    │   ├── Testing
    │   └── Staging
    └── Workload Production Subscription
        └── Production
```

Testing und Staging dürfen weiterhin kostenintensive Plattformdienste in
Nonproduction teilen. Production bleibt eine eigene Subscription mit eigenen
States, Identitäten, Secrets, Netzwerken, Clustern und Betriebsdaten.

Beide Subscriptions können trotzdem demselben Workload-Archetyp zugeordnet
sein, wenn sie dieselben übergeordneten Security- und Compliance-Policies
benötigen. Environment-spezifische Ausprägungen gehören dann in die
Subscription- oder Workload-Konfiguration, nicht automatisch in eine weitere
Management-Group-Ebene.

Die übergeordnete Platform Landing Zone besitzt einen anderen Lifecycle:

- `alz-core` verantwortet Management Groups, Policy- und
  Plattform-RBAC-Verträge.
- `alz-management` verantwortet zentrale Management- und
  Observability-Fähigkeiten.
- `alz-connectivity` verantwortet Hub, zentrale Konnektivität, Firewall und
  Private DNS, sofern dieses Betriebsmodell gewählt wird.
- `subscription-vending` nimmt Workload-Subscriptions kontrolliert auf.
- Die vorhandenen Fach-Stacks verantworten die Ressourcen innerhalb der
  jeweiligen Workload-Subscription.

In einer realen Organisation besitzen diese Grenzen eigenständige Root-States,
Pipelines, Freigaben und möglicherweise eigene Repositories. Das
Portfolio darf sie kompakt darstellen, aber nicht als einen gemeinsamen
Terraform-State modellieren.

## Bewusst Nicht Gewählte Abkürzungen

| Abkürzung | Warum ich sie nicht als Standard wähle |
| --- | --- |
| Eine Management Group je Environment | Development, Test und Production brauchen nicht automatisch unterschiedliche übergeordnete Policies. Die Struktur skaliert schlecht und kann erst spät sichtbare Policy-Unterschiede erzeugen. |
| Abteilungsstruktur als Cloud-Hierarchie | Organisationen ändern sich schneller als stabile Governance-Anforderungen. Ownership wird über klare Rollen und Zuständigkeiten abgebildet. |
| Alle Policies sofort mit `Deny` | Eine ungeprüfte Deny-Zuweisung kann bestehende Deployments oder Plattformprozesse blockieren. Wirkung und Ausnahmen müssen vorher sichtbar sein. |
| Workload-RBAC pauschal auf Management-Group-Scope | Vererbte Berechtigungen vergrößern den Zugriff unnötig. Workload-Teams erhalten Rechte bevorzugt auf Subscription- oder Resource-Group-Scope. |
| Alle Plattformfähigkeiten in einer ersten Ausbaustufe | Ein kleines Team braucht nicht automatisch dieselbe Trennung wie eine große Organisation. Separate Platform-Subscriptions folgen Ownership, Risiko, Limits und Betriebsbedarf. |
| Ein selbst gebautes Komplettframework ohne Referenzmodule | Eigener Code macht die Prinzipien sichtbar, ersetzt aber nicht die Wartbarkeit und Weiterentwicklung aktueller Azure-Verified-Module. |

## Policy-Lifecycle

Policy-driven Governance bedeutet für mich nicht, möglichst schnell viele
Deny-Regeln zu verteilen. Der sichere Weg ist gestuft:

```text
Anforderung
  -> Scope und Owner festlegen
  -> Definition oder Initiative versionieren
  -> auf kleinem Scope testen
  -> Audit-Ergebnis auswerten
  -> Remediation und Ausnahmeprozess klären
  -> kontrolliert auf Deny oder DeployIfNotExists umstellen
  -> Compliance und Nebenwirkungen überwachen
```

Eine Ausnahme braucht mindestens:

- eindeutigen Bezug zur Policy
- fachliche oder technische Begründung
- verantwortlichen Owner
- begrenzten Scope
- Ablaufdatum
- geplante Rücknahme oder erneute Prüfung

Policies, Zuweisungen und Ausnahmen gehören in den Review- und
Änderungsprozess. Manuelle Portaländerungen dürfen nicht zur zweiten
Wahrheitsquelle werden.

## Subscription Vending Als Plattformprodukt

Eine neue Subscription ist nicht erst dann fertig, wenn sie existiert. Der
Onboarding-Vertrag muss mindestens klären:

- Workload, Owner und Kostenverantwortung
- Nonproduction- oder Production-Grenze
- Ziel-Archetyp wie `Corp` oder `Online`
- benötigte Konnektivität und DNS
- RBAC- und PIM-Verantwortungen
- Budget, Tags und Kostenwarnungen
- Policy-Zuweisungen und begründete Ausnahmen
- zentrale Logging-, Security- und Monitoring-Anbindung
- Terraform-Backend und State-Ownership
- Betriebsübergabe, Support-Grenze und Stilllegung

Der Prozess soll diese Entscheidungen als versionierte Eingaben annehmen,
prüfen und wiederholbar umsetzen. Ein Ticket oder Formular kann der
Ausgangspunkt sein, darf aber nicht die einzige Quelle der technischen
Wahrheit bleiben.

## Stufenweiser Aufbau

| Stufe | Ziel | Nachweis |
| --- | --- | --- |
| 0 – Denkmodell | Anforderungen, Alternativen, Ownership und Zielbild dokumentieren | dieses Dokument und Review |
| 1 – Governance-Basis | [ALZ-Core-Vertrag](alz-core-contract.md): Intermediate Root, kleine Hierarchie, nicht erzwingender Policy-Test und getrennter State | Terraform-Plan, Hierarchie- und Vererbungsprüfung |
| 2 – Policy-Lifecycle | Initiative, Assignment, Remediation und befristete Exemption kontrolliert erproben | Compliance-Auswertung und Rücknahmetest |
| 3 – Subscription Vending | eine Workload-Subscription reproduzierbar aufnehmen und zuordnen | wiederholbarer Onboarding-Lauf und Übergabeprotokoll |
| 4 – Platform Landing Zone | Management-, Security- und Connectivity-Fähigkeiten nach Bedarf ergänzen | Plattform-Outputs, Diagnostics und Runbooks |
| 5 – Application Landing Zone | vorhandene Nonproduction-/Production-Stacks unter dem passenden Archetyp konsumieren | isolierte States, Policies, Deployments und Betriebschecks |

Der Aufbau beginnt in einer freigegebenen oder ausdrücklich autorisierten
Lernumgebung. Tenantweite Änderungen, Management-Group-Verschiebungen und
Policy-Enforcement benötigen einen eigenen Plan, geeignete Berechtigungen,
Review und eine ausdrückliche Freigabe.

## Verifikation

Eine Landing Zone ist für mich nicht durch ein erfolgreiches `terraform
apply` bewiesen. Zusätzlich prüfe ich:

- Liegt jede Subscription unter der beabsichtigten Management Group?
- Werden die erwarteten Policies vererbt und unerwartete Zuweisungen
  vermieden?
- Funktioniert eine zulässige Referenzbereitstellung?
- Wird eine bewusst unzulässige Konfiguration am erwarteten Scope erkannt
  oder blockiert?
- Besitzt ein Workload-Team nur die freigegebenen Berechtigungen?
- Funktionieren Exemption, Ablauf und Rücknahme nachvollziehbar?
- Erreichen Activity Logs, Policy Compliance und Plattformdiagnosen das
  verantwortete Monitoring-Ziel?
- Kann Subscription-Vending mit denselben Eingaben reproduziert werden?
- Bleiben Workload- und Platform-States voneinander getrennt?
- Ist die Stilllegung genauso kontrolliert wie das Onboarding?

Erst diese Prüfungen verbinden Governance-Code mit realem Plattformbetrieb.

## Umsetzungsstand Im Repository

| Bereich | Status |
| --- | --- |
| Landing-Zone-Entscheidungslogik | dokumentiert |
| Nonproduction-/Production-Subscription-Grenze | als Workload-Vertrag modelliert |
| Management-Group-Hierarchie | Zielbild, nicht implementiert |
| Policy Definitions, Initiatives und Assignments | Roadmap |
| Platform-RBAC und PIM | Roadmap und externe Voraussetzung |
| Subscription Vending | Roadmap |
| Zentrale Platform-Subscriptions | Roadmap |
| Tenantweites Deployment | nicht ausgeführt |

## Referenzrahmen

- [Microsoft Cloud Adoption Framework: Azure Landing Zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/)
- [Microsoft Cloud Adoption Framework: Management Groups](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups)
- [Microsoft Cloud Adoption Framework: Application Environments](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-application-environments)
- [Azure Verified Modules for Platform Landing Zone – Terraform](https://azure.github.io/Azure-Landing-Zones/terraform/)

## English Summary

This document is my reasoned target model for the next governance layer. The
existing nonproduction and production boundaries represent workload
subscriptions. A Platform Landing Zone is the architectural layer above them
and needs its own tenant context, review, plan and rollback path.

I do not start by copying a finished management-group hierarchy. I start with
the boundaries required by governance, ownership, security and operations:

- tenant-wide rules remain few and deliberate
- management groups represent shared policy and compliance requirements
- workload archetypes are based on connectivity and security needs, not SDLC
  environment names
- nonproduction and production use separate subscriptions but can inherit the
  same archetype policies
- platform capabilities receive separate subscriptions and states only when
  ownership, risk, limits or operations justify that separation
- policies move from scoped testing and audit to enforcement only after their
  impact, remediation and exception path are understood
- subscription vending includes policy, RBAC, cost, logging, network, state
  and operational handover rather than only creating a subscription

The intended implementation path is deliberately staged: document the
decisions, establish a minimal governance hierarchy, test the policy lifecycle,
build repeatable subscription vending, add justified platform capabilities and
then onboard the existing workload stacks. Each stage requires verification
beyond a successful deployment, including inheritance, least privilege,
compliance, exception expiry, observability, state separation and controlled
decommissioning.
