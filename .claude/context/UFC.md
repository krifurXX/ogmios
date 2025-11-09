# UFC - Universal File-based Context System

**Owner:** <YOUR_NAME>
**Created:** <DATE>
**Last Updated:** <DATE>

---

## What is UFC?

**UFC (Universal File-based Context)** is the backbone of this PAI - a file-based system that loads exactly the right context at exactly the right time.

**Central philosophy:** "The file system IS the context system"

---

## System Architecture

### Progressive Disclosure (3-Tier System)

**Tier 1: Metadata** (<5KB)
- Quick overview
- Always loaded first
- Minimal context window usage

**Tier 2: Core Content** (10-50KB)
- Loaded when intent detected
- Main working context
- Balances detail and speed

**Tier 3: Deep Context** (50KB+)
- Loaded on explicit request
- Full technical documentation
- Maximum detail

---

## Directory Structure

```
~/.claude/.claude/context/
├── UFC.md                     # This file - system overview
│
├── projects/                  # Project-specific context
│   ├── <project-name>.md      # Main project context
│   └── <project-name>/        # Optional subdirectory (max 3 levels!)
│       ├── stack.md           # Tech stack for this project
│       └── team.md            # Team/collaboration info
│
├── tools/                     # Tools and integrations
│   ├── git.md                 # Git workflow and conventions
│   ├── database.md            # Database preferences
│   └── <tool-name>.md         # Other tool-specific context
│
├── preferences/               # User preferences
│   ├── stack.md               # Default tech stack
│   ├── coding-style.md        # Code style preferences
│   └── workflow.md            # Work habits and preferences
│
├── memory/                    # Memory and learnings
│   ├── decisions.md           # Architecture Decision Records
│   └── learnings.md           # Lessons learned
│
└── languages/                 # Language preferences
    ├── bilingual.md           # Multi-language handling (if applicable)
    ├── english.md             # English-specific preferences
    └── <language>.md          # Other language preferences
```

---

## How UFC Works

### 1. Intent Detection
Hook analyzes user prompt to identify intent:
- Keywords (build, implement, research, etc.)
- Technology mentions (React, Python, etc.)
- Project references
- Language cues

### 2. Context Mapping
Maps detected intents to relevant context files:

```
Intent: "Build authentication for web project"
  ↓
Detected:
  - Task type: implementation (code)
  - Technology: authentication
  - Project: web project
  ↓
Maps to:
  - projects/web-project.md
  - tools/auth-stack.md
  - preferences/coding-style.md
```

### 3. Dynamic Loading
UserPromptSubmit hook loads context files before AI response

### 4. AI Response
AI generates response with full context

---

## Context File Templates

### Project Context Template

```markdown
# Project: <PROJECT_NAME>

**Status:** Active/Dormant/Completed
**Location:** <PATH>
**Stack:** <TECH_STACK>
**Goal:** <BRIEF_DESCRIPTION>

## Overview
[Brief project description]

## Tech Stack
- Frontend: <FRAMEWORK>
- Backend: <FRAMEWORK>
- Database: <DATABASE>
- Infrastructure: <CLOUD/HOSTING>

## Key Conventions
- [Convention 1]
- [Convention 2]

## Active Tasks
- [ ] Task 1
- [ ] Task 2
```

### Tool Context Template

```markdown
# Tool: <TOOL_NAME>

**Category:** Development/Design/Research/etc.
**Version:** <VERSION>

## Preferred Usage
[How you prefer to use this tool]

## Common Commands
```bash
# Command 1
<command>

# Command 2
<command>
```

## Conventions
- [Convention 1]
- [Convention 2]
```

---

## Intent Patterns (Customizable)

Edit `~/.claude/.claude/hooks/load-ufc-context.ts` to add custom patterns:

```typescript
const INTENT_PATTERNS = {
  // Your custom intents
  "project-web": ["web app", "frontend", "backend", "api"],
  "project-ml": ["machine learning", "pytorch", "tensorflow"],

  // Language-specific
  "swedish": ["svensk", "svenska", "på svenska"],

  // Tool-specific
  "git": ["git", "commit", "push", "branch"],
  "database": ["database", "sql", "query"],
};
```

---

## Context File Mapping

Map intents to context files in hook configuration:

```typescript
const CONTEXT_FILE_MAPPING = {
  "project-web": [
    "projects/web-project.md",
    "preferences/coding-style.md"
  ],
  "project-ml": [
    "projects/ml-project.md",
    "tools/python-ml-stack.md"
  ],
  "swedish": [
    "languages/swedish.md",
    "languages/bilingual.md"
  ],
};
```

---

## Nesting Guidelines

**RULE: Maximum 3 levels deep**

✅ **Good Examples:**
```
context/projects/ml-project.md          (2 levels)
context/projects/ml-project/stack.md    (3 levels)
context/tools/git.md                    (2 levels)
```

❌ **Avoid:**
```
context/projects/ml-project/docs/api/endpoints.md  (5 levels - too deep!)
```

**Why?** Deep nesting makes files hard to find and manage.

---

## Best Practices

### DO:
- ✅ Keep files focused on one topic
- ✅ Use clear, descriptive filenames
- ✅ Write in clean Markdown
- ✅ Update files regularly
- ✅ Use templates for consistency
- ✅ Document intent patterns in UFC.md

### DON'T:
- ❌ Duplicate information across files
- ❌ Create files deeper than 3 levels
- ❌ Mix different categories in one file
- ❌ Write overly long files (>50KB without good reason)
- ❌ Leave outdated information

---

## Example Workflow

### Scenario: User asks about web project

**User Input:**
```
"Implement user authentication for the web project using JWT"
```

**Hook Detection:**
- Intent: implementation (code)
- Technology: authentication, JWT
- Project: web project

**Loaded Context:**
1. `context/UFC.md` (always loaded)
2. `context/projects/web-project.md`
3. `context/tools/auth-stack.md`
4. `context/preferences/coding-style.md`

**Result:**
AI responds with full knowledge of:
- Web project structure and conventions
- Preferred auth stack and JWT implementation
- Coding style preferences
- Project-specific requirements

---

## Customization Guide

### 1. Add New Project Context

```bash
# Create project file
nano ~/.claude/.claude/context/projects/my-project.md

# Update intent patterns in hook
nano ~/.claude/.claude/hooks/load-ufc-context.ts
```

### 2. Add New Tool Context

```bash
# Create tool file
nano ~/.claude/.claude/context/tools/my-tool.md

# Map intent to file in hook
```

### 3. Add Language Support

```bash
# Create language file
nano ~/.claude/.claude/context/languages/my-language.md

# Add language detection patterns in hook
```

---

## Maintenance

### Regular Updates
- Review and update project context when projects evolve
- Update tool contexts when versions change
- Add new learnings to `memory/learnings.md`
- Document decisions in `memory/decisions.md`

### Cleanup
- Archive completed projects
- Remove obsolete tool contexts
- Consolidate duplicate information

---

## Advanced: Multi-Project Support

For complex setups with many projects:

```
context/projects/
├── active/
│   ├── project-a.md
│   └── project-b.md
├── dormant/
│   └── old-project.md
└── templates/
    └── project-template.md
```

Update hook to scan `active/` directory for current projects.

---

## Troubleshooting

**Issue:** Context not loading
- Check hook is configured in `settings.json`
- Verify file paths are correct
- Check hook logs for errors

**Issue:** Wrong context loaded
- Review intent patterns in hook
- Add more specific keywords
- Check context file mapping

**Issue:** Too much context loaded
- Refine intent detection
- Split large files into smaller ones
- Use tier system more strictly

---

## Related Files

- **PAI.md** - Core identity and system configuration
- **memory/decisions.md** - Architecture decisions
- **memory/learnings.md** - Lessons learned
- **hooks/load-ufc-context.ts** - Context loading hook

---

**UFC v1.0 - Context system for <YOUR_NAME>'s PAI**
