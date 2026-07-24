# ALZ Core: Kleinster Verantwortbarer Vertrag

## Status

Dieses Dokument leitet aus dem
[Landing-Zone-Denkweg](landing-zone-thinking.md) den kleinsten ersten
Implementierungsschnitt ab. Es ist noch kein Terraform-Root-Stack und keine
Behauptung über tenantweit provisionierte Ressourcen.

Ein `terraform/stacks/alz-core`-Verzeichnis wird erst angelegt, wenn die
Voraussetzungen, Ressourcenliste und Sicherheitsgrenzen geprüft und
freigegeben sind. So entsteht kein README-only-Stack, der ausführbarer wirkt,
als er ist.

## Ziel Des Ersten Slices

Der erste Slice soll genau eine Fähigkeit beweisen:

> Eine kleine Management-Group- und Policy-Basis kann aus versionierter
> Konfiguration reproduzierbar geplant, kontrolliert angewendet und unabhängig
> von Workload-States verifiziert werden.

Er soll noch keine vollständige Platform Landing Zone erzeugen. Management,
Security, Connectivity, Subscription Vending und Workload-Onboarding folgen
als getrennte Ausbaustufen.

## Voraussetzungen Vor Terraform-Code

Die folgenden Informationen und externen Voraussetzungen müssen zuerst
auflösbar sein:

- freigegebener persönlicher Lern-Tenant oder ausdrücklich autorisierter
  Ziel-Tenant
- ID der vorhandenen Parent Management Group
- Berechtigung, die bestehende Hierarchie, Policy-Zuweisungen und
  Rollenbindungen vollständig zu lesen
- zeitlich begrenzte Apply-Berechtigung auf dem notwendigen Scope
- getrennte Plan- und Apply-Identitäten
- vorhandener Remote-State-Backend-Service außerhalb des `alz-core`-States
- festgelegter Owner für Tenant Governance
- fachlicher Reviewer für Policy- und Security-Änderungen
- dokumentierter Wiederherstellungs- und Rücknahmepfad

Tenant-IDs, Subscription-IDs, Principal-IDs und Backend-Namen gehören nicht in
dieses öffentliche Portfolio. Sie werden erst in einer freigegebenen realen
Umgebung über geschützte Konfiguration bereitgestellt.

## Scope

### Im Ersten Slice

- eine vorhandene Parent Management Group als expliziter Einstiegspunkt
- eine Intermediate Root Management Group darunter
- flache Child Management Groups für:
  - `platform`
  - `landing-zones`
  - `sandboxes`
  - `decommissioned`
- unter `platform` zunächst:
  - `management`
  - `connectivity`
- unter `landing-zones` nur die freigegebenen Archetypen:
  - `corp`
  - `online`
- höchstens eine ungefährliche Built-in-Policy-Zuweisung als
  Lifecycle-Beispiel
- Policy-Wirkung zunächst in `Audit` oder `DoNotEnforce`
- dokumentierte Outputs der erzeugten Management-Group- und
  Policy-Assignment-IDs

`identity`, `security` und `local` bleiben zunächst konfigurierbare,
deaktivierte Optionen. Sie werden erst aktiviert, wenn Identity-Infrastruktur,
Security-/SIEM-Ownership oder Azure-Local-Anforderungen eine eigene Grenze
begründen.

### Nicht Im Ersten Slice

- Erstellen oder Verschieben bestehender Subscriptions
- Subscription Vending
- Plattform- oder Workload-RBAC-Zuweisungen
- benutzerdefinierte Rollen
- Policies mit aktivem `Deny`, `Modify` oder `DeployIfNotExists`
- Policy-Remediation
- Policy Exemptions
- Management-, Security-, Identity- oder Connectivity-Ressourcen
- Hub-Netzwerk, Firewall, Private DNS oder zentrale Monitoring-Ressourcen
- Workload-Deployments
- Änderungen direkt an der Tenant Root Group
- Löschen bestehender Management Groups oder Policy Assignments

Diese Begrenzung hält die erste Änderung klein genug, damit Vererbung,
Ownership und Rücknahme verstanden werden können.

## Warum Diese Hierarchie

```text
vorhandene Parent Management Group
└── Intermediate Root
    ├── Platform
    │   ├── Management
    │   └── Connectivity
    ├── Landing Zones
    │   ├── Corp
    │   └── Online
    ├── Sandboxes
    └── Decommissioned
```

- Die vorhandene Parent Management Group bleibt ein externer,
  bewusst ausgewählter Einstiegspunkt.
- Die Intermediate Root verhindert, dass das Lab seine Baseline direkt an der
  Tenant Root Group verteilt.
- `platform` trennt zentrale Plattformverantwortung von Workload-Ownership.
- `landing-zones` bündelt workload-unabhängige Guardrails.
- `corp` und `online` unterscheiden Konnektivitäts- und Sicherheitsmuster,
  nicht Development, Testing und Production.
- `sandboxes` erlaubt isoliertes Erproben mit einer bewusst anderen
  Governance-Stufe.
- `decommissioned` macht Stilllegung zu einem kontrollierten Lifecycle-Schritt.

Ob das bestehende Workload-Beispiel später unter `corp` oder `online`
eingeordnet wird, bleibt eine offene Architekturentscheidung. Dafür müssen
zuerst Konnektivität, Exposition und Betriebsverantwortung eindeutig
klassifiziert werden.

## Implementierungsentscheidung

Eine reale Umsetzung soll den aktuellen offiziellen Azure-Landing-Zone-Ansatz
mit Azure Verified Modules konsumieren. Der Portfolio-Code bildet darum einen
kleinen Wrapper und verantwortete Eingaben, statt Management-Group-,
Policy- und Role-Assignment-Logik aus dem Referenzmodul zu kopieren.

Vor der Implementierung werden geprüft und festgehalten:

- genaue Modulquelle und vollständig gepinnte Version
- benötigte Provider und vollständig gepinnte Versionen
- Auswirkungen der mitgelieferten Policy-Bibliothek
- standardmäßig aktive Assignments
- Abhängigkeiten auf Management-, Connectivity- oder Security-Ressourcen
- Verhalten bei Brownfield-Hierarchien
- Import- und Migrationsweg für bereits vorhandene Ressourcen

Die offizielle Empfehlung ist damit ein gepflegter Baustein, aber kein Grund,
Defaults ungeprüft zu übernehmen. Jede aktive Policy muss zu den Fähigkeiten
passen, die im Ziel-Tenant tatsächlich vorhanden sind.

## Konfigurationsvertrag

Die spätere Implementierung soll keine Tenant-Werte in Terraform-Code
hartcodieren. Der erste Vertrag benötigt logisch folgende Eingaben:

| Eingabe | Zweck |
| --- | --- |
| `parent_management_group_id` | vorhandener und freigegebener Einstiegspunkt |
| `root_id` und `root_display_name` | stabile Identität der Intermediate Root |
| `management_groups` | flache, über logische Schlüssel definierte Hierarchie |
| `enabled_archetypes` | explizite Auswahl von `corp` und/oder `online` |
| `enabled_platform_domains` | zunächst `management` und `connectivity` |
| `policy_assignments` | kleine, reviewbare Map freigegebener Assignments |
| `policy_enforcement_mode` | im ersten Slice nur nicht erzwingender Modus |
| `common_metadata` | nicht-sensitive Ownership- und Zweckangaben |

Sicherheitsrelevante IDs und Identitäten werden aus geschützten Pipeline-
Variablen oder einem freigegebenen privaten Konfigurationspfad bezogen. Die
öffentliche Beispielkonfiguration enthält nur synthetische logische Werte.

## Output-Vertrag

Der Stack veröffentlicht nur stabile Übergabepunkte:

```text
management_group_ids = {
  root
  platform
  management
  connectivity
  landing_zones
  corp
  online
  sandboxes
  decommissioned
}

policy_assignment_ids = {
  <logical_assignment_key>
}
```

Spätere Stacks konsumieren logische Outputs. Sie rekonstruieren keine
Management-Group-Ressourcenpfade aus Namen und greifen nicht in die interne
Modulstruktur.

## State- Und Pipeline-Grenze

`alz-core` besitzt einen eigenen Tenant-Governance-State. Dieser State wird
nicht mit Platform-Ressourcen, Subscription Vending oder Workload-Stacks
geteilt.

```text
Bootstrap / externer Backend-Vertrag
  -> alz-core State
       -> Management Groups
       -> Policy Definitions oder Bibliotheksreferenzen
       -> Policy Assignments

alz-core Outputs
  -> später: subscription-vending
  -> später: alz-management
  -> später: alz-connectivity
```

Der geplante State-Key muss eindeutig sein, zum Beispiel
`platform/alz-core/tenant.tfstate`. Der konkrete Storage Account, Container und
Tenant bleiben externe, nicht veröffentlichte Konfiguration.

Pipeline-Grenzen:

- Check und Validate ohne Azure-Schreibzugriff
- Plan mit lesender beziehungsweise minimal notwendiger Plan-Identität
- unveränderliches Plan-Artefakt
- Apply nur aus freigegebenem Branch und geschütztem Environment
- zeitlich begrenzte privilegierte Berechtigung
- keine gleichzeitigen Schreibläufe gegen denselben State
- genau das geprüfte Plan-Artefakt anwenden

## Policy-Auswahl Für Den Lern-Slice

Der Vertrag legt noch keine konkrete Built-in-Policy-ID fest. Vor der Auswahl
muss die aktuell veröffentlichte Definition geprüft werden:

- unterstützt sie tatsächlich einen nicht erzwingenden Einstieg?
- besitzt sie versteckte Abhängigkeiten oder Remediation-Aufgaben?
- ist ihr Scope für eine leere beziehungsweise kontrollierte Testhierarchie
  geeignet?
- kann ihre Wirkung mit einer synthetischen Referenzressource nachgewiesen
  werden?
- lässt sie sich ohne verbleibende Nebenwirkungen zurücknehmen?

Erst danach wird eine genaue Definition mit ID, Version, Scope, Parametern,
Owner und Testfall in die Konfiguration aufgenommen. Damit bleibt die Policy
eine begründete Entscheidung und kein zufällig ausgewähltes Demoobjekt.

## Review- Und Sicherheitsgates

Ein Plan darf erst für Apply freigegeben werden, wenn:

- die Parent Management Group im richtigen Tenant verifiziert wurde
- keine bestehende Management Group unbeabsichtigt übernommen, verschoben,
  umbenannt oder gelöscht wird
- keine bestehende Subscription verschoben wird
- keine Zuweisung an der Tenant Root Group entsteht
- alle Änderungen im Plan Ergänzungen sind oder einzeln begründete Updates
- kein `Deny`, `Modify` oder `DeployIfNotExists` aktiv ist
- die Policy-Wirkung und der Rücknahmeschritt dokumentiert sind
- die Apply-Identität nur die für diesen Slice notwendigen Rechte besitzt
- State-Backend, Locking und Recovery geprüft sind
- ein zweites fachliches Review für tenantweite Governance vorliegt

Unerwartete Deletes, Replacements, Subscription Moves oder erzwingende
Policy-Effekte stoppen den Ablauf.

## Verifikation Nach Apply

```text
Kontext prüfen
  -> Hierarchie lesen
  -> Parent-Child-Beziehungen vergleichen
  -> Policy Assignment und Enforcement Mode lesen
  -> Policy-Vererbung auf Child-Scope prüfen
  -> synthetischen Audit-Test ausführen
  -> Activity Log und Policy Compliance prüfen
  -> Rücknahmeschritt trocken durchgehen
  -> Terraform erneut planen und Drift ausschließen
```

Akzeptanzkriterien:

- alle erwarteten Management Groups existieren genau einmal
- alle Parent-Child-Beziehungen entsprechen der freigegebenen Konfiguration
- es gibt keine Subscription Moves
- das Policy Assignment läuft nicht erzwingend
- ein definierter Test macht die erwartete Compliance-Wirkung sichtbar
- außerhalb des Testscopes entstehen keine unerwarteten Änderungen
- ein erneuter Terraform-Plan zeigt keine Drift
- Outputs sind vollständig und enthalten keine sensitiven Werte
- Runbook und Changelog beschreiben Ergebnis und noch offene Stufen

## Abbruch Und Rücknahme

Der erste Slice vermeidet produktive Subscriptions und erzwingende Policies,
damit eine Rücknahme überschaubar bleibt. Trotzdem wird sie vor dem Apply
geplant:

1. Policy Assignment deaktivieren oder kontrolliert entfernen.
2. Prüfen, dass keine Subscription oder Ressource von den Management Groups
   abhängt.
3. Child Management Groups von unten nach oben entfernen.
4. Intermediate Root zuletzt entfernen.
5. Terraform-Plan und Azure-Hierarchie erneut prüfen.
6. State-Aufbewahrung und Audit-Nachweis nach dem freigegebenen Prozess
   behandeln.

Das ist ein geplanter Ablauf, keine Autorisierung zur Löschung. Jede reale
Rücknahme braucht eine eigene Prüfung und ausdrückliche Freigabe.

## Entscheidungspunkte Vor Der Implementierung

Vor Terraform-Code müssen noch diese Fragen beantwortet werden:

1. Wird ein persönlicher Lern-Tenant oder eine andere freigegebene Umgebung
   verwendet?
2. Welche vorhandene Parent Management Group ist der sichere Einstiegspunkt?
3. Werden im Lern-Slice `corp`, `online` oder beide Archetypen erzeugt?
4. Welche eine Built-in-Policy eignet sich nach aktueller Prüfung für den
   nicht erzwingenden Test?
5. Welche Azure-Verified-Module-Version wird nach Prüfung vollständig gepinnt?
6. Wie werden Backend und Apply-Identität außerhalb dieses States
   bereitgestellt?
7. Wer übernimmt das zweite Governance-/Security-Review?

Bis diese Entscheidungen vorliegen, bleibt der Status **modellierter
Implementierungsvertrag**.

## English Summary

This document defines the smallest responsible `alz-core` implementation
contract. It intentionally does not create an empty Terraform stack or claim
that tenant-level resources exist.

The first slice proves only that a small management-group hierarchy and one
non-enforcing policy example can be planned, applied and verified from
versioned configuration with an independent governance state. It does not move
subscriptions, assign workload RBAC, deploy platform services or enable
enforcing policy effects.

The intended implementation consumes the current Azure Verified Modules for
Platform Landing Zone through a small reviewed wrapper. It does not copy the
module internals or accept all defaults without examining policy dependencies.
Stable management-group and policy-assignment IDs become outputs for later
subscription-vending, management and connectivity stacks.

Before implementation, the target tenant, parent management group, archetype
selection, one safe policy example, exact pinned module version, backend,
privileged apply identity and independent governance review must be resolved.
Unexpected deletes, replacements, subscription moves or enforcing policy
effects stop the deployment path.

## Referenzrahmen

- [Azure Verified Modules for Platform Landing Zone – Terraform](https://azure.github.io/Azure-Landing-Zones/terraform/)
- [Azure Landing Zone Accelerator: Planning](https://azure.github.io/Azure-Landing-Zones/accelerator/0_planning/)
- [Microsoft Cloud Adoption Framework: Management Groups](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups)
- [Microsoft Cloud Adoption Framework: Application Environments](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-application-environments)
