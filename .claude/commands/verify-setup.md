---
description: Validate Ogmios installation and configuration
---

# Verify Ogmios Setup

**Task:** Run comprehensive checks to validate Ogmios installation and configuration.

## Verification Steps

### 1. Directory Structure

Check all required directories exist:

```bash
ls -la ~/.claude/.claude/
```

**Expected directories:**
- `context/` (UFC system)
- `skills/` (20+ specialists)
- `hooks/` (TypeScript automation)
- `documentation/` (guides)
- `scripts/` (utilities)
- `voice-server/` (optional)

### 2. Core Files

Verify essential files:

```bash
# Core configuration
test -f ~/.claude/.claude/PAI.md && echo "✅ PAI.md" || echo "❌ PAI.md MISSING"
test -f ~/.claude/.claude/settings.json && echo "✅ settings.json" || echo "❌ settings.json MISSING"

# Context system
test -f ~/.claude/.claude/context/UFC.md && echo "✅ UFC.md" || echo "❌ UFC.md MISSING"

# Skills index
test -f ~/.claude/.claude/SKILLS-INDEX.md && echo "✅ SKILLS-INDEX.md" || echo "❌ SKILLS-INDEX.md MISSING"
```

### 3. TypeScript Hooks

Validate hooks setup:

```bash
cd ~/.claude/.claude/hooks

# Check dependencies installed
test -d node_modules && echo "✅ Dependencies installed" || echo "❌ Run: bun install"

# Type check
bun run type-check && echo "✅ TypeScript OK" || echo "❌ Type errors found"

# Lint check
bun run lint 2>/dev/null && echo "✅ Lint passed" || echo "⚠️  Lint warnings (optional)"
```

### 4. Skills Validation

Check skills are properly configured:

```bash
# Count skills
skill_count=$(find ~/.claude/.claude/skills -maxdepth 1 -type d | tail -n +2 | wc -l)
echo "📊 Skills found: $skill_count"

# Verify core skills exist
for skill in engineering architecture research security; do
  test -d ~/.claude/.claude/skills/$skill && echo "✅ $skill" || echo "❌ $skill MISSING"
done

# Check SKILLS-INDEX.md is populated
line_count=$(wc -l < ~/.claude/.claude/SKILLS-INDEX.md)
test $line_count -gt 50 && echo "✅ SKILLS-INDEX.md populated" || echo "⚠️  SKILLS-INDEX.md may be incomplete"
```

### 5. Context System

Verify UFC structure:

```bash
cd ~/.claude/.claude/context

# Check tier directories
for dir in projects technical memory tools languages; do
  test -d $dir && echo "✅ context/$dir" || echo "❌ context/$dir MISSING"
done

# Check memory subdirectories
test -d memory/decisions && echo "✅ memory/decisions" || echo "⚠️  memory/decisions missing"
test -d memory/learnings-archive && echo "✅ memory/learnings-archive" || echo "⚠️  memory/learnings-archive missing"
```

### 6. Voice System (Optional)

If voice system enabled:

```bash
cd ~/.claude/.claude/voice-server

# Check .env exists
test -f .env && echo "✅ .env configured" || echo "⚠️  Voice disabled (no .env)"

# Check dependencies
test -d node_modules && echo "✅ Voice dependencies installed" || echo "⚠️  Run: bun install"

# Validate .env has API key
if [ -f .env ]; then
  grep -q "ELEVENLABS_API_KEY=" .env && echo "✅ API key set" || echo "❌ API key missing in .env"
fi
```

### 7. MCP Servers (Optional)

Check MCP configuration:

```bash
# Check .mcp.json exists
test -f ~/.claude/.claude/.mcp.json && echo "✅ MCP configured" || echo "⚠️  No MCP servers (optional)"

# Validate JSON syntax
if [ -f ~/.claude/.claude/.mcp.json ]; then
  cat ~/.claude/.claude/.mcp.json | jq . >/dev/null 2>&1 && echo "✅ Valid JSON" || echo "❌ Invalid JSON in .mcp.json"
fi
```

### 8. Customization Check

Verify user has customized templates:

```bash
# Check PAI.md for placeholders
if grep -q "<YOUR_NAME>" ~/.claude/.claude/PAI.md; then
  echo "⚠️  PAI.md has uncustomized placeholders"
else
  echo "✅ PAI.md customized"
fi

# Check for placeholder patterns
placeholder_count=$(grep -c "<.*>" ~/.claude/.claude/PAI.md 2>/dev/null || echo 0)
echo "📊 Remaining placeholders in PAI.md: $placeholder_count"
```

### 9. Git Safety

Verify .gitignore protection:

```bash
cd ~/.claude/.claude

# Check .gitignore exists
test -f .gitignore && echo "✅ .gitignore present" || echo "⚠️  No .gitignore"

# Verify sensitive files are ignored
if [ -f .gitignore ]; then
  for pattern in ".env" ".mcp.json" "PAI.md"; do
    grep -q "$pattern" .gitignore && echo "✅ $pattern ignored" || echo "❌ $pattern NOT in .gitignore"
  done
fi
```

### 10. Documentation

Check documentation is complete:

```bash
# Count documentation files
doc_count=$(find ~/.claude/.claude/documentation -name "*.md" | wc -l)
echo "📚 Documentation files: $doc_count"

# Check bilingual support
test -d ~/.claude/.claude/documentation/06-bilingual/svenska && echo "✅ Swedish docs available" || echo "⚠️  Swedish docs missing"
```

## Summary Report

After all checks, provide summary:

```markdown
## Ogmios Setup Verification

**Status:** ✅ READY / ⚠️  NEEDS ATTENTION / ❌ INCOMPLETE

### Passed ✅
- <List passed checks>

### Warnings ⚠️
- <List optional items missing>

### Failed ❌
- <List critical issues>

### Recommendations
1. <Fix 1>
2. <Fix 2>

### Next Steps
- [ ] <Action 1>
- [ ] <Action 2>
```

## Quick Fix Commands

**Install hook dependencies:**
```bash
cd ~/.claude/.claude/hooks && bun install
```

**Install voice server dependencies:**
```bash
cd ~/.claude/.claude/voice-server && bun install
```

**Create missing directories:**
```bash
cd ~/.claude/.claude
mkdir -p context/{projects,technical,memory/decisions,tools,languages}
```

**Customize PAI.md:**
```bash
nano ~/.claude/.claude/PAI.md
# Replace all <PLACEHOLDERS>
```

## Notes

- Run this verification after initial installation
- Run periodically to catch configuration drift
- Green checks (✅) = fully working
- Yellow warnings (⚠️) = optional features
- Red failures (❌) = critical issues

---

**Usage:** `/verify-setup`
