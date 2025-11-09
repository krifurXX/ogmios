# Example: .claude Directory Structure

**Language:** [🇸🇪 Svenska](../sv/exempel-directory-structure.md) | 🇬🇧 English

---

## Complete Directory Structure

This shows a complete `.claude/.claude/` structure with all components:

```
~/.claude/.claude/
├── PAI.md                          # Core identity (read at session start)
│
├── settings.json                   # Global configuration
├── .mcp.json                       # MCP servers (GITIGNORE!)
├── .env                            # Environment variables (GITIGNORE!)
│
├── context/                        # UFC (Universal File-based Context)
│   ├── UFC.md                      # UFC system overview
│   │
│   ├── projects/                   # Project-specific contexts
│   │   ├── my-project-tier1.md     # Metadata (<5KB)
│   │   ├── my-project-tier2.md     # Architecture (10-50KB)
│   │   ├── my-project-tier3.md     # Deep dive (50KB+)
│   │   └── other-project.md
│   │
│   ├── technical/                  # Technical contexts
│   │   ├── api-design.md
│   │   ├── database-schema.md
│   │   ├── security-practices.md
│   │   └── deployment-checklist.md
│   │
│   ├── memory/                     # Long-term memory
│   │   ├── decisions.md            # ADRs (Architecture Decision Records)
│   │   ├── learnings.md            # Lessons learned
│   │   ├── patterns.md             # Recurring patterns
│   │   └── mistakes.md             # Mistakes to avoid
│   │
│   ├── languages/                  # Language-specific contexts
│   │   ├── bilingual.md            # Bilingual operation
│   │   ├── svenska.md              # Swedish context
│   │   └── english.md              # English context
│   │
│   └── tools/                      # Tool-specific contexts
│       ├── mcps.md                 # MCP servers overview
│       ├── zotero.md               # Zotero integration
│       └── n8n.md                  # n8n workflows
│
├── skills/                         # Skills System (Specialized AI Assistants)
│   ├── SKILLS-INDEX.md             # Overview of all skills
│   │
│   ├── engineering/                # George Foster - Software Engineering
│   │   ├── SKILL.md                # Skill definition
│   │   ├── tier1.md                # Quick reference
│   │   ├── tier2.md                # Best practices
│   │   └── tier3.md                # Deep technical knowledge
│   │
│   ├── research/                   # Dr. Alice Mitchell - Academic Research
│   │   ├── SKILL.md
│   │   ├── tier1.md
│   │   ├── tier2.md
│   │   └── tier3.md
│   │
│   ├── architecture/               # Dr. Emma Roberts - System Architecture
│   │   ├── SKILL.md
│   │   ├── tier1.md
│   │   ├── tier2.md
│   │   └── tier3.md
│   │
│   ├── testing/                    # Marcus Thompson - QA & Testing
│   │   └── SKILL.md
│   │
│   └── swedish/                    # Prof. Lars Bergström - Swedish Academic
│       └── SKILL.md
│
├── hooks/                          # Event-driven automation
│   ├── package.json                # Bun dependencies
│   ├── tsconfig.json               # TypeScript configuration
│   │
│   ├── session-start.ts            # Load PAI.md at session start
│   ├── load-ufc-context.ts         # UserPromptSubmit: Load UFC context
│   ├── skill-activation.ts         # UserPromptSubmit: Activate skill
│   ├── stop-validation.ts          # Stop: Validate COMPLETED tag
│   ├── stop-voice.ts               # Stop: Trigger voice feedback
│   │
│   └── utils/                      # Helper functions for hooks
│       ├── file-reader.ts
│       ├── intent-detection.ts
│       └── voice-trigger.ts
│
├── voice-server/                   # ElevenLabs voice integration (optional)
│   ├── server.py                   # Flask server for voice feedback
│   ├── requirements.txt            # Python dependencies
│   ├── .env                        # ElevenLabs API key (GITIGNORE!)
│   └── voices.json                 # Voice mapping
│
└── documentation/                  # System documentation
    ├── OGMIOS-DEVELOPMENT-PLAN.md  # Development plan
    ├── architecture.md             # System architecture
    ├── voice-system.md             # Voice integration
    ├── ufc-guide.md                # UFC usage guide
    └── troubleshooting.md          # Troubleshooting

---

# For project-specific .claude/

Project:
/path/to/my-project/

├── .claude/
│   ├── CLAUDE.md                   # Project's claude.md (UFC Layer 4)
│   ├── settings.local.json         # Project-specific permissions
│   │
│   ├── .mcp.json                   # Project-specific MCP servers
│   │
│   ├── agents/                     # Symlinks to global agents
│   │   ├── engineer -> ~/.claude/.claude/agents/engineer
│   │   └── researcher -> ~/.claude/.claude/agents/researcher
│   │
│   └── context/                    # Project-specific context
│       ├── project-overview.md
│       ├── api-docs.md
│       └── deployment.md
│
├── .gitignore                      # MUST include .claude/.mcp.json
└── [project files...]

```

---

## File Sizes (Approximate)

```
PAI.md                          ~5-10KB   (core identity)
UFC.md                          ~3-5KB    (overview)

context/projects/*-tier1.md     <5KB      (metadata)
context/projects/*-tier2.md     10-50KB   (architecture)
context/projects/*-tier3.md     50KB+     (deep dive)

skills/*/SKILL.md               ~2-5KB    (skill definition)
skills/*/tier1.md               ~2KB      (quick ref)
skills/*/tier2.md               ~5-10KB   (practices)
skills/*/tier3.md               ~10-20KB  (deep knowledge)

hooks/*.ts                      ~1-3KB    (per hook)

Total system size:              ~100-500KB (with all components)
```

---

## Git Repository Structure

**Global PAI Repository (Private):**
```
~/.claude/.claude/
├── .git/                       # Git repository
├── .gitignore                  # Ignore sensitive data
├── PAI.md
├── context/
├── skills/
├── hooks/
└── documentation/
```

**.gitignore for PAI:**
```gitignore
# Credentials & Secrets
.mcp.json
.env
.env.local
voice-server/.env

# Node modules
node_modules/
hooks/node_modules/

# Logs
*.log
logs/

# OS files
.DS_Store
Thumbs.db

# Personal data (add as needed)
context/private/
context/contacts/
```

---

## Initialize Structure

### With Script (Recommended)

```bash
#!/bin/bash
# init-pai.sh

PAI_DIR="$HOME/.claude/.claude"

# Create main directories
mkdir -p "$PAI_DIR"/{context,skills,hooks,voice-server,documentation}
mkdir -p "$PAI_DIR"/context/{projects,technical,memory,languages,tools}

# Create template files
touch "$PAI_DIR"/PAI.md
touch "$PAI_DIR"/context/UFC.md
touch "$PAI_DIR"/context/memory/{decisions,learnings,patterns,mistakes}.md

# Create hooks setup
cd "$PAI_DIR"/hooks
cat > package.json <<EOF
{
  "name": "pai-hooks",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "bun run --watch"
  },
  "dependencies": {
    "@types/node": "^20.0.0"
  }
}
EOF

bun install

# Initialize git (optional)
cd "$PAI_DIR"
git init
cat > .gitignore <<EOF
.mcp.json
.env
.env.local
node_modules/
*.log
EOF

echo "✅ PAI structure initialized at $PAI_DIR"
```

Run:
```bash
chmod +x init-pai.sh
./init-pai.sh
```

---

## Best Practices

### 1. Keep It Organized
- One file per concept
- Clear filenames (`project-tier1.md` not `p1.md`)
- Consistent structure across all projects

### 2. Nesting Limit
- Max 3 levels deep in context/
- Example: `context/projects/subproject/` is OK
- `context/a/b/c/d/` is too deep

### 3. Symlinks for Reuse
- Global skills in `~/.claude/.claude/skills/`
- Project-specific symlinks in `.claude/agents/`
- Same for frequently used contexts

### 4. Separation of Concerns
- **Global PAI:** Core identity, reusable skills
- **Project .claude/:** Project-specific context
- **Version control:** Private for PAI, public for project (but gitignore .mcp.json!)

---

## Next Steps

After creating the structure:

1. **Fill in PAI.md** - Your core identity
2. **Create first skill** - Start with engineering or research
3. **Configure hooks** - Session start and UFC loading
4. **Add contexts** - Create your first project context
5. **(Optional) Enable voice** - ElevenLabs integration

---

**Related Documentation:**
- [Installation Guide](../../docs/01-getting-started/installation.md)
- [UFC System](../../docs/02-core-concepts/ufc-context.md)
- [Skills System](../../docs/02-core-concepts/skills.md)
- [Hooks & Automation](../../docs/02-core-concepts/hooks.md)
