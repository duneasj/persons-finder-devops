# Basic Kubernetes Deployment

## Files Created:
- `deployment.yaml` - Basic deployment with 1 replica
- `service.yaml` - ClusterIP service for internal access
- `secret.yaml` - Secret for OPENAI_API_KEY
- `ingress.yaml` - Basic ingress for external access

## Deployment:
```bash
kubectl apply -f k8s-basic/
```

## Note:
This is a basic deployment without:
- Resource limits
- Health checks
- Autoscaling
- Security contexts
- TLS termination
