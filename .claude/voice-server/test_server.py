#!/usr/bin/env python3
"""
Voice Server Test Suite
========================

Comprehensive tests for the Ogmios voice server.

Usage:
    python test_server.py
    pytest test_server.py -v
    pytest test_server.py --cov=server
"""

import pytest
import json
import os
from unittest.mock import Mock, patch, MagicMock
from server import app, synthesize_speech, play_audio_file, get_audio_player

# ============================================================================
# FIXTURES
# ============================================================================

@pytest.fixture
def client():
    """Create test client for Flask app."""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

@pytest.fixture
def mock_env(monkeypatch):
    """Mock environment variables."""
    monkeypatch.setenv('ELEVENLABS_API_KEY', 'test_api_key_12345')
    monkeypatch.setenv('PORT', '8888')
    monkeypatch.setenv('DEBUG', 'false')

# ============================================================================
# HEALTH CHECK TESTS
# ============================================================================

def test_health_check(client, mock_env):
    """Test health check endpoint."""
    response = client.get('/health')
    assert response.status_code == 200

    data = json.loads(response.data)
    assert data['status'] == 'healthy'
    assert 'version' in data
    assert 'audio_player' in data
    assert 'platform' in data

def test_health_check_shows_api_key_status(client, mock_env):
    """Test that health check shows API key configuration status."""
    response = client.get('/health')
    data = json.loads(response.data)
    assert 'elevenlabs_configured' in data
    assert data['elevenlabs_configured'] == True

# ============================================================================
# NOTIFY ENDPOINT TESTS
# ============================================================================

def test_notify_missing_json(client):
    """Test /notify with no JSON data."""
    response = client.post('/notify')
    assert response.status_code == 400
    data = json.loads(response.data)
    assert 'error' in data

def test_notify_missing_message(client):
    """Test /notify with missing message field."""
    response = client.post(
        '/notify',
        data=json.dumps({'voice_enabled': True}),
        content_type='application/json'
    )
    assert response.status_code == 400
    data = json.loads(response.data)
    assert 'error' in data
    assert 'message' in data['error']

def test_notify_voice_disabled(client):
    """Test /notify with voice disabled."""
    response = client.post(
        '/notify',
        data=json.dumps({
            'message': 'Test message',
            'voice_enabled': False
        }),
        content_type='application/json'
    )
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'skipped'
    assert data['reason'] == 'voice_disabled'

@patch('server.synthesize_speech')
@patch('server.play_audio_file')
def test_notify_success(mock_play, mock_synthesize, client, mock_env):
    """Test successful /notify request."""
    # Mock speech synthesis
    mock_synthesize.return_value = b'fake_audio_data'
    mock_play.return_value = True

    response = client.post(
        '/notify',
        data=json.dumps({
            'message': 'Test message',
            'voice_enabled': True,
            'voice_id': 'test_voice_id'
        }),
        content_type='application/json'
    )

    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'success'
    assert 'voice_id' in data
    assert 'text_length' in data

@patch('server.synthesize_speech')
def test_notify_synthesis_failure(mock_synthesize, client, mock_env):
    """Test /notify when speech synthesis fails."""
    mock_synthesize.return_value = None

    response = client.post(
        '/notify',
        data=json.dumps({
            'message': 'Test message',
            'voice_enabled': True
        }),
        content_type='application/json'
    )

    assert response.status_code == 500
    data = json.loads(response.data)
    assert 'error' in data

# ============================================================================
# SPEAK ENDPOINT TESTS
# ============================================================================

def test_speak_missing_json(client):
    """Test /speak with no JSON data."""
    response = client.post('/speak')
    assert response.status_code == 400

def test_speak_missing_text(client):
    """Test /speak with missing text field."""
    response = client.post(
        '/speak',
        data=json.dumps({'voice_id': 'test'}),
        content_type='application/json'
    )
    assert response.status_code == 400

# ============================================================================
# VOICES ENDPOINT TESTS
# ============================================================================

@patch('server.requests.get')
def test_list_voices_success(mock_get, client, mock_env):
    """Test successful voice listing."""
    mock_response = Mock()
    mock_response.status_code = 200
    mock_response.json.return_value = {
        'voices': [
            {'voice_id': 'voice1', 'name': 'Voice 1'},
            {'voice_id': 'voice2', 'name': 'Voice 2'}
        ]
    }
    mock_get.return_value = mock_response

    response = client.get('/voices')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert 'voices' in data

def test_list_voices_no_api_key(client, monkeypatch):
    """Test voice listing without API key."""
    monkeypatch.delenv('ELEVENLABS_API_KEY', raising=False)

    response = client.get('/voices')
    assert response.status_code == 500

# ============================================================================
# SYNTHESIS FUNCTION TESTS
# ============================================================================

@patch('server.requests.post')
def test_synthesize_speech_success(mock_post):
    """Test successful speech synthesis."""
    mock_response = Mock()
    mock_response.status_code = 200
    mock_response.content = b'audio_data'
    mock_post.return_value = mock_response

    with patch.dict(os.environ, {'ELEVENLABS_API_KEY': 'test_key'}):
        result = synthesize_speech('Test text', 'test_voice_id')
        assert result == b'audio_data'

@patch('server.requests.post')
def test_synthesize_speech_api_error(mock_post):
    """Test speech synthesis with API error."""
    mock_response = Mock()
    mock_response.status_code = 401
    mock_response.text = 'Unauthorized'
    mock_post.return_value = mock_response

    with patch.dict(os.environ, {'ELEVENLABS_API_KEY': 'test_key'}):
        result = synthesize_speech('Test text', 'test_voice_id')
        assert result is None

def test_synthesize_speech_no_api_key():
    """Test speech synthesis without API key."""
    with patch.dict(os.environ, {}, clear=True):
        result = synthesize_speech('Test text', 'test_voice_id')
        assert result is None

# ============================================================================
# AUDIO PLAYER TESTS
# ============================================================================

def test_get_audio_player():
    """Test audio player detection."""
    player_name, command = get_audio_player()
    assert player_name is not None
    assert isinstance(command, list)
    assert len(command) > 0

@patch('server.subprocess.Popen')
def test_play_audio_file_success(mock_popen):
    """Test successful audio playback."""
    mock_process = Mock()
    mock_process.wait.return_value = None
    mock_process.returncode = 0
    mock_popen.return_value = mock_process

    result = play_audio_file('/tmp/test.mp3')
    assert result == True

@patch('server.subprocess.Popen')
def test_play_audio_file_failure(mock_popen):
    """Test failed audio playback."""
    mock_popen.side_effect = Exception('Playback failed')

    result = play_audio_file('/tmp/test.mp3')
    assert result == False

# ============================================================================
# ERROR HANDLER TESTS
# ============================================================================

def test_404_handler(client):
    """Test 404 error handler."""
    response = client.get('/nonexistent-endpoint')
    assert response.status_code == 404
    data = json.loads(response.data)
    assert 'error' in data

# ============================================================================
# INTEGRATION TESTS
# ============================================================================

@patch('server.synthesize_speech')
@patch('server.play_audio_file')
def test_full_voice_notification_flow(mock_play, mock_synthesize, client, mock_env):
    """Test complete voice notification workflow."""
    mock_synthesize.return_value = b'audio_data'
    mock_play.return_value = True

    # Send notification
    response = client.post(
        '/notify',
        data=json.dumps({
            'message': 'Task completed successfully',
            'voice_id': 'test_voice',
            'voice_enabled': True,
            'stability': 0.6,
            'similarity_boost': 0.8
        }),
        content_type='application/json'
    )

    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'success'

    # Verify synthesis was called with correct parameters
    mock_synthesize.assert_called_once()
    call_args = mock_synthesize.call_args
    assert call_args[0][0] == 'Task completed successfully'
    assert call_args[0][1] == 'test_voice'
    assert call_args[1]['stability'] == 0.6
    assert call_args[1]['similarity_boost'] == 0.8

    # Verify playback was attempted
    mock_play.assert_called_once()

# ============================================================================
# RUN TESTS
# ============================================================================

if __name__ == '__main__':
    pytest.main([__file__, '-v', '--cov=server', '--cov-report=term-missing'])
