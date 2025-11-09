# UFC Intent Mapping

**Purpose:** Dynamically map user intent to UFC context files without code changes.

**How it works:**
- Hook reads this file on every UserPromptSubmit
- Matches keywords from user prompt against intents
- Automatically loads relevant context files
- **Zero code changes needed** - just edit this file!

**Format:**
```
## Intent: [Name]
Keywords: keyword1, keyword2, phrase with spaces
Load: path/to/context.md, another/context.md
Priority: [high|medium|low] (optional, defaults to medium)
```

---

## Intent: Content Creation

Keywords: write, create, blog, article, post, documentation, docs, content
Load: preferences/writing-style.md
Priority: high
Note: Apply style guidelines (configure content-guard.ts hook for quality rules)

## Intent: System Development

Keywords: develop, build, implement, code, create system, architecture, design
Load: preferences/stack.md, memory/decisions/INDEX.md
Priority: high

## Intent: Tool Integration

Keywords: mcp, tool, integration, api, service, connect
Load: tools/mcps.md, tools/tools.md
Priority: medium

## Intent: Git Operations

Keywords: git, commit, push, pull, branch, merge, repository, repo
Load: preferences/security.md
Priority: high
Note: CRITICAL - Security verification required before git operations

## Intent: Architecture Decision

Keywords: architecture, design decision, adr, decision, pattern, approach
Load: memory/decisions/INDEX.md
Priority: medium

## Intent: Learning from Experience

Keywords: learning, lesson, mistake, error, problem, issue, incident
Load: memory/learnings.md, memory/analysis/INDEX.md
Priority: medium

---

## Notes

**Priority levels:**
- `high` = Always load when keywords match (critical context)
- `medium` = Load when keywords match (helpful context)
- `low` = Load only if specifically mentioned (optional context)

**Maintenance:**
- Add new intents as new tools/contexts are added
- Update keywords based on usage patterns
- No code changes required - just edit this file!
- Keep keywords lowercase for case-insensitive matching

**Bilingual support:**
- Include keywords in all relevant languages
- Natural mixing of languages expected
- Example: "implementera TypeScript", "write svenska content"

**Future additions:**
- Add intent sections as new MCP servers configured
- Add project-specific intents
- Add domain-specific intents

---

**Version:** 1.0
**Last Updated:** <DATE>
**Maintenance:** Review quarterly, update as needed
