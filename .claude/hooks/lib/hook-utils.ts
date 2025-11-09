/**
 * Common Hook Utilities
 *
 * Shared functions used across multiple hooks to reduce duplication.
 * Based on Ogmios PAI system (Daniel Miessler's Kai architecture)
 *
 * SANITIZED VERSION - All personal data removed
 *
 * Usage: import { readStdinWithTimeout, writeMetrics, ... } from './lib/hook-utils.ts'
 */

import { existsSync, mkdirSync, writeFileSync, appendFileSync } from 'fs';
import { join } from 'path';
import { homedir } from 'os';
import { validateFilePath } from './validation.ts';

// ============================================================================
// STDIN READING
// ============================================================================

/**
 * Read from stdin with timeout
 * Used by: load-ufc-context.ts, skill-router.ts, completion-validator.ts
 *
 * @param timeout - Timeout in milliseconds (default: 3000)
 * @returns Promise<string> - Data from stdin
 * @throws Error if timeout occurs or stdin error
 */
export async function readStdinWithTimeout(timeout = 3000): Promise<string> {
  return new Promise((resolve, reject) => {
    let data = '';
    const timer = setTimeout(() => {
      reject(new Error('Timeout reading from stdin'));
    }, timeout);

    process.stdin.on('data', (chunk) => {
      data += chunk.toString();
    });

    process.stdin.on('end', () => {
      clearTimeout(timer);
      resolve(data);
    });

    process.stdin.on('error', (err) => {
      clearTimeout(timer);
      reject(err);
    });
  });
}

/**
 * Read and parse JSON from stdin with timeout
 * Common pattern across all hooks
 *
 * @param timeout - Timeout in milliseconds (default: 3000)
 * @returns Promise<any> - Parsed JSON data
 * @throws Error if timeout, parse error, or stdin error
 */
export async function readStdinJSON<T = any>(timeout = 3000): Promise<T> {
  const input = await readStdinWithTimeout(timeout);
  try {
    return JSON.parse(input);
  } catch (error) {
    throw new Error(`Failed to parse JSON from stdin: ${error}`);
  }
}

// ============================================================================
// METRICS WRITING
// ============================================================================

/**
 * Write metrics to JSONL file
 * Used by: completion-validator.ts, skill-router.ts
 *
 * Pattern: Append JSON line to metrics file in PAI_DIR/.claude/metrics/
 *
 * @param metricsFileName - Name of metrics file (e.g., "skill-router.jsonl")
 * @param metrics - Metrics object to write
 * @param paiDir - Optional PAI directory (defaults to $PAI_DIR or ~/.claude)
 */
export function writeMetrics(
  metricsFileName: string,
  metrics: any,
  paiDir?: string
): void {
  try {
    const pai = paiDir || process.env.PAI_DIR || join(homedir(), '.claude');
    const metricsDir = join(pai, '.claude/metrics');

    // Ensure metrics directory exists
    if (!existsSync(metricsDir)) {
      mkdirSync(metricsDir, { recursive: true });
    }

    // Validate path before writing (security)
    const metricsFile = validateFilePath(join(metricsDir, metricsFileName), pai);

    // Append metrics as JSONL (newline-delimited JSON)
    const metricsLine = JSON.stringify(metrics) + '\n';
    appendFileSync(metricsFile, metricsLine);
  } catch (error) {
    console.error(`⚠️ Failed to write metrics to ${metricsFileName}: ${error}`);
  }
}

/**
 * Read last N lines from JSONL metrics file
 * Used by: completion-validator.ts (reading router metrics)
 *
 * @param metricsFileName - Name of metrics file
 * @param lineCount - Number of lines to read from end (default: 100)
 * @param paiDir - Optional PAI directory
 * @returns Array of parsed metrics objects
 */
export function readMetricsLast<T = any>(
  metricsFileName: string,
  lineCount = 100,
  paiDir?: string
): T[] {
  try {
    const pai = paiDir || process.env.PAI_DIR || join(homedir(), '.claude');
    const metricsDir = join(pai, '.claude/metrics');
    const metricsFile = join(metricsDir, metricsFileName);

    if (!existsSync(metricsFile)) {
      return [];
    }

    // Validate path before reading (security)
    const safeFile = validateFilePath(metricsFile, pai);

    const { readFileSync } = require('fs');
    const content = readFileSync(safeFile, 'utf-8');
    const lines = content.trim().split('\n').slice(-lineCount);

    const metrics: T[] = [];
    for (const line of lines) {
      try {
        metrics.push(JSON.parse(line));
      } catch (e) {
        // Skip invalid JSON lines
      }
    }

    return metrics;
  } catch (error) {
    console.error(`⚠️ Failed to read metrics from ${metricsFileName}: ${error}`);
    return [];
  }
}

// ============================================================================
// ENVIRONMENT HELPERS
// ============================================================================

/**
 * Get PAI directory path
 * Used by: Almost all hooks
 *
 * @returns PAI directory path (from $PAI_DIR or default ~/.claude)
 */
export function getPAIDir(): string {
  return process.env.PAI_DIR || join(homedir(), '.claude');
}

/**
 * Detect if running in subagent context
 * Used by: completion-validator.ts, skill-router.ts
 *
 * Subagents have different validation/routing requirements
 *
 * @returns true if running in subagent
 */
export function isSubagent(): boolean {
  const claudeProjectDir = process.env.CLAUDE_PROJECT_DIR || '';
  return (
    claudeProjectDir.includes('/.claude/agents/') ||
    process.env.CLAUDE_AGENT_TYPE !== undefined
  );
}

/**
 * Get session ID from environment or stdin data
 * Used by: Metrics writing
 *
 * @param stdinData - Optional stdin data containing session_id
 * @returns Session ID string
 */
export function getSessionId(stdinData?: any): string {
  return stdinData?.session_id || process.env.CLAUDE_SESSION_ID || 'unknown';
}

// ============================================================================
// LANGUAGE DETECTION
// ============================================================================

/**
 * Detect language from text
 * Default implementation for English. Override for bilingual support.
 *
 * @param text - Text to analyze
 * @returns Language code (default: 'en')
 */
export function detectLanguage(text: string): string {
  // Example keywords for common languages
  const languageKeywords: Record<string, string[]> = {
    sv: ['jag', 'är', 'det', 'och', 'att', 'som', 'på', 'för', 'med', 'till'],
    de: ['ich', 'der', 'die', 'das', 'und', 'ist', 'zu', 'den', 'in', 'von'],
    fr: ['je', 'de', 'le', 'la', 'et', 'est', 'que', 'pour', 'dans', 'un'],
    es: ['el', 'la', 'de', 'que', 'y', 'es', 'en', 'lo', 'un', 'por'],
  };

  const lowerText = text.toLowerCase();

  // Count matches for each language
  const scores: Record<string, number> = {};
  for (const [lang, keywords] of Object.entries(languageKeywords)) {
    scores[lang] = keywords.filter(word =>
      lowerText.includes(` ${word} `) ||
      lowerText.startsWith(`${word} `) ||
      lowerText.endsWith(` ${word}`)
    ).length;
  }

  // Find language with highest score
  const detectedLang = Object.entries(scores)
    .sort((a, b) => b[1] - a[1])[0];

  // Return detected language if score >= 2, otherwise default to English
  return detectedLang && detectedLang[1] >= 2 ? detectedLang[0] : 'en';
}

// ============================================================================
// TRANSCRIPT READING
// ============================================================================

/**
 * Read last user prompt and assistant response from transcript
 * Used by: completion-validator.ts, stop hooks
 *
 * @param transcriptPath - Path to transcript file
 * @returns Object with lastUserPrompt and lastAssistantResponse
 */
export function readLastExchange(transcriptPath: string): {
  lastUserPrompt: string;
  lastAssistantResponse: string;
} {
  const { readFileSync } = require('fs');
  const { validateTranscriptPath } = require('./validation.ts');

  try {
    const safeTranscriptPath = validateTranscriptPath(transcriptPath);
    const transcript = readFileSync(safeTranscriptPath, 'utf-8');
    const lines = transcript.trim().split('\n');

    let lastUserPrompt = '';
    let lastAssistantResponse = '';

    // Read backwards to find last exchange
    for (let i = lines.length - 1; i >= 0; i--) {
      try {
        const entry = JSON.parse(lines[i]);

        // Find last assistant response
        if (!lastAssistantResponse && entry.type === 'assistant' && entry.message?.content) {
          const content = entry.message.content;
          if (Array.isArray(content)) {
            lastAssistantResponse = content.map(c => c.text || '').join(' ');
          } else if (typeof content === 'string') {
            lastAssistantResponse = content;
          }
        }

        // Find last user prompt
        if (!lastUserPrompt && entry.type === 'user' && entry.message?.content) {
          const content = entry.message.content;
          if (typeof content === 'string') {
            lastUserPrompt = content;
          } else if (Array.isArray(content)) {
            for (const item of content) {
              if (item.type === 'text' && item.text) {
                lastUserPrompt = item.text;
                break;
              }
            }
          }
        }

        if (lastUserPrompt && lastAssistantResponse) break;
      } catch (e) {
        // Skip invalid JSON lines
      }
    }

    return { lastUserPrompt, lastAssistantResponse };
  } catch (error) {
    console.error(`⚠️ Failed to read transcript: ${error}`);
    return { lastUserPrompt: '', lastAssistantResponse: '' };
  }
}

/**
 * Extract completion tags from response text
 * Used by: completion-validator.ts, stop hooks
 *
 * @param response - Assistant response text
 * @returns Object with completion information
 */
export function extractCompletionTags(response: string): {
  hasCompletedTag: boolean;
  completedContent: string | null;
  hasCustomCompletedTag: boolean;
  customCompletedContent: string | null;
  hasSkillTag: boolean;
  skillUsed: string | null;
} {
  const completedMatch = response.match(/🎯\s*COMPLETED:\s*(.+?)(?:\n|$)/im);
  const customCompletedMatch = response.match(/🗣️\s*CUSTOM COMPLETED:\s*(.+?)(?:\n|$)/im);
  const skillMatch = response.match(/\[SKILL:(\w+(?:-\w+)*)\]/i);

  return {
    hasCompletedTag: !!completedMatch,
    completedContent: completedMatch ? completedMatch[1].trim() : null,
    hasCustomCompletedTag: !!customCompletedMatch,
    customCompletedContent: customCompletedMatch ? customCompletedMatch[1].trim() : null,
    hasSkillTag: !!skillMatch,
    skillUsed: skillMatch ? skillMatch[1].toLowerCase() : null,
  };
}

// ============================================================================
// FORMATTING UTILITIES
// ============================================================================

/**
 * Format timestamp for display
 * Used by: Multiple hooks for logging
 *
 * @param date - Date object (defaults to now)
 * @returns ISO timestamp string
 */
export function formatTimestamp(date: Date = new Date()): string {
  return date.toISOString();
}

/**
 * Format duration in milliseconds to human-readable string
 * Used by: Metrics and performance logging
 *
 * @param ms - Duration in milliseconds
 * @returns Human-readable string (e.g., "1.5s", "250ms")
 */
export function formatDuration(ms: number): string {
  if (ms < 1000) {
    return `${ms}ms`;
  }
  return `${(ms / 1000).toFixed(1)}s`;
}

/**
 * Truncate text for display
 * Used by: Logging and error messages
 *
 * @param text - Text to truncate
 * @param maxLength - Maximum length (default: 100)
 * @returns Truncated text with ellipsis if needed
 */
export function truncate(text: string, maxLength = 100): string {
  if (text.length <= maxLength) {
    return text;
  }
  return text.substring(0, maxLength - 3) + '...';
}

// ============================================================================
// ERROR HANDLING
// ============================================================================

/**
 * Safe error message extraction
 * Used by: All hooks for error logging
 *
 * @param error - Error object or unknown
 * @returns Error message string
 */
export function getErrorMessage(error: unknown): string {
  if (error instanceof Error) {
    return error.message;
  }
  if (typeof error === 'string') {
    return error;
  }
  return String(error);
}

/**
 * Log error and exit gracefully
 * Used by: All hooks - prevents hook failures from breaking Claude Code
 *
 * @param message - Error message
 * @param error - Optional error object
 */
export function exitWithError(message: string, error?: unknown): never {
  console.error(`❌ ${message}`);
  if (error) {
    console.error(`   Error: ${getErrorMessage(error)}`);
  }
  console.error('');
  process.exit(0); // Exit gracefully (0) so Claude Code doesn't show hook error
}

/**
 * Log warning and continue
 * Used by: All hooks for non-critical errors
 *
 * @param message - Warning message
 * @param error - Optional error object
 */
export function logWarning(message: string, error?: unknown): void {
  console.error(`⚠️  ${message}`);
  if (error) {
    console.error(`   Error: ${getErrorMessage(error)}`);
  }
}

// ============================================================================
// EXPORTS
// ============================================================================

export default {
  // Stdin
  readStdinWithTimeout,
  readStdinJSON,

  // Metrics
  writeMetrics,
  readMetricsLast,

  // Environment
  getPAIDir,
  isSubagent,
  getSessionId,

  // Language
  detectLanguage,

  // Transcript
  readLastExchange,
  extractCompletionTags,

  // Formatting
  formatTimestamp,
  formatDuration,
  truncate,

  // Error handling
  getErrorMessage,
  exitWithError,
  logWarning,
};
