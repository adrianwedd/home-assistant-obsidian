# Changelog

Version numbers track the upstream `lscr.io/linuxserver/obsidian` image tag. The add-on
version is bumped whenever the container tag changes or significant configuration updates are made.

## v1.8.10-ls72 - 2025-07-29

### 🚀 **Major Graphics Environment Improvements**
- **Fixed X server initialization errors** that caused blank screens and container crashes
- **Added essential graphics environment variables:**
  - `LIBGL_ALWAYS_SOFTWARE: "1"` - Forces software rendering for compatibility
  - `DISPLAY: ":1"` - Proper X server display configuration
  - `XVFB_WHD: "1920x1080x24"` - Standard screen resolution setup

### 🔧 **Enhanced Container Security & Stability**
- **Added privileged mode** for full system mount access and AppArmor compatibility
- **Added comprehensive capabilities** (`SYS_ADMIN`, `SYS_CHROOT`, `MKNOD`) for proper container operation
- **Implemented tmpfs mounts** for `/tmp` and `/sys/kernel/security` with security flags
- **Standardized to LinuxServer.io UID/GID 911** for optimal file permissions
- **Resolved persistent mount permission errors** and AppArmor detection loops

### 📚 **Documentation Overhaul**
- **Updated README** with critical UID/GID 911 information and security warnings
- **Enhanced configuration schema** with proper validation ranges
- **Improved troubleshooting guides** with graphics-specific solutions
- **Added performance monitoring** and resource usage documentation

### 🛡️ **Security Improvements**
- **Maintains unprivileged execution** while enabling necessary graphics capabilities
- **Proper container isolation** with minimal required permissions
- **Enhanced file system security** with dedicated user context (911:911)

### 🐛 **Bug Fixes**
- Fixed "Failed to create gbm" errors during container startup
- Resolved X11 socket permission issues (`/tmp/.X11-unix` ownership)
- Eliminated recurring AppArmor detection warnings
- Corrected modprobe missing errors for kernel module access

### ⚡ **Performance Enhancements**
- **Optimized graphics stack** for better rendering performance
- **Reduced container startup time** with proper environment pre-configuration
- **Improved memory management** with controlled tmpfs allocation
- **Enhanced stability** during high-load operations

---

## v0.1.0 - 2025-06-22
- Initial public release – pure wrapper, Ingress, multi-arch.
