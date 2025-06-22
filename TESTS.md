# Test results

The add-on could not be run in this environment due to missing Docker privileges.
Attempts to start `dockerd` failed with permission errors. The `ha` CLI and
`pre-commit` were also unavailable, indicating the dev-container setup is
incomplete.

| Platform | Pass/Fail | Memory (MB) | CPU (%) | Notes |
|---|---|---|---|---|
| Dev-container (amd64) | Fail | N/A | N/A | `dockerd` failed: permission denied |
| Raspberry Pi 4 (aarch64) | Not tested | N/A | N/A | Hardware unavailable |
| x86-64 VM | Not tested | N/A | N/A | Hardware unavailable |

No resource metrics could be collected.

Testing was blocked by missing Docker privileges and missing tools.
The ADDON-012 tasks remain blocked until Docker access is resolved.
