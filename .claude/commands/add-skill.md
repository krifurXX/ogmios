---
description: Create a new specialized skill with template structure
---

# Add New Skill

**Task:** Create a new skill following Ogmios skill architecture.

## Steps to Execute

1. **Ask user for skill details:**
   - Skill name (lowercase, hyphens for multi-word)
   - Skill purpose (one sentence)
   - Primary use cases (3-5 examples)
   - Tools needed (Read, Write, Bash, WebFetch, etc.)
   - Voice ID (if voice system enabled)
   - Language (English/Swedish/Both)
   - Intent patterns (what user requests trigger this skill)

2. **Create skill directory:**
   ```bash
   mkdir -p ~/.claude/.claude/skills/<skill-name>
   ```

3. **Create skill.md:**
   Location: `~/.claude/.claude/skills/<skill-name>/skill.md`

   Include:
   ```markdown
   ---
   description: <One-line description>
   ---

   # <Skill Name> Skill

   **Purpose:** <What this skill does>

   **When to use:**
   - <Use case 1>
   - <Use case 2>
   - <Use case 3>

   **Intent patterns:**
   - "keyword1", "keyword2"
   - Example: "debug", "troubleshoot", "fix error"

   **Voice:** <Voice ID or "default">

   ## Instructions

   <Detailed instructions for Claude when activated as this skill>

   ## Tools

   Available tools:
   - <Tool 1>
   - <Tool 2>

   ## Examples

   **Example 1:**
   User: "<Example user request>"
   Skill: "<How skill should respond>"

   **Example 2:**
   User: "<Another example>"
   Skill: "<Response approach>"
   ```

4. **Create system-prompt.md (optional):**
   Location: `~/.claude/.claude/skills/<skill-name>/system-prompt.md`

   Custom system prompt overrides for this skill (advanced usage).

5. **Create examples directory:**
   ```bash
   mkdir -p ~/.claude/.claude/skills/<skill-name>/examples
   ```

   Add example interactions demonstrating skill usage.

6. **Update SKILLS-INDEX.md:**
   - Location: `~/.claude/.claude/SKILLS-INDEX.md`
   - Add new skill entry with:
     - Name
     - Description
     - Intent patterns
     - Voice ID
     - Status (active/beta/experimental)

7. **Test skill activation:**
   - Use intent pattern in a prompt
   - Verify skill loads correctly
   - Check voice works (if enabled)

## Skill Template

```markdown
---
description: <One-line description>
---

# <Skill Name> Skill

**Purpose:** <Core function>

**When to use:**
- <Scenario 1>
- <Scenario 2>
- <Scenario 3>

**Intent patterns:**
- "<keyword1>", "<keyword2>", "<keyword3>"

**Voice:** <voice-id or "default">

---

## Core Instructions

When activated, you are a specialist in <domain>.

Your approach:
1. <Step 1>
2. <Step 2>
3. <Step 3>

Your focus:
- <Priority 1>
- <Priority 2>

Avoid:
- <Anti-pattern 1>
- <Anti-pattern 2>

---

## Tools

You have access to:
- **Read** - For examining files
- **Write** - For creating files
- **Edit** - For modifying files
- **Bash** - For running commands
- **<Custom tool>** - For <purpose>

---

## Response Format

Use this structure:

\`\`\`
🎯 ANALYSIS: <Brief analysis>
⚡ APPROACH: <Strategy>
✅ RESULT: <Outcome>
➡️ NEXT: <Recommendations>
\`\`\`

---

## Examples

**Example 1: <Use case>**

User: "<Example request>"

Response:
<How skill should respond>

**Example 2: <Another use case>**

User: "<Another request>"

Response:
<Another response approach>
```

## Verification

After creation:
```bash
# Check skill files
ls -la ~/.claude/.claude/skills/<skill-name>/

# Verify SKILLS-INDEX.md updated
grep "<skill-name>" ~/.claude/.claude/SKILLS-INDEX.md

# Test activation
# Use intent pattern in conversation and verify skill loads
```

## Notes

- Skill names should be descriptive and URL-safe
- Intent patterns should be unique and specific
- Keep skill.md focused (under 200 lines)
- Use examples/ directory for detailed demonstrations
- Test thoroughly before marking as "active" in index

---

**Usage:** `/add-skill`
