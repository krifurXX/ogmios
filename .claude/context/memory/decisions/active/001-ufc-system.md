# ADR-001: UFC System

**Date**: 2025-11-02
**Status**: Accepted

## Context

AI systems need reliable context management. Large context windows help, but "haystack problem" is real - finding the right information at the right time. Need architecture for context management.

## Decision

Adopt Universal File-based Context (UFC) system:
- File system IS the context system
- Nested directory structure (max 3 levels - see ADR-005)
- 4-layer enforcement:
  1. UFC.md - System description
  2. Hooks - Automatic context loading
  3. claude.md - Per-project instructions
  4. Symlinks - Safety net (`.claude/claude.md → ../claude.md`)

**Structure:**
```
~/.claude/.claude/context/
├── UFC.md (Layer 1 - system overview)
├── projects/ (project-specific contexts)
├── tools/ (MCP, voice, statusline)
├── preferences/ (stack, security, git)
├── languages/ (bilingual support)
├── memory/ (decisions, learnings, analysis)
└── [other categories as needed]
```

## Consequences

**Positive:**
- ✅ Context persists across sessions
- ✅ File system navigation = context discovery
- ✅ Version control friendly (git tracks changes)
- ✅ Scalable (add files as needed)
- ✅ Portable (plain text markdown)
- ✅ No vendor lock-in

**Negative:**
- ⚠️ Requires discipline (must maintain files)
- ⚠️ File system complexity (many files/dirs)
- ⚠️ Manual curation needed

**Trade-offs Accepted:**
File system organization effort worth it for persistent, reliable context.

## Related

- ADR-005 (Max 3 nesting levels)
- ADR-008 (Minimal project .claude/)
- ADR-021 (Memory system refactoring)

---
