# Netzwerksegmentierung / Network Segmentation

## Ziel

Dieses Pattern beschreibt ein skalierbares Segmentierungsmodell für mehrere
Solutions, Mandanten oder Workload-Instanzen. Ziel ist sinnvolle Isolation,
ohne eine kaum verwaltbare Anzahl an Subnetzen zu erzeugen.

## Purpose

This pattern describes a scalable segmentation model for multiple solutions,
tenants or workload instances. The goal is meaningful isolation without
creating an unmanageable number of subnets.

## Designziele

- extern erreichbare Web-Komponenten von Backend-Systemen trennen
- direkten Public-IP-Zugriff auf virtuelle Maschinen vermeiden
- zentralen Ingress, Egress und administrativen Zugriff unterstützen
- Subnetze und NSGs über Terraform automatisierbar halten
- planbare Kapazität schaffen, wenn die Anzahl der Solutions wächst

## Design Goals

- isolate externally reachable web components from backend systems
- avoid direct public access to virtual machines
- support central ingress, egress and administrative access
- keep subnet and NSG management automatable through Terraform
- allow predictable capacity planning as the number of solutions grows

## Basismodell

```text
VNet
  zentrale Infrastruktur-Subnetze
    AzureBastionSubnet
    AzureFirewallSubnet
    ApplicationGatewaySubnet
    shared-services

  Subnetze pro Solution
    solution-001-web
    solution-001-app-data
    solution-002-web
    solution-002-app-data
```

Jede Solution erhält zwei Subnetztypen:

- `web`: Web- oder Reverse-Proxy-nahe Komponenten
- `app-data`: Applikation, Daten, Print, Worker oder interne Services

Das hält die Sicherheitsgrenze klar, ohne den Betriebsaufwand eines Subnetzes
pro VM oder eines großen gemeinsamen Subnetzes zu erzeugen.

## Baseline Layout

Each solution receives two subnet types:

- `web`: web or reverse-proxy-facing components
- `app-data`: application, data, print, worker or internal service components

This keeps the security line clear while avoiding the operational overhead
of one subnet per VM or one large subnet for everything.

## Entscheidungslogik

| Option | Vorteil | Risiko |
| --- | --- | --- |
| Ein Subnetz pro VM | maximale Isolation | zu viele Subnetze, schwer zu verwalten |
| Ein großes Subnetz | einfachste Netzform | schwache Isolation und komplexe Regeln |
| Rollenbasierte gemeinsame Subnetze | einfache Rollentrennung | schwache Mandanten- oder Solution-Isolation |
| Zwei Subnetze pro Solution | ausgewogene Isolation und Betrieb bleibt überschaubar | erfordert konsistente Automatisierung |

Das bevorzugte Modell sind zwei Subnetze pro Solution. Es trennt Web-nahe
Komponenten von Backend-Komponenten und hält Adressplanung sowie Terraform-Logik
beherrschbar.

## Decision Rationale

| Option | Benefit | Risk |
| --- | --- | --- |
| One subnet per VM | maximum isolation | too many subnets, hard to manage |
| One large subnet | simplest network shape | weak isolation and complex rules |
| Role-based shared subnets | simple role separation | weak tenant or solution isolation |
| Two subnets per solution | balanced isolation and manageable operations | requires consistent automation |

The preferred model is two subnets per solution. It isolates web-facing
components from backend components while keeping the address plan and Terraform
logic manageable.

## Sicherheitsmodell

Typische NSG-Absicht:

- Web-Subnetz akzeptiert HTTP(S) nur vom Application Gateway oder freigegebenen
  Edge-Komponenten.
- App-Data-Subnetz akzeptiert nur notwendigen Traffic aus dem passenden
  Web-Subnetz.
- Management-Zugriff läuft über Bastion oder freigegebene administrative Pfade.
- Ausgehender Traffic kann über eine zentrale Firewall geroutet werden.
- Virtuelle Maschinen benötigen keine Public IPs.

## Security Model

Typical NSG intent:

- web subnet accepts HTTP(S) only from Application Gateway or approved edge
  components
- app-data subnet accepts only required traffic from its matching web subnet
- management access is routed through Bastion or approved administrative paths
- outbound traffic can be routed through a central firewall
- virtual machines do not require public IP addresses

## Defense In Depth Mit ASGs

Die Subnetze bilden die Solution- und Workload-Grenze. Application Security
Groups können innerhalb dieser Grenze zusätzlich Rollen wie Web, Applikation
oder Daten gruppieren. NSG-Regeln referenzieren dann logische Rollen statt
einzelner IP-Adressen.

ASGs ersetzen weder die Subnetztrennung noch die zentrale Firewall. Sie
ergänzen beide als Defense-in-Depth-Schicht, ohne für jede VM ein eigenes
Subnetz zu erzeugen. In diesem Repository ist das als mögliche Erweiterung
dokumentiert und noch nicht als Terraform-Ressource implementiert.

## Defense In Depth With ASGs

Subnets define the solution and workload boundary. Application Security Groups
can additionally group roles such as web, application or data within that
boundary. NSG rules can then reference logical roles instead of individual IP
addresses.

ASGs replace neither subnet isolation nor the central firewall. They complement
both as a defense-in-depth layer without creating a subnet for every virtual
machine. This repository documents the option but does not yet implement ASGs
as Terraform resources.

## Skalierungsmodell

Der Adressplan sollte Kapazität für zentrale Infrastruktur und eine bekannte
Anzahl an Solution-Subnetzpaaren reservieren. Wenn ein VNet voll ist, kann ein
weiteres VNet mit demselben Infrastruktur-Pattern bereitgestellt werden.

Wichtig ist weniger die konkrete CIDR-Größe in diesem Lab, sondern das
Betriebsmodell:

- Kapazität wird vorher geplant.
- Subnetz-Zuweisung ist deterministisch.
- Neue Solutions werden über YAML-Konfiguration ergänzt.
- Terraform berechnet und provisioniert die resultierende Netzwerkform.
- Keine manuelle Subnetz-Tabelle ist für Routinewachstum erforderlich.

## Scaling Model

The address plan should reserve capacity for shared infrastructure and a known
number of solution subnet pairs. When the current VNet is full, a new VNet with
the same infrastructure pattern can be provisioned.

The important point is the operating model:

- capacity is planned up front
- subnet allocation is deterministic
- new solutions are added through YAML configuration
- Terraform calculates and provisions the resulting network shape
- no manual subnet spreadsheet is required for routine growth

## Repo-Bezug

- `network` in `environments/nonproduction/nonproduction.yaml` modelliert
  die Netzwerkdaten.
- `terraform/stacks/network/outputs.tf` veröffentlicht Subnet IDs als stabilen
  Übergabepunkt.
- `terraform/stacks/routing` und `terraform/stacks/firewall` nutzen diese
  Netzwerk-Outputs über Remote State.

## Repository Mapping

- `network` in `environments/nonproduction/nonproduction.yaml` models the
  network data.
- `terraform/stacks/network/outputs.tf` exposes subnet IDs as a stable
  handover point.
- `terraform/stacks/routing` and `terraform/stacks/firewall` consume these
  network outputs through remote state.
