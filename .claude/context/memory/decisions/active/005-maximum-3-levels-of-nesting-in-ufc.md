# ADR-005: Maximum 3 Levels of Nesting in UFC

**Date**: 2025-11-02
**Status**: Accepted

## Context

Need to balance organization vs. complexity in UFC structure. Too flat = everything in one place. Too deep = hard to navigate and unreliable loading.

## Decision

Maximum 3 levels of nesting in context structure:
- ✅ `context/tools/mcps.md` (2 levels)
- ✅ `context/projects/project-name/details.md` (3 levels)
- ❌ `context/projects/project-name/sub/team/members.md` (4 levels - too deep)

**Examples:**
```
GOOD:
~/.claude/.claude/context/
├── memory/
│   ├── decisions/
│   │   └── active/001-ufc.md (3 levels: context → memory → decisions)
│   └── learnings-archive/2025-11.md (3 levels)

BAD:
~/.claude/.claude/context/
├── projects/
│   ├── project-a/
│   │   ├── subproject/
│   │   │   └── team/details.md (5 levels - TOO DEEP)
```

## Consequences

**Positive:**
- ✅ Reliable context loading
- ✅ Not overwhelming to navigate
- ✅ Clear structure
- ✅ Easy to find files

**Negative:**
- ⚠️ Some contexts might feel cramped
- ⚠️ Need to consolidate related info
- ⚠️ May need to split large topics differently

**Trade-offs Accepted:**
Reliability over deep nesting. Better to have more files at level 2-3 than deep hierarchies.

## Related

- ADR-001 (UFC System)
- ADR-021 (Memory refactoring uses this principle)

---
