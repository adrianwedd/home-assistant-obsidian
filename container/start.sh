#!/bin/bash
set -e

echo "🧠 Starting Home Assistant Obsidian Container..."

# Set up PUID/PGID from environment variables if provided
PUID=${PUID:-1000}
PGID=${PGID:-1000}

echo "📋 Container Configuration:"
echo "  PUID: $PUID"
echo "  PGID: $PGID"
echo "  Display: $DISPLAY"
echo "  Resolution: $XVFB_WHD"
echo "  Data Directory: $OBSIDIAN_DATA_DIR"

# Create config directory if it doesn't exist
mkdir -p "$OBSIDIAN_DATA_DIR"

# Start Xvfb (Virtual Framebuffer)
echo "🖥️  Starting virtual display..."
Xvfb "$DISPLAY" -screen 0 "$XVFB_WHD" -ac -nolisten tcp &
XVFB_PID=$!

# Wait for X server to be ready
sleep 2

# Start window manager
echo "🪟 Starting window manager..."
openbox --config-file /home/obsidian/.config/openbox/rc.xml &
OPENBOX_PID=$!

# Start VNC server
echo "🌐 Starting VNC server..."
vncserver "$DISPLAY" -geometry "${XVFB_WHD%x*}" -depth 24 -localhost -nolisten tcp &
VNC_PID=$!

# Start noVNC web interface
echo "🕸️  Starting noVNC web interface..."
cd /opt/obsidian/noVNC
./utils/novnc_proxy --vnc localhost:5901 --listen 6080 &
NOVNC_PID=$!

# Start NGINX reverse proxy
echo "🔄 Starting web server..."
nginx -g "daemon off;" &
NGINX_PID=$!

# Wait a moment for services to start
sleep 3

# Start Obsidian
echo "🧠 Launching Obsidian..."
cd /opt/obsidian/app

# Set Obsidian data directory
export OBSIDIAN_CONFIG_DIR="$OBSIDIAN_DATA_DIR"

# Launch Obsidian AppImage with proper settings
DISPLAY="$DISPLAY" ./Obsidian.AppImage \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --disable-software-rasterizer \
    --user-data-dir="$OBSIDIAN_DATA_DIR" &

OBSIDIAN_PID=$!

echo "✅ All services started successfully!"
echo "🌐 Web interface available on port 3000"
echo "🔍 Process IDs:"
echo "   Xvfb: $XVFB_PID"
echo "   Openbox: $OPENBOX_PID"
echo "   VNC: $VNC_PID"
echo "   noVNC: $NOVNC_PID"
echo "   NGINX: $NGINX_PID"
echo "   Obsidian: $OBSIDIAN_PID"

# Function to handle shutdown
cleanup() {
    echo "🛑 Shutting down services..."
    kill $OBSIDIAN_PID 2>/dev/null || true
    kill $NGINX_PID 2>/dev/null || true
    kill $NOVNC_PID 2>/dev/null || true
    kill $VNC_PID 2>/dev/null || true
    kill $OPENBOX_PID 2>/dev/null || true
    kill $XVFB_PID 2>/dev/null || true
    echo "✅ Cleanup complete"
    exit 0
}

# Trap signals for graceful shutdown
trap cleanup SIGTERM SIGINT

# Keep container running and monitor processes
while true; do
    # Check if Obsidian is still running
    if ! kill -0 $OBSIDIAN_PID 2>/dev/null; then
        echo "❌ Obsidian process died, restarting..."
        cd /opt/obsidian/app
        DISPLAY="$DISPLAY" ./Obsidian.AppImage \
            --no-sandbox \
            --disable-dev-shm-usage \
            --disable-gpu \
            --disable-software-rasterizer \
            --user-data-dir="$OBSIDIAN_DATA_DIR" &
        OBSIDIAN_PID=$!
    fi

    sleep 10
done
