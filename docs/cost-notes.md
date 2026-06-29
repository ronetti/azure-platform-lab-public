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
