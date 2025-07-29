# Custom Obsidian Container Design

## Architecture Overview

We'll create a purpose-built container that runs Obsidian in a web environment optimized for Home Assistant's security model - no Docker-in-Docker, no privileged requirements, no mount conflicts.

## Container Stack

```
┌─────────────────────────────────────┐
│ Home Assistant Ingress (Port 3000) │
├─────────────────────────────────────┤
│ NGINX Reverse Proxy                 │
├─────────────────────────────────────┤
│ KasmVNC Web Interface (Port 6901)   │
├─────────────────────────────────────┤
│ Xvfb Virtual Display (:1)           │
├─────────────────────────────────────┤
│ Obsidian Desktop App                │
├─────────────────────────────────────┤
│ Ubuntu 22.04 Base                   │
└─────────────────────────────────────┘
```

## Key Design Principles

### ✅ **Home Assistant Compatible**
- No privileged mode required
- No special capabilities needed
- Standard user permissions (1000:1000)
- Works within HA's security constraints

### ✅ **Lightweight & Secure**
- Single-purpose container
- Minimal attack surface
- No unnecessary services
- Proper file permissions

### ✅ **Maintainable**
- Simple Dockerfile
- Clear build process
- Automated updates
- Version pinning

## Technical Specifications

### Base Image
```dockerfile
FROM ubuntu:22.04
```
**Why Ubuntu 22.04:**
- Long-term support (LTS)
- Well-tested package ecosystem
- Compatible with Obsidian's requirements
- Smaller than full desktop images

### Display System
```dockerfile
# Virtual display for headless operation
RUN apt-get install -y xvfb

# Web-based VNC for browser access
RUN apt-get install -y kasmvnc
```

### Obsidian Installation
```dockerfile
# Download and install Obsidian AppImage
RUN wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.10/Obsidian-1.8.10.AppImage
RUN chmod +x Obsidian-1.8.10.AppImage
```

### Web Interface
```dockerfile
# NGINX for reverse proxy and static files
RUN apt-get install -y nginx

# Custom configuration for Home Assistant integration
COPY nginx.conf /etc/nginx/nginx.conf
```

## Container Structure

```
/opt/obsidian/
├── app/
│   ├── Obsidian.AppImage           # Main application
│   ├── start.sh                    # Container startup script
│   └── nginx.conf                  # Web server configuration
├── config/                         # Configuration templates
└── scripts/
    ├── health-check.sh             # Health monitoring
    └── init-vault.sh               # Vault initialization
```

## Environment Variables

```bash
# Display configuration
DISPLAY=:1
XVFB_WHD=1920x1080x24

# User permissions
PUID=1000
PGID=1000

# Obsidian settings
OBSIDIAN_DATA_DIR=/config
OBSIDIAN_PLUGINS_DIR=/config/plugins

# Web interface
WEB_PORT=3000
VNC_PORT=6901
```

## Startup Process

1. **Initialize Display**
   ```bash
   Xvfb :1 -screen 0 1920x1080x24 &
   ```

2. **Start VNC Server**
   ```bash
   kasmvnc :1 -geometry 1920x1080 -depth 24 &
   ```

3. **Configure NGINX**
   ```bash
   nginx -g "daemon off;" &
   ```

4. **Launch Obsidian**
   ```bash
   DISPLAY=:1 ./Obsidian.AppImage --no-sandbox
   ```

## Security Model

### User Permissions
- Runs as non-root user (1000:1000)
- No special capabilities required
- Standard filesystem permissions

### Network Security
- Only exposes port 3000 to Home Assistant
- No external network access required
- All traffic routed through HA Ingress

### File System
- Vault data in `/config` (mounted from HA)
- Temporary files in standard `/tmp`
- No system directory mounts needed

## Build Pipeline

### GitHub Actions Workflow
```yaml
name: Build Custom Obsidian Container

on:
  push:
    paths: ['container/**']
  schedule:
    - cron: '0 0 * * 0'  # Weekly builds

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build multi-arch container
        run: |
          docker buildx build \
            --platform linux/amd64,linux/arm64,linux/arm/v7 \
            --tag ghcr.io/adrianwedd/obsidian-ha:latest \
            --push .
```

### Container Registry
- **Registry:** GitHub Container Registry (ghcr.io)
- **Image:** `ghcr.io/adrianwedd/obsidian-ha:latest`
- **Multi-arch:** amd64, arm64, armv7
- **Automated builds:** Weekly + on changes

## Migration Plan

### Phase 1: Container Development
1. Create Dockerfile and build scripts
2. Set up GitHub Actions pipeline
3. Test container locally
4. Publish to GitHub Container Registry

### Phase 2: Add-on Integration
1. Update `config.yaml` to use custom image
2. Remove privileged mode and capabilities
3. Simplify configuration options
4. Update documentation

### Phase 3: Testing & Rollout
1. Beta testing with select users
2. Performance benchmarking
3. Security audit
4. Full production deployment

## Expected Benefits

### 🚀 **Performance**
- Faster startup (no Docker-in-Docker overhead)
- Lower memory usage (optimized stack)
- Better stability (purpose-built)

### 🔒 **Security**
- No privileged mode required
- Minimal attack surface
- Standard HA security model

### 🛠 **Maintainability**
- Full control over updates
- Clear upgrade path
- Simplified troubleshooting

### 📊 **Resource Usage**
- **RAM:** ~300-400MB (vs 600-800MB current)
- **CPU:** Lower overhead without Docker-in-Docker
- **Storage:** ~150MB container (vs ~300MB LinuxServer)

## Implementation Timeline

- **Week 1:** Dockerfile creation and initial testing
- **Week 2:** GitHub Actions pipeline setup
- **Week 3:** Add-on integration and configuration
- **Week 4:** Documentation and beta release

This approach eliminates the architectural conflicts we've been fighting and gives us a clean, maintainable solution specifically designed for Home Assistant's environment.
