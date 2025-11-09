# Ogmios PAI - Template Files

**Language:** 🇬🇧 English | [🇸🇪 Svenska](README-sv.md)

This directory contains ready-to-use template files for setting up your Ogmios Personal AI Infrastructure.

---

## 📋 Quick Start

**Installation:**

```bash
# Clone the repository
git clone https://github.com/<username>/ogmios-pai.git
cd ogmios-pai

# Copy templates to your Claude directory
cp -r templates/* ~/.claude/.claude/

# Customize your PAI
nano ~/.claude/.claude/PAI.md  # or use your preferred editor
```

**What gets copied:**

```
~/.claude/.claude/
├── PAI.md                    # Your AI's core identity
├── SKILLS-INDEX.md           # Skills registry (root)
├── settings.json             # Hooks and configuration
├── .gitignore                # Security (prevents secrets in git)
│
├── context/                  # UFC Context System
│   ├── UFC.md                # Context system overview
│   ├── languages/
│   │   └── bilingual.md      # Language preferences template
│   ├── projects/
│   │   └── _example-project-tier1.md  # Example project template
│   ├── tools/
│   │   └── README.md         # Tool preferences guide
│   ├── technical/
│   │   └── README.md         # Technical stack preferences guide
│   └── memory/
│       ├── decisions.md      # Architectural Decision Records
│       └── learnings.md      # Lessons learned
│
├── skills/                   # Specialized AI Assistants
│   ├── SKILLS-INDEX.md       # Skills registry
│   ├── engineering/
│   │   └── SKILL.md          # George Foster (Engineering)
│   └── research/
│       └── SKILL.md          # Dr. Alice Mitchell (Research)
│
└── hooks/                    # Event-Driven Automation
    ├── package.json          # Dependencies
    ├── tsconfig.json         # TypeScript config
    ├── README.md             # Hooks documentation
    ├── session-start.ts      # Session initialization
    ├── load-ufc-context.ts   # Auto UFC context loading
    ├── skill-activation.ts   # Auto-activate specialists
    ├── stop-voice.ts         # Voice feedback (optional)
    └── log-tool-use.ts       # Tool logging (optional)
```

---

## 📂 Template Files

### Core Identity

#### `PAI.md`
**Purpose:** Your AI's core identity - defines who you are and how Claude should behave

**What it contains:**
- 🚨 Compliance enforcement protocol (mandatory context loading)
- 🚨 Skills-first activation rules
- 🎯 Your purpose and goals
- 👤 Your background and work style
- 🎨 Personality and tone preferences
- 🛠️ Enabled systems (UFC, Skills, Voice, MCP)
- 🗂️ Directory structure overview

**Customize:**
- Replace `<YOUR_NAME>` with your name
- Fill in your profession, education, interests
- Set your tech stack (editor, shell, package manager)
- Define your language preferences (Swedish, English, both)
- List your current projects
- Set your goals and vision

**Example:**
```markdown
**Name:** <YOUR_NAME>
**Profession:** PhD Candidate in Information Security
**Editor:** NeoVim
**Language:** Swedish (natural) + English (technical/code)
```

---

### Configuration

#### `settings.json`
**Purpose:** Claude Code configuration - hooks, permissions, voice setup

**What it contains:**
- **Hooks configuration** - When to run which hooks
- **Auto-approve tools** - Tools Claude can use without asking
- **Environment variables** - PAI directory, voice server URL
- **Voice settings** (if using ElevenLabs)

**Customize:**
- Update `PAI_DIR` if using non-standard location
- Add/remove auto-approved tools
- Configure voice server URL (if using)
- Enable/disable specific hooks

**Important sections:**

```json
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

#### `.gitignore`
**Purpose:** Security - prevent sensitive files from being committed to git

**Protects:**
- API keys and credentials (`.env`, `.mcp.json`)
- Personal information (`PAI.md`, `context/`)
- Logs and temporary files
- OS-specific files (`.DS_Store`, etc.)

**Usage:** Copy to any project directory where you're using Ogmios

---

### UFC Context System

#### `context/UFC.md`
**Purpose:** Overview of your UFC (Universal File-based Context) system

**What it contains:**
- System architecture overview
- Directory structure
- Progressive Disclosure tiers (Tier 1/2/3)
- Intent patterns for context loading
- Best practices

**Customize:**
- Describe your personal context organization
- Define intent patterns for your projects
- Document your Tier 1/2/3 strategy

**Example intent patterns:**
```markdown
## Intent Patterns

When user mentions "e-commerce project":
→ Load: context/projects/ecommerce.md

When user mentions "machine learning":
→ Load: context/projects/ml-project.md
→ Load: context/technical/python-ml-stack.md
```

#### `context/memory/decisions.md`
**Purpose:** Architectural Decision Records (ADRs) - document important decisions

**Format:**
```markdown
## Decision: UFC Tier System
**Date:** 2025-01-15
**Status:** Accepted
**Context:** Need to manage context size while providing detailed info
**Decision:** Use 3-tier progressive disclosure system
**Consequences:**
- ✅ Better token management
- ✅ Faster initial responses
- ⚠️ Requires discipline in file organization
```

**Use for:**
- System architecture decisions
- Technology choices
- Workflow changes
- Process improvements

#### `context/memory/learnings.md`
**Purpose:** Capture lessons learned - mistakes, quick wins, failed experiments

**Categories:**
- **Mistakes & Fixes** - What went wrong and how you fixed it
- **Quick Wins** - Surprisingly effective solutions
- **Failed Experiments** - What didn't work (avoid repeating)

**Example:**
```markdown
### Mistake: Over-complicated hook logic
**Date:** 2025-01-20
**What happened:** Created complex intent detection with ML
**Impact:** Hooks timed out (>5 seconds)
**Fix:** Simplified to keyword matching
**Lesson:** Keep hooks simple and fast (<2 seconds)
```

---

### Skills System

#### `skills/SKILLS-INDEX.md`
**Purpose:** Registry of all available skills with metadata

**Contains 7 predefined skills:**
- **engineering** - George Foster (code implementation)
- **architecture** - Dr. Emma Roberts (system design)
- **research** - Dr. Alice Mitchell (academic research)
- **knowledge-management** - Marcus Thompson (content creation)
- **swedish-academic-writing** - Prof. Lars Bergström (Swedish academic)
- **devops** - James Carter (deployment, infrastructure)
- **security** - Sarah Chen (security review)

**Format:**
```markdown
### engineering
**Name:** George Foster
**Voice:** British male engineer
**Triggers:** code, implement, build, fix, debug, refactor, optimize
**Voice ID:** <VOICE_ID_ENGINEERING>
**File:** ~/.claude/.claude/skills/engineering/SKILL.md
**Tier:** 1

**Description:**
Senior software engineer specializing in clean code...
```

**Customize:**
- Add your own skills
- Adjust triggers for better activation
- Set voice IDs if using ElevenLabs
- Create skill-specific files in `skills/<skill-name>/SKILL.md`

**Adding a new skill:**
```markdown
### your-skill-name
**Name:** Expert Name
**Voice:** Voice description
**Triggers:** keyword1, keyword2, keyword3
**Voice ID:** <VOICE_ID_CUSTOM>
**File:** ~/.claude/.claude/skills/your-skill-name/SKILL.md
**Tier:** 1

**Description:**
What this skill does...
```

---

### Hooks

Hooks are TypeScript files that run automatically at specific events in Claude Code.

#### `hooks/package.json`
**Purpose:** Dependencies for hook scripts

**Contains:**
- TypeScript types for Claude Code hooks
- File system utilities
- HTTP client for voice server

**Install dependencies:**
```bash
cd ~/.claude/.claude/hooks
bun install  # or npm install
```

#### `hooks/tsconfig.json`
**Purpose:** TypeScript configuration for hooks

**Settings:**
- ESNext target for modern JavaScript
- Strict type checking
- Module resolution for Node.js

#### `hooks/session-start.ts`
**Purpose:** Run when Claude Code starts a new session

**What it does:**
- Loads `PAI.md` content
- Displays welcome message
- Sets up session context

**Customize:**
- Add additional initialization logic
- Load session-specific context
- Display custom welcome message

#### `hooks/load-ufc-context.ts`
**Purpose:** Load context before AI responds (UserPromptSubmit event)

**What it does:**
- Reads user message
- Detects intent (keywords, project names)
- Loads relevant UFC context files
- Returns context as system message

**Customize:**
- Add your own intent patterns
- Define project-specific keywords
- Implement Tier-based loading logic

**Example customization:**
```typescript
const projectKeywords = {
  'my-app': ['app', 'frontend', 'react'],
  'ml-model': ['machine learning', 'model', 'training']
};

// Detect which project user is asking about
for (const [project, keywords] of Object.entries(projectKeywords)) {
  if (keywords.some(kw => message.toLowerCase().includes(kw))) {
    // Load project context
    const contextPath = `${PAI_DIR}/context/projects/${project}.md`;
    // ...
  }
}
```

#### `hooks/skill-activation.ts`
**Purpose:** Automatically activate specialist skills based on task type

**What it does:**
- Reads `SKILLS-INDEX.md`
- Parses skill triggers
- Matches user message against triggers
- Scores potential skills
- Activates best match if score > threshold

**Scoring algorithm:**
- Exact word match: 15 points
- Partial match: 5 points
- Threshold: 20 points minimum

**Customize:**
- Adjust activation threshold (default: 20)
- Add custom scoring logic
- Implement multi-skill activation

**Example:**
```typescript
// User: "Build a REST API for authentication"
//
// Matches:
// - "build" → engineering (+15)
// - "API" → engineering (+15)
// - "authentication" → security (+5)
//
// Score: engineering = 30, security = 5
// → Activates engineering skill (score > 20)
```

#### `hooks/stop-voice.ts` (Optional)
**Purpose:** Voice feedback when AI finishes response

**What it does:**
- Extracts `COMPLETED` and `CUSTOM COMPLETED` tags
- Detects active agent/skill
- Maps agent to voice ID
- Triggers voice server to speak completion

**Requires:**
- Voice server running at `localhost:8765`
- ElevenLabs API key configured
- Voice IDs set in script

**Customize:**
- Add your own voices
- Adjust speech rate
- Modify language detection

**Voice mapping:**
```typescript
const VOICE_MAP = {
  engineering: {
    id: 'YOUR_BRITISH_MALE_VOICE_ID',
    name: 'George Foster',
    language: 'en'
  },
  research: {
    id: 'YOUR_BRITISH_FEMALE_VOICE_ID',
    name: 'Dr. Alice Mitchell',
    language: 'en'
  }
};
```

#### `hooks/log-tool-use.ts` (Optional)
**Purpose:** Log all tool usage for analytics

**What it does:**
- Detects tool calls (Read, Write, Edit, Bash, etc.)
- Extracts parameters (sanitized)
- Logs to JSON Lines format
- Tracks success/failure

**Output format:**
```json
{"timestamp":"2025-01-15T10:30:00Z","tool":"Read","category":"file","parameters":{"file_path":"/path/to/file.md"},"success":true}
{"timestamp":"2025-01-15T10:30:05Z","tool":"Edit","category":"file","parameters":{"file_path":"/path/to/code.ts"},"success":true}
```

**Customize:**
- Change log file location
- Add custom tool categories
- Implement log rotation
- Add analytics queries

---

## 🚀 After Installation

### 1. Verify Installation

```bash
# Run verification script
./verify-installation.sh

# Expected output:
# ✅ Claude Code installed
# ✅ PAI.md exists
# ✅ settings.json exists
# ✅ UFC.md exists
# ✅ SKILLS-INDEX.md exists
# ✅ Hooks configured
```

### 2. Customize Templates

**Essential customizations:**

1. **Edit PAI.md:**
   ```bash
   nano ~/.claude/.claude/PAI.md
   ```
   - Replace `<YOUR_NAME>`
   - Fill in your details
   - Set your goals

2. **Create project context:**
   ```bash
   cp examples/en/example-ufc-tier1.md ~/.claude/.claude/context/projects/my-project.md
   # Edit with your project details
   ```

3. **Customize skills:**
   ```bash
   nano ~/.claude/.claude/skills/SKILLS-INDEX.md
   # Add/remove skills
   # Adjust triggers
   ```

### 3. Install Hook Dependencies

```bash
cd ~/.claude/.claude/hooks
bun install  # or npm install

# Verify
bun run session-start.ts  # Should output welcome message
```

### 4. Optional: Voice System

If you want voice feedback:

```bash
# Install voice server
cd voice-server
pip3 install -r requirements.txt

# Configure
cp .env.example .env
nano .env  # Add ELEVENLABS_API_KEY

# Start server
./start.sh

# Test
curl -X POST http://localhost:8765/speak \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello from Ogmios", "voice_id": "YOUR_VOICE_ID"}'
```

Update `hooks/stop-voice.ts` with your voice IDs.

### 5. Test Your Setup

```bash
# Start Claude Code
claude

# Test context loading:
> "What's in my UFC context?"
# Should show: ✅ Context hydrated: UFC.md

# Test skill activation:
> "Build a login form"
# Should activate: engineering skill (George Foster)

# Check response format:
# Should end with: 🎯 COMPLETED: [task description]
```

---

## 📚 Related Documentation

**Core Guides:**
- [Installation Guide](../docs/01-getting-started/installation.md) - Complete setup instructions
- [UFC System](../docs/02-core-concepts/ufc-context.md) - Context management
- [Skills System](../docs/02-core-concepts/skills.md) - Specialist activation
- [Hooks & Automation](../docs/02-core-concepts/hooks.md) - Event-driven system

**Examples:**
- [Example UFC Tier 1](../examples/en/example-ufc-tier1.md) - Quick project overview
- [Example UFC Tier 2](../examples/en/example-ufc-tier2.md) - Architecture details
- [Example Skill](../examples/en/example-skill-research.md) - Complete skill definition

**Reference:**
- [FAQ](../docs/08-faq/faq.md) - Common questions
- [Troubleshooting](../docs/01-getting-started/troubleshooting.md) - Debug issues
- [Compliance](../en/11-COMPLIANCE-ENFORCEMENT.md) - Mandatory instructions

---

## 🔐 Security Notes

**IMPORTANT - READ BEFORE USING:**

### 1. Never Commit Sensitive Data

The `.gitignore` template protects:
- `PAI.md` (contains personal info)
- `context/` (may contain private notes)
- `.mcp.json` (contains API keys)
- `.env` (contains secrets)

**Always verify before committing:**
```bash
# Check what will be committed
git status

# Check remote URL (should be YOUR private repo or local only)
git remote -v

# If unsure, DON'T commit
```

### 2. API Keys

**Never put API keys directly in code or config:**

❌ **WRONG:**
```json
{
  "mcpServers": {
    "github": {
      "env": {
        "GITHUB_TOKEN": "ghp_abc123def456"  // ← NEVER DO THIS
      }
    }
  }
}
```

✅ **CORRECT:**
```bash
# Store in .mcp.json (gitignored)
# Or use environment variables
export GITHUB_TOKEN="ghp_abc123def456"
```

### 3. File Permissions

```bash
# Set restrictive permissions
chmod 700 ~/.claude/.claude          # Only you can access
chmod 600 ~/.claude/.claude/PAI.md   # Only you can read/write
chmod 600 ~/.claude/.mcp.json        # Protect API keys
```

### 4. Backup Your Config

```bash
# Create encrypted backup
tar czf ogmios-backup-$(date +%Y%m%d).tar.gz ~/.claude/.claude
gpg -c ogmios-backup-*.tar.gz  # Encrypt with password
rm ogmios-backup-*.tar.gz      # Remove unencrypted

# Restore
gpg -d ogmios-backup-*.tar.gz.gpg | tar xz -C ~
```

---

## ❓ Getting Help

**If templates aren't working:**

1. **Run verification:**
   ```bash
   ./verify-installation.sh --fix
   ```

2. **Check troubleshooting guide:**
   ```bash
   cat docs/docs/01-getting-started/troubleshooting.md | less
   ```

3. **Common issues:**
   - Hooks not running → Install Bun: `curl -fsSL https://bun.sh/install | bash`
   - Context not loading → Check `settings.json` hooks section
   - Skills not activating → Verify `SKILLS-INDEX.md` exists

4. **Get community help:**
   - GitHub Discussions: https://github.com/<username>/ogmios-pai/discussions
   - GitHub Issues: https://github.com/<username>/ogmios-pai/issues

---

## 📝 Template Changelog

**v1.0.0 (2025-11-09):**
- ✅ Initial template release
- ✅ Complete compliance enforcement in PAI.md
- ✅ 7 predefined skills in SKILLS-INDEX.md
- ✅ All essential hooks (session-start, load-ufc-context, skill-activation)
- ✅ Optional hooks (stop-voice, log-tool-use)
- ✅ Security-focused .gitignore

---

**Happy hacking with Ogmios! 🚀**

*Building your Personal AI Infrastructure, one template at a time.*
