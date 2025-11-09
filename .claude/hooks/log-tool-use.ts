/**
 * TOOL USE LOGGING HOOK
 *
 * Location: ~/.claude/.claude/hooks/log-tool-use.ts
 * Hook Type: ToolUse (future) or Stop (current implementation)
 * Runs: AFTER Claude uses a tool OR after generating response
 * Purpose: Log tool usage for analytics, debugging, and pattern analysis
 *
 * HOW IT WORKS:
 * 1. Detects tool usage from assistant message
 * 2. Extracts tool name, parameters, and context
 * 3. Logs to structured JSON log file
 * 4. Privacy-conscious: filters sensitive data
 * 5. Supports analytics and usage pattern tracking
 *
 * USE CASES:
 * - Track which tools are used most frequently
 * - Identify tool usage patterns
 * - Debug tool integration issues
 * - Analyze productivity metrics
 * - Generate usage reports
 */

import { appendFile, mkdir } from 'fs/promises';
import { join } from 'path';
import { existsSync } from 'fs';

// ============================================================================
// INTERFACES
// ============================================================================

interface StopContext {
  assistantMessage: string;
  userMessage?: string;
  sessionId: string;
  projectDir?: string;
  timestamp?: string;
}

interface HookResponse {
  systemMessage?: string;
  error?: string;
  metadata?: Record<string, unknown>;
}

interface ToolUsageEntry {
  timestamp: string;
  sessionId: string;
  toolName: string;
  toolType: string;
  parameters?: Record<string, unknown>;
  context: {
    projectDir?: string;
    userIntent?: string;
    messageLength: number;
  };
  metadata?: Record<string, unknown>;
}

interface ToolDetection {
  toolName: string;
  toolType: string;
  parameters?: Record<string, unknown>;
}

// ============================================================================
// CONFIGURATION
// ============================================================================

/**
 * Log file configuration
 */
const PAI_DIR = process.env.PAI_DIR || join(process.env.HOME!, '.claude/.claude');
const LOG_DIR = join(PAI_DIR, 'logs');
const TOOL_LOG_FILE = join(LOG_DIR, 'tool-usage.jsonl');

/**
 * Privacy configuration
 * These parameter names will be filtered from logs
 */
const SENSITIVE_PARAMS = [
  'password',
  'api_key',
  'apiKey',
  'token',
  'secret',
  'credential',
  'auth',
  'bearer',
  'private_key',
  'privateKey'
];

/**
 * Logging configuration
 */
const ENABLE_LOGGING = process.env.TOOL_LOGGING_ENABLED !== 'false'; // Enabled by default
const MAX_PARAM_LENGTH = 500; // Truncate long parameters to this length

// ============================================================================
// MAIN HOOK FUNCTION
// ============================================================================

/**
 * Tool Use Logging Hook - Log tool usage for analytics
 */
export default async function logToolUseHook(
  context: StopContext
): Promise<HookResponse> {
  try {
    // Skip if logging disabled
    if (!ENABLE_LOGGING) {
      return {};
    }

    const { assistantMessage, userMessage, sessionId, projectDir } = context;

    // Detect tool usage from message
    const toolsUsed = detectToolUsage(assistantMessage);

    if (toolsUsed.length === 0) {
      // No tools used in this response
      return {};
    }

    // Ensure log directory exists
    await ensureLogDirectory();

    // Log each tool usage
    for (const tool of toolsUsed) {
      await logToolUsage(tool, {
        sessionId,
        projectDir,
        userMessage,
        assistantMessage,
        timestamp: new Date().toISOString()
      });
    }

    return {
      metadata: {
        toolsLogged: toolsUsed.length,
        toolNames: toolsUsed.map(t => t.toolName)
      }
    };

  } catch (error) {
    // Never block on logging errors
    console.error('[Tool Logging] Error:', error);
    return {
      metadata: {
        loggingError: error instanceof Error ? error.message : 'Unknown error'
      }
    };
  }
}

// ============================================================================
// TOOL DETECTION
// ============================================================================

/**
 * Detect tool usage from assistant message
 *
 * Looks for common patterns:
 * - Skill("skillname")
 * - Read("/path/to/file")
 * - Bash("command")
 * - WebSearch("query")
 * - etc.
 */
function detectToolUsage(message: string): ToolDetection[] {
  const tools: ToolDetection[] = [];

  // Pattern: ToolName("parameter") or ToolName({ param: value })
  const toolPattern = /(\w+)\s*\(\s*([^)]+)\s*\)/g;
  const matches = message.matchAll(toolPattern);

  for (const match of matches) {
    const toolName = match[1];
    const paramString = match[2];

    // Skip common false positives
    if (isFalsePositive(toolName)) {
      continue;
    }

    const tool = parseToolUsage(toolName, paramString);
    if (tool) {
      tools.push(tool);
    }
  }

  return tools;
}

/**
 * Parse tool usage details
 */
function parseToolUsage(toolName: string, paramString: string): ToolDetection | null {
  try {
    // Determine tool type based on name
    const toolType = categorizeToolType(toolName);

    // Try to parse parameters
    let parameters: Record<string, unknown> | undefined;

    // Check if it's JSON object
    if (paramString.trim().startsWith('{')) {
      try {
        parameters = JSON.parse(paramString);
      } catch {
        // Not valid JSON, treat as string parameter
        parameters = { value: paramString.replace(/['"]/g, '') };
      }
    } else {
      // Simple string parameter
      parameters = { value: paramString.replace(/['"]/g, '') };
    }

    // Filter sensitive parameters
    const filteredParams = filterSensitiveData(parameters);

    return {
      toolName,
      toolType,
      parameters: filteredParams
    };

  } catch (error) {
    console.warn(`[Tool Logging] Failed to parse tool usage: ${toolName}`, error);
    return null;
  }
}

/**
 * Categorize tool type
 */
function categorizeToolType(toolName: string): string {
  const typeMap: Record<string, string> = {
    // File operations
    'Read': 'file',
    'Write': 'file',
    'Edit': 'file',
    'Glob': 'file',
    'Grep': 'file',

    // Shell
    'Bash': 'shell',
    'BashOutput': 'shell',
    'KillShell': 'shell',

    // Web
    'WebSearch': 'web',
    'WebFetch': 'web',

    // Browser (MCP)
    'mcp__playwright__browser_navigate': 'browser',
    'mcp__playwright__browser_click': 'browser',
    'mcp__playwright__browser_snapshot': 'browser',

    // Skills
    'Skill': 'skill',

    // N8N (MCP)
    'mcp__n8n-mcp__n8n_create_workflow': 'n8n',
    'mcp__n8n-mcp__n8n_trigger_webhook_workflow': 'n8n',

    // Zotero (MCP)
    'mcp__zotero__zotero_search_items': 'zotero',
    'mcp__zotero__zotero_semantic_search': 'zotero',

    // VS Code (MCP)
    'mcp__ide__getDiagnostics': 'ide',
    'mcp__ide__executeCode': 'ide'
  };

  // Check exact match
  if (typeMap[toolName]) {
    return typeMap[toolName];
  }

  // Check prefixes
  if (toolName.startsWith('mcp__')) {
    const parts = toolName.split('__');
    return parts[1] || 'mcp';
  }

  return 'unknown';
}

/**
 * Check if tool name is a false positive
 */
function isFalsePositive(toolName: string): boolean {
  const falsePositives = [
    // Common programming functions
    'console', 'log', 'print', 'assert', 'require', 'import',
    'export', 'async', 'await', 'return', 'function',
    // Common methods
    'map', 'filter', 'reduce', 'forEach', 'find', 'some', 'every',
    'includes', 'indexOf', 'slice', 'splice', 'push', 'pop',
    // Common words in sentences
    'The', 'This', 'That', 'These', 'Those', 'When', 'Where', 'Why', 'How'
  ];

  return falsePositives.includes(toolName);
}

// ============================================================================
// PRIVACY FILTERING
// ============================================================================

/**
 * Filter sensitive data from parameters
 */
function filterSensitiveData(
  params: Record<string, unknown> | undefined
): Record<string, unknown> | undefined {
  if (!params) {
    return undefined;
  }

  const filtered: Record<string, unknown> = {};

  for (const [key, value] of Object.entries(params)) {
    // Check if parameter name suggests sensitive data
    if (SENSITIVE_PARAMS.some(s => key.toLowerCase().includes(s))) {
      filtered[key] = '[REDACTED]';
      continue;
    }

    // Truncate long values
    if (typeof value === 'string' && value.length > MAX_PARAM_LENGTH) {
      filtered[key] = value.substring(0, MAX_PARAM_LENGTH) + '... [TRUNCATED]';
      continue;
    }

    // Recursively filter objects
    if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
      filtered[key] = filterSensitiveData(value as Record<string, unknown>);
      continue;
    }

    // Keep safe values
    filtered[key] = value;
  }

  return filtered;
}

// ============================================================================
// LOGGING
// ============================================================================

/**
 * Ensure log directory exists
 */
async function ensureLogDirectory(): Promise<void> {
  if (!existsSync(LOG_DIR)) {
    await mkdir(LOG_DIR, { recursive: true });
  }
}

/**
 * Log tool usage to file
 */
async function logToolUsage(
  tool: ToolDetection,
  context: {
    sessionId: string;
    projectDir?: string;
    userMessage?: string;
    assistantMessage: string;
    timestamp: string;
  }
): Promise<void> {
  // Extract user intent (first few words of user message)
  const userIntent = context.userMessage
    ? context.userMessage.substring(0, 100).replace(/\n/g, ' ')
    : undefined;

  // Build log entry
  const entry: ToolUsageEntry = {
    timestamp: context.timestamp,
    sessionId: context.sessionId,
    toolName: tool.toolName,
    toolType: tool.toolType,
    parameters: tool.parameters,
    context: {
      projectDir: context.projectDir,
      userIntent,
      messageLength: context.assistantMessage.length
    }
  };

  // Write as JSON Lines (one JSON object per line)
  const logLine = JSON.stringify(entry) + '\n';

  await appendFile(TOOL_LOG_FILE, logLine, 'utf-8');

  console.log(`[Tool Logging] Logged: ${tool.toolName} (${tool.toolType})`);
}

// ============================================================================
// ANALYTICS UTILITIES
// ============================================================================

/**
 * These utilities can be used separately to analyze the log file
 * Example: bun run analyze-tool-usage.ts
 */

/**
 * Example: Read and parse tool usage logs
 */
export async function readToolUsageLogs(): Promise<ToolUsageEntry[]> {
  const { readFile } = await import('fs/promises');

  try {
    const content = await readFile(TOOL_LOG_FILE, 'utf-8');
    const lines = content.trim().split('\n').filter(Boolean);

    return lines.map(line => JSON.parse(line));
  } catch {
    return [];
  }
}

/**
 * Example: Aggregate tool usage statistics
 */
export function aggregateToolStats(logs: ToolUsageEntry[]): Record<string, number> {
  const stats: Record<string, number> = {};

  for (const log of logs) {
    stats[log.toolName] = (stats[log.toolName] || 0) + 1;
  }

  return stats;
}

/**
 * Example: Get tool usage by type
 */
export function aggregateByType(logs: ToolUsageEntry[]): Record<string, number> {
  const stats: Record<string, number> = {};

  for (const log of logs) {
    stats[log.toolType] = (stats[log.toolType] || 0) + 1;
  }

  return stats;
}

// ============================================================================
// CONFIGURATION IN settings.json
// ============================================================================

/**
 * ADD THIS TO YOUR settings.json:
 *
 * {
 *   "hooks": {
 *     "Stop": [
 *       {
 *         "hooks": [{
 *           "type": "command",
 *           "command": "bun run ${PAI_DIR}/.claude/hooks/log-tool-use.ts"
 *         }]
 *       }
 *     ]
 *   }
 * }
 */

// ============================================================================
// ENVIRONMENT VARIABLES
// ============================================================================

/**
 * OPTIONAL ENVIRONMENT VARIABLES:
 *
 * # Enable/disable tool logging (default: true)
 * TOOL_LOGGING_ENABLED=true
 *
 * # PAI directory (for log file location)
 * PAI_DIR=/Users/yourusername/.claude
 */

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/**
 * EXAMPLE 1: File operation logging
 *
 * Assistant uses Read("/path/to/file.ts")
 *
 * Log entry:
 * {
 *   "timestamp": "2025-11-09T14:30:00.000Z",
 *   "sessionId": "abc-123",
 *   "toolName": "Read",
 *   "toolType": "file",
 *   "parameters": { "value": "/path/to/file.ts" },
 *   "context": {
 *     "projectDir": "/Users/user/project",
 *     "userIntent": "Show me the authentication code",
 *     "messageLength": 1234
 *   }
 * }
 *
 *
 * EXAMPLE 2: Web search logging
 *
 * Assistant uses WebSearch("React hooks best practices")
 *
 * Log entry:
 * {
 *   "timestamp": "2025-11-09T14:35:00.000Z",
 *   "sessionId": "abc-123",
 *   "toolName": "WebSearch",
 *   "toolType": "web",
 *   "parameters": { "value": "React hooks best practices" },
 *   "context": {
 *     "userIntent": "Research React hooks patterns",
 *     "messageLength": 2345
 *   }
 * }
 *
 *
 * EXAMPLE 3: Skill activation logging
 *
 * Assistant uses Skill("engineering")
 *
 * Log entry:
 * {
 *   "timestamp": "2025-11-09T14:40:00.000Z",
 *   "sessionId": "abc-123",
 *   "toolName": "Skill",
 *   "toolType": "skill",
 *   "parameters": { "value": "engineering" },
 *   "context": {
 *     "userIntent": "Build a REST API",
 *     "messageLength": 3456
 *   }
 * }
 */

// ============================================================================
// ANALYTICS EXAMPLES
// ============================================================================

/**
 * EXAMPLE: Generate usage report
 *
 * ```typescript
 * import { readToolUsageLogs, aggregateToolStats } from './log-tool-use.ts';
 *
 * const logs = await readToolUsageLogs();
 * const stats = aggregateToolStats(logs);
 *
 * console.log("Tool Usage Statistics:");
 * for (const [tool, count] of Object.entries(stats)) {
 *   console.log(`  ${tool}: ${count} uses`);
 * }
 * ```
 *
 * Output:
 * Tool Usage Statistics:
 *   Read: 45 uses
 *   Write: 23 uses
 *   Bash: 34 uses
 *   WebSearch: 12 uses
 *   Skill: 8 uses
 */

// ============================================================================
// TROUBLESHOOTING
// ============================================================================

/**
 * ISSUE: Log file not created
 *
 * 1. Check permissions on PAI directory:
 *    ls -la ~/.claude/.claude/logs/
 *
 * 2. Check environment variables:
 *    echo $PAI_DIR
 *    echo $TOOL_LOGGING_ENABLED
 *
 * 3. Check hook is configured:
 *    cat ~/.claude/.claude/settings.json | grep log-tool-use
 *
 *
 * ISSUE: Sensitive data in logs
 *
 * 1. Check SENSITIVE_PARAMS list above
 * 2. Add your parameter names to the list
 * 3. Re-run to filter future logs
 * 4. Manually clean existing logs if needed
 *
 *
 * ISSUE: Too many false positives
 *
 * 1. Add to isFalsePositive() function
 * 2. Improve tool detection regex
 * 3. Adjust categorization logic
 */

// ============================================================================
// CUSTOMIZATION TIPS
// ============================================================================

/**
 * 1. Custom log format:
 *    - Add more context fields
 *    - Include execution time
 *    - Add success/failure status
 *
 * 2. Advanced analytics:
 *    - Track tool sequences (which tools follow others)
 *    - Measure response time per tool
 *    - Identify tool failure patterns
 *
 * 3. Log rotation:
 *    - Implement daily/weekly log rotation
 *    - Archive old logs
 *    - Compress archived logs
 *
 * 4. Real-time monitoring:
 *    - Send logs to monitoring service
 *    - Create dashboard for tool usage
 *    - Set up alerts for unusual patterns
 */
