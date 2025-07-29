# Mount Error Troubleshooting History

## Problem Statement

The Obsidian Home Assistant add-on has been experiencing persistent mount errors that cause container instability:

```
mount: /sys/kernel/security: cannot mount none read-only.
mount: /tmp: cannot mount none read-only.
Could not mount /sys/kernel/security.
AppArmor detection and --privileged mode might break.
/usr/local/bin/dockerd-entrypoint.sh: 148: modprobe: not found
```

These errors loop continuously and indicate the container is trying to mount system directories that Home Assistant's security model restricts.

## Attempted Solutions (Commit History)

### Phase 1: Graphics Environment (ADDON-051)
**Commit:** `110305e` - "Add graphics environment variables and bump to v1.8.10-ls73"

**What we tried:**
- Added `LIBGL_ALWAYS_SOFTWARE: "1"` for software rendering
- Set `DISPLAY: ":1"` for proper X server display
- Configured `XVFB_WHD: "1920x1080x24"` for screen resolution

**Result:** ✅ Fixed X server initialization, but mount errors persisted

### Phase 2: Enhanced Capabilities (ADDON-052)
**Commit:** `af9806d` - "Add privileged mode and enhanced capabilities for mount operations"

**What we tried:**
- Added `privileged: true` for full system access
- Enhanced capabilities: `SYS_ADMIN`, `SYS_CHROOT`, `MKNOD`
- Implemented tmpfs mounts for `/tmp` and `/sys/kernel/security`
- Standardized UID/GID to 911 (LinuxServer.io standard)

**Result:** ❓ **Still testing** - Latest attempt to resolve mount issues

### Previous Historical Attempts

#### ADDON-050: Container Tag Optimization
**Commit:** `4bad0c6` - Use existing container tag v1.8.10-ls74
- Attempted to use a stable upstream container version
- **Result:** Mount issues persisted

#### ADDON-049: S6-Overlay PID Conflict
**Commit:** `bcabd8a` - Fix s6-overlay PID 1 conflict and bump to v1.5.17
- Addressed process initialization conflicts
- **Result:** Partially resolved startup issues, mount errors continued

#### ADDON-047-048: Device Access Issues
**Commits:** `4acba49`, `1b3cef9` - Remove conflicting device access, fix Docker tag
- Removed conflicting device configurations
- Fixed Docker tag versioning issues
- **Result:** Improved startup but mount errors remained

#### ADDON-044-046: Privileged Mode Iterations
**Commits:** `2265546`, `6d4cfc9`, `847ab5a` - Various privileged mode configurations
- Multiple attempts at privileged container configuration
- Fixed configuration format issues
- **Result:** Partial improvements but persistent mount failures

## Current Configuration State

### Latest config.yaml (v1.8.10-ls72):
```yaml
name: Obsidian
version: "v1.8.10-ls72"
image: lscr.io/linuxserver/obsidian
full_access: true
privileged: true
capabilities:
  - SYS_ADMIN
  - SYS_CHROOT
  - MKNOD
tmpfs:
  - /tmp:rw,noexec,nosuid,size=1g
  - /sys/kernel/security:rw,noexec,nosuid,size=100m
environment:
  LIBGL_ALWAYS_SOFTWARE: "1"
  DISPLAY: ":1"
  XVFB_WHD: "1920x1080x24"
options:
  puid: 911
  pgid: 911
  tz: UTC
```

## Analysis: Why We're Going in Circles

### Root Cause Analysis
1. **LinuxServer.io Container Design**: The upstream container expects full system privileges that conflict with Home Assistant's security model
2. **AppArmor Integration**: The container's Docker-in-Docker setup requires AppArmor access that HA restricts
3. **Mount Namespace Issues**: Container tries to mount system directories that are protected in HA's containerized environment

### What's Working vs. What's Not

#### ✅ **Successfully Resolved:**
- X server initialization (`LIBGL_ALWAYS_SOFTWARE`, `DISPLAY`, `XVFB_WHD`)
- Container startup and basic operation
- Graphics environment setup
- File permissions (UID/GID 911)
- Basic Ingress connectivity

#### ❌ **Still Failing:**
- `/sys/kernel/security` mount operations
- `/tmp` mount operations (despite tmpfs configuration)
- AppArmor detection and integration
- `modprobe` kernel module loading
- Docker-in-Docker functionality within the container

## Next Steps & Recommendations

### Option 1: Accept Non-Fatal Warnings
- **Approach**: Document that mount warnings are cosmetic and don't affect functionality
- **Pros**: Container appears to work despite warnings
- **Cons**: Logs are cluttered, potential instability

### Option 2: Container Image Alternatives
- **Approach**: Switch to a different Obsidian container image designed for restricted environments
- **Pros**: Purpose-built for constrained security contexts
- **Cons**: May lose LinuxServer.io's stability and features

### Option 3: Home Assistant Core Integration
- **Approach**: Work with HA team to allow specific mount permissions for this add-on
- **Pros**: Proper solution that addresses root cause
- **Cons**: Requires upstream changes, security implications

### Option 4: Custom Container Build
- **Approach**: Create our own Obsidian container without Docker-in-Docker requirements
- **Pros**: Full control over container behavior
- **Cons**: Maintenance overhead, security responsibility

## Documentation Impact

This troubleshooting journey has revealed that:
1. The add-on requires extensive documentation about expected warnings
2. Users need clear guidance on what errors are cosmetic vs. critical
3. The security implications of `privileged: true` need better explanation
4. Alternative deployment methods should be documented

## Conclusion

We've systematically addressed:
- ✅ Graphics initialization issues
- ✅ Container startup problems
- ✅ File permission challenges
- ✅ Basic functionality requirements

The remaining mount errors appear to be architectural conflicts between the LinuxServer.io container design and Home Assistant's security model. Further investigation is needed to determine if these are cosmetic warnings or indicate deeper functionality issues.
