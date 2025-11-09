/**
 * SESSION START HOOK - Example
 *
 * Language: 🇸🇪 Svenska (se ../sv/exempel-hook-session-start.ts) | 🇬🇧 English
 *
 * File: ~/.claude/.claude/hooks/session-start.ts
 * Hook Type: SessionStart
 * Runs: At start of new session
 * Purpose: Load core identity and set up session
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
 * Session Start Hook - Loads PAI.md (core identity)
 */
export default async function sessionStartHook(
  context: SessionStartContext
): Promise<HookResponse> {
  try {
    // PAI.md is your core identity - always load at session start
    const paiDir = process.env.PAI_DIR || join(process.env.HOME!, '.claude/.claude');
    const paiPath = join(paiDir, 'PAI.md');

    // Read PAI.md
    const paiContent = await readFile(paiPath, 'utf-8');

    // Build system message with session info
    const systemMessage = `
# 🚀 SESSION START: ${new Date(context.timestamp).toLocaleString('en-US')}

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
 * CONFIGURATION IN settings.json:
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
 * USAGE EXAMPLE:
 *
 * When you start a new session:
 * 1. This hook runs automatically
 * 2. PAI.md loads (your core identity)
 * 3. Session information displayed
 * 4. Claude knows its purpose and your PAI from the start
 *
 * This ensures every session starts with the right context!
 */

/**
 * CUSTOMIZATION TIPS:
 *
 * 1. Add more context:
 *    - Load latest memory/learnings.md
 *    - Load active decisions from ADRs
 *    - Read latest session summary
 *
 * 2. Session-specific setup:
 *    - Check if project has .claude/CLAUDE.md
 *    - Load project-specific settings
 *    - Set environment variables
 *
 * 3. Logging:
 *    - Log session start to file
 *    - Count number of sessions
 *    - Save timestamp for analytics
 */
