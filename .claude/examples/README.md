# Ogmios Examples - Komplett Samling

**Språk:** [🇸🇪 Svenska](sv/) | [🇬🇧 English](en/)

---

## 📁 Översikt

Denna mapp innehåller **kompletterande exempelfiler** för alla typer av filer i Ogmios systemet, både på **svenska och engelska**.

**Total storlek:** ~140KB
**Antal filer:** 18 exempel

---

## 🗂️ Struktur

```
examples/
├── README.md (denna fil)
│
├── sv/                                 # 🇸🇪 Svenska exempel
│   ├── exempel-ufc-tier1.md            # UFC Tier 1 (Metadata <5KB)
│   ├── exempel-ufc-tier2.md            # UFC Tier 2 (Arkitektur 10-50KB)
│   ├── exempel-ufc-tier3.md            # UFC Tier 3 (Deep dive 50KB+)
│   ├── exempel-skill-research.md       # Research skill (Dr. Alice Mitchell)
│   ├── exempel-hook-session-start.ts   # SessionStart hook
│   ├── exempel-hook-stop-validation.ts # Stop hook (validation + voice)
│   ├── exempel-PAI-template.md         # PAI.md template
│   ├── exempel-directory-structure.md  # Komplett katalogstruktur
│   └── exempel-settings.json           # settings.json med hooks config
│
├── en/                                 # 🇬🇧 English examples
│   ├── example-ufc-tier1.md            # UFC Tier 1 (Metadata <5KB)
│   ├── example-ufc-tier2.md            # UFC Tier 2 (Architecture 10-50KB)
│   ├── example-ufc-tier3.md            # UFC Tier 3 (Deep dive 50KB+)
│   ├── example-skill-research.md       # Research skill (Dr. Alice Mitchell)
│   ├── example-hook-session-start.ts   # SessionStart hook
│   ├── example-hook-stop-validation.ts # Stop hook (validation + voice)
│   ├── example-PAI-template.md         # PAI.md template
│   ├── example-directory-structure.md  # Complete directory structure
│   └── example-settings.json           # settings.json with hooks config
```

---

## 📚 Exempeltyper

### 1️⃣ UFC Context Files (Tier 1, 2, 3)

**Tier 1 - Metadata** (`exempel-ufc-tier1.md` / `example-ufc-tier1.md`)
- Storlek: <5KB
- Innehåll: Snabb översikt, nyckelord, projektinfo
- Användning: Laddas först vid context hydration
- Exempel: E-commerce projekt översikt

**Tier 2 - Arkitektur** (`exempel-ufc-tier2.md` / `example-ufc-tier2.md`)
- Storlek: 10-50KB
- Innehåll: Systemarkitektur, API design, tekniska beslut
- Användning: Laddas vid djupare förståelse
- Exempel: Komplett API dokumentation, deployment setup

**Tier 3 - Deep Dive** (`exempel-ufc-tier3.md` / `example-ufc-tier3.md`)
- Storlek: 50KB+
- Innehåll: Komplett dokumentation, alla endpoints, test strategies
- Användning: Explicit begäran eller komplex implementation
- Exempel: Full API spec, environment variables, testing strategy

---

### 2️⃣ Skills System

**Research Skill** (`exempel-skill-research.md` / `example-skill-research.md`)
- Dr. Alice Mitchell - Academic research specialist
- Zotero MCP integration
- APA citation formatting
- Systematic literature review
- Voice feedback enabled

---

### 3️⃣ Hooks (Event-Driven Automation)

**SessionStart Hook** (`exempel-hook-session-start.ts` / `example-hook-session-start.ts`)
- Körs: Vid ny session
- Syfte: Ladda PAI.md (kärnidentitet)
- Output: System message med PAI content
- TypeScript implementation

**Stop Validation Hook** (`exempel-hook-stop-validation.ts` / `example-hook-stop-validation.ts`)
- Körs: EFTER Claude's svar
- Syfte: Validera COMPLETED tag + trigga voice
- Features:
  - COMPLETED tag format validation
  - Voice routing baserat på skill
  - ElevenLabs integration
  - Error reporting

---

### 4️⃣ Configuration Files

**PAI.md Template** (`exempel-PAI-template.md` / `example-PAI-template.md`)
- Komplett template för din kärnidentitet
- Alla sektioner förklarade
- Placeholders för personalisering
- Inkluderar:
  - Syfte och principer
  - Personlig bakgrund
  - Aktiverade system (UFC, Skills, Voice, MCP)
  - Katalogstruktur
  - Aktuella projekt
  - Mål och vision

**settings.json** (`exempel-settings.json` / `example-settings.json`)
- Komplett settings.json exempel
- Alla hooks konfigurerade:
  - SessionStart
  - UserPromptSubmit (UFC + Skills)
  - Stop (Validation + Voice)
  - PreToolUse (Logging)
- Environment variables
- Auto-approve tools
- Voice configuration
- Security settings

**Directory Structure** (`exempel-directory-structure.md` / `example-directory-structure.md`)
- Komplett .claude/.claude/ struktur
- Alla directories förklarade
- Filstorlekar approximativt
- Init script för setup
- Best practices
- Git repository struktur

---

## 🚀 Hur du Använder Exemplen

### Steg 1: Välj Språk
Alla exempel finns på både svenska (sv/) och engelska (en/)

### Steg 2: Kopiera och Anpassa

**UFC Context:**
```bash
# Skapa ditt första projekt-context
cp examples/sv/exempel-ufc-tier1.md ~/.claude/.claude/context/projects/mitt-projekt-tier1.md
# Redigera och fyll i din projektinfo
```

**Skill:**
```bash
# Lägg till research skill
mkdir -p ~/.claude/.claude/skills/research
cp examples/sv/exempel-skill-research.md ~/.claude/.claude/skills/research/SKILL.md
# Ersätt <VOICE_ID_RESEARCH> med ditt ElevenLabs voice ID
```

**Hooks:**
```bash
# Installera hooks
cp examples/sv/exempel-hook-session-start.ts ~/.claude/.claude/hooks/session-start.ts
cp examples/sv/exempel-hook-stop-validation.ts ~/.claude/.claude/hooks/stop-validation.ts
```

**PAI.md:**
```bash
# Skapa din PAI.md från template
cp examples/sv/exempel-PAI-template.md ~/.claude/.claude/PAI.md
# Fyll i alla <PLACEHOLDER> med din information
```

**Settings:**
```bash
# Använd exempel settings.json som utgångspunkt
cp examples/sv/exempel-settings.json ~/.claude/.claude/settings.json
# Anpassa efter dina behov
```

### Steg 3: Testa
```bash
# Starta Claude Code
claude

# Hooks körs automatiskt!
# PAI.md laddas vid session start
# UFC context laddas vid dina prompts
# Voice triggas när du svarar
```

---

## 🎯 Exempel Use Cases

### Use Case 1: Nytt Projekt Setup
1. Kopiera `exempel-ufc-tier1.md` → `mitt-projekt-tier1.md`
2. Fyll i projektinfo (namn, stack, status)
3. Skriv prompt: "Help me with my e-commerce project"
4. UFC hook laddar automatiskt rätt context!

### Use Case 2: Lägg till Research Skill
1. Kopiera `exempel-skill-research.md` → `~/.claude/.claude/skills/research/SKILL.md`
2. Hitta din voice på ElevenLabs Voice Library
3. Ersätt `<VOICE_ID_RESEARCH>` med ditt ID
4. Skriv prompt: "Research the latest AI papers"
5. Dr. Alice Mitchell aktiveras automatiskt!

### Use Case 3: Aktivera Voice Feedback
1. Kopiera `exempel-hook-stop-validation.ts` → hooks/
2. Sätt `VOICE_ENABLED=true` i settings.json
3. Starta voice-server (se Voice System docs)
4. Alla svar triggar voice feedback automatiskt!

---

## 📖 Relaterad Dokumentation

**Svenska:**
- [UFC System](../sv/03-UFC-SYSTEMET.md)
- [Skills System](../sv/04-SKILLS-SYSTEMET.md)
- [Hooks & Automation](../docs/06-bilingual/svenska/hooks-automation.md)
- [Voice System](../sv/05-ROST-SYSTEMET.md)
- [Installation](../docs/06-bilingual/svenska/installation.md)

**English:**
- [UFC System](../docs/02-core-concepts/ufc-context.md)
- [Skills System](../docs/02-core-concepts/skills.md)
- [Hooks & Automation](../docs/02-core-concepts/hooks.md)
- [Voice System](../docs/02-core-concepts/voice.md)
- [Installation](../docs/01-getting-started/installation.md)

---

## ✅ Checklista: Komplett Setup

Efter att ha använt alla exempel ska du ha:

- [ ] PAI.md med din identitet
- [ ] UFC context för dina projekt (Tier 1, 2, 3)
- [ ] Minst 2 skills aktiverade (engineering + research?)
- [ ] SessionStart hook (laddar PAI.md)
- [ ] UserPromptSubmit hooks (UFC + Skills)
- [ ] Stop hook (validation + voice)
- [ ] settings.json konfigurerad
- [ ] MCP servers installerade (GitHub, Zotero, etc.)
- [ ] (Valfritt) Voice system aktiverat

**När allt är setup:** Du har ett fullt fungerande Ogmios PAI system! 🚀

---

**Version:** 1.0
**Skapad:** 2025-11-09
**Språk:** Svenska & English (Bilingual)
