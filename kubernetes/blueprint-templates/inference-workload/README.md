# Inference Workload Blueprint

Dieser Blueprint modelliert eine Kubernetes-Basis für AI-Inference-
Workloads. Er wird noch nicht von den Environment-Overlays konsumiert und
stellt keine produktive Modellplattform dar.

Ich habe dafür bewusst einen eigenen Blueprint angelegt. Inference ist für
mich kein normales Web-Deployment mit anderem Image. GPU-Scheduling,
Model-Load-Zeit, Artefaktfreigabe, sensible Eingaben, höhere Kosten und andere
Betriebssignale müssen getrennt betrachtet werden. So bleiben die Grenzen sichtbar
und werden nicht im vorhandenen Web-Blueprint versteckt.

Er zeigt die Plattformfragen, die vor einem echten AI-Workload geklärt sein
müssen:

- Scheduling auf dafür vorgesehene AI-/GPU-Nodes
- Taints und Tolerations gegen versehentliche Platzierung
- CPU-, Memory- und GPU-Ressourcen als klare Vorgabe
- Non-Root-Ausführung und kein automatisch gemountetes Service-Account-Token
- interne Service-Grenze
- Probes, PDB und HPA als betriebliche Absicherung
- Model-Image nur als Platzhalter für ein später freigegebenes Artefakt

Das eigentliche Modell, Secrets, Credentials und produktive Prompts gehören
nicht in diesen Blueprint. Sie müssen über freigegebene Artefakte, Secret
Stores, Identities und Deployment-Gates angebunden werden.

Der Blueprint ist deshalb noch nicht in Testing, Staging oder Production
eingebunden. Erst müssen Model-Artefakt, Registry, Secrets, Observability,
Kostenfreigabe und Rollback-Verhalten geklärt sein. Danach kann aus dem
Blueprint ein echter Deployment-Pfad werden.

## English Summary

This blueprint models the Kubernetes baseline for AI inference workloads. It
is not wired into the environment overlays yet and does not claim a production
model-serving platform. It focuses on scheduling, resource boundaries, security
defaults, internal service exposure and operational readiness.

It is separated from the web workload blueprint because inference has different
operational risks: GPU scheduling, model artifact approval, model load time,
sensitive inputs, cost control and rollback behavior.
