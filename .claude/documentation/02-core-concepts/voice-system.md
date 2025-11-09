# Voice System - Multi-Voice TTS Integration

**Version**: 1.0.0
**Last Updated**: 2025-11-09
**Status**: Production (Optional Feature)

---

## Overview

The Ogmios Voice System provides **multi-voice text-to-speech feedback** using ElevenLabs TTS API. Each Specialized AI Assistants specialist has a unique voice, creating an immersive experience where you can **hear** which expert is speaking.

**Key Benefits:**
- **Multi-tasking**: Hear completion status without looking at screen
- **Personality**: Each specialist has distinct voice matching their expertise
- **Engagement**: Audio feedback makes interactions feel more alive
- **Bilingual**: Supports both English and Swedish voices
- **Optional**: Fully functional without voice system enabled

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [System Components](#system-components)
3. [Voice Mappings](#voice-mappings)
4. [Installation and Setup](#installation-and-setup)
5. [How It Works](#how-it-works)
6. [Configuration](#configuration)
7. [Testing Voices](#testing-voices)
8. [Troubleshooting](#troubleshooting)
9. [Development Guide](#development-guide)
10. [Performance and Limits](#performance-and-limits)

---

## Architecture Overview

### High-Level Flow

```
User completes conversation (Stop event)
  ↓
Stop hook triggers
  ↓
Read transcript, extract COMPLETED line
  ↓
Extract [SKILL:skill-name] tag
  ↓
Load skill's SKILL.md, read voice_id
  ↓
Send to Voice Server (HTTP POST)
  ↓
Voice Server → ElevenLabs API
  ↓
TTS audio generated
  ↓
Audio played via afplay (macOS)
  ↓
User hears specialist's voice
```

### Components Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    CLAUDE CODE                              │
│  User stops conversation (Stop event)                       │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────────────────────┐
│              STOP HOOK (stop-hook.ts)                       │
│  1. Read transcript                                         │
│  2. Find COMPLETED line                                     │
│  3. Extract [SKILL:name] tag                                │
│  4. Load SKILL.md → read voice_id                           │
│  5. Build request: {message, voice_id}                      │
└──────────────────┬──────────────────────────────────────────┘
                   │ HTTP POST
                   ↓
┌─────────────────────────────────────────────────────────────┐
│          VOICE SERVER (voice-server/server.ts)              │
│  1. Receive request                                         │
│  2. Call ElevenLabs API                                     │
│  3. Save audio to /tmp                                      │
│  4. Play via afplay                                         │
│  5. Clean up temp files                                     │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────────────────────┐
│              ELEVENLABS API                                 │
│  Neural TTS generation                                      │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   ↓
              Audio Output
```

---

## System Components

### 1. Voice Server

**Location**: `~/.claude/.claude/voice-server/`

**Technology**: Bun + TypeScript HTTP server

**Port**: 8888 (configurable)

**Responsibilities:**
- Receive voice requests via HTTP
- Call ElevenLabs TTS API
- Save audio files temporarily
- Play audio via macOS `afplay`
- Clean up temporary files

**Key Files:**
- `server.ts` - Main server implementation
- `package.json` - Dependencies
- `README.md` - Server-specific documentation

### 2. Stop Hook

**Location**: `~/.claude/.claude/hooks/stop-hook.ts`

**Trigger**: Every time user stops conversation (Stop event)

**Responsibilities:**
- Read conversation transcript
- Parse COMPLETED line format
- Extract skill name from [SKILL:name] tag
- Load skill's SKILL.md for voice_id
- Send request to voice server
- Fallback to Ogmios voice if no skill

**Key Logic:**
```typescript
// 1. Find COMPLETED line
const completedMatch = transcript.match(/🎯 COMPLETED: (.+)/);

// 2. Extract skill tag
const skillMatch = completedMatch[1].match(/\[SKILL:([^\]]+)\]/);

// 3. Load SKILL.md
const skillFile = `~/.claude/.claude/skills/${skillName}/SKILL.md`;
const skillContent = await readFile(skillFile);

// 4. Extract voice_id from frontmatter
const voiceMatch = skillContent.match(/voice_id:\s*([^\s]+)/);

// 5. Send to voice server
await fetch('http://localhost:8888/notify', {
  method: 'POST',
  body: JSON.stringify({
    message: completedText,
    voice_id: voiceId
  })
});
```

### 3. Skill Configuration

**Location**: Each skill's `SKILL.md` frontmatter

**Format:**
```yaml
---
name: engineering
description: ...
voice_id: JBFqnCBsd6RMkjVDRZzb  # George Foster
specialist: George Foster - Senior Engineer
tier: 1
---
```

**Purpose:**
- Associates skill with specific voice
- Enables automatic voice selection
- Provides specialist identity

### 4. Voice Mappings

**Location**: `~/.claude/.claude/hooks/voice-mappings.ts`

**Purpose**: Fallback mappings for agents using Task tool (not skills)

**Structure:**
```typescript
export const AGENT_VOICE_IDS: Record<string, string> = {
  researcher: 'Xb7hH8MSUJpSbSDYk0k2',      // Alice Mitchell
  engineer: 'JBFqnCBsd6RMkjVDRZzb',        // George Foster
  security: 'onwK4e9ZLuTAKqWW03F9',        // Daniel Davies
  ogmios: 'goT3UYdM9bhm0n2lmKQx',          // Ogmios (English)
  'ogmios-sv': 'JhAQDwsLijg4qbxGNQGH',     // Max (Swedish)
  default: 'goT3UYdM9bhm0n2lmKQx'          // Default to Ogmios
};
```

---

## Voice Mappings

### Specialized AI Assistants Voices

Complete 10-voice team using ElevenLabs pre-made and professional voices:

| Specialist | Role | Voice Accent | Voice ID | Skill |
|-----------|------|--------------|----------|-------|
| **Ogmios** | Team Lead | British | `goT3UYdM9bhm0n2lmKQx` | (default) |
| **Max Andersson** | Swedish Specialist | Swedish | `JhAQDwsLijg4qbxGNQGH` | swedish-content |
| **Alice Mitchell** | Research Analyst | British Female | `Xb7hH8MSUJpSbSDYk0k2` | research |
| **George Foster** | Senior Engineer | British Male | `JBFqnCBsd6RMkjVDRZzb` | engineering |
| **Daniel Davies** | Security Officer | British Male | `onwK4e9ZLuTAKqWW03F9` | security |
| **Callum** | Technical Architect | Neutral | `N2lVS1w4EtoT3dr4eOWO` | architecture |
| **Lily** | Technical Writer | Neutral Female | `pFZP5JQG7iQjIQuC4Bku` | technical-writing |
| **Jessica** | UX/UI Designer | American Female | `cgSgspJ2msm6clMCkdW9` | design |
| **Matilda** | Data Analyst | American Female | `XrExE9yKIg1WjnnlVkGX` | data-analysis |
| **Chris** | DevOps Engineer | American Male | `iP95p4xoKVk53GoZ742B` | devops |

**Gender Balance**: 5 male, 5 female
**Accent Diversity**: 4 British, 1 Swedish, 3 American, 2 Neutral
**Voice Type**: All pre-made ElevenLabs voices (no custom voice limits)

### Language-Specific Behavior

**For Skills:**
- Voice remains constant regardless of input language
- George Foster speaks English (even for Swedish input to engineering)
- Max Andersson speaks Swedish (swedish-content skill)
- Prof. Lars Bergström speaks Swedish (swedish-academic-writing skill)

**For Ogmios (no skill):**
- English input → Ogmios voice (English British)
- Swedish input → Max voice (Swedish)

**Detection Logic:**
```typescript
function getOgmiosVoice(text: string): string {
  const swedishPatterns = /\b(och|är|för|på|att|med|som|till|av|från|jag|du|han|hon|det|vi|ni|de)\b/i;
  return swedishPatterns.test(text)
    ? 'JhAQDwsLijg4qbxGNQGH'  // Max (Swedish)
    : 'goT3UYdM9bhm0n2lmKQx'; // Ogmios (English)
}
```

---

## Installation and Setup

### Prerequisites

1. **Claude Code** installed
2. **Bun** runtime installed (`curl -fsSL https://bun.sh/install | bash`)
3. **macOS** (for `afplay` audio playback)
4. **ElevenLabs account** with API key

### Step-by-Step Setup

**1. Get ElevenLabs API Key**

```bash
# Sign up at https://elevenlabs.io
# Free tier: 10,000 characters/month
# Navigate to: Profile → API Keys → Create
```

**2. Add API Key to Environment**

```bash
# Edit ~/.env
echo 'ELEVENLABS_API_KEY="your-api-key-here"' >> ~/.env

# Or edit existing .env file
nano ~/.env
```

**3. Install Voice Server Dependencies**

```bash
cd ~/.claude/.claude/voice-server
bun install
```

**4. Start Voice Server**

```bash
# Start in foreground (see logs)
cd ~/.claude/.claude/voice-server
bun server.ts

# OR start in background
cd ~/.claude/.claude/voice-server
bun server.ts > ~/Logs/pai-voice-server.log 2>&1 &
```

**5. Verify Installation**

```bash
# Check server health
curl http://localhost:8888/health

# Expected response:
# {"status":"healthy","port":8888,"voice_system":"ElevenLabs",...}

# Test voice output
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message":"Voice system test","voice_id":"goT3UYdM9bhm0n2lmKQx"}'

# You should hear: "Voice system test" in Ogmios voice
```

**6. Verify Stop Hook Integration**

```bash
# Check stop-hook is registered in settings.json
grep -A5 '"Stop"' ~/.claude/settings.json

# Should see:
# "Stop": [
#   "~/.claude/.claude/hooks/stop-hook.ts"
# ]
```

### Auto-Start Voice Server (Optional)

**macOS LaunchAgent:**

Create `~/Library/LaunchAgents/com.ogmios.voice-server.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.ogmios.voice-server</string>
  <key>ProgramArguments</key>
  <array>
    <string>/Users/<USERNAME>/.bun/bin/bun</string>
    <string>/Users/<USERNAME>/.claude/.claude/voice-server/server.ts</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>/Users/<USERNAME>/Logs/pai-voice-server.log</string>
  <key>StandardErrorPath</key>
  <string>/Users/<USERNAME>/Logs/pai-voice-server-error.log</string>
</dict>
</plist>
```

Replace `<USERNAME>` with your username, then:

```bash
# Load the service
launchctl load ~/Library/LaunchAgents/com.ogmios.voice-server.plist

# Start the service
launchctl start com.ogmios.voice-server

# Check status
launchctl list | grep ogmios
```

---

## How It Works

### Complete Workflow

**1. User Interaction**

```
User: "Build a REST API"
  ↓
Engineering skill activates (George Foster)
  ↓
George: [implements API with code]
  ↓
George: "🎯 COMPLETED: Built REST API with authentication [SKILL:engineering]"
  ↓
User stops conversation
```

**2. Stop Hook Processing**

```typescript
// Hook reads transcript
const transcript = await readFile(transcriptPath);

// Find COMPLETED line
const completedLine = transcript.match(/🎯 COMPLETED: (.+)/);
// Result: "Built REST API with authentication [SKILL:engineering]"

// Extract skill
const skillMatch = completedLine[1].match(/\[SKILL:([^\]]+)\]/);
// Result: "engineering"

// Load skill config
const skillPath = `~/.claude/.claude/skills/engineering/SKILL.md`;
const skillContent = await readFile(skillPath);

// Extract voice_id from YAML frontmatter
const voiceMatch = skillContent.match(/voice_id:\s*([^\s]+)/);
// Result: "JBFqnCBsd6RMkjVDRZzb"
```

**3. Voice Server Request**

```typescript
await fetch('http://localhost:8888/notify', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    message: "Built REST API with authentication",
    voice_id: "JBFqnCBsd6RMkjVDRZzb"  // George Foster
  })
});
```

**4. ElevenLabs TTS Generation**

```typescript
// Voice server calls ElevenLabs
const response = await fetch(
  `https://api.elevenlabs.io/v1/text-to-speech/${voice_id}`,
  {
    method: 'POST',
    headers: {
      'xi-api-key': process.env.ELEVENLABS_API_KEY,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      text: message,
      model_id: "eleven_monolingual_v1",
      voice_settings: {
        stability: 0.5,
        similarity_boost: 0.75
      }
    })
  }
);

// Save audio to temp file
const audioPath = `/tmp/ogmios-voice-${Date.now()}.mp3`;
await Bun.write(audioPath, await response.arrayBuffer());
```

**5. Audio Playback**

```typescript
// Play via macOS afplay
const proc = Bun.spawn(['afplay', audioPath]);
await proc.exited;

// Clean up
await unlink(audioPath);
```

**6. User Experience**

```
🔊 [George Foster voice]: "Built REST API with authentication"
```

### COMPLETED Line Format

**Required Format:**
```
🎯 COMPLETED: [brief description of accomplishment] [SKILL:skill-name]
```

**Examples:**
```
🎯 COMPLETED: Built REST API with authentication [SKILL:engineering]
🎯 COMPLETED: Researched AI agent architectures thoroughly [SKILL:research]
🎯 COMPLETED: Designed responsive dashboard layout [SKILL:design]
🎯 COMPLETED: Conducted security audit of authentication [SKILL:security]
```

**Optional Custom Voice Message:**
```
🎯 COMPLETED: Sent detailed project proposal email to stakeholder
🗣️ CUSTOM COMPLETED: Email sent
```

If `CUSTOM COMPLETED` exists and is under 8 words, it's used for voice output instead of main COMPLETED line.

---

## Configuration

### Voice Server Configuration

**Environment Variables (.env):**

```bash
# Required
ELEVENLABS_API_KEY="your-api-key-here"

# Optional (defaults shown)
PORT="8888"
ELEVENLABS_VOICE_ID="goT3UYdM9bhm0n2lmKQx"  # Default Ogmios voice
```

**Server Options (server.ts):**

```typescript
const PORT = process.env.PORT || 8888;
const DEFAULT_VOICE_ID = process.env.ELEVENLABS_VOICE_ID || 'goT3UYdM9bhm0n2lmKQx';

// Rate limiting
const RATE_LIMIT = 10; // requests per minute
const RATE_WINDOW = 60 * 1000; // 1 minute

// Audio settings
const AUDIO_FORMAT = 'mp3_44100_128';  // ElevenLabs format
const MODEL_ID = 'eleven_monolingual_v1';  // TTS model
```

### Skill Voice Configuration

**In each SKILL.md frontmatter:**

```yaml
---
name: engineering
description: Code implementation, debugging, optimization.
  USE WHEN user says 'build', 'implement', 'fix bug'
voice_id: JBFqnCBsd6RMkjVDRZzb  # George Foster voice
specialist: George Foster - Senior Engineer
tier: 1
---
```

**Adding New Voice to Skill:**

1. Choose ElevenLabs voice ID from your account
2. Update SKILL.md frontmatter
3. Test with curl (see Testing Voices section)

### Voice Mappings Fallback

**For agents not using skills (voice-mappings.ts):**

```typescript
export const AGENT_VOICE_IDS: Record<string, string> = {
  // Add new agent voice
  'custom-agent': '<ELEVENLABS_VOICE_ID>',

  // Existing mappings
  researcher: 'Xb7hH8MSUJpSbSDYk0k2',
  engineer: 'JBFqnCBsd6RMkjVDRZzb',
  // ...

  default: 'goT3UYdM9bhm0n2lmKQx'
};
```

---

## Testing Voices

### Test Individual Voices

```bash
# Test Ogmios (English)
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message":"I am Ogmios, your team lead","voice_id":"goT3UYdM9bhm0n2lmKQx"}'

# Test Max (Swedish)
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message":"Jag är Max, svensk språkspecialist","voice_id":"JhAQDwsLijg4qbxGNQGH"}'

# Test Alice (Research)
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message":"I am Alice, research analyst","voice_id":"Xb7hH8MSUJpSbSDYk0k2"}'

# Test George (Engineering)
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message":"I am George, senior engineer","voice_id":"JBFqnCBsd6RMkjVDRZzb"}'

# Test Daniel (Security)
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message":"I am Daniel, security officer","voice_id":"onwK4e9ZLuTAKqWW03F9"}'
```

### Test All 10 Team Members

```bash
# Script to test all voices
#!/bin/bash

declare -A voices=(
  ["Ogmios"]="goT3UYdM9bhm0n2lmKQx"
  ["Max"]="JhAQDwsLijg4qbxGNQGH"
  ["Alice"]="Xb7hH8MSUJpSbSDYk0k2"
  ["George"]="JBFqnCBsd6RMkjVDRZzb"
  ["Daniel"]="onwK4e9ZLuTAKqWW03F9"
  ["Callum"]="N2lVS1w4EtoT3dr4eOWO"
  ["Lily"]="pFZP5JQG7iQjIQuC4Bku"
  ["Jessica"]="cgSgspJ2msm6clMCkdW9"
  ["Matilda"]="XrExE9yKIg1WjnnlVkGX"
  ["Chris"]="iP95p4xoKVk53GoZ742B"
)

for name in "${!voices[@]}"; do
  echo "Testing $name..."
  curl -X POST http://localhost:8888/notify \
    -H "Content-Type: application/json" \
    -d "{\"message\":\"I am $name\",\"voice_id\":\"${voices[$name]}\"}"
  sleep 2
done
```

### Test via Claude Code

**Trigger engineering skill:**
```
User: "Build a simple calculator function"

Expected:
- George Foster voice
- "🎯 COMPLETED: Built calculator function [SKILL:engineering]"
```

**Trigger research skill:**
```
User: "Research TypeScript best practices"

Expected:
- Alice Mitchell voice
- "🎯 COMPLETED: Researched TypeScript best practices [SKILL:research]"
```

---

## Troubleshooting

### Voice Not Playing

**1. Check Voice Server Status**

```bash
# Test health endpoint
curl http://localhost:8888/health

# Expected: {"status":"healthy",...}
# If fails: Server not running
```

**2. Check API Key**

```bash
# Verify API key is set
grep ELEVENLABS_API_KEY ~/.env

# Should show: ELEVENLABS_API_KEY="your-key-here"
# If empty: Add API key
```

**3. Test Direct Voice Request**

```bash
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message":"Test","voice_id":"goT3UYdM9bhm0n2lmKQx"}'

# Should hear audio
# If fails: Check server logs
```

**4. Check Server Logs**

```bash
# If running in background
tail -f ~/Logs/pai-voice-server.log

# Look for errors like:
# - "Invalid API key"
# - "Rate limit exceeded"
# - "Voice ID not found"
```

### Wrong Voice Playing

**1. Check SKILL.md voice_id**

```bash
# For engineering skill
grep voice_id ~/.claude/.claude/skills/engineering/SKILL.md

# Should show: voice_id: JBFqnCBsd6RMkjVDRZzb
```

**2. Check [SKILL:name] Tag**

```bash
# In Claude response, look for:
🎯 COMPLETED: ... [SKILL:engineering]

# Tag must match skill directory name exactly
```

**3. Test Skill Voice Directly**

```bash
# Extract voice_id from SKILL.md
voice_id=$(grep voice_id ~/.claude/.claude/skills/engineering/SKILL.md | cut -d: -f2 | tr -d ' ')

# Test that voice
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d "{\"message\":\"Test engineering voice\",\"voice_id\":\"$voice_id\"}"
```

### Voice Server Won't Start

**1. Check Port Availability**

```bash
# Check if port 8888 is in use
lsof -i :8888

# If in use, kill process:
kill $(lsof -t -i:8888)
```

**2. Check Bun Installation**

```bash
# Verify bun is installed
which bun

# Should show: /Users/<username>/.bun/bin/bun
# If not: curl -fsSL https://bun.sh/install | bash
```

**3. Check Dependencies**

```bash
cd ~/.claude/.claude/voice-server
bun install

# Should install without errors
```

**4. Start in Foreground to See Errors**

```bash
cd ~/.claude/.claude/voice-server
bun server.ts

# Look for startup errors
```

### ElevenLabs API Errors

**401 Unauthorized:**
```
Cause: Invalid API key
Fix: Check ELEVENLABS_API_KEY in ~/.env
```

**429 Too Many Requests:**
```
Cause: Rate limit exceeded
Fix: Wait a minute or upgrade ElevenLabs plan
```

**422 Unprocessable Entity:**
```
Cause: Invalid voice_id
Fix: Verify voice_id exists in your ElevenLabs account
```

**Quota Exceeded:**
```
Cause: Monthly character limit reached (10,000 free tier)
Fix: Wait for monthly reset or upgrade plan
```

### No COMPLETED Line

**Issue:** Voice doesn't play because COMPLETED line is missing or malformed

**Check:**
```bash
# COMPLETED line must be exact format:
🎯 COMPLETED: [description] [SKILL:name]

# Common mistakes:
❌ COMPLETED: ...  (missing emoji)
❌ 🎯 Completed: ... (wrong capitalization)
❌ 🎯 COMPLETED [description]  (missing colon)
❌ 🎯 COMPLETED: ... SKILL:name  (missing brackets)
```

**Fix:** Ensure all responses end with proper format

---

## Development Guide

### Adding New Voices

**1. Get Voice ID from ElevenLabs**

- Log in to https://elevenlabs.io
- Navigate to Voice Library
- Choose pre-made voice or create custom
- Copy voice ID (long alphanumeric string)

**2. Add to Skill**

```yaml
# In skills/<skill-name>/SKILL.md
---
name: <skill-name>
voice_id: <NEW_VOICE_ID>
specialist: <Specialist Name> - <Title>
---
```

**3. Test New Voice**

```bash
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message":"Testing new voice","voice_id":"<NEW_VOICE_ID>"}'
```

**4. Update Documentation**

Add to voice mappings table in this document.

### Customizing Voice Settings

**In server.ts, modify ElevenLabs request:**

```typescript
const ttsRequest = {
  text: message,
  model_id: "eleven_monolingual_v1",  // or "eleven_multilingual_v2"
  voice_settings: {
    stability: 0.5,          // 0-1, higher = more stable/monotone
    similarity_boost: 0.75,  // 0-1, higher = closer to voice sample
    style: 0,                // 0-1, exaggeration (v2 only)
    use_speaker_boost: true  // Enhance clarity
  }
};
```

**Recommended settings by use case:**

```typescript
// Professional/Corporate
{ stability: 0.7, similarity_boost: 0.8, style: 0.3 }

// Expressive/Dynamic
{ stability: 0.3, similarity_boost: 0.6, style: 0.7 }

// Audiobook/Narration
{ stability: 0.5, similarity_boost: 0.75, style: 0.5 }
```

### Extending Voice Server

**Add custom endpoint:**

```typescript
// In server.ts
server.get('/custom-voice', async (req) => {
  const params = new URL(req.url).searchParams;
  const message = params.get('message');
  const voiceId = params.get('voice_id');

  // Your custom logic here

  return new Response(JSON.stringify({ status: 'success' }));
});
```

### Debugging Hook Logic

**Add logging to stop-hook.ts:**

```typescript
// Log transcript
console.error('[VOICE] Transcript:', transcript);

// Log COMPLETED extraction
console.error('[VOICE] Completed line:', completedLine);

// Log skill detection
console.error('[VOICE] Skill detected:', skillName);

// Log voice_id
console.error('[VOICE] Voice ID:', voiceId);

// Check logs
tail -f ~/.claude/.claude/hooks/stop-hook.log
```

---

## Performance and Limits

### ElevenLabs API Limits

**Free Tier:**
- 10,000 characters/month
- ~30 minutes of audio
- All pre-made voices included
- Standard TTS model

**Starter Plan ($5/month):**
- 30,000 characters/month
- ~90 minutes of audio
- Custom voice creation
- Advanced TTS model

**Creator Plan ($22/month):**
- 100,000 characters/month
- ~5 hours of audio
- Higher quality voices
- Commercial use

### Performance Metrics

**Voice Generation Time:**
- Short message (< 50 chars): ~500ms
- Medium message (50-200 chars): ~1-2s
- Long message (> 200 chars): ~2-4s

**Factors:**
- API latency: ~200-500ms
- TTS generation: ~300-2000ms
- Network transfer: ~100-500ms
- Audio playback: Immediate

**Optimization Tips:**
- Keep COMPLETED messages concise (< 100 chars)
- Use CUSTOM COMPLETED for short versions
- Rate limiting prevents overwhelming API
- Caching not implemented (each generation is fresh)

### Resource Usage

**Voice Server:**
- Memory: ~50MB (Bun runtime)
- CPU: Minimal (HTTP server + API calls)
- Disk: ~5MB temporary audio files (auto-cleaned)
- Network: ~10-50KB per request

**Audio Files:**
- Format: MP3 44.1kHz 128kbps
- Size: ~1KB per second of audio
- Storage: /tmp (temporary, auto-deleted)
- Cleanup: Immediate after playback

---

## Security and Privacy

### API Key Security

**Best Practices:**
- Store in `~/.env` (gitignored)
- Never commit to public repositories
- Rotate keys periodically
- Use environment-specific keys

**Access Control:**
- Voice server listens on localhost only
- CORS restricted to localhost
- No external access by default
- Rate limiting enabled

### Data Privacy

**What gets sent to ElevenLabs:**
- Text message (COMPLETED line content)
- Voice ID
- Audio settings

**What stays local:**
- Full transcripts
- Skill configurations
- User preferences
- Context files

**Audio Storage:**
- Temporary files only (/tmp)
- Auto-deleted after playback
- No persistent audio storage
- No logging of audio content

### Rate Limiting

**Server-side limits:**
- 10 requests per minute per IP
- Prevents abuse
- Configurable in server.ts

**ElevenLabs limits:**
- Per plan (see Performance section)
- Character count based
- Monthly reset

---

## Summary

**The Voice System provides:**
- ✅ 10 unique voices (Specialized AI Assistants)
- ✅ Skill-based voice selection
- ✅ Bilingual support (English/Swedish)
- ✅ High-quality neural TTS (ElevenLabs)
- ✅ Automatic integration via hooks
- ✅ Gender-balanced team (5M/5F)
- ✅ Accent diversity (British/Swedish/American/Neutral)
- ✅ Professional voice quality
- ✅ Simple HTTP API
- ⚠️ Requires ElevenLabs account and API key
- ⚠️ Subject to usage limits and pricing
- ⚠️ macOS only (afplay dependency)

**Voice makes Ogmios feel more alive and engaging!**

---

## References

- **ElevenLabs**: https://elevenlabs.io
- **ElevenLabs API Docs**: https://docs.elevenlabs.io
- **Bun Runtime**: https://bun.sh
- **Specialized AI Assistants Details**: [BRITISH-AI-TEAM.md](BRITISH-AI-TEAM.md)

---

**Document Version:** 1.0.0
**Last Updated:** 2025-11-09
**License:** MIT

**Questions?** See [troubleshooting guide](../docs/01-getting-started/troubleshooting.md) or [FAQ](../docs/08-faq/faq.md)
