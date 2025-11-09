# Röstsystemet - Flerstämmig AI-feedback

[🇬🇧 English](../docs/02-core-concepts/voice.md) | [🇸🇪 Svenska](05-ROST-SYSTEMET.md)

---

## Vad är Röstsystemet?

**Valfritt** flerstämmigt feedbacksystem via **ElevenLabs** som ger varje skill sin egen unika röst.

**Varför röster?**
- 🎧 **Multitasking** - Hör status utan att titta på skärm
- 🗣️ **Kontext** - Rösten berättar VEM som arbetade
- 🚀 **Framtid** - Bygger mot Digital Assistant (DA)

---

## Hur det Fungerar

### 1. Skills har Röster

Varje skill har en ElevenLabs-röst:

```yaml
# engineering/SKILL.md
voice_id: <VOICE_ID_ENGINEERING>
voice_name: George Foster
voice_accent: British
voice_gender: male
```

### 2. COMPLETED Tags

Varje svar slutar med:

```markdown
🎯 COMPLETED: [SKILL:engineering] Task implemented successfully
🗣️ CUSTOM COMPLETED: Implementation complete
```

### 3. Voice Routing

```
[SKILL:engineering] → George Foster (British male)
[SKILL:research] → Alice Mitchell (British female)
[SKILL:swedish-academic-writing] → Prof. Lars (Swedish male)
```

### 4. Text-to-Speech

ElevenLabs läser upp CUSTOM COMPLETED-texten i rätt röst.

---

## Röst-accent = Språk

**KRITISKT:** Röstens accent bestämmer språket, INTE användarens input!

**British voices** (George, Alice, Marcus):
- ✅ ALLTID engelska text
- ❌ ALDRIG svenska text (låter onaturligt)

**Swedish voices** (Prof. Lars):
- ✅ ALLTID svenska text
- ❌ ALDRIG engelska text

**Exempel:**
```
User (på svenska): "Bygg en funktion"
  ↓
Engineering skill (British voice) aktiveras
  ↓
Completion MÅSTE vara på engelska:
🎯 COMPLETED: [SKILL:engineering] Function built
🗣️ CUSTOM COMPLETED: Function ready
```

---

## Setup

### 1. Skaffa ElevenLabs API-nyckel

1. Gå till [elevenlabs.io](https://elevenlabs.io)
2. Skapa konto
3. Settings → API Keys
4. Kopiera nyckel

### 2. Lägg till i Environment

```json
// ~/.claude/settings.json
{
  "env": {
    "ELEVENLABS_API_KEY": "sk_..."
  }
}
```

### 3. Välj Röster

1. Gå till [Voice Library](https://elevenlabs.io/voice-library)
2. Välj röster du gillar
3. Kopiera voice ID
4. Uppdatera i skill-filer

```yaml
# skills/engineering/SKILL.md
voice_id: abc123xyz  # Din valda röst
```

---

## Specialized AI Assistants Röster (Förslag)

**Engineering - George Foster:**
- Accent: British male
- Personality: Professional, methodical
- Suggested: Sök "British professional male" i Voice Library

**Research - Alice Mitchell:**
- Accent: British female
- Personality: Curious, analytical
- Suggested: Sök "British female academic"

**Knowledge Management - Marcus Thompson:**
- Accent: British male
- Personality: Clear, articulate
- Suggested: Sök "British narrator male"

**Swedish Academic - Prof. Lars Bergström:**
- Accent: Swedish male
- Personality: Academic, authoritative
- Suggested: Sök "Swedish male" eller använd svensk röst

---

## Valfritt System

**Röstsystemet är helt valfritt!**

Ogmios fungerar perfekt utan röster - du får bara text-output.

Men röster ger:
- Rikare användarupplevelse
- Multitasking-möjlighet
- Bygger mot DA-framtid

---

**Tillbaka:** [Skills System](04-SKILLS-SYSTEMET.md) | **Nästa:** [Hooks](06-HOOKS-AUTOMATION.md)
