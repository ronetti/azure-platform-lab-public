# Security-Check-Ausnahmen

Dieses Verzeichnis ist der zentrale, reviewbare Vertrag für Ausnahmen aus
Infrastructure-as-Code-Scannern. Die Trennung je Tool folgt dem gleichen
Prinzip wie in den Arbeits-Repositories:

| Datei | Scanner |
| --- | --- |
| `checkov_exceptions.txt` | Checkov |
| `terrascan_exceptions.txt` | Terrascan |
| `tflint_exceptions.txt` | TFLint |
| `tfsec_exceptions.txt` | tfsec |

Eine leere Datei bedeutet: Für dieses Tool ist keine Ausnahme genehmigt.
Ausnahmen werden nicht vorsorglich eingetragen.

## Format

```text
RULE_ID # reason=<Begründung>; owner=<Team>; expires=YYYY-MM-DD
```

Jede aktive Zeile braucht:

- genau eine Rule-ID
- eine fachlich oder technisch nachvollziehbare Begründung
- einen verantwortlichen Owner
- ein Ablaufdatum für die erneute Prüfung

Kommentare beginnen mit `#`. Wildcards und unbegründete dauerhafte
Ausnahmen sind nicht zulässig.

Die lokale Action `.github/actions/security-exceptions` validiert diesen
Vertrag und stellt die Rule-IDs als kommagetrennte Outputs für Scanner-Schritte
bereit. Damit verwenden alle Pipeline-Templates dieselbe Quelle.
