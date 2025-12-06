---
description: Setup a new project with CLAUDE.md and UFC context
---

# Scaffold New Project

**Task:** Create a complete project setup with CLAUDE.md and UFC context.

## Steps to Execute

1. **Ask user for project details:**
   - Project name
   - Project type (web app, API, research, CLI tool, etc.)
   - Primary programming language/stack
   - Project location (absolute path)
   - Primary language (English/Swedish/Both)

2. **Create project CLAUDE.md:**
   - Use template from `~/.claude/.claude/context/claude-templates/project-CLAUDE.md`
   - Customize with user's answers
   - Place in project root: `<project-path>/CLAUDE.md`
   - Replace all `<PLACEHOLDERS>` with actual values

3. **Create project context file:**
   - Location: `~/.claude/.claude/context/projects/<project-slug>.md`
   - Include:
     - Project overview
     - Tech stack details
     - Current goals/phase
     - File structure
     - Key commands (build, test, lint)
     - Common tasks

4. **Create .claude symlink (if needed):**
   ```bash
   cd <project-path>
   mkdir -p .claude
   ln -s ../CLAUDE.md .claude/claude.md
   ```

5. **Add to PAI.md projects section:**
   - Edit `~/.claude/.claude/PAI.md`
   - Add project to "Current Focus" section

6. **Show summary:**
   - List all created files
   - Show next steps (customize placeholders, add to git)
   - Remind about `.gitignore` for sensitive data

## Template Customization

**Replace these placeholders:**
- `[PROJECT NAME]` → User's project name
- `[Type]` → Project type
- `[Absolute Path]` → Full project path
- `[Purpose]` → One-line purpose
- `[Language]` → English/Swedish/Both
- `<slug>` → kebab-case project identifier

**Customize sections:**
- Security warnings (project-specific)
- Tech stack preferences
- Git safety protocol
- Critical documentation links

## Example

**User input:**
- Name: "Task Manager API"
- Type: "REST API"
- Stack: "Node.js + TypeScript + PostgreSQL"
- Path: "/Users/john/projects/task-api"
- Language: "English"

**Creates:**
- `/Users/john/projects/task-api/CLAUDE.md`
- `~/.claude/.claude/context/projects/task-api.md`
- `/Users/john/projects/task-api/.claude/claude.md` (symlink)

## Verification

After scaffolding, verify:
```bash
ls -la <project-path>/CLAUDE.md
ls -la ~/.claude/.claude/context/projects/<slug>.md
cat <project-path>/.claude/claude.md  # Should show CLAUDE.md content
```

## Notes

- Always use absolute paths for project locations
- Slug should be URL-safe (lowercase, hyphens only)
- Symlink enables Layer 4 UFC (local .claude/ override)
- User must manually customize remaining placeholders

---

**Usage:** `/scaffold-project`
