# Troubleshooting Guide - Ogmios PAI

🇬🇧 English | [🇸🇪 Svenska](../06-bilingual/svenska/felsökning.md)

**Last updated:** 2025-11-09
**Version:** 1.0

---

## 📋 Contents

1. [Quick Diagnosis](#quick-diagnosis)
2. [Claude Code Issues](#claude-code-issues)
3. [Installation Issues](#installation-issues)
4. [Hooks Issues](#hooks-issues)
5. [Skills Issues](#skills-issues)
6. [UFC Context Issues](#ufc-context-issues)
7. [Voice System Issues](#voice-system-issues)
8. [MCP Server Issues](#mcp-server-issues)
9. [Performance Issues](#performance-issues)
10. [Bilingual Issues](#bilingual-issues)
11. [Verification Script](#verification-script)
12. [Getting Help](#getting-help)

---

## Quick Diagnosis

**Run this first to identify issues:**

```bash
#!/bin/bash
echo "🔍 Ogmios Quick Diagnosis"
echo "========================"

# Claude Code
echo -n "Claude Code: "
if command -v claude &> /dev/null; then
    echo "✅ Installed ($(claude --version))"
else
    echo "❌ MISSING - Install from https://docs.anthropic.com/claude/docs/claude-code"
fi

# PAI.md
echo -n "PAI.md: "
if [ -f ~/.claude/.claude/PAI.md ]; then
    echo "✅ Exists ($(wc -l < ~/.claude/.claude/PAI.md) lines)"
else
    echo "❌ MISSING"
fi

# Settings
echo -n "settings.json: "
if [ -f ~/.claude/.claude/settings.json ]; then
    echo "✅ Exists"
else
    echo "❌ MISSING"
fi

# Hooks
echo -n "Hooks: "
if [ -d ~/.claude/.claude/hooks ]; then
    hook_count=$(ls -1 ~/.claude/.claude/hooks/*.ts 2>/dev/null | wc -l)
    echo "✅ Directory exists ($hook_count .ts files)"
else
    echo "❌ Directory missing"
fi

# Context
echo -n "UFC Context: "
if [ -f ~/.claude/.claude/context/UFC.md ]; then
    echo "✅ UFC.md exists"
else
    echo "❌ UFC.md missing"
fi

# Skills
echo -n "Skills: "
if [ -f ~/.claude/.claude/skills/SKILLS-INDEX.md ]; then
    skill_count=$(grep -c "^### " ~/.claude/.claude/skills/SKILLS-INDEX.md 2>/dev/null || echo 0)
    echo "✅ SKILLS-INDEX.md exists ($skill_count skills)"
else
    echo "❌ SKILLS-INDEX.md missing"
fi

# Bun (for hooks)
echo -n "Bun: "
if command -v bun &> /dev/null; then
    echo "✅ Installed ($(bun --version))"
else
    echo "⚠️  Missing - Hooks won't work"
fi

# Voice Server (optional)
echo -n "Voice Server: "
if curl -s http://localhost:8765/health &> /dev/null; then
    echo "✅ Running"
else
    echo "⚠️  Not running (optional)"
fi

echo "========================"
echo "Run 'claude' to start"
```

**Save as:** `~/.claude/.claude/diagnose.sh`
**Run:** `bash ~/.claude/.claude/diagnose.sh`

---

## Claude Code Issues

### Issue: `claude: command not found`

**Symptom:** When you run `claude` you get "command not found"

**Cause:** Claude Code not installed or not in PATH

**Solution:**

```bash
# Check if installed
which claude

# If missing, install:
# macOS/Linux:
curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/install.sh | sh

# Verify installation
claude --version
```

### Issue: Claude Code won't start

**Symptom:** `claude` crashes or gives error message

**Possible causes:**

1. **Invalid JSON files**
```bash
# Validate settings.json
cat ~/.claude/.claude/settings.json | python3 -m json.tool
# If errors, copy from template again
```

2. **Permission issues**
```bash
# Check and fix permissions
chmod 700 ~/.claude/.claude
chmod 600 ~/.claude/.claude/PAI.md
chmod 600 ~/.claude/.claude/settings.json
```

3. **Corrupt configuration**
```bash
# Backup and restore
mv ~/.claude/.claude/settings.json ~/.claude/.claude/settings.json.backup
cp templates/settings.json ~/.claude/.claude/
# Re-enable hooks gradually
```

### Issue: API connection fails

**Symptom:** "Failed to connect to API" or timeout errors

**Solution:**

```bash
# Check API key
cat ~/.claude/.claude/.env | grep ANTHROPIC_API_KEY

# Check network connection
curl -I https://api.anthropic.com

# Check proxy settings (if using)
echo $HTTP_PROXY
echo $HTTPS_PROXY
```

---

## Installation Issues

### Issue: Templates not found

**Symptom:** `cp: templates: No such file or directory`

**Cause:** Didn't clone repository first

**Solution:**

```bash
# 1. Clone repository
cd ~/Downloads  # or any location
git clone https://github.com/<username>/ogmios-pai.git
cd ogmios-pai

# 2. NOW you can copy templates
cp -r templates/* ~/.claude/.claude/

# Verify
ls -la ~/.claude/.claude/
```

### Issue: Directory structure incorrect

**Symptom:** Files end up in wrong locations

**Expected structure:**
```
~/.claude/.claude/
├── PAI.md
├── settings.json
├── context/
│   ├── UFC.md
│   ├── projects/
│   ├── memory/
│   │   ├── decisions.md
│   │   └── learnings.md
│   └── languages/
├── skills/
│   └── SKILLS-INDEX.md
└── hooks/
    ├── package.json
    ├── session-start.ts
    ├── load-ufc-context.ts
    ├── skill-activation.ts
    ├── stop-voice.ts
    └── log-tool-use.ts
```

**Fix:**
```bash
# Create missing directories
mkdir -p ~/.claude/.claude/context/{projects,memory,languages}
mkdir -p ~/.claude/.claude/skills
mkdir -p ~/.claude/.claude/hooks

# Move files to correct location if misplaced
# Example: If UFC.md is in wrong directory
mv ~/.claude/.claude/UFC.md ~/.claude/.claude/context/
```

### Issue: Permission denied

**Symptom:** "Permission denied" when copying files

**Solution:**

```bash
# Check ownership
ls -la ~/.claude/

# If wrong user, fix:
sudo chown -R $(whoami):$(id -gn) ~/.claude

# Set correct permissions
chmod -R u+rwX ~/.claude/.claude
```

---

## Hooks Issues

### Issue: Hooks not running

**Symptom:** Context not loading, skills not activating, no voice feedback

**Diagnosis:**

```bash
# 1. Check settings.json
cat ~/.claude/.claude/settings.json | grep -A 20 "hooks"

# 2. Check hook files exist
ls -la ~/.claude/.claude/hooks/*.ts

# 3. Check Bun is installed
bun --version

# 4. Test hook manually
cd ~/.claude/.claude/hooks
bun run session-start.ts
```

**Possible solutions:**

**Issue 1: Bun missing**
```bash
# Install Bun
curl -fsSL https://bun.sh/install | bash

# Add to PATH
export PATH="$HOME/.bun/bin:$PATH"
echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.zshrc  # or ~/.bashrc
```

**Issue 2: Dependencies missing**
```bash
cd ~/.claude/.claude/hooks
bun install
```

**Issue 3: Hook syntax error**
```bash
# Validate TypeScript
cd ~/.claude/.claude/hooks
bun run --dry-run session-start.ts

# Check for error messages
```

**Issue 4: settings.json misconfigured**
```json
// Correct format in settings.json:
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bun run ${HOME}/.claude/.claude/hooks/session-start.ts"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bun run ${HOME}/.claude/.claude/hooks/load-ufc-context.ts"
          }
        ]
      },
      {
        "hooks": [
          {
            "type": "command",
            "command": "bun run ${HOME}/.claude/.claude/hooks/skill-activation.ts"
          }
        ]
      }
    ]
  }
}
```

### Issue: Hook timeout

**Symptom:** "Hook timed out" in Claude Code output

**Cause:** Hook takes too long (>5 seconds)

**Solution:**

```typescript
// In your hook, optimize:

// ❌ SLOW - Reads all files every time
const allFiles = await globFiles('context/**/*.md');
for (const file of allFiles) {
  const content = await readFile(file);
  // ...
}

// ✅ FAST - Read only necessary files
const ufcContent = await readFile('context/UFC.md');
// Load more only when needed
```

### Issue: Hook crashes

**Symptom:** Hook starts but gives error

**Debug:**

```bash
# Run hook manually with debug output
cd ~/.claude/.claude/hooks
DEBUG=* bun run session-start.ts

# Check logs
tail -f ~/.claude/.claude/logs/hooks.log  # if you have logging
```

---

## Skills Issues

### Issue: Skills not activating

**Symptom:** Claude responds generically instead of activating specialist

**Diagnosis:**

```bash
# 1. Check SKILLS-INDEX.md exists
cat ~/.claude/.claude/skills/SKILLS-INDEX.md

# 2. Check skill-activation.ts hook is enabled
grep skill-activation ~/.claude/.claude/settings.json

# 3. Test hook manually
cd ~/.claude/.claude/hooks
echo '{"message": "Build a login form"}' | bun run skill-activation.ts
```

**Solutions:**

**Issue 1: SKILLS-INDEX.md missing**
```bash
cp templates/skills/SKILLS-INDEX.md ~/.claude/.claude/skills/
```

**Issue 2: Intent patterns too weak**

Open `~/.claude/.claude/skills/SKILLS-INDEX.md`:

```markdown
### engineering
**Triggers:** code, implement, build, fix, debug, refactor, optimize, test

# Add more specific triggers:
**Triggers:** code, implement, build, fix, debug, refactor, optimize, test,
create, develop, write code, programming, api, frontend, backend, database
```

**Issue 3: Activation threshold too high**

In `skill-activation.ts`, lower threshold:

```typescript
const ACTIVATION_THRESHOLD = 20;  // ← Lower to 15 if skills don't activate often enough
```

### Issue: Wrong skill activates

**Symptom:** Research skill activates for code task

**Cause:** Overlapping triggers

**Fix triggers in SKILLS-INDEX.md:**

```markdown
### engineering
**Triggers:** implement, build, code, develop, fix bug, refactor, optimize
# Specific, technical words

### research
**Triggers:** research, academic, literature, papers, citations, sources
# Academic words

# Avoid generic words like "help", "create", "write" in triggers
```

### Issue: Skill file not found

**Symptom:** "Skill file not found" error

**Solution:**

```bash
# Check file structure
ls -la ~/.claude/.claude/skills/

# Expected:
# skills/
# ├── SKILLS-INDEX.md
# ├── engineering/
# │   └── SKILL.md
# ├── research/
# │   └── SKILL.md
# └── architecture/
#     └── SKILL.md

# Create missing skill files from templates
cp -r templates/skills/* ~/.claude/.claude/skills/
```

---

## UFC Context Issues

### Issue: Context not loading

**Symptom:** Claude responds without "✅ Context hydrated: [files]"

**Diagnosis:**

```bash
# 1. Check UFC.md exists
cat ~/.claude/.claude/context/UFC.md

# 2. Check load-ufc-context.ts hook
ls -la ~/.claude/.claude/hooks/load-ufc-context.ts

# 3. Check hook is enabled
grep load-ufc-context ~/.claude/.claude/settings.json

# 4. Test hook manually
cd ~/.claude/.claude/hooks
echo '{"message": "test"}' | bun run load-ufc-context.ts
```

**Solutions:**

**Issue 1: UFC.md missing**
```bash
cp templates/context/UFC.md ~/.claude/.claude/context/
# Edit and customize to your system
```

**Issue 2: Hook not configured in settings.json**

Add to `settings.json`:
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bun run ${HOME}/.claude/.claude/hooks/load-ufc-context.ts"
          }
        ]
      }
    ]
  }
}
```

### Issue: Wrong context loads

**Symptom:** Context for wrong project loads

**Cause:** Intent detection incorrect

**Fix in load-ufc-context.ts:**

```typescript
// Improve intent detection with more keywords
const projectKeywords = {
  'ecommerce': ['shop', 'cart', 'product', 'checkout', 'payment', 'order'],
  'ml-project': ['machine learning', 'ml', 'model', 'training', 'dataset', 'pytorch'],
  'blog': ['post', 'article', 'wordpress', 'cms', 'publish']
};
```

### Issue: Context too large

**Symptom:** Token limit exceeded, slow response

**Solution - Progressive Disclosure:**

```markdown
<!-- In context/projects/my-project.md -->

## TIER 1 - Quick Start (<5KB)
**Project:** E-commerce
**Stack:** React + FastAPI + PostgreSQL
**Status:** Production
**Keywords:** shop, cart, checkout

<!-- Stop here for Tier 1 -->
---
## TIER 2 - Architecture (10-50KB)
[Detailed architecture...]

---
## TIER 3 - Deep Dive (50KB+)
[API docs, database schemas, etc.]
```

Update hook to load progressively:
```typescript
// Load only Tier 1 first
const tier1Content = content.split('---')[0];
return { systemMessage: tier1Content };
```

---

## Voice System Issues

### Issue: Voice server won't start

**Symptom:** `curl http://localhost:8765/health` gives connection refused

**Diagnosis:**

```bash
# Check if server is running
ps aux | grep voice-server

# Check port is available
lsof -i :8765

# Check Python environment
cd voice-server
python3 --version  # Must be 3.8+
pip3 list | grep flask
```

**Solutions:**

**Issue 1: Dependencies missing**
```bash
cd voice-server
pip3 install -r requirements.txt
```

**Issue 2: Port in use**
```bash
# Change port in .env
echo "PORT=8766" >> .env

# Also update in hooks/stop-voice.ts:
const voiceServerUrl = 'http://localhost:8766';
```

**Issue 3: ElevenLabs API key missing**
```bash
cd voice-server

# Add API key to .env
echo "ELEVENLABS_API_KEY=your_key_here" > .env
echo "ELEVENLABS_DEFAULT_VOICE_ID=your_voice_id" >> .env

# Verify
source .env
curl -H "xi-api-key: $ELEVENLABS_API_KEY" \
  https://api.elevenlabs.io/v1/voices
```

### Issue: No audio plays

**Symptom:** Voice server responds 200 OK but no sound

**Diagnosis:**

```bash
# Test server directly
curl -X POST http://localhost:8765/speak \
  -H "Content-Type: application/json" \
  -d '{"text": "Test", "voice_id": "your_voice_id"}'

# Check audio output
# macOS:
system_profiler SPAudioDataType

# Linux:
aplay -l
```

**Solutions:**

**Issue 1: Audio player missing**

macOS:
```bash
# Should have afplay installed (standard)
which afplay
```

Linux:
```bash
# Install aplay
sudo apt-get install alsa-utils  # Debian/Ubuntu
sudo yum install alsa-utils       # RHEL/CentOS
```

**Issue 2: Wrong Voice ID**
```bash
# Get available voices
curl http://localhost:8765/voices

# Update voice ID in hooks/stop-voice.ts
```

### Issue: Voice lag

**Symptom:** Voice comes 5+ seconds after response

**Solution:**

```typescript
// In hooks/stop-voice.ts, decrease speech_rate for faster synthesis
const speechRate = 260;  // ← Lower to 200 for faster (but less natural)
```

Or use streaming:
```python
# In voice-server/server.py, add streaming
@app.route('/stream', methods=['POST'])
def stream():
    # Use ElevenLabs streaming API for lower latency
    # See: https://elevenlabs.io/docs/api-reference/streaming
```

---

## MCP Server Issues

### Issue: MCP server won't connect

**Symptom:** "MCP server connection failed" in Claude Code

**Diagnosis:**

```bash
# Check .mcp.json exists
cat ~/.claude/.mcp.json

# Test server individually
# Example for GitHub:
npx -y @modelcontextprotocol/server-github --version
```

**Solutions:**

**Issue 1: .mcp.json incorrect**

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

**Issue 2: API token missing or invalid**

```bash
# GitHub token
# Create new at: https://github.com/settings/tokens
# Add to .mcp.json under "env"

# Zotero
# Get API key: https://www.zotero.org/settings/keys
# Get User ID: https://www.zotero.org/settings/keys (shown under "Your userID")
```

**Issue 3: Server package not installed**

```bash
# GitHub server
npm install -g @modelcontextprotocol/server-github

# Zotero server (Python)
pip3 install mcp-server-zotero

# n8n server
npm install -g @n8n/mcp-server
```

### Issue: MCP tools not showing

**Symptom:** `mcp__` prefixed tools missing in Claude

**Solution:**

1. Restart Claude Code completely
2. Check server is running:
```bash
# List running processes
ps aux | grep mcp
```

3. Check Claude Code logs:
```bash
# Logs usually in:
~/.claude/logs/
# Or run with debug:
DEBUG=* claude
```

---

## Performance Issues

### Issue: Claude responds slowly

**Symptom:** >10 second response time

**Possible causes:**

**1. Too much context loading**

```bash
# Check context size
find ~/.claude/.claude/context -name "*.md" -exec wc -c {} + | sort -n

# If files >100KB:
# - Use Progressive Disclosure (Tier 1/2/3)
# - Load only relevant context per intent
```

**2. Hooks take too long**

```bash
# Measure hook time
time bun run ~/.claude/.claude/hooks/load-ufc-context.ts

# If >2 seconds, optimize:
# - Cache read files
# - Use grep instead of reading entire files
# - Enable only necessary hooks
```

**3. Too many MCP servers**

```json
// Comment out unused servers in .mcp.json
{
  "mcpServers": {
    "github": { ... },  // ✅ Used often
    // "zotero": { ... },  // ❌ Comment out if not using right now
    // "playwright": { ... }
  }
}
```

### Issue: Token limit exceeded

**Symptom:** "Token limit exceeded" error

**Solution:**

```markdown
<!-- In PAI.md, shorten -->
## 🎯 Purpose
Ogmios PAI for development and research.

<!-- Instead of long description -->

<!-- In context files, use Tier system -->
## Tier 1 (<5KB)
Only essentials here.

---
## Tier 2 (10-50KB)
Detailed info (loaded when needed).
```

Update hooks to only load Tier 1:
```typescript
const tier1 = content.split('---')[0];
```

---

## Bilingual Issues

### Issue: Wrong language in response

**Symptom:** Claude responds in English when you wrote in Swedish

**Solution:**

Add to PAI.md:
```markdown
## 🇸🇪 Language Rules

**MANDATORY:**
1. **Detect input language** - ALWAYS match user's language
2. **Swedish input → Swedish response**
3. **English input → English response**
4. **Technical terms** - OK to mix (Swedish text + English code terms)

**Examples:**
User (Swedish): "Hur fungerar hook-systemet?"
→ Claude MUST respond in Swedish

User (English): "How does the hook system work?"
→ Claude MUST respond in English
```

### Issue: Voice speaks wrong language

**Symptom:** Swedish voice reads English text (or vice versa)

**Solution:**

In `hooks/stop-voice.ts`:
```typescript
const VOICE_MAP: Record<string, VoiceConfig> = {
  engineering: {
    id: '<BRITISH_VOICE_ID>',
    name: 'George Foster',
    accent: 'British',
    language: 'en'  // ← Add this
  },
  'swedish-academic-writing': {
    id: '<SWEDISH_VOICE_ID>',
    name: 'Prof. Lars Bergström',
    accent: 'Swedish',
    language: 'sv'  // ← Add this
  }
};

// Match language in COMPLETED tag with voice
function detectLanguage(text: string): string {
  // Swedish words?
  if (/å|ä|ö|ska|och|för|med/i.test(text)) return 'sv';
  return 'en';
}

const textLang = detectLanguage(completedText);
const voice = VOICE_MAP[agent];

// If mismatch, choose default voice for language
if (voice.language !== textLang) {
  const defaultVoice = textLang === 'sv' ? SWEDISH_DEFAULT : ENGLISH_DEFAULT;
  // Use default instead
}
```

---

## Verification Script

**Complete verification script - save as `verify-ogmios.sh`:**

```bash
#!/bin/bash

# Ogmios Installation Verification Script
# Version: 1.0
# Usage: bash verify-ogmios.sh

set -e

echo "🔍 Ogmios Installation Verification"
echo "===================================="
echo ""

ERRORS=0
WARNINGS=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

pass() {
    echo -e "${GREEN}✅ $1${NC}"
}

fail() {
    echo -e "${RED}❌ $1${NC}"
    ERRORS=$((ERRORS + 1))
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    WARNINGS=$((WARNINGS + 1))
}

# 1. Claude Code
echo "1️⃣  Claude Code"
if command -v claude &> /dev/null; then
    VERSION=$(claude --version 2>&1)
    pass "Claude Code installed: $VERSION"
else
    fail "Claude Code not found - install from https://docs.anthropic.com/claude/docs/claude-code"
fi
echo ""

# 2. Core Files
echo "2️⃣  Core Files"
if [ -f ~/.claude/.claude/PAI.md ]; then
    LINES=$(wc -l < ~/.claude/.claude/PAI.md)
    pass "PAI.md exists ($LINES lines)"
else
    fail "PAI.md missing"
fi

if [ -f ~/.claude/.claude/settings.json ]; then
    pass "settings.json exists"
    # Validate JSON
    if python3 -m json.tool ~/.claude/.claude/settings.json > /dev/null 2>&1; then
        pass "settings.json is valid JSON"
    else
        fail "settings.json is invalid JSON"
    fi
else
    fail "settings.json missing"
fi
echo ""

# 3. Directory Structure
echo "3️⃣  Directory Structure"
for dir in context context/projects context/memory context/languages skills hooks; do
    if [ -d ~/.claude/.claude/$dir ]; then
        pass "~/.claude/.claude/$dir/ exists"
    else
        fail "~/.claude/.claude/$dir/ missing"
    fi
done
echo ""

# 4. UFC Context
echo "4️⃣  UFC Context"
if [ -f ~/.claude/.claude/context/UFC.md ]; then
    SIZE=$(wc -c < ~/.claude/.claude/context/UFC.md)
    pass "UFC.md exists ($(($SIZE / 1024))KB)"
else
    fail "UFC.md missing"
fi

if [ -f ~/.claude/.claude/context/memory/decisions.md ]; then
    pass "decisions.md exists"
else
    warn "decisions.md missing (recommended)"
fi

if [ -f ~/.claude/.claude/context/memory/learnings.md ]; then
    pass "learnings.md exists"
else
    warn "learnings.md missing (recommended)"
fi
echo ""

# 5. Skills
echo "5️⃣  Skills System"
if [ -f ~/.claude/.claude/skills/SKILLS-INDEX.md ]; then
    SKILL_COUNT=$(grep -c "^### " ~/.claude/.claude/skills/SKILLS-INDEX.md 2>/dev/null || echo 0)
    pass "SKILLS-INDEX.md exists ($SKILL_COUNT skills defined)"
else
    fail "SKILLS-INDEX.md missing"
fi
echo ""

# 6. Hooks
echo "6️⃣  Hooks"
if [ -d ~/.claude/.claude/hooks ]; then
    HOOK_COUNT=$(ls -1 ~/.claude/.claude/hooks/*.ts 2>/dev/null | wc -l)
    pass "Hooks directory exists ($HOOK_COUNT .ts files)"

    # Check specific hooks
    for hook in session-start.ts load-ufc-context.ts skill-activation.ts stop-voice.ts; do
        if [ -f ~/.claude/.claude/hooks/$hook ]; then
            pass "$hook exists"
        else
            warn "$hook missing"
        fi
    done

    # Check dependencies
    if [ -f ~/.claude/.claude/hooks/package.json ]; then
        pass "package.json exists"
        if [ -d ~/.claude/.claude/hooks/node_modules ]; then
            pass "Dependencies installed"
        else
            warn "Dependencies not installed - run 'cd ~/.claude/.claude/hooks && bun install'"
        fi
    else
        warn "package.json missing"
    fi
else
    fail "Hooks directory missing"
fi
echo ""

# 7. Bun (for hooks)
echo "7️⃣  Runtime"
if command -v bun &> /dev/null; then
    BUN_VERSION=$(bun --version)
    pass "Bun installed: $BUN_VERSION"
else
    warn "Bun not installed - hooks won't work (install from https://bun.sh)"
fi
echo ""

# 8. Voice Server (optional)
echo "8️⃣  Voice System (Optional)"
if [ -d voice-server ]; then
    pass "voice-server directory exists"

    if curl -s http://localhost:8765/health &> /dev/null; then
        pass "Voice server is running"
    else
        warn "Voice server not running (optional - start with 'cd voice-server && ./start.sh')"
    fi
else
    warn "voice-server not installed (optional)"
fi
echo ""

# 9. MCP Configuration
echo "9️⃣  MCP Servers (Optional)"
if [ -f ~/.claude/.mcp.json ]; then
    pass ".mcp.json exists"

    # Validate JSON
    if python3 -m json.tool ~/.claude/.mcp.json > /dev/null 2>&1; then
        pass ".mcp.json is valid JSON"

        # Count configured servers
        SERVER_COUNT=$(cat ~/.claude/.mcp.json | python3 -c "import sys, json; print(len(json.load(sys.stdin).get('mcpServers', {})))" 2>/dev/null || echo 0)
        if [ $SERVER_COUNT -gt 0 ]; then
            pass "$SERVER_COUNT MCP servers configured"
        else
            warn "No MCP servers configured"
        fi
    else
        fail ".mcp.json is invalid JSON"
    fi
else
    warn ".mcp.json missing (optional)"
fi
echo ""

# Summary
echo "===================================="
echo "📊 Summary"
echo "===================================="
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}🎉 Perfect! Ogmios is fully installed and configured.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Edit ~/.claude/.claude/PAI.md with your personal details"
    echo "2. Run 'claude' to start using Ogmios"
    echo "3. (Optional) Start voice server: cd voice-server && ./start.sh"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Installation complete with $WARNINGS warnings.${NC}"
    echo ""
    echo "Your Ogmios installation is functional but some optional components are missing."
    echo "Review warnings above and install missing components if needed."
elif [ $ERRORS -lt 3 ]; then
    echo -e "${YELLOW}⚠️  Installation incomplete: $ERRORS errors, $WARNINGS warnings.${NC}"
    echo ""
    echo "Fix the errors above and run this script again."
else
    echo -e "${RED}❌ Installation failed: $ERRORS errors, $WARNINGS warnings.${NC}"
    echo ""
    echo "Please review the errors above and follow the installation guide:"
    echo "https://github.com/<username>/ogmios-pai/blob/main/docs/01-getting-started/installation.md"
fi

echo ""
exit $ERRORS
```

**Usage:**

```bash
# Make script executable
chmod +x verify-ogmios.sh

# Run verification
./verify-ogmios.sh

# Results:
# ✅ = OK
# ⚠️  = Warning (optional missing)
# ❌ = Error (critical missing)
```

---

## Getting Help

### GitHub Issues

If you encounter problems:

1. **Run diagnosis first:**
```bash
bash ~/.claude/.claude/diagnose.sh > diagnosis.txt
```

2. **Open issue on GitHub:**
   - Go to: https://github.com/<username>/ogmios-pai/issues
   - Click "New Issue"
   - Choose template: "Bug Report"
   - Include `diagnosis.txt` output

### Community Discord/Discussions

- **GitHub Discussions:** https://github.com/<username>/ogmios-pai/discussions


### Documentation

- [Installation](08-INSTALLATION.md) - Complete installation guide
- [FAQ](10-FAQ.md) - Frequently asked questions
- [Architecture](02-ARCHITECTURE.md) - System architecture

---

**Last updated:** 2025-11-09
**Feedback:** Open issue on GitHub if you find errors or have suggestions
