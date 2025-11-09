#!/usr/bin/env bun

/**
 * stop-hook.ts - Voice notification and tab title updater
 *
 * Runs at session stop to:
 * 1. Extract completion message from transcript
 * 2. Send voice notification to ElevenLabs server
 * 3. Update terminal tab title with task summary
 *
 * Based on Ogmios PAI system (Daniel Miessler's Kai architecture)
 * SANITIZED VERSION - Replace voice IDs and configure for your needs
 */

import { readFileSync } from 'fs';
import { getVoiceId } from './lib/voice-mappings.ts';
import { extractCompletionTags, readLastExchange } from './lib/hook-utils.ts';
import { validateTranscriptPath } from './lib/validation.ts';

// ============================================================================
// CONFIGURATION
// ============================================================================

const VOICE_SERVER_URL = 'http://localhost:8888/notify';  // ElevenLabs voice server

/**
 * Generate 4-word tab title summarizing what was done
 */
function generateTabTitle(prompt: string, completedLine?: string): string {
  // If we have a completed line, try to use it for a better summary
  if (completedLine) {
    const cleanCompleted = completedLine
      .replace(/\*+/g, '')
      .replace(/\[.*?\]/g, '')
      .replace(/COMPLETED:\s*/gi, '')
      .trim();

    // Extract meaningful words from the completed line
    const completedWords = cleanCompleted.split(/\s+/)
      .filter(word => word.length > 2 &&
        !['the', 'and', 'but', 'for', 'are', 'with', 'this', 'that', 'completed'].includes(word.toLowerCase()))
      .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase());

    if (completedWords.length >= 2) {
      // Build a 4-word summary from completed line
      const summary = completedWords.slice(0, 4);
      while (summary.length < 4) {
        summary.push('Done');
      }
      return summary.slice(0, 4).join(' ');
    }
  }

  // Fall back to parsing the prompt
  const cleanPrompt = prompt.replace(/[^\w\s]/g, ' ').trim();
  const words = cleanPrompt.split(/\s+/).filter(word =>
    word.length > 2 &&
    !['the', 'and', 'but', 'for', 'are', 'with', 'this', 'that'].includes(word.toLowerCase())
  );

  const lowerPrompt = prompt.toLowerCase();

  // Find action verb if present
  const actionVerbs = ['test', 'rename', 'fix', 'debug', 'research', 'write', 'create', 'make', 'build', 'implement', 'analyze', 'review', 'update', 'modify', 'generate', 'develop', 'design'];

  let titleWords = [];

  // Check for action verb
  for (const verb of actionVerbs) {
    if (lowerPrompt.includes(verb)) {
      // Convert to past tense for summary
      let pastTense = verb;
      if (verb === 'write') pastTense = 'Wrote';
      else if (verb === 'make') pastTense = 'Made';
      else if (verb.endsWith('e')) pastTense = verb.charAt(0).toUpperCase() + verb.slice(1, -1) + 'ed';
      else pastTense = verb.charAt(0).toUpperCase() + verb.slice(1) + 'ed';

      titleWords.push(pastTense);
      break;
    }
  }

  // Add most meaningful remaining words
  const remainingWords = words
    .filter(word => !actionVerbs.includes(word.toLowerCase()))
    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase());

  // Fill up to 4 words total
  for (const word of remainingWords) {
    if (titleWords.length < 4) {
      titleWords.push(word);
    } else {
      break;
    }
  }

  // If we don't have enough words, add generic ones
  if (titleWords.length === 0) titleWords.push('Completed');
  if (titleWords.length === 1) titleWords.push('Task');
  if (titleWords.length === 2) titleWords.push('Successfully');
  if (titleWords.length === 3) titleWords.push('Done');

  return titleWords.slice(0, 4).join(' ');
}

/**
 * Set terminal tab title (works with most terminals)
 */
function setTerminalTabTitle(title: string): void {
  const term = process.env.TERM || '';

  // Send to stderr to bypass potential output filtering
  if (term.includes('ghostty')) {
    // Ghostty-specific sequences
    process.stderr.write(`\x1b]2;${title}\x07`);
    process.stderr.write(`\x1b]0;${title}\x07`);
  } else if (term.includes('kitty')) {
    // Kitty-specific sequences
    process.stderr.write(`\x1b]0;${title}\x07`);
    process.stderr.write(`\x1b]2;${title}\x07`);
    process.stderr.write(`\x1b]30;${title}\x07`);
  } else {
    // Generic sequences for other terminals
    process.stderr.write(`\x1b]0;${title}\x07`);
    process.stderr.write(`\x1b]2;${title}\x07`);
  }
}

/**
 * Generate intelligent response - prioritizes custom COMPLETED messages
 */
function generateIntelligentResponse(userQuery: string, assistantResponse: string, completedLine: string): string {
  // Clean the completed line
  const cleanCompleted = completedLine
    .replace(/\*+/g, '')
    .replace(/\[.*?\]/g, '')
    .trim();

  // If the completed line has meaningful custom content (not generic), use it
  const genericPhrases = [
    'completed successfully',
    'task completed',
    'done successfully',
    'finished successfully',
    'completed the task',
    'completed your request'
  ];

  const isGenericCompleted = genericPhrases.some(phrase =>
    cleanCompleted.toLowerCase() === phrase ||
    cleanCompleted.toLowerCase() === `${phrase}.`
  );

  // If we have a custom, non-generic completed message, prefer it
  if (!isGenericCompleted && cleanCompleted.length > 10) {
    return cleanCompleted;
  }

  // For simple acknowledgments
  const queryLC = userQuery.toLowerCase();
  if (queryLC.match(/^(thank|thanks|awesome|great|good job|well done)[\s!?.]*$/i)) {
    return "You're welcome!";
  }

  // For all other cases, use the actual completed message
  return cleanCompleted;
}

async function main() {
  // Log that hook was triggered
  const timestamp = new Date().toISOString();
  console.error(`\n🎬 STOP-HOOK TRIGGERED AT ${timestamp}`);

  // Get input
  let input = '';
  const decoder = new TextDecoder();
  const reader = Bun.stdin.stream().getReader();

  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      input += decoder.decode(value, { stream: true });
    }
  } catch (e) {
    console.error(`❌ Error reading input: ${e}`);
    process.exit(0);
  }

  if (!input) {
    console.error('❌ No input received');
    process.exit(0);
  }

  let transcriptPath;
  try {
    const parsed = JSON.parse(input);
    transcriptPath = parsed.transcript_path;
    console.error(`📁 Transcript path: ${transcriptPath}`);
  } catch (e) {
    console.error(`❌ Error parsing input JSON: ${e}`);
    process.exit(0);
  }

  if (!transcriptPath) {
    console.error('❌ No transcript_path in input');
    process.exit(0);
  }

  // Read the transcript
  try {
    const safeTranscriptPath = validateTranscriptPath(transcriptPath);
    const { lastUserPrompt, lastAssistantResponse } = readLastExchange(safeTranscriptPath);

    if (!lastUserPrompt || !lastAssistantResponse) {
      console.error('❌ No user prompt or assistant response found');
      process.exit(0);
    }

    console.error(`📝 User prompt: ${lastUserPrompt.substring(0, 100)}...`);

    // Extract completion tags
    const { hasCustomCompletedTag, customCompletedContent, hasCompletedTag, completedContent, hasSkillTag, skillUsed } = extractCompletionTags(lastAssistantResponse);

    // Generate message for voice notification
    let message = '';

    // Prioritize CUSTOM COMPLETED (voice-optimized)
    if (hasCustomCompletedTag && customCompletedContent) {
      const cleanCustom = customCompletedContent
        .replace(/\[.*?\]/g, '')
        .replace(/\*+/g, '')
        .trim();

      const wordCount = cleanCustom.split(/\s+/).length;
      if (wordCount <= 8) {
        message = cleanCustom;
        console.error(`🗣️ CUSTOM VOICE: ${message}`);
      }
    }

    // Fall back to regular COMPLETED
    if (!message && hasCompletedTag && completedContent) {
      message = generateIntelligentResponse(lastUserPrompt, lastAssistantResponse, completedContent);
      console.error(`🎯 INTELLIGENT: ${message}`);
    }

    // Send voice notification if we have a message
    if (message) {
      // Determine voice ID (use skill voice if present, otherwise assistant voice)
      const voiceId = getVoiceId(skillUsed, lastUserPrompt);

      const payload = {
        message: message,
        voice_id: voiceId
      };

      await fetch(VOICE_SERVER_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      }).catch((err) => {
        console.error(`🐛 Voice server error: ${err}`);
      });

      console.error(`🔊 Voice notification sent: "${message}" with voice ID: ${voiceId}`);
    }

    // Set tab title
    const tabTitle = message || generateTabTitle(lastUserPrompt, completedContent || '');
    if (tabTitle) {
      setTerminalTabTitle(tabTitle);
      console.error(`🏷️ Tab title set to: "${tabTitle}"`);
    }

    console.error(`🎬 STOP-HOOK COMPLETED SUCCESSFULLY at ${new Date().toISOString()}\n`);

  } catch (e) {
    console.error(`❌ Error processing transcript: ${e}`);
    process.exit(0);
  }
}

main().catch(() => {});
