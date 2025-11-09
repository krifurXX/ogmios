# UFC - Universal File-based Context System

[🇬🇧 English](ufc-system.md) | [🇸🇪 Svenska](../06-bilingual/svenska/ufc-systemet.md)

---

## What is UFC?

**UFC (Universal File-based Context)** is the core of Ogmios - a file-based system that loads exactly the right context at exactly the right time.

**Central philosophy:** "The file system IS the context system"

Instead of:
- ❌ Everything in one claude.md
- ❌ Relying on AI memory
- ❌ Re-explaining preferences every session

You get:
- ✅ Logical, hierarchical organization
- ✅ Automatic context loading
- ✅ Preferences defined once, used everywhere
- ✅ Context that persists between sessions

---

## Directory Structure

```
~/.claude/.claude/context/
├── UFC.md                  # System description
├── tools/                  # Tools and MCP
├── projects/               # Project context
├── preferences/            # User preferences
├── memory/                 # Memory and decisions
│   ├── decisions/
│   └── learnings.md
└── languages/              # Language support
```

---

## Progressive Disclosure

UFC uses **3 tiers** to balance speed and depth:

**Tier 1: Metadata** (<5KB) - Always loaded, quick overview
**Tier 2: Core content** (10-50KB) - Loaded when needed
**Tier 3: Deep context** (Unlimited) - Loaded on explicit request

---

## How UFC Works

### 1. Intent Detection
Analyzes your prompt to identify intent

### 2. Context Mapping
Maps intents to relevant context files

### 3. Dynamic Loading
UserPromptSubmit hook loads context automatically

### 4. AI Response
AI gets exactly the context needed

**Example Flow:**
```
User: "Implement authentication for the web project"
  ↓
Detects: implementation + authentication + web project
  ↓
Loads:
  - projects/web-project.md
  - tools/auth-stack.md
  - preferences/coding-style.md
  ↓
AI responds with full project knowledge
```

---

## Context Files

### projects/[project-name].md
Project-specific information

### preferences/stack.md
Technology choices and preferences

### preferences/coding-style.md
Code style and conventions

### memory/decisions/INDEX.md
Architecture Decision Records overview

### memory/learnings.md
Insights and lessons learned

---

## Nesting Guidelines

**MAX 3 LEVELS DEEP!**

✅ Good: `context/projects/ml-project/team.md` (3 levels)
❌ Avoid: `context/projects/ml-project/docs/api.md` (4 levels)

---

## Creating Custom Context Files

1. Identify the need
2. Choose right category (tools/projects/preferences/memory/languages)
3. Create the file
4. Use clear structure
5. Reference in hook

---

## Best Practices

✅ **DO:**
- Keep files focused
- Use clear headings
- Write in clean Markdown
- Update regularly

❌ **DON'T:**
- Duplicate information
- Nest deeper than 3 levels
- Mix categories
- Write overly long files

---

**Back to:** [README](01-README.md) | [Architecture](02-ARCHITECTURE.md) | **Next:** [Skills System](04-SKILLS-SYSTEM.md)
