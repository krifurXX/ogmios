# Ogmios Voice Server

**Production-ready Flask server for ElevenLabs text-to-speech integration**

Part of the Ogmios Personal AI Infrastructure (PAI) system, providing high-quality voice feedback for AI assistant responses.

---

## 🎯 Overview

The Ogmios Voice Server integrates with ElevenLabs API to provide natural, high-quality voice feedback for your AI assistant. When Claude completes a task, the voice server automatically speaks the completion message using configured voice profiles.

**Architecture:**
```
Hook (stop-voice.ts) → POST /notify → ElevenLabs API → Audio Player → 🔊
```

**Key Features:**
- 🎙️ ElevenLabs API integration for premium voice quality
- 🔊 Automatic audio playback (macOS, Linux, Windows)
- 🎛️ Configurable voice settings per skill/agent
- 🌍 CORS support for local development
- 🛡️ Comprehensive error handling and logging
- 📊 Health check endpoint for monitoring
- 🎨 Multiple voice profiles (agents, skills, languages)

---

## 📋 Table of Contents

- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [API Reference](#-api-reference)
- [Voice Configuration](#-voice-configuration)
- [Integration](#-integration)
- [Troubleshooting](#-troubleshooting)
- [Development](#-development)

---

## 🚀 Installation

### Prerequisites

- **Python 3.8+** (recommended: 3.11)
- **pip** or **uv** (package manager)
- **ElevenLabs API key** (get from [elevenlabs.io](https://elevenlabs.io))
- **Audio player** (pre-installed on macOS/Linux/Windows)

### Quick Start

1. **Navigate to voice-server directory:**
   ```bash
   cd /path/to/claudeogmios/voice-server
   ```

2. **Create virtual environment (recommended):**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

   Or with uv (faster):
   ```bash
   uv pip install -r requirements.txt
   ```

4. **Configure environment:**
   ```bash
   cp .env.example .env
   nano .env  # Edit with your API key
   ```

5. **Start the server:**
   ```bash
   python server.py
   ```

The server will start on `http://localhost:8888` by default.

---

## ⚙️ Configuration

### Getting Your ElevenLabs API Key

1. **Sign up for ElevenLabs:**
   - Go to [elevenlabs.io](https://elevenlabs.io)
   - Create a free account (10,000 characters/month free tier)

2. **Get your API key:**
   - Navigate to [Settings → API Keys](https://elevenlabs.io/app/settings/api-keys)
   - Click "Generate API Key" or copy existing key
   - Copy the key (starts with `xi-...` or similar)

3. **Add to .env file:**
   ```bash
   ELEVENLABS_API_KEY=your_actual_api_key_here
   ```

### Environment Variables

Edit `.env` file with your settings:

```bash
# REQUIRED: Your ElevenLabs API key
ELEVENLABS_API_KEY=your_api_key_here

# Server configuration
PORT=8888                    # Port to run server on
HOST=0.0.0.0                # Bind to all interfaces (use 127.0.0.1 for localhost only)
DEBUG=false                 # Enable debug mode (set to true for development)

# Voice settings (optional fine-tuning)
DEFAULT_VOICE_ID=EXAVITQu4vr4xnSDxMaL  # Default voice if not specified
DEFAULT_STABILITY=0.5                   # Voice stability (0.0-1.0)
DEFAULT_SIMILARITY_BOOST=0.75           # Voice similarity (0.0-1.0)
DEFAULT_STYLE=0.0                       # Style intensity (0.0-1.0)
DEFAULT_USE_SPEAKER_BOOST=true          # Speaker boost (true/false)

# Logging
LOG_LEVEL=INFO              # Logging level (DEBUG, INFO, WARNING, ERROR)
LOG_FILE=voice-server.log   # Log file path
```

### Voice Configuration

**Option 1: Simple (Use defaults)**
- Server works out-of-box with default voice
- Voice ID can be passed in each request

**Option 2: Advanced (Custom voices.json)**
```bash
cp voices.json.example voices.json
```

Edit `voices.json` to map skills/agents to voice IDs:
```json
{
  "voices": {
    "engineering": {
      "id": "your_voice_id_here",
      "name": "George Foster",
      "settings": {
        "stability": 0.6,
        "similarity_boost": 0.8
      }
    }
  }
}
```

**Finding Voice IDs:**
1. Go to [ElevenLabs Voice Library](https://elevenlabs.io/app/voice-library)
2. Select a voice or create your own
3. Copy the voice ID from voice settings
4. Add to `voices.json`

**Popular Pre-made Voices:**
- Rachel: `21m00Tcm4TlvDq8ikWAM` (Young American female)
- Antoni: `ErXwobaYiN019PkySvjV` (Young American male)
- Bella: `EXAVITQu4vr4xnSDxMaL` (Young American female)
- Josh: `TxGEqnHWrfWFTfGW9XjX` (Young American male)

---

## 🎮 Usage

### Starting the Server

**Development mode:**
```bash
python server.py
```

**Production mode (with gunicorn):**
```bash
gunicorn -w 4 -b 0.0.0.0:8888 server:app
```

**Background mode (daemonized):**
```bash
nohup python server.py > voice-server.log 2>&1 &
```

**With systemd (Linux):**
```bash
sudo systemctl start ogmios-voice
sudo systemctl enable ogmios-voice  # Auto-start on boot
```

### Testing the Server

**1. Health check:**
```bash
curl http://localhost:8888/health
```

Expected response:
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "elevenlabs_configured": true,
  "audio_player": "afplay",
  "platform": "Darwin"
}
```

**2. Test voice notification:**
```bash
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Voice server is working correctly",
    "voice_enabled": true
  }'
```

You should hear the message spoken through your speakers.

**3. Test with specific voice:**
```bash
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Testing custom voice",
    "voice_id": "21m00Tcm4TlvDq8ikWAM",
    "voice_enabled": true
  }'
```

**4. List available voices:**
```bash
curl http://localhost:8888/voices
```

---

## 📡 API Reference

### Endpoints

#### `GET /health`
Health check endpoint for monitoring server status.

**Response:**
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "elevenlabs_configured": true,
  "audio_player": "afplay",
  "platform": "Darwin"
}
```

---

#### `POST /notify`
Main endpoint for voice notifications (used by stop-voice.ts hook).

**Request:**
```json
{
  "message": "Text to speak",
  "voice_id": "ElevenLabs voice ID (optional)",
  "voice_enabled": true,
  "rate": 260,
  "stability": 0.5,
  "similarity_boost": 0.75,
  "style": 0.0,
  "use_speaker_boost": true
}
```

**Parameters:**
- `message` (required): Text to synthesize and speak
- `voice_id` (optional): ElevenLabs voice ID (defaults to DEFAULT_VOICE_ID)
- `voice_enabled` (optional): Enable/disable voice (default: true)
- `rate` (optional): Speech rate (not used by ElevenLabs, for compatibility)
- `stability` (optional): Voice stability 0.0-1.0 (default: 0.5)
- `similarity_boost` (optional): Similarity boost 0.0-1.0 (default: 0.75)
- `style` (optional): Style intensity 0.0-1.0 (default: 0.0)
- `use_speaker_boost` (optional): Enable speaker boost (default: true)

**Response (Success):**
```json
{
  "status": "success",
  "message": "Voice notification played",
  "voice_id": "EXAVITQu4vr4xnSDxMaL",
  "text_length": 42
}
```

**Response (Voice Disabled):**
```json
{
  "status": "skipped",
  "reason": "voice_disabled"
}
```

**Response (Error):**
```json
{
  "error": "Speech synthesis failed"
}
```

---

#### `POST /speak`
Simplified endpoint with minimal parameters.

**Request:**
```json
{
  "text": "Text to speak",
  "voice_id": "voice_id_optional"
}
```

**Response:** Same as `/notify`

---

#### `GET /voices`
List all available ElevenLabs voices from your account.

**Response:**
```json
{
  "voices": [
    {
      "voice_id": "21m00Tcm4TlvDq8ikWAM",
      "name": "Rachel",
      "category": "premade",
      "labels": {
        "accent": "american",
        "age": "young",
        "gender": "female"
      }
    }
  ]
}
```

---

## 🎨 Voice Configuration

### Voice Settings Explained

**Stability (0.0 - 1.0):**
- **Low (0.0-0.3)**: More variable, expressive, emotional
- **Medium (0.4-0.6)**: Balanced, natural (recommended)
- **High (0.7-1.0)**: Consistent, stable, less variation

**Similarity Boost (0.0 - 1.0):**
- **Low (0.0-0.3)**: More creative interpretation
- **Medium (0.4-0.7)**: Balanced similarity
- **High (0.8-1.0)**: Very close to original voice (recommended)

**Style (0.0 - 1.0):**
- **0.0**: Neutral delivery
- **0.5**: Moderate style
- **1.0**: Exaggerated style (only works with certain voices)

**Use Speaker Boost:**
- **true**: Enhanced clarity and presence (recommended)
- **false**: Natural voice without enhancement

### Recommended Settings

**For technical/professional content:**
```json
{
  "stability": 0.6,
  "similarity_boost": 0.8,
  "style": 0.0,
  "use_speaker_boost": true
}
```

**For casual/conversational content:**
```json
{
  "stability": 0.4,
  "similarity_boost": 0.7,
  "style": 0.3,
  "use_speaker_boost": true
}
```

**For narrative/storytelling:**
```json
{
  "stability": 0.3,
  "similarity_boost": 0.6,
  "style": 0.5,
  "use_speaker_boost": true
}
```

---

## 🔗 Integration

### Integration with stop-voice.ts Hook

The voice server is designed to work with the `stop-voice.ts` hook located at:
```
~/.claude/.claude/hooks/stop-voice.ts
```

**Hook workflow:**
1. Claude generates response with `COMPLETED` tag
2. Hook extracts completion message
3. Hook determines voice ID (from agent tag or skill)
4. Hook calls voice server `/notify` endpoint
5. Server synthesizes speech via ElevenLabs
6. Server plays audio through system audio player

**Required environment variables (for hook):**
```bash
export VOICE_ENABLED=true
export VOICE_SERVER_URL=http://localhost:8888
export VOICE_RATE=260
```

**Example COMPLETED tag (in Claude response):**
```
🎯 COMPLETED: [AGENT:engineer] User authentication system implemented
🗣️ CUSTOM COMPLETED: Auth complete
```

### Manual Integration (from other scripts)

```bash
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Task completed successfully",
    "voice_id": "21m00Tcm4TlvDq8ikWAM",
    "voice_enabled": true
  }'
```

**Python example:**
```python
import requests

response = requests.post(
    'http://localhost:8888/notify',
    json={
        'message': 'Task completed successfully',
        'voice_id': '21m00Tcm4TlvDq8ikWAM',
        'voice_enabled': True
    }
)
print(response.json())
```

**TypeScript example:**
```typescript
const response = await fetch('http://localhost:8888/notify', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    message: 'Task completed successfully',
    voice_id: '21m00Tcm4TlvDq8ikWAM',
    voice_enabled: true
  })
});
```

---

## 🔧 Troubleshooting

### Server Won't Start

**Issue: "ELEVENLABS_API_KEY not configured"**
- ✅ Solution: Add your API key to `.env` file
- ✅ Verify: `cat .env | grep ELEVENLABS_API_KEY`

**Issue: "Port 8888 already in use"**
- ✅ Solution: Change PORT in `.env` or kill existing process
- ✅ Check: `lsof -i :8888` (macOS/Linux) or `netstat -ano | findstr :8888` (Windows)
- ✅ Kill: `kill -9 <PID>`

**Issue: "Module not found"**
- ✅ Solution: Install dependencies: `pip install -r requirements.txt`
- ✅ Verify: `pip list | grep Flask`

### Voice Not Playing

**Issue: API call succeeds but no audio**
- ✅ Check audio player availability:
  - macOS: `which afplay` should return path
  - Linux: `which aplay` should return path
  - Windows: PowerShell should be available
- ✅ Check system volume is not muted
- ✅ Check logs: `tail -f voice-server.log`

**Issue: "Speech synthesis failed"**
- ✅ Verify API key is correct
- ✅ Check ElevenLabs quota: [Usage Dashboard](https://elevenlabs.io/app/usage)
- ✅ Verify voice ID is valid (use `/voices` endpoint)
- ✅ Check network connectivity to ElevenLabs API

**Issue: Wrong voice playing**
- ✅ Verify `voice_id` in request matches desired voice
- ✅ Check `voices.json` configuration
- ✅ Use `/voices` endpoint to list available voices

### ElevenLabs API Errors

**Issue: 401 Unauthorized**
- ✅ API key is invalid or expired
- ✅ Regenerate key at [ElevenLabs Settings](https://elevenlabs.io/app/settings/api-keys)

**Issue: 429 Too Many Requests**
- ✅ Rate limit exceeded
- ✅ Wait before retrying
- ✅ Consider upgrading plan

**Issue: 402 Payment Required**
- ✅ Quota exceeded (free tier: 10k chars/month)
- ✅ Upgrade plan or wait for reset

### Integration Issues

**Issue: Hook not triggering voice**
- ✅ Verify server is running: `curl http://localhost:8888/health`
- ✅ Check `VOICE_ENABLED=true` in environment
- ✅ Verify `COMPLETED` tag is present in Claude response
- ✅ Check hook logs for errors

**Issue: Timeout errors**
- ✅ Increase timeout in hook (default: 5 seconds)
- ✅ Check network latency to ElevenLabs
- ✅ Verify server is responsive

### Debugging

**Enable debug mode:**
```bash
# In .env
DEBUG=true
LOG_LEVEL=DEBUG
```

**View logs:**
```bash
tail -f voice-server.log
```

**Test ElevenLabs API directly:**
```bash
curl -X POST "https://api.elevenlabs.io/v1/text-to-speech/21m00Tcm4TlvDq8ikWAM" \
  -H "xi-api-key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Test",
    "model_id": "eleven_monolingual_v1"
  }' \
  --output test.mp3
```

---

## 👨‍💻 Development

### Running Tests

```bash
# Install dev dependencies
pip install pytest pytest-cov

# Run tests
pytest

# Run with coverage
pytest --cov=server --cov-report=html
```

### Code Quality

```bash
# Format code
black server.py

# Lint code
flake8 server.py

# Type checking
mypy server.py
```

### Project Structure

```
voice-server/
├── server.py              # Main Flask application
├── requirements.txt       # Python dependencies
├── .env.example          # Environment configuration template
├── .env                  # Your actual configuration (gitignored)
├── voices.json.example   # Voice mapping template
├── voices.json           # Your voice configuration (optional)
├── README.md             # This file
├── voice-server.log      # Server logs (auto-created)
└── venv/                 # Virtual environment (create with python -m venv venv)
```

### Production Deployment

**Using Gunicorn (recommended):**
```bash
gunicorn -w 4 -b 0.0.0.0:8888 --timeout 30 server:app
```

**Using systemd (Linux):**

Create `/etc/systemd/system/ogmios-voice.service`:
```ini
[Unit]
Description=Ogmios Voice Server
After=network.target

[Service]
Type=simple
User=yourusername
WorkingDirectory=/path/to/voice-server
Environment="PATH=/path/to/venv/bin"
ExecStart=/path/to/venv/bin/gunicorn -w 4 -b 0.0.0.0:8888 server:app
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable ogmios-voice
sudo systemctl start ogmios-voice
```

**Using Docker:**
```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 8888
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8888", "server:app"]
```

---

## 📄 License

MIT License - Part of the Ogmios Personal AI Infrastructure

---

## 🙏 Acknowledgments

- **ElevenLabs**: Premium voice synthesis API
- **Daniel Miessler**: Kai system architecture inspiration
- **Flask**: Micro web framework
- **Ogmios Development Team**: Voice system implementation

---

## 📚 Additional Resources

- [ElevenLabs Documentation](https://elevenlabs.io/docs)
- [ElevenLabs Voice Library](https://elevenlabs.io/app/voice-library)
- [Ogmios Documentation](../documentation/)
- [Flask Documentation](https://flask.palletsprojects.com/)

---

**Built with ❤️ for the Ogmios Personal AI Infrastructure**

*"System > Model" - Building intelligent infrastructure, one voice at a time.*
