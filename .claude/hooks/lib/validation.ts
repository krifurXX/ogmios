/**
 * Input validation utilities for hooks (Security - P0)
 *
 * Prevents:
 * - Path traversal attacks
 * - Resource exhaustion (oversized inputs)
 * - Injection attacks
 *
 * Based on Ogmios PAI system security standards
 * SANITIZED VERSION - Generic implementation
 */

import { resolve, normalize, relative } from "path";

/**
 * Validate file path to prevent path traversal
 * @param path - Path to validate
 * @param baseDir - Base directory to restrict to (default: PAI_DIR)
 * @returns Validated absolute path
 * @throws Error if path traversal detected
 */
export function validateFilePath(path: string, baseDir?: string): string {
  const base = baseDir || process.env.PAI_DIR || process.env.HOME + "/.claude";

  // Normalize and resolve path
  const normalizedPath = normalize(path);
  const resolvedPath = resolve(base, normalizedPath);

  // Check if resolved path is within base directory
  const relativePath = relative(base, resolvedPath);

  if (relativePath.startsWith('..') || resolve(base, relativePath) !== resolvedPath) {
    throw new Error(`Path traversal detected: ${path} (resolved to ${resolvedPath}, outside ${base})`);
  }

  return resolvedPath;
}

/**
 * Validate prompt/transcript content
 * @param content - Content to validate
 * @param maxLength - Maximum allowed length (default: 100KB)
 * @returns Validated content
 * @throws Error if content too long or suspicious
 */
export function validateContent(content: string, maxLength: number = 100000): string {
  if (typeof content !== 'string') {
    throw new Error(`Invalid content type: expected string, got ${typeof content}`);
  }

  if (content.length === 0) {
    throw new Error('Empty content not allowed');
  }

  if (content.length > maxLength) {
    throw new Error(`Content too long: ${content.length} chars (max ${maxLength})`);
  }

  // Check for null bytes (potential injection)
  if (content.includes('\0')) {
    throw new Error('Null bytes detected in content (potential injection attack)');
  }

  return content;
}

/**
 * Validate prompt specifically
 * @param prompt - User prompt to validate
 * @returns Validated prompt
 * @throws Error if invalid
 */
export function validatePrompt(prompt: string): string {
  return validateContent(prompt, 50000); // 50KB max for prompts
}

/**
 * Validate transcript path
 * @param path - Transcript file path
 * @returns Validated absolute path
 * @throws Error if invalid
 */
export function validateTranscriptPath(path: string): string {
  // Transcripts should be in PAI_DIR or temp directory
  const paiDir = process.env.PAI_DIR || process.env.HOME + "/.claude";
  const tmpDir = "/tmp";

  try {
    // Try PAI_DIR first
    return validateFilePath(path, paiDir);
  } catch (e1) {
    try {
      // Fall back to /tmp
      return validateFilePath(path, tmpDir);
    } catch (e2) {
      throw new Error(`Invalid transcript path: ${path} (not in PAI_DIR or /tmp)`);
    }
  }
}

/**
 * Validate skill name
 * @param skillName - Skill name to validate
 * @returns Validated skill name
 * @throws Error if invalid
 */
export function validateSkillName(skillName: string): string {
  if (!/^[a-z0-9-]+$/.test(skillName)) {
    throw new Error(`Invalid skill name: ${skillName} (must be lowercase alphanumeric with dashes)`);
  }

  if (skillName.length > 50) {
    throw new Error(`Skill name too long: ${skillName.length} chars (max 50)`);
  }

  return skillName;
}

/**
 * Validate language code
 * @param lang - Language code to validate
 * @returns Validated language code
 * @throws Error if invalid
 */
export function validateLanguage(lang: string): string {
  // Support common ISO 639-1 language codes
  const validLangs = ['en', 'sv', 'de', 'fr', 'es', 'it', 'pt', 'nl', 'no', 'da', 'fi'];

  if (!validLangs.includes(lang)) {
    throw new Error(`Invalid language: ${lang} (must be one of: ${validLangs.join(', ')})`);
  }

  return lang;
}

/**
 * Sanitize string for logging (prevent log injection)
 * @param str - String to sanitize
 * @returns Sanitized string
 */
export function sanitizeForLog(str: string): string {
  return str
    .replace(/\n/g, '\\n')
    .replace(/\r/g, '\\r')
    .replace(/\t/g, '\\t')
    .substring(0, 200); // Max 200 chars in logs
}
