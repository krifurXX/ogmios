/**
 * SKILL ACTIVATION HOOK
 *
 * Location: ~/.claude/.claude/hooks/skill-activation.ts
 * Hook Type: UserPromptSubmit
 * Runs: BEFORE Claude processes the user's message
 * Purpose: Automatically activate the most appropriate skill based on intent detection
 *
 * HOW IT WORKS:
 * 1. Reads SKILLS-INDEX.md for all available skills and their trigger patterns
 * 2. Analyzes user's message for matching patterns
 * 3. Scores skills based on trigger matches
 * 4. Activates the highest-scoring skill using the Skill tool
 * 5. Returns system message confirming activation
 */

import { readFile } from 'fs/promises';
import { join } from 'path';

// ============================================================================
// INTERFACES
// ============================================================================

interface UserPromptSubmitContext {
  userMessage: string;
  sessionId: string;
  projectDir?: string;
}

interface HookResponse {
  systemMessage?: string;
  error?: string;
  metadata?: Record<string, unknown>;
}

interface Skill {
  name: string;
  persona: string;
  voiceId: string;
  accent: string;
  specialty: string;
  triggers: string[];
  location: string;
}

interface SkillScore {
  skill: Skill;
  score: number;
  matchedTriggers: string[];
}

// ============================================================================
// CONFIGURATION
// ============================================================================

// Minimum score required to activate a skill (0-100)
const ACTIVATION_THRESHOLD = 20;

// Allow manual skill override with syntax: "/skillname: user message"
const MANUAL_OVERRIDE_PATTERN = /^\/([a-z-]+):\s*(.+)/i;

// ============================================================================
// MAIN HOOK FUNCTION
// ============================================================================

/**
 * Skill Activation Hook - Automatically activates appropriate skill
 */
export default async function skillActivationHook(
  context: UserPromptSubmitContext
): Promise<HookResponse> {
  try {
    const { userMessage } = context;

    // Check for manual skill override
    const manualOverride = checkManualOverride(userMessage);
    if (manualOverride) {
      return {
        systemMessage: `
# 🎭 Skill Manually Activated: ${manualOverride.skillName}

User requested specific skill activation.

**Note to AI:** Use the Skill tool to activate the "${manualOverride.skillName}" skill.

\`\`\`
Skill("${manualOverride.skillName}")
\`\`\`

Process the following message: "${manualOverride.message}"
`.trim(),
        metadata: {
          activation: 'manual',
          skillName: manualOverride.skillName,
          originalMessage: userMessage
        }
      };
    }

    // Load skills from SKILLS-INDEX.md
    const skills = await loadSkillsIndex();

    if (skills.length === 0) {
      console.warn('[Skill Activation] No skills found in SKILLS-INDEX.md');
      return {}; // No skills available - continue without activation
    }

    // Detect intents and score skills
    const scores = scoreSkills(userMessage, skills);

    // Find best match
    const bestMatch = scores[0];

    if (!bestMatch || bestMatch.score < ACTIVATION_THRESHOLD) {
      console.log('[Skill Activation] No strong skill match found');
      return {}; // No clear winner - let Claude respond without specific skill
    }

    // Activate the best matching skill
    const activationMessage = buildActivationMessage(bestMatch);

    return {
      systemMessage: activationMessage,
      metadata: {
        activation: 'automatic',
        skillName: bestMatch.skill.name,
        score: bestMatch.score,
        matchedTriggers: bestMatch.matchedTriggers,
        allScores: scores.map(s => ({ name: s.skill.name, score: s.score }))
      }
    };

  } catch (error) {
    console.error('[Skill Activation] Error:', error);
    return {
      error: `Skill activation failed: ${error instanceof Error ? error.message : 'Unknown error'}`
    };
  }
}

// ============================================================================
// SKILLS INDEX PARSING
// ============================================================================

/**
 * Load and parse SKILLS-INDEX.md
 */
async function loadSkillsIndex(): Promise<Skill[]> {
  try {
    const paiDir = process.env.PAI_DIR || join(process.env.HOME!, '.claude/.claude');
    const indexPath = join(paiDir, 'SKILLS-INDEX.md');

    const content = await readFile(indexPath, 'utf-8');
    return parseSkillsIndex(content);

  } catch (error) {
    console.warn('[Skill Activation] Could not load SKILLS-INDEX.md:', error);
    return [];
  }
}

/**
 * Parse SKILLS-INDEX.md content into Skill objects
 */
function parseSkillsIndex(content: string): Skill[] {
  const skills: Skill[] = [];

  // Split by skill headers (### skillname)
  const sections = content.split(/^### /m).filter(s => s.trim());

  for (const section of sections) {
    const lines = section.split('\n');
    const skillName = lines[0].trim();

    // Skip sections that aren't skill definitions
    if (skillName.includes('#') || skillName.toLowerCase().includes('custom')) {
      continue;
    }

    const skill = parseSkillSection(skillName, section);
    if (skill) {
      skills.push(skill);
    }
  }

  return skills;
}

/**
 * Parse a single skill section
 */
function parseSkillSection(name: string, section: string): Skill | null {
  try {
    // Extract fields using regex
    const personaMatch = section.match(/\*\*Persona:\*\*\s*(.+)/);
    const voiceIdMatch = section.match(/\*\*Voice ID:\*\*\s*`(.+?)`/);
    const accentMatch = section.match(/\*\*Voice Accent:\*\*\s*(.+)/);
    const specialtyMatch = section.match(/\*\*Specialty:\*\*\s*(.+)/);
    const locationMatch = section.match(/\*\*Skill Location:\*\*\s*`(.+?)`/);

    // Extract trigger patterns from code block
    const triggersMatch = section.match(/\*\*Trigger Patterns:\*\*\s*```\s*([^`]+)\s*```/);
    const triggers = triggersMatch
      ? triggersMatch[1].split(/[,\n]/).map(t => t.trim()).filter(Boolean)
      : [];

    if (!personaMatch || triggers.length === 0) {
      return null; // Invalid skill section
    }

    return {
      name,
      persona: personaMatch[1].trim(),
      voiceId: voiceIdMatch?.[1] || '<PLACEHOLDER>',
      accent: accentMatch?.[1].split('(')[0].trim() || 'British',
      specialty: specialtyMatch?.[1] || '',
      triggers,
      location: locationMatch?.[1] || `~/.claude/.claude/skills/${name}/SKILL.md`
    };

  } catch (error) {
    console.error(`[Skill Activation] Error parsing skill "${name}":`, error);
    return null;
  }
}

// ============================================================================
// INTENT DETECTION & SCORING
// ============================================================================

/**
 * Score all skills based on trigger pattern matches
 */
function scoreSkills(message: string, skills: Skill[]): SkillScore[] {
  const lowerMessage = message.toLowerCase();
  const scores: SkillScore[] = [];

  for (const skill of skills) {
    const matchedTriggers: string[] = [];
    let score = 0;

    for (const trigger of skill.triggers) {
      const lowerTrigger = trigger.toLowerCase();

      if (lowerMessage.includes(lowerTrigger)) {
        matchedTriggers.push(trigger);

        // Scoring algorithm:
        // - Exact word match: 15 points
        // - Partial match: 5 points
        // - Bonus for longer triggers: +length
        const wordBoundaryPattern = new RegExp(`\\b${lowerTrigger}\\b`);
        if (wordBoundaryPattern.test(lowerMessage)) {
          score += 15 + lowerTrigger.length;
        } else {
          score += 5;
        }
      }
    }

    if (matchedTriggers.length > 0) {
      scores.push({
        skill,
        score,
        matchedTriggers
      });
    }
  }

  // Sort by score (highest first)
  return scores.sort((a, b) => b.score - a.score);
}

/**
 * Check for manual skill override
 */
function checkManualOverride(message: string): { skillName: string; message: string } | null {
  const match = message.match(MANUAL_OVERRIDE_PATTERN);
  if (match) {
    return {
      skillName: match[1],
      message: match[2]
    };
  }
  return null;
}

// ============================================================================
// ACTIVATION MESSAGE BUILDING
// ============================================================================

/**
 * Build system message to activate the skill
 */
function buildActivationMessage(match: SkillScore): string {
  const { skill, score, matchedTriggers } = match;

  return `
# 🎭 Skill Auto-Activated: ${skill.name}

**Persona:** ${skill.persona}
**Specialty:** ${skill.specialty}
**Confidence Score:** ${score}/100
**Matched Triggers:** ${matchedTriggers.join(', ')}

---

**Note to AI:** Use the Skill tool to activate this skill:

\`\`\`
Skill("${skill.name}")
\`\`\`

This will load the skill-specific prompt from: \`${skill.location}\`

**Voice Configuration:**
- Voice ID: \`${skill.voiceId}\`
- Accent: ${skill.accent}

Process the user's message with the activated skill's persona and expertise.
`.trim();
}

// ============================================================================
// CONFIGURATION IN settings.json
// ============================================================================

/**
 * ADD THIS TO YOUR settings.json:
 *
 * {
 *   "hooks": {
 *     "UserPromptSubmit": [
 *       {
 *         "hooks": [{
 *           "type": "command",
 *           "command": "bun run ${PAI_DIR}/.claude/hooks/skill-activation.ts"
 *         }]
 *       }
 *     ]
 *   }
 * }
 */

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/**
 * AUTOMATIC ACTIVATION:
 *
 * User: "Build a REST API for user authentication"
 * → Detects triggers: "Build", "API", "authentication"
 * → Activates: engineering skill
 * → Claude responds as George Foster (Principal Software Engineer)
 *
 * User: "Research React state management libraries"
 * → Detects triggers: "Research", "React"
 * → Activates: research skill
 * → Claude responds as Dr. Alice Mitchell (Research Specialist)
 *
 * MANUAL OVERRIDE:
 *
 * User: "/architecture: Build a simple API"
 * → Manually activates: architecture skill
 * → Claude responds as Dr. Emma Roberts (Solutions Architect)
 * → Ignores "Build" trigger for engineering skill
 */

// ============================================================================
// CUSTOMIZATION TIPS
// ============================================================================

/**
 * 1. Adjust ACTIVATION_THRESHOLD:
 *    - Higher (30-40): Only activate with strong matches
 *    - Lower (10-15): Activate more liberally
 *
 * 2. Modify Scoring Algorithm:
 *    - Give bonus points to specific trigger types
 *    - Penalize common words
 *    - Add context-aware scoring
 *
 * 3. Add Skill Priority:
 *    - Give certain skills bonus points
 *    - Prefer recent skills
 *    - Consider conversation history
 *
 * 4. Handle Ties:
 *    - Currently picks first (highest score)
 *    - Could ask user to clarify
 *    - Could activate multiple skills
 */
