# Analysis Files - Index (Tier 1 Metadata)

**Purpose:** Quick reference for all analysis documents. Load this file by default. Load individual analyses on-demand.

**Total Files:** [Count]
**Categories:** System Analysis, Incident Reports, Implementation Logs

---

## Quick Reference Table

| File | Category | Date | Topic | Impact |
|------|----------|------|-------|--------|
| [system-analysis-1.md](#system-analysis-1) | System | YYYY-MM-DD | Topic | Impact level |
| [incident-1.md](#incident-1) | Incident | YYYY-MM-DD | Topic | Impact level |

---

## System Analyses

### system-analysis-1.md
**File:** system-analysis-1.md
**Date:** YYYY-MM-DD
**Topic:** System Architecture Analysis

**Summary:**
Brief one-paragraph summary of what this analysis covers.

**Key Finding:**
Most important discovery from this analysis.

**Impact:**
How this analysis influenced system design or decisions.

**Related:**
- ADR-XXX: [Related decision]
- Learning YYYY-MM-DD: [Related learning]

---

## Incident Reports

### incidents/YYYY-MM-DD-incident-name.md
**File:** incidents/YYYY-MM-DD-incident-name.md
**Date:** YYYY-MM-DD
**Topic:** Brief incident description

**Incident:**
One-paragraph summary of what went wrong.

**Root Cause:**
One-sentence explanation of why it happened.

**Solution:**
One-sentence description of fix.

**Impact:**
What changed as a result.

**Related:**
- ADR-XXX: [Decision resulting from incident]
- Learning: [Related learning entry]

---

## Implementation Logs

### implementation-logs/project-name/
**Directory:** implementation-logs/project-name/
**Contents:**
- problems-log.md - Challenges during implementation
- implementation-log.md - Solutions and progress

**Date:** YYYY-MM-DD
**Topic:** Implementation documentation

**Summary:**
What this implementation was about.

**Related:**
- ADR-XXX: [Related decision]

---

## Search Tips

**Find by topic:**
```bash
grep -r "topic" analysis/*.md
grep -r "keyword" analysis/incidents/*.md
```

**Find by date:**
```bash
ls -lt analysis/incidents/*.md
```

**Find incidents:**
```bash
ls -1 analysis/incidents/
```

**Find system analyses:**
```bash
ls -1 analysis/*.md | grep -v INDEX
```

---

## File Locations

**System Analyses:**
- `analysis/[topic].md`

**Incident Reports:**
- `analysis/incidents/YYYY-MM-DD-[name].md`

**Implementation Logs:**
- `analysis/implementation-logs/[project]/`

---

## Maintenance

**When creating new analysis:**
1. Determine category (System, Incident, Log)
2. Place in appropriate subdirectory
3. Update this INDEX.md
4. Use date-prefixed naming for incidents: `YYYY-MM-DD-topic.md`

**Quarterly review:**
- Archive old incident reports (>3 months)
- Update summaries
- Check for patterns across incidents

---

**Last Updated:** <DATE>
**Next Review:** [Quarterly date]
