# Hook Implementations

**Production-ready hook implementations for Claude Code PAI system**

Created: 2025-11-09
Location: `/templates/hooks/`

---

## 📋 Available Hooks

### 1. skill-activation.ts

**Type:** UserPromptSubmit
**Purpose:** Automatically activate the most appropriate skill based on user intent

**Features:**
- Reads SKILLS-INDEX.md for skill definitions and trigger patterns
- Intelligent pattern matching and scoring algorithm
- Manual skill override support (`/skillname: message`)
- Confidence-based activation threshold
- Detailed logging and metadata

**Dependencies:**
- Requires `~/.claude/.claude/SKILLS-INDEX.md`
- Uses the Skill tool for activation

**Configuration:**
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [{
          "type": "command",
          "command": "bun run ${PAI_DIR}/.claude/hooks/skill-activation.ts"
        }]
      }
    ]
  }
}
```

**Usage Example:**
```
User: "Build a REST API for user authentication"
→ Detects: "Build", "API", "authentication"
→ Activates: engineering skill
→ Claude responds as George Foster
```

---

### 2. stop-voice.ts

**Type:** Stop
**Purpose:** Voice feedback via ElevenLabs after Claude's response

**Features:**
- Extracts COMPLETED and CUSTOM COMPLETED tags
- Supports agent-specific voice IDs
- ElevenLabs API integration
- Privacy-conscious text cleaning
- Graceful error handling (never blocks)
- Configurable speech rate

**Dependencies:**
- Voice server running on port 8888 (configurable)
- ElevenLabs API key
- COMPLETED tags in assistant messages

**Environment Variables:**
```bash
VOICE_ENABLED=true
VOICE_SERVER_URL=http://localhost:8888
VOICE_RATE=260
ELEVENLABS_API_KEY=your_api_key
PAI_DIR=/Users/username/.claude
```

**Configuration:**
```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [{
          "type": "command",
          "command": "bun run ${PAI_DIR}/.claude/hooks/stop-voice.ts"
        }]
      }
    ]
  }
}
```

**Usage Example:**
```
🎯 COMPLETED: [AGENT:engineer] Auth system implemented
🗣️ CUSTOM COMPLETED: Auth complete

→ Voice triggered with George Foster's voice
→ Speaks: "Auth complete"
```

---

### 3. log-tool-use.ts

**Type:** Stop
**Purpose:** Log tool usage for analytics and debugging

**Features:**
- Detects tool usage from assistant messages
- Structured JSON Lines logging format
- Privacy filtering (removes sensitive parameters)
- Tool categorization (file, shell, web, etc.)
- False positive filtering
- Built-in analytics utilities

**Dependencies:**
- None (standalone)
- Creates `~/.claude/.claude/logs/tool-usage.jsonl`

**Environment Variables:**
```bash
TOOL_LOGGING_ENABLED=true  # Optional, default: true
PAI_DIR=/Users/username/.claude
```

**Configuration:**
```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [{
          "type": "command",
          "command": "bun run ${PAI_DIR}/.claude/hooks/log-tool-use.ts"
        }]
      }
    ]
  }
}
```

**Log Format:**
```json
{
  "timestamp": "2025-11-09T14:30:00.000Z",
  "sessionId": "abc-123",
  "toolName": "Read",
  "toolType": "file",
  "parameters": { "value": "/path/to/file.ts" },
  "context": {
    "projectDir": "/Users/user/project",
    "userIntent": "Show me the code",
    "messageLength": 1234
  }
}
```

---

## 🚀 Installation

### 1. Copy Hooks to PAI Directory

```bash
# Copy hooks to your PAI hooks directory
cp skill-activation.ts ~/.claude/.claude/hooks/
cp stop-voice.ts ~/.claude/.claude/hooks/
cp log-tool-use.ts ~/.claude/.claude/hooks/

# Make sure they're executable
chmod +x ~/.claude/.claude/hooks/*.ts
```

### 2. Configure in settings.json

Add to `~/.claude/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [{
          "type": "command",
          "command": "bun run ${PAI_DIR}/.claude/hooks/skill-activation.ts"
        }]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bun run ${PAI_DIR}/.claude/hooks/stop-voice.ts"
          },
          {
            "type": "command",
            "command": "bun run ${PAI_DIR}/.claude/hooks/log-tool-use.ts"
          }
        ]
      }
    ]
  }
}
```

### 3. Set Environment Variables

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
# PAI Configuration
export PAI_DIR="$HOME/.claude"

# Voice System (optional)
export VOICE_ENABLED=true
export VOICE_SERVER_URL="http://localhost:8888"
export VOICE_RATE=260
export ELEVENLABS_API_KEY="your_api_key_here"

# Tool Logging (optional)
export TOOL_LOGGING_ENABLED=true
```

### 4. Customize Voice IDs

Edit `stop-voice.ts` and replace placeholders:

```typescript
const VOICE_MAP: Record<string, VoiceConfig> = {
  engineering: {
    id: 'your_elevenlabs_voice_id',  // Replace <VOICE_ID_ENGINEERING>
    name: 'George Foster',
    accent: 'British',
    language: 'en'
  },
  // ... etc
};
```

Get voice IDs from: https://elevenlabs.io/voice-library

### 5. Create SKILLS-INDEX.md

Required for skill-activation.ts:

```bash
# Copy template
cp /path/to/templates/skills/SKILLS-INDEX.md ~/.claude/.claude/

# Edit with your skills
vim ~/.claude/.claude/SKILLS-INDEX.md
```

---

## 🧪 Testing

### Test Skill Activation

```bash
# Test with sample message
echo '{"userMessage": "Build a REST API", "sessionId": "test-123"}' | \
  bun run ~/.claude/.claude/hooks/skill-activation.ts
```

Expected output: System message with skill activation instructions

### Test Voice Hook

```bash
# Create test message with COMPLETED tag
TEST_MSG='🎯 COMPLETED: [AGENT:engineer] Test complete
🗣️ CUSTOM COMPLETED: Done'

echo "{\"assistantMessage\": \"$TEST_MSG\", \"sessionId\": \"test-123\"}" | \
  bun run ~/.claude/.claude/hooks/stop-voice.ts
```

Expected: Voice server API call (check logs)

### Test Tool Logging

```bash
# Create test message with tool usage
TEST_MSG='I used Read("/path/to/file.ts") and Bash("ls -la")'

echo "{\"assistantMessage\": \"$TEST_MSG\", \"sessionId\": \"test-123\"}" | \
  bun run ~/.claude/.claude/hooks/log-tool-use.ts

# Check log file
cat ~/.claude/.claude/logs/tool-usage.jsonl | tail -2
```

Expected: 2 log entries (Read and Bash)

---

## 📊 Analytics

### View Tool Usage Statistics

```typescript
// Create analyze-tools.ts
import { readToolUsageLogs, aggregateToolStats } from './log-tool-use.ts';

const logs = await readToolUsageLogs();
const stats = aggregateToolStats(logs);

console.log("Most Used Tools:");
Object.entries(stats)
  .sort((a, b) => b[1] - a[1])
  .slice(0, 10)
  .forEach(([tool, count]) => {
    console.log(`  ${tool}: ${count}`);
  });
```

Run:
```bash
bun run analyze-tools.ts
```

### Query Logs with jq

```bash
# Most used tools
cat ~/.claude/.claude/logs/tool-usage.jsonl | \
  jq -r '.toolName' | sort | uniq -c | sort -rn | head -10

# Tool usage by type
cat ~/.claude/.claude/logs/tool-usage.jsonl | \
  jq -r '.toolType' | sort | uniq -c | sort -rn

# Today's tool usage
cat ~/.claude/.claude/logs/tool-usage.jsonl | \
  jq -r "select(.timestamp | startswith(\"$(date +%Y-%m-%d)\")) | .toolName" | \
  sort | uniq -c
```

---

## 🔧 Troubleshooting

### Skill Activation Not Working

**Check SKILLS-INDEX.md exists:**
```bash
ls -la ~/.claude/.claude/SKILLS-INDEX.md
```

**Check hook configuration:**
```bash
cat ~/.claude/.claude/settings.json | grep -A 5 UserPromptSubmit
```

**Enable debug logging:**
```bash
# Run manually to see errors
echo '{"userMessage": "test", "sessionId": "test"}' | \
  bun run ~/.claude/.claude/hooks/skill-activation.ts
```

### Voice Not Playing

**Check voice server:**
```bash
curl http://localhost:8888/health
```

**Check environment variables:**
```bash
echo $VOICE_ENABLED
echo $VOICE_SERVER_URL
echo $ELEVENLABS_API_KEY
```

**Test voice server directly:**
```bash
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message":"Test","voice_enabled":true}'
```

### Tool Logging Not Creating Files

**Check log directory:**
```bash
mkdir -p ~/.claude/.claude/logs
ls -la ~/.claude/.claude/logs/
```

**Check permissions:**
```bash
touch ~/.claude/.claude/logs/test.txt
rm ~/.claude/.claude/logs/test.txt
```

**Run manually:**
```bash
echo '{"assistantMessage": "Read(\"test\")", "sessionId": "test"}' | \
  bun run ~/.claude/.claude/hooks/log-tool-use.ts

cat ~/.claude/.claude/logs/tool-usage.jsonl
```

---

## 🎯 Best Practices

### Skill Activation

1. **Keep trigger patterns specific** - Avoid generic words
2. **Review activation logs** - Ensure correct skill is chosen
3. **Use manual override** - When automatic detection fails
4. **Update SKILLS-INDEX.md** - Add new skills as needed

### Voice Feedback

1. **Use CUSTOM COMPLETED** - Keep voice messages short (under 8 words)
2. **Test voices** - Ensure voice IDs are correct
3. **Set appropriate rate** - 260 is natural, adjust to preference
4. **Handle errors gracefully** - Voice should never block responses

### Tool Logging

1. **Review logs regularly** - Identify usage patterns
2. **Clean sensitive data** - Add to SENSITIVE_PARAMS list
3. **Rotate logs** - Archive old logs to keep files small
4. **Use for debugging** - Track down tool integration issues

---

## 📝 Customization

### Add New Voice

```typescript
// In stop-voice.ts, add to VOICE_MAP:
'my-skill': {
  id: 'elevenlabs_voice_id',
  name: 'Voice Name',
  accent: 'British',
  language: 'en'
}
```

### Add New Tool Type

```typescript
// In log-tool-use.ts, add to categorizeToolType():
const typeMap: Record<string, string> = {
  // ... existing mappings
  'MyCustomTool': 'custom',
};
```

### Adjust Skill Activation Threshold

```typescript
// In skill-activation.ts:
const ACTIVATION_THRESHOLD = 30; // Higher = more selective
```

---

## 📚 Related Documentation

- **SKILLS-INDEX.md** - Skill definitions and trigger patterns
- **voice-system.md** - Voice system architecture
- **PAI.md** - Core PAI configuration
- **settings.json** - Hook configuration

---

## 🤝 Contributing

These hooks are production-ready but can always be improved:

1. **Report issues** - Open GitHub issues for bugs
2. **Share improvements** - Submit PRs with enhancements
3. **Add examples** - Document your use cases
4. **Write tests** - Improve test coverage

---

## 📄 License

Part of the Ogmios PAI system. Use freely, share improvements.

---

**Built for Claude Code. Optimized for productivity.** 🚀
