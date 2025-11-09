# Voice Server Quick Start Guide

**Get the Ogmios voice server running in 5 minutes!**

---

## 🚀 Installation (One-Time Setup)

### Step 1: Get ElevenLabs API Key

1. Go to [elevenlabs.io](https://elevenlabs.io) and sign up (free tier available)
2. Navigate to [Settings → API Keys](https://elevenlabs.io/app/settings/api-keys)
3. Copy your API key

### Step 2: Configure Environment

```bash
cd /path/to/claudeogmios/voice-server

# Copy environment template
cp .env.example .env

# Edit .env and add your API key
nano .env  # or use your preferred editor
```

Replace `your_api_key_here` with your actual ElevenLabs API key.

### Step 3: Install Dependencies

```bash
# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate  # macOS/Linux
# OR
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt
```

---

## ▶️ Running the Server

### Simple Start (Recommended for Testing)

```bash
./start.sh
```

### Background Mode

```bash
./start.sh --background
```

### Production Mode (Gunicorn)

```bash
./start.sh --prod
```

### Manual Start

```bash
source venv/bin/activate
python server.py
```

---

## 🧪 Testing

### 1. Check if server is running:

```bash
curl http://localhost:8888/health
```

Expected: `{"status": "healthy", ...}`

### 2. Test voice output:

```bash
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Voice server is working",
    "voice_enabled": true
  }'
```

You should hear "Voice server is working" spoken through your speakers!

### 3. List available voices:

```bash
curl http://localhost:8888/voices
```

---

## 🛑 Stopping the Server

### If started with `./start.sh --background`:

```bash
./stop.sh
```

### If started manually (foreground):

Press `Ctrl+C`

---

## 🔗 Integration with Claude Hooks

The voice server is designed to work with the `stop-voice.ts` hook.

**Set these environment variables in your shell:**

```bash
export VOICE_ENABLED=true
export VOICE_SERVER_URL=http://localhost:8888
export VOICE_RATE=260
```

**Add to your shell profile** (~/.zshrc or ~/.bashrc):

```bash
echo 'export VOICE_ENABLED=true' >> ~/.zshrc
echo 'export VOICE_SERVER_URL=http://localhost:8888' >> ~/.zshrc
echo 'export VOICE_RATE=260' >> ~/.zshrc
source ~/.zshrc
```

---

## 🎨 Customizing Voices

### Option 1: Use Default Voice

No configuration needed - works out of the box!

### Option 2: Configure Custom Voices

```bash
# Copy voice configuration template
cp voices.json.example voices.json

# Edit to add your voice IDs
nano voices.json
```

**Get Voice IDs:**
1. Go to [ElevenLabs Voice Library](https://elevenlabs.io/app/voice-library)
2. Select or create a voice
3. Copy the voice ID from voice settings
4. Add to `voices.json`

---

## 🐛 Common Issues

### "ELEVENLABS_API_KEY not configured"

**Fix:** Add your API key to `.env` file

### "Port 8888 already in use"

**Fix:** Change PORT in `.env` or stop other process:
```bash
lsof -i :8888  # Find process
kill -9 <PID>  # Kill it
```

### No audio playing

**Fix:** Check system volume and audio output device

### Voice quality issues

**Fix:** Adjust voice settings in `.env`:
- Increase `DEFAULT_STABILITY` for more consistent voice
- Increase `DEFAULT_SIMILARITY_BOOST` for better voice accuracy

---

## 📊 Monitoring

### View logs:

```bash
tail -f voice-server.log
```

### Check server status:

```bash
curl http://localhost:8888/health
```

---

## 🎯 Next Steps

1. ✅ Get server running
2. ✅ Test with curl commands
3. ✅ Integrate with Claude hooks
4. 📖 Read full [README.md](README.md) for advanced features
5. 🎨 Configure custom voices for different skills
6. 🚀 Deploy to production with systemd or Docker

---

## 💡 Pro Tips

- **Use background mode** for always-on voice server
- **Set up systemd** on Linux for auto-start on boot
- **Test different voices** to find ones you like
- **Adjust voice settings** for optimal quality
- **Monitor your ElevenLabs quota** to avoid overages

---

**Need help?** See full documentation in [README.md](README.md)

**Built for Ogmios** 🚀
