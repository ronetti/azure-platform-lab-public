# Firewall Module

## Deutsch

Dieses Rahmenmodul beschreibt die Schnittstelle für zentrale
Firewall-Integration. Je nach Umgebung kann das Azure Firewall, eine virtuelle
Appliance oder eine bestehende zentrale Plattformkomponente sein.

Regeln und IP-Gruppen sollten als Konfiguration modelliert werden, damit neue
Freigaben über YAML, Pull Requests und Pipeline-Gates nachvollziehbar bleiben.

Firewall-Änderungen sind Security- und Availability-relevant und sollten bei
produktionsnahen Umgebungen an Approvals und Error-Budget-Bewertung gekoppelt
werden.

## English

This module frame describes the interface for central firewall integration.
Depending on the environment, this can be Azure Firewall, a virtual appliance or
an existing central platform component.

Rules and IP groups should be modeled as configuration so new access paths can
be reviewed through YAML, pull requests and pipeline gates.

Firewall changes affect security and availability and should be connected to
approvals and error-budget checks in production-like environments.
