#!/usr/bin/env bun
/**
 * Content Guard Hook - Enforce content quality prohibitions
 *
 * Prevents Tier 0 AI clichés from being written to content files.
 * Warns about Tier 1 business jargon overuse.
 *
 * Enforces content quality standards using pattern matching.
 *
 * Usage: Called automatically before Write tool in content creation contexts
 *
 * Based on Ogmios PAI system (Daniel Miessler's Kai architecture)
 * SANITIZED VERSION - Configure paths for your needs
 */

import { readFile } from 'fs/promises';
import { join } from 'path';

// Tier 0: ABSOLUTELY FORBIDDEN - AI clichés
const TIER_0_PATTERNS = [
  /\bdelve into\b/gi,
  /\bleverage\b(?!.*\bAPI)/gi, // Allow "leverage APIs" but not generic "leverage"
  /\bin today's world\b/gi,
  /\bin today's digital landscape\b/gi,
  /\bit's worth noting that\b/gi,
  /\brevolutionize\b/gi,
  /\brevolutionary\b/gi,
  /\bgame-changer\b/gi,
  /\bgame-changing\b/gi,
  /\bunlock\b(?!.*\b(key|door|password))/gi, // Allow literal unlock
  /\bseamless(?:ly)?\b/gi,
  /\bempower(?:ment)?\b/gi,
  /\bat the end of the day\b/gi,
  /\bdive deep(?:ly)? into\b/gi,
  /\bunpack\b(?!.*\b(box|suitcase|archive))/gi, // Allow literal unpack
  /\bsynergy\b/gi,
  /\bparadigm shift\b/gi,
  /\blow-hanging fruit\b/gi,
  /\bthink outside the box\b/gi,
  /\bmove the needle\b/gi,
  /\bcircle back\b/gi,
  /\bAs an AI\b/gi,
  /\bAs a language model\b/gi,
  /\bI don't have personal opinions but\b/gi,
  /\bIt's important to note that\b/gi,
  /\bUpon careful consideration\b/gi,
];

// Tier 1: WARNING - Overused business jargon
const TIER_1_PATTERNS = [
  /\blandscape\b(?!.*\b(mountain|hill|geography|terrain))/gi, // Allow literal landscape
  /\brobust\b/gi,
  /\becosystem\b(?!.*\b(forest|nature|biology))/gi, // Allow biological ecosystem
  /\bholistic\b/gi,
  /\bstreamline\b/gi,
  /\boptimize\b/gi,
  /\bdisrupt(?:ive)?\b/gi,
  /\binnovative\b/gi,
  /\bcutting-edge\b/gi,
  /\bbleeding-edge\b/gi,
  /\bbest-in-class\b/gi,
  /\bmission-critical\b/gi,
  /\bvalue-add\b/gi,
  /\btouch base\b/gi,
  /\bbandwidth\b(?!.*\b(network|internet|connection))/gi, // Allow technical bandwidth
];

// Alternative language equivalents (Tier 0)
// CUSTOMIZE for your language needs
const TIER_0_ALT_LANGUAGE = [
  /\bfördjupa sig i\b/gi, // Swedish "delve into"
  /\butnyttja\b/gi, // Swedish "leverage"
  /\bi dagens samhälle\b/gi, // Swedish "in today's world"
  /\bi dagens digitala värld\b/gi, // Swedish "in today's digital landscape"
  /\bdet är värt att notera\b/gi, // Swedish "it's worth noting"
  /\brevolutionera\b/gi, // Swedish "revolutionize"
  /\bspelväxlare\b/gi, // Swedish "game-changer"
  /\bspelförändrande\b/gi, // Swedish "game-changing"
  /\blåsa upp\b(?!.*\b(dörr|lås))/gi, // Swedish "unlock" (literal OK)
  /\bsömlös(?:t)?\b/gi, // Swedish "seamless"
  /\bmyndiggöra\b/gi, // Swedish "empower"
];

interface ViolationMatch {
  phrase: string;
  position: number;
  tier: 0 | 1;
}

/**
 * Check if file path indicates content creation context
 * CUSTOMIZE these paths for your environment
 */
function isContentFile(filePath: string): boolean {
  const contentPaths = [
    '/content/',
    '/blog/',
    '/articles/',
    '/posts/',
    'README.md',
    'BLOG',
    'POST',
    '.md',
  ];

  const excludePaths = [
    '/node_modules/',
    '/.claude/',
    '/.git/',
    '/documentation/',
    '/docs/technical/',
    'SKILL.md',
    'CLAUDE.md',
    'PAI.md',
  ];

  // Exclude internal documentation
  if (excludePaths.some(p => filePath.includes(p))) {
    return false;
  }

  // Include content creation paths
  return contentPaths.some(p => filePath.includes(p));
}

/**
 * Find violations in content
 */
function findViolations(content: string): ViolationMatch[] {
  const violations: ViolationMatch[] = [];

  // Check Tier 0 (English)
  for (const pattern of TIER_0_PATTERNS) {
    const matches = content.matchAll(pattern);
    for (const match of matches) {
      violations.push({
        phrase: match[0],
        position: match.index || 0,
        tier: 0,
      });
    }
  }

  // Check Tier 0 (Alternative Language)
  for (const pattern of TIER_0_ALT_LANGUAGE) {
    const matches = content.matchAll(pattern);
    for (const match of matches) {
      violations.push({
        phrase: match[0],
        position: match.index || 0,
        tier: 0,
      });
    }
  }

  // Check Tier 1
  for (const pattern of TIER_1_PATTERNS) {
    const matches = content.matchAll(pattern);
    for (const match of matches) {
      violations.push({
        phrase: match[0],
        position: match.index || 0,
        tier: 1,
      });
    }
  }

  return violations;
}

/**
 * Get context snippet around violation
 */
function getContextSnippet(content: string, position: number, length: number = 50): string {
  const start = Math.max(0, position - length);
  const end = Math.min(content.length, position + length);
  const snippet = content.slice(start, end);
  return `...${snippet}...`;
}

/**
 * Main content guard function
 */
async function contentGuard(content: string, filePath: string): Promise<void> {
  // Only guard content files
  if (!isContentFile(filePath)) {
    console.log(`[content-guard] Skipping non-content file: ${filePath}`);
    return;
  }

  console.log(`[content-guard] Checking content quality for: ${filePath}`);

  // Find violations
  const violations = findViolations(content);
  const tier0Violations = violations.filter(v => v.tier === 0);
  const tier1Violations = violations.filter(v => v.tier === 1);

  // Report results
  if (tier0Violations.length === 0 && tier1Violations.length === 0) {
    console.log(`✅ Content quality check: 0 Tier 0 violations, 0 Tier 1 warnings`);
    return;
  }

  // Tier 0 violations = REJECT
  if (tier0Violations.length > 0) {
    console.error(`\n🚨 TIER 0 VIOLATIONS DETECTED (${tier0Violations.length}):\n`);
    console.error(`These phrases are ABSOLUTELY FORBIDDEN:\n`);

    for (const violation of tier0Violations) {
      const context = getContextSnippet(content, violation.position);
      console.error(`  ❌ "${violation.phrase}"`);
      console.error(`     Context: ${context}\n`);
    }

    console.error(`\nCONTENT REJECTED. Remove all Tier 0 phrases and try again.\n`);
    console.error(`Customize prohibitions in this hook file (content-guard.ts)\n`);

    throw new Error(`Content quality check failed: ${tier0Violations.length} Tier 0 violations`);
  }

  // Tier 1 warnings = WARN (allow 1, reject >1)
  if (tier1Violations.length > 1) {
    console.warn(`\n⚠️ TIER 1 WARNINGS (${tier1Violations.length}):\n`);
    console.warn(`Too many business jargon phrases detected:\n`);

    for (const violation of tier1Violations) {
      const context = getContextSnippet(content, violation.position);
      console.warn(`  ⚠️ "${violation.phrase}"`);
      console.warn(`     Context: ${context}\n`);
    }

    console.warn(`\nMaximum 1 Tier 1 phrase allowed. Please rewrite or justify.\n`);

    throw new Error(`Content quality check failed: ${tier1Violations.length} Tier 1 warnings (max 1)`);
  }

  if (tier1Violations.length === 1) {
    console.warn(`\n⚠️ Content quality check: 0 Tier 0 violations, 1 Tier 1 warning`);
    console.warn(`  Phrase: "${tier1Violations[0].phrase}"`);
    console.warn(`  This phrase should be avoided. Consider rewriting for clarity.\n`);
  }
}

// Run if called directly
if (import.meta.main) {
  const args = process.argv.slice(2);

  if (args.length < 2) {
    console.error('Usage: content-guard.ts <content> <filePath>');
    process.exit(1);
  }

  const [content, filePath] = args;

  try {
    await contentGuard(content, filePath);
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

export { contentGuard, isContentFile, findViolations };
