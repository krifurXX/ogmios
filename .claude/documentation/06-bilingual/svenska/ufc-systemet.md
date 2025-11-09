# UFC - Universal File-based Context System

[🇬🇧 English](../docs/02-core-concepts/ufc-context.md) | [🇸🇪 Svenska](03-UFC-SYSTEMET.md)

---

## Vad är UFC?

**UFC (Universal File-based Context)** är kärnan i Ogmios - ett filbaserat system som laddar exakt rätt kontext vid exakt rätt tidpunkt.

**Central filosofi:** "Filsystemet ÄR kontextsystemet"

Istället för:
- ❌ Allt i en enda claude.md
- ❌ Förlita sig på AI:ns minne
- ❌ Re-förklara preferenser varje session

Får du:
- ✅ Logisk, hierarkisk organisation
- ✅ Automatisk kontextladdning
- ✅ Preferenser definierade en gång, används överallt
- ✅ Kontext som överlever mellan sessioner

---

## Katalogstruktur

```
~/.claude/.claude/context/
├── UFC.md                  # Systembeskrivning
├── tools/                  # Verktyg och MCP
│   ├── tools.md
│   ├── mcps.md
│   └── commands.md
├── projects/               # Projekt-kontext
│   ├── project-a.md
│   └── project-b.md
├── preferences/            # Användarpreferenser
│   ├── stack.md
│   ├── coding-style.md
│   └── languages.md
├── memory/                 # Minne och beslut
│   ├── decisions/
│   │   ├── INDEX.md
│   │   └── active/
│   └── learnings.md
└── languages/              # Språkstöd
    ├── bilingual.md
    ├── swedish.md
    └── english.md
```

---

## Progressive Disclosure

UFC använder **3 nivåer** för att balansera snabbhet och djup:

### Tier 1: Metadata (Alltid laddad)
- **Storlek:** <5KB
- **Innehåll:** INDEX-filer, sammanfattningar
- **Syfte:** Snabb översikt, möjliggör sökning
- **Exempel:** `memory/decisions/INDEX.md`

### Tier 2: Kärninnehåll (Laddat vid behov)
- **Storlek:** 10-50KB per fil
- **Innehåll:** Fullständiga dokumentationsfiler
- **Syfte:** Djup kontext för specifika uppgifter
- **Exempel:** `projects/ml-project.md`, `preferences/stack.md`

### Tier 3: Djup kontext (Laddat vid explicit begäran)
- **Storlek:** Obegränsat
- **Innehåll:** Arkiverad data, historia
- **Syfte:** Detaljerad research, analys
- **Exempel:** `memory/learnings-archive/2025-10.md`

---

## Hur UFC Fungerar

### 1. Intent Detection

När du skriver en prompt analyseras den för att identifiera intent:

```
User: "Let's work on the machine learning project"
       ↓
Detekterade intents:
- Project: "machine learning"
- Domain: "ML/AI"
```

### 2. Context Mapping

Baserat på detekterade intents mappas till relevanta context-filer:

```yaml
Intent: "machine learning project"
  ↓
Laddar:
  - projects/ml-project.md
  - tools/python-ml-stack.md
  - preferences/coding-style.md
  - preferences/stack.md
```

### 3. Dynamic Loading

UserPromptSubmit-hooken laddar context automatiskt:

```typescript
// Hook laddar filer baserat på intent
const context = {
  "ml-project.md": "# ML Project\n...",
  "python-ml-stack.md": "# Python ML Stack\n...",
  "stack.md": "# Technology Stack\n..."
};

// Context injiceras som system message
return { systemMessage: buildContext(context) };
```

### 4. AI Response

AI:n får exakt den kontext som behövs:

```
AI har nu:
- Projektdetaljer (ml-project.md)
- ML-verktyg (python-ml-stack.md)
- Kodstil (coding-style.md)
- Stack-preferenser (stack.md)
  ↓
Kan svara med full kunskap om projektet!
```

---

## Context-filer i Detalj

### tools/tools.md
**Innehåll:** Översikt av alla tillgängliga verktyg
**Används när:** Frågor om verktyg, capabilities

### tools/mcps.md
**Innehåll:** MCP server-konfigurationer
**Används när:** MCP-relaterade uppgifter

### projects/[projekt-namn].md
**Innehåll:** Projektspecifik information
**Format:**
```markdown
# [Projektnamn]

## Overview
[Beskrivning]

## Tech Stack
- Language: [språk]
- Framework: [ramverk]

## Key Files
- Main: [path]
- Config: [path]

## Team (optional)
- [Roller och personer - använd <CONTACT_NAME> för anonymisering]
```

### preferences/stack.md
**Innehåll:** Teknologival och preferenser
**Format:**
```markdown
# Technology Stack Preferences

## Primary Language
TypeScript (preferred over Python)

## Package Managers
- JavaScript/TypeScript: bun
- Python: uv

## Frameworks
- Backend: [dina val]
- Frontend: [dina val]
```

### preferences/coding-style.md
**Innehåll:** Kodstil och konventioner
**Format:**
```markdown
# Coding Style Preferences

## General
- Indentation: 2 spaces
- Line length: 100 chars
- Semicolons: Yes (TypeScript)

## Naming
- Variables: camelCase
- Functions: camelCase
- Classes: PascalCase
- Constants: UPPER_SNAKE_CASE
```

### memory/decisions/INDEX.md
**Innehåll:** Översikt av alla ADRs (Architecture Decision Records)
**Format:**
```markdown
# Architecture Decision Records - Index

## Active Decisions

### ADR-001: UFC System
**Date:** 2025-10-20
**Status:** Active
**Summary:** Implement file-based context system
**File:** active/001-ufc-system.md
```

### memory/learnings.md
**Innehåll:** Lärdomar och insikter
**Format:**
```markdown
# Learnings Log - 2025-11

## 2025-11-09: Context Loading
**Learning:** Progressive disclosure reduces context bloat
**Impact:** 85% faster loading times
```

---

## Nesting Guidelines

**MAX 3 NIVÅER DJUPT!**

✅ **BRA:**
```
context/tools/mcps.md                    (2 nivåer)
context/projects/ml-project.md           (2 nivåer)
context/projects/ml-project/team.md      (3 nivåer - OK)
```

❌ **UNDVIK:**
```
context/projects/ml-project/docs/api.md  (4 nivåer - för djupt)
```

**Varför?** Kontexthydrering blir opålitlig bortom 3 nivåer.

---

## Exempel: Komplett Kontextflöde

```
🔹 STEG 1: User Input
User: "Implement authentication for the web project"

🔹 STEG 2: Intent Detection (i hook)
Detekterade intents:
- Task: "implementation"
- Domain: "authentication"
- Project: "web project"

🔹 STEG 3: Context Mapping
Mappning:
  "web project" → projects/web-project.md
  "authentication" → tools/auth-stack.md
  "implementation" → preferences/coding-style.md
  (alltid) → preferences/stack.md

🔹 STEG 4: File Loading
Laddar:
  ✅ projects/web-project.md (12KB)
  ✅ tools/auth-stack.md (8KB)
  ✅ preferences/coding-style.md (5KB)
  ✅ preferences/stack.md (4KB)
Total: 29KB context

🔹 STEG 5: Skill Activation
Intent "implementation" → engineering skill

🔹 STEG 6: AI Response
George Foster (engineering) får:
- Web project detaljer
- Auth stack info (JWT, OAuth, etc.)
- Kodstil-preferenser
- Tech stack (TypeScript + bun)
  ↓
Implementerar authentication med korrekt:
- Stack (TypeScript)
- Stil (camelCase, 2 spaces, etc.)
- Tools (JWT library från auth-stack.md)
- Projektstruktur (från web-project.md)
```

---

## Skapa Egna Context-filer

### 1. Identifiera Behov

Fråga dig:
- Förklarar jag samma sak om och om igen?
- Har jag projektspecifik information som AI behöver?
- Finns det preferenser jag vill bevara?

### 2. Välj Rätt Kategori

- **tools/** - Verktyg, MCP servers, kommandon
- **projects/** - Projektspecifik kontext
- **preferences/** - Personliga preferenser
- **memory/** - Beslut och lärdomar
- **languages/** - Språkspecifik info

### 3. Skapa Filen

```bash
# Exempel: Nytt projekt
nano ~/.claude/.claude/context/projects/my-project.md
```

### 4. Använd Tydlig Struktur

```markdown
# [Titel]

## Overview
[Vad är detta?]

## [Sektion 1]
[Innehåll]

## [Sektion 2]
[Innehåll]

## Related Files
- See also: [länk till relaterad fil]
```

### 5. Referera i Hooken

Uppdatera `load-ufc-context.ts` för att ladda din nya fil vid rätt intent.

---

## Best Practices

### ✅ GÖR:
- Håll filer fokuserade (en domän per fil)
- Använd tydliga rubriker
- Skriv i clean Markdown
- Länka till relaterade filer
- Uppdatera regelbundet

### ❌ UNDVIK:
- Duplicera information
- Nesta djupare än 3 nivåer
- Blanda kategorier
- Glömma att uppdatera gamla filer
- Skriva för långa filer (dela upp!)

---

## Underhåll

### Veckovis
- Granska `learnings.md`
- Lägg till nya insikter
- Uppdatera projekt-filer

### Månadsvis
- Arkivera gamla learnings
- Uppdatera INDEX-filer
- Städa bort föråldrat innehåll

### Vid Behov
- Lägg till nya projekt-contexts
- Uppdatera tool-configurations
- Expandera preferences

---

## Integration med Andra System

### Hooks
UFC laddas via `load-ufc-context.ts` hook

### Skills
Skills läser UFC-context för domänspecifik kunskap

### Voice System
Språk-context (languages/) bestämmer röstval

### MCP
MCP-konfiguration i `tools/mcps.md`

---

## Felsökning

### Problem: Context laddas inte

**Lösning:**
```bash
# Kontrollera att filer finns
ls ~/.claude/.claude/context/

# Testa hook manuellt
bun ~/.claude/.claude/hooks/load-ufc-context.ts --test
```

### Problem: Fel context laddas

**Lösning:**
- Granska intent-mappningen i hooken
- Kontrollera filnamn (case-sensitive!)
- Verifiera att filen innehåller rätt data

---

**Tillbaka till:** [README](01-README.md) | [Arkitektur](02-ARKITEKTUR.md) | **Nästa:** [Skills System](04-SKILLS-SYSTEMET.md)
