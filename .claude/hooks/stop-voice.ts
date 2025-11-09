/**
 * STOP VOICE HOOK - Full Voice Feedback Implementation
 *
 * Location: ~/.claude/.claude/hooks/stop-voice.ts
 * Hook Type: Stop
 * Runs: AFTER Claude generates the assistant message
 * Purpose: Extract COMPLETED tag and trigger voice feedback via ElevenLabs
 *
 * HOW IT WORKS:
 * 1. Extracts COMPLETED and CUSTOM COMPLETED tags from assistant message
 * 2. Detects voice configuration (skill-specific voice ID or default)
 * 3. Calls voice server API to generate speech
 * 4. Handles errors gracefully (voice is optional, never blocks)
 * 5. Logs voice activity for debugging
 *
 * VOICE SYSTEM ARCHITECTURE:
 * - Voice Server: Local HTTP server running on port 8888 (configurable)
 * - API: POST /notify with JSON payload
 * - ElevenLabs: Text-to-speech service (requires API key)
 * - Skills: Each skill can have its own voice ID
 */

import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

// ============================================================================
// INTERFACES
// ============================================================================

interface StopContext {
  assistantMessage: string;
  userMessage?: string;
  sessionId: string;
  projectDir?: string;
}

interface HookResponse {
  systemMessage?: string;
  shouldBlock?: boolean;
  error?: string;
  metadata?: Record<string, unknown>;
}

interface VoiceConfig {
  id: string;
  name: string;
  accent: string;
  language: string;
}

interface CompletedTags {
  standard?: string;
  custom?: string;
  voiceId?: string;
  agentTag?: string;
}

// ============================================================================
// CONFIGURATION
// ============================================================================

/**
 * Voice Server Configuration
 *
 * Set these environment variables:
 * - VOICE_ENABLED=true (enable/disable voice feedback)
 * - VOICE_SERVER_URL=http://localhost:8888 (voice server endpoint)
 * - VOICE_RATE=260 (speech rate, 100-400, default 260)
 * - ELEVENLABS_API_KEY=your_api_key (ElevenLabs API key)
 */
const VOICE_SERVER_URL = process.env.VOICE_SERVER_URL || 'http://localhost:8888';
const VOICE_ENABLED = process.env.VOICE_ENABLED === 'true';
const VOICE_RATE = parseInt(process.env.VOICE_RATE || '260', 10);

/**
 * Voice ID Mapping
 *
 * Maps skill names and agent tags to voice IDs
 * Replace <PLACEHOLDER> with actual ElevenLabs voice IDs
 */
const VOICE_MAP: Record<string, VoiceConfig> = {
  // English voices (skills)
  engineering: {
    id: '<VOICE_ID_ENGINEERING>',
    name: 'George Foster',
    accent: 'British',
    language: 'en'
  },
  research: {
    id: '<VOICE_ID_RESEARCH>',
    name: 'Dr. Alice Mitchell',
    accent: 'British',
    language: 'en'
  },
  architecture: {
    id: '<VOICE_ID_ARCHITECTURE>',
    name: 'Dr. Emma Roberts',
    accent: 'British',
    language: 'en'
  },
  'technical-writing': {
    id: '<VOICE_ID_TECHNICAL_WRITING>',
    name: 'Marcus Thompson',
    accent: 'British',
    language: 'en'
  },
  'data-analysis': {
    id: '<VOICE_ID_DATA_ANALYSIS>',
    name: 'Dr. Sarah Chen',
    accent: 'British',
    language: 'en'
  },
  devops: {
    id: '<VOICE_ID_DEVOPS>',
    name: 'James Wilson',
    accent: 'British',
    language: 'en'
  },
  security: {
    id: '<VOICE_ID_SECURITY>',
    name: 'Elena Rodriguez',
    accent: 'British',
    language: 'en'
  },

  // Swedish voices
  swedish: {
    id: '<VOICE_ID_SWEDISH>',
    name: 'Anna',
    accent: 'Swedish',
    language: 'sv'
  },
  'swedish-academic': {
    id: '<VOICE_ID_SWEDISH_ACADEMIC>',
    name: 'Prof. Lars Bergström',
    accent: 'Swedish',
    language: 'sv'
  },

  // Agent tags (from COMPLETED: [AGENT:name])
  architect: {
    id: '<VOICE_ID_ARCHITECTURE>',
    name: 'Dr. Emma Roberts',
    accent: 'British',
    language: 'en'
  },
  engineer: {
    id: '<VOICE_ID_ENGINEERING>',
    name: 'George Foster',
    accent: 'British',
    language: 'en'
  },
  researcher: {
    id: '<VOICE_ID_RESEARCH>',
    name: 'Dr. Alice Mitchell',
    accent: 'British',
    language: 'en'
  },

  // Default voice (fallback)
  default: {
    id: '<VOICE_ID_DEFAULT>',
    name: 'Default Voice',
    accent: 'British',
    language: 'en'
  }
};

// ============================================================================
// MAIN HOOK FUNCTION
// ============================================================================

/**
 * Stop Voice Hook - Trigger voice feedback after response
 */
export default async function stopVoiceHook(
  context: StopContext
): Promise<HookResponse> {
  try {
    const { assistantMessage } = context;

    // Extract COMPLETED tags from message
    const tags = extractCompletedTags(assistantMessage);

    if (!tags.standard) {
      // No COMPLETED tag - voice feedback not possible
      console.log('[Voice] No COMPLETED tag found, skipping voice feedback');
      return {};
    }

    // Voice feedback only if enabled
    if (!VOICE_ENABLED) {
      console.log('[Voice] Voice feedback disabled (VOICE_ENABLED=false)');
      return {};
    }

    // Determine which text to speak (prefer CUSTOM COMPLETED)
    const textToSpeak = tags.custom || tags.standard;

    // Determine voice ID (from agent tag, voice ID tag, or default)
    const voiceConfig = determineVoiceConfig(tags);

    // Trigger voice feedback
    await triggerVoiceFeedback(textToSpeak, voiceConfig);

    // Log voice activity
    console.log(`
[Voice Feedback]
Text: "${textToSpeak}"
Voice: ${voiceConfig.name} (${voiceConfig.accent})
Voice ID: ${voiceConfig.id}
Rate: ${VOICE_RATE}
    `.trim());

    return {
      metadata: {
        voiceTriggered: true,
        voiceName: voiceConfig.name,
        textSpoken: textToSpeak
      }
    };

  } catch (error) {
    // Never block on voice errors - voice is optional
    console.error('[Voice] Error during voice feedback:', error);
    return {
      metadata: {
        voiceTriggered: false,
        voiceError: error instanceof Error ? error.message : 'Unknown error'
      }
    };
  }
}

// ============================================================================
// TAG EXTRACTION
// ============================================================================

/**
 * Extract COMPLETED tags and voice configuration from assistant message
 */
function extractCompletedTags(message: string): CompletedTags {
  // Standard COMPLETED tag: 🎯 COMPLETED: [AGENT:name] task description
  const standardMatch = message.match(/🎯\s*COMPLETED:\s*(?:\[AGENT:(\w+)\]\s*)?(.+?)(?:\n|$)/);

  // Custom COMPLETED tag: 🗣️ CUSTOM COMPLETED: short version
  const customMatch = message.match(/🗣️\s*CUSTOM COMPLETED:\s*(.+?)(?:\n|$)/);

  // Voice ID tag: VOICE: skillname
  const voiceMatch = message.match(/VOICE:\s*([a-z-]+)/i);

  return {
    standard: standardMatch?.[2]?.trim(),
    agentTag: standardMatch?.[1]?.toLowerCase(),
    custom: customMatch?.[1]?.trim(),
    voiceId: voiceMatch?.[1]?.toLowerCase()
  };
}

/**
 * Determine which voice configuration to use
 */
function determineVoiceConfig(tags: CompletedTags): VoiceConfig {
  // Priority order:
  // 1. Explicit VOICE: tag
  // 2. AGENT tag from COMPLETED
  // 3. Default voice

  if (tags.voiceId && VOICE_MAP[tags.voiceId]) {
    return VOICE_MAP[tags.voiceId];
  }

  if (tags.agentTag && VOICE_MAP[tags.agentTag]) {
    return VOICE_MAP[tags.agentTag];
  }

  // Fallback to default
  return VOICE_MAP.default;
}

// ============================================================================
// VOICE SERVER API
// ============================================================================

/**
 * Trigger voice feedback via voice server
 */
async function triggerVoiceFeedback(text: string, voice: VoiceConfig): Promise<void> {
  try {
    // Clean text for voice (remove special characters, normalize)
    const cleanedText = cleanTextForVoice(text);

    // Build API payload
    const payload = {
      message: cleanedText,
      voice_id: voice.id,
      rate: VOICE_RATE,
      voice_enabled: true
    };

    // Call voice server API
    const curlCommand = `curl -X POST "${VOICE_SERVER_URL}/notify" \
      -H "Content-Type: application/json" \
      -d '${JSON.stringify(payload).replace(/'/g, "'\\''")}' \
      --silent --show-error --max-time 5`;

    await execAsync(curlCommand);

    console.log(`[Voice] Successfully triggered: "${cleanedText.substring(0, 50)}..."`);

  } catch (error) {
    console.error('[Voice] Failed to call voice server:', error);
    throw error;
  }
}

/**
 * Clean text for voice synthesis
 */
function cleanTextForVoice(text: string): string {
  return text
    // Remove markdown formatting
    .replace(/[*_`]/g, '')
    // Remove emojis
    .replace(/[\u{1F300}-\u{1F9FF}]/gu, '')
    // Remove special characters
    .replace(/[^\w\s.,!?-]/g, ' ')
    // Normalize whitespace
    .replace(/\s+/g, ' ')
    .trim();
}

// ============================================================================
// HEALTH CHECK (OPTIONAL)
// ============================================================================

/**
 * Check if voice server is running
 * Call this on session start to verify voice system is available
 */
async function checkVoiceServerHealth(): Promise<boolean> {
  try {
    const healthCheckCommand = `curl -X GET "${VOICE_SERVER_URL}/health" \
      --silent --show-error --max-time 2`;

    await execAsync(healthCheckCommand);
    return true;

  } catch (error) {
    console.warn('[Voice] Voice server not available:', error);
    return false;
  }
}

// ============================================================================
// CONFIGURATION IN settings.json
// ============================================================================

/**
 * ADD THIS TO YOUR settings.json:
 *
 * {
 *   "hooks": {
 *     "Stop": [
 *       {
 *         "hooks": [{
 *           "type": "command",
 *           "command": "bun run ${PAI_DIR}/.claude/hooks/stop-voice.ts"
 *         }]
 *       }
 *     ]
 *   }
 * }
 */

// ============================================================================
// ENVIRONMENT VARIABLES
// ============================================================================

/**
 * REQUIRED ENVIRONMENT VARIABLES:
 *
 * # Enable/disable voice feedback
 * VOICE_ENABLED=true
 *
 * # Voice server endpoint
 * VOICE_SERVER_URL=http://localhost:8888
 *
 * # Speech rate (100-400, default 260)
 * VOICE_RATE=260
 *
 * # ElevenLabs API key (required by voice server)
 * ELEVENLABS_API_KEY=your_api_key_here
 *
 * # PAI directory (for hooks location)
 * PAI_DIR=/Users/yourusername/.claude
 */

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/**
 * EXAMPLE 1: Standard COMPLETED tag
 *
 * Assistant message:
 * ---
 * [Response content...]
 *
 * 🎯 COMPLETED: [AGENT:engineer] User authentication system implemented
 * ---
 *
 * → Voice triggered with George Foster's voice
 * → Speaks: "User authentication system implemented"
 *
 *
 * EXAMPLE 2: Custom COMPLETED tag
 *
 * Assistant message:
 * ---
 * [Response content...]
 *
 * 🎯 COMPLETED: [AGENT:researcher] Comprehensive research on React state management completed
 * 🗣️ CUSTOM COMPLETED: Research complete
 * ---
 *
 * → Voice triggered with Dr. Alice Mitchell's voice
 * → Speaks: "Research complete" (shorter custom version)
 *
 *
 * EXAMPLE 3: Manual voice override
 *
 * Assistant message:
 * ---
 * [Response content...]
 *
 * 🎯 COMPLETED: Documentation written
 * 🗣️ CUSTOM COMPLETED: Docs ready
 * VOICE: technical-writing
 * ---
 *
 * → Voice triggered with Marcus Thompson's voice
 * → Speaks: "Docs ready"
 */

// ============================================================================
// TROUBLESHOOTING
// ============================================================================

/**
 * ISSUE: Voice not playing
 *
 * 1. Check voice server is running:
 *    curl http://localhost:8888/health
 *
 * 2. Check environment variables:
 *    echo $VOICE_ENABLED
 *    echo $VOICE_SERVER_URL
 *
 * 3. Check ElevenLabs API key:
 *    echo $ELEVENLABS_API_KEY
 *
 * 4. Check voice IDs are configured:
 *    - Replace <VOICE_ID_*> placeholders with actual IDs
 *    - Get voice IDs from ElevenLabs dashboard
 *
 * 5. Check hook is configured in settings.json:
 *    cat ~/.claude/.claude/settings.json | grep stop-voice
 *
 *
 * ISSUE: Wrong voice playing
 *
 * 1. Check AGENT tag in COMPLETED:
 *    🎯 COMPLETED: [AGENT:engineer] task description
 *
 * 2. Check VOICE tag if manual override:
 *    VOICE: skillname
 *
 * 3. Check VOICE_MAP configuration above
 *
 *
 * ISSUE: Voice server errors
 *
 * 1. Check server logs:
 *    tail -f /path/to/voice-server/logs
 *
 * 2. Test voice server directly:
 *    curl -X POST http://localhost:8888/notify \
 *      -H "Content-Type: application/json" \
 *      -d '{"message":"Test","voice_enabled":true}'
 *
 * 3. Restart voice server:
 *    bun run voice-server.ts
 */

// ============================================================================
// CUSTOMIZATION TIPS
// ============================================================================

/**
 * 1. Add new voices:
 *    - Get voice ID from ElevenLabs
 *    - Add to VOICE_MAP with config
 *    - Use in AGENT tag or VOICE tag
 *
 * 2. Adjust speech rate:
 *    - Set VOICE_RATE environment variable
 *    - Range: 100 (slow) to 400 (fast)
 *    - Default: 260 (natural)
 *
 * 3. Language-specific voices:
 *    - Add language field to VoiceConfig
 *    - Auto-detect language from message
 *    - Route to appropriate voice
 *
 * 4. Conditional voice triggering:
 *    - Only trigger for certain agents
 *    - Only trigger for longer responses
 *    - Only trigger during certain hours
 */
