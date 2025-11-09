# Ogmios Scripts - Quick Reference Card

One-page reference for all verification scripts.

---

## Quick Start

```bash
# Run everything
./scripts/run-all-checks.sh

# Quick pre-commit check
./scripts/security-audit.sh --quick

# Full installation check
./scripts/verify-installation.sh
```

---

## All Scripts at a Glance

| Script | Purpose | Quick Flag | Time |
|--------|---------|------------|------|
| `verify-installation.sh` | 20+ checks of repo structure | `--quick` | 5-10s |
| `security-audit.sh` | Scan for personal data leaks | `--quick` | 10-15s |
| `check-documentation.sh` | Validate docs & links | `--quick` | 5s |
| `validate-cross-references.sh` | Check all references | `--verbose` | 3s |
| `validate-skills.sh` | Validate skill files | `--strict` | 5s |
| `validate-hooks.sh` | Check TypeScript hooks | `--syntax` | 10s |
| `count-stats.sh` | Generate statistics | `--json` | 1s |
| `run-all-checks.sh` | Run all above | `--quick` | 40s |

---

## Common Commands

### Before Commit
```bash
./scripts/security-audit.sh --quick
```

### Before Push
```bash
./scripts/run-all-checks.sh --quick
```

### Before Release
```bash
./scripts/run-all-checks.sh
```

### Update README Stats
```bash
./scripts/count-stats.sh --markdown > stats.md
```

### Check Specific Skill
```bash
./scripts/validate-skills.sh CORE
```

### Validate Hooks Only
```bash
./scripts/validate-hooks.sh --syntax
```

---

## Exit Codes

- **0** = Success
- **1** = Errors (fix before proceeding)
- **2** = Warnings only (safe to proceed)

---

## Output Formats

```bash
# count-stats.sh outputs
./scripts/count-stats.sh              # Colored terminal
./scripts/count-stats.sh --json       # JSON for parsing
./scripts/count-stats.sh --markdown   # Markdown table
```

---

## CI/CD Integration

```yaml
# GitHub Actions example
- name: Quality Checks
  run: ./scripts/run-all-checks.sh --ci
```

```bash
# Pre-commit hook
#!/bin/bash
./scripts/security-audit.sh --quick || exit 1
```

---

## Troubleshooting

```bash
# Script permission denied
chmod +x scripts/*.sh

# Python not found
brew install python3  # macOS
apt install python3   # Ubuntu

# Bun not found
curl -fsSL https://bun.sh/install | bash

# TypeScript errors but bun available
./scripts/validate-hooks.sh  # Uses bun automatically
```

---

## Dependencies

### Required
- bash, python3, find, grep, wc

### Optional (recommended)
- bun (for hook validation)
- tsc (alternative to bun)

---

## Help Flags

Every script has `--help`:

```bash
./scripts/verify-installation.sh --help
./scripts/security-audit.sh --help
./scripts/validate-skills.sh --help
# etc.
```

---

## File Locations

All scripts in `./scripts/`:
```
scripts/
├── verify-installation.sh       # Main installation check
├── security-audit.sh            # Security scanning
├── check-documentation.sh       # Docs validation
├── validate-cross-references.sh # Reference checking
├── validate-skills.sh           # Skills validation
├── validate-hooks.sh            # Hooks validation
├── count-stats.sh               # Statistics
├── run-all-checks.sh            # Master script
├── README.md                    # Full documentation
└── QUICK-REFERENCE.md           # This file
```

---

## Typical Workflow

### Daily Development
```bash
# Start of day
./scripts/verify-installation.sh --quick

# Before each commit
./scripts/security-audit.sh --quick

# End of day (if major changes)
./scripts/run-all-checks.sh --quick
```

### Before Pull Request
```bash
./scripts/run-all-checks.sh
./scripts/count-stats.sh --markdown > STATS.md
# Review all output, fix errors
```

### Before Release
```bash
./scripts/run-all-checks.sh
./scripts/security-audit.sh --report security-report.txt
# Must have 0 errors, 0 critical security issues
```

---

## Quick Checks Cheat Sheet

```bash
# Security
./scripts/security-audit.sh --quick

# Installation
./scripts/verify-installation.sh --quick

# Documentation
./scripts/check-documentation.sh --links

# Skills
./scripts/validate-skills.sh CORE

# Hooks
./scripts/validate-hooks.sh --syntax

# References
./scripts/validate-cross-references.sh

# Stats
./scripts/count-stats.sh
```

---

## Color Legend

- 🟢 Green `✅` = Passed
- 🟡 Yellow `⚠️` = Warning (non-critical)
- 🔴 Red `❌` = Error (must fix)
- 🔵 Blue `ℹ️` = Info

---

**Last Updated:** 2025-11-09
**Version:** 1.0.0

For full documentation, see `scripts/README.md`
