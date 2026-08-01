# AKS Stack

## Zweck

Dieser Root-Stack macht die AKS-Plattformentscheidungen sichtbar: Cluster-
Grenze, Netzwerk, Identität, Security, Ingress, Node Pools, Kostenprofil,
Monitoring und Betriebsparameter. Er löst Subnet und Monitoring-Workspace aus
Remote State auf und zeigt damit, wie AKS nicht isoliert entsteht, sondern aus
Network- und Shared-Services-Verträgen konsumiert.

Der Stack ist aktuell ein ausführbarer Intent-Vertrag und noch keine
Cluster-Provisionierung. Das ist bewusst getrennt: Die Plattformentscheidungen
werden reviewbar, bevor ein reales Cluster mit Day-0-Entscheidungen entsteht.
Die dazugehörigen Kubernetes-Blueprints liegen unter
[`kubernetes/`](../../../kubernetes/README.md) und zeigen, wie Namespaces,
Security Defaults, NetworkPolicies, Ressourcensteuerung und Workload-Overlays
später auf diesem AKS-Modell aufsetzen.

Flux gehört als GitOps-Layer hinter diese Grenze. Der AKS-Stack beschreibt,
wo der Cluster, seine Netzwerkanbindung und seine Betriebsparameter liegen.
Flux beschreibt danach, wie der freigegebene Kubernetes-Zustand aus Git oder
OCI im Cluster abgeglichen wird. Das zugehörige Muster steht in
[`Flux GitOps Pattern`](../../../docs/flux-gitops-pattern.md).

## Konfiguration

- Quelle: `environments/<environment>/<environment>.yaml`
- Abschnitte: `aks`, `used_for`, `costs`
- Abhängigkeiten: `network`, `shared-services`
- Outputs: `cluster`, `cost`, `used_for`, `governance`

Die wichtigsten Entscheidungen im Vertrag sind:

- private Cluster-Ausrichtung und interner Ingress-Pfad
- getrennte Nonproduction- und Production-Grenzen
- Node-Pool-Profile für Kosten, Verfügbarkeit und Workload-Zuordnung
- Monitoring-Bezug aus Shared Services
- Security- und Governance-Metadaten als Teil des Plattformvertrags
- Flux-Bootstrap als nachgelagerter GitOps-Schritt für Quellen,
  Kustomizations, Helm Releases, Health und Events

## Verwenden

```bash
./scripts/terraform-stack.sh validate aks nonproduction
./scripts/terraform-stack.sh init aks nonproduction
./scripts/terraform-stack.sh plan aks nonproduction
```

Pipeline-Consumer:

```yaml
terraform_root: terraform/stacks/aks
state_key: platform/aks/nonproduction.tfstate
```

Siehe [Terraform Pipeline Blueprint](../../../pipeline-blueprints/terraform/README.md).

## English Summary

This stack documents the AKS platform contract: cluster boundary, networking,
identity, security, ingress, node pools, cost profile, monitoring and
operations metadata. It resolves network and shared-services dependencies
through remote state, so AKS is modeled as part of the platform rather than as
an isolated cluster.

The current stack is an executable intent contract, not the cluster
provisioning implementation. Flux is modeled as the GitOps step after the AKS
boundary: Terraform defines where the cluster lives, while Flux later
reconciles approved Kubernetes state from Git or OCI into that cluster.
