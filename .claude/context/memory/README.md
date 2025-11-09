# ADR-021 Memory Refactoring System Templates

**Version:** 1.0
**Date:** 2025-11-09
**Status:** Production Ready

---

## Overview

Complete template system for organizing PAI memory using progressive disclosure architecture. Based on <YOUR_NAME>'s Ogmios implementation of ADR-021, sanitized for community use.

**Purpose:** Provide reusable templates for decisions (ADRs), learnings, and analysis with chronological archiving and progressive disclosure.

---

## Quick Start

```bash
# Copy entire memory system to your PAI
cp -r templates/context/memory ~/.claude/.claude/context/memory

# Or copy specific components
cp -r templates/context/memory/decisions ~/.claude/.claude/context/memory/
cp templates/context/memory/learnings.md ~/.claude/.claude/context/memory/
cp -r templates/context/memory/analysis ~/.claude/.claude/context/memory/
```

Then customize placeholders: `<DATE>`, `<YOUR_NAME>`, etc.

---

## What's Included

### 1. Decisions System (11 files)

**INDEX.md** - Tier 1 metadata for all ADRs
**10 Example ADRs:**
- 001: UFC System (foundation)
- 003: Skills Over Commands
- 005: Max 3 Nesting Levels
- 007: Security-First Approach
- 008: Minimal Project .claude/
- 011: Progressive Disclosure
- 012: Proactive Skill Activation (CRITICAL)
- 020: Enforcement Architecture (P0)
- 021: Memory Refactoring (this system)
- 022: Progressive Disclosure Skills

### 2. Learnings System (3 files)

- **learnings.md** - Current month (Tier 1 summaries)
- **learnings-archive/INDEX.md** - Archive index
- **learnings-archive/2025-01-detailed.md** - Example archive

### 3. Analysis System (2 files)

- **analysis/INDEX.md** - Tier 1 metadata
- **analysis/incidents/README.md** - Incident template

---

## Progressive Disclosure Architecture

**Tier 1 (Always Load):** ~17KB
- decisions/INDEX.md (6.2KB)
- learnings.md (8.3KB)
- analysis/INDEX.md (2.7KB)

**Tier 2 (On-Demand):** ~2-4KB each
- Individual ADR files
- Monthly learning archives
- Specific analyses

**Tier 3 (Explicit):** Varies
- Incident reports
- Implementation logs

---

## Maintenance Schedule

**Monthly (1st of month):**
- Archive last month's learnings
- Update archive INDEX

**Quarterly:**
- Review active ADRs
- Move superseded ADRs
- Cleanup old incidents

**Annually:**
- Full system audit
- Update summaries

---

## File Size Targets

- Tier 1 files: <20KB total ✓
- Individual ADRs: 2-4KB each ✓
- Monthly archives: 50-100KB ✓
- No single file >150KB

---

## Documentation

See **ADR-021-IMPLEMENTATION-SUMMARY.md** for complete documentation including:
- Detailed usage instructions
- Migration guide
- Search patterns
- Integration points
- Success metrics
- Maintenance procedures

---

## License

MIT License - Free to use, modify, and distribute.

**Based On:** <YOUR_NAME>'s Ogmios PAI system, inspired by Daniel Miessler's Kai architecture.

---

## Support

- Read: ADR-021-IMPLEMENTATION-SUMMARY.md
- GitHub Issues: [Report bugs or request features]
- Community: Share improvements via PR

---

**Template Version:** 1.0
**Created:** 2025-11-09
**Ready For:** Production Use
