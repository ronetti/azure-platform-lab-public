# Routing Module

## Deutsch

Dieses Rahmenmodul beschreibt Route Tables, UDRs und zentrale
Egress-Patterns. In echten Umgebungen werden hier Firewall- oder NVA-Routen
modelliert.

Routen sollen aus versionierter Konfiguration entstehen, damit neue
Netzwerkpfade später nachvollziehbar bleiben.
Downstream-Stacks sollten nur veröffentlichte Netzwerk-Outputs und
klar beschriebene Routing-Daten nutzen.

## English

This module frame describes route tables, UDRs and central egress patterns.
In real environments, firewall or NVA routes are modeled here.

Routes should be derived from versioned configuration so new network paths stay
understandable later.
Downstream stacks should consume only published network outputs and routing
data.
