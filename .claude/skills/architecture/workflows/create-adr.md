# Create Architecture Decision Record (ADR) Workflow

## Purpose
Document significant architectural decisions with context, options evaluated, and rationale.

## When to Use
- Making technology selection decisions
- Choosing between architectural patterns
- Deciding on integration approaches
- Any decision with long-term impact

## Workflow Steps

### 1. Identify Decision
- Clearly state the decision to be made
- Explain why this decision is needed
- Note any time constraints

### 2. Gather Context
- Document current situation
- Identify driving forces for decision
- Note relevant constraints
- List stakeholder concerns

### 3. Evaluate Options
- List all viable options (minimum 2-3)
- Research each option thoroughly
- Document pros and cons
- Identify risks for each

### 4. Analyze Trade-offs
- Compare options against requirements
- Evaluate cost vs benefit
- Consider long-term implications
- Assess maintenance overhead

### 5. Make Decision
- Select recommended option
- Provide clear rationale
- Document why other options were rejected
- Note any assumptions

### 6. Document ADR
- Use standard ADR template
- Include all context and analysis
- Make decision explicit
- Note consequences and follow-up actions

## ADR Template Structure
```markdown
# ADR-XXX: [Title]

## Status
[Proposed | Accepted | Deprecated | Superseded]

## Context
[Background and driving forces]

## Decision
[The decision and rationale]

## Consequences
[Positive and negative outcomes]

## Alternatives Considered
[Options evaluated and why rejected]
```

## Best Practices
- Number ADRs sequentially
- Keep ADRs immutable (don't edit, supersede instead)
- Be specific and actionable
- Include enough context for future readers
- Link related ADRs
