### 1. 🐳 Containerization
1.  **The Prompt:** "I asked ChatGPT: create basic dockerfile for kotlin spring application
FROM eclipse-temurin:11-jre
WORKDIR /app
COPY build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
2.  **The Flaw:** "It gave me 
- a deployment running as `root`
- no multi-stage build features
- no health check
- image not as secure as possible

I added multi-stage build and changed imge used:
# Basic Dockerfile for Kotlin Spring Boot application
# Multi-stage build for Spring Boot Kotlin application
# Stage 1: Build stage

FROM eclipse-temurin:11-jdk-alpine AS builder

Copied gradlew, gradle/, build.gradle.kts, settings.gradle.kts, src/ from project root to /app and made gradlew executable and built the application
# Copy gradle wrapper
COPY gradlew ./
COPY gradle/ gradle/

# Copy build files
COPY build.gradle.kts settings.gradle.kts ./

# Make gradlew executable
RUN chmod +x ./gradlew

# Copy source code
COPY src/ src/

# Build the application
RUN ./gradlew build -x test

I added a runtime stage to the Dockerfile to run the application as a non-root user for security,used the built jar file from the builder stage and copied it to the runtime stage, set the entrypoint to run the jar file using a smaller runtime image.Also added health check.

# Stage 2: Runtime stage
FROM eclipse-temurin:11-jre-alpine

# Create non-root user for security
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy the built JAR from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

    # Run the application
CMD ["java", "-jar", "app.jar"]

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

Added security context to deployment.yaml for pod-level security to run as non-root user and group for better security.
securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        runAsGroup: 1000
        fsGroup: 1000

Also added container-level security context to deployment.yaml for additional security:
securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop:
    - ALL

Non-root execution with restricted capabilities provides defense in depth against privilege escalation attacks.
Read-only filesystem prevents malicious code from writing to the container's filesystem.
No capability drops means the container has minimal required permissions.
No privilege escalation allows the container to run with the least privileges necessary.

Added TLS termination configuration to ingress.yaml for secure HTTPS communication.
Lines 7-14 added TLS configuration with SSL redirect and certificate management.
Lines 16-21 added TLS secret configuration for certificate storage.


