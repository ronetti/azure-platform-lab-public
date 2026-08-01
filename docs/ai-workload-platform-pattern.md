# AI Workload Platform Pattern

## Ziel

Dieses Pattern beschreibt den nächsten Ausbauschritt des Portfolios:
Kubernetes nicht nur mit AI im Review-Prozess zu verbinden, sondern als
Plattformunterbau für AI-Workloads zu denken.

Das ist bewusst ein eigener Bereich. [AI-assisted Platform Governance](ai-assisted-platform-governance.md)
prüft Änderungen im Delivery-Loop. Dieses Dokument beschreibt dagegen, welche
Plattformfragen entstehen, wenn ein Team Modelle auf AKS bereitstellen oder
Inference-Workloads betreiben möchte.

Der aktuelle Stand ist ein modellierter Plattformvertrag. Es werden keine
GPU-Ressourcen provisioniert, kein Modell veröffentlicht und keine
produktive Inference-Plattform behauptet.

Ich habe mich bewusst für diesen ersten Schnitt entschieden, weil AI-
Infrastruktur sehr schnell teuer und missverständlich werden kann. Ein echter
GPU-Nodepool sieht im Repository vielleicht beeindruckender aus, wäre aber ohne
Quota, Kostenfreigabe, Zielmodell, Betriebsmetriken und Deployment-Gates kein
sauberer Nachweis. Mir ist wichtiger, zuerst die Grenzen richtig zu schneiden:
Was gehört in AKS, was gehört in einen Model- oder Artefaktprozess, was gehört
in den Secret Store, und was muss vor Production explizit freigegeben werden?

## Warum Das Relevant Ist

AI-Workloads sind teuer, empfindlich gegenüber falschem Scheduling und
sicherheitsrelevant. Ein GPU-Nodepool ist nicht einfach nur ein weiterer
Nodepool. Er verändert Kosten, Kapazitätsplanung, Upgrade-Verhalten,
Observability, Image-Vertrauen, Model-Artefakte und Zugriffsgrenzen.

Für mich gehört deshalb zuerst der Vertrag geklärt:

- Welche Workloads brauchen wirklich GPU-Kapazität?
- Welche Teile laufen besser auf CPU oder einem verwalteten AI-Dienst?
- Wie wird verhindert, dass Testing-Kosten dauerhaft laufen?
- Welche Modelle, Images und Artefakte dürfen in Production verwendet werden?
- Wie werden Secrets, Model-Artefakte und Runtime-Identitäten getrennt?
- Welche Metriken zeigen, ob Inference gesund, langsam oder zu teuer ist?
- Wer darf GPU-Kapazität anfordern, skalieren oder in Production freigeben?

Ich beginne hier also nicht mit „wir brauchen GPU“, sondern mit der Frage, ob
die Plattform die Folgen eines GPU-Workloads überhaupt kontrollieren kann. Das
ist dieselbe Denkweise wie bei Terraform State, Secrets oder Production-
Trennung: Erst Source of Truth, Ownership, Kosten- und Fehlergrenze klären,
dann Kapazität einschalten.

## Plattformgrenzen

Ein AI-Workload braucht dieselben Plattformfragen wie andere Workloads, aber
mit engeren Kosten- und Sicherheitsgrenzen:

- eigener Workload-Blueprint für Inference statt kopierter YAMLs
- optionaler GPU-Nodepool-Intent im AKS-Vertrag
- Taints, Tolerations und Node Selector für gezieltes Scheduling
- Resource Requests und Limits inklusive GPU-Ressourcen
- Model-Image oder Model-Artefakt nur aus freigegebener Quelle
- Secrets außerhalb von Git, zum Beispiel über Key Vault oder External Secrets
- Monitoring für Latenz, Fehlerrate, Sättigung, Restarts und GPU-Nutzung
- klare Promotion-Regeln von Testing/Staging nach Production

Production darf dabei nicht einfach die Nonproduction-GPU teilen. Für
Production braucht es eine eigene Kosten-, Identity-, Secret-, Registry-,
Monitoring- und Approval-Grenze.

Ich habe den AI-Workload bewusst nicht in den bestehenden Web-Workload-
Blueprint hineingemischt. Ein Web-Workload und ein Inference-Workload haben
andere Risiken: GPU-Scheduling, Model-Load-Zeit, Artefaktfreigabe, sensible
Prompts oder Eingabedaten, höhere Kosten und andere Sättigungssignale. Wenn
man das in denselben Blueprint drückt, wirkt es einfacher, aber die wirklich
wichtigen Grenzen werden unscharf.

## AKS GPU Nodepool Intent

In diesem Repository wird GPU-Kapazität nur als Intent modelliert:

```text
AKS cluster
  -> system nodepool
  -> regular user nodepool
  -> optional ai-gpu nodepool
       -> taint: workload.azure-lab.io/ai-inference=true:NoSchedule
       -> labels: workload-class=ai-inference, accelerator=gpu
       -> min_count=0 in Nonproduction
       -> explicit approval before Production
```

Der wichtige Punkt ist nicht, sofort teure GPU-Knoten zu starten. Der wichtige
Punkt ist, dass die Plattform vorab weiß, wie GPU-Workloads isoliert,
geplant, gemessen und freigegeben werden.

`min_count: 0` in Nonproduction ist deshalb Absicht. Testing und Staging
sollen zeigen können, wie ein AI-Workload eingeordnet wird, ohne dass dauerhaft
GPU-Kosten laufen. Production bleibt ebenfalls modelliert und braucht vor
echter Kapazität eine bewusste Freigabe. Für mich ist das die ehrliche
Reihenfolge: erst Vertrag und Reviewbarkeit, dann echte Kapazität.

## Inference Blueprint

Der Blueprint unter
[`kubernetes/blueprint-templates/inference-workload`](../kubernetes/blueprint-templates/inference-workload/README.md)
zeigt den Kubernetes-Vertrag für einen Inference-Workload:

- eigener Service Account ohne automatisch gemountetes Token
- Non-Root-Ausführung
- Probes
- CPU-, Memory- und GPU-Ressourcen
- Node Selector und Toleration für GPU-Nodes
- Service als interner `ClusterIP`
- PDB und HPA als Availability- und Skalierungsrahmen

Der Blueprint wird bewusst noch nicht von den Environment-Overlays konsumiert.
Damit bleibt klar: Das Pattern ist vorbereitet, aber noch kein freigegebener
Deployment-Pfad.

Ich habe auch bewusst keinen KServe-, KAITO- oder anderen Controller als
implementiert eingetragen. Dafür müsste zuerst entschieden werden, welcher
Serving-Ansatz zum Ziel passt, wie Modelle versioniert werden, wie Rollback bei
fachlich falschen Antworten aussieht und welche Observability wirklich
verfügbar ist. Ohne diese Entscheidungen wäre ein Controller nur ein weiterer
Baustein, aber noch kein betreibbares Plattformmuster.

## Kosten Und Betrieb

GPU-Kapazität ist ein Kostentreiber. Für Nonproduction ist deshalb `min_count:
0` der sinnvolle Startpunkt. Testing oder Staging dürfen GPU-Kapazität nur bei
konkretem Bedarf aktivieren. Production wird nicht durch Spot-Kapazität
verbilligt, solange Verfügbarkeit und Release-Risiko nicht bewertet sind.

Wichtige Betriebsfragen:

- Wie wird GPU-Auslastung sichtbar?
- Welche Latenz ist für Inference akzeptabel?
- Was passiert bei Image-Pull-, Model-Load- oder GPU-Scheduling-Fehlern?
- Wie wird verhindert, dass alte Modelle weiterlaufen?
- Wie sieht Rollback aus, wenn ein Modell fachlich falsche Ergebnisse liefert?
- Welche Logs dürfen gespeichert werden, ohne sensible Prompts oder Daten zu
  veröffentlichen?

## Status In Diesem Portfolio

Implementiert:

- AI-Workload-Platform-Pattern als Dokumentation
- modellierter GPU-Nodepool-Intent in den AKS-Environment-Verträgen
- Inference-Workload-Blueprint als Kustomize-Basis

Nicht implementiert:

- reale GPU-Nodepool-Provisionierung
- KServe, KAITO oder anderer Inference-Controller
- Modell-Deployment-Pipeline
- produktive Model Registry oder Model Promotion
- echte GPU-Metriken aus einem laufenden Cluster

Das ist absichtlich so getrennt. Ich möchte nicht behaupten, dass eine
produktive AI-Plattform läuft. Ich möchte zeigen, welche Fragen ich kläre,
bevor GPU-Workloads teuer und schwer kontrollierbar werden.

Für mich ist genau das der Wert des Patterns: Es zeigt nicht nur, dass ich
„AI“ in ein Repository schreiben kann. Es zeigt, dass ich AI-Infrastruktur wie
Plattformarbeit behandle: Kosten begrenzen, Scheduling kontrollieren, Secrets
trennen, Artefakte freigeben, Betriebssignale definieren und Production nicht
aus Versehen von einem Experiment abhängig machen.

## English Summary

This pattern separates two AI topics. AI-assisted governance improves the
delivery and review loop. AI workload infrastructure is the platform layer for
running model or inference workloads on AKS.

The current repository models the first responsible slice: GPU nodepool intent,
an inference workload blueprint, scheduling boundaries, cost controls,
secrets, observability and production approval boundaries. It does not claim a
running GPU cluster, KServe installation, model registry or production
inference platform.

The decision is deliberate: model the platform contract before enabling costly
GPU capacity. AI inference has different operational risks than a normal web
workload, including scheduling, model artifacts, sensitive input, latency,
saturation and rollback behavior. The repository therefore keeps AI workload
infrastructure separate from AI-assisted governance and labels the current
state as modeled, not provisioned.

## References

- [Microsoft: Use GPUs on Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/use-nvidia-gpu)
- [Microsoft Architecture Center: Use AKS to host GPU-based workloads](https://learn.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks-gpu/gpu-aks)
- [Microsoft: Best practices for cost optimization in AKS](https://learn.microsoft.com/en-us/azure/aks/best-practices-cost)
- [OWASP Top 10 for LLM Applications](https://owasp.org/www-project-top-10-for-large-language-model-applications/)
