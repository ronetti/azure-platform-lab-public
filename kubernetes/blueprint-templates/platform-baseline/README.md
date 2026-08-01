# Platform Baseline Blueprint

Dieser Kustomize-Blueprint stellt die gemeinsamen Plattformvorgaben für jeden
Workload-Namespace bereit:

- Namespace mit Pod Security Standard `restricted`
- ResourceQuota und LimitRange
- Default-Deny für Ingress und Egress
- explizite Freigaben für DNS, Namespace-internen Verkehr und Managed Ingress

Environment-Overlays binden den Ordner als Resource ein und setzen dort Name,
Labels und Kapazitätswerte. Die Basis wird nicht in Testing, Staging oder
Production kopiert.

```bash
kubectl kustomize kubernetes/environments/nonproduction/testing
```

Direktes Apply dieses Basisordners ist nicht vorgesehen, weil erst das
Environment-Overlay die konkrete Ownership und Umgebung festlegt.
