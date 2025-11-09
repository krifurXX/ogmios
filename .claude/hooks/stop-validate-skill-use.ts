#!/usr/bin/env bun
/**
 * Stop Hook: Validate Skill Usage
 *
 * Layer 3: VERIFY skill was used when expected.
 * Creates feedback loop for skill activation success rate.
 *
 * Purpose: Detect when skills are bypassed despite routing.
 * Enforcement: Validation → Logging → Metrics → Alerts
 *
 * Based on Ogmios PAI system (Daniel Miessler's Kai architecture)
 * SANITIZED VERSION - All personal data removed
 */

import { readFileSync, existsSync, mkdirSync, appendFileSync } from 'fs';
import { join } from 'path';
import { readStdinJSON, getPAIDir, isSubagent, extractCompletionTags } from './lib/hook-utils.ts';
import { validateTranscriptPath } from './lib/validation.ts';

// ============================================================================
// TYPES
// ============================================================================

interface HookInput {
  session_id: string;
  transcript_path: string;
  hook_event_name: string;
}

interface TranscriptMessage {
  type: 'user' | 'assistant' | 'system';
  content: string;
  timestamp?: string;
}

interface ValidationResult {
  skillExpected: boolean;
  skillUsed: boolean;
  skillName: string | null;
  hasCompleted: boolean;
  hasSkillTag: boolean;
  violationType: 'none' | 'missing_skill' | 'missing_tag' | 'bypass';
  message: string;
}

interface ValidationMetrics {
  sessionId: string;
  timestamp: string;
  validation: ValidationResult;
  lastUserPrompt: string;
  lastAssistantResponse: string;
}

// ============================================================================
// CONFIGURATION
// ============================================================================

const SKILL_TAG_PATTERN = /\[SKILL:([a-zA-Z0-9_-]+)\]/;

/**
 * Parse transcript file to get messages
 */
function parseTranscript(transcriptPath: string): TranscriptMessage[] {
  try {
    const content = readFileSync(transcriptPath, 'utf-8');
    const lines = content.split('\n').filter(line => line.trim());

    const messages: TranscriptMessage[] = [];

    for (const line of lines) {
      try {
        const msg = JSON.parse(line);

        // Handle different transcript formats
        if (msg.type && msg.message?.content) {
          // Claude Code format
          const contentData = msg.message.content;
          let textContent = '';

          if (typeof contentData === 'string') {
            textContent = contentData;
          } else if (Array.isArray(contentData)) {
            textContent = contentData
              .map((c: any) => c.text || c.content || '')
              .join(' ');
          }

          if (textContent) {
            messages.push({
              type: msg.type,
              content: textContent,
              timestamp: msg.timestamp
            });
          }
        } else if (msg.type && msg.content) {
          // Simple format
          messages.push(msg);
        }
      } catch {
        // Skip invalid JSON lines
      }
    }

    return messages;
  } catch (error) {
    console.error(`⚠️  Failed to parse transcript: ${error}`);
    return [];
  }
}

/**
 * Check if last exchange expected skill activation
 * Looks for Layer 2 routing injection
 */
function wasSkillExpected(systemMessages: TranscriptMessage[]): { expected: boolean; skillName: string | null } {
  // Check last system messages for Layer 2 routing injection
  for (let i = systemMessages.length - 1; i >= 0; i--) {
    const msg = systemMessages[i];
    if (msg.content.includes('AUTOMATIC SKILL ACTIVATION') ||
        msg.content.includes('SKILL ACTIVATION ENFORCER') ||
        msg.content.includes('MANDATORY SKILL ACTIVATION')) {
      // Extract skill name from routing message
      const skillMatch = msg.content.match(/\*\*(?:Primary |Matched )?Skill:\*\*\s+([a-zA-Z0-9_-]+)/);
      return {
        expected: true,
        skillName: skillMatch ? skillMatch[1] : null
      };
    }
  }

  return { expected: false, skillName: null };
}

/**
 * Validate skill usage in assistant response
 */
function validateSkillUsage(
  assistantMessages: TranscriptMessage[],
  expectedSkill: string | null
): ValidationResult {
  if (!expectedSkill) {
    return {
      skillExpected: false,
      skillUsed: false,
      skillName: null,
      hasCompleted: false,
      hasSkillTag: false,
      violationType: 'none',
      message: 'No skill routing in this exchange'
    };
  }

  // Get last assistant message
  const lastAssistant = assistantMessages[assistantMessages.length - 1];
  if (!lastAssistant) {
    return {
      skillExpected: true,
      skillUsed: false,
      skillName: expectedSkill,
      hasCompleted: false,
      hasSkillTag: false,
      violationType: 'bypass',
      message: 'No assistant response found'
    };
  }

  const content = lastAssistant.content;
  const { hasCompletedTag, hasSkillTag, skillUsed } = extractCompletionTags(content);

  // Validation logic
  if (!hasCompletedTag) {
    return {
      skillExpected: true,
      skillUsed: false,
      skillName: expectedSkill,
      hasCompleted: false,
      hasSkillTag: false,
      violationType: 'missing_tag',
      message: 'Missing COMPLETED message (incomplete response)'
    };
  }

  if (!hasSkillTag) {
    return {
      skillExpected: true,
      skillUsed: false,
      skillName: expectedSkill,
      hasCompleted: true,
      hasSkillTag: false,
      violationType: 'bypass',
      message: `Skill ${expectedSkill} was expected but no [SKILL:] tag found - SKILLS BYPASS!`
    };
  }

  if (skillUsed !== expectedSkill) {
    return {
      skillExpected: true,
      skillUsed: true,
      skillName: skillUsed,
      hasCompleted: true,
      hasSkillTag: true,
      violationType: 'bypass',
      message: `Wrong skill used: expected ${expectedSkill}, got ${skillUsed}`
    };
  }

  // Success!
  return {
    skillExpected: true,
    skillUsed: true,
    skillName: skillUsed,
    hasCompleted: true,
    hasSkillTag: true,
    violationType: 'none',
    message: `✅ Skill ${skillUsed} used correctly`
  };
}

/**
 * Write validation metrics to file
 */
function writeMetrics(metrics: ValidationMetrics, paiDir: string): void {
  try {
    const metricsDir = join(paiDir, '.claude/metrics');

    if (!existsSync(metricsDir)) {
      mkdirSync(metricsDir, { recursive: true });
    }

    const metricsFile = join(metricsDir, 'skill-validation.jsonl');
    const metricsLine = JSON.stringify(metrics) + '\n';

    appendFileSync(metricsFile, metricsLine);
  } catch (error) {
    console.error(`⚠️  Failed to write validation metrics: ${error}`);
  }
}

/**
 * Log violation to alerts file (for high-visibility monitoring)
 */
function logViolation(validation: ValidationResult, paiDir: string): void {
  if (validation.violationType === 'none') return;

  try {
    const alertsDir = join(paiDir, '.claude/alerts');

    if (!existsSync(alertsDir)) {
      mkdirSync(alertsDir, { recursive: true });
    }

    const alertsFile = join(alertsDir, 'skills-bypass-alerts.log');
    const timestamp = new Date().toISOString();
    const alertLine = `[${timestamp}] ${validation.violationType.toUpperCase()}: ${validation.message}\n`;

    appendFileSync(alertsFile, alertLine);

    console.error('🚨 ALERT logged to skills-bypass-alerts.log');
  } catch (error) {
    console.error(`⚠️  Failed to log alert: ${error}`);
  }
}

// ============================================================================
// MAIN FUNCTION
// ============================================================================

async function main() {
  try {
    // Read hook input
    const data = await readStdinJSON<HookInput>();

    const paiDir = getPAIDir();

    console.error('');
    console.error('🔍 ============================================================================');
    console.error('🔍 SKILL VALIDATION HOOK (Layer 3) - VERIFY SKILL USAGE');
    console.error('🔍 ============================================================================');
    console.error('');

    // Check if this is a subagent - if so, skip validation
    if (isSubagent()) {
      console.error('🤖 Subagent detected - skipping validation');
      console.error('');
      process.exit(0);
    }

    // Parse transcript
    console.error('📖 Reading transcript...');
    const safeTranscriptPath = validateTranscriptPath(data.transcript_path);
    const messages = parseTranscript(safeTranscriptPath);

    if (messages.length === 0) {
      console.error('⚠️  No messages in transcript - skipping validation');
      console.error('');
      process.exit(0);
    }

    console.error(`   Found ${messages.length} messages`);
    console.error('');

    // Separate by type
    const userMessages = messages.filter(m => m.type === 'user');
    const assistantMessages = messages.filter(m => m.type === 'assistant');
    const systemMessages = messages.filter(m => m.type === 'system');

    // Check if skill was expected (Layer 2 routing)
    console.error('🎯 Checking if skill was expected...');
    const { expected, skillName } = wasSkillExpected(systemMessages);

    if (expected) {
      console.error(`   ✅ Yes - Layer 2 routed to: ${skillName}`);
    } else {
      console.error('   ℹ️  No - generalist mode OK');
    }
    console.error('');

    // Validate skill usage
    console.error('🔍 Validating skill usage in response...');
    const validation = validateSkillUsage(assistantMessages, skillName);

    console.error(`   Expected: ${validation.skillExpected ? 'Yes' : 'No'}`);
    console.error(`   Used: ${validation.skillUsed ? 'Yes' : 'No'}`);
    console.error(`   Skill: ${validation.skillName || 'None'}`);
    console.error(`   Has COMPLETED: ${validation.hasCompleted ? 'Yes' : 'No'}`);
    console.error(`   Has [SKILL:] tag: ${validation.hasSkillTag ? 'Yes' : 'No'}`);
    console.error(`   Violation: ${validation.violationType}`);
    console.error('');

    // Report result
    if (validation.violationType === 'none') {
      console.error('✅ ========================================================================');
      console.error('✅ VALIDATION PASSED');
      console.error('✅ ========================================================================');
      console.error(`   ${validation.message}`);
    } else {
      console.error('🚨 ========================================================================');
      console.error('🚨 VALIDATION FAILED - SKILLS BYPASS DETECTED!');
      console.error('🚨 ========================================================================');
      console.error(`   ${validation.message}`);
      console.error('');
      console.error('   Layer 3 has detected this bypass.');
      console.error('   Alert logged for review.');
    }
    console.error('');

    // Write metrics
    const lastUser = userMessages[userMessages.length - 1];
    const lastAssistant = assistantMessages[assistantMessages.length - 1];

    const metrics: ValidationMetrics = {
      sessionId: data.session_id,
      timestamp: new Date().toISOString(),
      validation,
      lastUserPrompt: lastUser ? lastUser.content.substring(0, 200) : '',
      lastAssistantResponse: lastAssistant ? lastAssistant.content.substring(0, 200) : ''
    };

    writeMetrics(metrics, paiDir);
    console.error('📊 Validation metrics written to skill-validation.jsonl');

    // Log violation if any
    if (validation.violationType !== 'none') {
      logViolation(validation, paiDir);
    }

    console.error('');
    console.error('🔍 ============================================================================');
    console.error('🔍 SKILL VALIDATION COMPLETE');
    console.error('🔍 ============================================================================');
    console.error('');

    process.exit(0);

  } catch (error) {
    console.error('⚠️  Skill validation error:', error);
    console.error('⚠️  Continuing without validation...');
    console.error('');
    process.exit(0); // Don't block on validation errors
  }
}

main();
