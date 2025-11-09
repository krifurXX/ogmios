# Ogmios PAI - Mallfiler

**Språk:** [🇬🇧 English](README.md) | 🇸🇪 Svenska

Denna katalog innehåller färdiga mallfiler för att sätta upp din Ogmios Personal AI Infrastructure.

---

## 📋 Snabbstart

**Installation:**

```bash
# Klona repository
git clone https://github.com/<username>/ogmios-pai.git
cd ogmios-pai

# Kopiera mallar till din Claude-katalog
cp -r templates/* ~/.claude/.claude/

# Anpassa din PAI
nano ~/.claude/.claude/PAI.md  # eller använd din favoritredigerare
```

**Vad som kopieras:**

```
~/.claude/.claude/
├── PAI.md                    # Din AI:s kärnidentitet
├── settings.json             # Hooks och konfiguration
├── .gitignore                # Säkerhet (förhindrar secrets i git)
├── context/
│   ├── UFC.md                # Kontextsystemöversikt
│   └── memory/
│       ├── decisions.md      # Architectural Decision Records
│       └── learnings.md      # Lärdomar
├── skills/
│   └── SKILLS-INDEX.md       # Skills-register
└── hooks/
    ├── package.json          # Dependencies
    ├── tsconfig.json         # TypeScript-config
    ├── session-start.ts      # Session-initialisering
    ├── load-ufc-context.ts   # Kontextladdning
    ├── skill-activation.ts   # Auto-aktivera specialister
    ├── stop-voice.ts         # Röstfeedback (valfritt)
    └── log-tool-use.ts       # Verktygsloggning (valfritt)
```

---

## 📂 Mallfiler

### Kärnidentitet

#### `PAI.md`
**Syfte:** Din AI:s kärnidentitet - definierar vem du är och hur Claude ska bete sig

**Innehåller:**
- 🚨 Regelefterlevnadsprotokoll (obligatorisk kontextladdning)
- 🚨 Skills-first aktiveringsregler
- 🎯 Ditt syfte och mål
- 👤 Din bakgrund och arbetsstil
- 🎨 Personlighet och ton-preferenser
- 🛠️ Aktiverade system (UFC, Skills, Voice, MCP)
- 🗂️ Katalogstrukturöversikt

**Anpassa:**
- Ersätt `<DITT_NAMN>` med ditt namn
- Fyll i ditt yrke, utbildning, intressen
- Sätt din tech stack (editor, shell, pakethanterare)
- Definiera dina språkpreferenser (svenska, engelska, båda)
- Lista dina nuvarande projekt
- Sätt dina mål och vision

**Exempel:**
```markdown
**Namn:** <YOUR_NAME>
**Yrke:** PhD-student i informationssäkerhet
**Editor:** NeoVim
**Språk:** Svenska (naturlig) + Engelska (teknisk/kod)
```

---

### Konfiguration

#### `settings.json`
**Syfte:** Claude Code-konfiguration - hooks, permissions, röstuppsättning

**Innehåller:**
- **Hooks-konfiguration** - När ska vilka hooks köras
- **Auto-approve tools** - Verktyg Claude kan använda utan att fråga
- **Environment variables** - PAI-katalog, voice server URL
- **Voice settings** (om ElevenLabs används)

**Anpassa:**
- Uppdatera `PAI_DIR` om du använder icke-standard plats
- Lägg till/ta bort auto-approved tools
- Konfigurera voice server URL (om du använder)
- Aktivera/inaktivera specifika hooks

**Viktiga sektioner:**

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
**Syfte:** Säkerhet - förhindra känsliga filer från att committas till git

**Skyddar:**
- API-nycklar och credentials (`.env`, `.mcp.json`)
- Personlig information (`PAI.md`, `context/`)
- Loggar och temporära filer
- OS-specifika filer (`.DS_Store`, etc.)

**Användning:** Kopiera till valfri projektkatalog där du använder Ogmios

---

### UFC Context System

#### `context/UFC.md`
**Syfte:** Översikt av ditt UFC (Universal File-based Context) system

**Innehåller:**
- Systemarkitekturöversikt
- Katalogstruktur
- Progressive Disclosure tiers (Tier 1/2/3)
- Intent-patterns för kontextladdning
- Best practices

**Anpassa:**
- Beskriv din personliga kontextorganisation
- Definiera intent-patterns för dina projekt
- Dokumentera din Tier 1/2/3-strategi

**Exempel intent patterns:**
```markdown
## Intent Patterns

När användare nämner "e-commerce projekt":
→ Ladda: context/projects/ecommerce.md

När användare nämner "maskininlärning":
→ Ladda: context/projects/ml-project.md
→ Ladda: context/technical/python-ml-stack.md
```

#### `context/memory/decisions.md`
**Syfte:** Architectural Decision Records (ADRs) - dokumentera viktiga beslut

**Format:**
```markdown
## Beslut: UFC Tier System
**Datum:** 2025-01-15
**Status:** Accepterat
**Kontext:** Behöver hantera kontextstorlek samtidigt som detaljerad info tillhandahålls
**Beslut:** Använd 3-tiers progressive disclosure system
**Konsekvenser:**
- ✅ Bättre token-hantering
- ✅ Snabbare initiala svar
- ⚠️ Kräver disciplin i filorganisation
```

**Använd för:**
- Systemarkitekturbeslut
- Teknologival
- Workflow-ändringar
- Processförbättringar

#### `context/memory/learnings.md`
**Syfte:** Fånga lärdomar - misstag, quick wins, misslyckade experiment

**Kategorier:**
- **Misstag & Fixes** - Vad gick fel och hur du fixade det
- **Quick Wins** - Överraskande effektiva lösningar
- **Misslyckade Experiment** - Vad som inte funkade (undvik att upprepa)

**Exempel:**
```markdown
### Misstag: Överkomplice rad hook-logik
**Datum:** 2025-01-20
**Vad hände:** Skapade komplex intent detection med ML
**Impact:** Hooks timeout (>5 sekunder)
**Fix:** Förenklat till keyword matching
**Lärdom:** Håll hooks enkla och snabba (<2 sekunder)
```

---

### Skills System

#### `skills/SKILLS-INDEX.md`
**Syfte:** Register över alla tillgängliga skills med metadata

**Innehåller 7 fördefinierade skills:**
- **engineering** - George Foster (kodimplementering)
- **architecture** - Dr. Emma Roberts (systemdesign)
- **research** - Dr. Alice Mitchell (akademisk forskning)
- **knowledge-management** - Marcus Thompson (innehållsskapande)
- **swedish-academic-writing** - Prof. Lars Bergström (svensk akademisk)
- **devops** - James Carter (deployment, infrastruktur)
- **security** - Sarah Chen (säkerhetsgranskning)

**Format:**
```markdown
### engineering
**Namn:** George Foster
**Röst:** British male engineer
**Triggers:** code, implement, build, fix, debug, refactor, optimize
**Voice ID:** <VOICE_ID_ENGINEERING>
**Fil:** ~/.claude/.claude/skills/engineering/SKILL.md
**Tier:** 1

**Beskrivning:**
Senior software engineer specialiserad i ren kod...
```

**Anpassa:**
- Lägg till egna skills
- Justera triggers för bättre aktivering
- Sätt voice IDs om du använder ElevenLabs
- Skapa skill-specifika filer i `skills/<skill-name>/SKILL.md`

**Lägga till ny skill:**
```markdown
### din-skill-namn
**Namn:** Expert Namn
**Röst:** Röstbeskrivning
**Triggers:** keyword1, keyword2, keyword3
**Voice ID:** <VOICE_ID_CUSTOM>
**Fil:** ~/.claude/.claude/skills/din-skill-namn/SKILL.md
**Tier:** 1

**Beskrivning:**
Vad denna skill gör...
```

---

### Hooks

Hooks är TypeScript-filer som körs automatiskt vid specifika events i Claude Code.

#### `hooks/package.json`
**Syfte:** Dependencies för hook-scripts

**Innehåller:**
- TypeScript types för Claude Code hooks
- Filsystemverktyg
- HTTP-klient för voice server

**Installera dependencies:**
```bash
cd ~/.claude/.claude/hooks
bun install  # eller npm install
```

#### `hooks/tsconfig.json`
**Syfte:** TypeScript-konfiguration för hooks

**Inställningar:**
- ESNext target för modern JavaScript
- Strikt type checking
- Modulupplösning för Node.js

#### `hooks/session-start.ts`
**Syfte:** Körs när Claude Code startar ny session

**Vad den gör:**
- Laddar `PAI.md` innehåll
- Visar välkomstmeddelande
- Sätter upp sessionskontext

**Anpassa:**
- Lägg till ytterligare initialiseringslogik
- Ladda sessionsspecifik kontext
- Visa anpassat välkomstmeddelande

#### `hooks/load-ufc-context.ts`
**Syfte:** Ladda kontext innan AI svarar (UserPromptSubmit event)

**Vad den gör:**
- Läser användarmeddelande
- Detekterar intent (keywords, projektnamn)
- Laddar relevanta UFC-kontextfiler
- Returnerar kontext som systemmeddelande

**Anpassa:**
- Lägg till egna intent-patterns
- Definiera projektspecifika keywords
- Implementera Tier-baserad laddningslogik

**Exempel anpassning:**
```typescript
const projectKeywords = {
  'my-app': ['app', 'frontend', 'react'],
  'ml-model': ['machine learning', 'model', 'training']
};

// Detektera vilket projekt användare frågar om
for (const [project, keywords] of Object.entries(projectKeywords)) {
  if (keywords.some(kw => message.toLowerCase().includes(kw))) {
    // Ladda projektkontext
    const contextPath = `${PAI_DIR}/context/projects/${project}.md`;
    // ...
  }
}
```

#### `hooks/skill-activation.ts`
**Syfte:** Aktivera automatiskt specialist-skills baserat på uppgiftstyp

**Vad den gör:**
- Läser `SKILLS-INDEX.md`
- Parsar skill-triggers
- Matchar användarmeddelande mot triggers
- Poängsätter potentiella skills
- Aktiverar bäst match om poäng > threshold

**Poängsättningsalgoritm:**
- Exakt ordmatch: 15 poäng
- Partiell match: 5 poäng
- Threshold: 20 poäng minimum

**Anpassa:**
- Justera aktiveringströskel (default: 20)
- Lägg till anpassad poängsättningslogik
- Implementera multi-skill aktivering

**Exempel:**
```typescript
// User: "Bygg ett REST API för autentisering"
//
// Matchar:
// - "bygg" → engineering (+15)
// - "API" → engineering (+15)
// - "autentisering" → security (+5)
//
// Poäng: engineering = 30, security = 5
// → Aktiverar engineering skill (poäng > 20)
```

#### `hooks/stop-voice.ts` (Valfritt)
**Syfte:** Röstfeedback när AI är klar med svar

**Vad den gör:**
- Extraherar `COMPLETED` och `CUSTOM COMPLETED` tags
- Detekterar aktiv agent/skill
- Mappar agent till voice ID
- Triggar voice server att säga completion

**Kräver:**
- Voice server igång på `localhost:8765`
- ElevenLabs API-nyckel konfigurerad
- Voice IDs satta i script

**Anpassa:**
- Lägg till egna röster
- Justera speech rate
- Modifiera språkdetektering

**Röstmapping:**
```typescript
const VOICE_MAP = {
  engineering: {
    id: 'DIN_BRITISH_MALE_VOICE_ID',
    name: 'George Foster',
    language: 'en'
  },
  research: {
    id: 'DIN_BRITISH_FEMALE_VOICE_ID',
    name: 'Dr. Alice Mitchell',
    language: 'en'
  }
};
```

#### `hooks/log-tool-use.ts` (Valfritt)
**Syfte:** Logga all verktygsanvändning för analytics

**Vad den gör:**
- Detekterar verktygsanrop (Read, Write, Edit, Bash, etc.)
- Extraherar parametrar (sanerade)
- Loggar till JSON Lines-format
- Spårar success/failure

**Output-format:**
```json
{"timestamp":"2025-01-15T10:30:00Z","tool":"Read","category":"file","parameters":{"file_path":"/path/to/file.md"},"success":true}
{"timestamp":"2025-01-15T10:30:05Z","tool":"Edit","category":"file","parameters":{"file_path":"/path/to/code.ts"},"success":true}
```

**Anpassa:**
- Ändra loggfilsplats
- Lägg till anpassade verktygskatego rier
- Implementera log rotation
- Lägg till analytics-queries

---

## 🚀 Efter Installation

### 1. Verifiera Installation

```bash
# Kör verifikationsskript
./verify-installation.sh

# Förväntat output:
# ✅ Claude Code installerad
# ✅ PAI.md finns
# ✅ settings.json finns
# ✅ UFC.md finns
# ✅ SKILLS-INDEX.md finns
# ✅ Hooks konfigurerade
```

### 2. Anpassa Mallar

**Essentiella anpassningar:**

1. **Redigera PAI.md:**
   ```bash
   nano ~/.claude/.claude/PAI.md
   ```
   - Ersätt `<DITT_NAMN>`
   - Fyll i dina detaljer
   - Sätt dina mål

2. **Skapa projektkontext:**
   ```bash
   cp examples/sv/exempel-ufc-tier1.md ~/.claude/.claude/context/projects/mitt-projekt.md
   # Redigera med dina projektdetaljer
   ```

3. **Anpassa skills:**
   ```bash
   nano ~/.claude/.claude/skills/SKILLS-INDEX.md
   # Lägg till/ta bort skills
   # Justera triggers
   ```

### 3. Installera Hook Dependencies

```bash
cd ~/.claude/.claude/hooks
bun install  # eller npm install

# Verifiera
bun run session-start.ts  # Borde visa välkomstmeddelande
```

### 4. Valfritt: Röstsystem

Om du vill ha röstfeedback:

```bash
# Installera voice server
cd voice-server
pip3 install -r requirements.txt

# Konfigurera
cp .env.example .env
nano .env  # Lägg till ELEVENLABS_API_KEY

# Starta server
./start.sh

# Testa
curl -X POST http://localhost:8765/speak \
  -H "Content-Type: application/json" \
  -d '{"text": "Hej från Ogmios", "voice_id": "DIN_VOICE_ID"}'
```

Uppdatera `hooks/stop-voice.ts` med dina voice IDs.

### 5. Testa Din Setup

```bash
# Starta Claude Code
claude

# Testa kontextladdning:
> "Vad finns i min UFC-kontext?"
# Borde visa: ✅ Context hydrated: UFC.md

# Testa skill-aktivering:
> "Bygg ett inloggningsformulär"
# Borde aktivera: engineering skill (George Foster)

# Kolla responsformat:
# Borde sluta med: 🎯 COMPLETED: [uppgiftsbeskrivning]
```

---

## 📚 Relaterad Dokumentation

**Grundläggande Guider:**
- [Installationsguide](../docs/06-bilingual/svenska/installation.md) - Komplett setup-instruktioner
- [UFC-systemet](../sv/03-UFC-SYSTEMET.md) - Kontexthantering
- [Skills-systemet](../sv/04-SKILLS-SYSTEMET.md) - Specialistaktivering
- [Hooks & Automation](../docs/06-bilingual/svenska/hooks-automation.md) - Event-drivet system

**Exempel:**
- [Exempel UFC Tier 1](../examples/sv/exempel-ufc-tier1.md) - Snabb projektöversikt
- [Exempel UFC Tier 2](../examples/sv/exempel-ufc-tier2.md) - Arkitekturdetaljer
- [Exempel Skill](../examples/sv/exempel-skill-research.md) - Komplett skill-definition

**Referens:**
- [FAQ](../docs/06-bilingual/svenska/faq.md) - Vanliga frågor
- [Felsökning](../sv/12-FELSÖKNING.md) - Debug-problem
- [Regelefterlevnad](../sv/11-REGELEFTERLEVNAD.md) - Tvingande instruktioner

---

## 🔐 Säkerhetsnoteringar

**VIKTIGT - LÄS INNAN ANVÄNDNING:**

### 1. Committa Aldrig Känslig Data

`.gitignore`-mallen skyddar:
- `PAI.md` (innehåller personlig info)
- `context/` (kan innehålla privata anteckningar)
- `.mcp.json` (innehåller API-nycklar)
- `.env` (innehåller secrets)

**Verifiera alltid innan commit:**
```bash
# Kolla vad som kommer committas
git status

# Kolla remote URL (borde vara DITT privata repo eller endast lokalt)
git remote -v

# Om osäker, committa INTE
```

### 2. API-nycklar

**Lägg ALDRIG API-nycklar direkt i kod eller config:**

❌ **FEL:**
```json
{
  "mcpServers": {
    "github": {
      "env": {
        "GITHUB_TOKEN": "ghp_abc123def456"  // ← GÖR ALDRIG DETTA
      }
    }
  }
}
```

✅ **RÄTT:**
```bash
# Spara i .mcp.json (gitignored)
# Eller använd environment variables
export GITHUB_TOKEN="ghp_abc123def456"
```

### 3. Filrättigheter

```bash
# Sätt restriktiva permissions
chmod 700 ~/.claude/.claude          # Endast du kan accessa
chmod 600 ~/.claude/.claude/PAI.md   # Endast du kan läsa/skriva
chmod 600 ~/.claude/.mcp.json        # Skydda API-nycklar
```

### 4. Backup Av Din Config

```bash
# Skapa krypterad backup
tar czf ogmios-backup-$(date +%Y%m%d).tar.gz ~/.claude/.claude
gpg -c ogmios-backup-*.tar.gz  # Kryptera med lösenord
rm ogmios-backup-*.tar.gz      # Ta bort okrypterad

# Återställ
gpg -d ogmios-backup-*.tar.gz.gpg | tar xz -C ~
```

---

## ❓ Få Hjälp

**Om mallar inte fungerar:**

1. **Kör verifiering:**
   ```bash
   ./verify-installation.sh --fix
   ```

2. **Kolla felsökningsguide:**
   ```bash
   cat docs/sv/12-FELSÖKNING.md | less
   ```

3. **Vanliga problem:**
   - Hooks körs inte → Installera Bun: `curl -fsSL https://bun.sh/install | bash`
   - Kontext laddas inte → Kolla `settings.json` hooks-sektion
   - Skills aktiveras inte → Verifiera att `SKILLS-INDEX.md` finns

4. **Få community-hjälp:**
   - GitHub Discussions: https://github.com/<username>/ogmios-pai/discussions
   - GitHub Issues: https://github.com/<username>/ogmios-pai/issues

---

## 📝 Mall-Changelog

**v1.0.0 (2025-11-09):**
- ✅ Initial mall-release
- ✅ Komplett compliance enforcement i PAI.md
- ✅ 7 fördefinierade skills i SKILLS-INDEX.md
- ✅ Alla essentiella hooks (session-start, load-ufc-context, skill-activation)
- ✅ Valfria hooks (stop-voice, log-tool-use)
- ✅ Säkerhetsfokuserad .gitignore

---

**Lycka till med Ogmios! 🚀**

*Bygger din Personal AI Infrastructure, en mall i taget.*
