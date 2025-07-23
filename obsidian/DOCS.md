## 🧠 Obsidian – Home Assistant Add‑on | Headless. Web-based. Full Control

This add‑on wraps the **sytone/obsidian-remote** container, giving you a web-based version of Obsidian accessible from the Home Assistant sidebar via Ingress.

⧖ This container isn’t just an add-on—it’s your vault interface to structured knowledge under total local control. Built to be elegant, unbloated, and composable with your cognitive workflows.

---

### Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `puid` | int | `1000` | Linux user‑ID that owns files inside the vault. |
| `pgid` | int | `1000` | Linux group‑ID that owns files. |
| `tz`   | str | `UTC`  | Time‑zone string (e.g. `Australia/Sydney`). |

> On most Linux hosts run `id -u` and `id -g` to discover your UID/GID.

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
| `1.5.14` | 2025‑07‑23 | Updated to headless sytone/obsidian-remote image with `latest` tag. |

---

Questions or feedback? [Open an issue on GitHub](https://github.com/adrianwedd/home-assistant-obsidian/issues) or join the discussion in the [Home Assistant Community](https://community.home-assistant.io/).

⧖ Reflect often. Write freely. Fork bravely.
