## Obsidian – Home Assistant Community Add-on

This add‑on wraps the official **linuxserver/obsidian** container, giving you a full desktop version of Obsidian accessible from the Home Assistant sidebar via Ingress.

It follows the "pure wrapper" philosophy – no Dockerfile here – so updates are instant and always track upstream.

### Features

|   |   |
|---|---|
| **Pure wrapper, zero build‑time** | Pulls the official multi‑arch `lscr.io/linuxserver/obsidian` image – installs in seconds and stays upstream‑fresh. |
| **Ingress‑first UX** | Obsidian’s KasmVNC desktop appears in the HA sidebar – no extra ports or logins. |
| **Snapshot‑friendly** | Vault lives under `/data`; large browser caches are excluded from HA backups. |
| **Minimal setup** | Only `PUID`, `PGID`, and `TZ` options – sensible defaults included. |
| **Watchdog & auto‑heal** | Supervisor pings the UI every 60 s and restarts automatically on failure. |
| **CI‑powered updates** | Renovate + GitHub Actions bump the image tag and publish signed releases. |

### Quick start

1. **Add repository**
   *Settings → Add-ons → Add-on Store → ⋮ → Repositories →*

   ```text
   https://github.com/adrianwedd/home-assistant-obsidian
   ```

2. **Install** the **Obsidian** add-on.
3. **Configure** (optional – defaults work on many systems):

   | Option | Default | Notes |
   |--------|---------|-------|
   | `puid` | `1000`  | Numeric user ID for file ownership. Run `id -u` on Linux. |
   | `pgid` | `1000`  | Numeric group ID. Run `id -g` on Linux. |
   | `tz`   | `UTC`   | Time-zone string, e.g. `Europe/London`. |

4. **Start** the add-on → **Open Web UI** (or click the 🧠 Obsidian icon in the sidebar).
5. **Create your vault** inside `/config/MyVault` (maps to the add-on’s persistent storage).
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
2. Click **Open Web UI** or the 🧠 Obsidian sidebar entry.
3. In the VNC desktop choose **Create new vault** and point it to `/config/MyVault`.
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

### Security & resources

* Runs **unprivileged**; no `full_access` or extra capabilities by default.
* GPU passthrough is **deferred** to a future release.
* Memory hint set to **512 MB** – HA will warn (but not block) on 1 GB devices.
* Watchdog at `http://[HOST]:3000/` ensures automatic recovery if the VNC stack freezes.

---

### Troubleshooting

| Symptom | Fix |
|---------|-----|
| Blank screen / reconnect loop | Clear browser site‑data or restart the add‑on. |
| Vault not saved | Ensure you created it under `/config/…`; anything under `/home` vanishes on restart. |
| Add‑on keeps restarting | Check Supervisor log – watchdog fires if port 3000 stops responding. |

---

### Changelog

| Version | Date | Notes |
|---------|------|-------|
| `0.1.0` | 2025‑06‑22 | Initial public release – pure wrapper, Ingress, multi‑arch. |

---

Questions or feedback? [Open an issue on GitHub](https://github.com/adrianwedd/home-assistant-obsidian/issues) or join the discussion in the [Home Assistant Community](https://community.home-assistant.io/).

MIT © 2025 Adrian Wedd <adrian@adrianwedd.com>

Upstream image © LinuxServer.io (GPL‑v3)
