#!/bin/bash
#
# Ogmios Voice Server - Example API Calls
# ========================================
#
# Collection of example curl commands for testing the voice server.
#
# Usage:
#   ./examples.sh                    # Show all examples
#   ./examples.sh health             # Run health check
#   ./examples.sh test               # Run test notification
#   ./examples.sh custom <voice_id>  # Test with custom voice
#

# Server URL
SERVER_URL="${VOICE_SERVER_URL:-http://localhost:8888}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Functions
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_command() {
    echo -e "${YELLOW}Command:${NC}"
    echo "$1"
    echo ""
}

run_example() {
    local name=$1
    local description=$2
    local command=$3

    print_header "$name"
    echo "$description"
    echo ""
    print_command "$command"

    if [ "$AUTO_RUN" = "true" ]; then
        echo "Running..."
        eval "$command"
        echo ""
    fi
}

# Parse arguments
if [ "$1" = "--run" ] || [ "$1" = "-r" ]; then
    AUTO_RUN="true"
    shift
fi

EXAMPLE="${1:-all}"

# Examples

if [ "$EXAMPLE" = "all" ] || [ "$EXAMPLE" = "health" ]; then
    run_example \
        "1. Health Check" \
        "Check if the voice server is running and properly configured." \
        "curl -s ${SERVER_URL}/health | jq ."
fi

if [ "$EXAMPLE" = "all" ] || [ "$EXAMPLE" = "test" ]; then
    run_example \
        "2. Basic Voice Test" \
        "Send a simple test message to verify voice output works." \
        "curl -X POST ${SERVER_URL}/notify \\
  -H 'Content-Type: application/json' \\
  -d '{
    \"message\": \"Voice server is working correctly\",
    \"voice_enabled\": true
  }'"
fi

if [ "$EXAMPLE" = "all" ] || [ "$EXAMPLE" = "custom" ]; then
    VOICE_ID="${2:-21m00Tcm4TlvDq8ikWAM}"
    run_example \
        "3. Custom Voice Test" \
        "Test with a specific ElevenLabs voice ID." \
        "curl -X POST ${SERVER_URL}/notify \\
  -H 'Content-Type: application/json' \\
  -d '{
    \"message\": \"Testing custom voice\",
    \"voice_id\": \"${VOICE_ID}\",
    \"voice_enabled\": true
  }'"
fi

if [ "$EXAMPLE" = "all" ] || [ "$EXAMPLE" = "settings" ]; then
    run_example \
        "4. Custom Voice Settings" \
        "Test with custom stability and similarity boost settings." \
        "curl -X POST ${SERVER_URL}/notify \\
  -H 'Content-Type: application/json' \\
  -d '{
    \"message\": \"Testing custom voice settings for optimal clarity\",
    \"voice_enabled\": true,
    \"stability\": 0.7,
    \"similarity_boost\": 0.9,
    \"use_speaker_boost\": true
  }'"
fi

if [ "$EXAMPLE" = "all" ] || [ "$EXAMPLE" = "speak" ]; then
    run_example \
        "5. Simple Speak Endpoint" \
        "Use the simplified /speak endpoint with minimal parameters." \
        "curl -X POST ${SERVER_URL}/speak \\
  -H 'Content-Type: application/json' \\
  -d '{
    \"text\": \"This is the simple speak endpoint\"
  }'"
fi

if [ "$EXAMPLE" = "all" ] || [ "$EXAMPLE" = "voices" ]; then
    run_example \
        "6. List Available Voices" \
        "Get a list of all voices available in your ElevenLabs account." \
        "curl -s ${SERVER_URL}/voices | jq '.voices[] | {name: .name, voice_id: .voice_id, labels: .labels}'"
fi

if [ "$EXAMPLE" = "all" ] || [ "$EXAMPLE" = "disabled" ]; then
    run_example \
        "7. Voice Disabled Test" \
        "Test what happens when voice is disabled (should skip synthesis)." \
        "curl -X POST ${SERVER_URL}/notify \\
  -H 'Content-Type: application/json' \\
  -d '{
    \"message\": \"This should not be spoken\",
    \"voice_enabled\": false
  }'"
fi

if [ "$EXAMPLE" = "all" ] || [ "$EXAMPLE" = "long" ]; then
    run_example \
        "8. Long Text Test" \
        "Test with longer text to verify handling of extended content." \
        "curl -X POST ${SERVER_URL}/notify \\
  -H 'Content-Type: application/json' \\
  -d '{
    \"message\": \"This is a longer test message to verify that the voice server can handle extended content without issues. The ElevenLabs API should synthesize this entire message and play it back through the system audio player.\",
    \"voice_enabled\": true
  }'"
fi

if [ "$EXAMPLE" = "all" ] || [ "$EXAMPLE" = "agent" ]; then
    run_example \
        "9. Agent Completion Simulation" \
        "Simulate a completion message from the engineer agent." \
        "curl -X POST ${SERVER_URL}/notify \\
  -H 'Content-Type: application/json' \\
  -d '{
    \"message\": \"User authentication system implemented successfully\",
    \"voice_enabled\": true,
    \"voice_id\": \"21m00Tcm4TlvDq8ikWAM\"
  }'"
fi

if [ "$EXAMPLE" = "all" ] || [ "$EXAMPLE" = "error" ]; then
    run_example \
        "10. Error Handling Test" \
        "Test error handling with invalid request (missing message)." \
        "curl -X POST ${SERVER_URL}/notify \\
  -H 'Content-Type: application/json' \\
  -d '{
    \"voice_enabled\": true
  }'"
fi

# Help message
if [ "$EXAMPLE" = "help" ] || [ "$EXAMPLE" = "-h" ] || [ "$EXAMPLE" = "--help" ]; then
    echo "Ogmios Voice Server - Example API Calls"
    echo ""
    echo "Usage:"
    echo "  ./examples.sh [OPTIONS] [EXAMPLE]"
    echo ""
    echo "Options:"
    echo "  --run, -r       Auto-run the examples (otherwise just show commands)"
    echo ""
    echo "Examples:"
    echo "  all             Show all examples (default)"
    echo "  health          Health check"
    echo "  test            Basic voice test"
    echo "  custom [id]     Test with custom voice ID"
    echo "  settings        Test custom voice settings"
    echo "  speak           Simple speak endpoint"
    echo "  voices          List available voices"
    echo "  disabled        Test with voice disabled"
    echo "  long            Long text test"
    echo "  agent           Agent completion simulation"
    echo "  error           Error handling test"
    echo ""
    echo "Examples:"
    echo "  ./examples.sh                    # Show all examples"
    echo "  ./examples.sh health             # Show health check command"
    echo "  ./examples.sh --run test         # Run test example"
    echo "  ./examples.sh custom ABC123      # Test with voice ID ABC123"
    echo ""
fi

# Footer
if [ "$EXAMPLE" = "all" ] && [ "$AUTO_RUN" != "true" ]; then
    echo -e "\n${YELLOW}Tip:${NC} Use './examples.sh --run <example>' to execute the commands"
    echo -e "${YELLOW}Tip:${NC} Use 'jq' for pretty JSON output (install with: brew install jq)"
fi
