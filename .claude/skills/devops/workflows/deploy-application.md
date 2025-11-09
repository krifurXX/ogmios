# Deploy Application Workflow

## Overview
Safe, repeatable application deployment process.

## Pre-Deployment Checklist
- [ ] All tests passing
- [ ] Security scan clean
- [ ] Database migrations ready
- [ ] Environment variables configured
- [ ] Rollback plan documented
- [ ] Monitoring configured

## Deployment Steps

### 1. Pre-Deployment
- Backup current state
- Verify deployment environment
- Check resource availability
- Notify stakeholders

### 2. Deploy
- Apply database migrations
- Deploy application code
- Update configuration
- Restart services

### 3. Verification
- Health check endpoints
- Smoke tests
- Monitor metrics
- Check logs

### 4. Post-Deployment
- Verify functionality
- Monitor for errors
- Update documentation
- Notify completion

## Rollback Procedure
If issues detected:
1. Stop deployment
2. Restore previous version
3. Investigate issues
4. Document incident

## Voice Announcement
```
🎯 COMPLETED: [SKILL:devops] Application deployed successfully
🗣️ CUSTOM COMPLETED: Deployment complete
```
