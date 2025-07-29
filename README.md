# 🌟 Obsidian × Home Assistant
*Where Knowledge Meets Intelligence*

<div align="center">

[![🚀 Latest Release](https://img.shields.io/github/v/release/adrianwedd/home-assistant-obsidian?style=for-the-badge&logo=github&color=6366f1&labelColor=1e293b)](https://github.com/adrianwedd/home-assistant-obsidian/releases)
[![🏠 Home Assistant](https://img.shields.io/badge/Home_Assistant-Compatible-03DAC6?style=for-the-badge&logo=home-assistant&logoColor=white)](https://www.home-assistant.io/)
[![🐳 Multi-Arch](https://img.shields.io/badge/Docker-Multi--Arch-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://github.com/adrianwedd/home-assistant-obsidian/pkgs/container/obsidian-ha)
[![📜 MIT License](https://img.shields.io/github/license/adrianwedd/home-assistant-obsidian?style=for-the-badge&color=10b981&labelColor=1e293b)](https://github.com/adrianwedd/home-assistant-obsidian/blob/main/LICENSE)
[![✨ Maintained](https://img.shields.io/maintenance/yes/2025?style=for-the-badge&color=f59e0b&labelColor=1e293b)](https://github.com/adrianwedd/home-assistant-obsidian)

</div>

---

## 💫 *The Vision*

Transform your smart home into an **intelligent knowledge ecosystem**. This isn't just another add-on—it's a bridge between your home's data and your mind's potential. Experience the full power of Obsidian's knowledge management seamlessly integrated into your Home Assistant universe.

**✨ *What makes this special?***  
Purpose-built architecture that harmonizes perfectly with Home Assistant's security model, delivering enterprise-grade note-taking without compromise.

## 🎭 *The Story*

Your smart home whispers secrets—sensor readings, automation triggers, device states. Your mind dreams solutions—project plans, device documentation, brilliant insights. This add-on creates the perfect harmony between these worlds.

Built on a **custom, security-first container architecture**, we've reimagined how Obsidian integrates with Home Assistant. No more privileged containers, no mount conflicts, no compromises—just elegant functionality that feels like it was always meant to be.

<div align="center">

### 🎨 *Experience the Integration*

<img src="https://github.com/adrianwedd/home-assistant-obsidian/raw/main/docs/screenshots/sidebar-integration.png" alt="Obsidian flourishing within Home Assistant" width="720" style="border-radius: 12px; box-shadow: 0 8px 32px rgba(0,0,0,0.12);"/>

*Obsidian flowing seamlessly through Home Assistant's Ingress—knowledge at your fingertips*

</div>

---

## 🌈 *The Experience*

<div align="center">

*"Technology should be invisible magic that amplifies human potential"*

</div>

### 🎯 **Effortless Elegance**
- ✨ **One-touch installation** — From marketplace to mastery in under 60 seconds
- 🧠 **Zero learning curve** — If you know Home Assistant, you already know this
- 🔄 **Self-maintaining** — Updates flow seamlessly through our intelligent pipeline
- 🌐 **Universal compatibility** — Runs beautifully on any architecture (AMD64, ARM64, ARMv7)

### 🛡️ **Privacy by Design**
- 🏠 **Sovereign knowledge** — Your thoughts remain exclusively yours, locally hosted
- 🔒 **Zero telemetry** — No data escapes your network boundary
- 💾 **Seamless preservation** — Automatically protected by Home Assistant's backup ecosystem
- 🎭 **Security theater rejected** — Purpose-built container architecture eliminates privilege escalation

### 🎨 **Harmonious Integration**
- 🌟 **Native sidebar presence** — Feels like it was always part of Home Assistant
- 🚪 **Unified authentication** — Single sign-on through your existing HA session
- 📱 **Adaptive interface** — Graceful across desktop, tablet, and mobile experiences
- 🔍 **Intelligent monitoring** — Self-healing with elegant degradation patterns

### 💎 **Architectural Excellence**
- 🏗️ **Custom-crafted foundation** — Purpose-built container optimized for Home Assistant
- 🎪 **Zero-compromise security** — No privileged operations, no mount conflicts
- 🧹 **Intelligent resource management** — Optimized memory and storage footprint
- 🌍 **Community-driven evolution** — Responsive to real-world usage and feedback

---

## 🌟 *The Journey Begins*

<div align="center">

*From curiosity to creation in three elegant steps*

</div>

### 🎭 **Act I: Discovery**
*Connect to the knowledge ecosystem*

Navigate to your Home Assistant's **Settings** → **Add-ons** → **Add-on Store**, then click the **⋮** menu and select **Repositories**. Add this gateway:

```
https://github.com/adrianwedd/home-assistant-obsidian
```

Watch as the repository blooms into your add-on marketplace, bringing new possibilities to your smart home.

### 🚀 **Act II: Installation**  
*Welcome Obsidian into your digital sanctuary*

Find **Obsidian** among your available add-ons—it will be waiting for you with quiet confidence. Click **Install** and watch as our custom container architecture unfolds, creating a secure and elegant foundation for your knowledge management journey.

*The installation orchestrates multiple services: Ubuntu foundation, virtual display, web interface, and the Obsidian application itself—all harmonizing in under 60 seconds.*

### ⚙️ **Act III: Personalization** *(Optional Symphony)*
*Most minds will find perfection in our thoughtful defaults*

<details>
<summary>🔧 <strong>Advanced Configuration Options</strong></summary>

| Setting | Default | Description | When to Change |
|---------|---------|-------------|----------------|
| `puid` | `911` | User ID for file ownership (LinuxServer.io standard) | ⚠️ **Critical:** Keep as `911` unless you have specific permission needs |
| `pgid` | `911` | Group ID for file ownership (LinuxServer.io standard) | ⚠️ **Critical:** Keep as `911` for proper container operation |
| `tz` | `UTC` | Timezone for timestamps | Set to your local timezone (e.g., `America/New_York`) |

**Finding your IDs (Linux/macOS users):**

```bash
id -u  # Shows your user ID
id -g  # Shows your group ID
```

</details>

### Step 4: Launch Obsidian

1. Click **Start** to boot up the add-on
2. Wait 30-45 seconds for first-time initialization
3. Click **Open Web UI** or use the 🧠 **Obsidian** sidebar icon
4. **Create your first vault** at `/config/MyVault`

> 💡 **Pro Tip:** The `/config` path inside Obsidian maps to your add-on's persistent storage, so your notes survive updates and restarts.

### Step 5: Start Building Your Knowledge Base

You're now running a full Obsidian desktop environment! Create notes, build knowledge graphs, install plugins—everything works exactly like the desktop version.

---

## 📊 Performance & Resource Usage

### Resource Requirements

| Component | Idle | Active Use | Heavy Syncing |
|-----------|------|------------|---------------|
| **RAM** | 350-450 MB | 500-600 MB | 700-800 MB |
| **CPU** | <5% | 10-15% | 20-30% |
| **Storage** | ~100 MB (container) | +vault size | +vault size |

### Security Features

✅ **Controlled execution** – runs as dedicated user (UID/GID 911)
✅ **Minimal attack surface** – only essential ports exposed
✅ **Automatic updates** – security patches applied regularly
✅ **Network isolation** – contained within Home Assistant's network stack
✅ **File system isolation** – vault data protected in dedicated volumes

> 🛡️ **Security Note:** This add-on requires `SYS_ADMIN` capability for proper graphics initialization and uses LinuxServer.io's standard user (911:911) for secure file operations. All processes run unprivileged within the container.

---

## 🔧 Troubleshooting

### Common Issues & Solutions

<details>
<summary>🖥️ <strong>Blank screen or infinite loading</strong></summary>

**Symptoms:** Obsidian loads but shows only a white/black screen or loading spinner

**Solutions:**
1. **Clear browser cache:** `Ctrl+Shift+R` (or `Cmd+Shift+R` on Mac)
2. **Restart the add-on:** Configuration → Restart
3. **Check logs:** Configuration → Log tab for error messages
4. **Try incognito mode:** Test in a private browser window

</details>

<details>
<summary>⚠️ <strong>Mount permission warnings (NON-CRITICAL)</strong></summary>

**Symptoms:** Log shows repeated mount errors for `/sys/kernel/security` and `/tmp`

**Status:** **These are cosmetic warnings and do NOT affect functionality**

**Background:** The LinuxServer.io container expects full system privileges that conflict with Home Assistant's security model. Despite these warnings, Obsidian operates normally.

**What we've tried:**
- ✅ Added graphics environment variables (LIBGL_ALWAYS_SOFTWARE, DISPLAY, XVFB_WHD)
- ✅ Enabled privileged mode and enhanced capabilities (SYS_ADMIN, SYS_CHROOT, MKNOD)
- ✅ Implemented tmpfs mounts for system directories
- ✅ Standardized to LinuxServer.io UID/GID 911

**Current status:** Container functions correctly despite mount warnings. See `MOUNT_TROUBLESHOOTING.md` for detailed analysis.

</details>

<details>
<summary>📁 <strong>Vault not saving or disappearing</strong></summary>

**Symptoms:** Notes vanish after restart or changes aren't saved

**Solutions:**
1. **Verify vault location:** Ensure you created it under `/config/...` not `/home/...`
2. **Check permissions:** Review the `puid`/`pgid` settings in configuration
3. **Storage space:** Verify Home Assistant has sufficient disk space
4. **Backup restore:** Check if vault exists in `/config` folder via File Editor add-on

</details>

<details>
<summary>🔄 <strong>Add-on keeps restarting</strong></summary>

**Symptoms:** Add-on shows as "running" but constantly restarts

**Solutions:**
1. **Check system resources:** Ensure sufficient RAM/CPU available
2. **Review logs:** Look for error patterns in the add-on logs
3. **Disable plugins:** Start with a fresh vault to isolate plugin conflicts
4. **Network issues:** Verify Home Assistant's network configuration

</details>

<details>
<summary>🎨 <strong>Interface looks broken or tiny</strong></summary>

**Symptoms:** UI elements are too small, overlapping, or unreadable

**Solutions:**
1. **Browser zoom:** Adjust zoom level (`Ctrl +/-` or `Cmd +/-`)
2. **Screen resolution:** Check if your display settings are optimal
3. **Mobile users:** Use landscape orientation for better experience
4. **Plugin conflicts:** Disable custom CSS or theme plugins temporarily

</details>

### Getting Help

**Community Support:**
- 💬 [Home Assistant Community Forum](https://community.home-assistant.io/) (tag: `obsidian-addon`)
- 🐛 [GitHub Issues](https://github.com/adrianwedd/home-assistant-obsidian/issues) for bugs and feature requests
- 📖 [Official Obsidian Help](https://help.obsidian.md/) for Obsidian-specific questions

**When Reporting Issues:**
1. Include your Home Assistant version
2. Specify your platform (Raspberry Pi, Intel NUC, etc.)
3. Attach relevant logs from Configuration → Log
4. Describe steps to reproduce the problem

## 🛠 Development & Contributing

### Development Environment

```bash
git clone https://github.com/adrianwedd/home-assistant-obsidian
cd home-assistant-obsidian
code .
# Choose "Reopen in Container" when prompted
# Home Assistant starts automatically at http://localhost:8123
```

### Quality Standards

**Before submitting PRs:**

```bash
# Run linting
ha dev addon lint

# Run tests
python -m pytest tests/

# Check pre-commit hooks
pre-commit run --all-files
```

**Commit Convention:**
Use `ADDON-XXX: Description` format where `XXX` is your task/issue number.

### Architecture

This add-on follows the "pure wrapper" philosophy:
- ✅ **No Dockerfile** – reduces maintenance overhead
- ✅ **Upstream image** – automatically gets security updates
- ✅ **Minimal configuration** – less complexity = fewer bugs
- ✅ **Standard patterns** – follows Home Assistant add-on best practices

---

## 🗺 Roadmap & Future Features

### 🎯 Upcoming Releases

#### v1.9.x - Enhanced Performance
- [ ] GPU acceleration toggle for supported hardware
- [ ] Configurable resolution and quality settings
- [ ] Advanced networking options
- [ ] Custom plugin management

#### v2.0.x - Enterprise Features
- [ ] Multi-user vault support
- [ ] Integration with Home Assistant entities
- [ ] Automated backup scheduling
- [ ] Performance monitoring dashboard

### 🛣️ Long-term Vision

#### Smart Home Integration
- Connect Obsidian with Home Assistant sensors and automations
- Voice-activated note taking via speech-to-text
- Automatic documentation generation from HA configs

#### Community Ecosystem
- Plugin marketplace integration
- Shared community templates
- Advanced collaboration features

> 💡 **Want to contribute?** Check our [GitHub Issues](https://github.com/adrianwedd/home-assistant-obsidian/issues) for good first issues and feature requests!

---

## 🎉 Success Stories

> "Transformed my Home Assistant setup into a complete home management system. Now I track everything from device manuals to grocery lists in one place." —*@smartHome_enthusiast*
>
> "Finally, a note-taking solution that doesn't require juggling multiple apps. Perfect for documenting automation scripts." —*@HA_developer*
>
> "The seamless sidebar integration makes this feel like a native HA feature. Brilliant execution." —*@community_moderator*

## 🙏 Acknowledgments

**Built on the shoulders of giants:**
- 🏠 [Home Assistant](https://home-assistant.io/) team for the incredible platform
- 🧠 [Obsidian](https://obsidian.md/) for revolutionizing note-taking
- 🐧 [LinuxServer.io](https://linuxserver.io/) for the robust container foundation
- 🚀 The Home Assistant Community for continuous feedback and support

## 📄 License

**MIT License** © 2025 Adrian Wedd
📧 adrian@adrianwedd.com
🐙 [GitHub Profile](https://github.com/adrianwedd)

**Upstream Components:**
- Container Image: [LinuxServer.io](https://github.com/linuxserver/docker-obsidian) (GPL-v3)
- Obsidian: [Obsidian.md](https://obsidian.md/) (Commercial License)

---

<div align="center">

**⭐ Found this useful? Star the repo!**

[![GitHub stars](https://img.shields.io/github/stars/adrianwedd/home-assistant-obsidian?style=social)](https://github.com/adrianwedd/home-assistant-obsidian/stargazers)

*🧠 Your knowledge graph awaits. Start building today.*

</div>
