# Environments

Es gibt zwei getrennte Infrastruktur- und Subscription-Grenzen. Darin liegen
drei klar benannte Deployment-Stages: Testing und Staging in Nonproduction,
Production in Production.

```text
environments/
  nonproduction/
    nonproduction.yaml  # Testing und Staging
    nonproduction.azurerm.tfbackend.example
  production/
    production.yaml  # Production
    production.azurerm.tfbackend.example
```

Die beiden YAML-Dateien sind das konsolidierte Architekturmodell und die
ausführbare Terraform-Konfiguration dieses kompakten Labs. Jeder Root-Stack
liest daraus nur seinen gleichnamigen Abschnitt. Die Backend-Basis steht je
Subscription einmal daneben; nur der State-Key unterscheidet die Root-Stacks.

Im zugrundeliegenden Repository-Modell ist derselbe Vertrag verteilt: Network,
Firewall, Application Gateway, Compute und weitere Fachbereiche besitzen je
ein eigenes Repository mit eigener Multi-Environment-YAML, Backend-/State-
Konfiguration, Pipeline, Security-Assets und README. Single Source of Truth
bedeutet dort eine verantwortete Quelle pro Fach-Repository, nicht eine
globale Datei für alle Teams.

## Nonproduction

[`nonproduction/nonproduction.yaml`](nonproduction/nonproduction.yaml) enthält das gemeinsame Zielmodell
für Testing und Staging. Beide sollen denselben AKS-Cluster, dasselbe Netzwerk,
Gateway, Firewall, Monitoring, Key Vault, Registry, Terraform State und Storage
nutzen.

Testing und Staging bleiben durch Namespaces, eigene ServiceAccounts ohne
vorbelegte Berechtigungen, ResourceQuotas und NetworkPolicies getrennt.
Zusätzliche RBAC-Bindings müssten je Namespace explizit ergänzt werden. Das
spart die doppelte Grundlast der teuren Plattformdienste.

## Production

[`production/production.yaml`](production/production.yaml) beschreibt die eigene
Produktionsumgebung. Sie teilt weder Netzwerk noch Cluster oder Terraform
State mit Nonproduction. Auch Registry, Key Vault, Identitäten, Secrets,
Monitoring und Pipeline-Berechtigungen bleiben getrennt.

Production liest ausschließlich Production-Remote-State. Ein Release übernimmt
nur ein geprüftes, unveränderliches Artefakt in den Production-Bereich; daraus
entsteht keine Runtime-Abhängigkeit zu Nonproduction.

## Deployments

- Testing verwendet Rolling Deployments für schnelles Feedback.
- Staging prüft Blue-Green und den Traffic-Wechsel.
- Production verwendet Blue-Green mit zusätzlicher Freigabe und schnellem
  Rückwechsel auf die vorherige Version.

Blue-Green verdoppelt während eines Releases nur die betroffene Anwendung,
nicht die gesamte Infrastruktur. Der Traffic-Wechsel benötigt noch eine
Deployment-Pipeline oder einen Rollout-Controller.

Merksatz: **Zwei Infrastrukturgrenzen, drei Deployment-Stages.**
