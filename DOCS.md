## Obsidian – Home Assistant Add‑on

This add‑on wraps the official **linuxserver/obsidian** container, giving you a full desktop version of Obsidian accessible from the Home Assistant sidebar via Ingress.

It follows the "pure wrapper" philosophy – no Dockerfile here – so updates are instant and always track upstream.

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

### Resource Use

* Typical idle RAM ≈ 350‑450 MB, peaks ≈ 600 MB during heavy vault sync  
* CPU load is modest; rendering is software‑only in v1.0  
* The add‑on reserves **512 MB** (`memory:` hint) – low‑RAM devices may show a Supervisor warning  
* Watchdog monitors `http://[HOST]:3000/` to keep the UI responsive

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
| `1.0.0` | 2025‑06‑22 | Initial public release – pure wrapper, Ingress, multi‑arch. |

---

Questions or feedback? [Open an issue on GitHub](https://github.com/adrianwedd/home-assistant-obsidian/issues) or join the discussion in the [Home Assistant Community](https://community.home-assistant.io/).
