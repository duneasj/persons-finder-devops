# Basic Dockerfile for Kotlin Spring Boot application
# Multi-stage build for Spring Boot Kotlin application
# Stage 1: Build stage

FROM openjdk:11-jdk-slim AS builder

WORKDIR /app

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

# Stage 2: Runtime stage
FROM openjdk:11-jre-slim

# Create non-root user for security
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Change ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

    # Run the application
CMD ["java", "-jar", "build/libs/*.jar"]
