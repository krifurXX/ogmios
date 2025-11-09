# Installationsguide - Ogmios PAI

[🇬🇧 English](../docs/01-getting-started/installation.md) | [🇸🇪 Svenska](08-INSTALLATION.md)

---

## 📋 Innehållsförteckning

1. [Innan du börjar](#-innan-du-börjar)
2. [Förutsättningar](#-förutsättningar)
3. [Snabbinstallation](#-snabbinstallation)
4. [Detaljerad installation](#-detaljerad-installation)
5. [Konfiguration](#%EF%B8%8F-konfiguration)
6. [Verifiering](#-verifiering)
7. [Felsökning](#-felsökning)
8. [Avancerad konfiguration](#-avancerad-konfiguration)
9. [Uppgradering](#-uppgradering)
10. [Nästa steg](#-nästa-steg)

---

## 🎯 Innan du börjar

### Vad du kommer installera

Ogmios PAI är ett **Personal AI Infrastructure** som lägger till kraftfulla funktioner till Claude Code:

- **UFC-systemet** - Unified Function Context för intelligent kontexthantering
- **Skills-systemet** - Specialiserade AI-personligheter för olika uppgifter
- **Hooks-systemet** - Automation och arbetsflödesförbättringar
- **Flerspråksstöd** - Sömlös svenska/engelska
- **Voice System** - Röstfeedback med ElevenLabs (valfritt)
- **MCP Integration** - Anslutningar till externa tjänster (valfritt)

### Installationstid

- **Grundläggande installation:** 10-15 minuter
- **Med röstfeedback:** +5 minuter
- **Med MCP-servrar:** +10 minuter per tjänst

### Förkunskaper

- Grundläggande användning av terminal/kommandorad
- Grundläggande textfilredigering
- (Valfritt) Git för att klona repository

**Nybörjarvänlig:** Den här guiden antar **inga** förkunskaper om Claude Code. Allt förklaras steg för steg.

---

## ✅ Förutsättningar

### 1. Verifiera Claude Code

**Kontrollera om Claude Code är installerat:**

```bash
claude --version
```

**Förväntat resultat:**
```
Claude Code version X.X.X
```

**Om kommandot inte hittas:**

Claude Code är **INTE** installerat. Du måste installera det först:

1. Gå till [https://claude.ai/download](https://claude.ai/download)
2. Ladda ner för ditt operativsystem (macOS/Linux/Windows)
3. Följ installationsinstruktionerna
4. Starta om din terminal
5. Kör `claude --version` igen

**Officiell dokumentation:** [Claude Code Documentation](https://docs.claude.ai/code)

### 2. Systemkrav

**Operativsystem:**
- macOS 11+ (rekommenderat)
- Linux (Ubuntu 20.04+, Debian 11+)
- Windows 10+ med WSL2 (begränsat testat)

**Runtime:**
- **Node.js** 18+ ELLER **Bun** (rekommenderat)

**Kontrollera Node.js:**
```bash
node --version
```

Bör visa: `v18.0.0` eller högre

**Om Node.js saknas:**
```bash
# macOS med Homebrew:
brew install node

# Ubuntu/Debian:
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**Installera Bun (rekommenderat):**
```bash
curl -fsSL https://bun.sh/install | bash

# Verifiera:
bun --version
```

### 3. Git (för att klona repository)

**Kontrollera Git:**
```bash
git --version
```

**Om Git saknas:**
```bash
# macOS:
brew install git

# Ubuntu/Debian:
sudo apt-get install git
```

### 4. Valfria förutsättningar

**För röstfeedback (ElevenLabs):**
- ElevenLabs-konto ([https://elevenlabs.io](https://elevenlabs.io))
- API-nyckel (gratis tier tillgänglig)

**För Obsidian-integration:**
- Obsidian ([https://obsidian.md](https://obsidian.md))

**För MCP-servrar:**
- Specifika API-nycklar för varje tjänst (GitHub, Slack, etc.)

---

## 🚀 Snabbinstallation

**Perfekt för:** Snabb uppsättning, grundläggande funktioner, inga röster/MCP

**Tidsåtgång:** ~5 minuter

### Steg 1: Ladda ner Ogmios

**Alternativ A: Med Git (rekommenderat)**
```bash
# Klona repository till lämplig plats
cd ~/Downloads  # eller valfri plats
git clone https://github.com/your-username/ogmios-pai.git
cd ogmios-pai
```

**Alternativ B: Ladda ner ZIP**
1. Gå till GitHub-repository
2. Klicka "Code" → "Download ZIP"
3. Packa upp ZIP-filen
4. Öppna terminal i mappen

### Steg 2: Kopiera till Claude-katalog

```bash
# Skapa PAI-katalog om den inte finns
mkdir -p ~/.claude/.claude

# Säkerhetskopiera befintlig konfiguration (om du har någon)
if [ -f ~/.claude/settings.json ]; then
  cp ~/.claude/settings.json ~/.claude/settings.json.backup
  echo "✅ Backupade settings.json"
fi

# Kopiera Ogmios-templates
cp -r templates/context ~/.claude/.claude/
cp -r templates/skills ~/.claude/.claude/
cp -r templates/hooks ~/.claude/.claude/
cp templates/PAI.md ~/.claude/.claude/
cp templates/SKILLS-INDEX.md ~/.claude/.claude/
cp templates/settings.json ~/.claude/settings.json

echo "✅ Ogmios-filer kopierade"
```

**Vad kopierades:**
- `context/` - UFC-kontextfiler
- `skills/` - Specialiserade AI-personligheter
- `hooks/` - Automation-scripts
- `PAI.md` - Din kärnidentitet
- `SKILLS-INDEX.md` - Skills-katalog
- `settings.json` - Claude Code-konfiguration

### Steg 3: Anpassa PAI.md

```bash
# Öppna i din favoriteditor
nano ~/.claude/.claude/PAI.md
# eller: vim, code, subl, etc.
```

**Minimala ändringar (obligatoriskt):**

Hitta och ändra:
```markdown
## Core Identity
Your Name: <YOUR_NAME>  # ← ÄNDRA DETTA
Your Timezone: Europe/Stockholm  # ← ÄNDRA DETTA
```

**Rekommenderade ändringar:**

```markdown
## Essential Contacts
- Partner: name@email.com  # ← LÄGG TILL DINA KONTAKTER
- Team Lead: name@email.com

## Core Stack Preferences
- Primary Language: TypeScript  # ← DINA PREFERENSER
- Package managers: bun
```

**Spara och stäng** (Ctrl+X i nano, :wq i vim)

### Steg 4: Installera hook-dependencies

```bash
cd ~/.claude/.claude/hooks

# Med Bun (rekommenderat):
bun install

# ELLER med npm:
npm install
```

**Förväntat resultat:**
```
bun install v1.x.x
Installing dependencies...
✓ Installed 5 packages
```

### Steg 5: Första testen

```bash
# Starta Claude Code
claude
```

**I Claude-prompten, testa:**

```
What's my name according to PAI.md?
```

**Förväntat svar:**
```
According to your PAI configuration, your name is [DITT NAMN].
```

**Grattis!** Grundläggande installation klar! ✅

---

## 🔧 Detaljerad installation

**Perfekt för:** Fullständig kontroll, förståelse av varje steg, felsökning

### Steg 1: Förbered Claude-katalog

**Förstå katalogstrukturen:**

Claude Code använder:
- `~/.claude/settings.json` - Global konfiguration
- `~/.claude/.claude/` - Ogmios PAI-system (vår konvention)

**Skapa strukturen:**

```bash
# Gå till hem-katalogen
cd ~

# Skapa Claude-katalog
mkdir -p .claude

# Skapa PAI-underkatalog
mkdir -p .claude/.claude

# Verifiera:
ls -la .claude/
```

**Förväntat resultat:**
```
drwxr-xr-x  .claude/
```

### Steg 2: Ladda ner Ogmios (detaljerat)

**Med Git (rekommenderat):**

```bash
# Bestäm var du vill klona (temporärt läge)
cd ~/Downloads

# Klona repository
git clone https://github.com/your-username/ogmios-pai.git

# Gå in i katalogen
cd ogmios-pai

# Verifiera innehållet
ls -la
```

**Du bör se:**
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

**Utan Git (manuell nedladdning):**

1. Besök GitHub-repository i webbläsare
2. Klicka på grön "Code"-knapp
3. Välj "Download ZIP"
4. Spara till `~/Downloads/`
5. Packa upp:
   ```bash
   cd ~/Downloads
   unzip ogmios-pai-main.zip
   cd ogmios-pai-main
   ```

### Steg 3: Säkerhetskopiera befintlig konfiguration

**VIKTIGT:** Om du redan använder Claude Code, säkerhetskopiera först!

```bash
# Kontrollera om du har befintlig settings.json
if [ -f ~/.claude/settings.json ]; then
  echo "⚠️  Befintlig settings.json hittad!"

  # Säkerhetskopiera med timestamp
  cp ~/.claude/settings.json ~/.claude/settings.json.backup-$(date +%Y%m%d-%H%M%S)

  echo "✅ Backup skapad i ~/.claude/settings.json.backup-[timestamp]"
else
  echo "✅ Ingen befintlig konfiguration - redo för ny installation"
fi

# Säkerhetskopiera befintlig .claude/ katalog om den finns
if [ -d ~/.claude/.claude ]; then
  echo "⚠️  Befintlig PAI-installation hittad!"
  mv ~/.claude/.claude ~/.claude/.claude.backup-$(date +%Y%m%d-%H%M%S)
  echo "✅ Backup skapad"
fi
```

### Steg 4: Kopiera filer (detaljerat)

**Förstå vad som kopieras:**

```bash
# Från ogmios-pai-mappen:
cd ~/Downloads/ogmios-pai  # eller din nedladdningsplats

# Kopiera context-systemet
cp -r templates/context ~/.claude/.claude/
# Detta ger dig: UFC.md, tools/, projects/, preferences/, memory/, languages/

# Kopiera skills-systemet
cp -r templates/skills ~/.claude/.claude/
# Detta ger dig: CORE/, engineering/, architecture/, research/, etc.

# Kopiera hooks-systemet
cp -r templates/hooks ~/.claude/.claude/
# Detta ger dig: load-ufc-context.ts, skill-activation-enforcer.ts, etc.

# Kopiera kärnfiler
cp templates/PAI.md ~/.claude/.claude/
cp templates/SKILLS-INDEX.md ~/.claude/.claude/

# Kopiera settings.json
cp templates/settings.json ~/.claude/settings.json
```

**Verifiera kopiering:**

```bash
# Kontrollera att allt finns
ls -la ~/.claude/.claude/

# Du bör se:
# PAI.md
# SKILLS-INDEX.md
# context/
# skills/
# hooks/

# Kontrollera settings.json
ls -la ~/.claude/settings.json
```

### Steg 5: Installera dependencies (detaljerat)

**Förstå hook-dependencies:**

Hooks är TypeScript-filer som kör automation. De behöver dependencies som:
- `zx` - För shellkommandon i TypeScript
- `yaml` - För att läsa skill-metadata
- (andra enligt package.json)

**Installation:**

```bash
# Gå till hooks-katalog
cd ~/.claude/.claude/hooks

# Verifiera att package.json finns
ls -la package.json

# Installera med Bun (rekommenderat):
bun install

# ELLER med npm:
npm install

# ELLER med yarn:
yarn install
```

**Förväntat resultat (Bun):**
```
bun install v1.x.x (Linux x64)
Resolving dependencies...
  + zx
  + yaml
  + [andra packages]

✓ Installed 5 packages [1.2s]
```

**Verifiera installation:**
```bash
ls -la node_modules/
# Du bör se: zx/, yaml/, etc.
```

### Steg 6: Konfigurera permissions (macOS/Linux)

```bash
# Gör hooks executables
chmod +x ~/.claude/.claude/hooks/*.ts

# Verifiera:
ls -la ~/.claude/.claude/hooks/
```

**Förväntat resultat:**
```
-rwxr-xr-x  load-ufc-context.ts
-rwxr-xr-x  skill-activation-enforcer.ts
-rwxr-xr-x  completion-validator.ts
```

Notera `x` i permissions (executable).

---

## ⚙️ Konfiguration

### 1. Anpassa PAI.md (Grundläggande identitet)

**Öppna filen:**
```bash
nano ~/.claude/.claude/PAI.md
# eller din favoriteditor: vim, code, subl
```

**Obligatoriska ändringar:**

```markdown
## Core Identity
Your Name: [DITT FULLSTÄNDIGA NAMN]
Your Timezone: [DIN TIDSZON, t.ex. Europe/Stockholm]
Your Location: [STAD, LAND]

## Essential Contacts
- [Kontaktnamn 1]: email@example.com
- [Kontaktnamn 2]: email@example.com
```

**Rekommenderade anpassningar:**

```markdown
## Core Stack Preferences

### Package Managers
- JavaScript/TypeScript: bun (NOT npm, yarn, pnpm)  # ÄNDRA EFTER PREFERENS
- Python: uv (NOT pip)  # ÄNDRA EFTER PREFERENS

### Primary Languages
1. TypeScript  # ÄNDRA ORDNING EFTER PREFERENS
2. Python
3. Go

### Frameworks
- Backend: [DINA VAL]
- Frontend: [DINA VAL]
- Database: [DINA VAL]

## Work Environment
- OS: macOS  # ELLER Linux/Windows
- Shell: zsh  # ELLER bash/fish
- Editor: NeoVim  # ELLER VSCode/etc.
```

**Spara ändringar** (Ctrl+X → Y → Enter i nano)

### 2. Konfigurera UFC Context-filer

**a) Tech Stack Preferences**

```bash
nano ~/.claude/.claude/context/preferences/stack.md
```

**Anpassa till dina verkliga preferenser:**

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

**Spara ändringar**

**b) Create Project Context**

```bash
# Skapa context för ditt huvudprojekt
nano ~/.claude/.claude/context/projects/my-project.md
```

**Mall:**

```markdown
# [Projektnamn]

## Overview
[Kort beskrivning av projektet]

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

**Spara ändringar**

**c) Language Preferences (Flerspråk)**

```bash
nano ~/.claude/.claude/context/languages/bilingual.md
```

**Om du är tvåspråkig (svenska/engelska):**

Filen bör redan innehålla bra inställningar. Verifiera:

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

**Om du bara använder engelska:**

Ändra till:

```markdown
# Language Preference: English Only

## Response Language
Always respond in English.
```

### 3. Konfigurera Hooks i settings.json

**Öppna settings.json:**
```bash
nano ~/.claude/settings.json
```

**Verifiera att hooks är konfigurerade:**

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

**Viktiga detaljer:**
- `${HOME}` expanderas till din hem-katalog
- `bun` kan ersättas med `node` om du inte använder Bun
- Hooks körs i ordning (viktigt för UserPromptSubmit)

**Validera JSON-syntax:**
```bash
cat ~/.claude/settings.json | jq .
```

Om kommandot ger fel: syntaxfel i JSON. Korrigera innan du fortsätter.

### 4. Skapa egna Skills (Valfritt)

**Exempel: Skapa "database-expert" skill:**

```bash
# Skapa skill-katalog
mkdir -p ~/.claude/.claude/skills/database-expert

# Skapa SKILL.md
nano ~/.claude/.claude/skills/database-expert/SKILL.md
```

**Innehåll:**

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

**Registrera i SKILLS-INDEX.md:**

```bash
nano ~/.claude/.claude/SKILLS-INDEX.md
```

**Lägg till:**

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

## ✅ Verifiering

### Checklist

Använd denna checklista för att verifiera att allt är korrekt installerat:

```bash
# Kör detta script för att verifiera installation:

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

**Spara som:** `~/.claude/.claude/verify-installation.sh`

**Kör:**
```bash
chmod +x ~/.claude/.claude/verify-installation.sh
~/.claude/.claude/verify-installation.sh
```

### Manuella tester

**Test 1: Kontextladdning (UFC)**

```bash
# Starta Claude Code
claude
```

I Claude-prompten:
```
What are my technology stack preferences?
```

**Förväntat svar:**
```
Based on your PAI configuration in context/preferences/stack.md:

- Primary Language: TypeScript
- Package Manager: bun (NOT npm/yarn/pnpm)
- Python: uv (NOT pip)
[...]
```

**Om fel:**
- Kontrollera att `context/preferences/stack.md` finns
- Kontrollera att `load-ufc-context.ts` hook är aktiverad
- Se felsökningssektion

**Test 2: Skill-aktivering**

I Claude-prompten:
```
Implement a function to check if a number is prime
```

**Förväntat svar:**
```
✅ Skill activated: engineering (George Foster - American English)

[implementering följer...]
```

**Om fel:**
- Kontrollera att `skills/engineering/` finns
- Kontrollera att `skill-activation-enforcer.ts` hook är aktiverad
- Se felsökningssektion

**Test 3: Flerspråkighet (om konfigurerad)**

I Claude-prompten (på svenska):
```
Skapa en funktion för att sortera en lista
```

**Förväntat svar (på svenska):**
```
✅ Skill aktiverad: engineering (George Foster - Amerikansk engelska)

Här är en funktion för att sortera en lista:
[...]
```

**Test 4: Completion Validator**

Varje svar bör avslutas med:
```
🎯 COMPLETED: [task description]
```

Om detta saknas: `completion-validator.ts` hook fungerar inte korrekt.

---

## 🐛 Felsökning

### Problem: "Command not found: claude"

**Diagnos:**
Claude Code är inte installerat eller inte i PATH.

**Lösning:**

1. **Installera Claude Code:**
   ```bash
   # Besök: https://claude.ai/download
   # Följ installationsinstruktioner för ditt OS
   ```

2. **Lägg till i PATH (om installerat men inte hittas):**
   ```bash
   # Hitta Claude Code installation
   which claude

   # Om i /usr/local/bin eller ~/bin, lägg till i PATH:
   echo 'export PATH="$PATH:/path/to/claude"' >> ~/.bashrc  # eller ~/.zshrc
   source ~/.bashrc
   ```

3. **Starta om terminal**

### Problem: Hooks körs inte

**Diagnos:**
Ingen skill-aktivering, ingen kontextladdning, inga completion-meddelanden.

**Lösning:**

**Steg 1: Verifiera hooks är executables**
```bash
ls -la ~/.claude/.claude/hooks/

# Leta efter 'x' i permissions:
# -rwxr-xr-x (RÄTT)
# -rw-r--r-- (FEL - ej executable)
```

**Fixa permissions:**
```bash
chmod +x ~/.claude/.claude/hooks/*.ts
```

**Steg 2: Validera settings.json**
```bash
cat ~/.claude/settings.json | jq .
```

Om fel: syntaxproblem i JSON. Öppna och korrigera:
```bash
nano ~/.claude/settings.json
```

**Steg 3: Testa hook manuellt**
```bash
cd ~/.claude/.claude/hooks
bun load-ufc-context.ts
```

Om fel visas: åtgärda enligt felmeddelandet.

**Steg 4: Kontrollera hook-konfiguration**
```bash
nano ~/.claude/settings.json
```

Verifiera att hooks-sektionen finns och är korrekt:
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

### Problem: Context laddas inte

**Diagnos:**
Claude känner inte till dina preferenser från `context/`.

**Lösning:**

**Steg 1: Verifiera context-filer finns**
```bash
ls -la ~/.claude/.claude/context/

# Du bör se:
# UFC.md
# preferences/
# projects/
# tools/
# memory/
# languages/
```

**Steg 2: Kontrollera UFC.md**
```bash
cat ~/.claude/.claude/context/UFC.md | head -20
```

Bör innehålla UFC-systemdokumentation.

**Steg 3: Testa load-ufc-context hook direkt**
```bash
cd ~/.claude/.claude/hooks
bun load-ufc-context.ts --test
```

**Steg 4: Felsök hook-output**
```bash
# Lägg till debug-output i hook
nano ~/.claude/.claude/hooks/load-ufc-context.ts

// Lägg till i början av filen:
console.log("🔍 DEBUG: Hook started");
```

Kör igen och se om output visas.

### Problem: Skills aktiveras inte

**Diagnos:**
Ingen "✅ Skill activated" meddelande när du ber om hjälp.

**Lösning:**

**Steg 1: Verifiera skills-katalog**
```bash
ls -la ~/.claude/.claude/skills/

# Du bör se:
# CORE/
# engineering/
# architecture/
# research/
# [etc.]
```

**Steg 2: Kontrollera SKILLS-INDEX.md**
```bash
cat ~/.claude/.claude/SKILLS-INDEX.md
```

Bör lista alla skills med triggers.

**Steg 3: Verifiera trigger-ord**
```bash
cat ~/.claude/.claude/skills/engineering/SKILL.md | grep -A10 "triggers:"
```

**Steg 4: Testa skill-aktiverare manuellt**
```bash
cd ~/.claude/.claude/hooks
bun skill-activation-enforcer.ts
```

**Steg 5: Kontrollera YAML front-matter**

Öppna en skill-fil:
```bash
nano ~/.claude/.claude/skills/engineering/SKILL.md
```

Verifiera YAML:
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

**Vanligt fel:** Saknad `---` före eller efter YAML.

### Problem: Voice fungerar inte

**Diagnos:**
Ingen röstfeedback efter responses.

**Lösning:**

**Steg 1: Kontrollera API-nyckel**
```bash
# I settings.json:
cat ~/.claude/settings.json | grep ELEVENLABS_API_KEY
```

Bör visa:
```json
"ELEVENLABS_API_KEY": "sk_..."
```

**Steg 2: Testa API-nyckel**
```bash
curl -H "xi-api-key: YOUR_API_KEY" https://api.elevenlabs.io/v1/voices
```

Bör returnera lista med röster.

**Om "Unauthorized":** API-nyckel är ogiltig eller utgången.

**Steg 3: Verifiera voice-server (om du kör en)**
```bash
# Kontrollera om voice-server körs
ps aux | grep voice-server

# Starta om voice-server
cd ~/.claude/voice-server
bun run server.ts
```

**Steg 4: Kontrollera voice IDs i skills**
```bash
cat ~/.claude/.claude/skills/engineering/SKILL.md | grep voice_id
```

Bör visa:
```yaml
voice_id: abc123xyz
```

Verifiera att voice ID finns i ElevenLabs.

### Problem: Blandad språkigenkänning

**Diagnos:**
Claude svarar på fel språk (engelska när du skriver svenska).

**Lösning:**

**Steg 1: Kontrollera bilingual.md**
```bash
cat ~/.claude/.claude/context/languages/bilingual.md
```

Bör innehålla:
```markdown
## Response Language
**Rule:** Match the user's input language
```

**Steg 2: Testa explicit språkvalet**

I Claude:
```
[SV] Skriv en funktion för primtal
```

Prefix `[SV]` tvingar svenska.

**Steg 3: Kontrollera PAI.md language preference**
```bash
cat ~/.claude/.claude/PAI.md | grep -A5 "Language"
```

### Problem: Högt minnesutnyttjande

**Diagnos:**
Claude Code använder mycket RAM.

**Lösning:**

**Steg 1: Begränsa context-filstorlek**

Stora context-filer laddas in helt. Håll filer under 50KB var.

**Steg 2: Använd selektiv context-loading**

I `load-ufc-context.ts`, lägg till filtrering:
```typescript
// Ladda endast relevanta filer baserat på prompt
if (prompt.includes("database")) {
  loadContext("tools/database.md");
}
```

**Steg 3: Starta om Claude Code regelbundet**
```bash
# Avsluta session
exit

# Starta igen
claude
```

---

## 🎯 Avancerad konfiguration

### MCP Servers (Model Context Protocol)

**MCP låter Claude Code ansluta till externa tjänster.**

#### GitHub MCP Server

**Installation:**
```bash
claude mcp add --scope user github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=your_github_token \
  -- bunx -y @modelcontextprotocol/server-github
```

**Verifiering:**
```bash
claude mcp list
```

**Användning:**

I Claude:
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

**Se:** [MCP Integration Guide](07-MCP-INTEGRATION.md) för fullständig dokumentation.

### Voice Server (ElevenLabs)

**För avancerad rösthantering med lokal server:**

**Steg 1: Installera voice-server**
```bash
# Klona voice-server (om separat repo)
git clone https://github.com/your-username/ogmios-voice-server.git ~/.claude/voice-server

# Eller kopiera från templates/
cp -r templates/voice-server ~/.claude/
```

**Steg 2: Konfigurera**
```bash
cd ~/.claude/voice-server
cp .env.example .env
nano .env
```

**Innehåll:**
```bash
ELEVENLABS_API_KEY=sk_...
PORT=8888
```

**Steg 3: Installera dependencies**
```bash
bun install
```

**Steg 4: Starta server**
```bash
bun run server.ts

# ELLER som bakgrundsprocess:
bun run server.ts &
```

**Steg 5: Testa**
```bash
curl http://localhost:8888/health
```

**Förväntat:**
```json
{"status":"ok","voice_api":"connected"}
```

### Custom Hooks

**Skapa en custom hook:**

```bash
nano ~/.claude/.claude/hooks/my-custom-hook.ts
```

**Exempel: Logga alla prompts**

```typescript
#!/usr/bin/env bun

import { appendFileSync } from "fs";
import { join } from "path";

export default async function({ userMessage, context }) {
  const logFile = join(process.env.HOME, ".claude", "prompt-log.txt");
  const timestamp = new Date().toISOString();

  appendFileSync(logFile, `[${timestamp}] ${userMessage}\n`);

  // Returnera inget (ingen modifiering)
  return {};
}
```

**Registrera i settings.json:**
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

**Mer avancerat:** Se [Hooks & Automation](06-HOOKS-AUTOMATION.md)

---

## 🔄 Uppgradering

### Uppgradera Ogmios till ny version

**Steg 1: Säkerhetskopiera din konfiguration**
```bash
# Backup hela PAI-katalogen
cp -r ~/.claude/.claude ~/.claude/.claude.backup-$(date +%Y%m%d)

# Backup settings.json
cp ~/.claude/settings.json ~/.claude/settings.json.backup-$(date +%Y%m%d)
```

**Steg 2: Ladda ner ny version**
```bash
cd ~/Downloads/ogmios-pai
git pull origin main

# Eller ladda ner ny ZIP och packa upp
```

**Steg 3: Selective update (rekommenderat)**

**Uppdatera endast system-filer, inte dina anpassningar:**

```bash
# Uppdatera hooks (oftast säkert)
cp -r templates/hooks ~/.claude/.claude/

# Uppdatera skills (var försiktig om du ändrat)
# Kolla diff först:
diff -r ~/.claude/.claude/skills/engineering templates/skills/engineering

# Om inga konflikter:
cp -r templates/skills ~/.claude/.claude/

# UPPDATERA INTE: context/ (dina anpassningar), PAI.md (din identitet)
```

**Steg 4: Merge settings.json**

**Manuell merge (rekommenderat):**
```bash
# Öppna båda sida-vid-sida
diff ~/.claude/settings.json templates/settings.json

# Kopiera nya funktioner från templates/settings.json till ~/.claude/settings.json
nano ~/.claude/settings.json
```

**Steg 5: Återinstallera hook-dependencies (om package.json uppdaterades)**
```bash
cd ~/.claude/.claude/hooks
bun install
```

**Steg 6: Testa**
```bash
claude
# Kör verifieringstester från tidigare sektion
```

### Uppgradera Claude Code

```bash
# Kontrollera nuvarande version
claude --version

# Ladda ner senaste från https://claude.ai/download
# Installera enligt instruktioner

# Starta om terminal
# Verifiera ny version
claude --version
```

---

## 📚 Nästa steg

### Lär dig mer om systemet

- **[UFC-systemet](03-UFC-SYSTEMET.md)** - Hur kontexthantering fungerar
- **[Skills-systemet](04-SKILLS-SYSTEMET.md)** - Specialiserade AI-personligheter
- **[Hooks & Automation](06-HOOKS-AUTOMATION.md)** - Automation och custom workflows

### Utforska exempel

- **[Examples katalog](../examples/)** - Färdiga användn ingsfall
- **[Tutorials](../tutorials/)** - Steg-för-steg guider

### Bidra till projektet

- **[GitHub Repository](https://github.com/your-username/ogmios-pai)**
- **[Issues & Feature Requests](https://github.com/your-username/ogmios-pai/issues)**
- **[Contributing Guide](../CONTRIBUTING.md)**

### Community

- **Discord:** [Länk till community]
- **Forum:** [Länk till diskussionsforum]

---

## 🙏 Support

**Hittar du buggar eller har frågor?**

1. **Kontrollera felsökningssektionen** ovan
2. **Sök i [GitHub Issues](https://github.com/your-username/ogmios-pai/issues)**
3. **Skapa ny issue** med detaljerad beskrivning
4. **Gå med i community** för hjälp

**När du rapporterar problem, inkludera:**
- Din OS och version (macOS 14.2, Ubuntu 22.04, etc.)
- Claude Code version (`claude --version`)
- Felmeddelanden (kompletta)
- Steg för att återskapa problemet
- Output från verifieringsscriptet

---

**Tillbaka till:** [README](01-README.md) | **Dokumentation:** [Svenska](../sv/) | [English](../en/)

**Senast uppdaterad:** 2025-11-09
