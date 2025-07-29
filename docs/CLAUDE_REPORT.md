# Container Transition Investigation Report

## Summary

The project has transitioned from `lscr.io/linuxserver/obsidian` to `ghcr.io/sytone/obsidian-remote:latest` but contains several configuration inconsistencies and outdated references that need to be addressed.

## Current State

### Container Configuration
- **Current Image**: `ghcr.io/sytone/obsidian-remote:latest` (in `obsidian/config.yaml:12`)
- **Port**: 8080 (correctly configured in `obsidian/config.yaml:15`)
- **Version**: 1.5.15 (updated 2025-07-28 - fixed container startup issues)

### Container Differences

| Aspect | ghcr.io/sytone/obsidian-remote | sytone/obsidian-remote |
|--------|---------------------|------------------------|
| Port | 3000 | 8080 |
| Data Path | `/config` | `/vaults` for vaults, `/config` for settings |
| Base | KasmVNC | Custom web implementation |
| Focus | Full desktop experience | Browser-optimized Obsidian |

## Issues Identified

### 1. Documentation Inconsistencies
Multiple files still reference the old `ghcr.io/sytone/obsidian-remote` container:

- `CLAUDE.md:3` - Project overview still mentions `ghcr.io/sytone/obsidian-remote`
- `CHANGELOG.md:3-4` - References linuxserver image tracking
- `AGENTS.md:4` - References `ghcr.io/sytone/obsidian-remote`
- `AGENTS.md:16` - Mentions renovate monitoring linuxserver tags
- `R&D.md` - Extensive references throughout (multiple locations)

### 2. Test Configuration Issues
- `tests/smoke_test.py:22` - Still attempts to run `ghcr.io/sytone/obsidian-remote:latest`
- Test uses port 3000 instead of 8080

### 3. Runtime Script Compatibility
- `obsidian/run.sh:5` - Comment references "linuxserver.io's expected data path"
- The symlink logic (`/config` → `/data`) may be incompatible with sytone container expectations

### 4. No KMV Solutions Found
- **Good news**: No remnants of "kmv solutions" were found in the codebase
- The transition appears to have cleanly removed any previous workarounds

## Recommendations

### Priority 1: Critical Configuration
1. **Update run.sh**: Review and potentially revise the `/config` to `/data` symlink logic for sytone container compatibility
2. **Fix smoke test**: Update `tests/smoke_test.py` to use `ghcr.io/sytone/obsidian-remote:latest` and port 8080

### Priority 2: Documentation Updates
1. **Update CLAUDE.md**: Change project overview to reference `ghcr.io/sytone/obsidian-remote`
2. **Update CHANGELOG.md**: Revise to reflect new container tracking
3. **Update AGENTS.md**: Change renovate and container references
4. **Review R&D.md**: Update all linuxserver references or mark as historical

### Priority 3: Validation
1. **Test container compatibility**: Verify the current run.sh symlink approach works with sytone container
2. **Validate ingress configuration**: Ensure port 8080 ingress setup is functioning correctly

## Obsidian Panel Investigation Results

### Key Finding: The VNC Interface is Expected Behavior

**Important Discovery**: The `sytone/obsidian-remote` container **does** use KasmVNC/Guacamole - this is the correct and expected behavior, not a misconfiguration. The container runs Obsidian inside a virtual desktop accessible via web browser.

### Root Cause Analysis

1. **Container Architecture**: `sytone/obsidian-remote` uses:
   - Guacamole for RDP/VNC gateway
   - Internal RDP server for desktop environment
   - Express.js web server on port 8080
   - Obsidian running in the virtual desktop

2. **The Actual Problem**: JavaScript error `UI.rfb.lastActiveAt` undefined suggests:
   - KasmVNC frontend initialization issue
   - Possible ingress proxy interference
   - WebSocket connection problems through Home Assistant ingress

3. **Container Testing**: Direct container test showed:
   - HTTP 200 response on port 8080 ✓
   - Guacamole/RDP services starting correctly ✓
   - Connection timeout issues (inactive for too long)

### Playwright Test Enhancement

Created comprehensive test `test_obsidian_panel_detailed_exploration()` that will:
- Capture JavaScript console errors
- Detect VNC vs Obsidian UI elements
- Generate detailed diagnostic reports
- Take screenshots of failure states
- Distinguish between different failure modes

### Potential Fixes

#### Priority 1: Ingress Configuration Issues
1. **WebSocket Support**: Home Assistant ingress may not properly support WebSocket connections needed for KasmVNC
2. **Path Handling**: The ingress proxy might be interfering with KasmVNC's web client initialization
3. **Timeout Settings**: Connection dropping due to inactivity timeouts

#### Priority 2: Container Configuration
1. **Environment Variables**: May need additional config for proxy/ingress environment
2. **Authentication**: Container shows "no auth enabled" - might need proper auth setup
3. **Platform Mismatch**: Container built for amd64, running on arm64 (warning, not error)

### Troubleshooting Steps

1. **Run Playwright Test**: Execute the new test to get detailed diagnostics
2. **Check HA Logs**: Examine Home Assistant and Supervisor logs for ingress errors
3. **WebSocket Investigation**: Verify if HA ingress supports WebSocket properly
4. **Container Logs**: Check the actual add-on container logs in HA
5. **Consider Direct Access**: Test if accessing container directly (not through ingress) works

## Conclusion

The container transition is largely complete in the core configuration, but the Obsidian panel issue is **not** due to container mismatch - it's a runtime issue with the KasmVNC web interface failing to initialize properly through Home Assistant's ingress system. This is likely a WebSocket/proxy compatibility issue rather than a fundamental configuration problem.
