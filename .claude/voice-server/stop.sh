#!/bin/bash
#
# Ogmios Voice Server - Stop Script
# ==================================
#
# Simple script to stop the voice server running in background.
#
# Usage:
#   ./stop.sh
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

# Check for PID file
if [ -f voice-server.pid ]; then
    PID=$(cat voice-server.pid)

    # Check if process is running
    if ps -p $PID > /dev/null 2>&1; then
        log_info "Stopping voice server (PID: $PID)..."
        kill $PID

        # Wait for process to stop
        sleep 2

        # Check if stopped
        if ps -p $PID > /dev/null 2>&1; then
            log_warn "Process still running. Force killing..."
            kill -9 $PID
        fi

        rm voice-server.pid
        log_info "Voice server stopped."
    else
        log_warn "Process not running (PID $PID not found)"
        rm voice-server.pid
    fi
else
    # Try to find process by name
    log_warn "No PID file found. Searching for voice server process..."

    PIDS=$(pgrep -f "python.*server.py|gunicorn.*server:app" || true)

    if [ -z "$PIDS" ]; then
        log_info "No voice server process found."
    else
        log_info "Found process(es): $PIDS"
        for PID in $PIDS; do
            log_info "Stopping process $PID..."
            kill $PID
        done
        log_info "Voice server stopped."
    fi
fi
