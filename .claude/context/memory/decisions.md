# Architecture Decision Records (ADRs)

**Owner:** <YOUR_NAME>
**Created:** <DATE>
**Last Updated:** <DATE>

---

## What are ADRs?

**Architecture Decision Records (ADRs)** document important architectural and technical decisions with their context, rationale, and consequences.

**Purpose:**
- Remember WHY decisions were made
- Avoid revisiting solved problems
- Onboard new specialists (or future you!)
- Track evolution of system architecture

---

## ADR Format

Use this template for all architecture decisions:

```markdown
# ADR-XXX: [Decision Title]

**Date:** YYYY-MM-DD
**Status:** Proposed | Active | Superseded | Deprecated
**Decider(s):** <YOUR_NAME>
**Tags:** [architecture, tooling, process, etc.]

## Context

What is the issue we're facing in the current environment and context?
What factors are driving this decision?

## Decision

What is the change that we're proposing and/or doing?
Be specific and clear.

## Rationale

Why did we choose this solution over alternatives?
What are the key benefits?

## Alternatives Considered

1. **Alternative A**: Why it wasn't chosen
2. **Alternative B**: Why it wasn't chosen
3. **Alternative C**: Why it wasn't chosen

## Consequences

### Positive
- Benefit 1
- Benefit 2

### Negative
- Trade-off 1
- Trade-off 2

### Neutral
- Other impact 1
- Other impact 2

## Implementation Notes

How will this decision be implemented?
Any specific steps or migration path?

## References

- [Link to relevant documentation]
- [Related ADRs]
- [External resources]
```

---

## Active Decisions

### ADR-001: UFC System for Context Management

**Date:** <DATE>
**Status:** Active
**Tags:** architecture, context, core-system

#### Context
Single `claude.md` file becomes unwieldy with:
- Multiple projects
- Different tech stacks
- Various preferences
- Growing knowledge base

Need scalable, organized context system.

#### Decision
Implement **UFC (Universal File-based Context)** with hierarchical file structure:
- `context/projects/` for project-specific context
- `context/tools/` for tool preferences
- `context/preferences/` for user preferences
- `context/memory/` for decisions and learnings
- Dynamic loading via hooks based on intent detection

#### Rationale
- **Scalability**: Add new context without bloating single file
- **Organization**: Logical categorization
- **Performance**: Load only relevant context
- **Maintainability**: Edit specific aspects independently

#### Alternatives Considered
1. **Single claude.md**: Simple but doesn't scale
2. **Database**: Over-engineered for text files
3. **Tags in single file**: Hard to navigate at scale

#### Consequences

**Positive:**
- Context grows without performance impact
- Easy to find and update specific information
- Better separation of concerns

**Negative:**
- Initial setup complexity
- Requires hook configuration
- File management overhead

**Neutral:**
- Need to maintain directory structure
- Learning curve for new pattern

---

### ADR-002: Automatic Skill Activation

**Date:** <DATE>
**Status:** Active
**Tags:** skills, automation, ux

#### Context
Users want specialized AI responses (engineering vs research vs architecture) but manually selecting skills is cumbersome and breaks flow.

#### Decision
Implement automatic skill activation via `UserPromptSubmit` hook:
- Analyze user prompt for trigger words
- Activate appropriate skill automatically
- Use voice IDs to differentiate specialists

#### Rationale
- **Better UX**: No manual selection needed
- **Natural Flow**: Just describe task, get specialist
- **Consistency**: Same triggers always activate same skill

#### Alternatives Considered
1. **Manual Selection**: "/engineering" commands - breaks flow
2. **Always Use One Skill**: No specialization benefit
3. **AI Decides**: Less predictable, harder to configure

#### Consequences

**Positive:**
- Seamless specialist activation
- Predictable behavior (same triggers = same skill)
- Voice system can use different voices per skill

**Negative:**
- May activate wrong skill if triggers overlap
- Requires maintaining trigger patterns

**Neutral:**
- Users need to learn trigger words (but natural ones like "build", "research")

---

### ADR-003: Progressive Disclosure (3-Tier Context)

**Date:** <DATE>
**Status:** Active
**Tags:** context, performance, ux

#### Context
Some tasks need minimal context (quick questions), others need deep context (complex implementation). Loading everything wastes tokens and time.

#### Decision
Implement 3-tier progressive disclosure:
- **Tier 1** (<5KB): Metadata, always loaded
- **Tier 2** (10-50KB): Core content, loaded on intent match
- **Tier 3** (50KB+): Deep dive, loaded on explicit request

#### Rationale
- **Performance**: Don't load unnecessary context
- **Flexibility**: Scale from quick to deep as needed
- **Token Efficiency**: Smaller context window for simple tasks

#### Alternatives Considered
1. **Always Load Everything**: Wastes tokens
2. **Manual Tier Selection**: Breaks UX flow
3. **AI Decides Tier**: Less predictable

#### Consequences

**Positive:**
- Faster responses for simple queries
- Deep context available when needed
- Efficient token usage

**Negative:**
- Need to categorize content by tier
- Some complexity in hook logic

---

### ADR-004: <Your Decision Here>

**Date:** <DATE>
**Status:** Proposed
**Tags:** <tags>

#### Context
[Describe the problem/situation]

#### Decision
[What did you decide?]

#### Rationale
[Why this solution?]

#### Alternatives Considered
1. **Alternative A**: [Why not chosen]
2. **Alternative B**: [Why not chosen]

#### Consequences

**Positive:**
- [Benefit 1]

**Negative:**
- [Trade-off 1]

---

## Superseded Decisions

Document superseded decisions here with link to replacement ADR.

### ADR-XXX: [Superseded Decision]
**Superseded by:** ADR-YYY
**Date superseded:** YYYY-MM-DD
**Reason:** [Why was this superseded?]

---

## Deprecated Decisions

Document deprecated decisions (no longer applicable).

### ADR-XXX: [Deprecated Decision]
**Deprecated:** YYYY-MM-DD
**Reason:** [Why no longer applicable?]

---

## Decision Categories

Use tags to categorize decisions:

- `architecture` - System architecture and design
- `tooling` - Tool choices and configurations
- `process` - Development processes and workflows
- `security` - Security-related decisions
- `performance` - Performance optimization decisions
- `ux` - User experience decisions
- `core-system` - Fundamental system decisions

---

## How to Add New ADR

1. **Identify Need**: Recognize a decision worth documenting
2. **Number It**: Next available number (ADR-XXX)
3. **Draft**: Use template above
4. **Discuss**: If applicable, discuss with team/future self
5. **Decide**: Set status to "Active"
6. **Document**: Add to this file
7. **Implement**: Execute the decision
8. **Review**: Periodically review active decisions

---

## Review Schedule

**Quarterly Review**: Review all active ADRs
- Are they still relevant?
- Any need updates?
- Should any be superseded?

**Annual Review**: Full audit
- Clean up deprecated decisions
- Update references
- Consolidate if needed

---

## Quick Reference

### Common Decision Types

**Tool Selection:**
```markdown
# ADR-XXX: Choose [Tool] for [Purpose]

Context: Need tool for [purpose]
Decision: Use [Tool X]
Rationale: [Key benefits over alternatives]
Alternatives: [Tool Y, Tool Z]
```

**Architecture Pattern:**
```markdown
# ADR-XXX: Implement [Pattern] for [System]

Context: System needs [capability]
Decision: Use [Pattern/Approach]
Rationale: [Why this pattern fits]
Alternatives: [Other patterns considered]
```

**Process Change:**
```markdown
# ADR-XXX: Change [Process] from [X] to [Y]

Context: Current process [X] has issues [...]
Decision: Switch to [Y]
Rationale: [Benefits of Y over X]
Consequences: [Migration plan, impacts]
```

---

## Related Files

- **UFC.md** - Context system overview
- **learnings.md** - Lessons learned (outcomes of decisions)
- **PAI.md** - Core system configuration

---

**Document decisions. Save future thinking time.** 🧠
