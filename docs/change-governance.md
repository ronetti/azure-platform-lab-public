# Change Governance und Single Source of Truth / Change Governance and Single Source of Truth

## Ziel

Dieses Pattern beschreibt, wie Plattformänderungen nachvollziehbar bleiben.
Der Kern ist einfach: Konfiguration, Dokumentation und Änderungsverlauf liegen
versioniert im Repository. Das Repository ist damit die Single Source of Truth.
Änderungen sollen nicht im Portal, in lokalen Notizen oder in den Köpfen
einzelner Personen verschwinden.

## Purpose

This pattern describes how platform changes stay understandable later. The core
is simple: configuration, documentation and change history are versioned in the
repository. The repository is the single source of truth. Changes should not
disappear into the portal, local notes or individual people's heads.

## Versionierte Grundlage

Die gewünschte Plattformform soll aus versionierten Dateien ableitbar sein:

- YAML-Dateien beschreiben Umgebung, Solutions, Subnetze, Regeln, Backends und
  Workload-Intent.
- Terraform-Stacks interpretieren diese Konfiguration und erzeugen die
  Infrastruktur.
- Terraform Outputs und Remote State bilden die Übergabe zwischen Stacks.
- Ansible konsumiert veröffentlichte Outputs als Inventory-Quelle für
  VM-Konfiguration.
- README-Dateien erklären Zweck, Eingaben, Outputs und Betriebsgrenzen.
- Pattern-Dokumente halten Architekturentscheidungen und Betriebsmodelle fest.
- Changelogs dokumentieren relevante Änderungen und Migrationshinweise.

Damit bleibt das Repository die Single Source of Truth. Es gibt keine
versteckte Wahrheit in manuellen Portaleinstellungen, lokalen Notizen oder
einzelnen Personen.

## Versioned Foundation

The desired platform shape should be derivable from versioned files:

- YAML files describe environment, solutions, subnets, rules, backends and
  workload intent.
- Terraform stacks interpret this configuration and create the infrastructure.
- Terraform outputs and remote state form the handover between stacks.
- Ansible consumes published outputs as the inventory source for VM
  configuration.
- README files explain purpose, inputs, outputs and operational boundaries.
- Pattern documents capture architecture decisions and operating models.
- Changelogs document relevant changes and migration notes.

This keeps the repository as the single source of truth. It avoids hidden truth
in manual portal settings, local notes or individual people's heads.

## Review- und Approval-Modell

Plattformänderungen sollten über Pull Requests laufen:

- Änderung an YAML, Terraform, Kubernetes oder Doku
- automatische Validierung über Pipeline
- optional AI-assisted Review als zusätzliche Risiko- und Konsistenzprüfung
- Review durch fachlich passende Personen
- Approval für produktionsnahe Änderungen
- Merge erst nach erfolgreicher Validierung
- Changelog-Eintrag für relevante Änderungen

Dieses Modell macht Änderungen nachvollziehbar. Man sieht später, was geändert
wurde, wer geprüft hat und welche Pipeline gelaufen ist.

## Review and Approval Model

Platform changes should go through pull requests:

- change to YAML, Terraform, Kubernetes or documentation
- automatic validation through pipeline
- optional AI-assisted review as an additional risk and consistency check
- review by suitable subject-matter owners
- approval for production-like changes
- merge only after successful validation
- changelog entry for relevant changes

This model keeps changes understandable later. It shows what changed, who
checked it and which pipeline ran.

## Changelog-Prinzip

Changelogs helfen, technische Entwicklung nachvollziehbar zu halten. Sie sollten
nicht jede Kleinigkeit wiederholen, sondern relevante Änderungen erklären:

- neue Plattformfähigkeit
- Änderung an Netzwerk-, WAF- oder Firewall-Verhalten
- neue Konfigurationsoption
- Breaking Change
- Migration oder manuelle Nacharbeit
- relevante Betriebs- oder Security-Auswirkung

## Changelog Principle

Changelogs help keep technical evolution understandable later. They should not
repeat every small edit, but explain relevant changes:

- new platform capability
- change to network, WAF or firewall behavior
- new configuration option
- breaking change
- migration or manual follow-up
- relevant operational or security impact

## Release- Und Tag-Prinzip

Ein Merge nach `main` ist noch kein Release und erzeugt nicht automatisch einen
Tag. Tags und GitHub Releases werden nur für bewusst freigegebene Stände und
nach ausdrücklichem Auftrag erstellt.

Semantic Versioning braucht einen klar definierten öffentlichen Vertrag. In
diesem Repository ist das primär der konsumierbare Vertrag von
`.github/workflows/terraform-blueprint.yml`:

- `workflow_call`-Inputs
- erforderliche Berechtigungen und GitHub-Environment-Variablen
- dokumentiertes Check-, Validate-, Plan- und Apply-Verhalten
- Plan-Artefakt-, State- und Freigabegrenzen

Für diesen Vertrag gilt:

- `PATCH` kennzeichnet eine rückwärtskompatible Fehlerkorrektur.
- `MINOR` kennzeichnet neue rückwärtskompatible Funktionalität oder die
  Deprecation eines Teils des öffentlichen Vertrags.
- `MAJOR` kennzeichnet eine inkompatible Änderung des öffentlichen Vertrags.
- Reine Dokumentationsänderungen erzwingen keine neue Version.
- Ein bewusst veröffentlichter Dokumentations-Snapshot ist möglich; seine
  Version ist eine Projektentscheidung und folgt nicht automatisch aus
  Semantic Versioning.

Vor einem Release werden mindestens geprüft:

- `main` ist sauber und mit dem freigegebenen Remote-Stand synchron.
- Die relevante CI ist erfolgreich.
- Gepinnte Actions, Terraform und andere Werkzeuge werden anhand ihrer
  offiziellen Releases und Sicherheitshinweise auf Aktualität geprüft.
  Aktualisiert wird erst nach einer passenden Kompatibilitätsprüfung; eine
  bewusst beibehaltene ältere Version wird begründet.
- `CHANGELOG.md` ersetzt `Unreleased` durch Version und Datum und eröffnet bei
  weiterer Entwicklung wieder einen neuen `Unreleased`-Abschnitt.
- Der genaue Ziel-Commit und der Inhalt des Releases sind geprüft.
- Release-spezifische Tags wie `v1.0.0` werden nach Veröffentlichung nicht
  verschoben oder wiederverwendet.

GitHub unterscheidet zwischen Git-Tags und GitHub Releases. Ein Release basiert
auf einem Tag; ein normaler Tag ist dadurch nicht automatisch technisch
unveränderlich. Technische Unveränderlichkeit darf nur behauptet werden, wenn
sie durch GitHub-Einstellungen wie immutable Releases oder geeignete
Tag-Regeln tatsächlich erzwungen und geprüft ist.

Ein externer reusable Workflow kann über Branch, Release-Tag oder vollständigen
Commit-SHA referenziert werden. `main` ist kein stabiler Consumer-Vertrag. Ein
vollständiger Commit-SHA ist laut GitHub die sicherste Referenz für Stabilität
und Sicherheit. Ein Release-Tag bleibt als lesbare, bewusst freigegebene
Referenz zulässig; seine Schutz- und Änderungsgrenzen müssen dokumentiert und
verifiziert sein.

Referenzen:

- [Semantic Versioning 2.0.0](https://semver.org/)
- [GitHub: Reuse workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)
- [GitHub: About releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
- [GitHub: Immutable releases](https://docs.github.com/en/code-security/concepts/supply-chain-security/immutable-releases)

## Release And Tag Principle

A merge to `main` is not a release and does not automatically create a tag.
Tags and GitHub Releases are created only for deliberately approved states and
after an explicit request.

Semantic Versioning requires a clearly defined public contract. In this
repository, that contract is primarily the reusable interface of
`.github/workflows/terraform-blueprint.yml`:

- `workflow_call` inputs
- required permissions and GitHub Environment variables
- documented Check, Validate, Plan and Apply behavior
- plan-artifact, state and approval boundaries

For this contract:

- `PATCH` identifies a backward-compatible bug fix.
- `MINOR` identifies new backward-compatible functionality or deprecation of
  part of the public contract.
- `MAJOR` identifies an incompatible change to the public contract.
- Documentation-only changes do not require a new version.
- A deliberate documentation snapshot may be released, but its version is a
  project decision and is not automatically dictated by Semantic Versioning.

Before a release, at minimum:

- `main` is clean and synchronized with the approved remote state.
- Relevant CI has succeeded.
- Pinned actions, Terraform and other tools are checked against their official
  releases and security advisories. Updates follow suitable compatibility
  validation; a deliberately retained older version is justified.
- `CHANGELOG.md` replaces `Unreleased` with the version and date and opens a
  new `Unreleased` section when development continues.
- The exact target commit and release contents have been reviewed.
- Release-specific tags such as `v1.0.0` are not moved or reused after
  publication.

GitHub distinguishes Git tags from GitHub Releases. A release is based on a
tag; a normal tag is not automatically technically immutable. Technical
immutability is claimed only when GitHub settings such as immutable releases
or suitable tag rules actually enforce it and have been verified.

An external reusable workflow can be referenced through a branch, release tag
or full commit SHA. `main` is not a stable consumer contract. GitHub identifies
a full commit SHA as the safest reference for stability and security. A
release tag remains an allowed readable, deliberately approved reference, but
its protection and mutation boundaries must be documented and verified.

## Pipeline-Gates

Typische Gates:

- Terraform formatting
- Terraform validation
- YAML linting
- Kubernetes schema validation
- Configuration-management output checks
- optionale Policy- oder Security-Prüfungen
- manuelle Approval-Stufe für produktionsnahe Änderungen

Die Workflows vergeben `GITHUB_TOKEN`-Rechte ausdrücklich nach dem
Least-Privilege-Prinzip. Reine Validierung benötigt nur `contents: read`.
Checkout-Schritte behalten keine Git-Anmeldedaten, wenn der nachfolgende Job
keine authentifizierten Git-Befehle ausführen muss.

## Pipeline Gates

Typical gates:

- Terraform formatting
- Terraform validation
- YAML linting
- Kubernetes schema validation
- configuration-management output checks
- optional policy or security checks
- manual approval stage for production-like changes

Workflows grant `GITHUB_TOKEN` permissions explicitly according to least
privilege. Validation-only work needs only `contents: read`. Checkout steps do
not retain Git credentials when later steps do not require authenticated Git
commands.

## Repo-Bezug

- `.github/workflows/validate.yml` zeigt automatische Validierung.
- `environments/nonproduction/nonproduction.yaml` zeigt die zentrale
  Konfiguration als versionierte Quelle.
- `kubernetes/` zeigt Kubernetes-Konfiguration als versionierte Quelle.
- `terraform/stacks/configuration-management` zeigt Terraform Outputs als
  Inventory-Quelle für Ansible.
- `CHANGELOG.md` dokumentiert die Entwicklung dieses Repositories.
- `pipeline-blueprints/terraform/README.md` dokumentiert den konsumierbaren
  Workflow- und Versionsvertrag.
- `docs/availability-engineering.md` verbindet Changes mit SLI/SLO,
  Error Budget und Betriebsentscheidungen.

## Repository Mapping

- `.github/workflows/validate.yml` shows automatic validation.
- `environments/nonproduction/nonproduction.yaml` shows the central
  configuration as versioned source.
- `kubernetes/` shows Kubernetes configuration as versioned source.
- `terraform/stacks/configuration-management` shows Terraform outputs as an
  inventory source for Ansible.
- `CHANGELOG.md` documents the evolution of this repository.
- `pipeline-blueprints/terraform/README.md` documents the reusable workflow
  and versioning contract.
- `docs/availability-engineering.md` connects changes with SLI/SLO, error
  budgets and operational decisions.
