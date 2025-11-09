# OWASP Top 10 (2021) Quick Reference

## A01: Broken Access Control
**Risk**: Users access unauthorized resources
**Prevention**:
- Deny by default
- Implement access control checks
- Log access control failures
- Rate limit API access

## A02: Cryptographic Failures
**Risk**: Sensitive data exposure
**Prevention**:
- Encrypt data in transit (HTTPS)
- Encrypt sensitive data at rest
- Use strong algorithms (AES-256)
- Proper key management
- Disable caching for sensitive data

## A03: Injection
**Risk**: SQL, NoSQL, OS command injection
**Prevention**:
- Parameterized queries
- ORM usage
- Input validation
- Escape special characters
- Principle of least privilege for DB

## A04: Insecure Design
**Risk**: Architectural flaws
**Prevention**:
- Threat modeling
- Security requirements in design
- Secure design patterns
- Security reviews

## A05: Security Misconfiguration
**Risk**: Default configs, unnecessary features
**Prevention**:
- Harden configurations
- Remove unnecessary features
- Security headers
- Regular updates
- Automated scanning

## A06: Vulnerable Components
**Risk**: Known vulnerabilities in dependencies
**Prevention**:
- Inventory dependencies
- Regular updates
- Vulnerability scanning
- Remove unused dependencies
- Monitor security advisories

## A07: Authentication Failures
**Risk**: Compromised accounts
**Prevention**:
- Multi-factor authentication
- Strong password policies
- No default credentials
- Account lockout
- Secure session management

## A08: Data Integrity Failures
**Risk**: Insecure deserialization, untrusted data
**Prevention**:
- Digital signatures
- Integrity checks
- Validate serialized objects
- Secure deserialization

## A09: Security Logging Failures
**Risk**: Unable to detect/respond to breaches
**Prevention**:
- Log authentication events
- Log access control failures
- Tamper-proof logs
- Alert on suspicious activity
- Centralized logging

## A10: Server-Side Request Forgery
**Risk**: Server makes unintended requests
**Prevention**:
- Validate URLs
- Whitelist destinations
- Disable unnecessary URL schemas
- Network segmentation
