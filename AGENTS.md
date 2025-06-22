# AGENTS.md
Guidelines for AI (and human) contributors to **adrianwedd/home-assistant-obsidian**

This repository hosts a **pure-wrapper Home Assistant add-on** that embeds the
official `lscr.io/linuxserver/obsidian` container via Ingress.
The project is managed by granular tasks in `.codex/tasks.yml`.
Follow the rules below so automated tools, ChatGPT prompts, and human PRs all
produce consistent, merge-ready work.

---

## 1 ️⃣  Project pillars (never violate)

| Pillar | Why it matters |
|--------|----------------|
| **Pure wrapper** – no Dockerfile, only `image:` key | Keeps builds instant, leverages upstream multi-arch image. |
| **Init pattern** – `init: false` + `run.sh` → `exec /init` | Prevents double s6-overlay and mirrors official add-on style. |
| **Symlink fix** – `/config` → `/data` | Guarantees data persistence across restarts & upgrades. |
| **Ingress-first** – no host ports | Seamless SSO; smaller attack surface. |
| **Minimal privileges** – unprivileged by default | Security trumps convenience. `full_access:` is backlog only. |

Any change that breaks a pillar must raise an issue first.

---

## 2 ️⃣  Task workflow

### 2.1 `.codex/tasks.yml`
* Treat each `id:` as a single, atomic deliverable.

* Update the `status:` field (`todo` → `in-progress` → `done`) in the same PR
  that implements the task.

### 2.2 Commit message convention

ADDON-00X: short imperative summary

*One task per commit* unless trivially related (e.g., docs tweaks).

### 2.3 Pull-request checklist
- [ ] Task ID present in title & body
- [ ] `pre-commit run --all-files` passes (markdown-lint, shell-check, etc.)
- [ ] `ha dev addon lint` returns **0 errors / 0 warnings**
- [ ] Updated docs if user-visible behaviour changed

---

## 3 ️⃣  Branching & naming

| Purpose | Branch prefix | Example |
|---------|---------------|---------|
| Feature / task implementation | `feat/ADDON-004-` | `feat/ADDON-004-config-yaml` |
| Docs-only | `docs/ADDON-009-` | `docs/ADDON-009-readme` |
| CI / infra | `ci/` | `ci/github-actions-cache` |

PRs must target `main`.

---

## 4 ️⃣  Linting & CI

| Tool | Trigger | Notes |
|------|---------|-------|
| **Addon-linter** (`frenck/action-addon-linter`) | Every push / PR | Validates `config.yaml`, icons, translations. |
| **Release workflow** | Git tag `v*.*.*` | Bumps `version` in `config.yaml`, publishes GitHub Release. |
| **Renovate** | Nightly | Opens PR when new linuxserver/obsidian tag appears. |

Agents must **never** merge failing CI.

---

## 5 ️⃣  File-specific rules

| File | Who edits | Rule |
|------|-----------|------|
| `obsidian/config.yaml` | Tasks `ADDON-004`, `ADDON-008c`, `ADDON-013` only | `version:` **must equal** Docker image tag. |
| `run.sh` | Task `ADDON-005` | Keep shebang `#!/usr/bin/with-contenv bashio`. |
| `README.md` & `DOCS.md` | Task `ADDON-009` or docs fixes | Must stay in sync; update both. |
| `translations/en.yaml` | Task `ADDON-006` | Always valid YAML; keys match `config.yaml` options. |

---

## 6 ️⃣  Testing matrix (ADDON-012)

* **Dev-container (amd64)** – Mandatory
* **Raspberry Pi 4 (aarch64)** – Mandatory
* **x86-64 VM** – Mandatory
* **Pi 3 / armv7** – Optional but desirable

Record pass/fail and resource metrics in `/TESTS.md`.

---

## 7 ️⃣  Sensitive actions


| Action | Allowed by | Procedure |
|--------|-----------|-----------|
| Bumping `version` & image tag | `ADDON-013` release workflow only | Never bump manually outside the workflow. |
| Enabling `full_access` | Future task only | Must include detailed security rationale in PR. |
| Marketing / announcements | Out of scope | Not tracked in `.codex/tasks.yml`. |

---

## 8 ️⃣  Style guide (docs)

* Use sentence-case headings (`## Accessing Obsidian`)
* Wrap commands / paths in back-ticks.
* Keep line length ≤ 120 chars.
* Prefer ISO dates (`2025-06-22`).

---

## 9 ️⃣  When in doubt…

1. Search the official HA add-on docs.
2. Compare with patterns in **git_pull**, **glances**, **node-red** add-ons.
3. Open an issue tagged **question** before coding.

Happy hacking!
