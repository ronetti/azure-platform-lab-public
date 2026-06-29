# Plattform-Runbook / Platform Runbook

## Erste Prüfung

Zuerst wird eingegrenzt, welche Schicht betroffen ist: Azure-Ressourcen, Netzwerk, Kubernetes, Anwendung oder Monitoring.

```bash
az account show
az group list --output table
kubectl get nodes -o wide
kubectl get pods -A
kubectl get events -A --sort-by=.lastTimestamp
```

## First Checks

First identify which layer is affected: Azure resources, networking, Kubernetes, application or monitoring.

```bash
az account show
az group list --output table
kubectl get nodes -o wide
kubectl get pods -A
kubectl get events -A --sort-by=.lastTimestamp
```

## Terraform-Prüfung

```bash
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform validate
terraform -chdir=terraform plan
```

Prüfen auf:

- Drift zwischen Code und Umgebung
- Fehlende Variablen
- Nicht gesetzte Provider-Konfiguration
- Änderungen an Netzwerk, Routing oder Security-Regeln

Nach einem Restore zusätzlich prüfen:

- Hat der Restore Terraform Drift erzeugt?
- Stimmen State, Konfiguration und tatsächliche Ressourcen wieder zusammen?
- Sind Outputs, IPs, Namen und Zuordnungen weiterhin erklärbar?

## Terraform Checks

```bash
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform validate
terraform -chdir=terraform plan
```

Look for:

- Drift between code and environment
- Missing variables
- Missing provider configuration
- Changes to networking, routing or security rules

After a restore, additionally check:

- Did the restore create Terraform drift?
- Do state, configuration and actual resources match again?
- Are outputs, IPs, names and assignments still explainable?

## Restore-Prüfung

Prüfen:

- Ist die VM der richtigen Azure Backup Policy zugeordnet?
- Wann lief die letzte erfolgreiche Sicherung?
- Passt die Aufbewahrung der Recovery Points zur Anforderung?
- Wurde der erwartete Recovery Point für den Restore genutzt?
- Wurde der Restore-Ablauf vollständig geloggt?
- Welche Schritte haben am längsten gedauert?
- Passt die gemessene Dauer zum RTO?
- Passt das Datenverlustfenster zum RPO?
- Ist die Solution danach fachlich wieder im erwarteten Zustand?
- Wurde nach dem Restore ein Terraform Plan gegen Drift geprüft?

## Restore Checks

Check:

- Is the VM assigned to the correct Azure Backup policy?
- When did the last successful backup run?
- Does recovery point retention fit the requirement?
- Was the expected recovery point used for restore?
- Was the restore flow logged end to end?
- Which steps took the longest?
- Does the measured duration fit the RTO?
- Does the data-loss window fit the RPO?
- Is the solution back in the expected functional state afterwards?
- Was a Terraform plan run after restore to check for drift?

## Kubernetes-Workload Nicht Bereit

```bash
kubectl get deployment -n demo
kubectl get pods -n demo -l app=sample-app
kubectl describe pod -n demo -l app=sample-app
kubectl logs -n demo -l app=sample-app --tail=100
```

Häufige Ursachen:

- Image-Pull-Fehler
- Fehlgeschlagene Readiness- oder Liveness-Probes
- Fehlende Config oder Secrets
- Zu wenig CPU oder Memory
- Probleme beim Volume Mount

## Kubernetes Workload Not Ready

```bash
kubectl get deployment -n demo
kubectl get pods -n demo -l app=sample-app
kubectl describe pod -n demo -l app=sample-app
kubectl logs -n demo -l app=sample-app --tail=100
```

Common causes:

- Image pull errors
- Failed readiness or liveness probes
- Missing config or secrets
- Insufficient CPU or memory
- Volume mount problems

## Kubernetes-Guardrails Prüfen

Prüfen:

- Läuft der Container ohne Root-Rechte?
- Sind CPU- und Memory-Requests gesetzt?
- Sind Limits gesetzt?
- Gibt es Readiness- und Liveness-Probes?
- Ist der Service nur so offen wie nötig?
- Sind Secrets außerhalb von Git verwaltet?
- Gibt es eine passende Namespace- und Ownership-Kennzeichnung?

## Kubernetes Guardrail Checks

Check:

- Does the container run without root privileges?
- Are CPU and memory requests set?
- Are limits set?
- Are readiness and liveness probes configured?
- Is the service exposed only as much as needed?
- Are secrets managed outside Git?
- Is namespace and ownership labeling present?

## Ansible-Konfigurationsprüfung

Prüfen:

- Wurde das Inventory aus Terraform Outputs generiert?
- Läuft die Ansible-Pipeline getrennt von Terraform?
- Sind `ansible-lint`, Syntax Check und Check Mode erfolgreich?
- Gibt es ein Approval vor produktiven Änderungen?
- Wurde eine Änderung im Changelog oder in der passenden README dokumentiert?

## Ansible Configuration Checks

Check:

- Was the inventory generated from Terraform outputs?
- Does the Ansible pipeline run separately from Terraform?
- Did `ansible-lint`, syntax check and check mode pass?
- Is there an approval before production changes?
- Was the change documented in the changelog or the matching README?

## Monitoring-Prüfung

```bash
az monitor log-analytics workspace list --output table
kubectl top nodes
kubectl top pods -A
```

Fragen:

- Kommen Logs und Metriken an?
- Ist die Störung in Metriken sichtbar?
- Liefern VM-Agenten oder Exporter noch Daten?
- Sind SQL-nahe Signale wie Dienststatus, Verbindungen oder Jobs auffällig?
- Gibt es fehlende Diagnostic Settings?
- Wurde eine Mail- oder Teams-Benachrichtigung ausgelöst?
- Ist der Alert handlungsrelevant?
- Welcher SLI ist betroffen?
- Wird ein SLO verletzt?
- Wird Error Budget verbraucht?
- Darf ein Self-Healing-Schritt über Ansible oder Runbook angestoßen werden?
- Lief gerade ein Patch, Update oder Deployment für diese Solution?
- Muss eine Update-, Ansible- oder Restore-Pipeline mit Approval gestartet
  werden?

## Monitoring Checks

```bash
az monitor log-analytics workspace list --output table
kubectl top nodes
kubectl top pods -A
```

Questions:

- Are logs and metrics arriving?
- Is the incident visible in metrics?
- Are VM agents or exporters still sending data?
- Are SQL-related signals such as service status, connections or jobs unusual?
- Are diagnostic settings missing?
- Was a mail or Teams notification triggered?
- Is the alert actionable?
- Which SLI is affected?
- Is an SLO being violated?
- Is error budget being consumed?
- May a self-healing step be triggered through Ansible or a runbook?
- Was a patch, update or deployment running for this solution?
- Does an update, Ansible or restore pipeline with approval need to be started?

## Nachbereitung Nach Einem Incident

Nach einer Störung dokumentieren:

- Was ist fehlgeschlagen?
- Welche Schicht war betroffen?
- Wodurch wurde es erkannt?
- Welche Auswirkung gab es?
- Was war die Ursache?
- Was war der Sofortfix?
- Welche präventive Maßnahme folgt?
- Welches Error Budget wurde verbraucht?
- Wurden RTO oder RPO überschritten?
- Hat die Backup-Policy zur tatsächlichen Recovery-Anforderung gepasst?
- Hat der Restore Drift erzeugt oder verhindert?
- Muss ein Review-, Approval- oder Pipeline-Gate angepasst werden?

## Incident Follow-Up

After an incident, record:

- What failed?
- Which layer was affected?
- What detected it?
- What was the impact?
- What was the root cause?
- What was the immediate fix?
- What preventive action follows?
- Which error budget was consumed?
- Were RTO or RPO exceeded?
- Did the backup policy fit the actual recovery requirement?
- Did the restore create or prevent drift?
- Does a review, approval or pipeline gate need to be adjusted?
