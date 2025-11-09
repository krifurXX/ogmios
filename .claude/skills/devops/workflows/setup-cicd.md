# Setup CI/CD Pipeline Workflow

## Overview
Configure automated testing and deployment pipelines.

## Workflow Steps

### 1. Define Pipeline Stages
- Build
- Test (unit, integration)
- Security scan
- Deploy (staging, production)

### 2. Configure CI Platform
GitHub Actions example:
```yaml
name: CI/CD
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm test
  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - run: npm run deploy
```

### 3. Environment Management
- Dev, staging, production
- Environment variables
- Secrets management
- Infrastructure as code

### 4. Testing
- Automated test execution
- Code coverage requirements
- Integration tests
- E2E tests

### 5. Deployment Strategy
- Blue-green deployment
- Canary releases
- Rollback procedures
- Health checks

## Voice Announcement
```
🎯 COMPLETED: [SKILL:devops] CI/CD pipeline configured
🗣️ CUSTOM COMPLETED: Pipeline ready
```
