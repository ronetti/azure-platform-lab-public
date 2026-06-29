# Observability-Notizen / Observability Notes

## Deutsch

Diese Notizen verbinden zwei Perspektiven:

- Azure Monitor und Log Analytics für Infrastruktur, Plattformressourcen und
  Diagnoseeinstellungen
- Prometheus und Grafana für VM- und Kubernetes-nahe Metriken, Dashboards und
  Alerting

Wichtige Signale:

- Verfügbarkeit von Plattformressourcen
- VM-Verfügbarkeit und Betriebssystemmetriken
- Services oder Exporter, die über Ansible-Pipelines auf VMs vorbereitet
  werden
- SQL-nahe Signale wie Dienstverfügbarkeit, Verbindungen, Fehlerzustände und
  Backup- oder Job-Status
- Application-Gateway-Fehlerraten und Latenzen
- Firewall-, Routing- und Netzwerkereignisse
- Kubernetes Pod Restarts
- Deployment Availability
- CPU-, Memory- und Storage-Sättigung
- Fehlende Diagnostic Settings
- SLI-relevante Signale wie Erfolgsrate, Latenz, Fehlerrate und
  Deployment Availability
- Error-Budget-Verbrauch als Signal für Stabilisierung vor Feature-Rollout

Das Zielbild war nicht nur Dashboarding. VM-Agenten, Exporter, SQL-Signale,
Prometheus/Grafana, Log Analytics sowie Mail- und Teams-Webhooks sollten so
zusammenspielen, dass daraus später auch automatisierte Reaktionen möglich
werden. Self-Healing wäre dabei nicht direkt im Monitoring versteckt, sondern
würde kontrolliert über definierte Automatisierung laufen, zum Beispiel über
Ansible-Tasks oder Runbooks.

Ein technisch einfacher und realistischer Ablauf wäre:

```text
VM / SQL / Service / Application Gateway
        |
        v
Agent, Exporter oder Diagnostic Setting
        |
        v
Prometheus Alertmanager oder Azure Monitor Alert
        |
        v
Action Group / Webhook / Azure Function / Logic App
        |
        v
Mail oder Teams-Benachrichtigung
        |
        v
Ansible-, Update- oder Restore-Pipeline mit Guardrails und Approval
```

Der Alert stößt dabei nicht blind eine Reparatur an. Die Zwischenlogik prüft,
welche Solution betroffen ist, ob gerade ein Patch oder Update lief, welche
Recovery Points verfügbar sind und ob ein automatisierter Schritt erlaubt ist.
Bei einfachen Fällen kann eine Ansible-Pipeline einen Service prüfen oder neu
starten. Bei fehlgeschlagenen Updates muss eine Restore-Pipeline die komplette
Multi-Tier-Solution wieder konsistent herstellen.

## English

These notes combine two perspectives:

- Azure Monitor and Log Analytics for infrastructure, platform resources and diagnostic settings
- Prometheus and Grafana for VM- and Kubernetes-related metrics, dashboards and alerting

Important signals:

- Platform resource availability
- VM availability and operating-system metrics
- services or exporters prepared on VMs through Ansible pipelines
- SQL-related signals such as service availability, connections, error states
  and backup or job status
- Application Gateway error rates and latency
- Firewall, routing and network events
- Kubernetes pod restarts
- Deployment availability
- CPU, memory and storage saturation
- Missing diagnostic settings
- SLI-relevant signals such as success rate, latency, error rate and
  deployment availability
- Error budget consumption as a signal for stabilization before feature rollout

The target model was not only dashboarding. VM agents, exporters, SQL signals,
Prometheus/Grafana, Log Analytics and email or Teams notifications should work
together so automated reactions can be added later. Self-healing would not be
hidden inside monitoring directly; it would be controlled through defined
automation, for example Ansible tasks or runbooks.

A technically simple and realistic flow would be:

```text
VM / SQL / Service / Application Gateway
        |
        v
Agent, exporter or diagnostic setting
        |
        v
Prometheus Alertmanager or Azure Monitor alert
        |
        v
Action Group / Webhook / Azure Function / Logic App
        |
        v
Email or Teams notification
        |
        v
Ansible, update or restore pipeline with guardrails and approval
```

The alert should not blindly repair the environment. The intermediate logic
checks which solution is affected, whether a patch or update was running, which
recovery points are available and whether an automated step is allowed. For
simple cases, an Ansible pipeline can check or restart a service. For failed
updates, a restore pipeline has to bring back the complete multi-tier solution
in a consistent state.
