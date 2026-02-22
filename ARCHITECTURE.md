# 🛡️ PII Egress Security Architecture

## Current Risk
The Persons Finder app sends user PII (names, bios) directly to external LLM providers, creating data exposure risks.

## Proposed Security Architecture

### 1. PII Redaction Sidecar Pattern
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Main App      │───▶│ PII Redaction    │───▶│ External LLM    │
│ (Spring Boot)   │    │ Sidecar          │    │ Provider        │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### 2. API Gateway Pattern
```
Client → Ingress → API Gateway → PII Filter → LLM Provider
```

## Implementation Options

### Option A: Sidecar Pattern
**Pros**: Low latency, co-located deployment
**Cons**: Per-pod resource overhead

### Option B: Gateway Pattern  
**Pros**: Centralized control, easier updates
**Cons**: Single point of failure, network hop

## Recommended: Hybrid Approach

1. **Primary**: API Gateway with PII filtering
2. **Fallback**: Sidecar for critical workloads
3. **Monitoring**: Egress traffic inspection
4. **Policy**: Data classification and handling rules

## Security Controls
- **PII Detection**: Regex/ML-based identification
- **Data Masking**: Tokenization or anonymization  
- **Audit Logging**: All egress traffic logged
- **Rate Limiting**: Prevent data exfiltration
- **Network Policies**: Restrict external access

## Components
1. **PII Detection Service**
2. **Data Masking Engine** 
3. **Audit Log Store**
4. **Policy Engine**
5. **Monitoring Dashboard**

This architecture provides defense-in-depth for PII protection while maintaining application functionality.
