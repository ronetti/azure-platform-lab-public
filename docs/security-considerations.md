# Security Considerations / Sicherheitsüberlegungen

## Deutsch

Security wird in diesem Repository als Plattformaufgabe verstanden:

- Netzwerksegmentierung über Subnetze und Routing
- Zentraler Edge-Zugriff über Application Gateway/WAF
- Diagnose- und Auditierbarkeit über Monitoring
- WAF-Regeln, Exclusions und Managed-Rule-Anpassungen als Konfiguration, die
  im Review sichtbar bleibt
- Secret- und Zertifikatsbasis über Key Vault
- Keine Secrets in Git
- TLS am Edge und am internen Kubernetes-Ingress; Zertifikate und Secret-Werte
  werden außerhalb des Repositories bereitgestellt
- Flux darf nur den freigegebenen GitOps-Scope abgleichen. Secrets bleiben
  verschlüsselt oder werden über externe Secret-Provider wie Azure Key Vault
  bereitgestellt.
- Least Privilege für Workloads und Automatisierung
- Getrennte Berechtigungen für Terraform- und Ansible-Pipelines
- Pipeline-Gates für Terraform, YAML, Kubernetes und
  Configuration-Management-Änderungen
- GitHub-Actions-Deployments mit Entra OIDC statt langlebiger Client-Secrets
- getrennte Plan- und Apply-Identitäten sowie geschützte Production-Environments
- Microsoft Entra ID, OIDC und Workload Identity als AKS-Identitätsmodell
- Key Vault CSI als Zielpfad für Workload-Secrets
- Pod Security Standard `restricted`, Default-Deny-NetworkPolicies und
  deaktivierte automatische Service-Account-Tokens

In einer echten Umgebung würden zusätzlich Azure Policy, Defender for Cloud,
Private Endpoints, Managed Identities und zentrale Logging-/SIEM-Anbindung
bewertet.

Die Blueprints enthalten keine Client IDs, Tokens, Zertifikate oder
Secret-Werte. Environment-Overlays dürfen nur nicht-sensitive Referenzen
enthalten. Die konkrete Verbindung zwischen Kubernetes Service Account und
Managed Identity wird erst in einer freigegebenen Umgebung aufgebaut.

Ich habe Secrets bewusst nicht in Blueprints, YAML-Dateien oder
Environment-Overlays abgelegt, weil sie dort aus meiner Sicht nicht
hingehören. Konfiguration beschreibt den gewünschten Plattformzustand.
Passwörter, Zertifikate und Tokens sind dagegen vertrauliche Betriebsdaten und
brauchen einen eigenen Schutzraum. Dafür ist ein Secret Store wie Azure Key
Vault der richtige Ort: verschlüsselte Ablage, zentrale Verwaltung, gezielte
RBAC-Berechtigungen und kontrollierte Bereitstellung über Managed Identities
oder Workload Identities.

Diese Trennung reduziert das Risiko, Secrets versehentlich in Git zu
versionieren. Gleichzeitig können Zugriffe begrenzt und Secrets rotiert werden,
ohne Blueprints oder Environment-Konfigurationen umzuschreiben. Für mich ist
das eine klare Verantwortungsgrenze: Das Repository beschreibt die Plattform,
der Secret Store verwaltet vertrauliche Daten.

## Environment-Trennung

Testing und Staging dürfen innerhalb von Nonproduction kostenintensive
Plattformressourcen teilen. Diese Freigabe endet vollständig an der
Production-Grenze.

Production verwendet eigene:

- Subscription- und Pipeline-Berechtigungen
- Terraform-State-Resource-Group und eigenen State-Storage
- Netzwerke, Routing, Firewall und Edge
- AKS-Cluster und Workload Identities
- Key Vault, Secrets und Zertifikate
- Container Registry
- Monitoring- und Logging-Ziele

Production konsumiert keinen Nonproduction-Remote-State und besitzt keine
Runtime-Abhängigkeit auf Testing oder Staging. Zwischen den Grenzen darf nur
ein geprüftes, unveränderliches Artefakt kontrolliert übernommen werden.
Gemeinsamer Terraform-Code und gemeinsame Blueprint-Templates sind
Quellcode-Wiederverwendung, keine gemeinsam betriebenen Ressourcen.

## English

Security is treated as a platform responsibility in this repository:

- Network segmentation through subnets and routing
- Central edge access through Application Gateway/WAF
- Diagnostics and later checks through monitoring
- WAF rules, exclusions and managed-rule adjustments as configuration that
  stays visible in review
- Secret and certificate foundation through Key Vault
- No secrets in Git
- TLS at the edge and internal Kubernetes ingress; certificates and secret
  values are delivered outside the repository
- Flux may only reconcile the approved GitOps scope. Secrets stay encrypted or
  are provided through external secret providers such as Azure Key Vault.
- Least privilege for workloads and automation
- Separate permissions for Terraform and Ansible pipelines
- Pipeline gates for Terraform, YAML, Kubernetes and configuration-management
  changes
- GitHub Actions deployments with Entra OIDC instead of long-lived client secrets
- separate plan and apply identities with protected production environments
- Microsoft Entra ID, OIDC and Workload Identity as the AKS identity model
- Key Vault CSI as the intended workload secret path
- restricted Pod Security, default-deny network policies and disabled
  automatic service-account tokens

A real environment also requires evaluation of Azure Policy, Defender for
Cloud, private endpoints, managed identities and central logging or SIEM
integration.

The blueprints do not contain client IDs, tokens, certificates or secret
values. Environment overlays may contain only non-sensitive references. Secrets
are operational data, not platform configuration. They belong in a protected
secret store such as Azure Key Vault, where encryption, RBAC, managed identity
access and rotation can be controlled without changing the repository.
