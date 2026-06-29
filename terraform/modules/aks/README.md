# AKS Module

## Deutsch

Dieses Rahmenmodul beschreibt die Kubernetes-Zielstruktur. Für ein echtes Setup
würden hier AKS, Node Pools, Managed Identity, Netzwerkprofil, Monitoring,
Guardrails und Upgrade-Strategie modelliert.

Node Pools, Versionen und Betriebsparameter sollten über Konfiguration steuerbar
sein. Kubernetes-Guardrails wie Security Contexts, Probes, Requests, Limits und
Policy-Gates gehören zum Zielbild.

SLIs wie Node Readiness, Pod Availability, Deployment Availability und
Restart-Rate sollten in SLOs und Error Budgets übersetzt werden.

## English

This module frame describes the Kubernetes target structure. A real setup would
model AKS, node pools, managed identity, network profile, monitoring,
guardrails and upgrade strategy.

Node pools, versions and operating parameters should be controlled through
configuration. Kubernetes guardrails such as security contexts, probes,
requests, limits and policy gates are part of the target model.

SLIs such as node readiness, pod availability, deployment availability and
restart rate should be translated into SLOs and error budgets.
