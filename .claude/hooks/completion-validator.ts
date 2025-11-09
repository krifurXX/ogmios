#!/usr/bin/env bun

/**
 * completion-validator.ts
 *
 * ADR-020: Stop Hook Completion Validator (Layer 3)
 *
 * PURPOSE:
 * Validate responses for proper skill usage and compliance with skill-routing
 * recommendations. This hook implements post-hoc validation to provide observability
 * and feedback for continuous improvement of the skill activation system.
 *
 * CORE FUNCTIONALITY:
 * 1. Response Validation - Check for proper COMPLETED format
 * 2. Skill Tag Verification - Verify [SKILL:] tag present when required
 * 3. Skill Accuracy - Verify correct skill was used for task type
 * 4. Voice Consistency - Verify specialist voices used appropriately
 * 5. Observability - Comprehensive logging and metrics
 *
 * VALIDATION RULES:
 * - IF task required TIER 1 skill → Verify [SKILL:] tag present
 * - IF [SKILL:] present → Verify correct skill for task type
 * - IF no skill used → Check if task was simple question (acceptable)
 * - Specialist voices → MUST use [SKILL:] (specialist work)
 * - Generalist voices → Only for coordination or simple questions
 *
 * VIOLATION SEVERITY:
 * - LOW: Wrong skill used (logs warning)
 * - MEDIUM: Clear skill bypass (logs error + reminder)
 * - HIGH: Repeated violations (blocks + strong reminder)
 *
 * OBSERVABILITY:
 * - Logs validation results to completion-validator.jsonl
 * - Tracks compliance rate over time
 * - Identifies patterns of skill bypass
 * - Generates weekly summary reports
 *
 * IMPORTANT:
 * - This is VALIDATION, not ENFORCEMENT
 * - Does NOT block responses (post-hoc analysis)
 * - Provides FEEDBACK for continuous improvement
 * - Performance target: <50ms
 *
 * SANITIZED VERSION - Replace voice IDs with your own
 *
 * Based on Ogmios PAI system (Daniel Miessler's Kai architecture)
 */

import { readStdinJSON, writeMetrics, readMetricsLast, getPAIDir, isSubagent, extractCompletionTags, readLastExchange, getSessionId, formatTimestamp, formatDuration } from './lib/hook-utils.ts';
import { validateTranscriptPath } from './lib/validation.ts';
import { readFileSync, existsSync, writeFileSync } from 'fs';
import { join } from 'path';

// ============================================================================
// TYPES
// ============================================================================

interface HookInput {
  session_id: string;
  transcript_path: string;
  hook_event_name: string;
}

interface ValidationResult {
  hasCompletedTag: boolean;
  hasSkillTag: boolean;
  skillUsed: string | null;
  expectedSkill: string | null;
  taskType: string | null;
  wasSkillRequired: boolean;
  compliance: 'compliant' | 'violation_bypass' | 'violation_wrong_skill' | 'warning_ambiguous';
  severity: 'none' | 'low' | 'medium' | 'high';
  reason: string;
  voiceConsistency: {
    voiceUsed: string | null;
    expectedSpecialist: boolean;
    isConsistent: boolean;
  };
}

interface ValidationMetrics {
  sessionId: string;
  timestamp: string;
  result: ValidationResult;
  userPrompt: string;
  promptLength: number;
  responseLength: number;
  processingTimeMs: number;
  routingDecision?: {
    wasRouted: boolean;
    recommendedSkill: string | null;
    confidence: number;
  };
}

interface ViolationSummary {
  totalValidations: number;
  complianceCount: number;
  violationCount: number;
  complianceRate: number;
  violationsByType: {
    bypass: number;
    wrongSkill: number;
    ambiguous: number;
  };
  violationsBySeverity: {
    low: number;
    medium: number;
    high: number;
  };
}

// ============================================================================
// CONFIGURATION
// ============================================================================

const MAX_PROCESSING_TIME_MS = 50; // Performance requirement from ADR-020
const METRICS_FILE = 'completion-validator.jsonl';
const SUMMARY_FILE = 'validation-summary.json';

// Specialist voice IDs (configure with your own voice IDs)
// Replace <VOICE_ID_*> with your actual ElevenLabs voice IDs
const SPECIALIST_VOICES = [
  '<VOICE_ID_ENGINEER>',       // Engineering specialist
  '<VOICE_ID_ARCHITECT>',      // Architecture specialist
  '<VOICE_ID_DESIGNER>',       // Design specialist
  '<VOICE_ID_TECHNICAL_WRITER>', // Technical writing specialist
  '<VOICE_ID_DATA_ANALYST>',   // Data analysis specialist
  '<VOICE_ID_SECURITY>',       // Security specialist
  '<VOICE_ID_DEVOPS>',         // DevOps specialist
  '<VOICE_ID_RESEARCHER>',     // Research specialist
];

// Generalist voices (configure with your own voice IDs)
const GENERALIST_VOICES = [
  '<VOICE_ID_ASSISTANT_ENGLISH>',  // Main assistant (English)
  '<VOICE_ID_ASSISTANT_ALT_LANGUAGE>', // Main assistant (alternative language)
];

// ============================================================================
// TASK TYPE DETECTION (From Layer 2)
// ============================================================================

/**
 * Detect task type from user prompt
 * Reuses logic from user-prompt-skill-router.ts
 */
function detectTaskType(prompt: string): string | null {
  const lowerPrompt = prompt.toLowerCase();

  // Check documentation/writing tasks FIRST (more specific)
  // Technical Writing - MUST come before engineering to avoid false positives
  if (/\b(write|create|draft|update)\s+.*\s+(readme|documentation|docs|guide|tutorial)/i.test(prompt) ||
      /\b(write|create)\s+(a|an|the)\s+.*\s+(readme|documentation|guide)/i.test(prompt) ||
      /\b(document|explain)\s+.*\s+(how\s+to|api|feature)/i.test(prompt)) {
    return 'technical-writing';
  }

  // Academic Writing
  if (/\b(skriv|skapa|författa)\s+(akademisk|vetenskaplig)/i.test(prompt) ||
      /\b(write|create)\s+(academic|scientific)\s+(paper|article)/i.test(prompt) ||
      /\b(avhandling|uppsats|artikel|rapport|thesis|dissertation)/i.test(prompt)) {
    return 'academic-writing';
  }

  // Architecture (more specific than engineering)
  if (/\b(design|architect|plan)\s+.*\s+(system|architecture|solution|microservice)/i.test(prompt) ||
      /\b(design|architect)\s+(the|a|an)\s+.*\s+(architecture|system)/i.test(prompt) ||
      /\b(create|write|draft)\s+(adr|architecture\s+decision)/i.test(prompt)) {
    return 'architecture';
  }

  // Design (UI/UX - more specific)
  if (/\b(design|create|build|make)\s+.*\s+(ui|ux|interface|mockup|wireframe|prototype|dashboard)/i.test(prompt) ||
      /\b(create|make)\s+(a|an|the)\s+.*\s+(mockup|wireframe|prototype|interface)/i.test(prompt) ||
      /\b(user\s+experience|user\s+interface|user\s+flow)/i.test(prompt)) {
    return 'design';
  }

  // Engineering (general code/implementation)
  if (/\b(build|implement|code|create|develop|write)\s+.*\s+(function|class|component|module|api|service|feature|application|system)/i.test(prompt) ||
      /\b(build|implement|create)\s+(a|an|the)\s+.*\s+(component|module|api|service|feature)/i.test(prompt) ||
      /\b(fix|debug|resolve|solve)\s+.*\s+(bug|issue|error|problem)/i.test(prompt) ||
      /\b(optimize|improve|refactor|enhance)\s+.*\s+(code|performance|algorithm)/i.test(prompt)) {
    return 'engineering';
  }

  // Data Analysis
  if (/\b(analyze|analyse|study|examine)\s+(data|dataset|metrics|statistics)/i.test(prompt) ||
      /\b(regression|correlation|hypothesis\s+test)/i.test(prompt)) {
    return 'data-analysis';
  }

  // Security
  if (/\b(security|säkerhet)\s+(audit|review|assessment|granskning)/i.test(prompt) ||
      /\b(threat\s+model|vulnerability|penetration\s+test|pentest)/i.test(prompt)) {
    return 'security';
  }

  // DevOps
  if (/\b(deploy|deployment|pipeline|ci\/cd)/i.test(prompt) ||
      /\b(docker|kubernetes|container|orchestration)/i.test(prompt) ||
      /\b(infrastructure|terraform|cloudformation)/i.test(prompt)) {
    return 'devops';
  }

  // Knowledge Management
  if (/\b(arkivet|zettelkasten|pkm|personal\s+knowledge)/i.test(prompt) ||
      /\b(skapa|skriv|create|write)\s+.*\s+(anteckning|note|blogg|blog\s+post)/i.test(prompt)) {
    return 'knowledge-management';
  }

  // Academic Research
  if (/\b(search|find|look\s+for)\s+.*\s+(papers|research|studies|literature)/i.test(prompt) ||
      /\b(literature\s+review|systematic\s+review)/i.test(prompt) ||
      /\b(zotero|academic\s+search)/i.test(prompt)) {
    return 'academic-research';
  }

  // No clear task type detected
  return null;
}

/**
 * Check if prompt is a question (not an action request)
 */
function isQuestion(prompt: string): boolean {
  const questionStarts = /^(what|how|why|when|where|who|which|can\s+you|could\s+you|would\s+you|tell\s+me|explain)\s+/i;
  const endsWithQuestion = /\?\s*$/;
  return questionStarts.test(prompt.trim()) || endsWithQuestion.test(prompt.trim());
}

/**
 * Check if task required TIER 1 skill activation
 */
function wasSkillRequired(taskType: string | null, prompt: string): boolean {
  // If no task type detected, skill was not required
  if (!taskType) return false;

  // If prompt is a simple question, skill was not required
  if (isQuestion(prompt) && prompt.length < 100) return false;

  // Otherwise, if we detected a TIER 1 task type, skill was required
  return true;
}

// ============================================================================
// RESPONSE PARSING
// ============================================================================

/**
 * Extract voice ID from response (if available)
 */
function extractVoiceId(response: string): string | null {
  // Look for voice_id mentions in the response
  const voiceMatch = response.match(/voice[_\s]id:\s*([a-zA-Z0-9]+)/i);
  return voiceMatch ? voiceMatch[1] : null;
}

// ============================================================================
// VALIDATION LOGIC
// ============================================================================

/**
 * Validate response for skill usage compliance
 */
function validateResponse(
  userPrompt: string,
  assistantResponse: string,
  routingDecision?: any
): ValidationResult {
  const taskType = detectTaskType(userPrompt);
  const skillRequired = wasSkillRequired(taskType, userPrompt);
  const { hasCompletedTag, completedContent, hasSkillTag, skillUsed } = extractCompletionTags(assistantResponse);

  // Determine expected skill
  const expectedSkill = routingDecision?.primarySkill || taskType;

  // Validate voice consistency
  const voiceId = extractVoiceId(assistantResponse);
  const isSpecialistVoice = voiceId ? SPECIALIST_VOICES.includes(voiceId) : false;
  const expectedSpecialist = skillRequired && hasSkillTag;

  let compliance: ValidationResult['compliance'] = 'compliant';
  let severity: ValidationResult['severity'] = 'none';
  let reason = '';

  // Validation rules
  if (!hasCompletedTag) {
    // No COMPLETED tag - this is a formatting issue, not skill compliance
    compliance = 'warning_ambiguous';
    severity = 'low';
    reason = 'Response missing COMPLETED: tag';
  } else if (skillRequired && !hasSkillTag) {
    // VIOLATION: Skill was required but not used
    compliance = 'violation_bypass';
    severity = 'medium';
    reason = `TIER 1 task (${taskType}) should have used skill, but no [SKILL:] tag found`;
  } else if (hasSkillTag && expectedSkill && skillUsed !== expectedSkill) {
    // VIOLATION: Wrong skill used
    compliance = 'violation_wrong_skill';
    severity = 'low';
    reason = `Expected [SKILL:${expectedSkill}], but used [SKILL:${skillUsed}]`;
  } else if (!skillRequired && hasSkillTag) {
    // Skill used for simple question - not ideal but acceptable
    compliance = 'warning_ambiguous';
    severity = 'low';
    reason = 'Skill used for simple question/task (acceptable but may be overkill)';
  } else {
    // Compliant
    if (hasSkillTag) {
      reason = `Correct skill usage: [SKILL:${skillUsed}] for task type ${taskType}`;
    } else {
      reason = 'No skill required for this task type';
    }
  }

  return {
    hasCompletedTag,
    hasSkillTag,
    skillUsed,
    expectedSkill,
    taskType,
    wasSkillRequired: skillRequired,
    compliance,
    severity,
    reason,
    voiceConsistency: {
      voiceUsed: voiceId,
      expectedSpecialist,
      isConsistent: !expectedSpecialist || isSpecialistVoice,
    },
  };
}

// ============================================================================
// OBSERVABILITY
// ============================================================================

/**
 * Update summary statistics
 */
function updateSummary(result: ValidationResult, paiDir: string): void {
  try {
    const metricsDir = join(paiDir, '.claude/metrics');
    const summaryFile = join(metricsDir, SUMMARY_FILE);

    // Load existing summary or create new
    let summary: ViolationSummary;
    if (existsSync(summaryFile)) {
      summary = JSON.parse(readFileSync(summaryFile, 'utf-8'));
    } else {
      summary = {
        totalValidations: 0,
        complianceCount: 0,
        violationCount: 0,
        complianceRate: 0,
        violationsByType: { bypass: 0, wrongSkill: 0, ambiguous: 0 },
        violationsBySeverity: { low: 0, medium: 0, high: 0 },
      };
    }

    // Update counts
    summary.totalValidations++;

    if (result.compliance === 'compliant') {
      summary.complianceCount++;
    } else {
      summary.violationCount++;

      // Update by type
      if (result.compliance === 'violation_bypass') {
        summary.violationsByType.bypass++;
      } else if (result.compliance === 'violation_wrong_skill') {
        summary.violationsByType.wrongSkill++;
      } else if (result.compliance === 'warning_ambiguous') {
        summary.violationsByType.ambiguous++;
      }

      // Update by severity
      if (result.severity === 'low') {
        summary.violationsBySeverity.low++;
      } else if (result.severity === 'medium') {
        summary.violationsBySeverity.medium++;
      } else if (result.severity === 'high') {
        summary.violationsBySeverity.high++;
      }
    }

    // Calculate compliance rate
    summary.complianceRate = summary.totalValidations > 0
      ? summary.complianceCount / summary.totalValidations
      : 0;

    // Write updated summary
    writeFileSync(summaryFile, JSON.stringify(summary, null, 2));
  } catch (error) {
    console.error(`⚠️ Failed to update summary: ${error}`);
  }
}

/**
 * Read routing decision from skill-router metrics
 */
function getRoutingDecision(sessionId: string, paiDir: string): any {
  try {
    const metrics = readMetricsLast('skill-router.jsonl', 100, paiDir);

    // Find routing decision for this session
    for (let i = metrics.length - 1; i >= 0; i--) {
      if (metrics[i].sessionId === sessionId) {
        return {
          wasRouted: metrics[i].decision?.shouldActivate,
          recommendedSkill: metrics[i].decision?.primarySkill,
          confidence: metrics[i].decision?.confidence,
        };
      }
    }

    return null;
  } catch (error) {
    console.error(`⚠️ Failed to read routing decision: ${error}`);
    return null;
  }
}

// ============================================================================
// MAIN FUNCTION
// ============================================================================

async function main() {
  const startTime = Date.now();

  try {
    // Read hook input
    const data = await readStdinJSON<HookInput>();

    // Get PAI directory
    const paiDir = getPAIDir();

    console.error('');
    console.error('✅ ============================================================================');
    console.error('✅ COMPLETION VALIDATOR (Layer 3) - POST-HOC VALIDATION');
    console.error('✅ ============================================================================');
    console.error('');

    // Check if this is a subagent - if so, exit silently
    if (isSubagent()) {
      console.error('🤖 Subagent detected - skipping validation (subagent has own context)');
      console.error('');
      process.exit(0);
    }

    // Read transcript to get user prompt and assistant response
    console.error('📜 Reading transcript...');
    const safeTranscriptPath = validateTranscriptPath(data.transcript_path);
    const { lastUserPrompt, lastAssistantResponse } = readLastExchange(safeTranscriptPath);

    if (!lastUserPrompt || !lastAssistantResponse) {
      console.error('⚠️ Could not extract prompt/response from transcript');
      console.error('');
      process.exit(0);
    }

    console.error(`📝 User prompt: ${lastUserPrompt.substring(0, 100)}...`);
    console.error(`📝 Response length: ${lastAssistantResponse.length} characters`);
    console.error('');

    // Get routing decision if available
    const routingDecision = getRoutingDecision(data.session_id, paiDir);
    if (routingDecision) {
      console.error('🎯 Routing decision found:');
      console.error(`   Recommended skill: ${routingDecision.recommendedSkill || 'None'}`);
      console.error(`   Was routed: ${routingDecision.wasRouted ? 'Yes' : 'No'}`);
      console.error('');
    }

    // Validate response
    console.error('🔍 Validating response...');
    const result = validateResponse(lastUserPrompt, lastAssistantResponse, routingDecision);

    // Display validation results
    console.error('');
    console.error('📊 VALIDATION RESULTS:');
    console.error(`   Compliance: ${result.compliance}`);
    console.error(`   Severity: ${result.severity}`);
    console.error(`   Has COMPLETED tag: ${result.hasCompletedTag ? 'Yes' : 'No'}`);
    console.error(`   Has [SKILL:] tag: ${result.hasSkillTag ? 'Yes' : 'No'}`);
    console.error(`   Skill used: ${result.skillUsed || 'None'}`);
    console.error(`   Expected skill: ${result.expectedSkill || 'None'}`);
    console.error(`   Task type: ${result.taskType || 'None'}`);
    console.error(`   Was skill required: ${result.wasSkillRequired ? 'Yes' : 'No'}`);
    console.error(`   Reason: ${result.reason}`);
    console.error('');

    // Voice consistency check
    if (result.voiceConsistency.expectedSpecialist) {
      console.error('🎤 VOICE CONSISTENCY:');
      console.error(`   Voice used: ${result.voiceConsistency.voiceUsed || 'Unknown'}`);
      console.error(`   Expected Specialist: ${result.voiceConsistency.expectedSpecialist ? 'Yes' : 'No'}`);
      console.error(`   Is consistent: ${result.voiceConsistency.isConsistent ? 'Yes' : 'No'}`);
      console.error('');
    }

    // Performance check
    const processingTime = Date.now() - startTime;
    console.error('⚡ PERFORMANCE:');
    console.error(`   Processing time: ${formatDuration(processingTime)}`);
    if (processingTime > MAX_PROCESSING_TIME_MS) {
      console.error(`   ⚠️ WARNING: Exceeds target ${MAX_PROCESSING_TIME_MS}ms`);
    } else {
      console.error(`   ✅ Within target ${MAX_PROCESSING_TIME_MS}ms`);
    }
    console.error('');

    // Write metrics
    const metrics: ValidationMetrics = {
      sessionId: getSessionId(data),
      timestamp: formatTimestamp(),
      result,
      userPrompt: lastUserPrompt.substring(0, 200), // Truncate for privacy
      promptLength: lastUserPrompt.length,
      responseLength: lastAssistantResponse.length,
      processingTimeMs: processingTime,
      routingDecision: routingDecision || undefined,
    };

    writeMetrics(METRICS_FILE, metrics, paiDir);
    updateSummary(result, paiDir);

    console.error('📊 Metrics written to completion-validator.jsonl');
    console.error('');

    // Display violation warnings
    if (result.compliance !== 'compliant') {
      console.error('⚠️ ========================================================================');
      console.error(`⚠️ VALIDATION ${result.severity.toUpperCase()}: ${result.compliance.toUpperCase()}`);
      console.error('⚠️ ========================================================================');
      console.error('');
      console.error(result.reason);
      console.error('');

      if (result.severity === 'medium' || result.severity === 'high') {
        console.error('💡 RECOMMENDATION:');
        console.error('   Review enforcement system');
        console.error('   Check skill-router patterns');
        console.error('   Verify skill activation instructions are clear');
        console.error('');
      }
    } else {
      console.error('✅ ========================================================================');
      console.error('✅ VALIDATION PASSED - COMPLIANT SKILL USAGE');
      console.error('✅ ========================================================================');
      console.error('');
    }

    // Display summary statistics
    const metricsDir = join(paiDir, '.claude/metrics');
    const summaryFile = join(metricsDir, SUMMARY_FILE);
    if (existsSync(summaryFile)) {
      const summary: ViolationSummary = JSON.parse(readFileSync(summaryFile, 'utf-8'));
      console.error('📈 SUMMARY STATISTICS:');
      console.error(`   Total validations: ${summary.totalValidations}`);
      console.error(`   Compliance rate: ${(summary.complianceRate * 100).toFixed(1)}%`);
      console.error(`   Violations: ${summary.violationCount}`);
      console.error(`     - Bypass: ${summary.violationsByType.bypass}`);
      console.error(`     - Wrong skill: ${summary.violationsByType.wrongSkill}`);
      console.error(`     - Ambiguous: ${summary.violationsByType.ambiguous}`);
      console.error('');
    }

    console.error('✅ ============================================================================');
    console.error('✅ COMPLETION VALIDATOR COMPLETE');
    console.error('✅ ============================================================================');
    console.error('');

    process.exit(0);

  } catch (error) {
    const processingTime = Date.now() - startTime;

    console.error('');
    console.error('❌ ========================================================================');
    console.error('❌ ERROR IN COMPLETION VALIDATOR');
    console.error('❌ ========================================================================');
    console.error('');
    console.error(`Error: ${error}`);
    console.error(`Processing time: ${formatDuration(processingTime)}`);
    console.error('');

    // Fail gracefully - don't block if validation fails
    process.exit(0);
  }
}

main();
