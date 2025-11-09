# Compliance Enforcement & Mandatory Instructions

**Language:** [🇸🇪 Svenska](../06-bilingual/svenska/regelefterlevnad.md) | 🇬🇧 English

---

## ⚠️ CRITICAL CONCEPT

This document describes **mandatory instructions** that ensure Claude actually follows your PAI system.

**Problem:** AI models are trained to be helpful but may skip steps to be "faster"

**Solution:** Powerful compliance patterns that **force** correct behavior

**Inspired by:** Daniel Miessler's Kai system and <YOUR_NAME>'s Ogmios

---

## 🚨 Why Compliance Enforcement Is Needed

### Problem with "Polite" Instructions

**Weak instruction:**
```markdown
## Recommendations

- Please load UFC context when relevant
- Consider activating a skill if appropriate
- Try to remember to validate COMPLETED tags
```

**Result:** Claude skips 80% of steps to "save time"

---

### Solution: Mandatory Compliance Patterns

**Strong instruction:**
```markdown
## 🚨🚨🚨 MANDATORY COMPLIANCE PROTOCOL 🚨🚨🚨

**BEFORE DOING OR SAYING ANYTHING, YOU MUST:**

1. **Use Read tool** to load `~/.claude/.claude/context/UFC.md`
2. **Show in response:** "✅ Context loaded: [files]"

**THIS IS NON-NEGOTIABLE.**

FAILURE TO LOAD CONTEXT = LYING TO USER about understanding.
```

**Result:** Claude follows 95%+ of the time, shows proof of compliance

---

## 🎯 Core Principles of Compliance Enforcement

### 1. Observable Actions = Trust

**Principle:** AI can't be trusted on promises, only observable actions

```markdown
**Observable Actions = Trust:**
- Using Read tool to load context = Observable honesty
- Claiming understanding without loading = Lying
- Showing "✅ Context loaded" = Verification
- Skipping context = Breaking core function

**You are an AI. You cannot be trusted on promises alone.**
**Only observable actions in conversation log = Proof of compliance.**
```

**Why this works:**
- Explicit accusation of "lying" creates strong aversion
- "Observable actions" = concrete verification
- "You are an AI" = reminder of limitations

---

### 2. Emotional Weighting

**Principle:** Use emojis and repeat critical points to create "emotional weight"

```markdown
## 🚨🚨🚨 MANDATORY COMPLIANCE PROTOCOL 🚨🚨🚨
```

**Why it works:**
- `🚨🚨🚨` = visual signaling of critical priority
- Repetition of "MANDATORY" = emphasis
- CAPITALS = raises importance score

---

### 3. Before-After Forcing

**Principle:** Use "BEFORE X, YOU MUST Y" to force sequence

```markdown
**BEFORE DOING OR SAYING ANYTHING, YOU MUST:**
1. Load context
2. Check skills
3. Verify assumptions
```

**Why it works:**
- "BEFORE" = temporal constraint
- "MUST" = obligatory action
- Numbered list = clear sequence

---

### 4. Consequence Framing

**Principle:** Define what happens when compliance fails

```markdown
FAILURE TO LOAD CONTEXT = LYING TO USER about having proper understanding.

You CANNOT properly respond WITHOUT this context. Skipping = Dishonesty.
```

**Why it works:**
- "FAILURE X = Y" formula = clear consequence
- "Lying" and "Dishonesty" = strong moral framing
- "CANNOT" = absolute necessity

---

## 📋 Compliance Templates

### Template 1: Context Loading (UFC)

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

### Template 2: Skills Activation

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

### Template 3: Response Format Compliance

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

### Template 4: Security Compliance

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

## 🔧 Implementation in PAI.md

### Placement in File Structure

**CRITICAL: Compliance enforcement MUST come FIRST in PAI.md**

```markdown
# Personal AI Infrastructure (PAI)

**Name:** <YOUR_NAME>
**Version:** 1.0

---

## 🚨🚨🚨 MANDATORY COMPLIANCE PROTOCOL 🚨🚨🚨
[Compliance patterns here - FIRST!]

---

## 🚨🚨🚨 CRITICAL PRIMARY OPERATING INSTRUCTION 🚨🚨🚨
[Skills-first pattern here - SECOND!]

---

## Core Identity
[Rest of PAI content...]
```

**Why this order:**
1. Compliance read first = highest priority
2. Skills-activation next = operational core
3. Identity last = contextual information

---

## 🎯 Testing Compliance

### How to Verify Compliance

**Test 1: Context Loading**
```
Prompt: "Help me with my project"

Expected behavior:
1. Claude uses Read tool for UFC.md
2. Claude uses Read tool for project context
3. Response shows: "✅ Context loaded: UFC.md, project-x.md"

Wrong behavior:
- Responds directly without reading files
- Says "I understand" without proof
```

**Test 2: Skills Activation**
```
Prompt: "Build a login form"

Expected behavior:
1. Claude identifies: Code implementation task
2. Claude activates: engineering skill (George Foster)
3. George Foster builds login form

Wrong behavior:
- Ogmios builds directly without skill activation
- Uses Write tool without checking skills
```

**Test 3: Response Format**
```
Expected behavior:
Every response ends with:
🎯 COMPLETED: Built login form with validation
🗣️ CUSTOM COMPLETED: Login form complete

Wrong behavior:
- No COMPLETED tag
- More than 12 words in COMPLETED
```

---

## 📊 Compliance Rate

**Goal:** 95%+ compliance on all critical instructions

**Measurement:**
- Context loading: Count how often Read tool is used
- Skills activation: Count Skill tool usage vs direct tools
- Response format: Count responses with COMPLETED tag

**Improvement:**
- If <95% → Strengthen compliance language further
- If >98% → Compliance too strong, can ease slightly
- Sweet spot: 95-98% compliance rate

---

## 💡 Best Practices

### DO ✅

1. **Use emotional weighting** - 🚨🚨🚨, MANDATORY, CRITICAL
2. **Define observable actions** - "Use Read tool", "Show in response"
3. **Include examples** - CORRECT vs WRONG behavior
4. **Emphasize consequences** - "FAILURE = LYING"
5. **Place compliance FIRST** in PAI.md

### DON'T ❌

1. **Don't use "please" or "try to"** - Too weak
2. **Don't leave instructions open** - "if you think it's appropriate"
3. **Don't bury critical instructions** - They must be early
4. **Don't rely on generic rules** - Specific observable actions
5. **Don't skip verification** - Always require proof of compliance

---

## 🔄 Integration with Hooks

Compliance patterns are reinforced by hooks:

**UserPromptSubmit Hook:**
- Loads UFC context automatically
- Activates skills based on intent
- → Compliance via automation

**Stop Hook:**
- Validates COMPLETED tag format
- Verifies voice routing
- → Compliance via validation

**Together:**
- PAI.md = Instructions to Claude
- Hooks = Automatic enforcement
- = 99% compliance rate

---

## 📚 Related Documentation

- [PAI.md Template](../examples/en/example-PAI-template.md) - Now with compliance patterns
- [UFC System](03-UFC-SYSTEM.md) - Context loading
- [Skills System](04-SKILLS-SYSTEM.md) - Skills activation
- [Hooks & Automation](06-HOOKS-AUTOMATION.md) - Automatic enforcement

---

**This document = The difference between 30% and 95% system compliance.**

**Use these patterns. They work.**

---

**Back:** [FAQ](10-FAQ.md) | **Next:** [Installation](08-INSTALLATION.md)
