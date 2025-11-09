# Architecture Decisions - Index (Tier 1 Metadata)

**Purpose:** Quick reference for all ADRs with Tier 1 metadata. Load this file by default. Load individual ADRs on-demand.

**Total ADRs:** 10 (examples for template)
**Active:** 10 | **Superseded:** 0 | **Deprecated:** 0

---

## Quick Reference Table

| ADR | Title | Status | Priority | Date | Impact |
|-----|-------|--------|----------|------|--------|
| **001** | [UFC System](#adr-001-ufc-system) | Accepted | - | 2025-11-02 | High - Foundation |
| **003** | [Skills Over Commands](#adr-003-skills-over-commands) | Accepted | - | 2025-11-02 | Medium |
| **005** | [Max 3 Nesting Levels](#adr-005-nesting-limit) | Accepted | - | 2025-11-02 | Medium - UFC design |
| **007** | [Security-First](#adr-007-security-first) | Accepted | - | 2025-11-02 | Critical - Data safety |
| **008** | [Minimal Project .claude/](#adr-008-minimal-project-claude) | Accepted | - | 2025-11-02 | High - UFC Layer 4 |
| **011** | [Progressive Disclosure](#adr-011-progressive-disclosure) | Accepted | - | 2025-11-02 | High - Dimension 1 |
| **012** | [Proactive Skill Activation](#adr-012-proactive-activation) | Accepted | - | 2025-11-02 | **CRITICAL** - Dimension 4 |
| **020** | [Enforcement Architecture](#adr-020-enforcement-architecture) | Accepted | **P0** | 2025-11-04 | **CRITICAL** - System fix |
| **021** | [Memory System Refactoring](#adr-021-memory-refactoring) | Accepted | P1 | 2025-11-04 | High - This refactoring |
| **022** | [Progressive Disclosure Skills](#adr-022-progressive-disclosure-skills) | Accepted | P1 | 2025-11-04 | High - 67% size reduction |

---

## ADR-001: UFC System
**Status:** Accepted | **File:** active/001-ufc-system.md
**Summary:** Adopt Universal File-based Context system with nested directory structure, max 3 levels nesting, 4-layer enforcement.
**Impact:** Foundation for entire context management. File system IS context system.
**Related:** ADR-005, ADR-008

---

## ADR-003: Skills Over Commands
**Status:** Accepted | **File:** active/003-skills-over-commands.md
**Summary:** Prefer Skills over slash commands. Skills provide better organization, auto-discovery, multiple files.
**Impact:** Different from other systems but more powerful long-term. Directory-based organization.
**Related:** ADR-012

---

## ADR-005: Nesting Limit
**Status:** Accepted | **File:** active/005-nesting-limit.md
**Summary:** Maximum 3 levels of nesting in UFC structure. Reliability over deep organization.
**Impact:** Prevents unreliable context loading. Clear structure.
**Related:** ADR-001

---

## ADR-007: Security-First
**Status:** Accepted | **File:** active/007-security-first.md
**Summary:** Security-first approach. Never commit ~/.claude/ to public repos. Run git remote -v before commits. 3x verification.
**Impact:** Protects sensitive data. Prevents accidental exposure.

---

## ADR-008: Minimal Project .claude/
**Status:** Accepted | **File:** active/008-minimal-project-claude.md
**Summary:** Project-local .claude/ contains ONLY claude.md symlink. No PAI infrastructure copies. Single source of truth.
**Impact:** Prevents hook conflicts. UFC Layer 4. No duplication.
**Related:** ADR-001

---

## ADR-011: Progressive Disclosure
**Status:** Accepted | **File:** active/011-progressive-disclosure.md
**Summary:** Tier 1 metadata in SKILL.md YAML (~100 tokens), Tier 2 instructions in body. Progressive disclosure pattern.
**Impact:** Efficient token usage. Enables auto-activation.
**Related:** ADR-012

---

## ADR-012: Proactive Activation
**Status:** Accepted | **Priority:** **CRITICAL** | **File:** active/012-proactive-activation.md
**Summary:** Proactive skill activation based on task type. Two-level routing: Intent → Skill → Workflow. 5 critical rules.
**Impact:** **30% → 100% capacity**. Specialists fully utilized.
**Related:** ADR-019, ADR-020

---

## ADR-020: Enforcement Architecture
**Status:** Accepted | **Priority:** **P0 - CRITICAL** | **File:** active/020-enforcement-architecture.md
**Summary:** Enforcement-based architecture. 3 layers: SessionStart (context), UserPromptSubmit (routing), Stop (validation). Trust → Enforcement.
**Impact:** **Eliminates recurring failures**. Observable behavior. Reliable operation.
**Related:** ADR-012, ADR-019

---

## ADR-021: Memory Refactoring
**Status:** Accepted | **Priority:** P1 | **File:** active/021-memory-refactoring.md
**Summary:** Refactor memory system. Chronological archiving (learnings-archive/), categorical organization (decisions/, analysis/), progressive disclosure (Tier 1/2/3).
**Impact:** 84% file size reduction. Context window efficiency. Enables future phases.
**Related:** ADR-001, ADR-011

---

## ADR-022: Progressive Disclosure Skills
**Status:** Accepted | **Priority:** P1 | **File:** active/022-progressive-disclosure-skills.md
**Summary:** Three-tier skill architecture: SKILL.md core (<180 lines), workflows/ on-demand, reference/ background. Refactored skills achieving 67% average reduction.
**Impact:** 67% size reduction, 73% token savings, better maintainability, scalability.
**Related:** ADR-011, ADR-003

---

## Priority Legend

- **P0** - Critical, blocks system operation
- **P1** - High, enables next phase
- **P2** - Medium, quality improvement
- **No priority** - Standard decision

---

## Status Definitions

- **Accepted** - Decision made and active
- **Superseded** - Replaced by newer ADR (see superseded/ directory)
- **Deprecated** - No longer used (see deprecated/ directory)

---

## Search Tips

**Find by topic:**
```bash
grep -r "skill activation" decisions/active/*.md
grep -r "UFC" decisions/active/*.md
```

**Find by priority:**
```bash
grep -r "Priority: P0" decisions/active/*.md
```

**Find by date range:**
```bash
ls -lt decisions/active/*.md | head -10
```

---

## Maintenance

**When ADR is superseded:**
1. Move file from `active/` to `superseded/`
2. Update this INDEX.md (change status to "Superseded")
3. Add reference to superseding ADR

**When ADR is deprecated:**
1. Move file from `active/` to `deprecated/`
2. Update this INDEX.md (change status to "Deprecated")
3. Document reason for deprecation

**Quarterly review:**
- Verify all ADRs in correct directory
- Update impact assessments
- Check for missing ADRs

---

**Last Updated:** 2025-11-09
**Next Review:** 2026-02-01 (quarterly)
