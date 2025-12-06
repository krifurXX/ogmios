# Ogmios - Personal AI Infrastructure

**Repository for developing and maintaining a specialized Claude Code configuration.**

---

## WHAT

**Tech Stack:**
- **Runtime:** Bun (TypeScript hooks and automation)
- **Configuration:** Markdown-based context files
- **Platform:** Claude Code with `.claude/` directory structure
- **Languages:** English and Swedish support

**Project Structure:**
```
.claude/
├── PAI.md                    # Main configuration (user-customizable)
├── context/                  # UFC (Universal File-based Context)
│   ├── UFC.md               # Context system documentation
│   ├── projects/            # Project-specific contexts
│   ├── memory/              # Decisions and learnings
│   ├── technical/           # Tech preferences
│   └── tools/               # MCP server configurations
├── skills/                  # Specialized AI personas
│   ├── SKILLS-INDEX.md      # All available skills
│   ├── engineering/         # Code implementation specialist
│   ├── research/            # Academic research specialist
│   ├── architecture/        # System design specialist
│   ├── security/            # Security audit specialist
│   └── [20+ other skills]
├── hooks/                   # TypeScript automation
│   ├── session-start.ts     # Load context on startup
│   ├── skill-activation.ts  # Auto-activate skills
│   └── stop-voice.ts        # Voice feedback on completion
├── documentation/           # Comprehensive guides
└── voice-server/            # Optional ElevenLabs integration
```

---

## WHY

**Purpose:**
Transform Claude Code into a specialized AI system with:
1. **Persistent Memory** - Context survives between sessions (UFC system)
2. **Domain Specialists** - 20+ expert skills for different tasks
3. **Event Automation** - Hooks trigger on session start, prompt submit, stop
4. **Bilingual Support** - English and Swedish responses with voice matching

**Philosophy:**
Based on [Daniel Miessler's Kai](https://github.com/danielmiessler/Personal_AI_Infrastructure):
- **System > Model** - Architecture matters more than the AI
- **Text as Thought** - Markdown for knowledge storage
- **Build Once** - Reusable solutions
- **Context is King** - Right info at right time

---

## HOW

### Verify Development Environment

```bash
# Check Bun is installed
bun --version  # Should be >=1.0.0

# Verify TypeScript hooks compile
cd .claude/hooks
bun install
bun run type-check

# Run linter
bun run lint

# Run tests (if available)
bun test
```

### Development Workflow

**Working on Hooks:**
```bash
cd .claude/hooks
# Edit TypeScript files
bun run type-check  # Verify types
bun run lint        # Check code style
```

**Working on Skills:**
```bash
cd .claude/skills
# Follow skill template structure:
# skill-name/
# ├── skill.md              # Skill definition
# ├── system-prompt.md      # Custom instructions
# └── examples/             # Usage examples
```

**Working on Context:**
```bash
# Context files are markdown - edit freely
# Follow progressive disclosure:
# - Tier 1: Metadata (<5KB)
# - Tier 2: Architecture (10-50KB)
# - Tier 3: Deep dive (50KB+)
```

### Installation (For Users)

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/ogmios.git
cd ogmios

# Install to home directory
cp -r .claude/ ~/.claude/

# Install hook dependencies
cd ~/.claude/.claude/hooks
bun install

# Customize configuration
cd ~/.claude/.claude
nano PAI.md  # Replace <PLACEHOLDERS> with your info

# Start Claude Code
claude
```

### File Boundaries

**Safe to Edit:**
- `.claude/hooks/*.ts` - TypeScript automation (follow type checking)
- `.claude/skills/*/skill.md` - Skill definitions (follow template)
- `.claude/context/**/*.md` - Context files (user-editable)
- `.claude/PAI.md` - Main configuration (user-specific)
- `.claude/documentation/**/*.md` - Documentation improvements

**Edit with Caution:**
- `.claude/settings.json` - Hook configurations (JSON syntax required)
- `.claude/hooks/package.json` - Dependencies (validate with bun)
- `.claude/SKILLS-INDEX.md` - Skill registry (auto-generated preferred)

**Do Not Edit:**
- `.claude/hooks/lib/` - Shared utilities (affects all hooks)
- `.claude/context/UFC.md` - System documentation (affects behavior)

### Testing Changes

**Before Committing:**
```bash
# Type check TypeScript
cd .claude/hooks && bun run type-check

# Lint code
bun run lint

# Format files
bun run format

# Test in clean environment (optional)
# 1. Backup current ~/.claude/
# 2. Install modified version
# 3. Start Claude Code and verify behavior
# 4. Restore backup
```

### Common Tasks

**Add a New Skill:**
1. Create directory: `.claude/skills/your-skill-name/`
2. Copy template from existing skill
3. Define `skill.md` with intent patterns
4. Add to `.claude/SKILLS-INDEX.md`
5. Test activation with matching user prompts

**Add a New Hook:**
1. Create `.claude/hooks/your-hook-name.ts`
2. Export default function matching hook signature
3. Add to `.claude/settings.json` hooks configuration
4. Run `bun run type-check`
5. Test with Claude Code

**Update Documentation:**
1. Edit files in `.claude/documentation/`
2. Follow existing structure (numbered sections)
3. Maintain bilingual parity (English + Swedish)
4. Link from relevant context files

---

## Security

**CRITICAL:** This repository contains configuration for a PERSONAL AI system.

**Before Any Git Operation:**
```bash
# Verify remote 3 times
git remote -v
git remote -v
git remote -v

# Ensure you're NOT pushing to public repos with personal data
```

**Never Commit:**
- API keys (use `.env` files, gitignored)
- Personal information in `PAI.md`
- Project-specific contexts with sensitive data
- `.mcp.json` with credentials

**Safe to Commit:**
- Template files
- Hook implementations (no secrets)
- Generic skill definitions
- Documentation
- Example configurations

---

## Quick Reference

**Need to:**
- Understand system architecture → `.claude/documentation/03-architecture/overview.md`
- See all available skills → `.claude/SKILLS-INDEX.md`
- Learn about context system → `.claude/context/UFC.md`
- Troubleshoot issues → `.claude/documentation/08-faq/troubleshooting.md`
- Add bilingual support → `.claude/documentation/06-bilingual/`

**Hooks Location:** `~/.claude/.claude/hooks/` (for installed system)
**Development Location:** `./claude/hooks/` (this repository)

---

## Philosophy

> "System > Model" - The architecture matters more than which AI you use.

Ogmios proves this by showing that Claude Code with the right:
- Context (UFC system)
- Specialists (Skills)
- Automation (Hooks)

...becomes exponentially more powerful than vanilla Claude.

---

**Built for:** Contributors developing the Ogmios system
**Inspired by:** [Daniel Miessler's Kai](https://github.com/danielmiessler/Personal_AI_Infrastructure)
**License:** MIT
