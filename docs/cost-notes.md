# Kostenhinweise / Cost Notes

## Deutsch

Dieses Repository erzeugt keine echte Azure-Umgebung. Für reale Deployments
sollten Kosten früh betrachtet werden.

Typische Kostentreiber:

- Application Gateway / WAF
- Firewall oder zentrale Netzwerkappliances
- AKS Node Pools oder VM-basierte Workloads
- Log Analytics Ingestion und Retention
- Storage und Backup
- Datenverkehr über Regionen oder Zonen
- Betriebsaufwand für getrennte Pipeline-Gates, Reviews und
  Configuration-Management

Für Lab- oder Demo-Umgebungen sollten kleine SKUs, kurze Retention und
automatische Abschalt- oder Destroy-Prozesse genutzt werden.
Error Budgets helfen dabei, Kosten- und Stabilitätsentscheidungen bewusst zu
treffen: Wenn Stabilisierung Vorrang hat, werden Skalierung, Retention und
zusätzliche Plattformdienste gezielter bewertet.

## English

This repository does not create a real Azure environment. For real deployments, costs should be considered early.

Typical cost drivers:

- Application Gateway / WAF
- Firewall or central network appliances
- AKS node pools or VM-based workloads
- Log Analytics ingestion and retention
- Storage and backup
- Cross-region or cross-zone traffic
- operational effort for separate pipeline gates, reviews and configuration
  management

For lab or demo environments, small SKUs, short retention and automatic shutdown or destroy processes should be used.
Error budgets help make cost and stability decisions deliberate: when
stabilization takes priority, scaling, retention and additional platform
services can be evaluated more deliberately.

## AKS-Umgebungsmodell / AKS Environment Model

Testing und Staging laufen in einer gemeinsamen Nonproduction-Umgebung. Sie
teilen den AKS-Cluster, Netzwerk, Edge, Egress,
Registry, Key Vault und Monitoring. Kosten werden über Namespace-, Stage- und
Owner-Metadaten zugeordnet. Quotas, RBAC und Network Policies begrenzen
gegenseitige Beeinflussung.

Die gemeinsame Umgebung hält eine kleine reguläre Grundlast und optionale
Spot-Kapazität für unterbrechbare Tests. Stop/Start außerhalb definierter
Test- und Releasefenster ist erlaubt. Ein dedizierter Staging-Node-Pool wird
erst bei gemessener Last oder einem echten Isolationsbedarf ergänzt.

Production wird nicht durch Entfernen von Redundanz verbilligt. Zwei
System-Nodes, reguläre Workload-Nodes und Zonenverteilung bleiben Teil der
Verfügbarkeitsanforderungen. Rightsizing, Autoscaling und eine mögliche
Reservierung werden erst nach Auswertung realer Kosten und
Production-Auslastungsmetriken entschieden. Production teilt keine States,
Netzwerke, Cluster, Identitäten, Secrets, Registry oder Monitoring-Ressourcen
mit Nonproduction.

Blue-Green dupliziert vorübergehend nur die auszurollende Workload. Die
kostenintensive Plattformbasis wird dabei innerhalb derselben Umgebung nicht
dupliziert. Die YAML-Profile sind keine Preisberechnung und kein
Einsparversprechen.

Testing and staging run in one shared nonproduction environment.
They share fixed platform services and allocate usage by namespace and stage.
Production keeps its own platform and availability boundaries;
it shares no runtime resources or state with nonproduction. Rightsizing and
commitments require production cost and utilization data.
