FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV LIBGL_ALWAYS_SOFTWARE=1

# --- Dependencies ---
RUN apt-get update && apt-get install -y \
  wget curl unzip ca-certificates \
  supervisor xvfb x11vnc openbox \
  libnss3 libasound2 libxss1 libxtst6 libxkbfile1 \
  libgtk-3-0 libnotify4 libx11-xcb1 libxcomposite1 libxcursor1 \
  libxdamage1 libxi6 libxtst6 libnss3 libxrandr2 libxss1 libasound2 \
  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

# --- Install KasmVNC ---
RUN mkdir -p /opt/kasmvnc && \
    curl -L -o /opt/kasmvnc/kasmvnc.tar.gz https://kasmweb.com/files/kasmvnc/kasmvnc.tar.gz && \
    tar -xzf /opt/kasmvnc/kasmvnc.tar.gz -C /opt/kasmvnc --strip-components=1 && \
    chmod +x /opt/kasmvnc/kasmvnc

# --- Download Obsidian AppImage ---
RUN mkdir -p /opt/obsidian && \
    curl -L -o /opt/obsidian/Obsidian.AppImage https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/Obsidian-1.5.3.AppImage && \
    chmod +x /opt/obsidian/Obsidian.AppImage

# --- Supervisor config ---
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 6901

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
