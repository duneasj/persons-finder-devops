# GitHub Actions CI/CD Pipeline

## Workflows Created:

### 1. `ci.yml` - Main CI Pipeline
**Triggers**: Push to main/develop, Pull Requests
**Features**:
- Java 11 setup with Gradle caching
- Build and test execution
- **Trivy dependency scan** (HIGH,CRITICAL severity)
- **Semgrep code analysis** (ERROR severity)
- **Trivy container scan** (HIGH/CRITICAL vulnerabilities)
- Docker image building and pushing
- SBOM generation
- SARIF upload to GitHub Security tab

### 2. `security-scan.yml` - Scheduled Security Scanning
**Triggers**: Daily at 2 AM UTC, manual dispatch
**Features**:
- Trivy dependency scanning (MEDIUM,HIGH,CRITICAL)
- Semgrep code analysis (WARNING,ERROR)
- Trivy container vulnerability scanning
- Results uploaded to GitHub Security tab

## Security Tools Used:
- **Trivy**: Dependency and container vulnerability scanning
- **Semgrep**: Static application security testing (SAST)
- **GitHub Security Tab**: Centralized security findings

## Security Features:
- ✅ **Dependency Scanning**: Trivy finds vulnerable dependencies
- ✅ **Code Analysis**: Semgrep finds security code issues
- ✅ **Container Scanning**: Trivy finds image vulnerabilities
- ✅ **Fail-Safe**: Scans don't fail builds (|| true)
- ✅ **Security Tab**: Results visible in GitHub Security tab
- ✅ **SBOM Generation**: Software Bill of Materials for compliance
- ✅ **No Authentication Required**: All tools work without tokens

## Setup Instructions:
1. Enable GitHub Advanced Security for SARIF upload
2. Pipeline will automatically run security scans
3. Results appear in GitHub Security tab

## Benefits over Snyk:
- No authentication tokens required
- Open source tools
- Comprehensive coverage (dependencies, code, containers)
- GitHub-native integration
