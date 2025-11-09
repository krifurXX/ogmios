# Architecture Decision Record Template

## ADR-XXX: [Short Title of Decision]

**Date**: YYYY-MM-DD  
**Status**: [Proposed | Accepted | Deprecated | Superseded by ADR-YYY]  
**Deciders**: [Names of decision makers]  
**Technical Story**: [Link to issue/ticket if applicable]

## Context

### Background
[Describe the current situation and the problem that needs to be solved. Include:
- What is driving this decision?
- What is the current state?
- Why is a decision needed now?]

### Driving Forces
[List the key factors influencing this decision:
- Business requirements
- Technical constraints
- Quality attributes (performance, security, scalability)
- Team capabilities
- Time constraints]

### Assumptions
[Document any assumptions being made:
- About the problem
- About the environment
- About resources]

## Decision

### Chosen Option
**[Name of selected option]**

[Clearly state what was decided and explain the rationale. Include:
- What is the decision?
- Why was this option chosen?
- What are the key reasons?]

### Implementation Approach
[High-level approach for implementing this decision:
- Key steps
- Timeline considerations
- Dependencies]

## Alternatives Considered

### Option 1: [Name]
**Description**: [Brief description]

**Pros**:
- [Benefit 1]
- [Benefit 2]

**Cons**:
- [Drawback 1]
- [Drawback 2]

**Why Rejected**: [Reason for not choosing this option]

### Option 2: [Name]
**Description**: [Brief description]

**Pros**:
- [Benefit 1]
- [Benefit 2]

**Cons**:
- [Drawback 1]
- [Drawback 2]

**Why Rejected**: [Reason for not choosing this option]

[Add more options as needed]

## Consequences

### Positive
- [Expected benefit 1]
- [Expected benefit 2]
- [Expected benefit 3]

### Negative
- [Known drawback 1]
- [Known drawback 2]
- [Trade-off 1]

### Risks
- [Risk 1 and mitigation strategy]
- [Risk 2 and mitigation strategy]

### Technical Debt
[Any technical debt introduced by this decision and plan to address it]

## Follow-up Actions

1. [Action item 1] - Owner: [Name] - Due: [Date]
2. [Action item 2] - Owner: [Name] - Due: [Date]
3. [Action item 3] - Owner: [Name] - Due: [Date]

## References

- [Link to research/documentation 1]
- [Link to research/documentation 2]
- [Related ADR-XXX: Title]

## Notes

[Any additional notes, learnings, or context that may be valuable]

---

## ADR Best Practices

1. **Keep ADRs immutable**: Don't edit after acceptance; supersede instead
2. **Be specific**: Avoid vague language; be concrete and actionable
3. **Include context**: Future readers need to understand the "why"
4. **Number sequentially**: ADR-001, ADR-002, etc.
5. **Date clearly**: Include decision date
6. **Link related ADRs**: Show evolution of decisions
7. **Update status**: Mark as deprecated/superseded when relevant
8. **Store with code**: Keep ADRs in version control

## Status Definitions

- **Proposed**: Under consideration, not yet accepted
- **Accepted**: Decision made and being implemented
- **Deprecated**: No longer relevant but kept for history
- **Superseded by ADR-XXX**: Replaced by newer decision
