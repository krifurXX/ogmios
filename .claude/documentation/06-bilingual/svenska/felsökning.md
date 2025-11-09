# Felsökningsguide - Ogmios PAI

[🇬🇧 English](../docs/01-getting-started/troubleshooting.md) | 🇸🇪 Svenska

**Senast uppdaterad:** 2025-11-09
**Version:** 1.0

---

## 📋 Innehåll

1. [Snabbdiagnos](#snabbdiagnos)
2. [Claude Code Problem](#claude-code-problem)
3. [Installation Problem](#installation-problem)
4. [Hooks Problem](#hooks-problem)
5. [Skills Problem](#skills-problem)
6. [UFC Context Problem](#ufc-context-problem)
7. [Voice System Problem](#voice-system-problem)
8. [MCP Server Problem](#mcp-server-problem)
9. [Performance Problem](#performance-problem)
10. [Bilingual Problem](#bilingual-problem)
11. [Verifikationsskript](#verifikationsskript)
12. [Få Hjälp](#få-hjälp)

---

## Snabbdiagnos

**Kör detta först för att identifiera problem:**

```bash
#!/bin/bash
echo "🔍 Ogmios Snabbdiagnos"
echo "======================="

# Claude Code
echo -n "Claude Code: "
if command -v claude &> /dev/null; then
    echo "✅ Installerad ($(claude --version))"
else
    echo "❌ SAKNAS - Installera från https://docs.anthropic.com/claude/docs/claude-code"
fi

# PAI.md
echo -n "PAI.md: "
if [ -f ~/.claude/.claude/PAI.md ]; then
    echo "✅ Finns ($(wc -l < ~/.claude/.claude/PAI.md) rader)"
else
    echo "❌ SAKNAS"
fi

# Settings
echo -n "settings.json: "
if [ -f ~/.claude/.claude/settings.json ]; then
    echo "✅ Finns"
else
    echo "❌ SAKNAS"
fi

# Hooks
echo -n "Hooks: "
if [ -d ~/.claude/.claude/hooks ]; then
    hook_count=$(ls -1 ~/.claude/.claude/hooks/*.ts 2>/dev/null | wc -l)
    echo "✅ Katalog finns ($hook_count .ts filer)"
else
    echo "❌ Katalog saknas"
fi

# Context
echo -n "UFC Context: "
if [ -f ~/.claude/.claude/context/UFC.md ]; then
    echo "✅ UFC.md finns"
else
    echo "❌ UFC.md saknas"
fi

# Skills
echo -n "Skills: "
if [ -f ~/.claude/.claude/skills/SKILLS-INDEX.md ]; then
    skill_count=$(grep -c "^### " ~/.claude/.claude/skills/SKILLS-INDEX.md 2>/dev/null || echo 0)
    echo "✅ SKILLS-INDEX.md finns ($skill_count skills)"
else
    echo "❌ SKILLS-INDEX.md saknas"
fi

# Bun (för hooks)
echo -n "Bun: "
if command -v bun &> /dev/null; then
    echo "✅ Installerad ($(bun --version))"
else
    echo "⚠️  Saknas - Hooks fungerar inte"
fi

# Voice Server (valfritt)
echo -n "Voice Server: "
if curl -s http://localhost:8765/health &> /dev/null; then
    echo "✅ Igång"
else
    echo "⚠️  Ej igång (valfritt)"
fi

echo "======================="
echo "Kör 'claude' för att starta"
```

**Spara som:** `~/.claude/.claude/diagnose.sh`
**Kör:** `bash ~/.claude/.claude/diagnose.sh`

---

## Claude Code Problem

### Problem: `claude: command not found`

**Symptom:** När du kör `claude` får du "command not found"

**Orsak:** Claude Code inte installerad eller inte i PATH

**Lösning:**

```bash
# Kontrollera om installerad
which claude

# Om saknas, installera:
# macOS/Linux:
curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/install.sh | sh

# Verifiera installation
claude --version
```

### Problem: Claude Code startar inte

**Symptom:** `claude` kraschar eller ger felmeddelande

**Möjliga orsaker:**

1. **Ogiltiga JSON-filer**
```bash
# Validera settings.json
cat ~/.claude/.claude/settings.json | python3 -m json.tool
# Om fel, kopiera från template igen
```

2. **Permissions-problem**
```bash
# Kontrollera och fixa permissions
chmod 700 ~/.claude/.claude
chmod 600 ~/.claude/.claude/PAI.md
chmod 600 ~/.claude/.claude/settings.json
```

3. **Korrupt konfiguration**
```bash
# Backup och återställ
mv ~/.claude/.claude/settings.json ~/.claude/.claude/settings.json.backup
cp templates/settings.json ~/.claude/.claude/
# Återaktivera hooks gradvis
```

### Problem: API-anslutning misslyckas

**Symptom:** "Failed to connect to API" eller timeout-errors

**Lösning:**

```bash
# Kontrollera API-nyckel
cat ~/.claude/.claude/.env | grep ANTHROPIC_API_KEY

# Kontrollera nätverksanslutning
curl -I https://api.anthropic.com

# Kontrollera proxy-inställningar (om används)
echo $HTTP_PROXY
echo $HTTPS_PROXY
```

---

## Installation Problem

### Problem: Templates inte hittade

**Symptom:** `cp: templates: No such file or directory`

**Orsak:** Klonade inte repository först

**Lösning:**

```bash
# 1. Klona repository
cd ~/Downloads  # eller valfri plats
git clone https://github.com/<username>/ogmios-pai.git
cd ogmios-pai

# 2. NU kan du kopiera templates
cp -r templates/* ~/.claude/.claude/

# Verifiera
ls -la ~/.claude/.claude/
```

### Problem: Katalogstruktur fel

**Symptom:** Filer hamnar på fel plats

**Förväntad struktur:**
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

**Fixa:**
```bash
# Skapa saknade kataloger
mkdir -p ~/.claude/.claude/context/{projects,memory,languages}
mkdir -p ~/.claude/.claude/skills
mkdir -p ~/.claude/.claude/hooks

# Flytta filer till rätt plats om de hamnat fel
# Exempel: Om UFC.md är i fel katalog
mv ~/.claude/.claude/UFC.md ~/.claude/.claude/context/
```

### Problem: Permission denied

**Symptom:** "Permission denied" när du kopierar filer

**Lösning:**

```bash
# Kontrollera ägarskap
ls -la ~/.claude/

# Om fel användare, fixa:
sudo chown -R $(whoami):$(id -gn) ~/.claude

# Sätt korrekta permissions
chmod -R u+rwX ~/.claude/.claude
```

---

## Hooks Problem

### Problem: Hooks körs inte

**Symptom:** Context laddas inte, skills aktiveras inte, ingen röstfeedback

**Diagnos:**

```bash
# 1. Kontrollera settings.json
cat ~/.claude/.claude/settings.json | grep -A 20 "hooks"

# 2. Kontrollera hook-filer finns
ls -la ~/.claude/.claude/hooks/*.ts

# 3. Kontrollera Bun är installerad
bun --version

# 4. Testa hook manuellt
cd ~/.claude/.claude/hooks
bun run session-start.ts
```

**Möjliga lösningar:**

**Problem 1: Bun saknas**
```bash
# Installera Bun
curl -fsSL https://bun.sh/install | bash

# Lägg till i PATH
export PATH="$HOME/.bun/bin:$PATH"
echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.zshrc  # eller ~/.bashrc
```

**Problem 2: Dependencies saknas**
```bash
cd ~/.claude/.claude/hooks
bun install
```

**Problem 3: Hook-syntax fel**
```bash
# Validera TypeScript
cd ~/.claude/.claude/hooks
bun run --dry-run session-start.ts

# Kolla efter felmeddelanden
```

**Problem 4: settings.json fel konfigurerad**
```json
// Korrekt format i settings.json:
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

### Problem: Hook timeout

**Symptom:** "Hook timed out" i Claude Code output

**Orsak:** Hook tar för lång tid (>5 sekunder)

**Lösning:**

```typescript
// I din hook, optimera:

// ❌ LÅNGSAMT - Läser alla filer varje gång
const allFiles = await globFiles('context/**/*.md');
for (const file of allFiles) {
  const content = await readFile(file);
  // ...
}

// ✅ SNABBT - Läs bara nödvändiga filer
const ufcContent = await readFile('context/UFC.md');
// Ladda mer endast vid behov
```

### Problem: Hook kraschar

**Symptom:** Hook startar men ger error

**Debug:**

```bash
# Kör hook manuellt med debug output
cd ~/.claude/.claude/hooks
DEBUG=* bun run session-start.ts

# Kolla logs
tail -f ~/.claude/.claude/logs/hooks.log  # om du har logging
```

---

## Skills Problem

### Problem: Skills aktiveras inte

**Symptom:** Claude svarar generiskt istället för att aktivera specialist

**Diagnos:**

```bash
# 1. Kontrollera SKILLS-INDEX.md finns
cat ~/.claude/.claude/skills/SKILLS-INDEX.md

# 2. Kontrollera skill-activation.ts hook är aktiverad
grep skill-activation ~/.claude/.claude/settings.json

# 3. Testa hook manuellt
cd ~/.claude/.claude/hooks
echo '{"message": "Build a login form"}' | bun run skill-activation.ts
```

**Lösningar:**

**Problem 1: SKILLS-INDEX.md saknas**
```bash
cp templates/skills/SKILLS-INDEX.md ~/.claude/.claude/skills/
```

**Problem 2: Intent patterns för svaga**

Öppna `~/.claude/.claude/skills/SKILLS-INDEX.md`:

```markdown
### engineering
**Triggers:** code, implement, build, fix, debug, refactor, optimize, test

# Lägg till fler specifika triggers:
**Triggers:** code, implement, build, fix, debug, refactor, optimize, test,
create, develop, write code, programming, api, frontend, backend, database
```

**Problem 3: Activation threshold för hög**

I `skill-activation.ts`, sänk threshold:

```typescript
const ACTIVATION_THRESHOLD = 20;  // ← Sänk till 15 om skills inte aktiveras ofta nog
```

### Problem: Fel skill aktiveras

**Symptom:** Research skill aktiveras för kod-uppgift

**Orsak:** Överlappande triggers

**Fixa triggers i SKILLS-INDEX.md:**

```markdown
### engineering
**Triggers:** implement, build, code, develop, fix bug, refactor, optimize
# Specifika, tekniska ord

### research
**Triggers:** research, academic, literature, papers, citations, sources
# Akademiska ord

# Undvik generiska ord som "help", "create", "write" i triggers
```

### Problem: Skills-fil inte hittas

**Symptom:** "Skill file not found" error

**Lösning:**

```bash
# Kontrollera filstruktur
ls -la ~/.claude/.claude/skills/

# Förväntat:
# skills/
# ├── SKILLS-INDEX.md
# ├── engineering/
# │   └── SKILL.md
# ├── research/
# │   └── SKILL.md
# └── architecture/
#     └── SKILL.md

# Skapa saknade skill-filer från templates
cp -r templates/skills/* ~/.claude/.claude/skills/
```

---

## UFC Context Problem

### Problem: Context laddas inte

**Symptom:** Claude svarar utan "✅ Context hydrated: [files]"

**Diagnos:**

```bash
# 1. Kontrollera UFC.md finns
cat ~/.claude/.claude/context/UFC.md

# 2. Kontrollera load-ufc-context.ts hook
ls -la ~/.claude/.claude/hooks/load-ufc-context.ts

# 3. Kontrollera hook är aktiverad
grep load-ufc-context ~/.claude/.claude/settings.json

# 4. Testa hook manuellt
cd ~/.claude/.claude/hooks
echo '{"message": "test"}' | bun run load-ufc-context.ts
```

**Lösningar:**

**Problem 1: UFC.md saknas**
```bash
cp templates/context/UFC.md ~/.claude/.claude/context/
# Redigera och anpassa till ditt system
```

**Problem 2: Hook inte konfigurerad i settings.json**

Lägg till i `settings.json`:
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

### Problem: Fel kontext laddas

**Symptom:** Context för fel projekt laddas

**Orsak:** Intent detection felaktig

**Fixa i load-ufc-context.ts:**

```typescript
// Förbättra intent detection med fler keywords
const projectKeywords = {
  'ecommerce': ['shop', 'cart', 'product', 'checkout', 'payment', 'order'],
  'ml-project': ['machine learning', 'ml', 'model', 'training', 'dataset', 'pytorch'],
  'blog': ['post', 'article', 'wordpress', 'cms', 'publish']
};
```

### Problem: Context för stor

**Symptom:** Token limit överskrids, långsam respons

**Lösning - Progressive Disclosure:**

```markdown
<!-- I context/projects/my-project.md -->

## TIER 1 - Snabbstart (<5KB)
**Projekt:** E-commerce
**Stack:** React + FastAPI + PostgreSQL
**Status:** Production
**Keywords:** shop, cart, checkout

<!-- Stoppa här för Tier 1 -->
---
## TIER 2 - Arkitektur (10-50KB)
[Detaljerad arkitektur...]

---
## TIER 3 - Deep Dive (50KB+)
[API docs, databas-schemas, etc.]
```

Uppdatera hook för att ladda progressivt:
```typescript
// Ladda bara Tier 1 först
const tier1Content = content.split('---')[0];
return { systemMessage: tier1Content };
```

---

## Voice System Problem

### Problem: Voice server startar inte

**Symptom:** `curl http://localhost:8765/health` ger connection refused

**Diagnos:**

```bash
# Kontrollera om server körs
ps aux | grep voice-server

# Kontrollera port är ledig
lsof -i :8765

# Kontrollera Python miljö
cd voice-server
python3 --version  # Måste vara 3.8+
pip3 list | grep flask
```

**Lösningar:**

**Problem 1: Dependencies saknas**
```bash
cd voice-server
pip3 install -r requirements.txt
```

**Problem 2: Port upptagen**
```bash
# Ändra port i .env
echo "PORT=8766" >> .env

# Uppdatera också i hooks/stop-voice.ts:
const voiceServerUrl = 'http://localhost:8766';
```

**Problem 3: ElevenLabs API-nyckel saknas**
```bash
cd voice-server

# Lägg till API-nyckel i .env
echo "ELEVENLABS_API_KEY=your_key_here" > .env
echo "ELEVENLABS_DEFAULT_VOICE_ID=your_voice_id" >> .env

# Verifiera
source .env
curl -H "xi-api-key: $ELEVENLABS_API_KEY" \
  https://api.elevenlabs.io/v1/voices
```

### Problem: Ingen röst hörs

**Symptom:** Voice server svarar 200 OK men ingen ljud

**Diagnos:**

```bash
# Testa server direkt
curl -X POST http://localhost:8765/speak \
  -H "Content-Type: application/json" \
  -d '{"text": "Test", "voice_id": "your_voice_id"}'

# Kontrollera ljudutgång
# macOS:
system_profiler SPAudioDataType

# Linux:
aplay -l
```

**Lösningar:**

**Problem 1: Audio player saknas**

macOS:
```bash
# Ska ha afplay installerat (standard)
which afplay
```

Linux:
```bash
# Installera aplay
sudo apt-get install alsa-utils  # Debian/Ubuntu
sudo yum install alsa-utils       # RHEL/CentOS
```

**Problem 2: Fel Voice ID**
```bash
# Hämta tillgängliga röster
curl http://localhost:8765/voices

# Uppdatera voice ID i hooks/stop-voice.ts
```

### Problem: Voice lag

**Symptom:** Röst kommer 5+ sekunder efter response

**Lösning:**

```typescript
// I hooks/stop-voice.ts, minska speech_rate för snabbare syntes
const speechRate = 260;  // ← Sänk till 200 för snabbare (men mindre naturligt)
```

Eller använd streaming:
```python
# I voice-server/server.py, lägg till streaming
@app.route('/stream', methods=['POST'])
def stream():
    # Använd ElevenLabs streaming API för lägre latens
    # Se: https://elevenlabs.io/docs/api-reference/streaming
```

---

## MCP Server Problem

### Problem: MCP server ansluter inte

**Symptom:** "MCP server connection failed" i Claude Code

**Diagnos:**

```bash
# Kontrollera .mcp.json finns
cat ~/.claude/.mcp.json

# Testa server individuellt
# Exempel för GitHub:
npx -y @modelcontextprotocol/server-github --version
```

**Lösningar:**

**Problem 1: .mcp.json felaktig**

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

**Problem 2: API-token saknas eller ogiltig**

```bash
# GitHub token
# Skapa ny på: https://github.com/settings/tokens
# Lägg till i .mcp.json under "env"

# Zotero
# Hämta API key: https://www.zotero.org/settings/keys
# Hämta User ID: https://www.zotero.org/settings/keys (visas under "Your userID")
```

**Problem 3: Server-package inte installerat**

```bash
# GitHub server
npm install -g @modelcontextprotocol/server-github

# Zotero server (Python)
pip3 install mcp-server-zotero

# n8n server
npm install -g @n8n/mcp-server
```

### Problem: MCP tools visas inte

**Symptom:** `mcp__` prefixade tools saknas i Claude

**Lösning:**

1. Starta om Claude Code helt
2. Kontrollera server körs:
```bash
# Lista running processes
ps aux | grep mcp
```

3. Kolla Claude Code logs:
```bash
# Logs brukar vara i:
~/.claude/logs/
# Eller kör med debug:
DEBUG=* claude
```

---

## Performance Problem

### Problem: Claude svarar långsamt

**Symptom:** >10 sekunder svarstid

**Möjliga orsaker:**

**1. För mycket context laddas**

```bash
# Kontrollera context-storlek
find ~/.claude/.claude/context -name "*.md" -exec wc -c {} + | sort -n

# Om filer >100KB:
# - Använd Progressive Disclosure (Tier 1/2/3)
# - Ladda bara relevant context per intent
```

**2. Hooks tar för lång tid**

```bash
# Mät hook-tid
time bun run ~/.claude/.claude/hooks/load-ufc-context.ts

# Om >2 sekunder, optimera:
# - Cacha lästa filer
# - Använd grep istället för att läsa hela filer
# - Aktivera endast nödvändiga hooks
```

**3. För många MCP servers**

```json
// Kommentera ut oanvända servers i .mcp.json
{
  "mcpServers": {
    "github": { ... },  // ✅ Används ofta
    // "zotero": { ... },  // ❌ Kommentera ut om ej används just nu
    // "playwright": { ... }
  }
}
```

### Problem: Token limit överskrids

**Symptom:** "Token limit exceeded" error

**Lösning:**

```markdown
<!-- I PAI.md, förkorta -->
## 🎯 Purpose
Ogmios PAI för utveckling och forskning.

<!-- Istället för lång beskrivning -->

<!-- I context-filer, använd Tier system -->
## Tier 1 (<5KB)
Endast essentials här.

---
## Tier 2 (10-50KB)
Detaljerad info (laddas vid behov).
```

Uppdatera hooks för att bara ladda Tier 1:
```typescript
const tier1 = content.split('---')[0];
```

---

## Bilingual Problem

### Problem: Fel språk i svar

**Symptom:** Claude svarar på engelska när du skrev på svenska

**Lösning:**

Lägg till i PAI.md:
```markdown
## 🇸🇪 Språkregler

**OBLIGATORISKT:**
1. **Detektera input-språk** - Matcha ALLTID användarens språk
2. **Svenska input → Svenska svar**
3. **English input → English response**
4. **Tekniska termer** - OK att mixa (svenska text + engelska kodord)

**Exempel:**
User (svenska): "Hur fungerar hook-systemet?"
→ Claude MÅSTE svara på svenska

User (English): "How does the hook system work?"
→ Claude MUST respond in English
```

### Problem: Voice säger fel språk

**Symptom:** Svensk röst läser engelsk text (eller tvärtom)

**Lösning:**

I `hooks/stop-voice.ts`:
```typescript
const VOICE_MAP: Record<string, VoiceConfig> = {
  engineering: {
    id: '<BRITISH_VOICE_ID>',
    name: 'George Foster',
    accent: 'British',
    language: 'en'  // ← Lägg till
  },
  'swedish-academic-writing': {
    id: '<SWEDISH_VOICE_ID>',
    name: 'Prof. Lars Bergström',
    accent: 'Swedish',
    language: 'sv'  // ← Lägg till
  }
};

// Matcha språk i COMPLETED tag med voice
function detectLanguage(text: string): string {
  // Svenska ord?
  if (/å|ä|ö|ska|och|för|med/i.test(text)) return 'sv';
  return 'en';
}

const textLang = detectLanguage(completedText);
const voice = VOICE_MAP[agent];

// Om mismatch, välj default voice för språket
if (voice.language !== textLang) {
  const defaultVoice = textLang === 'sv' ? SWEDISH_DEFAULT : ENGLISH_DEFAULT;
  // Använd default istället
}
```

---

## Verifikationsskript

**Komplett verifikationsskript - spara som `verify-ogmios.sh`:**

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
    echo "https://github.com/<username>/ogmios-pai/blob/main/docs/06-bilingual/svenska/installation.md"
fi

echo ""
exit $ERRORS
```

**Användning:**

```bash
# Gör skriptet körbart
chmod +x verify-ogmios.sh

# Kör verifiering
./verify-ogmios.sh

# Resultat:
# ✅ = OK
# ⚠️  = Varning (valfritt saknas)
# ❌ = Fel (kritiskt saknas)
```

---

## Få Hjälp

### GitHub Issues

Om du stöter på problem:

1. **Kör diagnos först:**
```bash
bash ~/.claude/.claude/diagnose.sh > diagnosis.txt
```

2. **Öppna issue på GitHub:**
   - Gå till: https://github.com/<username>/ogmios-pai/issues
   - Klicka "New Issue"
   - Välj template: "Bug Report"
   - Inkludera `diagnosis.txt` output

### Community Discord/Discussions

- **GitHub Discussions:** https://github.com/<username>/ogmios-pai/discussions


### Dokumentation

- [Installation](08-INSTALLATION.md) - Fullständig installationsguide
- [FAQ](10-FAQ.md) - Vanliga frågor
- [Architecture](02-ARKITEKTUR.md) - Systemarkitektur

---

**Senast uppdaterad:** 2025-11-09
**Feedback:** Öppna issue på GitHub om du hittar fel eller har förbättringsförslag
