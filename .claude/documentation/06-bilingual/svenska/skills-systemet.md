# Skills System - Specialized AI Assistants

[🇬🇧 English](../docs/02-core-concepts/skills.md) | [🇸🇪 Svenska](04-SKILLS-SYSTEMET.md)

---

## Vad är Skills?

**Skills** = Specialiserade AI-personligheter för olika uppgiftstyper

Istället för en generisk assistent får du ett **team av experter**:
- **George Foster** (Engineering) - Kod & debugging
- **Dr. Emma Roberts** (Architecture) - Systemdesign
- **Alice Mitchell** (Research) - Forskning
- **Marcus Thompson** (Knowledge Mgmt) - Innehållsskapande
- **Prof. Lars Bergström** (Swedish Academic) - Svensk akademisk text

---

## Varför Skills?

**Problem med generisk AI:**
- Allt låter likadant
- Ingen specialisering
- Svårt att veta vem som "pratar"

**Lösning med Skills:**
- Olika experter för olika uppgifter
- Automatisk aktivering (ingen manuell väljning!)
- Unika röster via ElevenLabs

---

## Skill-struktur

```yaml
---
name: engineering
description: Senior software engineer
triggers:
  - code
  - implement
  - build
voice_id: <VOICE_ID>
voice_name: George Foster
voice_accent: British
---

# Engineering Skill
[Detaljerad workflow och expertis]
```

---

## Specialized AI Assistants

### George Foster (Engineering)
**Röst:** British male  
**Expertis:** TypeScript, Python, debugging  
**Triggers:** build, implement, fix, refactor

### Dr. Emma Roberts (Architecture)
**Röst:** British female  
**Expertis:** System design, ADRs  
**Triggers:** design, architect, plan

### Alice Mitchell (Research)
**Röst:** British female  
**Expertis:** Web research, information gathering  
**Triggers:** research, investigate, find

### Marcus Thompson (Knowledge Management)
**Röst:** British male  
**Expertis:** Content creation, documentation  
**Triggers:** write, create content, document

### Prof. Lars Bergström (Swedish Academic)
**Röst:** Swedish male  
**Expertis:** Swedish academic writing  
**Triggers:** svensk, akademisk, rapport

---

## Automatisk Aktivering

**Du behöver INTE be om skill!** Systemet detekterar automatiskt:

```
User: "Build a markdown parser"
  ↓
Hook analyserar: "Build" = kod-implementation
  ↓
Aktiverar: engineering skill (George Foster)
  ↓
Svar från George Foster i British male voice
```

---

## Skapa Egen Skill

```bash
mkdir -p ~/.claude/.claude/skills/my-skill
nano ~/.claude/.claude/skills/my-skill/SKILL.md
```

Se [exempel](../examples/example-skill-engineering.md)

---

**Tillbaka:** [UFC System](03-UFC-SYSTEMET.md) | **Nästa:** [Voice System](05-ROST-SYSTEMET.md)
