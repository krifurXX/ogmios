# Hooks & Automation

[🇬🇧 English](../docs/02-core-concepts/hooks.md) | [🇸🇪 Svenska](06-HOOKS-AUTOMATION.md)

---

## Vad är Hooks?

**Hooks** = Skript (TypeScript/Bash) som körs automatiskt vid specifika Claude Code-händelser.

**Gör Ogmios:** Proaktivt istället för reaktivt

---

## Hook-typer

### SessionStart
**När:** Vid start av ny session  
**Användning:** Ladda PAI.md (kärnidentitet)

### UserPromptSubmit ⭐ (Viktigast!)
**När:** INNAN AI svarar  
**Användning:** Ladda kontext, aktivera skills

### Stop
**När:** EFTER AI-svar  
**Användning:** Validera output, trigga röst

### PreToolUse / PostToolUse
**När:** Före/efter verktygsanvändning  
**Användning:** Logging, säkerhetsvalidering

---

## Execution Flow

```
User skriver prompt
    ↓
UserPromptSubmit hooks kör:
  - load-ufc-context.ts (laddar kontext)
  - skill-activation-enforcer.ts (aktiverar skill)
    ↓
AI genererar svar (med kontext & skill)
    ↓
Stop hooks kör:
  - completion-validator.ts (validerar)
  - stop-hook.ts (röst)
    ↓
User ser/hör resultat
```

---

## Viktiga Hooks

### load-ufc-context.ts
Laddar UFC-context baserat på intent detection

### skill-activation-enforcer.ts
Aktiverar rätt skill automatiskt

### completion-validator.ts
Validerar COMPLETED-tag format

---

## Skapa Egen Hook

```typescript
// ~/.claude/.claude/hooks/my-hook.ts
export default async function({ userMessage }) {
  // Din logik här
  
  return {
    systemMessage: "Extra context..."
  };
}
```

Lägg till i `settings.json`:
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

**Exempel:** [UFC context hook](../examples/example-hook-ufc-context.ts)

---

**Tillbaka:** [Voice System](05-ROST-SYSTEMET.md) | **Nästa:** [MCP Integration](07-MCP-INTEGRATION.md)
