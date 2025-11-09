#!/usr/bin/env python3
"""
OGMIOS VOICE SERVER
===================

Production-ready Flask server for ElevenLabs text-to-speech integration.

Features:
- ElevenLabs API integration for high-quality voice synthesis
- Automatic audio playback on macOS (afplay), Linux (aplay), Windows (powershell)
- Configurable voice settings (stability, similarity, rate)
- CORS support for local development
- Comprehensive error handling and logging
- Health check endpoint for monitoring
- Voice configuration management

Architecture:
    Hook (stop-voice.ts) → POST /notify → ElevenLabs API → Audio Player

Author: Ogmios Development Team
License: MIT
"""

import os
import sys
import logging
import tempfile
import subprocess
import platform
from typing import Dict, Optional, Tuple
from pathlib import Path

from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# ============================================================================
# CONFIGURATION
# ============================================================================

# Server configuration
PORT = int(os.getenv('PORT', 8888))
HOST = os.getenv('HOST', '0.0.0.0')
DEBUG = os.getenv('DEBUG', 'false').lower() == 'true'

# ElevenLabs API configuration
ELEVENLABS_API_KEY = os.getenv('ELEVENLABS_API_KEY')
ELEVENLABS_API_URL = 'https://api.elevenlabs.io/v1/text-to-speech'

# Voice settings (can be overridden per request)
DEFAULT_STABILITY = float(os.getenv('DEFAULT_STABILITY', '0.5'))
DEFAULT_SIMILARITY_BOOST = float(os.getenv('DEFAULT_SIMILARITY_BOOST', '0.75'))
DEFAULT_STYLE = float(os.getenv('DEFAULT_STYLE', '0.0'))
DEFAULT_USE_SPEAKER_BOOST = os.getenv('DEFAULT_USE_SPEAKER_BOOST', 'true').lower() == 'true'

# Audio settings
AUDIO_FORMAT = os.getenv('AUDIO_FORMAT', 'mp3_44100_128')  # High quality MP3
DEFAULT_VOICE_ID = os.getenv('DEFAULT_VOICE_ID', 'EXAVITQu4vr4xnSDxMaL')  # Bella

# Logging
LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')
LOG_FILE = os.getenv('LOG_FILE', 'voice-server.log')

# ============================================================================
# LOGGING SETUP
# ============================================================================

logging.basicConfig(
    level=getattr(logging, LOG_LEVEL),
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler(sys.stdout)
    ]
)

logger = logging.getLogger('voice-server')

# ============================================================================
# FLASK APP SETUP
# ============================================================================

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# ============================================================================
# AUDIO PLAYBACK UTILITIES
# ============================================================================

def get_audio_player() -> Tuple[str, list]:
    """
    Detect the appropriate audio player for the current platform.

    Returns:
        Tuple of (player_name, base_command)
    """
    system = platform.system()

    if system == 'Darwin':  # macOS
        return 'afplay', ['afplay']
    elif system == 'Linux':
        # Try to find available players
        for player in ['aplay', 'paplay', 'ffplay']:
            try:
                subprocess.run(['which', player], check=True, capture_output=True)
                return player, [player]
            except subprocess.CalledProcessError:
                continue
        return 'aplay', ['aplay']  # Default to aplay
    elif system == 'Windows':
        return 'powershell', ['powershell', '-c', '(New-Object Media.SoundPlayer']
    else:
        logger.warning(f"Unsupported platform: {system}, defaulting to afplay")
        return 'afplay', ['afplay']

def play_audio_file(file_path: str) -> bool:
    """
    Play an audio file using the system's audio player.

    Args:
        file_path: Path to the audio file

    Returns:
        True if playback succeeded, False otherwise
    """
    try:
        player_name, base_command = get_audio_player()

        if platform.system() == 'Windows':
            # Special handling for Windows
            command = base_command + [f"'{file_path}').PlaySync()"]
        else:
            command = base_command + [file_path]

        logger.info(f"Playing audio with {player_name}: {file_path}")

        # Run player in background to avoid blocking
        process = subprocess.Popen(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )

        # Wait for completion (with timeout)
        try:
            process.wait(timeout=30)  # Max 30 seconds per audio file
            return process.returncode == 0
        except subprocess.TimeoutExpired:
            logger.error("Audio playback timed out")
            process.kill()
            return False

    except Exception as e:
        logger.error(f"Failed to play audio: {str(e)}")
        return False

# ============================================================================
# ELEVENLABS API INTEGRATION
# ============================================================================

def synthesize_speech(
    text: str,
    voice_id: str,
    stability: Optional[float] = None,
    similarity_boost: Optional[float] = None,
    style: Optional[float] = None,
    use_speaker_boost: Optional[bool] = None
) -> Optional[bytes]:
    """
    Synthesize speech using ElevenLabs API.

    Args:
        text: Text to synthesize
        voice_id: ElevenLabs voice ID
        stability: Voice stability (0.0-1.0)
        similarity_boost: Voice similarity boost (0.0-1.0)
        style: Voice style intensity (0.0-1.0)
        use_speaker_boost: Enable speaker boost

    Returns:
        Audio data as bytes, or None if failed
    """
    if not ELEVENLABS_API_KEY:
        logger.error("ELEVENLABS_API_KEY not configured")
        return None

    # Use defaults if not specified
    stability = stability if stability is not None else DEFAULT_STABILITY
    similarity_boost = similarity_boost if similarity_boost is not None else DEFAULT_SIMILARITY_BOOST
    style = style if style is not None else DEFAULT_STYLE
    use_speaker_boost = use_speaker_boost if use_speaker_boost is not None else DEFAULT_USE_SPEAKER_BOOST

    # Build request URL and headers
    url = f"{ELEVENLABS_API_URL}/{voice_id}"
    headers = {
        "Accept": "audio/mpeg",
        "Content-Type": "application/json",
        "xi-api-key": ELEVENLABS_API_KEY
    }

    # Build request payload
    payload = {
        "text": text,
        "model_id": "eleven_monolingual_v1",
        "voice_settings": {
            "stability": stability,
            "similarity_boost": similarity_boost,
            "style": style,
            "use_speaker_boost": use_speaker_boost
        }
    }

    try:
        logger.info(f"Synthesizing speech: '{text[:50]}...' (voice: {voice_id})")

        response = requests.post(
            url,
            json=payload,
            headers=headers,
            timeout=30
        )

        if response.status_code == 200:
            logger.info(f"Speech synthesis successful ({len(response.content)} bytes)")
            return response.content
        else:
            logger.error(f"ElevenLabs API error: {response.status_code} - {response.text}")
            return None

    except requests.RequestException as e:
        logger.error(f"Failed to call ElevenLabs API: {str(e)}")
        return None

# ============================================================================
# FLASK ROUTES
# ============================================================================

@app.route('/health', methods=['GET'])
def health_check():
    """
    Health check endpoint for monitoring.

    Returns:
        JSON response with server status
    """
    status = {
        'status': 'healthy',
        'version': '1.0.0',
        'elevenlabs_configured': bool(ELEVENLABS_API_KEY),
        'audio_player': get_audio_player()[0],
        'platform': platform.system()
    }

    return jsonify(status), 200

@app.route('/notify', methods=['POST'])
def notify():
    """
    Main endpoint for voice notifications.

    Expected JSON payload:
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

    Returns:
        JSON response with success/error status
    """
    try:
        # Parse request data
        data = request.get_json()

        if not data:
            return jsonify({'error': 'No JSON data provided'}), 400

        # Extract parameters
        message = data.get('message')
        voice_enabled = data.get('voice_enabled', True)
        voice_id = data.get('voice_id', DEFAULT_VOICE_ID)

        # Voice settings (optional overrides)
        stability = data.get('stability')
        similarity_boost = data.get('similarity_boost')
        style = data.get('style')
        use_speaker_boost = data.get('use_speaker_boost')

        # Validate required fields
        if not message:
            return jsonify({'error': 'Missing required field: message'}), 400

        # Check if voice is enabled
        if not voice_enabled:
            logger.info("Voice feedback disabled in request")
            return jsonify({'status': 'skipped', 'reason': 'voice_disabled'}), 200

        # Log request
        logger.info(f"Voice notification request: '{message[:50]}...'")

        # Synthesize speech
        audio_data = synthesize_speech(
            text=message,
            voice_id=voice_id,
            stability=stability,
            similarity_boost=similarity_boost,
            style=style,
            use_speaker_boost=use_speaker_boost
        )

        if not audio_data:
            return jsonify({'error': 'Speech synthesis failed'}), 500

        # Save audio to temporary file
        with tempfile.NamedTemporaryFile(suffix='.mp3', delete=False) as temp_file:
            temp_file.write(audio_data)
            temp_path = temp_file.name

        # Play audio
        playback_success = play_audio_file(temp_path)

        # Clean up temporary file
        try:
            os.unlink(temp_path)
        except Exception as e:
            logger.warning(f"Failed to delete temp file: {str(e)}")

        if playback_success:
            return jsonify({
                'status': 'success',
                'message': 'Voice notification played',
                'voice_id': voice_id,
                'text_length': len(message)
            }), 200
        else:
            return jsonify({
                'status': 'partial_success',
                'message': 'Audio synthesized but playback failed',
                'voice_id': voice_id
            }), 200

    except Exception as e:
        logger.error(f"Error in /notify endpoint: {str(e)}", exc_info=True)
        return jsonify({'error': str(e)}), 500

@app.route('/speak', methods=['POST'])
def speak():
    """
    Alternative endpoint with simpler interface.

    Expected JSON payload:
        {
            "text": "Text to speak",
            "voice_id": "ElevenLabs voice ID (optional)"
        }

    Returns:
        JSON response with success/error status
    """
    try:
        data = request.get_json()

        if not data:
            return jsonify({'error': 'No JSON data provided'}), 400

        text = data.get('text')
        voice_id = data.get('voice_id', DEFAULT_VOICE_ID)

        if not text:
            return jsonify({'error': 'Missing required field: text'}), 400

        # Forward to notify endpoint
        return notify()

    except Exception as e:
        logger.error(f"Error in /speak endpoint: {str(e)}", exc_info=True)
        return jsonify({'error': str(e)}), 500

@app.route('/voices', methods=['GET'])
def list_voices():
    """
    List available ElevenLabs voices.

    Returns:
        JSON response with voice list or error
    """
    if not ELEVENLABS_API_KEY:
        return jsonify({'error': 'ELEVENLABS_API_KEY not configured'}), 500

    try:
        headers = {
            "xi-api-key": ELEVENLABS_API_KEY
        }

        response = requests.get(
            "https://api.elevenlabs.io/v1/voices",
            headers=headers,
            timeout=10
        )

        if response.status_code == 200:
            return jsonify(response.json()), 200
        else:
            return jsonify({'error': f'ElevenLabs API error: {response.status_code}'}), 500

    except Exception as e:
        logger.error(f"Failed to fetch voices: {str(e)}")
        return jsonify({'error': str(e)}), 500

# ============================================================================
# ERROR HANDLERS
# ============================================================================

@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors."""
    return jsonify({'error': 'Endpoint not found'}), 404

@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors."""
    logger.error(f"Internal server error: {str(error)}")
    return jsonify({'error': 'Internal server error'}), 500

# ============================================================================
# MAIN ENTRY POINT
# ============================================================================

def check_configuration():
    """
    Validate server configuration before starting.

    Returns:
        True if configuration is valid, False otherwise
    """
    errors = []

    if not ELEVENLABS_API_KEY:
        errors.append("ELEVENLABS_API_KEY environment variable not set")

    if errors:
        logger.error("Configuration errors:")
        for error in errors:
            logger.error(f"  - {error}")
        return False

    return True

def main():
    """Main entry point for the voice server."""
    logger.info("=" * 70)
    logger.info("OGMIOS VOICE SERVER")
    logger.info("=" * 70)
    logger.info(f"Version: 1.0.0")
    logger.info(f"Platform: {platform.system()}")
    logger.info(f"Audio Player: {get_audio_player()[0]}")
    logger.info(f"Port: {PORT}")
    logger.info(f"Debug: {DEBUG}")
    logger.info("=" * 70)

    # Check configuration
    if not check_configuration():
        logger.error("Server configuration invalid. Exiting.")
        sys.exit(1)

    logger.info("Configuration validated successfully")
    logger.info(f"Starting server on {HOST}:{PORT}...")

    # Start Flask server
    app.run(
        host=HOST,
        port=PORT,
        debug=DEBUG,
        threaded=True
    )

if __name__ == '__main__':
    main()
