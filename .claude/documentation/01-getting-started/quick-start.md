# Quick Start Guide - Get Ogmios Running in 5 Minutes

This guide gets you from zero to running Ogmios in one terminal session.

---

## Prerequisites Check

Before starting, verify you have:

```bash
# Check Claude Code is installed
claude --version

# Check Node.js/Bun (for TypeScript hooks)
bun --version
# OR
node --version

# Check you're on macOS/Linux
uname -s
# Should show: Darwin (macOS) or Linux
```

If anything is missing:
- **Claude Code**: Install from [Claude downloads](https://claude.ai/download)
- **Bun**: Install with `curl -fsSL https://bun.sh/install | bash`
- **Windows users**: See [Windows installation guide](installation.md#windows)

---

## Installation (3 Commands)

### Step 1: Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/ogmios.git ~/.claude-ogmios
```

**What this does**: Downloads Ogmios to `~/.claude-ogmios` (hidden directory in your home folder)

### Step 2: Run Installation Script

```bash
cd ~/.claude-ogmios && ./install.sh
```

**What this does**:
1. Creates `~/.claude/.claude/` directory structure
2. Copies skills, hooks, and context files
3. Configures Claude Code settings
4. Sets up voice system (optional)
5. Installs TypeScript dependencies for hooks

**Expected output**:
```
🚀 Installing Ogmios Personal AI Infrastructure...
✅ Created directory structure
✅ Installed 20 skills
✅ Configured 12 hooks
✅ Set up UFC context system
✅ Configured voice system (optional)
🎉 Installation complete!
```

### Step 3: Start Claude Code

```bash
claude
```

**What happens**:
1. Session starts
2. Core context loads automatically (UFC.md, PAI.md, SKILLS-INDEX.md)
3. Ogmios greets you with system status
4. You're ready to work!

---

## Your First Interaction

### Test 1: Basic Task

Try this:

```
"Build a TypeScript function that reverses a string"
```

**What should happen**:

1. System detects: Code implementation task
2. Auto-activates: **engineering** skill (George Foster)
3. Shows: "✅ Skill activated: engineering (George Foster)"
4. George implements the function with tests
5. Output includes: Working code + tests + documentation
6. Completion message: `🎯 COMPLETED: [SKILL:engineering] implemented string reversal function`

**If voice enabled**: You hear George Foster's British voice say "Engineering skill completed string reversal implementation"

### Test 2: Research Task

Try this:

```
"Research the latest developments in AI agents (quick summary)"
```

**What should happen**:

1. System detects: Research task
2. Auto-activates: **research** skill (Alice Mitchell)
3. Alice gathers sources from multiple places
4. Synthesizes findings into clear summary
5. Includes sources and citations
6. Completion message: `🎯 COMPLETED: [SKILL:research] researched AI agent developments`

### Test 3: Documentation Task

Try this:

```
"Write a README for a weather API project"
```

**What should happen**:

1. System detects: Documentation writing
2. Auto-activates: **technical-writing** skill (Lily)
3. Lily creates professional README
4. Includes: Installation, usage, API reference, examples
5. Completion message: `🎯 COMPLETED: [SKILL:technical-writing] created weather API README`

---

## What Just Happened?

### UFC Context System

Behind the scenes, Ogmios loaded these files:

```
~/.claude/.claude/context/
├── UFC.md                 (System architecture)
├── PAI.md                 (Core identity)
├── SKILLS-INDEX.md        (All 20 skills)
├── projects/              (Project contexts - empty for now)
├── preferences/stack.md   (Your tech stack preferences)
└── memory/
    ├── decisions/         (Architecture decisions)
    └── learnings.md       (System learnings)
```

**Why this matters**:
- These files are loaded on FIRST prompt only (not every prompt)
- Context persists across entire session
- You never repeat preferences

### Skills Activation

Each task matched a skill:

| Your Request | Skill Activated | Specialist |
|--------------|----------------|------------|
| "Build TypeScript function" | engineering | George Foster |
| "Research AI agents" | research | Alice Mitchell |
| "Write README" | technical-writing | Lily |

**Skills activate automatically** based on task type. You don't need to specify.

### Voice System (Optional)

If you installed voice system:
- Each completion plays in that skill's voice
- George Foster = British male (engineering)
- Alice Mitchell = British female (research)
- Lily = Neutral female (writing)

**Voice is optional** - system works perfectly without it.

---

## Next Steps

### Customize Your Preferences

Edit your tech stack preferences:

```bash
# Open in your editor
code ~/.claude/.claude/context/preferences/stack.md

# Or use nano
nano ~/.claude/.claude/context/preferences/stack.md
```

Example customization:

```markdown
# Technology Stack Preferences

- **JavaScript/TypeScript**: bun (NOT npm/yarn/pnpm)
- **Python**: uv (NOT pip)
- **Database**: PostgreSQL (preferred)
- **Testing**: Jest for TS, pytest for Python
- **Documentation**: Always include README.md
- **Code Style**: 2-space indentation, trailing commas
```

**Save and restart Claude Code.** Preferences now apply to all future tasks.

### Add Project Context

Create context for your current project:

```bash
# Create project context file
nano ~/.claude/.claude/context/projects/my-project.md
```

Example project context:

```markdown
# My Project - Weather API

**Type**: Node.js/TypeScript API
**Status**: In development
**Stack**: Express, TypeScript, PostgreSQL

## Key Information

- API endpoints use RESTful conventions
- Database uses TypeORM for queries
- All endpoints require authentication (JWT)
- Error handling follows RFC 7807 (Problem Details)

## Team

- You (developer)
- Sarah (designer) - sarah@example.com
- Mike (product owner) - mike@example.com

## Current Focus

Building user authentication system with JWT tokens.
```

**Now when you work on this project**, create a `claude.md` in your project directory:

```bash
cd ~/projects/my-project
nano claude.md
```

```markdown
# My Project Context

**BEFORE doing ANY work, load:**
- ~/.claude/.claude/context/projects/my-project.md

This ensures Ogmios knows your project conventions.
```

### Enable Voice System (Optional)

If you skipped voice during installation:

1. Get ElevenLabs API key from [elevenlabs.io](https://elevenlabs.io)
2. Configure voice server:

```bash
cd ~/.claude/.claude/voice-server
cp .env.example .env
nano .env
```

Add your API key:

```
ELEVENLABS_API_KEY=your_key_here
VOICE_SERVER_PORT=8888
```

3. Start voice server:

```bash
bun run start
```

4. Test it:

```bash
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message":"Ogmios voice system active","voice_enabled":true}'
```

You should hear Ogmios say "Ogmios voice system active"

---

## Common Issues

### Issue: Skills not activating

**Symptoms**: Tasks execute directly instead of using skills

**Fix**: Check hooks are enabled:

```bash
cat ~/.claude/settings.json | grep hooks
```

Should show multiple hooks. If missing, re-run installation:

```bash
cd ~/.claude-ogmios && ./install.sh
```

### Issue: Context not loading

**Symptoms**: Preferences not applied, starting from scratch

**Fix**: Verify UFC files exist:

```bash
ls -la ~/.claude/.claude/context/
```

Should show directories: projects/, preferences/, memory/, etc.

If missing, re-run installation.

### Issue: Voice not working

**Symptoms**: No voice notifications

**Check voice server is running**:

```bash
curl http://localhost:8888/health
```

Should return: `{"status":"ok"}`

If not, start voice server:

```bash
cd ~/.claude/.claude/voice-server && bun run start
```

---

## Verify Installation

Run this comprehensive test:

```
"Test Ogmios system:
1. Build a simple calculator function (engineering)
2. Research best practices for error handling (research)
3. Document the calculator API (technical-writing)
4. Show me which skills you activated"
```

**Expected behavior**:

1. Three skills activate sequentially
2. Each task completed by specialist
3. Three completion messages with [SKILL:name] tags
4. Summary showing: engineering → research → technical-writing

**If this works**, Ogmios is fully operational.

---

## What to Learn Next

### Understand the System

- [Architecture Overview](architecture.md) - How Ogmios works
- [UFC Context System](ufc-system.md) - Persistent memory
- [Skills System](skills-system.md) - Meet the 20+ specialists

### Customize Your Setup

- [Create Custom Skills](create-skill.md) - Build your own specialists
- [Hook Development](hook-development.md) - Event-driven automation
- [Bilingual Setup](bilingual.md) - Swedish/English configuration

### Integrate Your Data

- [MCP Integration](mcp-integration.md) - Connect Zotero, Obsidian, etc.
- [Obsidian Integration](obsidian-integration.md) - Access your notes
- [Zotero Integration](zotero-integration.md) - Search your research

---

## Getting Help

### Self-Help Resources

- [FAQ](faq.md) - Common questions answered
- [Troubleshooting](troubleshooting.md) - Common issues and fixes
- [Complete Installation Guide](installation.md) - Detailed setup

### Community Support

- [GitHub Discussions](https://github.com/YOUR_USERNAME/ogmios/discussions) - Ask questions
- [GitHub Issues](https://github.com/YOUR_USERNAME/ogmios/issues) - Report bugs
- [Discord Community](https://discord.gg/ogmios) - Real-time chat (coming soon)

---

## Summary

You now have:

✅ Ogmios installed and running
✅ 20+ specialists available
✅ Persistent context system active
✅ Skills auto-activating on tasks
✅ (Optional) Voice system providing feedback

**Welcome to the Specialized AI Assistants!** 🇬🇧🤖

**Next**: [Meet the Specialized AI Assistants](skills.md) - Learn about all 20+ specialists and when to use them.
