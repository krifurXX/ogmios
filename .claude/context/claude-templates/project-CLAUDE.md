# 🚨 CRITICAL: [PROJECT NAME] CONTEXT 🚨

**READ THIS BEFORE DOING ANYTHING**

---

## 🚨🚨🚨 MANDATORY FIRST ACTION 🚨🚨🚨

**BEFORE responding to user input, you MUST:**

1. Use Read tool: `~/.claude/.claude/context/UFC.md`
2. Use Read tool: `~/.claude/.claude/context/projects/[project-slug].md`
3. Use Read tool: `~/.claude/.claude/PAI.md`

**SHOW in response:** "✅ Context loaded: [files]"

**FAILURE TO LOAD = LYING about having proper context.**

---

## 📋 Project Overview

**Name:** [Project Name]
**Type:** [Type - e.g., PAI Development, Web App, Research, etc.]
**Location:** `[Absolute Path]`
**Purpose:** [One-line purpose]
**Language:** [English/Swedish/Both]

---

## 🚨 SECURITY WARNINGS 🚨

[Project-specific security requirements with firm language]

**CRITICAL:**
1. [Security requirement 1]
2. [Security requirement 2]
3. NEVER [prohibited action]

**Verification required BEFORE:**
- Git operations: Check remote 3 times (`git remote -v`)
- File operations: Verify path exists with LS
- [Other critical operations]

**🚨 GIT SAFETY PROTOCOL:**

BEFORE any `git push`:
1. Run `git remote -v`
2. VERIFY URL matches expected repository
3. CHECK you're not on main/master (unless explicitly requested)

NEVER push to wrong remote = Potential data breach.

---

## 🎯 Current Phase/Sprint

**Status:** [In Progress/Blocked/Completed]

**Current Goals:**
- [ ] [Goal 1]
- [ ] [Goal 2]
- [ ] [Goal 3]

**See:** `~/.claude/.claude/context/projects/[slug].md` for full details

---

## 📚 Critical Documentation

**MUST READ (if working on these areas):**
- [Link 1 with description]
- [Link 2 with description]

**Reference as needed:**
- [Link 3 with description]
- [Link 4 with description]

---

## 🇸🇪/🇬🇧 Language Settings

**Primary Language:** [Swedish/English/Both]

**Response Language:** Match user input language

**Voice System:**
- Swedish voice: `JhAQDwsLijg4qbxGNQGH` (Ogmios Swedish)
- English voice: `goT3UYdM9bhm0n2lmKQx` (Ogmios English - older storytelling)

**Voice Selection Rule:**
- User writes Swedish → Response in Swedish, Swedish voice
- User writes English → Response in English, English voice
- British skill voices (George, Alice, Marcus) → ALWAYS English text
- Swedish skill voices (Lars Bergström) → ALWAYS Swedish text

---

## 📝 Response Format

**Use structured format for all responses:**

```
📅 [Current date YYYY-MM-DD HH:MM:SS]
🗨️ [Language matched to input]
📋 SUMMARY: Brief overview
🔍 ANALYSIS: Key findings
⚡ ACTIONS: Steps taken
✅ RESULTS: Outcomes (SHOW ACTUAL OUTPUT)
📊 STATUS: Current state
➡️ NEXT: Recommended follow-up
🎯 COMPLETED: [Task description in 10-12 words]
🗣️ CUSTOM COMPLETED: [Voice-optimized under 8 words]
```

**COMPLETED keywords MUST be in ENGLISH** (even for Swedish responses)

---

## 🎯 Project-Specific Stack

**Preferred Technologies:**
[List project-specific preferences]

**Package Managers:**
- JavaScript/TypeScript: bun (NOT npm/yarn/pnpm)
- Python: uv (NOT pip)

**See:** `~/.claude/.claude/context/preferences/stack.md` for global preferences

---

## 🚨 Project-Specific Prohibitions

[List any project-specific forbidden patterns or approaches]

**NEVER:**
- ❌ [Prohibited action 1]
- ❌ [Prohibited action 2]
- ❌ [Prohibited action 3]

**ALWAYS:**
- ✅ [Required action 1]
- ✅ [Required action 2]
- ✅ [Required action 3]

---

## 🔄 UFC Layer 4: Symlink Safety Net

This file should have a symlink at `.claude/claude.md → ../claude.md`

If you're reading this from `.claude/`, the symlink is working! ✅

---

## 💡 Quick Reference

**If you need to:**
- Understand system architecture → Read `context/UFC.md`
- Know project status → Read `context/projects/[slug].md`
- Check past decisions → Read `context/memory/decisions.md`
- Learn from mistakes → Read `context/memory/learnings.md`

---

**Remember:** [Project-specific philosophy or reminder]

**This project is part of <YOUR_NAME>'s [context - e.g., PAI system, PhD research, etc.].**

---

**Template Version:** 1.0 (Enhanced with Phase 5 enforcement)
**Last Updated:** 2025-11-03
**Based On:** Daniel Miessler's Kai aggressive CLAUDE.md pattern
