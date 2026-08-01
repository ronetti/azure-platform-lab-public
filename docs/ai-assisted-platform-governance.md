# AI-Assisted Platform Governance

## Warum Dieses Pattern Dazu Gehört

AI gehört für mich nicht als Marketing-Schicht in eine Plattform, sondern als
zusätzliche Prüfebene dort, wo viele wiederkehrende Entscheidungen entstehen:
Terraform, Kubernetes, YAML-Konfiguration, Pipeline-Regeln, Security-Hinweise
und Betriebsstandards.

Der wichtigste Punkt ist die Grenze: Ein AI Agent ersetzt keine technische
Verantwortung. Er kann Reviews vorbereiten, Risiken markieren und immer wieder
dieselben Standards prüfen. Die Entscheidung, ob eine Änderung richtig,
vertretbar und produktionsnah freigegeben ist, bleibt beim verantwortlichen
Team.

## Rolle Des AI Agents

Ein AI-assisted Review kann vor dem Merge helfen, typische Plattformrisiken
früher sichtbar zu machen:

- Secrets, Tokens oder vertrauliche Werte im Code
- fehlende oder zu breite RBAC-/IAM-Berechtigungen
- fehlende Resource Requests, Limits, Probes oder NetworkPolicies
- unklare Environment-Grenzen zwischen Nonproduction und Production
- Terraform-State-, Remote-State- oder Output-Abhängigkeiten
- unvollständige Diagnostic Settings, Logging- oder Alerting-Anbindung
- ungepinnte Actions, Images oder Abhängigkeiten
- Änderungen ohne passenden Runbook-, Rollback- oder RCA-Bezug

Damit wird der Review nicht automatisch richtig, aber gleichmäßiger. Der Agent
fragt jedes Mal nach denselben Dingen, auch wenn Menschen unter Zeitdruck
stehen oder Kontext fehlt.

## Harte Und Weiche Gates

Nicht jedes AI-Finding sollte ein Deployment blockieren. Für mich braucht es
zwei Kategorien:

- **Harte Gates:** klare Regelverstöße wie Secrets im Repository, verbotene
  Klartext-Werte, fehlende Production-Freigabe oder nicht erlaubte
  Cross-Environment-Abhängigkeiten.
- **Weiche Hinweise:** Architektur-, Betriebs- oder Wartbarkeitsrisiken, die
  ein Mensch bewerten muss, zum Beispiel zu breite Zuständigkeiten, fehlende
  Runbook-Schritte oder unklare Ownership.

Diese Trennung ist wichtig. Sonst wird AI entweder ignoriert, weil sie zu viel
blockiert, oder gefährlich überschätzt, weil ein grüner Hinweis wie eine
Freigabe wirkt.

## Security-Grenzen Für AI

AI selbst braucht Guardrails:

- keine Secrets, Tokens, State-Dateien oder produktiven Konfigurationen als
  Eingabe
- Least Privilege für Repository-, Pipeline- und Cloud-Zugriffe
- keine automatischen Production-Änderungen ohne separates Approval
- nachvollziehbare Findings mit Datei, Regel, Begründung und möglichem
  Rückweg
- Schutz gegen Prompt Injection und manipulierte externe Inhalte
- Validierung von generiertem Code durch Tests, Linting, Policy Checks und
  menschliches Review

Gerade bei AI ist Overreliance ein reales Risiko. Ein plausibel formulierter
Vorschlag ist noch kein geprüfter Plattformzustand. Deshalb muss ein Agent in
denselben Review-, Logging- und Verantwortungsrahmen eingebunden werden wie
andere Automatisierung auch.

## Einordnung In Dieses Repository

In diesem Portfolio ist AI-assisted Governance als Pattern beschrieben, nicht
als produktiv angebundener Agent. Das passt zum bestehenden Plattformmodell:

```text
Pull Request
  -> klassische Checks: fmt, lint, validate, schema, security exceptions
  -> AI-assisted Review: Risiko-, Kontext- und Konsistenzprüfung
  -> menschliches Review und Approval
  -> Merge
  -> Flux/Reconciliation oder freigegebener Apply-Prozess
```

Die AI-Schicht darf dabei keine zweite Source of Truth werden. Git bleibt die
Quelle für Konfiguration, Entscheidungen und Änderungsverlauf. Der Agent liest
diese Quelle, kommentiert Risiken und hilft beim Prüfen. Er ersetzt nicht die
bestehenden Plattformregeln.

## Warum Das Zu Meiner Arbeitsweise Passt

Ich möchte Plattformen so bauen, dass sie im Betrieb weniger unnötige
Handarbeit erzeugen. Menschen können sehr gute Entscheidungen treffen, aber
kein Mensch denkt in jedem Moment an alle Abhängigkeiten. Wiederholbare Checks,
klare Gates, Runbooks und AI-assisted Reviews helfen, Fehler früher zu sehen
und Qualität gleichmäßiger zu machen.

Für mich ist AI deshalb kein Ersatz für Engineering, sondern ein Werkzeug für
bessere Engineering-Disziplin: proaktiv prüfen, Risiken sichtbar machen, aus
Incidents lernen und die Plattform danach weiter verbessern.

## English Summary

AI-assisted platform governance uses an AI agent as an additional review layer
for infrastructure and platform changes. It can inspect Terraform, Kubernetes,
YAML, pipelines, security signals and operational standards before merge.

The agent does not replace accountability. It creates findings, highlights
risks and makes reviews more consistent. Critical changes still need human
review, approval boundaries and production validation.

AI itself needs guardrails: no secrets or production state as input, least
privilege, prompt-injection awareness, traceable findings and validation of any
generated code through normal tests, policy checks and review.

## References

- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework)
- [NIST AI RMF Core: Govern, Map, Measure, Manage](https://airc.nist.gov/airmf-resources/airmf/5-sec-core/)
- [OWASP Top 10 for LLM Applications](https://owasp.org/www-project-top-10-for-large-language-model-applications/)
- [Microsoft Responsible AI principles and approach](https://www.microsoft.com/en-us/ai/principles-and-approach/)
- [Microsoft: Defend against indirect prompt injection attacks](https://learn.microsoft.com/en-us/security/zero-trust/sfi/defend-indirect-prompt-injection)
