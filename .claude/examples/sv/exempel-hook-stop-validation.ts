/**
 * STOP HOOK - Validation & Voice Trigger
 *
 * Språk: 🇸🇪 Svenska | 🇬🇧 English (se ../en/example-hook-stop-validation.ts)
 *
 * Fil: ~/.claude/.claude/hooks/stop-validation.ts
 * Hook Type: Stop
 * Körs: EFTER att Claude genererat sitt svar
 * Syfte: Validera COMPLETED tag och trigga voice feedback
 */

import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

interface StopContext {
  assistantMessage: string;
  userMessage?: string;
  sessionId: string;
}

interface HookResponse {
  systemMessage?: string;
  shouldBlock?: boolean;
  error?: string;
}

/**
 * Voice IDs för olika skills (exempel)
 */
const VOICE_MAP: Record<string, { id: string; name: string; accent: string }> = {
  engineering: {
    id: '<VOICE_ID_ENGINEERING>',
    name: 'George Foster',
    accent: 'British'
  },
  research: {
    id: '<VOICE_ID_RESEARCH>',
    name: 'Dr. Alice Mitchell',
    accent: 'British'
  },
  architecture: {
    id: '<VOICE_ID_ARCHITECTURE>',
    name: 'Dr. Emma Roberts',
    accent: 'British'
  },
  swedish: {
    id: '<VOICE_ID_SWEDISH>',
    name: 'Anna',
    accent: 'Swedish'
  }
};

/**
 * Extrahera COMPLETED tag från assistant message
 */
function extractCompletedTag(message: string): {
  standard?: string;
  custom?: string;
  voiceId?: string;
} {
  const standardMatch = message.match(/🎯\s*COMPLETED:\s*(.+?)(?:\n|$)/);
  const customMatch = message.match(/🗣️\s*CUSTOM COMPLETED:\s*(.+?)(?:\n|$)/);
  const voiceMatch = message.match(/VOICE:\s*(\w+)/i);

  return {
    standard: standardMatch?.[1]?.trim(),
    custom: customMatch?.[1]?.trim(),
    voiceId: voiceMatch?.[1]?.toLowerCase()
  };
}

/**
 * Validera COMPLETED tag format
 */
function validateCompletedTag(tag: string): { valid: boolean; error?: string } {
  const words = tag.split(/\s+/).length;

  if (words > 12) {
    return {
      valid: false,
      error: `COMPLETED tag is too long (${words} words, max 12)`
    };
  }

  if (tag.length < 3) {
    return {
      valid: false,
      error: 'COMPLETED tag is too short'
    };
  }

  return { valid: true };
}

/**
 * Trigga voice feedback via voice-server
 */
async function triggerVoice(text: string, voiceId: string): Promise<void> {
  try {
    const voiceServerUrl = process.env.VOICE_SERVER_URL || 'http://localhost:8765';

    await execAsync(`curl -X POST ${voiceServerUrl}/speak \\
      -H "Content-Type: application/json" \\
      -d '{"text": "${text.replace(/"/g, '\\"')}", "voice_id": "${voiceId}"}'`);

    console.log(`[Voice] Triggered: "${text}" (${voiceId})`);
  } catch (error) {
    console.error('[Voice] Failed to trigger:', error);
  }
}

/**
 * Stop Hook - Validering och Voice
 */
export default async function stopValidationHook(
  context: StopContext
): Promise<HookResponse> {
  try {
    const { assistantMessage } = context;
    const { standard, custom, voiceId } = extractCompletedTag(assistantMessage);

    // Validera att COMPLETED tag finns
    if (!standard) {
      return {
        systemMessage: `
⚠️ WARNING: Missing COMPLETED tag!

All responses should end with:
🎯 COMPLETED: [Task description, max 12 words]
🗣️ CUSTOM COMPLETED: [Voice-optimized, max 8 words] (optional)
`.trim()
      };
    }

    // Validera format
    const validation = validateCompletedTag(standard);
    if (!validation.valid) {
      return {
        systemMessage: `
⚠️ WARNING: Invalid COMPLETED tag format!

Error: ${validation.error}

Current tag: "${standard}"
Word count: ${standard.split(/\s+/).length}

Please fix the COMPLETED tag.
`.trim()
      };
    }

    // Om voice är aktiverat, trigga feedback
    const voice = VOICE_MAP[voiceId || 'engineering'];
    if (voice && process.env.VOICE_ENABLED === 'true') {
      const textToSpeak = custom || standard;
      await triggerVoice(textToSpeak, voice.id);

      console.log(`
[Voice Feedback]
Text: "${textToSpeak}"
Voice: ${voice.name} (${voice.accent})
      `.trim());
    }

    // Allt OK - inget system message behövs
    return {};

  } catch (error) {
    console.error('[Stop Hook] Error:', error);
    return {
      error: `Stop hook failed: ${error instanceof Error ? error.message : 'Unknown error'}`
    };
  }
}

/**
 * KONFIGURATION I settings.json:
 *
 * {
 *   "hooks": {
 *     "Stop": [
 *       {
 *         "hooks": [{
 *           "type": "command",
 *           "command": "bun run ${PAI_DIR}/.claude/hooks/stop-validation.ts"
 *         }]
 *       }
 *     ]
 *   }
 * }
 */

/**
 * ENVIRONMENT VARIABLES:
 *
 * VOICE_ENABLED=true          # Aktivera voice feedback
 * VOICE_SERVER_URL=http://localhost:8765  # Voice server URL
 */

/**
 * ANVÄNDNINGSEXEMPEL:
 *
 * Normal response:
 * ---
 * [Assistant's answer]
 *
 * 🎯 COMPLETED: Created user authentication system with JWT tokens
 * 🗣️ CUSTOM COMPLETED: Auth system created
 * VOICE: engineering
 * ---
 *
 * → Hook validerar ✅
 * → Voice triggas med George Foster's röst: "Auth system created"
 *
 * Felaktig response:
 * ---
 * [Assistant's answer]
 * (ingen COMPLETED tag)
 * ---
 *
 * → Hook varnar ⚠️ om saknad tag
 */
