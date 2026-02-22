# GitHub Actions CI/CD Pipeline

## Workflows Created:

### 1. `ci.yml` - Main CI Pipeline
**Triggers**: Push to main/develop, Pull Requests
**Features**:
- Java 11 setup with Gradle caching
- Build and test execution
- **Snyk dependency scan** (fails on HIGH severity)
- **Snyk code analysis** (fails on MEDIUM severity)
- **Trivy container scan** (fails on HIGH/CRITICAL)
- Docker image building and pushing
- SBOM generation
- SARIF upload to GitHub Security tab

### 2. `security-scan.yml` - Scheduled Security Scanning
**Triggers**: Daily at 2 AM UTC, manual dispatch
**Features**:
- Snyk dependency and code scans
- Trivy container vulnerability scanning
- Results uploaded to GitHub Security tab

## Required Secrets:
- `SNYK_TOKEN`: Your Snyk API token
- `GITHUB_TOKEN`: Automatically provided by GitHub Actions

## Security Thresholds:
- **Dependencies**: Fail on HIGH severity
- **Code**: Fail on MEDIUM severity  
- **Container**: Fail on HIGH/CRITICAL vulnerabilities

## Setup Instructions:
1. Create Snyk account and get API token
2. Add `SNYK_TOKEN` to repository secrets
3. Enable GitHub Advanced Security for SARIF upload
4. Pipeline will automatically fail on security issues

## Security Features:
- ✅ **Dependency Scanning**: Snyk checks for vulnerable dependencies
- ✅ **Code Analysis**: Snyk finds security code issues
- ✅ **Container Scanning**: Trivy finds image vulnerabilities
- ✅ **Fail-Fast**: Build stops on security issues
- ✅ **Security Tab**: Results visible in GitHub Security tab
- ✅ **SBOM Generation**: Software Bill of Materials for compliance
