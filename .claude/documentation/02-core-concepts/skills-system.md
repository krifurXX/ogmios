# Skills System - Specialized AI Assistants

[🇬🇧 English](skills-system.md) | [🇸🇪 Svenska](../06-bilingual/svenska/skills-systemet.md)

---

## What are Skills?

**Skills** = Specialized AI personalities for different task types

Instead of one generic assistant, you get a **team of experts**:
- **George Foster** (Engineering) - Code & debugging
- **Dr. Emma Roberts** (Architecture) - System design
- **Alice Mitchell** (Research) - Research
- **Marcus Thompson** (Knowledge Mgmt) - Content creation
- **Prof. Lars Bergström** (Swedish Academic) - Swedish academic text

---

## Why Skills?

**Problem with generic AI:**
- Everything sounds the same
- No specialization
- Hard to know who's "talking"

**Solution with Skills:**
- Different experts for different tasks
- Automatic activation (no manual selection!)
- Unique voices via ElevenLabs

---

## Specialized AI Assistants

### George Foster (Engineering)
**Voice:** British male  
**Expertise:** TypeScript, Python, debugging  
**Triggers:** build, implement, fix, refactor

### Dr. Emma Roberts (Architecture)
**Voice:** British female  
**Expertise:** System design, ADRs  
**Triggers:** design, architect, plan

### Alice Mitchell (Research)
**Voice:** British female  
**Expertise:** Web research, information gathering  
**Triggers:** research, investigate, find

### Marcus Thompson (Knowledge Management)
**Voice:** British male  
**Expertise:** Content creation, documentation  
**Triggers:** write, create content, document

### Prof. Lars Bergström (Swedish Academic)
**Voice:** Swedish male  
**Expertise:** Swedish academic writing  
**Triggers:** svensk, akademisk, rapport

---

## Automatic Activation

**You DON'T need to ask for a skill!** System detects automatically:

```
User: "Build a markdown parser"
  ↓
Hook analyzes: "Build" = code implementation
  ↓
Activates: engineering skill (George Foster)
  ↓
Response from George Foster in British male voice
```

---

## Create Custom Skill

```bash
mkdir -p ~/.claude/.claude/skills/my-skill
nano ~/.claude/.claude/skills/my-skill/SKILL.md
```

See [example](../examples/example-skill-engineering.md)

---

**Back:** [UFC System](03-UFC-SYSTEM.md) | **Next:** [Voice System](05-VOICE-SYSTEM.md)
