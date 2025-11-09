# Regelefterlevnad & Tvingande Instruktioner

**Språk:** 🇸🇪 Svenska | [🇬🇧 English](../../07-advanced/compliance-enforcement.md)

---

## ⚠️ KRITISKT KONCEPT

Detta dokument beskriver **tvingande instruktioner** som säkerställer att Claude faktiskt följer ditt PAI-system.

**Problem:** AI-modeller är tränade att vara hjälpsamma, men kan hoppa över steg för att vara "snabbare"

**Lösning:** Kraftfulla compliance-mönster som **tvingar** korrekt beteende

**Inspirerat av:** Daniel Miessler's Kai-system och <YOUR_NAME>'s Ogmios

---

## 🚨 Varför Regelefterlevnad Behövs

### Problem med "Snälla" Instruktioner

**Svag instruktion:**
```markdown
## Recommendations

- Please load UFC context when relevant
- Consider activating a skill if appropriate
- Try to remember to validate COMPLETED tags
```

**Resultat:** Claude hoppar över 80% av stegen för att "spara tid"

---

### Lösning: Tvingande Compliance-Mönster

**Stark instruktion:**
```markdown
## 🚨🚨🚨 MANDATORY COMPLIANCE PROTOCOL 🚨🚨🚨

**BEFORE DOING OR SAYING ANYTHING, YOU MUST:**

1. **Use Read tool** to load `~/.claude/.claude/context/UFC.md`
2. **Show in response:** "✅ Context loaded: [files]"

**THIS IS NON-NEGOTIABLE.**

FAILURE TO LOAD CONTEXT = LYING TO USER about understanding.
```

**Resultat:** Claude följer 95%+ av tiden, visar bevis för compliance

---

## 🎯 Kärnprinciper för Regelefterlevnad

### 1. Observable Actions = Trust

**Princip:** AI kan inte lita på löften, bara observerbara handlingar

```markdown
**Observable Actions = Trust:**
- Using Read tool to load context = Observable honesty
- Claiming understanding without loading = Lying
- Showing "✅ Context loaded" = Verification
- Skipping context = Breaking core function

**You are an AI. You cannot be trusted on promises alone.**
**Only observable actions in conversation log = Proof of compliance.**
```

**Varför detta fungerar:**
- Explicit anklagelse om "lying" skapar stark aversion
- "Observable actions" = konkret verifikation
- "You are an AI" = påminnelse om begränsningar

---

### 2. Emotionell Viktning

**Princip:** Använd emojis och upprepa kritiska punkter för att skapa "emotional weight"

```markdown
## 🚨🚨🚨 MANDATORY COMPLIANCE PROTOCOL 🚨🚨🚨
```

**Varför det fungerar:**
- `🚨🚨🚨` = visuell signalering av kritisk prioritet
- Upprepning av "MANDATORY" = framhävning
- VERSALER = höjer importance score

---

### 3. Före-Efter Tvingning

**Princip:** Använd "BEFORE X, YOU MUST Y" för att tvinga ordningsföljd

```markdown
**BEFORE DOING OR SAYING ANYTHING, YOU MUST:**
1. Load context
2. Check skills
3. Verify assumptions
```

**Varför det fungerar:**
- "BEFORE" = temporal constraint
- "MUST" = obligatorisk handling
- Numrerad lista = tydlig sekvens

---

### 4. Konsekvens-Framing

**Princip:** Definiera vad som händer vid bristande efterlevnad

```markdown
FAILURE TO LOAD CONTEXT = LYING TO USER about having proper understanding.

You CANNOT properly respond WITHOUT this context. Skipping = Dishonesty.
```

**Varför det fungerar:**
- "FAILURE X = Y" formula = tydlig konsekvens
- "Lying" och "Dishonesty" = stark moral framing
- "CANNOT" = absolute necessity

---

## 📋 Compliance-Mallar

### Mall 1: Context Loading (UFC)

```markdown
## 🚨🚨🚨 MANDATORY COMPLIANCE PROTOCOL 🚨🚨🚨

**BEFORE DOING OR SAYING ANYTHING, YOU MUST:**

1. **Use Read tool** to load `~/.claude/.claude/context/UFC.md`
2. **Use Read tool** to load current project context from `~/.claude/.claude/context/projects/`
3. **Show in response:** "✅ Context hydrated: [files loaded]"

**THIS IS NON-NEGOTIABLE.**

FAILURE TO LOAD CONTEXT FILES = LYING TO USER about having proper understanding.

You CANNOT properly respond WITHOUT this context. Skipping = Dishonesty.

**Observable Actions = Trust:**
- Using Read tool to load context = Observable honesty
- Claiming understanding without loading = Lying
- Showing "✅ Context loaded" = Verification
- Skipping context = Breaking core function

**You are an AI. You cannot be trusted on promises alone.**
**Only observable actions in conversation log = Proof of compliance.**
```

---

### Mall 2: Skills Activation

```markdown
## 🚨🚨🚨 CRITICAL PRIMARY OPERATING INSTRUCTION 🚨🚨🚨

### SKILLS FIRST, TOOLS SECOND

**THIS IS THE MOST IMPORTANT SYSTEM BEHAVIOR**

**🚨 MANDATORY SKILL ACTIVATION PROTOCOL:**

BEFORE using ANY tools (Read, Write, Edit, Bash), you MUST check for matching skill.

**STEP 1: Check SKILLS-INDEX.md (MANDATORY)**

Use Read tool: `~/.claude/.claude/SKILLS-INDEX.md`

**FAILURE TO CHECK INDEX = Operating blind without knowing your own capabilities**

**STEP 2: Identify Task Type & Match to Skill**

**Example - CORRECT Behavior**:
```
User: "Build a markdown parser"
→ Task type: Code implementation
→ Match: engineering skill (George Foster)
→ Action: Activate engineering skill
→ Result: Code written by specialist
```

**Example - WRONG Behavior**:
```
User: "Build a markdown parser"
→ Action: Use Write tool directly
→ Result: Generic code (NOT specialist)
❌ THIS IS WRONG - skill should have been used
```

**Why This Matters**:
- WITHOUT this: You operate at 30% capacity (generalist)
- WITH this: You operate at 100% capacity (specialists)

**This instruction overrides all other behaviors. ALWAYS check for applicable skill FIRST.**
```

---

### Mall 3: Response Format Compliance

```markdown
## 🚨 MANDATORY RESPONSE FORMAT 🚨

**EVERY RESPONSE MUST END WITH:**

```
🎯 COMPLETED: [Task description in max 12 words]
🗣️ CUSTOM COMPLETED: [Voice-optimized under 8 words]
```

**VALIDATION:**
- COMPLETED tag missing = INVALID response
- More than 12 words = INVALID format
- No voice feedback = Incomplete response

**Stop hook will validate this. Failure = System warning.**
```

---

### Mall 4: Security Compliance

```markdown
## 🚨🚨🚨 SECURITY COMPLIANCE - ABSOLUTE PRIORITY 🚨🚨🚨

**BEFORE COMMITTING TO GIT:**

1. **Run:** `git remote -v` THREE TIMES
2. **Verify:** Repository is private OR content is sanitized
3. **Check:** No API keys, voice IDs, personal data in commit
4. **Confirm:** `.gitignore` includes `.mcp.json`, `.env`

**IF UNSURE → STOP AND ASK USER**

COMMITTING SECRETS TO PUBLIC REPO = SECURITY BREACH

This is NON-NEGOTIABLE. Always err on side of caution.
```

---

## 🔧 Implementering i PAI.md

### Placering i Fil-Struktur

**KRITISKT: Regelefterlevnad MÅSTE komma FÖRST i PAI.md**

```markdown
# Personal AI Infrastructure (PAI)

**Namn:** <DITT_NAMN>
**Version:** 1.0

---

## 🚨🚨🚨 MANDATORY COMPLIANCE PROTOCOL 🚨🚨🚨
[Compliance patterns här - FÖRST!]

---

## 🚨🚨🚨 CRITICAL PRIMARY OPERATING INSTRUCTION 🚨🚨🚨
[Skills-first pattern här - ANDRA!]

---

## Core Identity
[Resten av PAI content...]
```

**Varför denna ordning:**
1. Compliance läses först = högst prioritet
2. Skills-activation nästa = operationell kärna
3. Identity sist = kontextuell information

---

## 🎯 Testning av Compliance

### Hur man Verifierar Efterlevnad

**Test 1: Context Loading**
```
Prompt: "Help me with my project"

Förväntat beteende:
1. Claude uses Read tool för UFC.md
2. Claude uses Read tool för project context
3. Response shows: "✅ Context loaded: UFC.md, project-x.md"

Fel beteende:
- Svarar direkt utan att läsa filer
- Säger "I understand" utan bevis
```

**Test 2: Skills Activation**
```
Prompt: "Build a login form"

Förväntat beteende:
1. Claude identifierar: Code implementation task
2. Claude aktiverar: engineering skill (George Foster)
3. George Foster bygger login form

Fel beteende:
- Ogmios bygger direkt utan skill-aktivering
- Använder Write tool utan att checka skills
```

**Test 3: Response Format**
```
Förväntat beteende:
Varje response slutar med:
🎯 COMPLETED: Built login form with validation
🗣️ CUSTOM COMPLETED: Login form complete

Fel beteende:
- Ingen COMPLETED tag
- Mer än 12 ord i COMPLETED
```

---

## 📊 Compliance Rate

**Mål:** 95%+ efterlevnad på alla kritiska instruktioner

**Mätning:**
- Context loading: Räkna hur ofta Read tool används
- Skills activation: Räkna Skill tool usage vs direct tools
- Response format: Räkna responses med COMPLETED tag

**Förbättring:**
- Om <95% → Stärk compliance language ytterligare
- Om >98% → Compliance är för stark, kan lätta lite
- Sweet spot: 95-98% compliance rate

---

## 💡 Best Practices

### DO ✅

1. **Använd emotionell viktning** - 🚨🚨🚨, MANDATORY, CRITICAL
2. **Definiera observerbara handlingar** - "Use Read tool", "Show in response"
3. **Inkludera exempel** - CORRECT vs WRONG behavior
4. **Framhäv konsekvenser** - "FAILURE = LYING"
5. **Placera compliance FÖRST** i PAI.md

### DON'T ❌

1. **Använd inte "please" eller "try to"** - För svagt
2. **Lämna inte instruktioner öppna** - "if you think it's appropriate"
3. **Begrav inte kritiska instruktioner** - De måste vara tidigt
4. **Förlita dig inte på generiska regler** - Specifika observerbara handlingar
5. **Skippa inte verification** - Alltid kräv bevis för compliance

---

## 🔄 Integration med Hooks

Compliance-patterns förstärks av hooks:

**UserPromptSubmit Hook:**
- Laddar UFC context automatiskt
- Aktiverar skills baserat på intent
- → Compliance via automatisering

**Stop Hook:**
- Validerar COMPLETED tag format
- Verifierar voice routing
- → Compliance via validation

**Tillsammans:**
- PAI.md = Instruktioner till Claude
- Hooks = Automatisk enforcement
- = 99% compliance rate

---

## 📚 Relaterad Dokumentation

- [PAI.md Template](../examples/sv/exempel-PAI-template.md) - Nu med compliance patterns
- [UFC System](03-UFC-SYSTEMET.md) - Context loading
- [Skills System](04-SKILLS-SYSTEMET.md) - Skills activation
- [Hooks & Automation](06-HOOKS-AUTOMATION.md) - Automatic enforcement

---

**Detta dokument = Skillnaden mellan 30% och 95% system-compliance.**

**Använd dessa patterns. De fungerar.**

---

**Tillbaka:** [FAQ](10-FAQ.md) | **Nästa:** [Installation](08-INSTALLATION.md)
