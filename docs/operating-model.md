# Betriebsmodell / Operating Model

## Deutsch

Eine Plattform ist nicht nur eine Sammlung von Azure-Ressourcen. Sie braucht ein
klares Betriebsmodell:

- Wer verantwortet Netzwerk, Security, Monitoring und Plattformdienste?
- Wie werden Änderungen geplant, geprüft und deployed?
- Wie werden Incidents erkannt, priorisiert und nachbereitet?
- Wie werden Umgebungen reproduzierbar aufgebaut?
- Welche Teile dürfen Teams selbst konfigurieren?
- Wo liegt die nachvollziehbare Quelle für Konfiguration und Entscheidungen?
- Welche SLIs, SLOs und Error Budgets steuern Verfügbarkeitsentscheidungen?
- Welche Änderungen benötigen Pipeline-Gates und Approvals?
- Wo endet Terraform, und wo beginnt Ansible-Konfigurationsmanagement?

Das Ziel ist ein Modell, in dem Teams Infrastruktur nutzen können, ohne jedes
Detail selbst neu bauen zu müssen. Routineänderungen sollen über
Konfigurationsdateien erfolgen, während Reviews, Pipelines und Approvals die
Qualität und Nachvollziehbarkeit absichern. Changelogs dokumentieren relevante
Plattformänderungen und machen die Entwicklung über Zeit nachvollziehbar.
Terraform bleibt für Infrastruktur und Remote-State-Outputs verantwortlich.
Ansible wird getrennt ausgeführt und nutzt veröffentlichte Terraform Outputs
als Inventory-Quelle.

Für mich gehört dazu auch eine proaktive Fehlerkultur. Möglichst viel sollte
prüfbar, wiederholbar und automatisierbar sein, weil manuelle Arbeit gerade in
komplexen Plattformen schnell fehleranfällig wird. Wenn trotzdem etwas
schiefgeht, braucht es RCA und blameless RCA: nicht um Schuld zu suchen,
sondern um zu verstehen, welche Annahme, welcher Prozess oder welche technische
Grenze verbessert werden muss. Diese Zeit lohnt sich, weil jedes gute Learning
die Plattform später stabiler und leichter betreibbar macht.

## English

A platform is not only a collection of Azure resources. It needs a clear
operating model:

- Who owns networking, security, monitoring and platform services?
- How are changes planned, checked and deployed?
- How are incidents detected, prioritized and reviewed afterwards?
- How are environments created reproducibly?
- Which parts can teams configure themselves?
- Where is the understandable source for configuration and decisions?
- Which SLIs, SLOs and error budgets guide availability decisions?
- Which changes require pipeline gates and approvals?
- Where does Terraform end, and where does Ansible configuration management
  begin?

The goal is a model where teams can consume infrastructure without rebuilding
every detail from scratch. Routine changes should happen through configuration
files, while reviews, pipelines and approvals protect quality and traceability.
Changelogs document relevant platform changes and make evolution over time
understandable.
Terraform remains responsible for infrastructure and remote-state outputs.
Ansible runs separately and consumes published Terraform outputs as its
inventory source.

That also includes a proactive learning culture. As much as possible should be
checkable, repeatable and automatable, because manual work becomes error-prone
in complex platforms. When something still goes wrong, RCA and blameless RCA
are used to understand which assumption, process or technical boundary needs
improvement, not to assign blame. Those learnings make the platform more stable
and easier to operate over time.
