#!/bin/bash
#
# Ogmios Voice Server - Start Script
# ===================================
#
# Simple script to start the voice server with proper environment setup.
#
# Usage:
#   ./start.sh              # Start in foreground
#   ./start.sh --background # Start in background
#   ./start.sh --prod       # Start with gunicorn (production)
#

set -e

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if .env exists
if [ ! -f .env ]; then
    log_error ".env file not found!"
    log_info "Please create .env from .env.example:"
    echo "  cp .env.example .env"
    echo "  nano .env  # Add your ELEVENLABS_API_KEY"
    exit 1
fi

# Load environment
source .env

# Check API key
if [ -z "$ELEVENLABS_API_KEY" ] || [ "$ELEVENLABS_API_KEY" == "your_api_key_here" ]; then
    log_error "ELEVENLABS_API_KEY not configured in .env"
    log_info "Get your API key from: https://elevenlabs.io/app/settings/api-keys"
    exit 1
fi

# Check Python
if ! command -v python3 &> /dev/null; then
    log_error "Python 3 not found. Please install Python 3.8 or higher."
    exit 1
fi

# Check virtual environment
if [ ! -d "venv" ]; then
    log_warn "Virtual environment not found. Creating..."
    python3 -m venv venv
    log_info "Virtual environment created."
fi

# Activate virtual environment
log_info "Activating virtual environment..."
source venv/bin/activate

# Install/update dependencies
if [ ! -f "venv/.dependencies_installed" ]; then
    log_info "Installing dependencies..."
    pip install -q -r requirements.txt
    touch venv/.dependencies_installed
    log_info "Dependencies installed."
else
    log_info "Dependencies already installed (use --reinstall to force)"
fi

# Parse arguments
MODE="dev"
BACKGROUND=false

for arg in "$@"; do
    case $arg in
        --background|-b)
            BACKGROUND=true
            ;;
        --prod|-p)
            MODE="prod"
            ;;
        --reinstall)
            log_info "Reinstalling dependencies..."
            pip install -q -r requirements.txt
            touch venv/.dependencies_installed
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --background, -b    Run server in background"
            echo "  --prod, -p          Run with gunicorn (production mode)"
            echo "  --reinstall         Reinstall dependencies"
            echo "  --help, -h          Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                  # Development mode (foreground)"
            echo "  $0 --background     # Development mode (background)"
            echo "  $0 --prod           # Production mode with gunicorn"
            exit 0
            ;;
    esac
done

# Start server
log_info "Starting Ogmios Voice Server..."
log_info "Mode: $MODE"
log_info "Port: ${PORT:-8888}"

if [ "$MODE" == "prod" ]; then
    # Production mode with gunicorn
    if ! command -v gunicorn &> /dev/null; then
        log_error "Gunicorn not found. Installing..."
        pip install gunicorn
    fi

    log_info "Starting with gunicorn (4 workers)..."

    if [ "$BACKGROUND" = true ]; then
        nohup gunicorn -w 4 -b 0.0.0.0:${PORT:-8888} --timeout 30 server:app > voice-server.log 2>&1 &
        PID=$!
        echo $PID > voice-server.pid
        log_info "Server started in background (PID: $PID)"
        log_info "Logs: tail -f voice-server.log"
        log_info "Stop: kill $PID"
    else
        gunicorn -w 4 -b 0.0.0.0:${PORT:-8888} --timeout 30 server:app
    fi
else
    # Development mode with Flask
    if [ "$BACKGROUND" = true ]; then
        nohup python server.py > voice-server.log 2>&1 &
        PID=$!
        echo $PID > voice-server.pid
        log_info "Server started in background (PID: $PID)"
        log_info "Logs: tail -f voice-server.log"
        log_info "Stop: kill $PID"
    else
        python server.py
    fi
fi
