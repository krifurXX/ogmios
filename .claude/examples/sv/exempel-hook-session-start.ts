/**
 * SESSION START HOOK - Exempel
 *
 * Språk: 🇸🇪 Svenska | 🇬🇧 English (se ../en/example-hook-session-start.ts)
 *
 * Fil: ~/.claude/.claude/hooks/session-start.ts
 * Hook Type: SessionStart
 * Körs: Vid start av ny session
 * Syfte: Ladda kärnidentitet och sätta upp session
 */

import { readFile } from 'fs/promises';
import { join } from 'path';

interface SessionStartContext {
  projectDir?: string;
  sessionId: string;
  timestamp: string;
}

interface HookResponse {
  systemMessage?: string;
  error?: string;
}

/**
 * Session Start Hook - Laddar PAI.md (kärnidentitet)
 */
export default async function sessionStartHook(
  context: SessionStartContext
): Promise<HookResponse> {
  try {
    // PAI.md är din kärnidentitet - ladda alltid vid session start
    const paiDir = process.env.PAI_DIR || join(process.env.HOME!, '.claude/.claude');
    const paiPath = join(paiDir, 'PAI.md');

    // Läs PAI.md
    const paiContent = await readFile(paiPath, 'utf-8');

    // Bygg system message med sessioninfo
    const systemMessage = `
# 🚀 SESSION START: ${new Date(context.timestamp).toLocaleString('sv-SE')}

Session ID: ${context.sessionId}
Project: ${context.projectDir || 'No project'}

---

${paiContent}

---

**Session initialized successfully.**
`.trim();

    return { systemMessage };

  } catch (error) {
    console.error('[SessionStart Hook] Error:', error);
    return {
      error: `Failed to load PAI.md: ${error instanceof Error ? error.message : 'Unknown error'}`
    };
  }
}

/**
 * KONFIGURATION I settings.json:
 *
 * {
 *   "hooks": {
 *     "SessionStart": [
 *       {
 *         "hooks": [{
 *           "type": "command",
 *           "command": "bun run ${PAI_DIR}/.claude/hooks/session-start.ts"
 *         }]
 *       }
 *     ]
 *   }
 * }
 */

/**
 * ANVÄNDNINGSEXEMPEL:
 *
 * När du startar en ny session:
 * 1. Denna hook körs automatiskt
 * 2. PAI.md laddas (din kärnidentitet)
 * 3. Session-information visas
 * 4. Claude känner till sitt syfte och din PAI från början
 *
 * Detta säkerställer att varje session börjar med rätt kontext!
 */

/**
 * TIPS FÖR ANPASSNING:
 *
 * 1. Lägg till mer kontext:
 *    - Ladda senaste memory/learnings.md
 *    - Ladda aktiva decisions från ADRs
 *    - Läs senaste session summary
 *
 * 2. Session-specifik setup:
 *    - Kolla om projektet har .claude/CLAUDE.md
 *    - Ladda projekt-specifika settings
 *    - Sätt environment-variabler
 *
 * 3. Logging:
 *    - Logga session start till fil
 *    - Räkna antal sessioner
 *    - Spara timestamp för analytics
 */
