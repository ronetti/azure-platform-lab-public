# Application Gateway / WAF Module

## Deutsch

Dieses Rahmenmodul ist für Edge-Patterns gedacht: Application Gateway, WAF
Policy, Listener, Backend Pools, Health Probes, Diagnostic Settings und
WAF-Konfiguration.

Der erste Schritt ist der Hostname-pro-Solution-Ansatz: ein zentraler
Application Gateway/WAF, aber klar getrennte Listener, Backends und Probes. Die
gemeinsame URL mit zusätzlicher Routing-Logik bleibt als späterer Ausbau
geplant.

Die Betriebslogik umfasst Log Analytics, Alerting und optional eine Azure
Function für Teams-Benachrichtigungen. WAF Custom Rules, Exclusions und
Managed-Rule-Overrides sollten als YAML-Schichten modelliert werden, damit sie
im Review sichtbar bleiben.

Listener-Verfügbarkeit, Backend Health, Fehlerrate und Latenz sind natürliche
SLI-Kandidaten für SLOs und Error Budgets.

## English

This module frame is intended for edge patterns: Application Gateway, WAF
policy, listeners, backend pools, health probes, diagnostic settings and WAF
configuration.

The first step is the hostname-per-solution approach: one central Application
Gateway/WAF, but clearly separated listeners, backends and probes. A shared URL
with additional routing logic remains planned as a later extension.

The operating model includes Log Analytics, alerting and optionally an Azure
Function for Teams notifications. WAF custom rules, exclusions and managed-rule
overrides should be modeled as YAML layers that stay visible in review.

Listener availability, backend health, error rate and latency are natural SLI
candidates for SLOs and error budgets.
