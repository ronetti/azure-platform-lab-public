# Kubernetes Platform Blueprints

## Meine Denkweise

Kubernetes ist in diesem Repository keine isolierte Sammlung von YAML-Dateien.
Es ist eine weitere Plattformschicht mit denselben Fragen wie Netzwerk,
Terraform oder Configuration Management:

- Welche Schicht wird gerade aufgebaut?
- Was ist gewünschter Zustand und was ist tatsächlicher Zustand?
- Wo endet Plattformverantwortung und wo beginnt Workload-Verantwortung?
- Welche Änderung ist Konfiguration und welche verändert die Architektur?
- Wie werden Sicherheit, Kosten und Betrieb vor dem Deployment sichtbar?

Das folgt dem Lernmuster aus dem persönlichen k3s-Lab: erst Voraussetzungen
und Verbindungen prüfen, dann automatisieren, danach den Zustand mit `get`,
`describe` und Logs verifizieren.

## Schichten

```text
Terraform AKS intent
  -> Platform Baseline Blueprint
  -> Web Workload Blueprint
  -> Nonproduction or Production
  -> Workload Overlay
  -> rendered desired state
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

## Prüfen

```bash
kubectl get namespace workload-testing
kubectl get all -n workload-testing
kubectl get networkpolicy -n workload-testing
kubectl describe deployment web-workload -n workload-testing
kubectl get events -n workload-testing --sort-by=.lastTimestamp
```

Merksätze:

- Erst Kontext und Verbindung, dann Apply.
- Rendern zeigt den gewünschten Zustand.
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
gerendert sowie gegen Kubernetes-Schemas validiert. Der AKS-Stack bleibt ein
sichtbar gekennzeichneter Deployment-Intent und provisioniert noch keinen
Cluster. Blue-Green ist ebenfalls als Ziel beschrieben; die Overlays verwenden
aktuell RollingUpdate, bis eine Pipeline oder ein Rollout-Controller den
Traffic-Wechsel zuverlässig übernimmt.

Das öffentliche Beispielimage verwendet einen festen Tag. Eine reale
Production-Pipeline müsste stattdessen ein freigegebenes Image per Digest aus
der eigenen Production-Registry einsetzen; diese Delivery-Pipeline ist hier
nicht implementiert.
