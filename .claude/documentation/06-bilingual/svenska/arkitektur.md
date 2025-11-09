# Ogmios Arkitektur

[🇬🇧 English](../docs/03-architecture/system-design.md) | [🇸🇪 Svenska](02-ARKITEKTUR.md)

---

## Översikt

Ogmios bygger på en **4-lagers arkitektur** där varje lager spelar en specifik roll i att göra din AI-assistent intelligent, kontextmedveten och automatiserad.

```
┌──────────────────────────────────────────────┐
│  Layer 4: VOICE SYSTEM (Valfritt)           │
│  Multi-voice feedback via ElevenLabs         │
└──────────────────┬───────────────────────────┘
                   │
┌──────────────────┴───────────────────────────┐
│  Layer 3: SKILLS SYSTEM                      │
│  Specialized AI personalities (British Team) │
└──────────────────┬───────────────────────────┘
                   │
┌──────────────────┴───────────────────────────┐
│  Layer 2: HOOKS & AUTOMATION                 │
│  Event-driven context loading & validation   │
└──────────────────┬───────────────────────────┘
                   │
┌──────────────────┴───────────────────────────┐
│  Layer 1: UFC (Universal File-based Context) │
│  The foundation - filesystem as context      │
└──────────────────────────────────────────────┘
```

---

## Layer 1: UFC - Universal File-based Context

**Filosofi:** "Filsystemet ÄR kontextsystemet"

### Vad är UFC?

UFC är den centrala nervsystemet i Ogmios. Istället för att krama in allt i en enda `claude.md`-fil eller förlita sig på att AI:n kommer ihåg saker, organiserar UFC all kunskap i **logiska, hierarkiska markdown-filer** som laddas **exakt när de behövs**.

### Katalogstruktur

```
~/.claude/.claude/context/
├── UFC.md                  # Systembeskrivning
├── tools/                  # Verktyg och MCP-servrar
│   ├── tools.md
│   ├── mcps.md
│   └── commands.md
├── projects/               # Projektspecifik kontext
│   ├── project-a.md
│   └── project-b.md
├── preferences/            # Användarpreferenser
│   ├── stack.md
│   ├── coding-style.md
│   └── languages.md
├── memory/                 # Beslut och lärdomar
│   ├── decisions/
│   │   ├── INDEX.md
│   │   └── active/
│   │       ├── 001-ufc-system.md
│   │       └── 002-skills-activation.md
│   └── learnings.md
└── languages/              # Flerspråksstöd
    ├── bilingual.md
    ├── swedish.md
    └── english.md
```

### Progressive Disclosure

UFC använder **tre nivåer** av kontextdjup:

**Tier 1: Metadata (Alltid laddad)**
- Snabb översikt (<5KB)
- INDEX-filer med sammanfattningar
- Möjliggör snabb sökning

**Tier 2: Kärninnehåll (Laddat vid behov)**
- Fullständiga dokumentationsfiler
- Laddas när kontext behövs
- Vanligtvis 10-50KB per fil

**Tier 3: Djup kontext (Laddat vid explicit behov)**
- Detaljerad arkiverad data
- Historiska beslut
- Laddas endast när specifikt efterfrågat

### Exempel: Kontextflöde

```
1. User: "Let's work on the machine learning project"
   ↓
2. UserPromptSubmit hook triggas
   ↓
3. Intent detection: "machine learning project"
   ↓
4. Laddar automatiskt:
   - context/projects/ml-project.md
   - context/tools/python-ml-stack.md
   - context/preferences/coding-style.md
   ↓
5. AI får exakt rätt kontext för uppgiften
```

### Nesting Guidelines

**VIKTIGT:** Håll nesting till **max 3 nivåer djupt**

✅ **Bra:** `context/tools/mcps.md`
✅ **Bra:** `context/projects/ml-project/team.md`
⚠️ **Försiktigt:** `context/projects/ml-project/docs/api.md` (3 nivåer)
❌ **Undvik:** `context/projects/ml-project/docs/api/v2.md` (4 nivåer)

**Varför?** Kontexthydrering blir opålitlig bortom 3 nivåer.

[Läs mer: UFC-systemet](03-UFC-SYSTEMET.md)

---

## Layer 2: Hooks & Automation

**Koncept:** Event-driven automatisering som gör systemet intelligent

### Vad är Hooks?

Hooks är skript (TypeScript/Bash) som körs automatiskt vid specifika händelser i Claude Code. De gör Ogmios **proaktivt** istället för **reaktivt**.

### Hook-typer

#### 1. SessionStart
**När:** Vid start av ny session
**Användning:** Ladda kärnidentitet (PAI.md), välkomstmeddelande

```typescript
// session-start.ts
export default async function() {
  // Ladda PAI.md (kärnidentitet)
  // Visa välkomstmeddelande
  // Konfigurera miljö
}
```

#### 2. UserPromptSubmit
**När:** INNAN AI svarar på användarens prompt
**Användning:** Ladda kontext, aktivera skills, detektera intent

```typescript
// load-ufc-context.ts
export default async function({ userMessage }) {
  // 1. Detektera intent (projekt, språk, uppgiftstyp)
  // 2. Ladda relevant UFC-kontext
  // 3. Aktivera matchande skill
  // 4. Returnera context till AI
}
```

**Detta är den mest kraftfulla hooken!** Den är hjärtat av UFC-systemet.

#### 3. Stop
**När:** EFTER att AI har genererat svar
**Användning:** Validering, röstgenerering, logging

```typescript
// completion-validator.ts
export default async function({ assistantMessage }) {
  // 1. Validera output-format
  // 2. Extrahera COMPLETED-tag
  // 3. Trigga röstsyntes (om aktiverat)
  // 4. Logga händelse
}
```

#### 4. PreToolUse / PostToolUse
**När:** Före/efter verktygsanvändning (Read, Write, Bash, etc.)
**Användning:** Logging, säkerhetsvalidering

```typescript
// capture-all-events.ts
export default async function({ tool, params }) {
  // Logga verktygsanvändning för observability
}
```

### Hook Execution Flow

```
User skriver prompt
    ↓
UserPromptSubmit hooks kör
    ├─ load-ufc-context.ts (laddar kontext)
    ├─ skill-activation-enforcer.ts (aktiverar skill)
    └─ capture-all-events.ts (loggar)
    ↓
AI genererar svar (med laddad kontext & aktiverad skill)
    ↓
Stop hooks kör
    ├─ completion-validator.ts (validerar format)
    ├─ stop-hook.ts (röstgenerering)
    └─ capture-all-events.ts (loggar)
    ↓
Användaren ser/hör resultat
```

[Läs mer: Hooks & Automation](06-HOOKS-AUTOMATION.md)

---

## Layer 3: Skills System - Specialized AI Assistants

**Koncept:** Specialiserade AI-personligheter för olika uppgiftstyper

### Varför Skills?

Istället för en generisk AI-assistent som kan "lite av allt" får du ett **team av specialister** som är **experter** inom sina områden.

### Skills-struktur

Varje skill definieras i en `SKILL.md`-fil:

```yaml
---
name: engineering
description: Senior software engineering specialist
triggers:
  - code
  - implement
  - build
  - debug
  - refactor
voice_id: <VOICE_ID_ENGINEERING>
voice_name: George Foster
voice_accent: British
voice_gender: male
---

# Engineering Skill

## När att använda
- Kodimplementering
- Debugging
- Performance-optimering
- Refactoring

## George Fosters Expertis
- TypeScript, Python, modern web
- Systematisk felsökning
- Best practices & design patterns

## Workflow
1. Förstå kravet
2. Planera approach
3. Implementera systematiskt
4. Verifiera funktionalitet
5. Dokumentera beslut
```

### Specialized AI Assistants (Exempel)

**Engineering - George Foster** (British male)
- Kodimplementering, debugging, optimering
- Stack: TypeScript, Python
- Triggers: "build", "implement", "fix", "refactor"

**Architecture - Dr. Emma Roberts** (British female)
- Systemdesign, tekniska specifikationer
- ADRs, teknologi-utvärdering
- Triggers: "design", "architect", "plan system"

**Research - Alice Mitchell** (British female)
- Forskning, informationsinsamling
- Webbsökningar, dokumentanalys
- Triggers: "research", "find information", "investigate"

**Knowledge Management - Marcus Thompson** (British male)
- Innehållsskapande, dokumentation
- PKM (Personal Knowledge Management)
- Triggers: "write", "create content", "document"

**Swedish Academic Writing - Prof. Lars Bergström** (Swedish male)
- Svensk akademisk text
- Forskningsrapporter, artiklar
- Triggers: "svensk", "akademisk", "rapport"

### Automatisk Skill-aktivering

**Ingen manuell aktivering behövs!** Systemet detekterar automatiskt:

```
User: "Build a markdown parser"
    ↓
UserPromptSubmit hook analyserar prompt
    ↓
Detekterar: kod-implementation
    ↓
Aktiverar: engineering skill (George Foster)
    ↓
George Foster implementerar koden
    ↓
British male voice läser upp completion
```

### Tier 1/2/3 Skills

**Tier 1 (Auto-aktivering - ingen bekräftelse):**
- engineering, architecture, research, knowledge-management
- security, design, devops, data-analysis
- swedish-academic-writing, academic-research

**Tier 2 (På begäran - valfri bekräftelse):**
- prompting, fabric, swedish-content

**Tier 3 (Specialiserade - bekräftelse rekommenderat):**
- agent-observability, ffuf, create-skill

[Läs mer: Skills-systemet](04-SKILLS-SYSTEMET.md)

---

## Layer 4: Voice System (Valfritt)

**Koncept:** Flerstämmig feedback via ElevenLabs

### Varför Röster?

Olika röster för olika skills ger:
- **Multitasking** - Hör status utan att titta på skärm
- **Kontext** - Rösten berättar VEM som arbetade (George, Alice, etc.)
- **Framtidssäkring** - Bygger mot Digital Assistant (DA)

### Voice Routing

```
engineering skill → George Foster (British male)
research skill → Alice Mitchell (British female)
swedish-academic-writing → Prof. Lars (Swedish male)
```

### COMPLETED Tags

Varje svar slutar med:

```markdown
🎯 COMPLETED: [SKILL:engineering] [Task description]
🗣️ CUSTOM COMPLETED: [Voice-optimized short version]
```

**COMPLETED-taggen triggar:**
1. Extrahering av `[SKILL:name]`
2. Mappning till rätt röst-ID
3. Röstsyntes via ElevenLabs API
4. Uppläsning av CUSTOM COMPLETED-text

### Språkanpassning

**Röstaccent bestämmer språk (INTE användarens input):**

- **British voices** (George, Alice, Marcus) → ALLTID engelska text
- **Swedish voices** (Prof. Lars) → ALLTID svenska text
- **Neutral voices** → Matchar användarens input-språk

**Varför?** En brittisk accent + svensk text = onaturlig röstoutput.

[Läs mer: Röstsystemet](05-ROST-SYSTEMET.md)

---

## Hur Lagren Samverkar

### Scenario: Användare vill bygga en funktion

```
1. ANVÄNDARE: "Build a user authentication feature"

2. LAYER 2 (Hooks): UserPromptSubmit triggas
   ├─ load-ufc-context.ts
   │  ├─ Detekterar: kod-implementation
   │  └─ Laddar: context/preferences/coding-style.md
   │
   └─ skill-activation-enforcer.ts
      └─ Aktiverar: engineering skill (George Foster)

3. LAYER 1 (UFC): Kontext laddad
   ├─ Kodstil-preferenser
   ├─ Stack-val (TypeScript, bun)
   └─ Säkerhetsriktlinjer

4. LAYER 3 (Skills): Engineering skill aktiv
   ├─ George Foster's expertis tillämpas
   ├─ Best practices följs
   └─ Kod implementeras

5. AI SVARAR:
   - Implementerar authentication feature
   - Följer kodstil från UFC
   - Använder prefererad stack

6. LAYER 2 (Hooks): Stop triggas
   └─ completion-validator.ts
      ├─ Extraherar: [SKILL:engineering]
      └─ Förbereder röst-output

7. LAYER 4 (Voice): Röstsyntes (om aktiverad)
   ├─ Mappar till: George Foster's voice ID
   └─ Läser upp: "Authentication feature implemented"

8. ANVÄNDARE: Hör completion i George Foster's röst
```

---

## Designprinciper

### 1. System > Model
En väldesignad arkitektur med en genomsnittlig modell slår dålig design med bästa modellen.

### 2. Progressive Disclosure
Ladda bara det som behövs, när det behövs. Ingen "context bloat".

### 3. Observable Actions = Trust
AI:n **visar** vad den gör (laddar filer, aktiverar skills), inte bara **säger** det.

### 4. Composition over Complexity
Små, sammansättningsbara delar (UFC + Skills + Hooks) bygger komplexare beteenden.

### 5. Text as Thought Primitives
Markdown är bara ett hopp från ren tanke. Allt är text, allt är versionshanterat.

---

## Skalbarhet

### Context Efficiency

**Före UFC:**
- 200KB+ context per prompt
- Slow, opålitlig loading
- Context window-problem

**Efter UFC:**
- <30KB Tier 1 metadata
- Snabb, målad loading
- Skalas obegränsat med arkivering

### Skills Scalability

**Skills är modulära:**
- Lägg till nya skills utan att påverka befintliga
- Skills kan dela UFC-context
- Enkelt att distribuera och återanvända

### Hook Composability

**Hooks är oberoende:**
- Lägg till/ta bort hooks utan systemändringar
- Varje hook gör EN sak bra (Unix-filosofi)
- Lätt att debugga och underhålla

---

## Jämförelse: Vanilla Claude vs Ogmios

| Aspekt | Vanilla Claude | Ogmios PAI |
|--------|----------------|------------|
| **Context** | Lost between sessions | Persists via UFC |
| **Specialization** | Generalist | Team of experts (Skills) |
| **Automation** | Manual | Event-driven (Hooks) |
| **Voices** | One (or text-only) | Multiple (ElevenLabs) |
| **Language** | Single-language focused | Bilingual (SV/EN) seamless |
| **Preferences** | Re-explain every time | Define once, use everywhere |
| **Scalability** | Limited by context window | Unlimited (progressive disclosure) |
| **Observability** | Black box | Full logging & validation |

---

## Nästa Steg

- **Djupdykning:** Läs om varje lager i detalj
  - [UFC-systemet](03-UFC-SYSTEMET.md)
  - [Skills-systemet](04-SKILLS-SYSTEMET.md)
  - [Röstsystemet](05-ROST-SYSTEMET.md)
  - [Hooks & Automation](06-HOOKS-AUTOMATION.md)

- **Implementation:** Följ installationsguiden
  - [Installationsguide](08-INSTALLATION.md)

- **Exempel:** Se praktiska användningsfall
  - [Exempel](../examples/)

---

**Tillbaka till:** [README](01-README.md) | **Dokumentation:** [Svenska](../sv/) | [English](../en/)
