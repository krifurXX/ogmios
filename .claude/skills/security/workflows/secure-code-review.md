# Secure Code Review Workflow

## Overview
Review code for security vulnerabilities and best practices.

## Review Checklist

### Input Validation
- [ ] All user input validated
- [ ] Whitelist validation (not blacklist)
- [ ] Type checking enforced
- [ ] Length limits applied
- [ ] Special characters handled

### Output Encoding
- [ ] HTML encoding for web output
- [ ] SQL parameterized queries
- [ ] Command injection prevention
- [ ] XSS prevention

### Authentication
- [ ] Strong password requirements
- [ ] Secure password storage (bcrypt/Argon2)
- [ ] Multi-factor authentication
- [ ] Session management secure
- [ ] Account lockout after failures

### Authorization
- [ ] Principle of least privilege
- [ ] Access control checks
- [ ] Direct object reference protection
- [ ] Vertical privilege escalation prevention
- [ ] Horizontal privilege escalation prevention

### Cryptography
- [ ] Strong algorithms (AES-256, RSA-2048+)
- [ ] Secure key management
- [ ] HTTPS enforced
- [ ] Sensitive data encrypted at rest
- [ ] No hardcoded secrets

### Error Handling
- [ ] Generic error messages to users
- [ ] Detailed logging for debugging
- [ ] No stack traces exposed
- [ ] Graceful failure handling

### Dependencies
- [ ] Regular dependency updates
- [ ] Vulnerability scanning (npm audit, Snyk)
- [ ] Minimal dependencies
- [ ] Trusted sources only

## Voice Announcement
```
🎯 COMPLETED: [SKILL:security] Code review complete with recommendations
🗣️ CUSTOM COMPLETED: Review complete
```
