#!/usr/bin/env bun

/**
 * skill-activation-enforcer.ts
 *
 * Dimension 4: Proactive Skill Activation Enforcer
 *
 * PURPOSE:
 * - Detect task type from user prompt
 * - Match against skill triggers (bilingual support)
 * - Inject AGGRESSIVE structural enforcement when skills match
 * - Force observable verification (can't be bypassed like instructions)
 * - Coordinate multi-skill workflows when >1 skill matches strongly
 *
 * RUNS ON: UserPromptSubmit hook (BEFORE load-ufc-context.ts)
 *
 * Tier 0 Reinforcements:
 * - R0-1: Structural enforcement template with mandatory checklist
 * - R0-2: Bilingual trigger matching
 * - R0-3: [SKILL:] tag enforcement in completion
 *
 * Tier 1 Reinforcements:
 * - R1-1: Multi-skill coordination (detect >1 strong match)
 * - R1-2: Observable verification (require checkmark messages)
 * - R1-3: Voice-language alignment
 *
 * Hook Priority: 100 (runs BEFORE load-ufc-context.ts = 50)
 *
 * SANITIZED VERSION - All personal data removed
 * Based on Ogmios PAI system (Daniel Miessler's Kai architecture)
 */

import { readFileSync, existsSync, readdirSync } from 'fs';
import { join } from 'path';
import { readStdinJSON, getPAIDir, isSubagent } from './lib/hook-utils.ts';
import { validateFilePath, validatePrompt, sanitizeForLog } from './lib/validation.ts';

interface HookInput {
  session_id: string;
  prompt: string;
  transcript_path: string;
  hook_event_name: string;
}

interface SkillMetadata {
  name: string;
  description: string;
  triggers: string[];
  voice_id?: string;
  voice_name?: string;
  voice_accent?: string;
  voice_gender?: string;
  skillPath: string;
}

interface SkillMatch {
  skill: SkillMetadata;
  matchCount: number;
  matchedTriggers: string[];
}

/**
 * Parse YAML frontmatter from SKILL.md file
 * Returns SkillMetadata or null if not found/invalid
 */
function parseSkillMetadata(skillPath: string, skillName: string): SkillMetadata | null {
  try {
    const safePath = validateFilePath(skillPath);
    const content = readFileSync(safePath, 'utf-8');

    // Extract YAML frontmatter (between --- markers)
    const yamlMatch = content.match(/^---\n([\s\S]*?)\n---/);
    if (!yamlMatch) {
      return null;
    }

    const yamlContent = yamlMatch[1];
    const metadata: Partial<SkillMetadata> = {
      name: skillName,
      skillPath,
      triggers: []
    };

    // Parse YAML manually (simple key-value parsing)
    const lines = yamlContent.split('\n');
    let currentKey: string | null = null;

    for (const line of lines) {
      const trimmed = line.trim();

      // Skip empty lines and comments
      if (!trimmed || trimmed.startsWith('#')) continue;

      // Array items
      if (trimmed.startsWith('- ')) {
        const value = trimmed.substring(2).trim();
        if (currentKey === 'triggers' && metadata.triggers) {
          metadata.triggers.push(value.toLowerCase());
        }
        continue;
      }

      // Key-value pairs
      const colonIndex = trimmed.indexOf(':');
      if (colonIndex > 0) {
        const key = trimmed.substring(0, colonIndex).trim();
        const value = trimmed.substring(colonIndex + 1).trim();

        if (key === 'name') metadata.name = value;
        else if (key === 'description') metadata.description = value;
        else if (key === 'voice_id') metadata.voice_id = value;
        else if (key === 'voice_name') metadata.voice_name = value;
        else if (key === 'voice_accent') metadata.voice_accent = value;
        else if (key === 'voice_gender') metadata.voice_gender = value;
        else if (key === 'triggers') {
          currentKey = 'triggers';
          // If triggers has inline value, add it
          if (value) metadata.triggers?.push(value.toLowerCase());
        }
      }
    }

    // Validate required fields
    if (metadata.name && metadata.description && metadata.triggers && metadata.triggers.length > 0) {
      return metadata as SkillMetadata;
    }

    return null;
  } catch (error) {
    console.error(`⚠️  Failed to parse ${skillName}: ${error}`);
    return null;
  }
}

/**
 * Load Tier 1 metadata from SKILLS-INDEX.md
 * Returns array of SkillMetadata
 */
function loadAllSkillsMetadata(paiDir: string): SkillMetadata[] {
  const skills: SkillMetadata[] = [];

  try {
    const indexPath = join(paiDir, '.claude', 'SKILLS-INDEX.md');

    if (!existsSync(indexPath)) {
      console.error('⚠️  SKILLS-INDEX.md not found, falling back to directory scan');
      return loadSkillsFromDirectory(join(paiDir, '.claude', 'skills'));
    }

    const safePath = validateFilePath(indexPath);
    const content = readFileSync(safePath, 'utf-8');

    // Parse SKILLS-INDEX.md for Tier 1 skills
    const lines = content.split('\n');
    let currentSkill: Partial<SkillMetadata> | null = null;
    let inTier1Section = false;

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];

      // Detect TIER 1 section
      if (line.includes('## TIER 1 Skills')) {
        inTier1Section = true;
        continue;
      }

      // Exit TIER 1 section when we hit TIER 2
      if (inTier1Section && line.includes('## TIER 2 Skills')) {
        break;
      }

      if (!inTier1Section) continue;

      // Parse skill header (e.g., "### 1. knowledge-management (Voice Name)")
      const skillHeaderMatch = line.match(/###\s+\d+\.\s+(\S+)\s+\(([^)]+)\)/);
      if (skillHeaderMatch) {
        // Save previous skill if exists
        if (currentSkill && currentSkill.name && currentSkill.triggers) {
          skills.push(currentSkill as SkillMetadata);
        }

        // Start new skill
        const skillName = skillHeaderMatch[1];
        const voiceName = skillHeaderMatch[2];

        currentSkill = {
          name: skillName,
          voice_name: voiceName,
          triggers: [],
          skillPath: join(paiDir, '.claude', 'skills', skillName, 'SKILL.md'),
          description: ''
        };
        continue;
      }

      // Parse intent patterns
      if (currentSkill && line.includes('**Intent Patterns:**')) {
        // Read next lines for triggers
        for (let j = i + 1; j < Math.min(i + 5, lines.length); j++) {
          const triggerLine = lines[j].trim();
          if (triggerLine.match(/^- (Swedish|English):/)) {
            // Extract triggers from quoted text
            const triggerMatches = triggerLine.match(/"([^"]+)"/g);
            if (triggerMatches && currentSkill.triggers) {
              triggerMatches.forEach(match => {
                const trigger = match.replace(/"/g, '').toLowerCase().trim();
                if (!currentSkill.triggers?.includes(trigger)) {
                  currentSkill.triggers?.push(trigger);
                }
              });
            }
          }
          // Stop at next section
          if (triggerLine.startsWith('**') && !triggerLine.includes('Intent Patterns')) {
            break;
          }
        }
      }

      // Parse voice accent
      if (currentSkill && line.includes('**Voice:**')) {
        const voiceMatch = line.match(/\*\*Voice:\*\*\s+(\w+)/);
        if (voiceMatch) {
          currentSkill.voice_accent = voiceMatch[1];
        }
      }

      // Parse description from "When to Use:" section
      if (currentSkill && line.includes('**When to Use:**')) {
        const descLines: string[] = [];
        for (let j = i + 1; j < Math.min(i + 10, lines.length); j++) {
          const descLine = lines[j].trim();
          if (descLine.startsWith('- ')) {
            descLines.push(descLine.substring(2));
          }
          if (descLine.startsWith('**')) break;
        }
        currentSkill.description = descLines.slice(0, 2).join(', '); // First 2 items
      }
    }

    // Save last skill
    if (currentSkill && currentSkill.name && currentSkill.triggers && currentSkill.triggers.length > 0) {
      skills.push(currentSkill as SkillMetadata);
    }

    console.error(`📋 Skill Enforcer: Loaded ${skills.length} TIER 1 skills from SKILLS-INDEX.md`);
  } catch (error) {
    console.error(`⚠️  Failed to parse SKILLS-INDEX.md: ${error}`);
  }

  return skills;
}

/**
 * Fallback: Load skills from directory scan
 */
function loadSkillsFromDirectory(skillsDir: string): SkillMetadata[] {
  const skills: SkillMetadata[] = [];

  try {
    const skillDirs = readdirSync(skillsDir, { withFileTypes: true })
      .filter(dirent => dirent.isDirectory())
      .filter(dirent => !dirent.name.startsWith('.'))
      .map(dirent => dirent.name);

    for (const skillName of skillDirs) {
      const skillPath = join(skillsDir, skillName, 'SKILL.md');
      if (existsSync(skillPath)) {
        const metadata = parseSkillMetadata(skillPath, skillName);
        if (metadata) {
          skills.push(metadata);
        }
      }
    }
  } catch (error) {
    console.error(`⚠️  Directory scan failed: ${error}`);
  }

  return skills;
}

/**
 * Match prompt against skill triggers
 * Returns matched skills with match details sorted by match count (descending)
 */
function matchSkills(prompt: string, skills: SkillMetadata[]): SkillMatch[] {
  const lowerPrompt = prompt.toLowerCase();
  const matched: SkillMatch[] = [];

  for (const skill of skills) {
    const matchedTriggers = skill.triggers.filter(trigger => {
      // Support both single words and phrases
      if (trigger.includes(' ')) {
        return lowerPrompt.includes(trigger);
      } else {
        // Word boundary matching for single words
        const regex = new RegExp(`\\b${trigger}\\b`, 'i');
        return regex.test(lowerPrompt);
      }
    });

    if (matchedTriggers.length > 0) {
      console.error(`  ✓ Matched skill: ${skill.name} (${matchedTriggers.length} triggers: ${matchedTriggers.join(', ')})`);
      matched.push({
        skill,
        matchCount: matchedTriggers.length,
        matchedTriggers
      });
    }
  }

  // Sort by match count (descending) - best match first
  matched.sort((a, b) => b.matchCount - a.matchCount);

  return matched;
}

/**
 * Determine voice language enforcement rule
 * Returns 'SPECIALIST_LANG', 'ALTERNATIVE_LANG', or 'NEUTRAL'
 */
function getVoiceLanguageRule(skill: SkillMetadata): 'SPECIALIST_LANG' | 'ALTERNATIVE_LANG' | 'NEUTRAL' {
  const accent = (skill.voice_accent || '').toLowerCase();

  // Customize these for your voice configuration
  if (accent.includes('british') || accent.includes('american')) return 'SPECIALIST_LANG';
  if (accent.includes('swedish') || accent.includes('german') || accent.includes('french')) return 'ALTERNATIVE_LANG';
  return 'NEUTRAL';
}

/**
 * Generate context loading enforcement (MUST come first)
 */
function generateContextEnforcement(): string {
  return `
## 🚨🚨🚨 STEP 0: LOAD CONTEXT FIRST 🚨🚨🚨

**BEFORE activating ANY skill, you MUST load core context:**

### MANDATORY CONTEXT LOADING:

1. ✅ **Use Read tool** to load \`\${PAI_DIR}/.claude/context/UFC.md\`
2. ✅ **Use Read tool** to load \`\${PAI_DIR}/.claude/context/projects/[PROJECT].md\`
3. ✅ **Show verification**: "✅ Context hydrated: UFC.md, [project].md"

**THIS MUST HAPPEN FIRST.**

**Why this matters:**
- Context files contain critical system architecture and project knowledge
- Skills operate 100x better WITH context loaded
- Observable verification = Trust
- PAI.md EXPLICITLY requires this

**ONLY AFTER context loading → Proceed to skill activation below**

---
`;
}

/**
 * Generate enforcement message from template
 * Substitutes {{PLACEHOLDERS}} with actual skill data
 */
function generateEnforcementMessage(primaryMatch: SkillMatch, allMatches: SkillMatch[]): string {
  const skill = primaryMatch.skill;
  const voiceRule = getVoiceLanguageRule(skill);

  // Read enforcement template
  const paiDir = getPAIDir();
  const templatePath = join(paiDir, '.claude', 'hooks', 'templates', 'skill-activation-enforcement.md');

  // STEP 0: Context loading enforcement (ALWAYS first)
  let message = generateContextEnforcement();

  let template = '';
  try {
    const safePath = validateFilePath(templatePath);
    if (existsSync(safePath)) {
      template = readFileSync(safePath, 'utf-8');
    } else {
      console.error('⚠️  Template not found, using inline fallback');
      // Fallback to basic enforcement if template missing
      message += generateFallbackEnforcement(primaryMatch, allMatches);
      return message;
    }
  } catch (error) {
    console.error(`⚠️  Failed to load template: ${error}`);
    message += generateFallbackEnforcement(primaryMatch, allMatches);
    return message;
  }

  // Substitute placeholders
  let templateMessage = template
    .replace(/\{\{SKILL_NAME\}\}/g, skill.name)
    .replace(/\{\{MATCHED_TRIGGERS\}\}/g, primaryMatch.matchedTriggers.join(', '))
    .replace(/\{\{VOICE_NAME\}\}/g, skill.voice_name || 'Unknown')
    .replace(/\{\{VOICE_ACCENT\}\}/g, skill.voice_accent || 'Unknown')
    .replace(/\{\{VOICE_GENDER\}\}/g, skill.voice_gender || 'Unknown')
    .replace(/\{\{VOICE_ID\}\}/g, skill.voice_id || 'Unknown')
    .replace(/\{\{SKILL_PATH\}\}/g, skill.skillPath)
    .replace(/\{\{TASK_DESCRIPTION\}\}/g, `[Task using ${skill.name} skill]`)
    .replace(/\{\{SHORT_VOICE_MESSAGE\}\}/g, `[${skill.name} complete]`);

  // Handle conditional voice sections
  if (voiceRule === 'SPECIALIST_LANG') {
    templateMessage = templateMessage.replace(/\{\{#if SPECIALIST_LANG\}\}([\s\S]*?)\{\{\/if\}\}/g, '$1');
    templateMessage = templateMessage.replace(/\{\{#if ALTERNATIVE_LANG\}\}[\s\S]*?\{\{\/if\}\}/g, '');
    templateMessage = templateMessage.replace(/\{\{#if NEUTRAL\}\}[\s\S]*?\{\{\/if\}\}/g, '');
  } else if (voiceRule === 'ALTERNATIVE_LANG') {
    templateMessage = templateMessage.replace(/\{\{#if SPECIALIST_LANG\}\}[\s\S]*?\{\{\/if\}\}/g, '');
    templateMessage = templateMessage.replace(/\{\{#if ALTERNATIVE_LANG\}\}([\s\S]*?)\{\{\/if\}\}/g, '$1');
    templateMessage = templateMessage.replace(/\{\{#if NEUTRAL\}\}[\s\S]*?\{\{\/if\}\}/g, '');
  } else {
    templateMessage = templateMessage.replace(/\{\{#if SPECIALIST_LANG\}\}[\s\S]*?\{\{\/if\}\}/g, '');
    templateMessage = templateMessage.replace(/\{\{#if ALTERNATIVE_LANG\}\}[\s\S]*?\{\{\/if\}\}/g, '');
    templateMessage = templateMessage.replace(/\{\{#if NEUTRAL\}\}([\s\S]*?)\{\{\/if\}\}/g, '$1');
  }

  // Add template to message (after context enforcement)
  message += templateMessage;

  // R1-1: Multi-skill coordination
  if (allMatches.length > 1) {
    const alternativeSkills = allMatches.slice(1)
      .filter(m => m.matchCount >= 2) // Only strong secondary matches
      .map(m => m.skill.name);

    if (alternativeSkills.length > 0) {
      const multiSkillSection = `

---

### 🔗 MULTI-SKILL COORDINATION DETECTED

**This task matches ${allMatches.length} skills strongly:**

1. **Primary**: ${skill.name} (${primaryMatch.matchCount} triggers)
${alternativeSkills.map((name, idx) => `${idx + 2}. **Secondary**: ${name} (${allMatches[idx + 1].matchCount} triggers)`).join('\n')}

**COORDINATION PROTOCOL:**

If this task requires multiple specialists:
1. Start with primary skill: ${skill.name}
2. After ${skill.name} completes, evaluate if secondary skills needed
3. Activate secondary skills sequentially (NOT in parallel for voice clarity)
4. Use [COORDINATED:${skill.name}+${alternativeSkills[0]}] tag if multiple skills used

**Example workflow:**
- ${skill.name} → Analyze and design approach
- ${alternativeSkills[0]} → Implement the design
- Main assistant → Synthesize and report completion

---
`;
      message += multiSkillSection;
    }
  }

  return message;
}

/**
 * Fallback enforcement if template missing
 */
function generateFallbackEnforcement(primaryMatch: SkillMatch, allMatches: SkillMatch[]): string {
  const skill = primaryMatch.skill;

  return `
## 🚨🚨🚨 MANDATORY SKILL ACTIVATION 🚨🚨🚨

**CRITICAL: Skill match detected - MUST activate before proceeding**

**Matched Skill**: ${skill.name}
**Voice**: ${skill.voice_name || 'Unknown'} (${skill.voice_accent || 'Unknown'})
**Triggers Matched**: ${primaryMatch.matchedTriggers.join(', ')}

**MANDATORY STEPS:**

1. ✅ Show activation: "✅ Skill activated: ${skill.name} (${skill.voice_name})"
2. 📖 Read skill: Use Read tool on \`${skill.skillPath}\`
3. 🔄 Follow skill workflow defined in SKILL.md
4. 🎤 Use ${skill.voice_name}'s voice and language rules
5. 🏷️ Include [SKILL:${skill.name}] in COMPLETED message

**DO NOT proceed without completing ALL steps.**

**Why**: ${skill.description}

---
`;
}

async function main() {
  try {
    // Read hook input
    const data = await readStdinJSON<HookInput>();

    // Validate prompt input
    const safePrompt = validatePrompt(data.prompt);
    data.prompt = safePrompt;

    // Get PAI directory
    const paiDir = getPAIDir();

    console.error('🚨 SKILL ACTIVATION ENFORCER (Dimension 4)');
    console.error(`  Prompt: ${sanitizeForLog(safePrompt)}`);

    // Skip if subagent
    if (isSubagent()) {
      console.error('  Subagent detected - skipping enforcement');
      process.exit(0);
    }

    // Load Tier 1 metadata from SKILLS-INDEX.md (or fallback to directory scan)
    const allSkills = loadAllSkillsMetadata(paiDir);

    // Match skills against prompt
    const matchedSkills = matchSkills(safePrompt, allSkills);

    // If no skills matched, exit silently
    if (matchedSkills.length === 0) {
      console.error('  No skills matched - exiting silently');
      process.exit(0);
    }

    console.error(`  ✅ ${matchedSkills.length} skill(s) matched`);

    // R1-2: Generate enforcement with observable verification
    const primaryMatch = matchedSkills[0];
    const enforcementMessage = generateEnforcementMessage(primaryMatch, matchedSkills);

    // Wrap in system-reminder for injection
    const message = `<system-reminder>
${enforcementMessage}
</system-reminder>`;

    // Output to stdout (captured by Claude Code)
    console.log(message);

    console.error(`✅ Injected skill activation enforcement for: ${primaryMatch.skill.name}`);
    console.error('');
    process.exit(0);
  } catch (error) {
    // Fail silently to not interrupt Claude's flow
    console.error('Skill activation enforcer error:', error);
    process.exit(0);
  }
}

main();
