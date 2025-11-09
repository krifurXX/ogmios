# Learnings Archive - Index

**Purpose:** Searchable index of archived learnings by month.

**Archive Strategy:**
- Current month stays in `../learnings.md`
- Previous months archived here as `YYYY-MM-detailed.md`
- Monthly archiving: 1st of each month (manual or automated)

---

## Archive Status

**Current Month:** [Month YYYY] (in ../learnings.md - Tier 1 summaries only)
**Archived Months:** [Count]

**Refactoring Note:** Progressive disclosure applied to learnings
- Tier 1 (learnings.md): Summaries only (~20KB, ~500 lines)
- Tier 2 (YYYY-MM-detailed.md): Full content (detailed versions)
- Reduction: ~84% file size reduction in Tier 1

---

## [YYYY-MM] Details (Example)

**Status:** Detailed version in `YYYY-MM-detailed.md` (Tier 2)
**Summary Version:** In `../learnings.md` (Tier 1)
**Entries:** [Count] learnings
**Date Range:** YYYY-MM-DD to YYYY-MM-DD
**File Sizes:**
- Tier 1 (summaries): [Size]KB ([Lines] lines) ← Loaded by default
- Tier 2 (details): [Size]KB ([Lines] lines) ← On-demand only

**Key Topics:**
- Topic 1 (brief description)
- Topic 2 (brief description)
- Topic 3 (brief description)
- Topic 4 (brief description)

**Critical Learnings (High-Impact):**
1. **Learning 1** - Brief description
2. **Learning 2** - Brief description
3. **Learning 3** - Brief description

**Archive Date:** YYYY-MM-DD

---

## Future Months

**[Next Month]:** Will be archived [Date]
**[Previous Month]:** If learnings exist, archive separately

---

## Search Tips

**Find by topic:**
```bash
grep -r "topic" learnings-archive/*.md
grep -r "skill activation" learnings-archive/*.md
```

**Find by date:**
```bash
grep "^## YYYY-MM-DD" learnings-archive/YYYY-MM-detailed.md
```

**Find critical/high-impact:**
```bash
grep -i "critical\|CRITICAL\|Severity: CRITICAL" learnings-archive/*.md
```

---

## Maintenance

**Monthly Archiving Process:**

1. **Extract last month** from `../learnings.md`:
   ```bash
   # Extract all entries from previous month
   # Save to learnings-archive/YYYY-MM-detailed.md
   ```

2. **Update this INDEX.md:**
   - Add new month section
   - Summarize key topics
   - List entry count
   - Note critical learnings

3. **Clean ../learnings.md:**
   - Keep only current month entries
   - Verify no content lost
   - Update file size metrics

**Quarterly Review (every 3 months):**
- Review INDEX summaries
- Update search tips if needed
- Verify archive integrity
- Check for patterns across months

---

**Last Updated:** [Date]
**Archive Count:** [Count] archives
**Next Monthly Archive:** [First day of next month]
