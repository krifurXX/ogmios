# Incident Reports

**Purpose:** Document system failures, problems, and their resolutions.

**Naming Convention:** `YYYY-MM-DD-incident-name.md`

---

## Purpose

Incident reports capture:
- What went wrong
- Why it happened
- How it was fixed
- What we learned
- How to prevent recurrence

**Goal:** Learn from failures to build more reliable systems.

---

## Incident Report Template

```markdown
# Incident: [Brief Title]

**Date**: YYYY-MM-DD
**Category**: [System | Process | Technical | Security]
**Severity**: [CRITICAL | HIGH | MEDIUM | LOW]

## Summary

One-paragraph description of what happened.

## Timeline

**YYYY-MM-DD HH:MM** - Incident detected
**YYYY-MM-DD HH:MM** - Investigation started
**YYYY-MM-DD HH:MM** - Root cause identified
**YYYY-MM-DD HH:MM** - Fix implemented
**YYYY-MM-DD HH:MM** - Verification complete
**YYYY-MM-DD HH:MM** - Incident closed

## Incident Details

**What Happened:**
Detailed description of the problem, symptoms, and impact.

**Affected Systems:**
- System/component 1
- System/component 2

**User Impact:**
Description of how this affected users or workflows.

## Root Cause Analysis

**Immediate Cause:**
Technical explanation of what directly caused the failure.

**Contributing Factors:**
- Factor 1: [Description]
- Factor 2: [Description]

**Systemic Issues:**
Underlying architectural or process gaps that allowed this to happen.

## Investigation Process

Steps taken to understand the problem:
1. Checked [what]
2. Reviewed [what]
3. Tested [what]
4. Discovered [what]

## Resolution

**Fix Implemented:**
Detailed description of the solution.

**Files Modified:**
- file1.md: [changes]
- file2.ts: [changes]

**Testing Performed:**
- Test 1: [result]
- Test 2: [result]

## Prevention

**Immediate Actions:**
- [ ] Action 1
- [ ] Action 2

**Long-term Improvements:**
- [ ] Improvement 1
- [ ] Improvement 2

**Monitoring Added:**
What monitoring/alerting was added to detect similar issues.

## Learning

**Key Insights:**
1. Insight 1
2. Insight 2

**Pattern Recognition:**
Connection to previous incidents or learnings.

**ADR Created:**
If this incident led to architectural decision, reference ADR.

## Related

- **ADR-XXX**: [Related decision]
- **Learning YYYY-MM-DD**: [Related learning]
- **Similar Incident**: [If pattern]

---

**Status**: [Open | Investigating | Resolved | Closed]
**Assignee**: [If applicable]
**Follow-up Date**: [If applicable]
```

---

## Severity Levels

**CRITICAL:**
- System down or severely degraded
- Data loss or corruption
- Security breach
- Immediate action required

**HIGH:**
- Major functionality broken
- Significant user impact
- Workaround available but costly
- Fix needed within 24 hours

**MEDIUM:**
- Partial functionality broken
- Moderate user impact
- Acceptable workaround exists
- Fix needed within week

**LOW:**
- Minor issue
- Minimal user impact
- Easy workaround
- Fix when convenient

---

## When to Create Incident Report

Create incident report when:
- System failure occurs
- Recurring pattern identified (3+ occurrences)
- Security issue discovered
- Data integrity compromised
- Learning valuable enough to document formally

Don't create for:
- Expected behavior
- Known limitations
- User error (unless pattern)
- Minor inconveniences

---

## Review Process

**After incident:**
1. Create incident report (use template)
2. Update analysis/INDEX.md
3. Create ADR if architectural change needed
4. Add learning to learnings.md
5. Update relevant documentation

**Monthly:**
- Review all incidents for patterns
- Update prevention measures
- Check if follow-up actions completed

**Quarterly:**
- Analyze incident trends
- Identify systemic issues
- Update monitoring/alerting

---

## Example Incident Reports

### 2025-01-15-context-loading-failure.md
**Severity:** HIGH
**Summary:** Context files not loading at session start
**Root Cause:** Path resolution bug in load-ufc-context hook
**Resolution:** Fixed path handling, added validation
**Prevention:** Added tests, improved error handling

### 2025-01-10-skill-activation-bypass.md
**Severity:** CRITICAL
**Summary:** Skills not activating despite clear triggers
**Root Cause:** Missing enforcement in routing logic
**Resolution:** Implemented ADR-020 enforcement architecture
**Prevention:** Structural enforcement, observable actions

---

## Search Tips

**Find by severity:**
```bash
grep "Severity: CRITICAL" incidents/*.md
```

**Find by category:**
```bash
grep "Category: Security" incidents/*.md
```

**Find unresolved:**
```bash
grep "Status: Open" incidents/*.md
```

**Find by date range:**
```bash
ls -lt incidents/2025-01-*.md
```

---

## Integration

**Incident → Learning:**
Every resolved incident should generate learning entry.

**Incident → ADR:**
Significant incidents may trigger architectural decisions.

**Incident → Monitoring:**
Each incident should improve system observability.

---

**Last Updated:** <DATE>
**Total Incidents:** [Count]
**Open Incidents:** [Count]
