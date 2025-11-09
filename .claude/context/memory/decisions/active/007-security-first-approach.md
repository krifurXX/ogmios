# ADR-007: Security-First Approach

**Date**: 2025-11-02
**Status**: Accepted

## Context

`~/.claude/` directory contains:
- Contact information (names, emails, relationships)
- Work contexts (collaborators, advisors)
- Personal preferences
- API keys (potentially)
- Private project details

Accidental public exposure = serious privacy/security breach.

## Decision

Security-first approach for ALL git operations:

**Before ANY commit:**
1. Run `git remote -v` THREE TIMES
2. Verify remote URL matches expected repository
3. Check you're in correct directory
4. Verify no sensitive data in staged files

**NEVER:**
- ❌ Commit `~/.claude/` to public repos
- ❌ Push to wrong remote
- ❌ Include API keys in commits
- ❌ Commit contact information
- ❌ Push without verifying remote

**ALWAYS:**
- ✅ Verify git remote before push
- ✅ Use `.gitignore` for sensitive data
- ✅ Sanitize examples before sharing
- ✅ Ask user if unsure about public/private status

**Git Safety Protocol:**
```bash
# BEFORE git push, ALWAYS run:
git remote -v
# Verify output matches expected repository
# If wrong repository: STOP IMMEDIATELY
```

## Consequences

**Positive:**
- ✅ Protects sensitive data
- ✅ Prevents accidental exposure
- ✅ Builds trust through vigilance
- ✅ Aligns with InfoSec background

**Negative:**
- ⚠️ Adds friction to git operations
- ⚠️ Requires extra verification steps
- ⚠️ Paranoia might seem excessive

**Trade-offs Accepted:**
Better paranoid than exposed. One accidental push of contacts/keys = permanent damage.

## Implementation

**Hook support:**
Consider pre-push hook that verifies:
- Remote URL matches whitelist
- No files from `~/.claude/.claude/` (unless explicitly allowed)
- No API keys in diff

**Human verification required:**
Automated checks help, but human must verify. Security is responsibility.

## Related

- Project-specific CLAUDE.md files include security warnings
- All documentation emphasizes verification

---
