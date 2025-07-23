# Home Assistant Obsidian Add-on Testing Matrix

This document outlines the testing procedures and results for the Home Assistant Obsidian Add-on. The goal is to ensure broad compatibility and stability across various Home Assistant deployment environments.

Pre-commit hooks now run locally without errors.
The hook suite now includes `markdownlint` and `shellcheck`.
`ha dev addon lint` works inside the dev container because `pipx` installs the Home Assistant CLI (`homeassistant-cli`).
Install the CLI manually if running outside the container.

Run `pytest tests/test_version_sync.py` to confirm the config version matches the Docker image tag.

## Test Environments

| Environment | Architecture | Notes |
|---|---|---|
| **VS Code Dev Container** | `amd64` | Primary development environment. Simulates a Home Assistant OS instance. |
| **Raspberry Pi 4** | `aarch64` | Physical hardware test. Represents a common low-power ARM deployment. |
| **Intel NUC (VM)** | `amd64` | Virtual machine test. Represents a typical x86-64 server deployment. |
| **Raspberry Pi 3** | `armv7` | Optional test. Represents older, lower-spec ARM hardware. |

## Test Cases

For each environment, the following test cases will be executed and their results recorded.

### 1. Add-on Installation and Initial Startup

**Objective:** Verify that the add-on installs correctly and starts without errors.

* **Steps:**
    1. Add the custom add-on repository to Home Assistant.
    2. Install the Obsidian add-on from the store.
    3. Start the add-on.
    4. Monitor the add-on logs for any errors or warnings during startup.
* **Expected Result:** Add-on starts successfully, logs show no critical errors.

### 2. Ingress Functionality

**Objective:** Verify that the Obsidian UI is accessible via Home Assistant Ingress.

* **Steps:**
    1.  Navigate to the add-on page in Home Assistant.
    2.  Click "Open Web UI" or the Obsidian sidebar icon.
    3.  Verify that the KasmVNC desktop with Obsidian loads correctly within the Home Assistant UI.
* **Expected Result:** Obsidian UI loads and is fully interactive within the Home Assistant frontend.

### 3. Vault Persistence and Symlink (`/config` to `/data`)

**Objective:** Verify that Obsidian vaults are correctly persisted across add-on restarts and that the `/config` to `/data` symlink functions as expected.

* **Steps:**
    1.  Inside the Obsidian UI, create a new vault at `/config/MyTestVault`.
    2.  Create a new note inside `MyTestVault` (e.g., "Test Note").
    3.  Stop the Obsidian add-on.
    4.  Start the Obsidian add-on.
    5.  Re-open the Obsidian UI via Ingress.
    6.  Verify that `MyTestVault` and "Test Note" are still present and accessible.
* **Expected Result:** Vault and its contents persist across add-on restarts.

### 4. Configuration Options (`puid`, `pgid`, `tz`)

**Objective:** Verify that the `puid`, `pgid`, and `tz` configuration options are correctly applied.

* **Steps:**
    1.  Configure `puid` and `pgid` to non-default values (e.g., `1001`, `1001`).
    2.  Configure `tz` to a specific timezone (e.g., `America/New_York`).
    3.  Restart the add-on.
    4.  **For `puid`/`pgid`:** Access the add-on's `/data` directory (e.g., via SSH to the Home Assistant OS and navigating to `/mnt/data/supervisor/addons/data/a0d7b954_obsidian/`). Verify that the files created by Obsidian (e.g., `.obsidian` directory within the vault) are owned by the specified `puid`/`pgid`.
    5.  **For `tz`:** Inside Obsidian, open a terminal (if available in the KasmVNC environment, or check logs for timezone-related output) and run `date`. Verify the displayed time reflects the configured timezone.
* **Expected Result:** File ownership and timezone settings are correctly applied within the container.

### 5. Watchdog Functionality

**Objective:** Verify that the add-on's watchdog correctly detects and restarts the add-on if the UI becomes unresponsive.

* **Steps:**
    1.  Start the add-on.
    2.  (Simulate unresponsiveness - *This step may require manual intervention or a specific command to kill the VNC process within the container without stopping the entire add-on.* For initial testing, simply stopping the VNC process might suffice if the add-on is configured to restart on process exit.)
    3.  Monitor the Home Assistant Supervisor logs for watchdog-triggered restarts.
* **Expected Result:** Supervisor detects unresponsiveness and restarts the add-on.

### 6. Backup Exclusions

**Objective:** Verify that specified directories (`BrowserCache/`, `.cache/`) are excluded from Home Assistant snapshots.

* **Steps:**
    1.  Generate some browser cache data within the Obsidian UI (e.g., browse some internal links, open a few notes).
    2.  Create a full Home Assistant snapshot.
    3.  Download the snapshot and inspect its contents (e.g., using a tool like `tar` or `7zip`).
    4.  Verify that `BrowserCache/` and `.cache/` directories within the add-on's data are *not* present in the snapshot.
* **Expected Result:** `BrowserCache/` and `.cache/` are excluded from the snapshot, resulting in a smaller backup size.

### 7. Local Linting

**Objective:** Verify that the add-on passes the official Home Assistant linter.

*   **Steps:**
    1.  Install the Home Assistant CLI. The dev container already does this with `pipx install homeassistant-cli`.
    2.  Run `ha dev addon lint` from the root of the repository.
* **Expected Result:** The linter should pass without any errors.

| Test Case | VS Code Dev Container (`amd64`) | Raspberry Pi 4 (`aarch64`) | Intel NUC (VM, `amd64`) | Raspberry Pi 3 (`armv7`) |
|---|---|---|---|---|
| 1. Installation & Startup | In Progress | Not tested | Not tested | Not tested |
| 2. Ingress Functionality | In Progress | Not tested | Not tested | Not tested |
| 3. Vault Persistence | In Progress | Not tested | Not tested | Not tested |
| 4. Config Options | In Progress | Not tested | Not tested | Not tested |
| 5. Watchdog | In Progress | Not tested | Not tested | Not tested |
| 6. Backup Exclusions | In Progress | Not tested | Not tested | Not tested |

**Summary:** Testing is currently in progress. The Docker privilege issue in the dev container is being addressed to enable full test execution.
