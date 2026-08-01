# Flux GitOps Pattern

## Warum Flux In Dieses Modell Gehört

In diesem Repository liegt der gewünschte Kubernetes-Zustand bereits in Git:
Kustomize-Bases, Environment-Overlays, Security Defaults, NetworkPolicies,
Quotas, Limits, Probes, HPA und PDB. Was noch fehlte, war die Schicht, die
diesen gewünschten Zustand im Cluster immer wieder mit dem tatsächlichen
Zustand vergleicht.

Genau an dieser Stelle gehört Flux in mein Plattformmodell. Nicht als
zusätzliches Tool, weil noch ein Tool fehlt, sondern weil sonst eine wichtige
Betriebsfrage offen bleibt: Wer merkt später, ob der Cluster noch das fährt,
was in Git freigegeben wurde?

Für mich schließt Flux die Lücke zwischen:

```text
Pull Request
  -> Review und CI-Validierung
  -> Merge nach main
  -> Git als gewünschter Zustand
  -> Flux Reconciliation im Cluster
  -> Status, Events, Health und Drift-Sichtbarkeit
```

Damit wird Kubernetes-Betrieb weniger abhängig von manuellen `kubectl apply`-
Läufen. Die Änderung entsteht im Repository, wird vor dem Merge geprüft und
wird danach vom Cluster abgeholt. Wenn der Cluster den Zustand nicht erreicht,
muss das als Status, Event oder Health-Problem sichtbar werden.

## Welche Frage Flux Beantwortet

Ohne GitOps bleibt nach dem Rendern eine offene Betriebsfrage:

> Wer sorgt dauerhaft dafür, dass der tatsächliche Clusterzustand wieder zum
> gewünschten Zustand aus Git passt?

Flux beantwortet diese Frage mit pull-basierter Reconciliation. Der Cluster
kennt seine Quellen, holt Änderungen aus Git oder anderen unterstützten
Quellen, baut die Kustomize- oder Helm-Konfiguration und wendet sie an. Wenn
jemand manuell im Cluster ändert, ist das keine zweite Wahrheit. Die
Abweichung wird beim nächsten Reconcile sichtbar oder zurückgeführt, abhängig
vom gewählten Vertrag.

Das passt zu meiner Arbeitsweise: Die Wahrheit liegt nicht im Portal, nicht in
alten Tickets und nicht nur im Kopf einzelner Personen. Sie liegt versioniert
in Git, und der Cluster zeigt über Status und Events, ob er diesen Zustand
erreichen kann.

## Flux Im Plattform-Schnitt

Ich würde Flux nicht in den Terraform-Root-Stack hineinmischen, der den
AKS-Cluster beschreibt. Das sind zwei verschiedene Verantwortungen.

Terraform verantwortet die Cluster- und Plattformbasis:

- Netzwerk und private Cluster-Grenze
- Identitäten und Berechtigungsrahmen
- Node Pools und Kostenprofil
- Monitoring-Anbindung
- optional erste Bootstrap-Voraussetzungen

Flux übernimmt danach den Kubernetes-Zustand:

- `GitRepository` oder `OCIRepository` als Quelle
- `Kustomization` für Platform Baseline, Workload-Blueprints und Overlays
- `HelmRelease` für helm-basierte Plattformkomponenten
- Dependencies zwischen Platform Baseline und Workloads
- Health Checks, Events und Reconcile-Status
- optional Image Automation, wenn Image-Updates bewusst über Git laufen sollen

Die Grenze ist wichtig: Terraform erzeugt den Ort, an dem Kubernetes läuft.
Flux hält den Kubernetes-Zustand in diesem Ort aktuell. Wenn diese Grenze
unsauber wird, weiß später niemand mehr, ob ein Problem aus der
Cluster-Basis, aus der Workload-Konfiguration oder aus dem GitOps-Abgleich
kommt.

## Vorgeschlagene Repo-Struktur

Für dieses Portfolio reicht eine kleine, verständliche Flux-Struktur. Ich
würde nicht mit einer großen GitOps-Fleet-Architektur starten, bevor die
einfachen Fragen beantwortet sind: Welche Quelle? Welcher Pfad? Welcher
Scope? Welche Rechte? Welche Health-Prüfung?

```text
kubernetes/
  flux/
    clusters/
      nonproduction/
        flux-system/
        platform-baseline.yaml
        testing.yaml
        staging.yaml
      production/
        flux-system/
        platform-baseline.yaml
        production.yaml
    sources/
      platform-repository.yaml
```

Die vorhandenen Blueprints bleiben dort, wo sie sind:

```text
kubernetes/blueprint-templates/
kubernetes/environments/
```

Flux referenziert diese Pfade als gewünschte Zustände. Die Blueprint-Logik
wird nicht kopiert. Sonst entsteht wieder genau das Problem, das ich vermeiden
will: dieselbe Wahrheit an mehreren Stellen.

## Nonproduction Und Production

Testing und Staging bleiben getrennte Namespaces in Nonproduction. Flux kann
sie als getrennte `Kustomization`-Objekte abgleichen:

- `platform-baseline`
- `workload-testing`
- `workload-staging`

Production bekommt eine eigene Flux-Grenze:

- eigener Cluster oder eigene Production-Plattformgrenze
- eigene `Kustomization`
- eigene Secrets-/Identity-Anbindung
- strengere Approval- und Image-Promotion-Regeln vor dem Merge

Flux ersetzt dabei nicht die Review-Gates. Production wird nicht sicherer, nur
weil ein Controller etwas automatisch anwendet. Sicher wird es erst, wenn der
freigegebene Zustand vorher geprüft ist und der Cluster danach sichtbar zeigt,
ob er diesen Zustand erreicht.

## Secrets Und Identitäten

Secrets gehören nicht als Klartext in Git. Das ist für mich keine
Geschmacksfrage, sondern eine harte Grenze. Für Flux kommen deshalb nur
geschützte Muster infrage:

- SOPS-verschlüsselte Kubernetes-Secrets mit klarer Key-Ownership
- External Secrets gegen Azure Key Vault
- AKS Workload Identity oder Managed Identity für Laufzeit-Zugriffe
- getrennte Berechtigungen für Flux-System, Platform Baseline und Workloads

Ich trenne hier bewusst Plattformkonfiguration von vertraulichen
Betriebsdaten. Git beschreibt, welcher Secret-Name, welcher Zugriffspfad oder
welche Identity gebraucht wird. Das eigentliche Geheimnis liegt nicht im
Blueprint, nicht im Overlay und nicht in einer unverschlüsselten YAML-Datei,
sondern in einem dafür vorgesehenen Secret Store. So kann ein Team Rotation,
Zugriff und Bereitstellung steuern, ohne den Plattformvertrag zu verändern.

Wichtig ist die gleiche Frage wie bei Terraform State: Wer darf welche
Wahrheit lesen oder verändern? Flux braucht nur die Rechte, die für den
jeweiligen Scope notwendig sind. Ein GitOps-Controller darf nicht aus
Bequemlichkeit zum allgemeinen Cluster-Admin werden.

## Warum Nicht Nur GitHub Actions Apply

GitHub Actions ist stark für Validierung, Tests, Plan-Artefakte, Reviews und
Promotion. Aber ein Pipeline-Lauf sieht nur einen Zeitpunkt. Kubernetes lebt
danach weiter. Deshalb ist ein dauerhafter Reconcile-Loop im Cluster
wertvoll:

- GitHub Actions sieht den Merge-Zeitpunkt.
- Flux sieht fortlaufend, ob der Clusterzustand zum Git-Zustand passt.
- GitHub Actions kann Rendern und Schema validieren.
- Flux kann Health, Drift, Events und Abhängigkeiten im Cluster auswerten.

Ich habe Flux deshalb nicht als Ersatz für GitHub Actions ergänzt, sondern als
zweite Verantwortung. GitHub Actions beantwortet vor dem Merge die Frage: Ist
diese Änderung technisch korrekt, geprüft und freigegeben? Mit einem reinen
`kubectl apply` endet der Prozess nach dem Deployment. Ob der Cluster Stunden
oder Tage später noch dem freigegebenen Zustand entspricht, überwacht die
Pipeline nicht dauerhaft.

Flux beantwortet die andere Betriebsfrage: Entspricht der tatsächliche
Clusterzustand noch dem gewünschten Zustand aus Git? Wenn jemand manuell im
Cluster ändert oder Drift entsteht, erkennt Flux diese Abweichung und führt
den Zustand je nach Vertrag zurück oder macht den Unterschied sichtbar. Für
mich entsteht genau dadurch ein sauberes Modell: Delivery und kontinuierliche
Reconciliation sind getrennt, arbeiten aber zusammen.

Ich würde deshalb beides kombinieren:

```text
CI vor Merge:
  kubectl kustomize
  kubeconform
  Policy-/Security-Prüfungen

Flux nach Merge:
  Source pull
  Kustomization build
  Apply
  Health check
  Events und Reconcile-Status
```

## Betriebsfragen

Flux muss selbst betrieben werden. Sonst verschiebt man nur Verantwortung von
`kubectl apply` zu einem Controller, den niemand beobachtet. Dazu gehören:

- Wer darf Flux-Kustomizations ändern?
- Wie werden Reconcile-Fehler sichtbar?
- Wohin gehen Events und Alerts?
- Wie wird Flux selbst aktualisiert?
- Wie wird ein fehlerhafter Commit zurückgenommen?
- Wann wird eine Kustomization suspendiert?
- Wie verhindert man, dass Image Automation ungewollt Production verändert?

Diese Fragen sind Teil des Plattformvertrags. GitOps ist nicht „einmal Flux
installieren“, sondern ein Betriebsmodell für gewünschten und tatsächlichen
Zustand. Für mich ist genau das der Punkt: GitOps ist nur dann gut, wenn ein
Team später versteht, was passiert, wenn der Abgleich fehlschlägt.

## Umsetzungsstand In Diesem Portfolio

Die Kubernetes-Blueprints und Environment-Overlays sind bereits renderbar und
werden in CI validiert. Flux ist der nächste logische GitOps-Layer darauf:
Cluster Bootstrap, Quellen, Kustomizations, Health Checks und Events.

Die aktuelle Arbeitsprobe dokumentiert damit bewusst den Plattformweg:

```text
Blueprints in Git
  -> CI-validierter gewünschter Zustand
  -> Flux als geplanter Reconciliation-Layer
  -> späterer Clusterzustand mit Status, Events und Drift-Sichtbarkeit
```

## Referenzen

- [Flux Documentation](https://fluxcd.io/flux/)
- [Flux Core Concepts](https://fluxcd.io/flux/concepts/)
- [Flux Get Started](https://fluxcd.io/flux/get-started/)
- [Flux Kustomization](https://fluxcd.io/flux/components/kustomize/kustomizations/)
- [Flux Security](https://fluxcd.io/flux/security/)

## English Summary

Flux is the GitOps layer that connects approved Kubernetes desired state in Git
with the running cluster. CI validates Kustomize overlays and policy checks
before merge; Flux then pulls the approved source, applies Kustomization or
HelmRelease objects and exposes status, events, health and drift.

GitHub Actions and Flux have different responsibilities. GitHub Actions answers
whether a change is valid, reviewed and allowed to be delivered. Flux answers
whether the cluster still matches the approved Git state hours or days later.
That separates delivery from continuous reconciliation.

I keep the responsibility boundary explicit: Terraform defines the AKS
platform foundation, while Flux manages Kubernetes state after the cluster
exists. Secrets stay outside plain Git through protected patterns such as SOPS,
External Secrets, Azure Key Vault or workload identity. Flux does not replace
review, CI or production approval. It answers the operational question after
merge: which state came from Git, what is healthy, where is drift, and what
needs investigation.
