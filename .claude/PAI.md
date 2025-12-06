# Personal AI Infrastructure (PAI)

**Name:** <YOUR_NAME>
**Version:** 2.0
**Last updated:** <DATE>

> **Quick Start:** First time? See `.claude/documentation/01-getting-started/quick-start.md`

---

## 🚨 MANDATORY FIRST ACTIONS

**Before every response:**

1. Load context: `~/.claude/.claude/context/UFC.md`
2. Load project context: `~/.claude/.claude/context/projects/`
3. Show: "✅ Context loaded: [files]"

**Check for applicable skill:**

1. Read `~/.claude/.claude/SKILLS-INDEX.md`
2. Match task type to skill (code → engineering, research → research, etc.)
3. Activate skill BEFORE using tools

**Why:** Skills = specialists (100% capacity). No skills = generalist (30% capacity).

---

## 👤 About Me

**Background:**
- Profession: <YOUR_PROFESSION>
- Education: <YOUR_EDUCATION>
- Focus: <RELEVANT_INTERESTS>

**Work Preferences:**
- Style: <E.G., "Terminal over GUI">
- Peak hours: <E.G., "Mornings">
- Language: <E.G., "English + Swedish">

**Tech Stack:**
- Editor: <E.G., "NeoVim">
- Shell: <E.G., "zsh">
- Runtime: <E.G., "bun">

---

## 🎯 PAI Purpose

**This system helps me:**

1. <Main Purpose 1> - E.g., "Academic research and writing"
2. <Main Purpose 2> - E.g., "Development automation"
3. <Main Purpose 3> - E.g., "Knowledge organization"

---

## 🛠️ Enabled Systems

### UFC Context
- **Location:** `~/.claude/.claude/context/`
- **See:** `.claude/documentation/04-ufc-system/` for details

### Skills (20+ specialists)
- ✅ engineering, architecture, research, security
- **See:** `.claude/SKILLS-INDEX.md` for all skills

### Voice System (Optional)
- Provider: <ElevenLabs/etc.>
- Default voice: <VOICE_ID>
- **See:** `.claude/documentation/05-voice-system/` for setup

### MCP Servers
- Configured: <GitHub, Zotero, etc.>
- **See:** `.claude/.mcp.json.example` and `.claude/context/tools/`

---

## 🎨 Response Style

**Tone:**
- Concise and direct
- Match input language
- Minimal emojis (only for clarity)

**Format:**
```
📋 SUMMARY: [Brief overview]
⚡ ACTIONS: [What was done]
✅ RESULTS: [Outcomes]
➡️ NEXT: [Recommendations]
```

---

## 🚀 Current Focus

### Active Projects

**Project:** <PROJECT_NAME>
- **Path:** `<PROJECT_PATH>`
- **Context:** `context/projects/<slug>.md`
- **Status:** <ACTIVE/DORMANT>

---

## 🔒 Security Protocol

**Git Safety (CRITICAL):**
```bash
git remote -v  # Run 3 times before ANY commit/push
```

**Never commit:**
- `PAI.md` (personal)
- `.env` (secrets)
- `.mcp.json` (credentials)
- Project contexts with sensitive data

**See:** `SECURITY.md` and `.claude/documentation/07-security/`

---

## 📚 Documentation

**Essential reading:**
- Architecture: `.claude/documentation/03-architecture/overview.md`
- Skills: `.claude/SKILLS-INDEX.md`
- UFC: `.claude/context/UFC.md`
- Troubleshooting: `.claude/documentation/08-faq/troubleshooting.md`

**Full docs:** `.claude/documentation/` (English + Swedish)

---

## 📝 Memory & Decisions

**Architectural decisions:** `context/memory/decisions.md`
**Lessons learned:** `context/memory/learnings.md`
**Latest updates:** See above files

---

## 💡 Core Principles

1. **System > Model** - Architecture matters most
2. **Text as Thought** - Markdown for everything
3. **Build Once** - Reusable solutions
4. **Context is King** - Right info, right time
5. **<Your principle>** - <E.g., "Security first">

---

**PAI v2.0 - Simplified with Progressive Disclosure**
**See `.claude/documentation/` for comprehensive guides**
