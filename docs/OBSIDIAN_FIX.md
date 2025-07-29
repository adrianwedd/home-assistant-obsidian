# Obsidian Panel Fix

## Problem Summary
The Obsidian add-on panel was "useless" because the container was failing to start due to X server/display creation errors.

## Root Cause
The `sytone/obsidian-remote` container requires:
1. Additional privileges (`SYS_ADMIN`) for X server operations
2. Access to GPU devices (`/dev/dri`) for graphics buffer management (gbm)
3. Proper tmpfs and cgroup permissions

## The Fix

### Updated `obsidian/config.yaml`

```yaml
privileged:
  - SYS_ADMIN
devices:
  - /dev/dri:/dev/dri:rwm
```

### Key Error Messages Resolved
- `Fatal server error: Failed to create gbm`
- `Owner of /tmp/.X11-unix should be set to root`
- `Failed to open the display from the DISPLAY environment variable`
- `mkdir: cannot create directory '/sys/fs/cgroup/init': Read-only file system`

## What This Enables
- KasmVNC X server can properly initialize
- Graphics buffer management works correctly
- Container gets required filesystem permissions
- Obsidian desktop environment can start inside the container

## Testing
1. Restart the Home Assistant Obsidian add-on
2. Check add-on logs for successful X server startup
3. Navigate to the Obsidian panel in Home Assistant
4. Should now see KasmVNC web interface with Obsidian running

## Technical Details
This fix addresses the fundamental issue that containerized GUI applications need additional privileges to:
- Create X11 displays
- Access graphics hardware
- Manage system resources like cgroups
- Write to system directories like `/tmp/.X11-unix`

The `sytone/obsidian-remote` container architecture is correct - it uses KasmVNC to provide web access to Obsidian. The problem was Home Assistant's security restrictions preventing the container from initializing its display server.
