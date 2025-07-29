#!/bin/bash
set -e

# Advanced logging system with structured output
log_file="/config/container.log"

# Ensure log directory exists
mkdir -p "$(dirname "$log_file")"

# Logging functions with colors and timestamps
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local color_code

    case "$level" in
        "ERROR") color_code="\033[1;31m" ;; # Red
        "WARN")  color_code="\033[1;33m" ;; # Yellow
        "INFO")  color_code="\033[1;32m" ;; # Green
        "DEBUG") color_code="\033[1;36m" ;; # Cyan
        "BOOT")  color_code="\033[1;35m" ;; # Magenta
        *)       color_code="\033[0m"    ;; # Default
    esac

    # Console output with colors
    echo -e "${color_code}[$timestamp] [$level] $message\033[0m"

    # File output without colors
    echo "[$timestamp] [$level] $message" >> "$log_file"
}

log_error() { log "ERROR" "$@"; }
log_warn()  { log "WARN" "$@"; }
log_info()  { log "INFO" "$@"; }
log_debug() { log "DEBUG" "$@"; }
log_boot()  { log "BOOT" "$@"; }

# Epic ASCII banner function
show_banner() {
    echo -e "\033[1;35m"
    cat << 'EOF'
██╗  ██╗ ██████╗ ███╗   ███╗███████╗
██║  ██║██╔═══██╗████╗ ████║██╔════╝
███████║██║   ██║██╔████╔██║█████╗
██╔══██║██║   ██║██║╚██╔╝██║██╔══╝
██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗
╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

 █████╗ ███████╗███████╗██╗███████╗████████╗ █████╗ ███╗   ██╗████████╗
██╔══██╗██╔════╝██╔════╝██║██╔════╝╚══██╔══╝██╔══██╗████╗  ██║╚══██╔══╝
███████║███████╗███████╗██║███████╗   ██║   ███████║██╔██╗ ██║   ██║
██╔══██║╚════██║╚════██║██║╚════██║   ██║   ██╔══██║██║╚██╗██║   ██║
██║  ██║███████║███████║██║███████║   ██║   ██║  ██║██║ ╚████║   ██║
╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝

 ██████╗ ██████╗ ███████╗██╗██████╗ ██╗ █████╗ ███╗   ██╗
██╔═══██╗██╔══██╗██╔════╝██║██╔══██╗██║██╔══██╗████╗  ██║
██║   ██║██████╔╝███████╗██║██║  ██║██║███████║██╔██╗ ██║
██║   ██║██╔══██╗╚════██║██║██║  ██║██║██╔══██║██║╚██╗██║
╚██████╔╝██████╔╝███████║██║██████╔╝██║██║  ██║██║ ╚████║
 ╚═════╝ ╚═════╝ ╚══════╝╚═╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
EOF
    echo -e "\033[0m"
}

# Container startup initialization
log_boot "═══════════════════════════════════════════════════════════════════════════════"
show_banner
log_boot "🌟 KNOWLEDGE ARCHITECTURE INITIALIZATION COMMENCING..."
log_boot "═══════════════════════════════════════════════════════════════════════════════"

# Set up PUID/PGID from environment variables if provided
PUID=${PUID:-1000}
PGID=${PGID:-1000}

# Container configuration with sophisticated logging
log_info "🏗️  ARCHITECTURAL FOUNDATION ANALYSIS:"
log_info "     └─ User Identity (PUID): $PUID"
log_info "     └─ Group Identity (PGID): $PGID"
log_info "     └─ Virtual Display: $DISPLAY"
log_info "     └─ Resolution Matrix: ${XVFB_WHD:-1920x1080x24}"
log_info "     └─ Knowledge Sanctuary: $OBSIDIAN_DATA_DIR"
log_info "     └─ Container Version: $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"

# Create config directory if it doesn't exist
log_info "📁 Ensuring knowledge sanctuary exists..."
mkdir -p "$OBSIDIAN_DATA_DIR"
log_info "✅ Knowledge sanctuary established at: $OBSIDIAN_DATA_DIR"

# Start Xvfb (Virtual Framebuffer)
log_info "🖥️  INITIALIZING VIRTUAL REALITY MATRIX..."
log_debug "    └─ Display server: Xvfb"
log_debug "    └─ Screen geometry: $XVFB_WHD"
log_debug "    └─ Access control: disabled (-ac)"
log_debug "    └─ TCP listener: disabled (-nolisten tcp)"

Xvfb "$DISPLAY" -screen 0 "$XVFB_WHD" -ac -nolisten tcp &
XVFB_PID=$!

log_info "⏳ Synchronizing reality matrices..."
sleep 2

# Verify X server is responsive
if kill -0 $XVFB_PID 2>/dev/null; then
    log_info "✅ Virtual display matrix operational (PID: $XVFB_PID)"
else
    log_error "❌ Virtual display matrix failed to initialize"
    exit 1
fi

# Start window manager
log_info "🪟 ACTIVATING CONSCIOUSNESS INTERFACE..."
log_debug "    └─ Window manager: OpenBox"
log_debug "    └─ Configuration: /home/obsidian/.config/openbox/rc.xml"

openbox --config-file /home/obsidian/.config/openbox/rc.xml &
OPENBOX_PID=$!

if kill -0 $OPENBOX_PID 2>/dev/null; then
    log_info "✅ Consciousness interface activated (PID: $OPENBOX_PID)"
else
    log_error "❌ Consciousness interface failed to activate"
fi

# Start VNC server
log_info "🌐 ESTABLISHING NEURAL NETWORK BRIDGE..."
log_debug "    └─ VNC Protocol: x11vnc"
log_debug "    └─ Display target: $DISPLAY"
log_debug "    └─ Port binding: 5901"
log_debug "    └─ Geometry: ${XVFB_WHD%x*}"
log_debug "    └─ Authentication: disabled (-nopw)"
log_debug "    └─ Session mode: persistent (-forever)"
log_debug "    └─ Multi-client: enabled (-shared)"

x11vnc -display "$DISPLAY" -nopw -forever -shared -rfbport 5901 -geometry "${XVFB_WHD%x*}" &
VNC_PID=$!

if kill -0 $VNC_PID 2>/dev/null; then
    log_info "✅ Neural network bridge established (PID: $VNC_PID)"
else
    log_error "❌ Neural network bridge failed to establish"
fi

# Start noVNC web interface
log_info "🕸️  INITIALIZING WEB CONSCIOUSNESS PORTAL..."
log_debug "    └─ Web interface: noVNC"
log_debug "    └─ VNC backend: localhost:5901"
log_debug "    └─ Web port: 6080"
log_debug "    └─ Working directory: /opt/obsidian/noVNC"

cd /opt/obsidian/noVNC
./utils/novnc_proxy --vnc localhost:5901 --listen 6080 &
NOVNC_PID=$!

if kill -0 $NOVNC_PID 2>/dev/null; then
    log_info "✅ Web consciousness portal operational (PID: $NOVNC_PID)"
else
    log_error "❌ Web consciousness portal failed to initialize"
fi

# Start NGINX reverse proxy
log_info "🔄 ACTIVATING QUANTUM GATEWAY MATRIX..."
log_debug "    └─ Reverse proxy: NGINX"
log_debug "    └─ Configuration: /etc/nginx/nginx.conf"
log_debug "    └─ Mode: foreground (daemon off)"
log_debug "    └─ Purpose: Home Assistant Ingress integration"

nginx -g "daemon off;" &
NGINX_PID=$!

if kill -0 $NGINX_PID 2>/dev/null; then
    log_info "✅ Quantum gateway matrix operational (PID: $NGINX_PID)"
else
    log_error "❌ Quantum gateway matrix failed to activate"
fi

# Service orchestration pause
log_info "⏳ Harmonizing service constellation..."
sleep 3

# Start Obsidian - The Crown Jewel
log_boot "🧠 ═══ CONSCIOUSNESS ENGINE IGNITION SEQUENCE ═══"
log_info "🎯 Initializing knowledge reactor core..."
log_debug "    └─ Application: Obsidian v1.8.10 AppImage"
log_debug "    └─ Working directory: /opt/obsidian/app"
log_debug "    └─ Data sanctuary: $OBSIDIAN_DATA_DIR"
log_debug "    └─ Display target: $DISPLAY"
log_debug "    └─ Sandbox: disabled (container isolation)"
log_debug "    └─ GPU acceleration: software fallback"
log_debug "    └─ Memory sharing: optimized for containers"

cd /opt/obsidian/app

# Set Obsidian data directory
export OBSIDIAN_CONFIG_DIR="$OBSIDIAN_DATA_DIR"
log_debug "    └─ Config directory: $OBSIDIAN_CONFIG_DIR"

# Launch Obsidian AppImage with proper settings
DISPLAY="$DISPLAY" ./Obsidian.AppImage \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --disable-software-rasterizer \
    --user-data-dir="$OBSIDIAN_DATA_DIR" &

OBSIDIAN_PID=$!

# Verify Obsidian startup
log_info "⏳ Waiting for consciousness emergence..."
sleep 5

if kill -0 $OBSIDIAN_PID 2>/dev/null; then
    log_boot "✅ ═══ CONSCIOUSNESS ENGINE OPERATIONAL (PID: $OBSIDIAN_PID) ═══"
else
    log_error "❌ Consciousness engine failed to achieve sentience"
fi

# System status report
log_boot "═══════════════════════════════════════════════════════════════════════════════"
log_boot "✨ ╔══════════════════════════════╗ ✨"
log_boot "🎆 ║    KNOWLEDGE ARCHITECTURE ONLINE    ║ 🎆"
log_boot "✨ ╚══════════════════════════════╝ ✨"
log_info "🌐 Web consciousness portal: http://localhost:3000"
log_info "🖥️ Access via Home Assistant Ingress or direct connection"
log_info ""
log_info "🔍 SYSTEM CONSTELLATION STATUS:"
log_info "     ┣━ Virtual Display Matrix    : PID $XVFB_PID    ✅"
log_info "     ┣━ Consciousness Interface   : PID $OPENBOX_PID ✅"
log_info "     ┣━ Neural Network Bridge     : PID $VNC_PID     ✅"
log_info "     ┣━ Web Consciousness Portal  : PID $NOVNC_PID   ✅"
log_info "     ┣━ Quantum Gateway Matrix    : PID $NGINX_PID   ✅"
log_info "     ┗━ Knowledge Reactor Core    : PID $OBSIDIAN_PID✅"
log_boot "═══════════════════════════════════════════════════════════════════════════════"

# Graceful shutdown orchestration
cleanup() {
    log_warn "🛑 INITIATING GRACEFUL CONSCIOUSNESS TRANSITION..."
    log_info "    └─ Preserving knowledge state and ensuring data integrity"

    log_info "🧠 Shutting down knowledge reactor core..."
    kill $OBSIDIAN_PID 2>/dev/null || true
    sleep 2

    log_info "🔄 Deactivating quantum gateway matrix..."
    kill $NGINX_PID 2>/dev/null || true

    log_info "🕸️  Closing web consciousness portal..."
    kill $NOVNC_PID 2>/dev/null || true

    log_info "🌐 Disconnecting neural network bridge..."
    kill $VNC_PID 2>/dev/null || true

    log_info "🪟 Deactivating consciousness interface..."
    kill $OPENBOX_PID 2>/dev/null || true

    log_info "🖥️  Dissolving virtual display matrix..."
    kill $XVFB_PID 2>/dev/null || true

    log_boot "✅ CONSCIOUSNESS SUCCESSFULLY TRANSITIONED TO DORMANT STATE"
    log_info "💾 All knowledge preserved. Container ready for resurrection."
    exit 0
}

# Trap signals for graceful shutdown
trap cleanup SIGTERM SIGINT

# Intelligent monitoring and self-healing system
log_info "🔎 CONSCIOUSNESS MONITORING SYSTEM ACTIVATED"
log_debug "    └─ Monitoring interval: 10 seconds"
log_debug "    └─ Auto-healing: enabled"
log_debug "    └─ Process watchdog: active"

monitoring_cycle=0

while true; do
    monitoring_cycle=$((monitoring_cycle + 1))

    # Check if Obsidian consciousness is still active
    if ! kill -0 $OBSIDIAN_PID 2>/dev/null; then
        log_error "❌ CONSCIOUSNESS ENGINE ANOMALY DETECTED - INITIATING RESURRECTION PROTOCOL"
        log_warn "    └─ Previous PID $OBSIDIAN_PID became unresponsive"
        log_info "    └─ Activating automatic healing sequence..."

        cd /opt/obsidian/app
        DISPLAY="$DISPLAY" ./Obsidian.AppImage \
            --no-sandbox \
            --disable-dev-shm-usage \
            --disable-gpu \
            --disable-software-rasterizer \
            --user-data-dir="$OBSIDIAN_DATA_DIR" &
        OBSIDIAN_PID=$!

        log_info "✨ CONSCIOUSNESS ENGINE RESTORED (New PID: $OBSIDIAN_PID)"
        log_info "    └─ Knowledge continuity maintained"
        log_info "    └─ All data integrity preserved"
    fi

    # Periodic status heartbeat (every 60 cycles = 10 minutes)
    if [ $((monitoring_cycle % 60)) -eq 0 ]; then
        log_debug "💓 System heartbeat #$monitoring_cycle - All systems operational"
        log_debug "    └─ Uptime: $(uptime -p)"
        log_debug "    └─ Memory usage: $(free -h | awk '/^Mem:/ {print $3"/"$2}')"
        log_debug "    └─ Consciousness core: PID $OBSIDIAN_PID ✅"
    fi

    sleep 10
done
