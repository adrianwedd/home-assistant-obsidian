# 🧠 Obsidian – Home Assistant Community Add-on | Sidebar to Second Brain
*A private, full-desktop Obsidian vault streamed via KasmVNC and embedded directly in your Home Assistant UI.*

This repository wraps the `lscr.io/linuxserver/obsidian` container without a Dockerfile, keeping the add-on lightweight and always up to date.

⧖ This add-on is a conduit—not just a container. It gives you frictionless access to a private Obsidian vault, embedded seamlessly in your home infrastructure. No Dockerfile. No bloat. Just reflection.

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
| **Healthcheck & auto‑heal** | Supervisor monitors the UI and restarts automatically on failure. |
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

4. **Start** the add‑on → **Open Web UI** (🧠 icon = vault gateway).
5. **Create your vault** inside `/config/MyVault` (maps to the add‑on’s persistent storage).

---

## 🔒 Security & Resources

* Runs **unprivileged**; no `full_access` or extra capabilities by default.
* GPU passthrough is **deferred** to a future release.
* The dev container sets `LIBGL_ALWAYS_SOFTWARE=1` by default; mount `/dev/dri` with the `video` group for GPU passthrough.
* Automatic restart via healthcheck keeps the UI responsive.

GODMODE builds log performance snapshots to `/config/perf.json` and support reflective recovery cycles.

---

## 🛠 Development

```bash
git clone https://github.com/adrianwedd/home-assistant-obsidian
cd home-assistant-obsidian
code .
# Reopen in Dev Container → HA boots on http://localhost:8123
```

The container runs `devcontainer_bootstrap` on start to install test dependencies
and launch a lightweight Home Assistant Supervisor.

*Lint locally:* `ha dev addon lint`
CI must pass and docs remain in sync for PRs to be merged.

## Contributing

Use commit messages that start with `ADDON-XXX:` where `XXX` is the task number.
Reflective contributions welcome—if it improves clarity, containment, or vaultflow, it belongs here.
Run `pre-commit run --all-files` and `ha dev addon lint` before pushing.

## Example headless container

A sample Dockerfile and Helm chart live under `examples/obsidian-headless`. Build with `docker build -t obsidian-headless examples/obsidian-headless` and run `docker run --rm -p 6901:6901 obsidian-headless`.


---

## 🗺 Roadmap

* Optional GPU toggle (`video: true`) behind a UI switch
* Advanced KasmVNC settings (resolution, quality)
* CodeNotary signing prior to submission to the Community Add‑ons repo

---

## 📜 Licence

MIT © 2025 Adrian Wedd <adrian@adrianwedd.com>
Upstream image © LinuxServer.io (GPL‑v3)

⧖ Obsidian is not just where your notes go—it's where they grow. Vault on.
