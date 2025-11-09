/**
 * Voice ID Mappings for Agents
 *
 * This file provides centralized voice mappings for your Digital Assistant
 * and specialized agents/skills.
 *
 * CONFIGURATION REQUIRED:
 * Replace <VOICE_ID_*> placeholders with your actual ElevenLabs voice IDs
 *
 * Based on Ogmios PAI system (Daniel Miessler's Kai architecture)
 * SANITIZED VERSION - Replace with your own voice IDs
 */

export const AGENT_VOICE_IDS: Record<string, string> = {
  // ============================================================================
  // PRIMARY ASSISTANT
  // ============================================================================

  // Your main Digital Assistant (default English voice)
  assistant: '<VOICE_ID_ASSISTANT_ENGLISH>',
  'assistant-en': '<VOICE_ID_ASSISTANT_ENGLISH>',
  default: '<VOICE_ID_ASSISTANT_ENGLISH>',

  // Optional: Secondary language support (e.g., Swedish, German, French)
  'assistant-alt': '<VOICE_ID_ASSISTANT_ALT_LANGUAGE>',

  // ============================================================================
  // SPECIALIZED SKILLS / AGENTS
  // ============================================================================

  // Research & Analysis
  researcher: '<VOICE_ID_RESEARCHER>',
  'academic-research': '<VOICE_ID_RESEARCHER>',
  research: '<VOICE_ID_RESEARCHER>',

  // Engineering & Development
  engineer: '<VOICE_ID_ENGINEER>',
  'principal-engineer': '<VOICE_ID_ENGINEER>',
  engineering: '<VOICE_ID_ENGINEER>',

  // Architecture & System Design
  architect: '<VOICE_ID_ARCHITECT>',
  architecture: '<VOICE_ID_ARCHITECT>',

  // Security & Penetration Testing
  security: '<VOICE_ID_SECURITY>',
  pentester: '<VOICE_ID_SECURITY>',

  // DevOps & Infrastructure
  devops: '<VOICE_ID_DEVOPS>',
  'dev-ops': '<VOICE_ID_DEVOPS>',

  // Technical Writing
  'technical-writing': '<VOICE_ID_TECHNICAL_WRITER>',
  writer: '<VOICE_ID_TECHNICAL_WRITER>',

  // Design & UX
  designer: '<VOICE_ID_DESIGNER>',
  design: '<VOICE_ID_DESIGNER>',

  // Data Analysis
  'data-analysis': '<VOICE_ID_DATA_ANALYST>',
  'data-analyst': '<VOICE_ID_DATA_ANALYST>',

  // Content Creation
  'content-creation': '<VOICE_ID_CONTENT_CREATOR>',
  content: '<VOICE_ID_CONTENT_CREATOR>',

  // Knowledge Management
  'knowledge-management': '<VOICE_ID_KNOWLEDGE_MANAGER>',
};

/**
 * Detect if text contains specific language patterns
 *
 * CUSTOMIZE THIS for your language needs
 *
 * @param text - Text to analyze
 * @param language - Language code to check for (e.g., 'sv', 'de', 'fr')
 * @returns true if text contains language patterns
 */
export function detectLanguage(text: string, language: string): boolean {
  // Language-specific character patterns
  const characterPatterns: Record<string, RegExp> = {
    sv: /[åäöÅÄÖ]/, // Swedish
    de: /[äöüßÄÖÜ]/, // German
    fr: /[àâæçéèêëîïôœùûüÿÀÂÆÇÉÈÊËÎÏÔŒÙÛÜŸ]/, // French
    es: /[áéíóúñüÁÉÍÓÚÑÜ¿¡]/, // Spanish
    pt: /[áàâãçéêíóôõúÁÀÂÃÇÉÊÍÓÔÕÚ]/, // Portuguese
  };

  // Common words for each language
  const commonWords: Record<string, string[]> = {
    sv: ['jag', 'är', 'det', 'och', 'att', 'som', 'på', 'för', 'med', 'till', 'kan', 'ska', 'vill', 'har', 'finns', 'blir'],
    de: ['ich', 'der', 'die', 'das', 'und', 'ist', 'zu', 'den', 'in', 'von', 'mit', 'ein', 'für', 'auf', 'nicht'],
    fr: ['je', 'de', 'le', 'la', 'et', 'est', 'que', 'pour', 'dans', 'un', 'une', 'avec', 'pas', 'ce', 'il'],
    es: ['el', 'la', 'de', 'que', 'y', 'es', 'en', 'lo', 'un', 'por', 'para', 'con', 'no', 'una', 'los'],
    pt: ['o', 'a', 'de', 'que', 'e', 'do', 'da', 'em', 'um', 'para', 'com', 'não', 'uma', 'os', 'no'],
  };

  // Check for special characters
  if (characterPatterns[language] && characterPatterns[language].test(text)) {
    return true;
  }

  // Check for common words
  if (commonWords[language]) {
    const lowerText = text.toLowerCase();
    const wordPattern = new RegExp(`\\b(${commonWords[language].join('|')})\\b`, 'i');
    return wordPattern.test(lowerText);
  }

  return false;
}

/**
 * Get the appropriate voice ID based on agent type and language
 *
 * IMPORTANT: The `userInput` parameter should be the USER'S PROMPT for language detection
 *
 * @param agentType - The agent type (e.g., 'engineer', 'researcher', 'assistant')
 * @param userInput - The USER'S INPUT TEXT (used for language detection)
 * @param detectedLanguage - Optional pre-detected language code
 * @returns The ElevenLabs voice ID to use
 */
export function getVoiceId(
  agentType: string | null,
  userInput: string = '',
  detectedLanguage?: string
): string {
  // For main assistant, auto-detect language if bilingual support enabled
  if (!agentType || agentType === 'assistant') {
    // Example: Swedish detection (customize for your needs)
    const isSwedish = detectedLanguage === 'sv' || detectLanguage(userInput, 'sv');
    if (isSwedish && AGENT_VOICE_IDS['assistant-alt']) {
      return AGENT_VOICE_IDS['assistant-alt'];
    }

    return AGENT_VOICE_IDS['assistant'];
  }

  // For other agents, use their specific voice or fallback to default
  return AGENT_VOICE_IDS[agentType.toLowerCase()] || AGENT_VOICE_IDS['default'];
}

/**
 * Get voice name/description for logging
 *
 * @param voiceId - Voice ID to look up
 * @returns Human-readable voice name
 */
export function getVoiceName(voiceId: string): string {
  // Reverse lookup
  for (const [name, id] of Object.entries(AGENT_VOICE_IDS)) {
    if (id === voiceId) {
      return name.replace(/-/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
    }
  }
  return 'Unknown Voice';
}

/**
 * Check if voice ID is configured (not a placeholder)
 *
 * @param voiceId - Voice ID to check
 * @returns true if voice ID is configured (not a placeholder)
 */
export function isVoiceConfigured(voiceId: string): boolean {
  return !voiceId.startsWith('<VOICE_ID_');
}
