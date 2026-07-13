# Web Workload Blueprint

Dieser Kustomize-Blueprint ist der gemeinsame Workload-Vertrag:

- eigener Service Account ohne automatisch eingebundenes Token
- Deployment mit Non-Root-Security-Context, Ressourcen und Probes
- interner `ClusterIP` Service
- PodDisruptionBudget und HorizontalPodAutoscaler

Testing, Staging und Production verwenden denselben Blueprint und ändern nur
die environmentbezogene Ausprägung im jeweiligen Overlay.

```bash
kubectl kustomize kubernetes/environments/nonproduction/staging
kubectl kustomize kubernetes/environments/production
```

Das Beispielimage ist für das öffentliche Lab gepinnt. Eine reale
Production-Pipeline setzt einen freigegebenen Image-Digest aus der getrennten
Production-Registry.
