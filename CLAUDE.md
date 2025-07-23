# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Home Assistant Community Add-on that wraps the `lscr.io/linuxserver/obsidian` container to provide Obsidian as an embedded web UI within Home Assistant. The add-on is designed as a pure wrapper without a Dockerfile, keeping it lightweight and always up-to-date with the upstream container.

## Architecture

- **obsidian/**: Contains the Home Assistant add-on configuration
  - `config.yaml`: Main add-on configuration with version, image reference, and options schema
  - `run.sh`: Add-on startup script
  - `finish.sh`: Cleanup script
  - `translations/en.yaml`: UI text translations
- **tests/**: Python test suite
  - `test_version_sync.py`: Validates config.yaml structure
  - `smoke_test.py`: Integration test that runs the container and validates HTTP response
- **examples/obsidian-headless/**: Standalone Docker setup with Helm chart
- **scripts/**: Development utilities
  - `check_commit_msg.sh`: Git hook for enforcing commit message format

## Development Commands

### Linting

```bash
ha dev addon lint
```

This is the primary linting command used in CI and should be run before commits.

### Testing

```bash
# Run all tests
python -m pytest tests/

# Run specific test
python -m pytest tests/test_version_sync.py
python -m pytest tests/smoke_test.py
```

### Pre-commit Hooks

```bash
pre-commit run --all-files
```

### Development Environment
The repository includes a dev container configuration. After cloning:

```bash
# Reopen in Dev Container → HA boots on http://localhost:8123
```

## Key Configuration Files

- `obsidian/config.yaml`: Core add-on configuration. The `image` field must NOT include a tag (validated by tests), and `version` must be specified.
- `repository.yaml`: Home Assistant add-on repository metadata

## Commit Convention

All commit messages must start with `ADDON-XXX:` where `XXX` is a task number. This is enforced by `scripts/check_commit_msg.sh`.

## CI/CD

- **Lint workflow**: Runs `frenck/action-addon-linter` on the `obsidian/` directory
- **Release workflow**: Automated releases via GitHub Actions
- **Renovate**: Automated dependency updates via `renovate.json`

## Important Notes

- The add-on is a wrapper around an upstream container, not a custom build
- Version management is handled through `obsidian/config.yaml`
- Backup exclusions are configured to skip browser caches
- The add-on runs unprivileged by default for security
