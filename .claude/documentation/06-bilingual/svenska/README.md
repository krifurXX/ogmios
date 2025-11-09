# Ogmios Dokumentation (Svenska)

Välkommen till den svenska dokumentationen för Ogmios - din personliga AI-infrastruktur!

## Dokumentation i Denna Sektion

### Kom Igång
- **[Översikt](oversikt.md)** - Vad är Ogmios och varför behöver du det?
- **[Installation](installation.md)** - Steg-för-steg installationsguide
- **[Felsökning](felsökning.md)** - Vanliga problem och lösningar

### Kärnkoncept
- **[UFC-Systemet](ufc-systemet.md)** - Persistent minne och kontexthantering
- **[Skills-Systemet](skills-systemet.md)** - Specialiserade AI-experter
- **[Röstsystemet](rost-systemet.md)** - Flerstämmig feedback (valfritt)
- **[Hooks & Automation](hooks-automation.md)** - Händelsedriven automation

### Arkitektur & Design
- **[Arkitektur](arkitektur.md)** - Systemdesign och komponenter

### Integration
- **[MCP-Integration](mcp-integration.md)** - Anslut externa verktyg (Zotero, Obsidian)

### Avancerat
- **[Regelefterlevnad](regelefterlevnad.md)** - Säkerhet och systemregler

### Vanliga Frågor
- **[FAQ](faq.md)** - Vanliga frågor och svar

---

## Snabbnavigering

### För Nya Användare
1. Börja med [Översikt](oversikt.md) för att förstå vad Ogmios är
2. Följ [Installation](installation.md) för att sätta upp systemet
3. Läs om [UFC-Systemet](ufc-systemet.md) för att förstå hur minnet fungerar
4. Utforska [Skills-Systemet](skills-systemet.md) för specialiserade experter

### För Erfarna Användare
1. Gå direkt till [Installation](installation.md)
2. Konfigurera [MCP-Integration](mcp-integration.md)
3. Utforska [Regelefterlevnad](regelefterlevnad.md)

---

## Tvåspråkig Funktionalitet

Ogmios har fullständigt stöd för både svenska och engelska:

**Automatisk Språkdetektering:**
- Svarar på svenska när du skriver på svenska
- Svarar på engelska när du skriver på engelska
- Blandad terminologi (svenska/engelska) fungerar naturligt

**Svenska Röster:**
- **Gunnar** (Ogmios Svenska) - Systemröst för svenska svar
- **Maja** (Svenska Akademiker) - Professor Lars Bergström
- **Anton** (Svenska Forskare) - För svensk akademisk forskning

**Engelsk Dokumentation:**
- [English Documentation](../../README.md)
- [Getting Started (English)](../../01-getting-started/)
- [Core Concepts (English)](../../02-core-concepts/)

---

## Systemstruktur

```
~/.claude/.claude/
├── PAI.md              # Kärnidentitet (tvåspråkig)
├── context/
│   ├── UFC.md          # UFC-systemöversikt
│   ├── projects/       # Projektkontexter
│   ├── languages/
│   │   └── bilingual.md   # Tvåspråkig konfiguration
│   └── memory/
│       ├── decisions.md   # Arkitekturbeslut
│       └── learnings.md   # Lärdomar
├── skills/             # Specialiserade experter
└── hooks/              # Automation
```

---

## Exempel på Användning

### Svensk Akademisk Forskning
```
Du: "Hjälp mig skriva ett abstract för min avhandling om AI-etik"
    ↓
Professor Lars Bergström aktiveras
    ↓
Svarar på akademisk svenska
    ↓
Använder svensk akademisk stil
    ↓
Majas röst bekräftar när klar
```

### Teknisk Dokumentation (Blandat)
```
Du: "Skapa en README för mitt TypeScript-projekt"
    ↓
Lily (Technical Writer) aktiveras
    ↓
Svarar på svenska med engelsk terminologi
    ↓
Följer svenska konventioner
```

---

## Viktig Information

**Ogmios Talar Alltid Engelska:**
Systemrösten "Ogmios" använder alltid engelska, även när du skriver på svenska. Andra specialister (som Professor Lars Bergström) svarar på det språk du använder.

**Röstbekräftelser:**
- Alla röstbekräftelser innehåller nyckelorden "COMPLETED" och "CUSTOM COMPLETED" på engelska
- Detta säkerställer att röstsystemet fungerar korrekt
- Resten av svaret kan vara på svenska

**Tekniska Termer:**
Många tekniska termer behålls på engelska även i svenska svar:
- "hook" istället för "krok"
- "skill" istället för "färdighet"
- "context" istället för "sammanhang"

Detta är naturligt i svensk teknisk kommunikation.

---

## Snabbreferens

| Koncept | Plats | Nyckelfördel |
|---------|-------|--------------|
| UFC | `~/.claude/.claude/context/` | Persistent minne |
| Skills | `~/.claude/.claude/skills/` | Specialiserad expertis |
| Hooks | `~/.claude/.claude/hooks/` | Automation |
| Röst | `~/.claude/voice-server/` | Flerstämmig feedback |

---

## Behöver Hjälp?

- **Installationsproblem**: Se [Felsökning](felsökning.md)
- **Vanliga Frågor**: Se [FAQ](faq.md)
- **English Support**: Visit [English Documentation](../../README.md)
- **Tekniska Detaljer**: Läs [Arkitektur](arkitektur.md)

---

## Nästa Steg

Efter att ha förstått grunderna:

**Lär Dig Mer:**
- [UFC-Systemet](ufc-systemet.md) - Hur minnet fungerar
- [Skills-Systemet](skills-systemet.md) - Specialiserade experter
- [Arkitektur](arkitektur.md) - Systemdesign

**Anpassa:**
- Skapa egna projektkontexter
- Konfigurera MCPs (Zotero, Obsidian)
- Bygg egna skills

**Bidra:**
- [Contributing Guidelines](../../../CONTRIBUTING.md) (på engelska)
- Dela dina svenska exempel
- Förbättra översättningar

---

**Byggt med ❤️ för svensk/engelsk tvåspråkig AI-kommunikation**

[← Tillbaka till Huvuddokumentation](../../README.md)
