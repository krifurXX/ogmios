# Ogmios Template Customization Checklist

**Purpose:** Step-by-step checklist to customize Ogmios templates for your Personal AI Infrastructure.

**Time Required:** 1-2 hours (complete customization)

**Prerequisites:**
- Claude Code installed
- Bun or Node.js 18+ installed
- Basic understanding of Markdown and JSON

---

## Table of Contents

- [Quick Start](#quick-start)
- [Phase 1: Essential Configuration](#phase-1-essential-configuration-30-min)
- [Phase 2: Skills & Specialization](#phase-2-skills--specialization-20-min)
- [Phase 3: Context & Projects](#phase-3-context--projects-15-min)
- [Phase 4: Voice System](#phase-4-voice-system-optional-15-min)
- [Phase 5: Advanced Features](#phase-5-advanced-features-optional-30-min)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

**TL;DR - Minimum Viable Configuration (5 minutes):**

```bash
# 1. Install templates
cp -r templates/* ~/.claude/.claude/

# 2. Customize PAI.md (minimal)
cd ~/.claude/.claude/
nano PAI.md  # Replace: <YOUR_NAME>, <YOUR_LOCATION>, <YOUR_ROLE>

# 3. Install hooks
cd hooks
bun install

# 4. Start Claude
claude
```

**You're ready!** The rest of this guide adds powerful features.

---

## Phase 1: Essential Configuration (30 min)

Essential files that make Ogmios work.

### 1.1 PAI Identity (`PAI.md`)

**Location:** `~/.claude/.claude/PAI.md`

**Priority:** 🔴 CRITICAL (Claude loads this on every session)

**Checklist:**

- [ ] **Basic Identity**
  ```markdown
  # Find line ~10
  Your Name: <YOUR_NAME>  # Replace with your full name

  # Example:
  Your Name: Jane Smith
  ```

- [ ] **Location**
  ```markdown
  # Find line ~12
  Location: <YOUR_CITY>, <YOUR_COUNTRY>

  # Example:
  Location: San Francisco, USA
  ```

- [ ] **Current Role**
  ```markdown
  # Find line ~14
  Current Role: <YOUR_ROLE>

  # Example:
  Current Role: Senior Software Engineer
  ```

- [ ] **Languages**
  ```markdown
  # Find line ~20
  - Primary: <YOUR_PRIMARY_LANGUAGE>
  - Secondary: <YOUR_SECONDARY_LANGUAGE>

  # Example:
  - Primary: English
  - Secondary: Spanish
  ```

- [ ] **Operating System**
  ```markdown
  # Find line ~35
  - OS: <YOUR_OS>

  # Example:
  - OS: macOS Sonoma 14.2
  ```

- [ ] **Preferred Tools**
  ```markdown
  # Find line ~40
  - Editor: <YOUR_EDITOR>
  - Terminal: <YOUR_TERMINAL>
  - Shell: <YOUR_SHELL>

  # Example:
  - Editor: VS Code
  - Terminal: iTerm2
  - Shell: zsh
  ```

- [ ] **Cloud Services**
  ```markdown
  # Find line ~154
  - Cloud: <YOUR_CLOUD_PROVIDER>

  # Example:
  - Cloud: Google Drive for personal, GitHub for code
  ```

**Time:** 10 minutes

---

### 1.2 Directory Structure (`context/directory-structure.md`)

**Location:** `~/.claude/.claude/context/directory-structure.md`

**Priority:** 🟠 HIGH (Helps Claude understand your file organization)

**Checklist:**

- [ ] **Workspace Path**
  ```markdown
  # Find line ~15
  <WORKSPACE_PATH>/

  # Replace with your actual workspace:
  ~/projects/
  ```

- [ ] **Project Organization**
  ```markdown
  # Update section: "Your Project Organization"
  # Add your real project folders:

  ~/projects/
  ├── work/
  │   ├── client-app/
  │   └── internal-tools/
  ├── personal/
  │   ├── blog/
  │   └── side-projects/
  ```

- [ ] **Knowledge Base Location** (if using Obsidian/Notion)
  ```markdown
  # Find section: "Knowledge Base"

  # Example for Obsidian:
  ~/Documents/ObsidianVault/

  # Example for Notion:
  # Link to Notion workspace
  ```

**Time:** 5 minutes

---

### 1.3 Settings Configuration (`settings.json`)

**Location:** `~/.claude/settings.json`

**Priority:** 🟠 HIGH (Claude Code configuration)

**Checklist:**

- [ ] **Copy template** (if not exists)
  ```bash
  cp examples/en/example-settings.json ~/.claude/settings.json
  ```

- [ ] **Update workspace paths**
  ```json
  {
    "workspaceFolders": [
      "/Users/<YOUR_USERNAME>/projects",     // ← UPDATE THIS
      "/Users/<YOUR_USERNAME>/Documents"     // ← UPDATE THIS
    ]
  }
  ```

- [ ] **Set default language** (optional)
  ```json
  {
    "locale": "en-US"  // or "sv-SE", "es-ES", etc.
  }
  ```

- [ ] **Configure MCP servers** (if using)
  ```json
  {
    "mcpServers": {
      "github": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-github"],
        "env": {
          "GITHUB_PERSONAL_ACCESS_TOKEN": "<YOUR_TOKEN>"  // ← ADD TOKEN
        }
      }
    }
  }
  ```

**Time:** 5 minutes

---

### 1.4 Hook Dependencies

**Location:** `~/.claude/.claude/hooks/`

**Priority:** 🟠 HIGH (Hooks enable automation)

**Checklist:**

- [ ] **Install dependencies**
  ```bash
  cd ~/.claude/.claude/hooks
  bun install
  # or: npm install
  ```

- [ ] **Verify package.json exists**
  ```bash
  ls package.json
  # Should exist from template copy
  ```

- [ ] **Test hook compilation** (optional)
  ```bash
  bun run build
  # or: npm run build
  ```

- [ ] **Check hook permissions**
  ```bash
  chmod 600 *.ts
  ```

**Time:** 5 minutes

---

### 1.5 Skills Index (`SKILLS-INDEX.md`)

**Location:** `~/.claude/.claude/SKILLS-INDEX.md`

**Priority:** 🟡 MEDIUM (Skills work without this, but better with it)

**Checklist:**

- [ ] **Verify file exists**
  ```bash
  ls ~/.claude/.claude/SKILLS-INDEX.md
  ```

- [ ] **Review enabled skills**
  ```markdown
  # Find section: "Active Skills"
  # Default skills included:
  # - CORE
  # - engineering
  # - research
  # - architecture
  # - technical-writing

  # Uncomment skills you want to activate:
  # - data-analysis
  # - devops
  # - security
  # - swedish-academic (if Swedish speaker)
  ```

- [ ] **Disable unused skills** (optional)
  ```markdown
  # Comment out skills you won't use:
  # ## data-analysis
  # (reduces context load)
  ```

**Time:** 5 minutes

---

## Phase 2: Skills & Specialization (20 min)

Customize your AI team of specialists.

### 2.1 Core Skill (`skills/CORE/README.md`)

**Location:** `~/.claude/.claude/skills/CORE/README.md`

**Priority:** 🔴 CRITICAL (CORE skill defines your AI's personality)

**Checklist:**

- [ ] **Update persona message**
  ```markdown
  # Find line ~132
  Your Role: <YOUR_NAME>'s AI assistant

  # Example:
  Your Role: Jane's AI assistant and future friend
  ```

- [ ] **Set frustration tolerance**
  ```markdown
  # Find line ~134
  Message to AI: Remember that <YOUR_NAME> gets frustrated when...

  # Example:
  Message to AI: Remember that Jane values efficiency.
  Stay concise unless asked for details.
  ```

- [ ] **Add key contacts** (3-5 important people)
  ```markdown
  # Find line ~139
  ## Key Contacts

  - **<NAME>** <RELATIONSHIP> - <EMAIL>

  # Example:
  - **Sarah Johnson** Manager - sarah@company.com
  - **Mike Chen** Mentor - mike@example.com
  ```

- [ ] **Update communication preferences**
  ```markdown
  # Find section: "Communication Style"

  # Adjust to your preferences:
  - Tone: Professional but friendly
  - Verbosity: Concise with option to expand
  - Emoji use: Minimal (only for clarity)
  ```

**Time:** 10 minutes

---

### 2.2 Engineering Skill (if developer)

**Location:** `~/.claude/.claude/skills/engineering/SKILL.md`

**Priority:** 🟡 MEDIUM

**Checklist:**

- [ ] **Update tech stack**
  ```markdown
  # Find section: "Preferred Technologies"

  # Update with YOUR stack:
  - **Backend:** Python (FastAPI), Node.js (Express)
  - **Frontend:** React, TypeScript
  - **Database:** PostgreSQL, Redis
  - **Cloud:** AWS (primary), Google Cloud (secondary)
  ```

- [ ] **Set coding standards**
  ```markdown
  # Find section: "Coding Standards"

  # Add your team's standards:
  - Follow PEP 8 for Python
  - Use ESLint + Prettier for JavaScript
  - Maximum function length: 50 lines
  ```

- [ ] **Configure testing preferences**
  ```markdown
  # Find section: "Testing"

  # Your approach:
  - Test framework: pytest (Python), Jest (JavaScript)
  - Coverage target: 80%
  - TDD: Prefer for complex business logic
  ```

**Time:** 5 minutes

---

### 2.3 Swedish Academic Skill (if Swedish speaker)

**Location:** `~/.claude/.claude/skills/swedish-academic/SKILL.md`

**Priority:** 🟡 MEDIUM (only if you write Swedish academic content)

**Checklist:**

- [ ] **Update academic affiliation**
  ```markdown
  # Find line ~20
  **Affiliation:** <YOUR_UNIVERSITY>

  # Example:
  **Affiliation:** Lund University, Department of Computer Science
  ```

- [ ] **Set citation style**
  ```markdown
  # Find section: "Citation Standards"

  # Your preference:
  - Primary style: Harvard
  - Secondary: APA 7th edition
  ```

- [ ] **Configure Swedish language settings**
  ```markdown
  # Find section: "Language Settings"

  # Dialect preferences:
  - Spelling: Swedish (Sweden) - sv-SE
  - Formality: Academic formal
  - Terminology: Prefer Swedish terms when available
  ```

**Time:** 5 minutes

---

## Phase 3: Context & Projects (15 min)

Add your actual work and personal projects.

### 3.1 Create Project Files

**Location:** `~/.claude/.claude/context/projects/`

**Priority:** 🟡 MEDIUM (Very helpful for context loading)

**Checklist:**

- [ ] **Create project file for each major project**
  ```bash
  # Use template:
  cp examples/en/example-ufc-tier2.md \
     ~/.claude/.claude/context/projects/my-project.md
  ```

- [ ] **Customize project details**
  ```markdown
  # For each project file:

  **Name:** <Actual Project Name>
  **Status:** Active | Planning | Maintenance
  **Priority:** P0 (critical) | P1 (high) | P2 (medium) | P3 (low)

  **Tech Stack:**
  - Backend: <YOUR_STACK>
  - Frontend: <YOUR_STACK>
  - Database: <YOUR_DB>

  **Repository:** https://github.com/<USER>/<REPO>
  ```

- [ ] **Add key files and structure**
  ```markdown
  ## Key Files

  - `/src/main.py` - Application entry point
  - `/tests/` - Test suite
  - `/docs/` - Documentation
  ```

- [ ] **Document common tasks**
  ```markdown
  ## Common Tasks

  - **Start dev server:** `bun dev`
  - **Run tests:** `bun test`
  - **Deploy:** `bun run deploy:prod`
  ```

**Repeat for 3-5 major projects.**

**Time:** 10 minutes (2 min per project)

---

### 3.2 Update Contacts (`context/contacts.md`)

**Location:** `~/.claude/.claude/context/contacts.md`

**Priority:** 🟢 LOW (Nice to have, not essential)

**Checklist:**

- [ ] **Add family contacts** (if desired)
  ```markdown
  ## Family

  - Mom: <NAME> - <EMAIL> - <PHONE>
  - Sibling: <NAME> - <EMAIL>
  ```

- [ ] **Add professional contacts**
  ```markdown
  ## Work

  - Manager: <NAME> - <EMAIL>
  - Team Lead: <NAME> - <EMAIL>
  - HR: <NAME> - <EMAIL>
  ```

- [ ] **Add key collaborators**
  ```markdown
  ## Collaborators

  - <NAME> - <ROLE> - <EMAIL> - <EXPERTISE>
  ```

**Time:** 5 minutes

---

## Phase 4: Voice System (Optional, 15 min)

Add voice feedback for task completions.

### 4.1 Get ElevenLabs API Key

**Priority:** 🟢 OPTIONAL (Voice is nice-to-have)

**Checklist:**

- [ ] **Sign up for ElevenLabs**
  - Visit: https://elevenlabs.io
  - Create free account (10,000 characters/month free)

- [ ] **Get API key**
  - Navigate to: Settings → API Keys
  - Click: "Create API Key"
  - Copy key (starts with `sk_...`)

- [ ] **Store API key securely**
  ```bash
  # Create .env file in voice-server/
  cd voice-server
  cp .env.example .env
  nano .env

  # Add your key:
  ELEVENLABS_API_KEY=sk_your_actual_key_here
  ```

- [ ] **Verify .env in .gitignore**
  ```bash
  # Check that .env won't be committed:
  cat .gitignore | grep ".env"
  # Should show: .env
  ```

**Time:** 5 minutes

---

### 4.2 Configure Voice Mappings

**Location:** `voice-server/voices.json`

**Priority:** 🟢 OPTIONAL

**Checklist:**

- [ ] **Copy voice template**
  ```bash
  cd voice-server
  cp voices.json.example voices.json
  ```

- [ ] **Choose voices from ElevenLabs**
  - Visit: https://elevenlabs.io/app/voice-library
  - Listen to pre-made voices
  - Note Voice IDs for voices you like

- [ ] **Update voice mappings**
  ```json
  {
    "skills": {
      "engineering": {
        "id": "<YOUR_CHOSEN_VOICE_ID>",
        "name": "Your Engineering Voice",
        "language": "en"
      },
      "research": {
        "id": "<ANOTHER_VOICE_ID>",
        "name": "Your Research Voice",
        "language": "en"
      }
    }
  }
  ```

- [ ] **Test voice server**
  ```bash
  cd voice-server
  ./start.sh

  # In another terminal:
  curl http://localhost:5050/health
  # Should return: {"status": "healthy"}
  ```

**Time:** 10 minutes

---

## Phase 5: Advanced Features (Optional, 30 min)

Power user features for maximum PAI customization.

### 5.1 MCP Server Integration

**Priority:** 🟢 OPTIONAL (Advanced integrations)

**Checklist:**

- [ ] **GitHub MCP** (for repository access)
  ```json
  // In ~/.claude/settings.json
  {
    "mcpServers": {
      "github": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-github"],
        "env": {
          "GITHUB_PERSONAL_ACCESS_TOKEN": "<YOUR_GITHUB_TOKEN>"
        }
      }
    }
  }
  ```

- [ ] **Zotero MCP** (for academic references)
  ```json
  {
    "mcpServers": {
      "zotero": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-zotero"],
        "env": {
          "ZOTERO_API_KEY": "<YOUR_ZOTERO_KEY>",
          "ZOTERO_USER_ID": "<YOUR_USER_ID>"
        }
      }
    }
  }
  ```

- [ ] **n8n MCP** (for workflow automation)
  ```json
  {
    "mcpServers": {
      "n8n": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-n8n"],
        "env": {
          "N8N_API_URL": "https://your-n8n-instance.com",
          "N8N_API_KEY": "<YOUR_N8N_KEY>"
        }
      }
    }
  }
  ```

**Time:** 10 minutes

---

### 5.2 Custom Skills

**Priority:** 🟢 OPTIONAL (Create your own specialists)

**Checklist:**

- [ ] **Create new skill directory**
  ```bash
  mkdir -p ~/.claude/.claude/skills/my-custom-skill
  ```

- [ ] **Copy skill template**
  ```bash
  cp ~/.claude/.claude/skills/CORE/README.md \
     ~/.claude/.claude/skills/my-custom-skill/SKILL.md
  ```

- [ ] **Customize skill**
  ```markdown
  # Edit SKILL.md

  **Name:** My Custom Skill
  **Persona:** Dr. Custom Expert
  **Expertise:** <Your Domain>

  ## When to Activate

  - User mentions: <KEYWORD>
  - Task type: <TASK_TYPE>

  ## Core Competencies

  1. <COMPETENCY_1>
  2. <COMPETENCY_2>
  ```

- [ ] **Add to SKILLS-INDEX.md**
  ```markdown
  ## my-custom-skill

  **Status:** active
  **Persona:** Dr. Custom Expert
  **Expertise:** <Domain>
  ```

- [ ] **Create workflows** (optional)
  ```bash
  mkdir ~/.claude/.claude/skills/my-custom-skill/workflows
  # Add .md files with step-by-step processes
  ```

**Time:** 15 minutes per skill

---

### 5.3 Hook Customization

**Priority:** 🟢 OPTIONAL (Advanced automation)

**Checklist:**

- [ ] **Review available hooks**
  ```bash
  ls ~/.claude/.claude/hooks/*.ts
  ```

- [ ] **Customize stop-voice.ts** (change voice behavior)
  ```typescript
  // Find line ~80
  const voiceMap: VoiceMapping = {
    engineering: {
      name: '<YOUR_ENGINEERING_VOICE_NAME>',
      voiceId: '<YOUR_ENGINEERING_VOICE_ID>',
    }
  };
  ```

- [ ] **Customize content-guard.ts** (add your no-no words)
  ```typescript
  // Find line ~40
  const PROHIBITED_PATTERNS = [
    /\bsynergy\b/i,
    /\bparadigm shift\b/i,
    /\b<YOUR_HATED_BUZZWORD>\b/i,  // ← ADD YOURS
  ];
  ```

- [ ] **Test hook changes**
  ```bash
  cd ~/.claude/.claude/hooks
  bun run build
  # Restart Claude to apply changes
  ```

**Time:** 5 minutes per hook

---

## Verification

After customization, verify everything works:

### Checklist: Final Verification

- [ ] **Run verification script**
  ```bash
  cd ~/path/to/ogmios-pai  # Your repo clone
  ./verify-installation.sh
  ```

- [ ] **Start Claude Code**
  ```bash
  claude
  ```

- [ ] **Check PAI.md loads**
  ```
  Ask Claude: "What's in my PAI.md?"
  Expected: Should describe YOUR name, role, preferences
  ```

- [ ] **Test skill activation**
  ```
  Ask Claude: "Build me a REST API for user management"
  Expected: Engineering skill should activate automatically
  ```

- [ ] **Test voice system** (if configured)
  ```
  # Voice server should be running
  # Ask Claude to complete a task
  Expected: Hear completion message
  ```

- [ ] **Test project context**
  ```
  Ask Claude: "Let's work on <YOUR_PROJECT>"
  Expected: Should load project context from context/projects/
  ```

- [ ] **Check hook functionality**
  ```
  # Hooks should:
  # - Load PAI.md on session start
  # - Activate skills automatically
  # - Validate completions
  # - Trigger voice (if configured)
  ```

---

## Troubleshooting

### Issue 1: PAI.md not loading

**Symptoms:** Claude doesn't know your name/preferences

**Fix:**
```bash
# Check file exists
ls ~/.claude/.claude/PAI.md

# Check permissions
chmod 600 ~/.claude/.claude/PAI.md

# Verify no syntax errors
cat ~/.claude/.claude/PAI.md | head -50
```

---

### Issue 2: Skills not activating

**Symptoms:** Claude doesn't use specialist personas

**Fix:**
```bash
# Check SKILLS-INDEX.md exists
ls ~/.claude/.claude/SKILLS-INDEX.md

# Verify skill files exist
ls ~/.claude/.claude/skills/*/SKILL.md

# Check hook is active
ls ~/.claude/.claude/hooks/skill-activation.ts
```

---

### Issue 3: Hooks not working

**Symptoms:** No automation, skills don't activate

**Fix:**
```bash
# Check dependencies installed
cd ~/.claude/.claude/hooks
ls node_modules/  # Should have packages

# Reinstall if needed
rm -rf node_modules
bun install

# Check TypeScript compiles
bun run build
```

---

### Issue 4: Voice server not starting

**Symptoms:** No voice feedback

**Fix:**
```bash
# Check Python installed
python3 --version  # Should be 3.8+

# Check dependencies
cd voice-server
pip3 install -r requirements.txt

# Check .env file
cat .env | grep ELEVENLABS_API_KEY
# Should show your key (not empty)

# Check port not in use
lsof -i :5050  # Should be empty or show ogmios

# Restart server
./stop.sh
./start.sh
```

---

### Issue 5: Settings not applied

**Symptoms:** Claude doesn't use your workspace paths

**Fix:**
```bash
# Check settings.json location
ls ~/.claude/settings.json

# Verify JSON is valid
cat ~/.claude/settings.json | python3 -m json.tool

# Check for syntax errors
# Common: trailing commas, missing quotes

# Restart Claude
claude --reload-settings
```

---

## Quick Reference: Essential Placeholders

Replace these in ALL files where they appear:

```markdown
<YOUR_NAME>              → Your full name
<YOUR_EMAIL>             → Your email address
<YOUR_LOCATION>          → City, Country
<YOUR_ROLE>              → Current job title
<YOUR_OS>                → macOS / Linux / Windows
<YOUR_EDITOR>            → VS Code / Vim / etc.
<YOUR_SHELL>             → zsh / bash / fish

<YOUR_API_KEY>           → ElevenLabs API key
<GITHUB_TOKEN>           → GitHub personal access token
<YOUR_VOICE_ID>          → ElevenLabs voice ID

<WORKSPACE_PATH>         → ~/projects/ or your workspace
<PROJECT_NAME>           → Your project names
<VAULT_PATH>             → Obsidian vault path (if using)
```

---

## Time Estimates Summary

| Phase | Time | Priority |
|-------|------|----------|
| Phase 1: Essential | 30 min | 🔴 CRITICAL |
| Phase 2: Skills | 20 min | 🟡 RECOMMENDED |
| Phase 3: Projects | 15 min | 🟡 RECOMMENDED |
| Phase 4: Voice | 15 min | 🟢 OPTIONAL |
| Phase 5: Advanced | 30 min | 🟢 OPTIONAL |
| **TOTAL** | **110 min** | **~2 hours** |

**Minimum viable:** Phase 1 only (30 min)
**Recommended:** Phases 1-3 (65 min)
**Full setup:** All phases (110 min)

---

## Next Steps

After customization:

1. **✅ Test thoroughly** - Run verification script
2. **📚 Read documentation** - See [docs/01-getting-started/overview.md](docs/01-getting-started/overview.md)
3. **🎯 Start using** - Begin with simple tasks
4. **🔧 Iterate** - Refine configuration based on usage
5. **💡 Share** - Contribute improvements back to community

---

## Help & Support

**Need help?**
- 📖 Full documentation: [docs/01-getting-started/installation.md](docs/01-getting-started/installation.md)
- 🐛 Troubleshooting: [docs/01-getting-started/troubleshooting.md](docs/01-getting-started/troubleshooting.md)
- ❓ FAQ: [docs/08-faq/faq.md](docs/08-faq/faq.md)
- 💬 Community: [GitHub Discussions](https://github.com/<your_username>/ogmios-pai/discussions)

**Found a bug?**
- 🐛 Report: [GitHub Issues](https://github.com/<your_username>/ogmios-pai/issues)

---

**You're ready to use Ogmios!** 🚀

*Enjoy your Personal AI Infrastructure.*
