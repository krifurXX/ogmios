# ADR-020: Enforcement Architecture

**Date**: 2025-11-04
**Status**: Accepted
**Priority**: P0 - CRITICAL

## Context

**Recurring pattern identified:**
- Skills not activating despite triggers
- Context not loading despite instructions
- Workflows not followed despite documentation
- Trust-based architecture failing repeatedly

**Root cause:** Documentation alone insufficient. System needs ENFORCEMENT.

## Decision

Shift from trust-based to enforcement-based architecture.

**Three Enforcement Layers:**

### Layer 1: SessionStart (Context Guarantee)
**Hook:** session-start.ts
**Purpose:** FORCE context loading at session start
**Enforcement:**
- Blocking: Session doesn't proceed until context loaded
- Validation: Verify files exist before claiming success
- Retry: Attempt load 3 times before failing
- Observable: Show exactly what loaded

### Layer 2: UserPromptSubmit (Skill Routing)
**Hook:** user-prompt-skill-router.ts
**Purpose:** FORCE skill activation when triggers match
**Enforcement:**
- Aggressive tone: "🚨 MANDATORY SKILL ACTIVATION"
- Observable verification required
- Cannot skip (structural enforcement)
- [SKILL:] tag required in COMPLETED

### Layer 3: Stop (Validation)
**Hook:** completion-validator.ts
**Purpose:** VERIFY work was done correctly
**Enforcement:**
- Check [SKILL:] tag present (if skill work)
- Verify COMPLETED format
- Log violations for analysis
- Voice notification based on skill

**Philosophy Shift:**
- Before: "Please activate skills when appropriate"
- After: "🚨 MANDATORY: Activate [skill-name] NOW"

**Observable Actions = Trust:**
- Show what you loaded
- Show what you activated
- Show what you verified
- Make it impossible to skip

## Consequences

**Positive:**
- ✅ **Eliminates recurring failures**
- ✅ Skills activate reliably
- ✅ Context loads reliably
- ✅ Observable behavior (builds trust)
- ✅ 30% → 100% capacity (specialists used)

**Negative:**
- ⚠️ More aggressive tone (necessary)
- ⚠️ Hook complexity increased
- ⚠️ More system messages in conversation

**Trade-offs Accepted:**
Reliability > Politeness. Better to be aggressive and work than polite and broken.

## Implementation

**4-Week Timeline:**
- Week 1: Layer 1 (SessionStart enforcement)
- Week 2: Layer 2 (UserPromptSubmit routing)
- Week 3: Layer 3 (Stop validation)
- Week 4: Testing & refinement

**Testing Protocol:**
- Test 1: Context loading (cold start)
- Test 2: Skill activation (research task)
- Test 3: Workflow compliance (content creation)
- Test 4: Voice routing (bilingual)
- Test 5: Validation (COMPLETED format)

## Related

- ADR-012 (Proactive activation - this enforces it)
- ADR-019 (Hook-driven activation)
- Learning 2025-11-04: Skills bypass incidents that triggered this

---
