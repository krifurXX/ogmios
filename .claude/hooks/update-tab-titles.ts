#!/usr/bin/env bun
/**
 * Tab Title Update Hook
 * Updates tab title based on user prompt
 *
 * Based on Ogmios PAI system (Daniel Miessler's Kai architecture)
 * SANITIZED VERSION - All personal data removed
 */

import { execSync } from 'child_process';
import { readStdinJSON } from './lib/hook-utils.ts';

interface HookInput {
  session_id: string;
  prompt: string;
  transcript_path: string;
  hook_event_name: string;
}

async function main() {
  try {
    // Read the hook input from stdin
    const data = await readStdinJSON<HookInput>();

    const prompt = data.prompt || '';

    // UPDATE TAB TITLE
    // Generate quick fallback tab title
    let tabTitle = 'Processing request...';
    if (prompt) {
      const words = prompt.replace(/[^\w\s]/g, ' ').trim().split(/\s+/)
        .filter(w => w.length > 2 && !['the', 'and', 'but', 'for', 'are', 'with', 'you', 'can'].includes(w.toLowerCase()))
        .slice(0, 3);

      if (words.length > 0) {
        tabTitle = words[0].charAt(0).toUpperCase() + words[0].slice(1).toLowerCase();
        if (words.length > 1) {
          tabTitle += ' ' + words.slice(1).map(w => w.toLowerCase()).join(' ');
        }
        tabTitle += '...';
      }
    }

    // Set initial tab title with recycle emoji
    try {
      const titleWithEmoji = '♻️ ' + tabTitle;
      const escapedTitle = titleWithEmoji.replace(/'/g, "'\\''");
      execSync(`printf '\\033]0;${escapedTitle}\\007' >&2`);
      execSync(`printf '\\033]2;${escapedTitle}\\007' >&2`);
      execSync(`printf '\\033]30;${escapedTitle}\\007' >&2`);
    } catch (e) {
      // Silently fail
    }

    process.exit(0);
  } catch (error) {
    // Silently fail to not interrupt Claude's flow
    console.error('Tab title update error:', error);
    process.exit(0);
  }
}

main();
