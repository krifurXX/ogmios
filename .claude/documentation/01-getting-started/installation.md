# Installation Guide - Ogmios PAI

[🇬🇧 English](08-INSTALLATION.md) | [🇸🇪 Svenska](../docs/06-bilingual/svenska/installation.md)

---

## 📋 Table of Contents

1. [Before You Begin](#-before-you-begin)
2. [Prerequisites](#-prerequisites)
3. [Quick Installation](#-quick-installation)
4. [Detailed Installation](#-detailed-installation)
5. [Configuration](#%EF%B8%8F-configuration)
6. [Verification](#-verification)
7. [Troubleshooting](#-troubleshooting)
8. [Advanced Configuration](#-advanced-configuration)
9. [Upgrading](#-upgrading)
10. [Next Steps](#-next-steps)

---

## 🎯 Before You Begin

### What You're Installing

Ogmios PAI is a **Personal AI Infrastructure** that adds powerful capabilities to Claude Code:

- **UFC System** - Unified Function Context for intelligent context management
- **Skills System** - Specialized AI personas for different tasks
- **Hooks System** - Automation and workflow enhancements
- **Multilingual Support** - Seamless Swedish/English operation
- **Voice System** - Voice feedback with ElevenLabs (optional)
- **MCP Integration** - Connections to external services (optional)

### Installation Time

- **Basic installation:** 10-15 minutes
- **With voice feedback:** +5 minutes
- **With MCP servers:** +10 minutes per service

### Prerequisites Knowledge

- Basic terminal/command line usage
- Basic text file editing
- (Optional) Git for cloning repository

**Beginner-Friendly:** This guide assumes **no** prior knowledge of Claude Code. Everything is explained step-by-step.

---

## ✅ Prerequisites

### 1. Verify Claude Code

**Check if Claude Code is installed:**

```bash
claude --version
```

**Expected output:**
```
Claude Code version X.X.X
```

**If command not found:**

Claude Code is **NOT** installed. You must install it first:

1. Go to [https://claude.ai/download](https://claude.ai/download)
2. Download for your operating system (macOS/Linux/Windows)
3. Follow installation instructions
4. Restart your terminal
5. Run `claude --version` again

**Official documentation:** [Claude Code Documentation](https://docs.claude.ai/code)

### 2. System Requirements

**Operating System:**
- macOS 11+ (recommended)
- Linux (Ubuntu 20.04+, Debian 11+)
- Windows 10+ with WSL2 (limited testing)

**Runtime:**
- **Node.js** 18+ OR **Bun** (recommended)

**Check Node.js:**
```bash
node --version
```

Should show: `v18.0.0` or higher

**If Node.js is missing:**
```bash
# macOS with Homebrew:
brew install node

# Ubuntu/Debian:
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**Install Bun (recommended):**
```bash
curl -fsSL https://bun.sh/install | bash

# Verify:
bun --version
```

### 3. Git (for cloning repository)

**Check Git:**
```bash
git --version
```

**If Git is missing:**
```bash
# macOS:
brew install git

# Ubuntu/Debian:
sudo apt-get install git
```

### 4. Optional Prerequisites

**For voice feedback (ElevenLabs):**
- ElevenLabs account ([https://elevenlabs.io](https://elevenlabs.io))
- API key (free tier available)

**For Obsidian integration:**
- Obsidian ([https://obsidian.md](https://obsidian.md))

**For MCP servers:**
- Specific API keys for each service (GitHub, Slack, etc.)

---

## 🚀 Quick Installation

**Perfect for:** Fast setup, basic features, no voices/MCP

**Time required:** ~5 minutes

### Step 1: Download Ogmios

**Option A: With Git (recommended)**
```bash
# Clone repository to a suitable location
cd ~/Downloads  # or your preferred location
git clone https://github.com/your-username/ogmios-pai.git
cd ogmios-pai
```

**Option B: Download ZIP**
1. Go to GitHub repository
2. Click "Code" → "Download ZIP"
3. Extract ZIP file
4. Open terminal in the folder

### Step 2: Copy to Claude Directory

```bash
# Create PAI directory if it doesn't exist
mkdir -p ~/.claude/.claude

# Backup existing configuration (if you have one)
if [ -f ~/.claude/settings.json ]; then
  cp ~/.claude/settings.json ~/.claude/settings.json.backup
  echo "✅ Backed up settings.json"
fi

# Copy Ogmios templates
cp -r templates/context ~/.claude/.claude/
cp -r templates/skills ~/.claude/.claude/
cp -r templates/hooks ~/.claude/.claude/
cp templates/PAI.md ~/.claude/.claude/
cp templates/SKILLS-INDEX.md ~/.claude/.claude/
cp templates/settings.json ~/.claude/settings.json

echo "✅ Ogmios files copied"
```

**What was copied:**
- `context/` - UFC context files
- `skills/` - Specialized AI personas
- `hooks/` - Automation scripts
- `PAI.md` - Your core identity
- `SKILLS-INDEX.md` - Skills catalog
- `settings.json` - Claude Code configuration

### Step 3: Customize PAI.md

```bash
# Open in your favorite editor
nano ~/.claude/.claude/PAI.md
# or: vim, code, subl, etc.
```

**Minimum required changes:**

Find and change:
```markdown
## Core Identity
Your Name: <YOUR_NAME>  # ← CHANGE THIS
Your Timezone: Europe/Stockholm  # ← CHANGE THIS
```

**Recommended changes:**

```markdown
## Essential Contacts
- Partner: name@email.com  # ← ADD YOUR CONTACTS
- Team Lead: name@email.com

## Core Stack Preferences
- Primary Language: TypeScript  # ← YOUR PREFERENCES
- Package managers: bun
```

**Save and close** (Ctrl+X in nano, :wq in vim)

### Step 4: Install Hook Dependencies

```bash
cd ~/.claude/.claude/hooks

# With Bun (recommended):
bun install

# OR with npm:
npm install
```

**Expected output:**
```
bun install v1.x.x
Installing dependencies...
✓ Installed 5 packages
```

### Step 5: First Test

```bash
# Start Claude Code
claude
```

**In Claude prompt, test:**

```
What's my name according to PAI.md?
```

**Expected response:**
```
According to your PAI configuration, your name is [YOUR NAME].
```

**Congratulations!** Basic installation complete! ✅

---

## 🔧 Detailed Installation

**Perfect for:** Complete control, understanding each step, troubleshooting

### Step 1: Prepare Claude Directory

**Understand the directory structure:**

Claude Code uses:
- `~/.claude/settings.json` - Global configuration
- `~/.claude/.claude/` - Ogmios PAI system (our convention)

**Create the structure:**

```bash
# Go to home directory
cd ~

# Create Claude directory
mkdir -p .claude

# Create PAI subdirectory
mkdir -p .claude/.claude

# Verify:
ls -la .claude/
```

**Expected output:**
```
drwxr-xr-x  .claude/
```

### Step 2: Download Ogmios (detailed)

**With Git (recommended):**

```bash
# Decide where you want to clone (temporary location)
cd ~/Downloads

# Clone repository
git clone https://github.com/your-username/ogmios-pai.git

# Enter the directory
cd ogmios-pai

# Verify contents
ls -la
```

**You should see:**
```
templates/
  ├── context/
  ├── skills/
  ├── hooks/
  ├── PAI.md
  ├── SKILLS-INDEX.md
  └── settings.json
examples/
sv/
en/
README.md
```

**Without Git (manual download):**

1. Visit GitHub repository in browser
2. Click green "Code" button
3. Select "Download ZIP"
4. Save to `~/Downloads/`
5. Extract:
   ```bash
   cd ~/Downloads
   unzip ogmios-pai-main.zip
   cd ogmios-pai-main
   ```

### Step 3: Backup Existing Configuration

**IMPORTANT:** If you already use Claude Code, backup first!

```bash
# Check if you have existing settings.json
if [ -f ~/.claude/settings.json ]; then
  echo "⚠️  Existing settings.json found!"

  # Backup with timestamp
  cp ~/.claude/settings.json ~/.claude/settings.json.backup-$(date +%Y%m%d-%H%M%S)

  echo "✅ Backup created at ~/.claude/settings.json.backup-[timestamp]"
else
  echo "✅ No existing configuration - ready for fresh install"
fi

# Backup existing .claude/ directory if it exists
if [ -d ~/.claude/.claude ]; then
  echo "⚠️  Existing PAI installation found!"
  mv ~/.claude/.claude ~/.claude/.claude.backup-$(date +%Y%m%d-%H%M%S)
  echo "✅ Backup created"
fi
```

### Step 4: Copy Files (detailed)

**Understand what's being copied:**

```bash
# From ogmios-pai folder:
cd ~/Downloads/ogmios-pai  # or your download location

# Copy context system
cp -r templates/context ~/.claude/.claude/
# This gives you: UFC.md, tools/, projects/, preferences/, memory/, languages/

# Copy skills system
cp -r templates/skills ~/.claude/.claude/
# This gives you: CORE/, engineering/, architecture/, research/, etc.

# Copy hooks system
cp -r templates/hooks ~/.claude/.claude/
# This gives you: load-ufc-context.ts, skill-activation-enforcer.ts, etc.

# Copy core files
cp templates/PAI.md ~/.claude/.claude/
cp templates/SKILLS-INDEX.md ~/.claude/.claude/

# Copy settings.json
cp templates/settings.json ~/.claude/settings.json
```

**Verify copy:**

```bash
# Check everything is there
ls -la ~/.claude/.claude/

# You should see:
# PAI.md
# SKILLS-INDEX.md
# context/
# skills/
# hooks/

# Check settings.json
ls -la ~/.claude/settings.json
```

### Step 5: Install Dependencies (detailed)

**Understand hook dependencies:**

Hooks are TypeScript files that run automation. They need dependencies like:
- `zx` - For shell commands in TypeScript
- `yaml` - For reading skill metadata
- (others according to package.json)

**Installation:**

```bash
# Go to hooks directory
cd ~/.claude/.claude/hooks

# Verify package.json exists
ls -la package.json

# Install with Bun (recommended):
bun install

# OR with npm:
npm install

# OR with yarn:
yarn install
```

**Expected output (Bun):**
```
bun install v1.x.x (Linux x64)
Resolving dependencies...
  + zx
  + yaml
  + [other packages]

✓ Installed 5 packages [1.2s]
```

**Verify installation:**
```bash
ls -la node_modules/
# You should see: zx/, yaml/, etc.
```

### Step 6: Configure Permissions (macOS/Linux)

```bash
# Make hooks executable
chmod +x ~/.claude/.claude/hooks/*.ts

# Verify:
ls -la ~/.claude/.claude/hooks/
```

**Expected output:**
```
-rwxr-xr-x  load-ufc-context.ts
-rwxr-xr-x  skill-activation-enforcer.ts
-rwxr-xr-x  completion-validator.ts
```

Note the `x` in permissions (executable).

---

## ⚙️ Configuration

### 1. Customize PAI.md (Basic Identity)

**Open the file:**
```bash
nano ~/.claude/.claude/PAI.md
# or your favorite editor: vim, code, subl
```

**Required changes:**

```markdown
## Core Identity
Your Name: [YOUR FULL NAME]
Your Timezone: [YOUR TIMEZONE, e.g., America/New_York]
Your Location: [CITY, COUNTRY]

## Essential Contacts
- [Contact Name 1]: email@example.com
- [Contact Name 2]: email@example.com
```

**Recommended customizations:**

```markdown
## Core Stack Preferences

### Package Managers
- JavaScript/TypeScript: bun (NOT npm, yarn, pnpm)  # CHANGE TO YOUR PREFERENCE
- Python: uv (NOT pip)  # CHANGE TO YOUR PREFERENCE

### Primary Languages
1. TypeScript  # CHANGE ORDER TO YOUR PREFERENCE
2. Python
3. Go

### Frameworks
- Backend: [YOUR CHOICES]
- Frontend: [YOUR CHOICES]
- Database: [YOUR CHOICES]

## Work Environment
- OS: macOS  # OR Linux/Windows
- Shell: zsh  # OR bash/fish
- Editor: NeoVim  # OR VSCode/etc.
```

**Save changes** (Ctrl+X → Y → Enter in nano)

### 2. Configure UFC Context Files

**a) Tech Stack Preferences**

```bash
nano ~/.claude/.claude/context/preferences/stack.md
```

**Customize to your actual preferences:**

```markdown
# Technology Stack Preferences

## Primary Language
TypeScript (preferred over Python for new projects)

## Package Managers
- JavaScript/TypeScript: **bun** (NOT npm, yarn, pnpm)
- Python: **uv** (NOT pip, pipenv, poetry)

## Why Bun?
- Faster than npm/yarn
- Built-in TypeScript support
- Drop-in replacement

## Frameworks & Tools
- Backend: Express.js, Fastify
- Frontend: React, Next.js
- Database: PostgreSQL, Redis
- Cloud: AWS (preferred), GCP
```

**Save changes**

**b) Create Project Context**

```bash
# Create context for your main project
nano ~/.claude/.claude/context/projects/my-project.md
```

**Template:**

```markdown
# [Project Name]

## Overview
[Brief description of the project]

## Location
`/path/to/project/`

## Tech Stack
- Language: TypeScript
- Framework: Next.js
- Database: PostgreSQL
- Hosting: Vercel

## Key Files
- Main: `src/index.ts`
- Config: `next.config.js`
- Database: `prisma/schema.prisma`

## Development
```bash
# Install dependencies
bun install

# Run dev server
bun run dev

# Run tests
bun test
```

## Notes
- Use TypeScript strict mode
- Follow Airbnb style guide
- Write tests for all new features
```

**Save changes**

**c) Language Preferences (Multilingual)**

```bash
nano ~/.claude/.claude/context/languages/bilingual.md
```

**If you're bilingual (Swedish/English):**

The file should already contain good settings. Verify:

```markdown
# Bilingual Operation: Swedish & English

## Language Detection
- Match input language in responses
- Swedish for natural communication
- English for technical documentation
- Mixed terminology is natural and encouraged

## Response Language
**Rule:** Match the user's input language
```

**If you only use English:**

Change to:

```markdown
# Language Preference: English Only

## Response Language
Always respond in English.
```

### 3. Configure Hooks in settings.json

**Open settings.json:**
```bash
nano ~/.claude/settings.json
```

**Verify hooks are configured:**

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bun ${HOME}/.claude/.claude/hooks/session-start.ts"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bun ${HOME}/.claude/.claude/hooks/load-ufc-context.ts"
          },
          {
            "type": "command",
            "command": "bun ${HOME}/.claude/.claude/hooks/skill-activation-enforcer.ts"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bun ${HOME}/.claude/.claude/hooks/completion-validator.ts"
          }
        ]
      }
    ]
  }
}
```

**Important details:**
- `${HOME}` expands to your home directory
- `bun` can be replaced with `node` if you don't use Bun
- Hooks run in order (important for UserPromptSubmit)

**Validate JSON syntax:**
```bash
cat ~/.claude/settings.json | jq .
```

If the command gives error: JSON syntax error. Fix before continuing.

### 4. Create Custom Skills (Optional)

**Example: Create "database-expert" skill:**

```bash
# Create skill directory
mkdir -p ~/.claude/.claude/skills/database-expert

# Create SKILL.md
nano ~/.claude/.claude/skills/database-expert/SKILL.md
```

**Content:**

```yaml
---
name: database-expert
description: Database design, optimization, and query expert
triggers:
  - database design
  - sql query
  - schema optimization
  - query performance
  - database migration
voice_id: your-voice-id-here
voice_name: Database Expert Voice
voice_accent: American
voice_gender: male
---

# Database Expert Skill

## When to Use
This skill activates when the user needs help with:
- Database schema design
- SQL query optimization
- Performance tuning
- Migration strategies
- Data modeling

## Workflow
1. Understand the database requirements
2. Analyze current schema (if exists)
3. Propose optimizations or design
4. Provide SQL examples
5. Explain trade-offs

## Response Format
Always include:
- 📊 Schema diagrams (as text/markdown)
- 🔍 Query explanations
- ⚡ Performance tips
- ✅ Best practices

## Voice
Speak as an experienced database architect with deep PostgreSQL/MySQL expertise.
```

**Register in SKILLS-INDEX.md:**

```bash
nano ~/.claude/.claude/SKILLS-INDEX.md
```

**Add:**

```markdown
## Tier 1: Core Skills
[existing skills...]

### Database Expert (`database-expert/`)
- **Purpose:** Database design, optimization, SQL expertise
- **Triggers:** "database design", "sql query", "schema optimization"
- **Voice:** Database Expert (American, Male)
- **Use when:** Working with databases, schema, queries
```

---

## ✅ Verification

### Checklist

Use this checklist to verify everything is correctly installed:

```bash
# Run this script to verify installation:

echo "🔍 Ogmios PAI Installation Verification"
echo "========================================"
echo

# 1. Check Claude Code
echo "1. Claude Code:"
if command -v claude &> /dev/null; then
  echo "  ✅ Installed: $(claude --version)"
else
  echo "  ❌ NOT FOUND - Install from https://claude.ai/download"
fi

# 2. Check Node.js or Bun
echo "2. Runtime:"
if command -v bun &> /dev/null; then
  echo "  ✅ Bun installed: $(bun --version)"
elif command -v node &> /dev/null; then
  echo "  ✅ Node.js installed: $(node --version)"
else
  echo "  ❌ Neither Bun nor Node.js found"
fi

# 3. Check PAI directory
echo "3. PAI Directory:"
if [ -d ~/.claude/.claude ]; then
  echo "  ✅ ~/.claude/.claude exists"
else
  echo "  ❌ PAI directory missing"
fi

# 4. Check core files
echo "4. Core Files:"
[ -f ~/.claude/.claude/PAI.md ] && echo "  ✅ PAI.md" || echo "  ❌ PAI.md missing"
[ -f ~/.claude/.claude/SKILLS-INDEX.md ] && echo "  ✅ SKILLS-INDEX.md" || echo "  ❌ SKILLS-INDEX.md missing"
[ -f ~/.claude/settings.json ] && echo "  ✅ settings.json" || echo "  ❌ settings.json missing"

# 5. Check directories
echo "5. Directories:"
[ -d ~/.claude/.claude/context ] && echo "  ✅ context/" || echo "  ❌ context/ missing"
[ -d ~/.claude/.claude/skills ] && echo "  ✅ skills/" || echo "  ❌ skills/ missing"
[ -d ~/.claude/.claude/hooks ] && echo "  ✅ hooks/" || echo "  ❌ hooks/ missing"

# 6. Check hook dependencies
echo "6. Hook Dependencies:"
if [ -d ~/.claude/.claude/hooks/node_modules ]; then
  echo "  ✅ node_modules exists"
else
  echo "  ❌ Dependencies not installed - run 'bun install' in hooks/"
fi

# 7. Count skills
echo "7. Skills:"
skill_count=$(find ~/.claude/.claude/skills -name "SKILL.md" | wc -l)
echo "  ✅ $skill_count skills found"

echo
echo "========================================"
echo "Verification complete!"
```

**Save as:** `~/.claude/.claude/verify-installation.sh`

**Run:**
```bash
chmod +x ~/.claude/.claude/verify-installation.sh
~/.claude/.claude/verify-installation.sh
```

### Manual Tests

**Test 1: Context Loading (UFC)**

```bash
# Start Claude Code
claude
```

In Claude prompt:
```
What are my technology stack preferences?
```

**Expected response:**
```
Based on your PAI configuration in context/preferences/stack.md:

- Primary Language: TypeScript
- Package Manager: bun (NOT npm/yarn/pnpm)
- Python: uv (NOT pip)
[...]
```

**If error:**
- Check that `context/preferences/stack.md` exists
- Check that `load-ufc-context.ts` hook is enabled
- See troubleshooting section

**Test 2: Skill Activation**

In Claude prompt:
```
Implement a function to check if a number is prime
```

**Expected response:**
```
✅ Skill activated: engineering (George Foster - American English)

[implementation follows...]
```

**If error:**
- Check that `skills/engineering/` exists
- Check that `skill-activation-enforcer.ts` hook is enabled
- See troubleshooting section

**Test 3: Multilingual (if configured)**

In Claude prompt (in Swedish):
```
Skapa en funktion för att sortera en lista
```

**Expected response (in Swedish):**
```
✅ Skill aktiverad: engineering (George Foster - Amerikansk engelska)

Här är en funktion för att sortera en lista:
[...]
```

**Test 4: Completion Validator**

Every response should end with:
```
🎯 COMPLETED: [task description]
```

If missing: `completion-validator.ts` hook is not working correctly.

---

## 🐛 Troubleshooting

### Problem: "Command not found: claude"

**Diagnosis:**
Claude Code is not installed or not in PATH.

**Solution:**

1. **Install Claude Code:**
   ```bash
   # Visit: https://claude.ai/download
   # Follow installation instructions for your OS
   ```

2. **Add to PATH (if installed but not found):**
   ```bash
   # Find Claude Code installation
   which claude

   # If in /usr/local/bin or ~/bin, add to PATH:
   echo 'export PATH="$PATH:/path/to/claude"' >> ~/.bashrc  # or ~/.zshrc
   source ~/.bashrc
   ```

3. **Restart terminal**

### Problem: Hooks Don't Run

**Diagnosis:**
No skill activation, no context loading, no completion messages.

**Solution:**

**Step 1: Verify hooks are executable**
```bash
ls -la ~/.claude/.claude/hooks/

# Look for 'x' in permissions:
# -rwxr-xr-x (CORRECT)
# -rw-r--r-- (WRONG - not executable)
```

**Fix permissions:**
```bash
chmod +x ~/.claude/.claude/hooks/*.ts
```

**Step 2: Validate settings.json**
```bash
cat ~/.claude/settings.json | jq .
```

If error: syntax problem in JSON. Open and fix:
```bash
nano ~/.claude/settings.json
```

**Step 3: Test hook manually**
```bash
cd ~/.claude/.claude/hooks
bun load-ufc-context.ts
```

If errors shown: fix according to error message.

**Step 4: Check hook configuration**
```bash
nano ~/.claude/settings.json
```

Verify hooks section exists and is correct:
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bun ${HOME}/.claude/.claude/hooks/load-ufc-context.ts"
          }
        ]
      }
    ]
  }
}
```

### Problem: Context Doesn't Load

**Diagnosis:**
Claude doesn't know your preferences from `context/`.

**Solution:**

**Step 1: Verify context files exist**
```bash
ls -la ~/.claude/.claude/context/

# You should see:
# UFC.md
# preferences/
# projects/
# tools/
# memory/
# languages/
```

**Step 2: Check UFC.md**
```bash
cat ~/.claude/.claude/context/UFC.md | head -20
```

Should contain UFC system documentation.

**Step 3: Test load-ufc-context hook directly**
```bash
cd ~/.claude/.claude/hooks
bun load-ufc-context.ts --test
```

**Step 4: Debug hook output**
```bash
# Add debug output to hook
nano ~/.claude/.claude/hooks/load-ufc-context.ts

// Add at beginning of file:
console.log("🔍 DEBUG: Hook started");
```

Run again and see if output appears.

### Problem: Skills Don't Activate

**Diagnosis:**
No "✅ Skill activated" message when you ask for help.

**Solution:**

**Step 1: Verify skills directory**
```bash
ls -la ~/.claude/.claude/skills/

# You should see:
# CORE/
# engineering/
# architecture/
# research/
# [etc.]
```

**Step 2: Check SKILLS-INDEX.md**
```bash
cat ~/.claude/.claude/SKILLS-INDEX.md
```

Should list all skills with triggers.

**Step 3: Verify trigger words**
```bash
cat ~/.claude/.claude/skills/engineering/SKILL.md | grep -A10 "triggers:"
```

**Step 4: Test skill activator manually**
```bash
cd ~/.claude/.claude/hooks
bun skill-activation-enforcer.ts
```

**Step 5: Check YAML front-matter**

Open a skill file:
```bash
nano ~/.claude/.claude/skills/engineering/SKILL.md
```

Verify YAML:
```yaml
---
name: engineering
description: Software engineering expert
triggers:
  - implement
  - build
  - code
  - function
---
```

**Common error:** Missing `---` before or after YAML.

### Problem: Voice Doesn't Work

**Diagnosis:**
No voice feedback after responses.

**Solution:**

**Step 1: Check API key**
```bash
# In settings.json:
cat ~/.claude/settings.json | grep ELEVENLABS_API_KEY
```

Should show:
```json
"ELEVENLABS_API_KEY": "sk_..."
```

**Step 2: Test API key**
```bash
curl -H "xi-api-key: YOUR_API_KEY" https://api.elevenlabs.io/v1/voices
```

Should return list of voices.

**If "Unauthorized":** API key is invalid or expired.

**Step 3: Verify voice-server (if you run one)**
```bash
# Check if voice-server is running
ps aux | grep voice-server

# Restart voice-server
cd ~/.claude/voice-server
bun run server.ts
```

**Step 4: Check voice IDs in skills**
```bash
cat ~/.claude/.claude/skills/engineering/SKILL.md | grep voice_id
```

Should show:
```yaml
voice_id: abc123xyz
```

Verify that voice ID exists in ElevenLabs.

### Problem: Mixed Language Recognition

**Diagnosis:**
Claude responds in wrong language (English when you write Swedish).

**Solution:**

**Step 1: Check bilingual.md**
```bash
cat ~/.claude/.claude/context/languages/bilingual.md
```

Should contain:
```markdown
## Response Language
**Rule:** Match the user's input language
```

**Step 2: Test explicit language selection**

In Claude:
```
[SV] Skriv en funktion för primtal
```

Prefix `[SV]` forces Swedish.

**Step 3: Check PAI.md language preference**
```bash
cat ~/.claude/.claude/PAI.md | grep -A5 "Language"
```

### Problem: High Memory Usage

**Diagnosis:**
Claude Code uses a lot of RAM.

**Solution:**

**Step 1: Limit context file size**

Large context files are loaded entirely. Keep files under 50KB each.

**Step 2: Use selective context loading**

In `load-ufc-context.ts`, add filtering:
```typescript
// Load only relevant files based on prompt
if (prompt.includes("database")) {
  loadContext("tools/database.md");
}
```

**Step 3: Restart Claude Code regularly**
```bash
# Exit session
exit

# Start again
claude
```

---

## 🎯 Advanced Configuration

### MCP Servers (Model Context Protocol)

**MCP allows Claude Code to connect to external services.**

#### GitHub MCP Server

**Installation:**
```bash
claude mcp add --scope user github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=your_github_token \
  -- bunx -y @modelcontextprotocol/server-github
```

**Verification:**
```bash
claude mcp list
```

**Usage:**

In Claude:
```
Show me my latest GitHub issues
```

#### Slack MCP Server

```bash
claude mcp add --scope user slack \
  -e SLACK_BOT_TOKEN=xoxb-your-token \
  -- bunx -y @modelcontextprotocol/server-slack
```

#### Google Drive MCP Server

```bash
claude mcp add --scope user gdrive \
  -e GOOGLE_OAUTH_CLIENT_ID=your_client_id \
  -e GOOGLE_OAUTH_CLIENT_SECRET=your_secret \
  -- bunx -y @modelcontextprotocol/server-gdrive
```

**See:** [MCP Integration Guide](07-MCP-INTEGRATION.md) for full documentation.

### Voice Server (ElevenLabs)

**For advanced voice handling with local server:**

**Step 1: Install voice-server**
```bash
# Clone voice-server (if separate repo)
git clone https://github.com/your-username/ogmios-voice-server.git ~/.claude/voice-server

# Or copy from templates/
cp -r templates/voice-server ~/.claude/
```

**Step 2: Configure**
```bash
cd ~/.claude/voice-server
cp .env.example .env
nano .env
```

**Content:**
```bash
ELEVENLABS_API_KEY=sk_...
PORT=8888
```

**Step 3: Install dependencies**
```bash
bun install
```

**Step 4: Start server**
```bash
bun run server.ts

# OR as background process:
bun run server.ts &
```

**Step 5: Test**
```bash
curl http://localhost:8888/health
```

**Expected:**
```json
{"status":"ok","voice_api":"connected"}
```

### Custom Hooks

**Create a custom hook:**

```bash
nano ~/.claude/.claude/hooks/my-custom-hook.ts
```

**Example: Log all prompts**

```typescript
#!/usr/bin/env bun

import { appendFileSync } from "fs";
import { join } from "path";

export default async function({ userMessage, context }) {
  const logFile = join(process.env.HOME, ".claude", "prompt-log.txt");
  const timestamp = new Date().toISOString();

  appendFileSync(logFile, `[${timestamp}] ${userMessage}\n`);

  // Return nothing (no modification)
  return {};
}
```

**Register in settings.json:**
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bun ${HOME}/.claude/.claude/hooks/my-custom-hook.ts"
          }
        ]
      }
    ]
  }
}
```

**More advanced:** See [Hooks & Automation](06-HOOKS-AUTOMATION.md)

---

## 🔄 Upgrading

### Upgrade Ogmios to New Version

**Step 1: Backup your configuration**
```bash
# Backup entire PAI directory
cp -r ~/.claude/.claude ~/.claude/.claude.backup-$(date +%Y%m%d)

# Backup settings.json
cp ~/.claude/settings.json ~/.claude/settings.json.backup-$(date +%Y%m%d)
```

**Step 2: Download new version**
```bash
cd ~/Downloads/ogmios-pai
git pull origin main

# Or download new ZIP and extract
```

**Step 3: Selective update (recommended)**

**Update only system files, not your customizations:**

```bash
# Update hooks (usually safe)
cp -r templates/hooks ~/.claude/.claude/

# Update skills (be careful if you've modified)
# Check diff first:
diff -r ~/.claude/.claude/skills/engineering templates/skills/engineering

# If no conflicts:
cp -r templates/skills ~/.claude/.claude/

# DON'T UPDATE: context/ (your customizations), PAI.md (your identity)
```

**Step 4: Merge settings.json**

**Manual merge (recommended):**
```bash
# Open both side-by-side
diff ~/.claude/settings.json templates/settings.json

# Copy new features from templates/settings.json to ~/.claude/settings.json
nano ~/.claude/settings.json
```

**Step 5: Reinstall hook dependencies (if package.json was updated)**
```bash
cd ~/.claude/.claude/hooks
bun install
```

**Step 6: Test**
```bash
claude
# Run verification tests from earlier section
```

### Upgrade Claude Code

```bash
# Check current version
claude --version

# Download latest from https://claude.ai/download
# Install according to instructions

# Restart terminal
# Verify new version
claude --version
```

---

## 📚 Next Steps

### Learn More About the System

- **[UFC System](03-UFC-SYSTEMET.md)** - How context management works
- **[Skills System](04-SKILLS-SYSTEMET.md)** - Specialized AI personas
- **[Hooks & Automation](06-HOOKS-AUTOMATION.md)** - Automation and custom workflows

### Explore Examples

- **[Examples directory](../examples/)** - Ready-to-use cases
- **[Tutorials](../tutorials/)** - Step-by-step guides

### Contribute to the Project

- **[GitHub Repository](https://github.com/your-username/ogmios-pai)**
- **[Issues & Feature Requests](https://github.com/your-username/ogmios-pai/issues)**
- **[Contributing Guide](../CONTRIBUTING.md)**

### Community

- **Discord:** [Link to community]
- **Forum:** [Link to discussion forum]

---

## 🙏 Support

**Found bugs or have questions?**

1. **Check the troubleshooting section** above
2. **Search [GitHub Issues](https://github.com/your-username/ogmios-pai/issues)**
3. **Create new issue** with detailed description
4. **Join the community** for help

**When reporting problems, include:**
- Your OS and version (macOS 14.2, Ubuntu 22.04, etc.)
- Claude Code version (`claude --version`)
- Error messages (complete)
- Steps to reproduce the issue
- Output from verification script

---

**Back to:** [README](01-README.md) | **Documentation:** [English](../en/) | [Svenska](../sv/)

**Last updated:** 2025-11-09
