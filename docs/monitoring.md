# Monitoring / Observability

## Deutsch

Die Monitoring-Basis kombiniert Azure Monitor / Log Analytics mit VM-,
Kubernetes- und Prometheus/Grafana-Denken.

Wichtige Signale:

- Ressourcenverfügbarkeit
- VM-Verfügbarkeit und Betriebssystemmetriken
- CPU-, Memory- und Storage-Auslastung
- über Ansible-Pipelines vorbereitete Services oder Exporter auf VMs
- SQL-nahe Signale wie Dienstverfügbarkeit, Verbindungen, Fehlerzustände und
  Backup- oder Job-Status
- Application-Gateway-Fehlerraten und Latenzen
- WAF-Blocks, WAF-Matches und auffällige Request-Muster
- Kubernetes Pod Restarts und Deployment Availability
- Readiness- und Liveness-Probe-Fehler
- Kubernetes-Ressourcenverbrauch gegen Requests und Limits
- Firewall-, Routing- und Netzwerkereignisse
- Fehlende oder fehlerhafte Diagnostic Settings
- SLI-relevante Signale wie Erfolgsrate, Latenz, Fehlerrate und
  Verfügbarkeit

Monitoring soll nicht nur Daten sammeln, sondern handlungsrelevante Hinweise
liefern. Für kritische Application-Gateway- oder WAF-Ereignisse kann eine Azure
Function Alerts aus Log Analytics entgegennehmen und über einen Teams Webhook
an das Betriebsteam weiterleiten.

Für VM-basierte Workloads war das Zielbild breiter: Agenten oder Exporter
liefern Betriebssystem-, Service- und SQL-nahe Signale an Prometheus/Grafana
oder Log Analytics. Mail- und Teams-Webhooks können daraus Benachrichtigungen
machen. Eine spätere Self-Healing-Anbindung sollte kontrolliert über definierte
Automatisierung laufen, zum Beispiel über Ansible-Tasks oder Runbooks, nicht
als unkontrollierter Automatismus direkt aus einem Alert heraus.

Für Patches und Updates ist der wichtigste Punkt die Erkennbarkeit: Wenn ein
Update eine VM, einen Service oder eine SQL-nahe Komponente beschädigt, muss
der Fehler in Metriken, Logs oder Health Checks sichtbar werden. Ein Alert kann
dann über Action Group, Webhook, Azure Function oder Logic App eine
Benachrichtigung auslösen und bei Bedarf eine Pipeline starten. Diese Pipeline
sollte mit Parametern wie Solution, Umgebung und Fehlerart laufen und für
kritische Schritte ein Approval erzwingen.

SLIs sollten so gewählt werden, dass daraus SLOs und Error Budgets abgeleitet
werden können. Damit wird sichtbar, ob eine Plattformänderung sicher
ausgeliefert werden kann oder ob zuerst Stabilisierung notwendig ist.

## English

The monitoring baseline combines Azure Monitor / Log Analytics with VM,
Kubernetes and Prometheus/Grafana thinking.

Important signals:

- Resource availability
- VM availability and operating-system metrics
- CPU, memory and storage saturation
- services or exporters prepared on VMs through Ansible pipelines
- SQL-related signals such as service availability, connections, error states
  and backup or job status
- Application Gateway error rates and latency
- WAF blocks, WAF matches and suspicious request patterns
- Kubernetes pod restarts and deployment availability
- readiness and liveness probe failures
- Kubernetes resource usage compared to requests and limits
- Firewall, routing and network events
- Missing or broken diagnostic settings
- SLI-relevant signals such as success rate, latency, error rate and
  availability

Monitoring should not only collect data, but provide actionable signals. For
critical Application Gateway or WAF events, an Azure Function can receive alerts
from Log Analytics and forward actionable notifications to the operations team
through a Teams webhook.

For VM-based workloads, the target model was broader: agents or exporters
provide operating-system, service and SQL-related signals to Prometheus/Grafana
or Log Analytics. Mail and Teams webhooks can turn those signals into
notifications. A later self-healing integration should be controlled through
defined automation, for example Ansible tasks or runbooks, not as an
uncontrolled action directly from an alert.

For patches and updates, the most important point is detectability: if an
update breaks a VM, service or SQL-related component, the failure has to become
visible in metrics, logs or health checks. An alert can then use an Action
Group, webhook, Azure Function or Logic App to send a notification and, if
needed, start a pipeline. That pipeline should run with parameters such as
solution, environment and failure type, and require approval for critical
steps.

SLIs should be selected so that SLOs and error budgets can be derived from
them. This makes it visible whether a platform change can be shipped safely or
whether stabilization should come first.
