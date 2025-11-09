# Threat Modeling Workflow

## Overview
Systematic identification of security threats using STRIDE methodology.

## STRIDE Categories
- **S**poofing: Identity impersonation
- **T**ampering: Data modification
- **R**epudiation: Denying actions
- **I**nformation Disclosure: Data exposure
- **D**enial of Service: Availability attacks
- **E**levation of Privilege**: Unauthorized access

## Workflow Steps

### 1. System Decomposition
- Architecture diagram
- Data flows
- Trust boundaries
- Entry/exit points
- Assets to protect

### 2. Threat Identification
For each component, ask:
- Can attacker spoof identity?
- Can data be tampered with?
- Can actions be repudiated?
- Can information be disclosed?
- Can service be disrupted?
- Can privileges be elevated?

### 3. Risk Assessment
For each threat:
- Likelihood (High/Medium/Low)
- Impact (High/Medium/Low)
- Risk = Likelihood × Impact

### 4. Mitigation Strategies
- Eliminate threat (redesign)
- Reduce risk (controls)
- Accept risk (document)
- Transfer risk (insurance, third-party)

### 5. Documentation
- Threat model diagram
- Identified threats
- Risk ratings
- Mitigation plans
- Residual risks

## Voice Announcement
```
🎯 COMPLETED: [SKILL:security] Threat model complete
🗣️ CUSTOM COMPLETED: Threats identified
```
