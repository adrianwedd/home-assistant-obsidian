#!/bin/bash

# Health check script for Home Assistant Obsidian Container
# Verifies all services are running and responding

set -e

# Function to check if a process is running
check_process() {
    local process_name="$1"
    if pgrep -f "$process_name" > /dev/null 2>&1; then
        echo "✅ $process_name is running"
        return 0
    else
        echo "❌ $process_name is not running"
        return 1
    fi
}

# Function to check HTTP endpoint
check_http() {
    local url="$1"
    local description="$2"

    if curl -s -f "$url" > /dev/null 2>&1; then
        echo "✅ $description is responding"
        return 0
    else
        echo "❌ $description is not responding"
        return 1
    fi
}

echo "🔍 Performing health check..."

# Track overall health
HEALTH_OK=true

# Check Xvfb (virtual display)
if ! check_process "Xvfb"; then
    HEALTH_OK=false
fi

# Check window manager
if ! check_process "openbox"; then
    HEALTH_OK=false
fi

# Check VNC server
if ! check_process "x11vnc"; then
    HEALTH_OK=false
fi

# Check NGINX
if ! check_process "nginx"; then
    HEALTH_OK=false
fi

# Check Obsidian
if ! check_process "Obsidian"; then
    HEALTH_OK=false
fi

# Check web interface is responding
if ! check_http "http://localhost:3000/health" "Web interface"; then
    HEALTH_OK=false
fi

# Check if X display is available
if ! xdpyinfo -display :1 > /dev/null 2>&1; then
    echo "❌ X display :1 is not available"
    HEALTH_OK=false
else
    echo "✅ X display :1 is available"
fi

# Overall health status
if [ "$HEALTH_OK" = true ]; then
    echo "🎉 All health checks passed"
    exit 0
else
    echo "💥 Health check failed"
    exit 1
fi
