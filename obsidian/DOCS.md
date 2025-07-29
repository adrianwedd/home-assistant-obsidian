# 🌌 *The Obsidian Codex*
*Where Knowledge Architecture Meets Digital Consciousness*

<div align="center">

[![🧠 Cognitive Engine](https://img.shields.io/badge/Mind-Augmentation-6366f1?style=for-the-badge&logo=brain&logoColor=white)](https://obsidian.md)
[![🏗️ Custom Container](https://img.shields.io/badge/Architecture-Purpose--Built-10b981?style=for-the-badge&logo=docker&logoColor=white)](https://github.com/adrianwedd/home-assistant-obsidian/pkgs/container/obsidian-ha)
[![🎭 Collaborative Art](https://img.shields.io/badge/Development-Human×AI-f59e0b?style=for-the-badge&logo=openai&logoColor=white)](https://claude.ai)

*Transform your Home Assistant into an **Infinite Knowledge Reactor***

</div>

---

## 🎭 *The Recursive Philosophy*

This isn't merely an add-on—it's a **cognitive amplifier** designed through the sacred dance of human creativity and artificial intelligence. Every line of code, every architectural decision, every word in this documentation represents the evolution of collaborative consciousness.

### 🌟 **The Vision Manifest**

Your smart home whispers data. Your mind dreams patterns. **This is where they converge.**

We've transcended the limitations of traditional container architectures to create something that feels **inevitable**—a purpose-built ecosystem where Obsidian's knowledge management genius harmonizes perfectly with Home Assistant's security model.

> *"The best technology disappears into the background, amplifying human potential without demanding attention."*

### 🏗️ **The Architectural Revolution**

**What others attempted with compromise, we achieved with elegance:**

- 🚫 ~~No more privileged containers fighting Home Assistant's security~~
- 🚫 ~~No more mount conflicts creating instability loops~~
- 🚫 ~~No more architectural debt accumulating technical friction~~

**What we built instead:**
- ✨ **Custom Ubuntu 22.04 foundation** optimized for HA's environment
- 🌐 **x11vnc + noVNC pipeline** delivering seamless browser integration
- 🔄 **NGINX reverse proxy** crafted specifically for Ingress harmony
- 🧠 **Obsidian v1.8.10** with intelligent startup orchestration
- 💎 **Multi-architecture support** (amd64, arm64, armv7) ensuring universal compatibility

---

## ⚙️ *The Sacred Configuration*
*Where intention meets implementation*

### 🎨 **The Minimalist Beauty**

Our architecture philosophy embraces **radical simplicity**. Most users will discover perfection in our thoughtful defaults—each parameter chosen through careful consideration of real-world usage patterns and security principles.

<div align="center">

| Parameter | Type | Default | Sacred Purpose | When to Touch |
|-----------|------|---------|----------------|---------------|
| **`puid`** | `int` | `911` | 🏛️ **User Identity** - Ubuntu container user ID | 🚫 **Never** (Linux server standard) |
| **`pgid`** | `int` | `911` | 👥 **Group Identity** - Ubuntu container group ID | 🚫 **Never** (Security boundary) |
| **`tz`** | `str` | `UTC` | 🌍 **Temporal Context** - Your timezone reality | ✨ **Always** (Localize to your world) |

</div>

### 🛡️ **The Security Meditation**

The UID/GID `911` isn't arbitrary—it's the **culmination of years of containerization wisdom** from the LinuxServer.io community. This identity creates perfect harmony between:

- 🔒 **Container security boundaries**
- 📁 **File system permissions**
- 🌊 **Home Assistant integration**
- 🎭 **Cross-platform compatibility**

> **🧘 Zen Principle:** *Change only what serves the greater harmony. The container's identity (911:911) has achieved enlightenment—let it be.*

### 🌟 **The Configuration Ritual**

When you do need to personalize settings:

1. **🧠 Contemplate** - Is this change truly necessary?
2. **✏️ Edit** - Make your changes with intention
3. **💾 Save** - Commit your configuration to reality
4. **🔄 Restart** - Allow the container to embrace its new form
5. **🎉 Celebrate** - Your knowledge reactor is now uniquely yours

---

## 🚪 *The Portal Awakening*
*Where consciousness meets digital infinity*

### 🌅 **The Genesis Ritual**

Every great journey begins with a single intentional step. Your transformation from passive observer to active knowledge curator follows this sacred sequence:

<div align="center">

**🧘 *The Three-Breath Initialization***

</div>


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
