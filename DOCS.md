## 🧠 Obsidian – Home Assistant Community Add-on | Pure Wrapper. Zero Bloat. Full GODMODE

This add‑on wraps the official **linuxserver/obsidian** container, giving you a full desktop version of Obsidian accessible from the Home Assistant sidebar via Ingress.

It follows the "pure wrapper" philosophy – no Dockerfile here – so updates are instant and always track upstream.

⧖ No build chains. No overengineering. This is a fast lane from sidebar to second brain. Upstream fidelity meets Home Assistant elegance.

### Features

|   |   |
|---|---|
| **Pure wrapper, zero build‑time** | Pulls the official multi‑arch `lscr.io/linuxserver/obsidian` image – installs in seconds and stays upstream‑fresh. |
| **Ingress‑first UX** | Obsidian’s KasmVNC desktop appears in the HA sidebar – no extra ports or logins. |
| **Snapshot‑friendly** | Vault lives under `/data`; large browser caches are excluded from HA backups. |
| **Minimal setup** | Only `PUID`, `PGID`, and `TZ` options – sensible defaults included. |
| **Healthcheck & auto‑heal** | Supervisor monitors the UI and restarts automatically on failure. |
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

4. **Start** the add-on → **Open Web UI** (🧠 icon in sidebar = portal to your vault OS).
5. **Create your vault** inside `/config/MyVault` (maps to the add-on’s persistent storage).

The dev container runs `devcontainer_bootstrap` on startup to install test dependencies and start a lightweight Supervisor.

### Contributing

Reflective edits welcome – if your tweak adds resilience, elegance, or creative misuse potential, lean in and PR it.

Use commit messages prefixed with `ADDON-XXX:` where `XXX` matches the task ID.
Run `pre-commit run --all-files` and `ha dev addon lint` before pushing changes.

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

### Security & Resources

* Runs **unprivileged**; no `full_access` or extra capabilities by default.
* GPU passthrough is **deferred** to a future release.
* Automatic restart via healthcheck keeps the UI responsive.
* Typical idle RAM ≈ 350‑450 MB, peaks ≈ 600 MB during heavy vault sync
* CPU load is modest; rendering is software‑only in v0.1

---

### Troubleshooting

| Symptom | Fix |
|---------|-----|
| Blank screen / reconnect loop | Clear browser site‑data or restart the add‑on. |
| Vault not saved | Ensure you created it under `/config/…`; anything under `/home` vanishes on restart. |
| Add‑on keeps restarting | Check Supervisor log – watchdog fires if port 3000 stops responding. |
| `Failed to create gbm` in logs | `LIBGL_ALWAYS_SOFTWARE=1` is set by default; mount `/dev/dri` with the `video` group to enable passthrough. |

---

### Changelog

| Version | Date | Notes |
|---------|------|-------|
| `1.5.12` | 2025‑06‑22 | Initial public release – pure wrapper, Ingress, multi‑arch. |

---

Questions or feedback? [Open an issue on GitHub](https://github.com/adrianwedd/home-assistant-obsidian/issues) or join the discussion in the [Home Assistant Community](https://community.home-assistant.io/).

MIT © 2025 Adrian Wedd <adrian@adrianwedd.com>

Upstream image © LinuxServer.io (GPL‑v3)

⧖ You’re now operating at the edges of local-first knowledge management. No excuses. No bloat. Just Obsidian, everywhere.
