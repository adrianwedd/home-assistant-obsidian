# 🧠 Obsidian Add-on Documentation

## Complete guide to running Obsidian inside Home Assistant

This add-on provides the full Obsidian desktop experience directly in your Home Assistant sidebar. Built on the proven `lscr.io/linuxserver/obsidian` container, it delivers enterprise-grade note-taking with zero configuration complexity.

> **🎯 Perfect for:** Home automation documentation, device manuals, project planning, personal knowledge management, and building your digital second brain.

---

## 📋 Table of Contents

1. [Quick Start Guide](#-quick-start-guide)
2. [Configuration Options](#️-configuration-options)
3. [Creating & Managing Vaults](#-creating--managing-vaults)
4. [Data Management & Backups](#-data-management--backups)
5. [Performance Optimization](#-performance-optimization)
6. [Troubleshooting Guide](#-troubleshooting-guide)
7. [Advanced Features](#️-advanced-features)
8. [Security Considerations](#-security-considerations)
9. [Integration Tips](#-integration-tips)
10. [Version History](#-version-history)

---

## 🚀 Quick Start Guide

### Prerequisites

- Home Assistant OS, Supervised, or Container installation
- Minimum 4GB RAM (8GB recommended)
- 2GB free storage space
- Modern web browser (Chrome, Firefox, Safari, Edge)

### Installation Steps

1. **Add Repository**
   - Navigate to **Settings** → **Add-ons** → **Add-on Store**
   - Click **⋮** (menu) → **Repositories**
   - Add: `https://github.com/adrianwedd/home-assistant-obsidian`

2. **Install Add-on**
   - Find **Obsidian** in the store
   - Click **Install** and wait for completion

3. **First Launch**
   - Click **Start** to initialize the add-on
   - Wait 30-45 seconds for container startup
   - Click **Open Web UI** or use the 🧠 sidebar icon

4. **Create Your Vault**
   - In Obsidian, select **Create new vault**
   - Name it and set location to `/config/MyVault`
   - Start taking notes immediately!

---

## ⚙️ Configuration Options

### Basic Settings

The add-on works perfectly with default settings for most users. Only modify these if you have specific requirements:

| Setting | Default | Purpose | Example |
|---------|---------|---------|----------|
| `puid` | `1000` | User ID for file ownership | `1000` (find with `id -u`) |
| `pgid` | `1000` | Group ID for file ownership | `1000` (find with `id -g`) |
| `tz` | `UTC` | Timezone for timestamps | `America/New_York`, `Europe/London` |

### When to Change Settings

**User/Group IDs (`puid`/`pgid`):**
- ✅ Keep defaults unless you have file permission issues
- ⚠️ Change only if running Home Assistant with custom user accounts
- 🔧 Linux users: run `id -u` and `id -g` to find your IDs

**Timezone (`tz`):**
- ✅ Set to your local timezone for accurate timestamps
- 📝 Use standard timezone names (e.g., `Asia/Tokyo`)
- 🌍 See [TimeZone List](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for options

### Configuration Example

```yaml
# Example configuration for Eastern Time user
puid: 1000
pgid: 1000
tz: "America/New_York"
```

> 💡 **Tip:** After changing settings, click **Save** then **Restart** the add-on for changes to take effect.

---

## 📁 Creating & Managing Vaults

### Vault Creation Best Practices

#### ✅ Recommended Approach

1. **Always use `/config/` path**
   - Create vaults under `/config/MyVault`
   - This ensures data persistence across restarts
   - Automatically included in Home Assistant backups

2. **Vault Naming Convention**
   - Use clear, descriptive names: `HomeAutomation`, `DeviceManuals`, `ProjectNotes`
   - Avoid special characters and spaces
   - Consider date prefixes for project vaults: `2025-SmartHome`

#### ❌ Common Mistakes

- **Never use `/home/` paths** – data will be lost on restart
- **Avoid system directories** like `/tmp/` or `/var/`
- **Don't create vaults in root** (`/`) directory

### Vault Organization Strategies

#### Single Large Vault

```text
/config/MainVault/
├── 01-Inbox/           # Quick capture
├── 02-Home-Assistant/  # HA documentation
├── 03-Devices/         # Device manuals
├── 04-Projects/        # Active projects
├── 05-Archive/         # Completed items
└── Templates/          # Note templates
```

#### Multiple Specialized Vaults

```text
/config/
├── HomeAssistant/      # HA configs & automations
├── DeviceManuals/      # Equipment documentation
├── PersonalNotes/      # Private notes
└── ProjectPlanning/    # Active projects
```

### Vault Migration & Import

#### From Desktop Obsidian

1. **Copy your existing vault** to `/config/YourVaultName/`
2. **Use File Editor add-on** or SFTP to transfer files
3. **Verify plugins** work in the web environment
4. **Update file paths** in any automation scripts

#### From Other Note Apps

- **Notion:** Use Notion's export → Markdown option
- **Evernote:** Export to ENEX, convert using tools like Yarle
- **OneNote:** Export pages individually as Markdown
- **Joplin:** Direct export to Obsidian format available

---

## 💾 Data Management & Backups

### Automatic Backup Integration

#### Home Assistant Snapshots

✅ **Included Automatically**
- All vault data under `/config/` is backed up
- Plugin configurations preserved
- Custom themes and snippets included

✅ **Optimized for Size**
- Browser caches excluded (`BrowserCache/`, `.cache/`)
- Temporary files filtered out
- Efficient compression applied

#### Backup Schedule Recommendations

```yaml
# Example Home Assistant backup automation
automation:
  - alias: "Weekly Obsidian Backup"
    trigger:
      platform: time
      at: "02:00:00"
    condition:
      condition: time
      weekday:
        - sun
    action:
      service: hassio.backup_full
      data:
        name: "Weekly-{{ now().strftime('%Y%m%d') }}"
```

### Manual Backup Strategies

#### Local Backups

1. **File Editor Method**
   - Use Home Assistant's File Editor add-on
   - Navigate to `/config/` and download vault folders
   - Create regular ZIP archives

2. **SFTP/SSH Method**

   ```bash
   # From external machine
   scp -r root@homeassistant.local:/config/MyVault/ ./backups/
   ```

3. **Git Version Control**

   ```bash
   # Inside your vault directory
   git init
   git add .
   git commit -m "Initial vault backup"
   git remote add origin https://github.com/yourusername/obsidian-vault
   git push -u origin main
   ```

#### Cloud Backup Options

- **Git-based:** GitHub, GitLab (for text-based vaults)
- **Sync services:** Use with caution – may conflict with Obsidian's file handling
- **Manual upload:** Periodic manual uploads to cloud storage

### Data Recovery Procedures

#### Restoring from Home Assistant Backup

1. Navigate to **Settings** → **System** → **Backups**
2. Select backup containing your vault data
3. Choose **Restore** → **Configuration**
4. Restart add-on after restoration

#### Manual Restoration

1. Stop the Obsidian add-on
2. Use File Editor to clear `/config/YourVault/`
3. Upload backup files to the same location
4. Restart the add-on
5. Verify data integrity

---

## ⚡ Performance Optimization

### System Requirements by Usage

| Use Case | RAM | CPU | Storage | User Count |
|----------|-----|-----|---------|------------|
| **Light** (few notes, basic features) | 2GB | 2 cores | 1GB | 1-2 users |
| **Medium** (daily use, plugins) | 4GB | 2 cores | 5GB | 2-3 users |
| **Heavy** (large vaults, heavy plugins) | 8GB | 4 cores | 10GB+ | 3+ users |

### Performance Monitoring

#### Resource Usage Patterns

```text
Typical RAM Usage:
├── Container Base: ~200MB
├── Obsidian App: ~300-400MB
├── Plugins: ~50-100MB per plugin
└── Cache/Buffers: ~100-200MB

Total: 650-900MB for normal usage
```

#### Performance Indicators

**🟢 Good Performance:**
- Page loads < 3 seconds
- Typing lag < 100ms
- Plugin actions < 1 second
- Search results < 2 seconds

**🟡 Degraded Performance:**
- Page loads 3-10 seconds
- Noticeable typing lag
- Plugin delays 1-3 seconds

**🔴 Poor Performance:**
- Page loads > 10 seconds
- Significant input lag
- Frequent disconnections

### Optimization Strategies

#### For Low-Resource Systems

1. **Minimize Active Plugins**
   - Disable unused community plugins
   - Use lightweight themes
   - Reduce auto-save frequency

2. **Vault Management**
   - Keep individual notes under 10MB
   - Use folder structure instead of excessive tagging
   - Archive old projects regularly

3. **Browser Optimization**
   - Close unused browser tabs
   - Use ad blockers to reduce memory usage
   - Enable hardware acceleration if available

#### For High-Performance Systems

1. **Enable Advanced Features**
   - Install performance-heavy plugins
   - Use complex themes and customizations
   - Enable real-time collaboration features

2. **Increase Resource Limits** (Advanced)

   ```yaml
   # In Home Assistant configuration.yaml
   homeassistant:
     packages:
       obsidian_tweaks:
         hassio:
           addon_configs:
             local_obsidian:
               memory_limit: "2048MB"
   ```

---

## 🔧 Troubleshooting Guide

### Diagnostic Steps

#### Step 1: Check Add-on Status

1. Navigate to **Settings** → **Add-ons** → **Obsidian**
2. Verify add-on shows **"Running"** status
3. Check **Log** tab for error messages
4. Note the **Version** currently installed

#### Step 2: Test Basic Connectivity

1. Click **Open Web UI** button
2. Check if Obsidian interface loads
3. Try creating a test note
4. Verify note saves successfully

#### Step 3: Browser Diagnostics

1. Open browser **Developer Tools** (F12)
2. Check **Console** tab for JavaScript errors
3. Monitor **Network** tab for failed requests
4. Try accessing from different browser/device

### Common Issues & Solutions

#### 🖥️ Interface Problems

#### Blank/Black Screen

```text
Symptoms: Obsidian loads but shows empty screen
Causes: Browser cache, X server issues, resource constraints

Solutions:
1. Hard refresh browser (Ctrl+Shift+R)
2. Clear browser cache and cookies
3. Restart add-on from Configuration tab
4. Try incognito/private browsing mode
5. Check available system RAM
```

#### Tiny/Oversized Interface

```text
Symptoms: UI elements too small or large
Causes: Browser zoom, display scaling, theme issues

Solutions:
1. Adjust browser zoom (Ctrl+Plus/Minus)
2. Check display scaling settings
3. Reset Obsidian appearance settings
4. Disable custom CSS themes temporarily
```

#### Constant Reconnection

```text
Symptoms: "Reconnecting..." message appears frequently
Causes: Network issues, resource exhaustion, container restarts

Solutions:
1. Check Home Assistant network stability
2. Monitor system resource usage
3. Review add-on logs for restart patterns
4. Reduce plugin load if using many community plugins
```

#### 📁 Data & Vault Issues

#### Vault Not Found/Missing

```text
Symptoms: Vault disappears after restart
Causes: Incorrect vault path, storage issues

Solutions:
1. Verify vault was created under /config/
2. Check Home Assistant storage space
3. Use File Editor to browse /config/ directory
4. Restore from Home Assistant backup if needed
```

#### Permission Errors

```text
Symptoms: Cannot save files, "Permission denied" errors
Causes: Incorrect PUID/PGID settings

Solutions:
1. Check puid/pgid configuration values
2. Ensure they match your system user ID
3. Restart add-on after changing settings
4. Use default values (1000/1000) if unsure
```

#### Sync Conflicts

```text
Symptoms: Duplicate files, merge conflicts
Causes: Multiple Obsidian instances, external sync

Solutions:
1. Use only one Obsidian instance at a time
2. Disable external sync services (Dropbox, Google Drive)
3. Resolve conflicts manually in Obsidian
4. Consider using Obsidian Sync for multi-device access
```

#### 🔄 Performance Issues

#### Slow Loading

```text
Symptoms: Pages take >10 seconds to load
Causes: Large vaults, many plugins, insufficient resources

Solutions:
1. Disable unnecessary community plugins
2. Archive old/large files
3. Increase system RAM if possible
4. Use simpler themes
5. Check for corrupted cache files
```

#### High Resource Usage

```text
Symptoms: System becomes sluggish, high CPU/RAM
Causes: Memory leaks, runaway plugins, large media files

Solutions:
1. Restart add-on to clear memory leaks
2. Identify resource-heavy plugins
3. Optimize media file sizes
4. Monitor usage patterns in HA System tab
```

### Advanced Diagnostics

#### Log Analysis

**Key Log Patterns:**

```bash
# Normal startup
[INFO] Starting Obsidian add-on...
[INFO] Container started successfully
[INFO] Obsidian accessible at port 3000

# Permission issues
[ERROR] Permission denied: /config/vault
[WARN] PUID/PGID mismatch detected

# Resource constraints
[WARN] Low memory warning
[ERROR] Container killed due to OOM

# X server problems
[ERROR] Failed to initialize X server
[ERROR] /dev/dri device not accessible
```

#### Container Health Checks

```bash
# From Home Assistant SSH add-on
docker ps | grep obsidian
docker logs addon_local_obsidian
docker stats addon_local_obsidian
```

### Emergency Recovery

#### Complete Reset Procedure

1. **Stop the add-on**
2. **Backup vault data** (if accessible)
3. **Uninstall and reinstall** the add-on
4. **Reconfigure** with default settings
5. **Restore vault** from backup
6. **Test basic functionality**

#### Data Recovery from Snapshots

1. Navigate to **Settings** → **System** → **Backups**
2. Find backup containing your vault
3. Download backup file
4. Extract and locate `/config/` folder
5. Manually restore vault files

---

## 🎛️ Advanced Features

### Plugin Management

#### Recommended Plugins for Home Assistant Users

**Essential Productivity:**
- **Dataview** – Query and display vault data
- **Templater** – Advanced note templates
- **Tag Wrangler** – Organize tags efficiently
- **Quick Switcher++** – Enhanced file navigation

**Home Assistant Integration:**
- **Advanced Tables** – Format device inventories
- **Excalidraw** – Network diagrams and layouts
- **Mind Map** – Visualize automation logic
- **Kanban** – Track project status

#### Plugin Safety Guidelines

✅ **Safe Practices:**
- Install plugins one at a time
- Test thoroughly after each installation
- Keep plugins updated regularly
- Backup vault before major plugin changes

⚠️ **Caution Areas:**
- Sync plugins (may conflict with HA backups)
- Beta/experimental plugins
- Plugins requiring network access
- Memory-intensive visualization plugins

### Custom CSS & Themes

#### Home Assistant-Inspired Themes

```css
/* Custom CSS for HA-style dark theme */
.theme-dark {
  --background-primary: #111111;
  --background-secondary: #1b1b1b;
  --text-accent: #03a9f4;
  --interactive-accent: #03a9f4;
}

/* HA-style cards */
.markdown-preview-view .mod-header {
  background: var(--background-secondary);
  border-radius: 8px;
  padding: 16px;
  margin: 8px 0;
}
```

#### Theme Management

1. Navigate to **Settings** → **Appearance**
2. Choose **Dark** or **Light** base theme
3. Install community themes from **Community Themes**
4. Apply custom CSS in **CSS Snippets**

### Automation Integration Ideas

#### Note Templates for HA

**Device Documentation Template:**

```markdown
# {{title}}

## Device Information
- **Manufacturer:**
- **Model:**
- **Purchase Date:**
- **Location:**
- **HA Entity ID:**

## Configuration
```yaml
# Home Assistant configuration

```text

## Troubleshooting
- [ ] Power cycle device
- [ ] Check network connectivity
- [ ] Verify HA integration

## Notes

```

**Automation Documentation:**
```markdown
# {{title}} Automation

## Purpose

## Triggers
- [ ] Time-based
- [ ] State change
- [ ] Manual

## Actions
1.
2.
3.

## Testing Notes

```

### Keyboard Shortcuts

#### Essential Shortcuts

| Action | Shortcut | Description |
|--------|----------|-------------|
| **Quick Switcher** | `Ctrl+O` | Open any file quickly |
| **Command Palette** | `Ctrl+P` | Access all commands |
| **New Note** | `Ctrl+N` | Create new note |
| **Search** | `Ctrl+Shift+F` | Global vault search |
| **Toggle Preview** | `Ctrl+E` | Switch edit/preview |
| **Link Note** | `[[` | Create internal link |
| **Tag** | `#` | Add tags |
| **Bold** | `Ctrl+B` | Bold text |
| **Italic** | `Ctrl+I` | Italic text |

#### Custom Shortcuts Setup

1. Open **Settings** → **Hotkeys**
2. Search for desired command
3. Click pencil icon to set shortcut
4. Test shortcut works correctly

---

## 🔒 Security Considerations

### Container Security

#### Built-in Security Features

✅ **Unprivileged Execution**
- Add-on runs without root privileges
- Limited system access by design
- Isolated from host filesystem

✅ **Network Isolation**
- Traffic routed through HA Ingress
- No direct external network access
- Protected by HA authentication

✅ **Resource Limits**
- Memory and CPU constraints applied
- Prevents resource exhaustion attacks
- Automatic restart on failure

#### Required Privileges

⚠️ **SYS_ADMIN Capability**
- Purpose: X server initialization only
- Scope: Limited to display management
- Alternative: None available for GUI apps

⚠️ **Device Access (/dev/dri)**
- Purpose: Hardware graphics acceleration
- Benefit: Improved performance on supported hardware
- Risk: Minimal – read-only graphics device access

### Data Protection

#### Vault Security

**Encryption at Rest:**
- Use Home Assistant's backup encryption
- Consider full-disk encryption on host
- Encrypt sensitive notes using Obsidian plugins

**Access Control:**
- Leverage HA user authentication
- Configure user permissions appropriately
- Monitor access logs regularly

**Network Security:**

```yaml
# Example firewall rule (iptables)
# Block direct container access
iptables -A INPUT -p tcp --dport 3000 -j DROP

# Allow only through HA proxy
iptables -A INPUT -s 172.30.0.0/16 -p tcp --dport 3000 -j ACCEPT
```

### Best Practices

#### Vault Hygiene

1. **Regular Security Reviews**
   - Audit plugin permissions
   - Review custom CSS for security issues
   - Check for sensitive data in notes

2. **Access Monitoring**
   - Enable HA authentication logs
   - Monitor unusual access patterns
   - Set up alerts for failed logins

3. **Backup Security**
   - Encrypt backup files
   - Store backups securely
   - Test recovery procedures

#### Plugin Security

```markdown
# Plugin Security Checklist
- [ ] Plugin from trusted developer
- [ ] Recent updates and maintenance
- [ ] No excessive permissions requested
- [ ] Positive community feedback
- [ ] No network/external API requirements
```

### Compliance Considerations

**For Enterprise Users:**
- Ensure vault data meets retention policies
- Document security controls implemented
- Regular security assessments
- User access auditing

**For Personal Users:**
- Consider local regulations (GDPR, etc.)
- Protect personal information appropriately
- Regular backup testing

---

## 🔗 Integration Tips

### Home Assistant Integration

#### Documenting Your Smart Home

**Configuration Management:**

```markdown
# Device Registry in Obsidian
## Living Room
- **Smart TV**: `media_player.living_room_tv`
  - IP: 192.168.1.100
  - Last Updated: 2025-01-15
  - Issues: [[TV Troubleshooting Guide]]

- **Light Strip**: `light.living_room_strip`
  - Zones: 3 segments
  - Automation: [[Evening Lighting Scene]]
```

**Automation Documentation:**

```markdown
# Morning Routine Automation

## Trigger
- Time: 07:00 weekdays
- Condition: Someone home

## Actions
1. [[Lights Gradually Brighten]]
2. [[Coffee Maker Start]]
3. [[News Briefing Play]]

## YAML
```yaml
automation:
  - alias: "Morning Routine"
    trigger:
      platform: time
      at: "07:00:00"
```

#### Cross-Referencing with HA

**Entity Documentation:**
- Create notes for each major device
- Link related automations and scenes
- Track maintenance schedules
- Document troubleshooting steps

**Project Planning:**
- Use Obsidian for planning HA projects
- Track device shopping lists
- Document installation procedures
- Plan automation logic flows

### Workflow Integration

#### Daily Operations

1. **Morning Review**
   - Check overnight automation logs
   - Review device status notes
   - Plan daily HA maintenance

2. **Configuration Changes**
   - Document changes in Obsidian first
   - Test configurations
   - Update documentation post-deployment

3. **Issue Tracking**
   - Create troubleshooting notes
   - Link to relevant device documentation
   - Track resolution steps

#### Long-term Planning

- **Home Improvement Projects**
  - Integration with existing HA setup
  - Device compatibility research
  - Budget and timeline tracking

- **System Evolution**
  - Migration planning between HA versions
  - Device lifecycle management
  - Performance optimization notes

---

## 📈 Version History

### Current Release: v1.8.10-ls75 (2025-07-28)

**🎯 Major Improvements:**
- Switched to `lscr.io/linuxserver/obsidian` for enhanced stability
- Fixed X server startup issues with proper privilege configuration
- Added multi-architecture support (amd64, aarch64, armv7, armhf)
- Improved container health monitoring
- Enhanced backup integration with HA snapshots

**🔧 Technical Changes:**
- Required `SYS_ADMIN` privilege for X server initialization
- Added `/dev/dri` device access for hardware acceleration
- Updated ingress configuration for better performance
- Optimized cache exclusions for smaller backups

**🐛 Bug Fixes:**
- Resolved "Failed to create gbm" X server errors
- Fixed container restart loops on resource-constrained systems
- Corrected file permission issues with default PUID/PGID
- Improved startup reliability on ARM64 systems

### Previous Releases

#### v1.5.14 (2025-07-23)
- Updated to `sytone/obsidian-remote` headless image
- Implemented KasmVNC-based web interface
- Added basic ingress support
- Initial multi-architecture testing

#### v1.5.13 (2025-07-20)
- Enhanced configuration validation
- Improved error logging and diagnostics
- Added automated testing pipeline
- Updated documentation structure

#### v1.5.12 (2025-07-15)
- Initial stable release
- Basic Obsidian web interface
- Home Assistant integration
- Snapshot backup support

### Upgrade Notes

#### Migrating from v1.5.x

1. **Backup your vault** before upgrading
2. **Stop the add-on** completely
3. **Update** to latest version
4. **Verify configuration** settings
5. **Start add-on** and test functionality
6. **Check logs** for any startup issues

#### Breaking Changes

**v1.8.x Series:**
- Container image changed from `sytone/obsidian-remote` to `lscr.io/linuxserver/obsidian`
- Additional privileges required (`SYS_ADMIN`, `/dev/dri`)
- Port changed from 8080 to 3000 (automatically handled)

### Development Roadmap

#### v1.9.x (Planned - Q2 2025)
- **GPU Acceleration Toggle** – Optional hardware acceleration
- **Advanced Networking** – Custom resolution and quality settings
- **Plugin Management** – Pre-installed plugin bundles
- **Performance Monitoring** – Built-in resource usage dashboard

#### v2.0.x (Planned - Q3 2025)
- **Multi-User Support** – Separate vaults per HA user
- **HA Entity Integration** – Direct sensor/device documentation
- **Automated Backups** – Scheduled vault backups independent of HA
- **API Integration** – REST API for external vault access

#### v2.1.x (Planned - Q4 2025)
- **Voice Integration** – Speech-to-text note creation
- **Mobile Optimization** – Enhanced mobile web interface
- **Collaboration Features** – Real-time collaborative editing
- **Advanced Security** – Vault-level encryption options

### Support & Community

**Getting Help:**
- 📖 **Documentation:** This comprehensive guide
- 💬 **Community Forum:** [Home Assistant Community](https://community.home-assistant.io/)
- 🐛 **Bug Reports:** [GitHub Issues](https://github.com/adrianwedd/home-assistant-obsidian/issues)
- ✨ **Feature Requests:** [GitHub Discussions](https://github.com/adrianwedd/home-assistant-obsidian/discussions)

**Contributing:**
- 🔧 **Code Contributions:** Fork → Develop → Pull Request
- 📝 **Documentation:** Improve this guide via GitHub
- 🧪 **Testing:** Beta test new features
- 💡 **Ideas:** Share use cases and workflow improvements

---

<div align="center">

**📚 Questions? Found a bug? Want to contribute?**

[📖 Read the Docs](https://github.com/adrianwedd/home-assistant-obsidian) • [💬 Community Forum](https://community.home-assistant.io/) • [🐛 Report Issues](https://github.com/adrianwedd/home-assistant-obsidian/issues) • [⭐ Star on GitHub](https://github.com/adrianwedd/home-assistant-obsidian)

*🧠 Building knowledge graphs, one note at a time.*

</div>
