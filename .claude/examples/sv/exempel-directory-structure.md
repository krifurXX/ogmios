# Exempel: .claude Directory Structure

**Språk:** 🇸🇪 Svenska | [🇬🇧 English](../en/example-directory-structure.md)

---

## Komplett Katalogstruktur

Detta visar en fullständig `.claude/.claude/` struktur med alla komponenter:

```
~/.claude/.claude/
├── PAI.md                          # Kärnidentitet (läses vid session start)
│
├── settings.json                   # Global konfiguration
├── .mcp.json                       # MCP servers (GITIGNORE!)
├── .env                            # Environment variables (GITIGNORE!)
│
├── context/                        # UFC (Universal File-based Context)
│   ├── UFC.md                      # UFC system overview
│   │
│   ├── projects/                   # Projekt-specifika contexts
│   │   ├── mitt-projekt-tier1.md   # Metadata (<5KB)
│   │   ├── mitt-projekt-tier2.md   # Arkitektur (10-50KB)
│   │   ├── mitt-projekt-tier3.md   # Deep dive (50KB+)
│   │   └── annat-projekt.md
│   │
│   ├── technical/                  # Tekniska contexts
│   │   ├── api-design.md
│   │   ├── database-schema.md
│   │   ├── security-practices.md
│   │   └── deployment-checklist.md
│   │
│   ├── memory/                     # Långtidsminne
│   │   ├── decisions.md            # ADRs (Architecture Decision Records)
│   │   ├── learnings.md            # Lärdomar
│   │   ├── patterns.md             # Återkommande mönster
│   │   └── mistakes.md             # Misstag att undvika
│   │
│   ├── languages/                  # Språk-specifika contexts
│   │   ├── bilingual.md            # Tvåspråkig operation
│   │   ├── svenska.md              # Svensk kontext
│   │   └── english.md              # Engelsk kontext
│   │
│   └── tools/                      # Verktygsspecifika contexts
│       ├── mcps.md                 # MCP servers overview
│       ├── zotero.md               # Zotero integration
│       └── n8n.md                  # n8n workflows
│
├── skills/                         # Skills System (Specialized AI Assistants)
│   ├── SKILLS-INDEX.md             # Översikt över alla skills
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
│   ├── session-start.ts            # Ladda PAI.md vid session start
│   ├── load-ufc-context.ts         # UserPromptSubmit: Ladda UFC context
│   ├── skill-activation.ts         # UserPromptSubmit: Aktivera skill
│   ├── stop-validation.ts          # Stop: Validera COMPLETED tag
│   ├── stop-voice.ts               # Stop: Trigga voice feedback
│   │
│   └── utils/                      # Hjälpfunktioner för hooks
│       ├── file-reader.ts
│       ├── intent-detection.ts
│       └── voice-trigger.ts
│
├── voice-server/                   # ElevenLabs voice integration (valfritt)
│   ├── server.py                   # Flask server för voice feedback
│   ├── requirements.txt            # Python dependencies
│   ├── .env                        # ElevenLabs API key (GITIGNORE!)
│   └── voices.json                 # Voice mapping
│
└── documentation/                  # Systemdokumentation
    ├── OGMIOS-DEVELOPMENT-PLAN.md  # Utvecklingsplan
    ├── architecture.md             # Systemarkitektur
    ├── voice-system.md             # Voice integration
    ├── ufc-guide.md                # UFC användningsguide
    └── troubleshooting.md          # Felsökning

---

# För projekt-specifik .claude/

Projekt:
/path/to/mitt-projekt/

├── .claude/
│   ├── CLAUDE.md                   # Projekts claude.md (UFC Layer 4)
│   ├── settings.local.json         # Projekt-specifika permissions
│   │
│   ├── .mcp.json                   # Projekt-specifika MCP servers
│   │
│   ├── agents/                     # Symlinks till globala agents
│   │   ├── engineer -> ~/.claude/.claude/agents/engineer
│   │   └── researcher -> ~/.claude/.claude/agents/researcher
│   │
│   └── context/                    # Projekt-specifik kontext
│       ├── project-overview.md
│       ├── api-docs.md
│       └── deployment.md
│
├── .gitignore                      # MÅSTE inkludera .claude/.mcp.json
└── [projektfiler...]

```

---

## Filstorlekar (Approximativt)

```
PAI.md                          ~5-10KB   (kärnidentitet)
UFC.md                          ~3-5KB    (översikt)

context/projects/*-tier1.md     <5KB      (metadata)
context/projects/*-tier2.md     10-50KB   (arkitektur)
context/projects/*-tier3.md     50KB+     (deep dive)

skills/*/SKILL.md               ~2-5KB    (skill definition)
skills/*/tier1.md               ~2KB      (quick ref)
skills/*/tier2.md               ~5-10KB   (practices)
skills/*/tier3.md               ~10-20KB  (deep knowledge)

hooks/*.ts                      ~1-3KB    (per hook)

Total system size:              ~100-500KB (med alla components)
```

---

## Git Repository Structure

**Globalt PAI Repository (Privat):**
```
~/.claude/.claude/
├── .git/                       # Git repository
├── .gitignore                  # Ignorera känslig data
├── PAI.md
├── context/
├── skills/
├── hooks/
└── documentation/
```

**.gitignore för PAI:**
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

# Personal data (lägg till efter behov)
context/private/
context/contacts/
```

---

## Initialisera Strukturen

### Med Script (Rekommenderat)

```bash
#!/bin/bash
# init-pai.sh

PAI_DIR="$HOME/.claude/.claude"

# Skapa huvuddirektories
mkdir -p "$PAI_DIR"/{context,skills,hooks,voice-server,documentation}
mkdir -p "$PAI_DIR"/context/{projects,technical,memory,languages,tools}

# Skapa template-filer
touch "$PAI_DIR"/PAI.md
touch "$PAI_DIR"/context/UFC.md
touch "$PAI_DIR"/context/memory/{decisions,learnings,patterns,mistakes}.md

# Skapa hooks setup
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

# Initiera git (valfritt)
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

Kör:
```bash
chmod +x init-pai.sh
./init-pai.sh
```

---

## Bästa Praxis

### 1. Håll Det Organiserat
- En fil per koncept
- Tydliga filnamn (`projekt-tier1.md` inte `p1.md`)
- Konsekvent structure i alla projekt

### 2. Nesting Limit
- Max 3 nivåer djup i context/
- Exempel: `context/projects/subproject/` är OK
- `context/a/b/c/d/` är för djupt

### 3. Symlinks för Återanvändning
- Globala skills i `~/.claude/.claude/skills/`
- Projekt-specifika symlinks i `.claude/agents/`
- Samma för ofta använda contexts

### 4. Separation of Concerns
- **Global PAI:** Kärnidentitet, återanvändbara skills
- **Projekt .claude/:** Projekt-specifik kontext
- **Version control:** Privat för PAI, publikt för projekt (men gitignore .mcp.json!)

---

## Nästa Steg

Efter att ha skapat strukturen:

1. **Fyll i PAI.md** - Din kärnidentitet
2. **Skapa första skill** - Börja med engineering eller research
3. **Konfigurera hooks** - Session start och UFC loading
4. **Lägg till contexts** - Skapa ditt första projekt-context
5. **(Valfritt) Aktivera voice** - ElevenLabs integration

---

**Relaterad Dokumentation:**
- [Installation Guide](../../docs/06-bilingual/svenska/installation.md)
- [UFC System](../../sv/03-UFC-SYSTEMET.md)
- [Skills System](../../sv/04-SKILLS-SYSTEMET.md)
- [Hooks & Automation](../../docs/06-bilingual/svenska/hooks-automation.md)
