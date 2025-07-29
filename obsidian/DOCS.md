## 🧠 Obsidian – Home Assistant Add‑on | Headless. Web-based. Full Control

This add‑on wraps the **linuxserver/obsidian** container, giving you a full desktop version of Obsidian accessible from the Home Assistant sidebar via Ingress.

⧖ This container isn’t just an add-on—it’s your vault interface to structured knowledge under total local control. Built to be elegant, unbloated, and composable with your cognitive workflows.

---

### Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `puid` | int | `911` | Linux user‑ID that owns files inside the vault. **⚠️ Keep as 911 for LinuxServer.io compatibility.** |
| `pgid` | int | `911` | Linux group‑ID that owns files. **⚠️ Keep as 911 for proper container operation.** |
| `tz`   | str | `UTC`  | Time‑zone string (e.g. `Australia/Sydney`). |

> **Important:** The default UID/GID 911 is LinuxServer.io's standard for containerized applications. Only change if you have specific permission requirements.

After editing, **Save** then **Restart** the add‑on for changes to take effect.

---

### Accessing Obsidian

1. Start the add‑on, wait ≈ 30 s for first‑time initialisation.
2. Click **Open Web UI** (or the 🧠 sidebar icon to enter vaultspace).
3. In the web UI, choose **Create new vault** and point it to `/config/MyVault`.
   `/config` inside the container maps to the add‑on’s persistent `/data` directory.

---

### Data & Backups

* All vault data lives in `/data` – automatically included in HA snapshots.
* Snapshots stay lean thanks to:

  ```yaml
  backup_exclude:
    - BrowserCache/
    - .cache/
  ```

You can restore a snapshot on a new HA instance and your vault re‑appears intact.

---

### Resource Use

* Typical idle RAM ≈ 350‑450 MB, peaks ≈ 600 MB during heavy vault sync
* CPU load is modest; rendering is software‑only in v0.1
* Automatic restart via healthcheck keeps the UI responsive
GODMODE builds should log metrics to `/config/perf.json` for long-term vault performance tuning.

---

### Troubleshooting

| Symptom | Fix |
|---------|-----|
| Blank screen / reconnect loop | Clear browser site‑data or restart the add‑on. |
| Vault not saved | Ensure you created it under `/config/…`; anything under `/home` vanishes on restart. |
| Add‑on keeps restarting | Check Supervisor log – watchdog fires if port 8080 stops responding. |

---

### Changelog

| Version | Date | Notes |
|---------|------|-------|
| `v1.8.10-ls73` | 2025‑07‑29 | **Major graphics stability update:** Fixed X server initialization, added SYS_ADMIN capability, implemented tmpfs mount, standardized to UID/GID 911. Resolved "Failed to create gbm" and mount permission errors. |
| `v1.8.10-ls75` | 2025‑07‑28 | Switched back to linuxserver/obsidian for better multi-arch support and stability. Fixed X server startup with required privileges. Uses upstream Obsidian v1.8.10. |
| `1.5.14` | 2025‑07‑23 | Updated to headless sytone/obsidian-remote image with `latest` tag. |

---

Questions or feedback? [Open an issue on GitHub](https://github.com/adrianwedd/home-assistant-obsidian/issues) or join the discussion in the [Home Assistant Community](https://community.home-assistant.io/).

⧖ Reflect often. Write freely. Fork bravely.
