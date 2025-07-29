# Home Assistant Optimized Obsidian Container
# Purpose-built to avoid mount conflicts and privileged requirements

FROM ubuntu:22.04

# Set non-interactive frontend for apt
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone
ENV TZ=UTC

# Create obsidian user matching Home Assistant expectations
RUN groupadd -g 1000 obsidian && \
    useradd -u 1000 -g obsidian -m -s /bin/bash obsidian

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Display server
    xvfb \
    # VNC server for web access
    x11vnc \
    # Window manager
    openbox \
    # Web server
    nginx \
    # Download utilities
    wget \
    curl \
    unzip \
    # AppImage requirements
    fuse \
    libfuse2 \
    # Graphics libraries
    libgtk-3-0 \
    libx11-6 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libnss3 \
    libxss1 \
    libgconf-2-4 \
    libxrandr2 \
    libasound2 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    # Cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create application directories
RUN mkdir -p /opt/obsidian/app /opt/obsidian/config /opt/obsidian/scripts

# Download and install noVNC for web browser access
WORKDIR /opt/obsidian
RUN wget -O noVNC.zip "https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.zip" && \
    unzip noVNC.zip && \
    mv noVNC-1.4.0 noVNC && \
    rm noVNC.zip

# Download and install Obsidian AppImage
WORKDIR /opt/obsidian/app
RUN wget -O Obsidian.AppImage "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.10/Obsidian-1.8.10.AppImage" && \
    chmod +x Obsidian.AppImage

# Configure NGINX for web interface
COPY nginx.conf /etc/nginx/nginx.conf

# Create startup script
COPY start.sh /opt/obsidian/scripts/start.sh
RUN chmod +x /opt/obsidian/scripts/start.sh

# Create health check script
COPY health-check.sh /opt/obsidian/scripts/health-check.sh
RUN chmod +x /opt/obsidian/scripts/health-check.sh

# Set up VNC configuration  
RUN mkdir -p /home/obsidian/.vnc

# Configure Openbox window manager
RUN mkdir -p /home/obsidian/.config/openbox
COPY openbox-rc.xml /home/obsidian/.config/openbox/rc.xml

# Set ownership of home directory
RUN chown -R obsidian:obsidian /home/obsidian /opt/obsidian

# Switch to obsidian user
USER obsidian

# Set environment variables
ENV DISPLAY=:1
ENV XVFB_WHD=1920x1080x24
ENV OBSIDIAN_DATA_DIR=/config

# Expose port for Home Assistant Ingress
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /opt/obsidian/scripts/health-check.sh

# Set working directory
WORKDIR /config

# Start the container
CMD ["/opt/obsidian/scripts/start.sh"]
