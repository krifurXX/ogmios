/**
 * LOAD UFC CONTEXT HOOK
 *
 * File: ~/.claude/.claude/hooks/load-ufc-context.ts
 * Hook Type: UserPromptSubmit
 * Runs: Before user prompt is sent to Claude
 * Purpose: Automatically load relevant UFC context based on intent detection
 */

import { readFile } from 'fs/promises';
import { join } from 'path';
import { existsSync } from 'fs';

interface UserPromptSubmitContext {
  prompt: string;
  projectDir?: string;
  sessionId: string;
}

interface HookResponse {
  systemMessage?: string;
  error?: string;
}

/**
 * Intent detection patterns for UFC context loading
 */
const INTENT_PATTERNS = {
  // Project mentions - load project context
  projects: [
    /project\s+(\w+)/i,
    /working on\s+(\w+)/i,
    /(\w+)\s+project/i,
  ],

  // Tool mentions - load tool preferences
  tools: [
    /using\s+(git|docker|kubernetes|npm|bun)/i,
    /(github|gitlab|bitbucket)/i,
  ],

  // Language mentions - load language preferences
  languages: [
    /in\s+(swedish|svenska|engelsk|english)/i,
    /(typescript|javascript|python|rust|go)\s/i,
  ],
};

/**
 * Detect intent and find matching UFC context files
 */
function detectIntent(prompt: string): string[] {
  const contextFiles: string[] = [];
  const lowerPrompt = prompt.toLowerCase();

  // Always load UFC.md first
  contextFiles.push('UFC.md');

  // Check for project mentions
  for (const pattern of INTENT_PATTERNS.projects) {
    const match = lowerPrompt.match(pattern);
    if (match) {
      const projectName = match[1];
      contextFiles.push(`projects/${projectName}-tier1.md`);
    }
  }

  // Check for tool mentions
  for (const pattern of INTENT_PATTERNS.tools) {
    const match = lowerPrompt.match(pattern);
    if (match) {
      const tool = match[1];
      contextFiles.push(`tools/${tool}.md`);
    }
  }

  // Check for language mentions
  for (const pattern of INTENT_PATTERNS.languages) {
    const match = lowerPrompt.match(pattern);
    if (match) {
      contextFiles.push('languages/bilingual.md');
      break; // Only load once
    }
  }

  return contextFiles;
}

/**
 * Load UFC context files
 */
async function loadContextFiles(contextFiles: string[]): Promise<string> {
  const paiDir = process.env.PAI_DIR || join(process.env.HOME!, '.claude/.claude');
  const contextDir = join(paiDir, 'context');

  const loadedContent: string[] = [];
  const loadedFiles: string[] = [];

  for (const file of contextFiles) {
    const filePath = join(contextDir, file);

    if (existsSync(filePath)) {
      try {
        const content = await readFile(filePath, 'utf-8');
        loadedContent.push(`\n## Context: ${file}\n\n${content}\n`);
        loadedFiles.push(file);
      } catch (error) {
        console.error(`[UFC Hook] Failed to load ${file}:`, error);
      }
    }
  }

  if (loadedContent.length === 0) {
    return '';
  }

  return `
# 📂 UFC CONTEXT LOADED

**Files:** ${loadedFiles.join(', ')}

---

${loadedContent.join('\n---\n')}

---

**Context hydrated successfully.**
`.trim();
}

/**
 * UserPromptSubmit Hook - Load UFC context based on intent
 */
export default async function loadUfcContextHook(
  context: UserPromptSubmitContext
): Promise<HookResponse> {
  try {
    // Detect which context files to load
    const contextFiles = detectIntent(context.prompt);

    if (contextFiles.length === 0) {
      return {}; // No context needed
    }

    // Load context files
    const systemMessage = await loadContextFiles(contextFiles);

    return { systemMessage };

  } catch (error) {
    console.error('[UFC Hook] Error:', error);
    return {
      error: `Failed to load UFC context: ${error instanceof Error ? error.message : 'Unknown error'}`
    };
  }
}

/**
 * CONFIGURATION IN settings.json:
 *
 * {
 *   "hooks": {
 *     "UserPromptSubmit": [
 *       {
 *         "hooks": [{
 *           "type": "command",
 *           "command": "bun run ${PAI_DIR}/.claude/hooks/load-ufc-context.ts"
 *         }]
 *       }
 *     ]
 *   }
 * }
 */

/**
 * USAGE EXAMPLE:
 *
 * User: "Let's work on the ecommerce project"
 * → Hook detects "ecommerce project"
 * → Loads context/projects/ecommerce-tier1.md
 * → Claude has project context automatically!
 *
 * User: "I need help with git"
 * → Hook detects "git"
 * → Loads context/tools/git.md
 * → Claude knows your git preferences!
 */

/**
 * CUSTOMIZATION TIPS:
 *
 * 1. Add more intent patterns:
 *    - Technical stack mentions
 *    - Client/company names
 *    - Workflow keywords
 *
 * 2. Implement tiered loading:
 *    - Start with tier1 (metadata)
 *    - Load tier2 if needed
 *    - Only load tier3 on explicit request
 *
 * 3. Add caching:
 *    - Cache frequently loaded contexts
 *    - Reduce file I/O overhead
 *
 * 4. Context prioritization:
 *    - Load most recent project first
 *    - Prefer active contexts over dormant
 */
