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
- Least Privilege für Workloads und Automatisierung
- Getrennte Berechtigungen für Terraform- und Ansible-Pipelines
- Pipeline-Gates für Terraform, YAML, Kubernetes und
  Configuration-Management-Änderungen

In einer echten Umgebung würden zusätzlich Azure Policy, Defender for Cloud,
Private Endpoints, Managed Identities und zentrale Logging-/SIEM-Anbindung
bewertet.

## English

Security is treated as a platform responsibility in this repository:

- Network segmentation through subnets and routing
- Central edge access through Application Gateway/WAF
- Diagnostics and later checks through monitoring
- WAF rules, exclusions and managed-rule adjustments as configuration that
  stays visible in review
- Secret and certificate foundation through Key Vault
- No secrets in Git
- Least privilege for workloads and automation
- Separate permissions for Terraform and Ansible pipelines
- Pipeline gates for Terraform, YAML, Kubernetes and configuration-management
  changes

In a real environment, Azure Policy, Defender for Cloud, private endpoints, managed identities and central logging/SIEM integration would also be evaluated.
