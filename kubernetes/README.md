# Kubernetes Platform Blueprints

## Meine Denkweise

Kubernetes ist in diesem Repository keine isolierte Sammlung von YAML-Dateien.
Es ist eine Plattformschicht mit denselben Fragen wie Netzwerk, Terraform oder
Configuration Management. Für mich beginnt Kubernetes nicht bei der Frage, wie
viele Manifeste vorhanden sind, sondern ob der gewünschte Zustand, die
Verantwortungsgrenzen und die Betriebsfolgen klar sind:

- Welche Schicht wird gerade aufgebaut?
- Was ist gewünschter Zustand und was ist tatsächlicher Zustand?
- Wo endet Plattformverantwortung und wo beginnt Workload-Verantwortung?
- Welche Änderung ist Konfiguration und welche verändert die Architektur?
- Wie werden Sicherheit, Kosten und Betrieb vor dem Deployment sichtbar?

Das folgt der praktischen Kubernetes-Lab-Arbeit: erst Kontext, Verbindung und
Voraussetzungen prüfen, dann automatisieren, danach den Zustand mit `get`,
`describe`, Events und Logs verifizieren. Dieses Muster übertrage ich hier auf
AKS-Blueprints: gewünschter Zustand in Git, Rendering vor Apply, klare
Security- und Ressourcen-Grenzen und eine Prüfung, die mehr zeigt als nur
`kubectl apply` ohne Fehler.

## Schichten

```text
Terraform AKS intent
  -> Platform Baseline Blueprint
  -> Web Workload Blueprint
  -> Nonproduction or Production
  -> Workload Overlay
  -> rendered desired state
  -> Flux reconciliation
  -> cluster reconciliation
```

Der Netzwerkpfad bleibt in beiden Subscription-Grenzen gleich, die Ressourcen
werden jedoch nicht geteilt:

```text
Application Gateway/WAF
  -> interner AKS Web App Routing Ingress
  -> ClusterIP Service
  -> Workload Pod
```

`blueprint-templates/platform-baseline` enthält den Vertrag, den die Plattform
jedem Namespace mitgibt: Pod Security, Quotas, Limits und Network Policies.

`blueprint-templates/web-workload` zeigt den Vertrag, den ein Team konsumiert:
Non-Root-Ausführung, Probes, Ressourcen, PDB, HPA und interner Service.

`environments` verändert nur die Ausprägung. Testing, Staging und Production
kopieren die Blueprints nicht. Testing und Staging sind getrennte Namespaces
auf demselben Nonproduction-Cluster; Production läuft in einer eigenen
Umgebung. Production teilt weder Cluster, Netzwerk, Identitäten, Secrets,
Registry noch Monitoring mit Nonproduction.

## Kosten- und Verfügbarkeitsprofil

| Umgebung | Nutzung | Grundlast | Spot | Absicht |
|---|---|---:|---|---|
| Nonproduction | Testing | gemeinsam | unterbrechbare Workloads | schnelles Feedback |
| Nonproduction | Staging | gemeinsam, 1 regulärer User-Node | optional | produktionsnahe Prüfung und Blue-Green-Probe |
| Production | Production | 2 System, 2 User, zonenverteilt | nein | Blue-Green mit Freigabe und schnellem Rollback |

Das sind Architektur- und Betriebsentscheidungen, keine berechneten
Kosteneinsparungen. Reale Optimierung braucht Azure-Kostendaten und
Auslastungsmetriken. Blue-Green verdoppelt während eines Releases die
betreffende Workload-Kapazität, nicht die gesamte Umgebung.

## Rendern ist der Plan

Wie `terraform plan` zeigt `kubectl kustomize` zuerst den gewünschten Zustand,
ohne ihn anzuwenden:

```bash
kubectl kustomize kubernetes/environments/nonproduction
kubectl kustomize kubernetes/environments/production
```

Nonproduction rendert Testing und Staging gemeinsam. Für eine gezielte
Änderungsprüfung kann ein einzelnes Overlay gerendert werden:

```bash
kubectl kustomize kubernetes/environments/nonproduction/testing
```

Erst in einer echten, freigegebenen Umgebung folgt:

```bash
kubectl apply -k kubernetes/environments/nonproduction/testing
```

In einem GitOps-Betriebsmodell ist dieser manuelle Apply nicht der Zielzustand.
CI rendert und validiert die Overlays vor dem Merge. Nach dem Merge kann Flux
den freigegebenen Zustand aus Git als `Kustomization` oder `HelmRelease`
abgleichen. Genau das ist für mich der wichtige Punkt: Git ist nicht nur
Ablage, sondern die Source of Truth. Der Cluster muss zeigen, ob er diesen
Zustand erreichen kann.

## Prüfen

```bash
kubectl get namespace workload-testing
kubectl get all -n workload-testing
kubectl get networkpolicy -n workload-testing
kubectl describe deployment web-workload -n workload-testing
kubectl get events -n workload-testing --sort-by=.lastTimestamp
```

Mit Flux kommen zusätzliche Betriebsprüfungen dazu:

```bash
flux get sources git
flux get kustomizations
flux reconcile kustomization workload-testing
kubectl describe kustomization workload-testing -n flux-system
```

Merksätze:

- Erst Kontext und Verbindung, dann Apply.
- Rendern zeigt den gewünschten Zustand.
- Flux gleicht den freigegebenen Git-Zustand im Cluster ab.
- `get` zeigt den Überblick, `describe` erklärt Abweichungen, Logs zeigen die
  Anwendungsperspektive.
- Secrets gehören nicht in Blueprints oder Environment-Overlays.
- Die Ingress-Dateien referenzieren TLS-Secrets nur namentlich. Zertifikate und
  Secret-Inhalte werden über einen freigegebenen externen Prozess geliefert.
- Testing und Staging sparen durch gemeinsam genutzte Plattformdienste,
  Laufzeitsteuerung und kleine Grundlast.
- Production spart durch Messung und Rightsizing, nicht durch das Entfernen
  von Redundanz.

## Status

Die Blueprints und Environment-Overlays sind implementiert und werden in CI
gerendert sowie gegen Kubernetes-Schemas validiert. Damit zeigt dieses
Repository Kubernetes als prüfbaren Plattformvertrag: Namespaces,
NetworkPolicies, Pod Security, Quotas, Limits, Probes, HPA, PDB und
environment-spezifische Overlays sind versioniert und renderbar.

Der AKS-Stack modelliert die Cluster- und Plattformentscheidungen bewusst als
Terraform-Intent: Netzwerk, Security, Node Pools, Kostenprofil,
Monitoring-Bezug und Environment-Grenzen. Blue-Green ist als Delivery-Ziel
beschrieben; die Overlays verwenden aktuell RollingUpdate, bis eine Pipeline
oder ein Rollout-Controller den Traffic-Wechsel zuverlässig übernimmt.

Flux ist die geplante GitOps-Schicht zwischen diesen Blueprints und einem
laufenden Cluster. Er ersetzt nicht Review und CI. Er beantwortet die
Betriebsfrage nach dem Merge: Was läuft im Cluster wirklich, was ist gesund,
wo gibt es Drift und welcher Zustand kommt aus Git? Das zugehörige Muster
steht in [Flux GitOps Pattern](../docs/flux-gitops-pattern.md).

Das öffentliche Beispielimage verwendet einen festen Tag. Eine reale
Production-Pipeline müsste stattdessen ein freigegebenes Image per Digest aus
der eigenen Production-Registry einsetzen; diese Delivery-Pipeline ist hier
nicht implementiert.

## English Summary

This repository treats Kubernetes as a platform layer, not as a loose
collection of YAML files. The blueprints define namespace, network, pod
security, quota, limit, probe, HPA and PDB defaults. Testing and staging are
rendered as separate namespaces in nonproduction, while production keeps its
own platform boundary.

CI renders and validates the desired state before merge. Flux is the planned
GitOps layer after merge: it pulls the approved Git state into the cluster and
shows whether the cluster can reach that state through status, events, health
and drift signals. AKS is modeled as Terraform intent; the cluster deployment
itself remains a separate integration step.
