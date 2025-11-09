# ADR-003: Skills Over Commands

**Date**: 2025-11-02
**Status**: Accepted

## Context

Claude Code supports both slash commands and Skills system. Need to choose primary pattern for organizing capabilities.

## Decision

Prefer Skills over slash commands:
- Skills provide better organization
- Skills auto-load based on description
- Skills can contain multiple files (workflows, assets, etc.)
- Commands still available when needed
- But primary pattern is Skills

**Structure:**
```
~/.claude/.claude/skills/
├── skill-name/
│   ├── SKILL.md (Tier 1 metadata + core instructions)
│   ├── workflows/ (step-by-step processes)
│   ├── reference/ (background materials)
│   └── assets/ (templates, examples)
```

## Consequences

**Positive:**
- ✅ Better organization (each skill is a directory)
- ✅ Auto-discovery (Claude loads based on description)
- ✅ More maintainable (workflows/, assets/ subdirectories)
- ✅ Progressive disclosure (SKILL.md → workflows → reference)
- ✅ Matches Claude Code's recommended pattern

**Negative:**
- ⚠️ Different from other systems (less direct compatibility)
- ⚠️ Learning curve if switching from commands

**Trade-offs Accepted:**
Skills are more powerful long-term. Directory structure enables better organization.

## Related

- ADR-011 (Progressive disclosure)
- ADR-012 (Proactive skill activation)
- ADR-022 (Progressive disclosure skills)

---
