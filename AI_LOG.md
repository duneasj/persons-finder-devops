### 1. 🐳 Containerization
1.  **The Prompt:** "I asked ChatGPT: create basic dockerfile for kotlin spring application
2.  **The Flaw:** "It gave me 
- a deployment running as `root`
- no multi-stage build features
no health check
3.  **The Fix:** "I added multi-stages one for build and one for runtime, added health check, appuser and changed runtime image to openjdk:11-jre-slim for smaller size"

### 2. ☁️ Infrastructure as Code (Kubernetes/Terraform)
1.  **The Prompt:** "I asked ChatGPT: create basic K8s manifests
2.  **The Flaw:** "It gave me no 
- Resource limits
- Health checks
- Autoscaling
- Security contexts
- TLS termination
3.  **The Fix:** "I added resources to deployment.yaml" Appended the below code block lines 28-34 to fix resource limits:
resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"

This ensures the container has appropriate resource allocation and prevents resource exhaustion.

I added health checks to the deployment.yaml file to monitor the application's health and ensure it is running correctly. Lines 35-50 added liveness and readiness probes.
livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 30
          timeoutSeconds: 10
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3

Gives app 60s to start up before liveness probe begins and checks every 30s and will restart container if it fails 3 times.
For the readiness probe, it gives app 30s to start up and checks every 10s with 5s timeout and will fail after 3 attempts.

Created hpa.yaml for horizontal pod autoscaling. The scaling configuration is:
- Min replicas: 1
- Max replicas: 5
- CPU threshold: 70% utilization
- Memory threshold: 80% utilization
The HPA will automatically scale up or downthe deployment based on CPU (>70%) or Memory (>80%) utilization.