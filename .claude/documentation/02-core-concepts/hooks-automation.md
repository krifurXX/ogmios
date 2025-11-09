# Hooks & Automation

[🇬🇧 English](06-HOOKS-AUTOMATION.md) | [🇸🇪 Svenska](../docs/06-bilingual/svenska/hooks-automation.md)

---

## What are Hooks?

**Hooks** = Scripts (TypeScript/Bash) that run automatically at specific Claude Code events.

**Makes Ogmios:** Proactive instead of reactive

---

## Hook Types

### SessionStart
**When:** At new session start  
**Use:** Load PAI.md (core identity)

### UserPromptSubmit ⭐ (Most Important!)
**When:** BEFORE AI responds  
**Use:** Load context, activate skills

### Stop
**When:** AFTER AI response  
**Use:** Validate output, trigger voice

### PreToolUse / PostToolUse
**When:** Before/after tool usage  
**Use:** Logging, security validation

---

## Execution Flow

```
User writes prompt
    ↓
UserPromptSubmit hooks run:
  - load-ufc-context.ts (loads context)
  - skill-activation-enforcer.ts (activates skill)
    ↓
AI generates response (with context & skill)
    ↓
Stop hooks run:
  - completion-validator.ts (validates)
  - stop-hook.ts (voice)
    ↓
User sees/hears result
```

---

## Key Hooks

### load-ufc-context.ts
Loads UFC context based on intent detection

### skill-activation-enforcer.ts
Activates correct skill automatically

### completion-validator.ts
Validates COMPLETED tag format

---

## Create Custom Hook

```typescript
// ~/.claude/.claude/hooks/my-hook.ts
export default async function({ userMessage }) {
  // Your logic here
  
  return {
    systemMessage: "Extra context..."
  };
}
```

Add to `settings.json`:
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [{
          "type": "command",
          "command": "${PAI_DIR}/.claude/hooks/my-hook.ts"
        }]
      }
    ]
  }
}
```

---

**Example:** [UFC context hook](../examples/example-hook-ufc-context.ts)

---

**Back:** [Voice System](05-VOICE-SYSTEM.md) | **Next:** [MCP Integration](07-MCP-INTEGRATION.md)
