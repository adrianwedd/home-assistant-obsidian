# Obsidian – Home Assistant Community Add-on
*A private, full-desktop Obsidian vault streamed via KasmVNC and embedded directly in your Home Assistant UI.*

This repository wraps the `lscr.io/linuxserver/obsidian` container without a Dockerfile, keeping the add-on lightweight and always up to date.

[![Lint](https://github.com/adrianwedd/home-assistant-obsidian/actions/workflows/lint.yml/badge.svg)](https://github.com/adrianwedd/home-assistant-obsidian/actions/workflows/lint.yml)
[![Release](https://img.shields.io/github/v/release/adrianwedd/home-assistant-obsidian?sort=semver)](https://github.com/adrianwedd/home-assistant-obsidian/releases)
![Maintenance](https://img.shields.io/maintenance/yes/2025)

---

## ✨ Features

|   |   |
|---|---|
| **Pure wrapper, zero build‑time** | Pulls the official multi‑arch `lscr.io/linuxserver/obsidian` image – installs in seconds and stays upstream‑fresh. |
| **Ingress‑first UX** | Obsidian’s KasmVNC desktop appears in the HA sidebar – no extra ports or logins. |
| **Snapshot‑friendly** | Vault lives under `/data`; large browser caches are excluded from HA backups. |
| **Minimal setup** | Only `PUID`, `PGID`, and `TZ` options – sensible defaults included. |
| **Watchdog & auto‑heal** | Supervisor pings the UI every 60 s and restarts automatically on failure. |
| **CI‑powered updates** | Renovate + GitHub Actions bump the image tag and publish signed releases. |

---

## 🚀 Quick Start

1. **Add repository**
   *Settings → Add‑ons → Add‑on Store → ⋮ → Repositories →*

   ```text
   https://github.com/adrianwedd/home-assistant-obsidian
   ```

2. **Install** the **Obsidian** add‑on.
3. **Configure** (optional – defaults work on many systems):

   | Option | Default | Notes |
   |--------|---------|-------|
   | `puid` | `1000`  | Numeric user ID for file ownership. Run `id -u` on Linux. |
   | `pgid` | `1000`  | Numeric group ID. Run `id -g` on Linux. |
   | `tz`   | `UTC`   | Time‑zone string, e.g. `Europe/London`. |

4. **Start** the add‑on → **Open Web UI** (or click the 🧠 Obsidian icon in the sidebar).
5. **Create your vault** inside `/config/MyVault` (maps to the add‑on’s persistent storage).

---

## 🔒 Security & Resources

* Runs **unprivileged**; no `full_access` or extra capabilities by default.
* GPU passthrough is **deferred** to a future release.
* Memory hint set to **512 MB** – HA will warn (but not block) on 1 GB devices.
* Watchdog at `http://[HOST]:3000/` ensures automatic recovery if the VNC stack freezes.

---

## 🛠 Development

```bash
git clone https://github.com/adrianwedd/home-assistant-obsidian
cd home-assistant-obsidian
code .
# Reopen in Dev Container → HA boots on http://localhost:8123
```

*Lint locally:* `ha dev addon lint`
CI must pass and docs remain in sync for PRs to be merged.

---

## 🗺 Roadmap

* Optional GPU toggle (`video: true`) behind a UI switch
* Advanced KasmVNC settings (resolution, quality)
* CodeNotary signing prior to submission to the Community Add‑ons repo

---

## 📜 Licence

MIT © 2025 Adrian Wedd <adrian@adrianwedd.com>

Upstream image © LinuxServer.io (GPL‑v3)
