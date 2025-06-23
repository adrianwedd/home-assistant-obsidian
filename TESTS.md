# Test results

Pre-commit hooks now run locally without errors.
The hook suite now includes `markdownlint` and `shellcheck`.
`ha dev addon lint` could not be executed because the `ha` binary is missing in
this environment.

Run `pytest tests/test_version_sync.py` to confirm the config version matches the Docker image tag.

| Platform | Pass/Fail | Memory (MB) | CPU (%) | Notes |
|---|---|---|---|---|
| Dev-container (amd64) | Fail | N/A | N/A | `dockerd` failed: permission denied |
| Raspberry Pi 4 (aarch64) | Not tested | N/A | N/A | Hardware unavailable |
| x86-64 VM | Not tested | N/A | N/A | Hardware unavailable |

No resource metrics could be collected.

Testing was blocked by missing Docker privileges and missing tools.
The ADDON-012 tasks remain blocked until Docker access is resolved.
