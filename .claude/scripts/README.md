# Ogmios PAI - Verification and Quality Control Scripts

This directory contains comprehensive validation and quality control scripts for the Ogmios PAI repository.

## Overview

All scripts are designed to be run from the repository root:

```bash
./scripts/script-name.sh [options]
```

Each script:
- Has a `--help` flag for detailed usage
- Returns proper exit codes (0 = success, 1 = errors, 2 = warnings)
- Works on both macOS and Linux
- Provides colored, structured output

---

## Scripts

### 1. verify-installation.sh

**Purpose:** Comprehensive installation verification with 20+ checks

**Usage:**
```bash
./scripts/verify-installation.sh           # Full verification
./scripts/verify-installation.sh --quick   # Quick check only
./scripts/verify-installation.sh --fix     # Auto-fix common issues
```

**Checks:**
- Repository structure (templates, en, sv, examples)
- All 17 hooks present
- CORE skill exists
- All 11 skills have SKILL.md
- settings.json valid JSON
- Bun installed
- Hook dependencies installable
- SKILLS-INDEX.md complete
- No placeholders in PAI.md
- No <YOUR_NAME>-specific data in templates
- Documentation files (English + Swedish)
- Voice server structure
- .gitignore safety
- TypeScript syntax (if tsc available)
- README statistics match reality
- Bilingual consistency
- License file

**Example:**
```bash
$ ./scripts/verify-installation.sh

Ogmios PAI - Installation Verification v2.0.0
==============================================

Repository: ogmios-github
Mode: full

Running full verification (20+ checks)...

1️⃣  Repository Structure
✅ templates/ exists
✅ en/ exists
✅ sv/ exists
...

📊 Verification Summary
==============================================

Total checks: 45
Errors:       0
Warnings:     2

🎉 Repository complete with warnings.
```

---

### 2. security-audit.sh

**Purpose:** Scan for personal data leaks and security issues

**Usage:**
```bash
./scripts/security-audit.sh                    # Full audit
./scripts/security-audit.sh --quick            # Quick scan
./scripts/security-audit.sh --report FILE      # Save report
```

**Scans for:**
- Email addresses (excluding allowed examples)
- Phone numbers (all formats)
- Real names (except documented personas)
- API keys and tokens
- Private file paths (/Users/*, OneDrive, etc.)
- IP addresses (excluding localhost)
- Hardcoded credentials
- Sensitive comments (TODO password, etc.)
- .env files (should not be in repo)

**Example:**
```bash
$ ./scripts/security-audit.sh --report security-report.txt

Ogmios PAI - Security Audit v1.0.0
==============================================

Scanning 234 files in 5 directories

📧 Email Addresses
✅ No unauthorized emails found

📱 Phone Numbers
✅ No phone numbers found

👤 Real Names (Non-Persona)
✅ No personal names found

🔑 API Keys and Tokens
✅ No API keys found

📁 Private File Paths
⚠️  WARNING: Private path found: templates/PAI.md:42
   Content: Example path for documentation

...

📊 Security Audit Summary
==============================================

Files scanned:    234
Critical issues:  0
Warnings:         1

⚠️  Warnings found.

No critical issues, but review warnings above.
```

---

### 3. check-documentation.sh

**Purpose:** Validate documentation completeness and consistency

**Usage:**
```bash
./scripts/check-documentation.sh           # Full check
./scripts/check-documentation.sh --quick   # Quick check
./scripts/check-documentation.sh --links   # Check links only
```

**Validates:**
- Cross-reference validity
- English/Swedish parity (document count and content)
- Broken internal links
- Code example validity (syntax checks)
- Statistics accuracy in README
- Header consistency
- YAML frontmatter in skills
- Table of Contents in major docs

**Example:**
```bash
$ ./scripts/check-documentation.sh --links

Ogmios Documentation Check v1.0.0
==============================================

Checking links only...

🔗 Cross-Reference Validity
✅ en/01-OVERVIEW.md: All references valid
✅ sv/01-ÖVERSIKT.md: All references valid
...

🔗 Internal Link Validity
✅ All internal links valid

📊 Documentation Check Summary
==============================================

Total checks: 15
Errors:       0
Warnings:     0

🎉 Documentation is perfect!
```

---

### 4. validate-cross-references.sh

**Purpose:** Validate all file references across the repository

**Usage:**
```bash
./scripts/validate-cross-references.sh              # Full validation
./scripts/validate-cross-references.sh --verbose    # Detailed output
```

**Validates:**
- Skills in SKILLS-INDEX exist
- ADRs in decisions.md exist (if present)
- Examples in README exist
- Hook references in settings.json exist
- Cross-references between skills
- Documentation file references

**Example:**
```bash
$ ./scripts/validate-cross-references.sh --verbose

Ogmios Cross-Reference Validation v1.0.0
==============================================

Verbose mode enabled - showing all checks

1️⃣  Skills in SKILLS-INDEX
   Found indexed skill: CORE
   Found indexed skill: academic-research
...
✅ ✓ CORE
✅ ✓ academic-research
...

2️⃣  ADRs in decisions.md
✅ decisions.md exists
   Found ADR reference: ADR-001
   Found ADR reference: ADR-002
...

📊 Validation Summary
==============================================

Total checks: 42
Errors:       0
Warnings:     0

🎉 All cross-references are valid!
```

---

### 5. validate-skills.sh

**Purpose:** Validate skill structure, YAML, and content

**Usage:**
```bash
./scripts/validate-skills.sh              # Validate all
./scripts/validate-skills.sh CORE         # Validate specific
./scripts/validate-skills.sh --strict     # Strict mode
```

**Validates:**
- YAML frontmatter format (opening and closing ---)
- Required fields (name, description, version)
- Optional fields (category, tags, author)
- File size (<180 lines recommended)
- Directory structure (workflows/, reference/)
- Content quality (sections, word count, code blocks)
- Metadata consistency (name matches directory)
- Internal links validity

**Example:**
```bash
$ ./scripts/validate-skills.sh CORE

Ogmios Skills Validation v1.0.0
==============================================

🔍 Validating: CORE

✅ CORE: SKILL.md exists
✅ CORE: Valid YAML frontmatter delimiters
✅ CORE: Has name:
✅ CORE: Has description:
✅ CORE: Has version:
✅ CORE: Has category: (optional)
ℹ️  CORE: 165 lines
✅ CORE: File size OK (165/180 lines)
✅ CORE: workflows/ directory exists
   3 workflow file(s)
✅ CORE: reference/ directory exists
   5 reference file(s)
✅ CORE: Has description section
✅ CORE: Has usage section
✅ CORE: Has examples section
✅ CORE: Good content depth (842 words)
✅ CORE: Contains 4 code block(s)
✅ CORE: YAML name matches directory
✅ CORE: Valid version format (1.0.0)
✅ CORE: All internal links valid

📊 Validation Summary
==============================================

Total checks: 18
Errors:       0
Warnings:     0

🎉 All skills are valid!
```

---

### 6. validate-hooks.sh

**Purpose:** Validate hooks, TypeScript syntax, and dependencies

**Usage:**
```bash
./scripts/validate-hooks.sh           # Full validation
./scripts/validate-hooks.sh --syntax  # Syntax check only
./scripts/validate-hooks.sh --deps    # Dependencies only
```

**Validates:**
- Hooks in settings.json exist
- TypeScript syntax valid (requires tsc or bun)
- Dependencies installable
- Proper exports (export default)
- Common patterns (error handling)
- Library imports valid

**Example:**
```bash
$ ./scripts/validate-hooks.sh

Ogmios Hooks Validation v1.0.0
==============================================

Running full hook validation...

1️⃣  Hooks in settings.json
✅ settings.json exists
✅ settings.json is valid JSON
✅ ✓ load-ufc-context.ts
✅ ✓ skill-activation.ts
✅ ✓ stop-voice.ts
...
ℹ️  Found 12 hook(s), 0 missing

2️⃣  TypeScript Syntax
✅ TypeScript compiler available: Version 5.2.2
✅ load-ufc-context.ts: Valid TypeScript
✅ skill-activation.ts: Valid TypeScript
...
✅ All TypeScript files valid

3️⃣  Dependencies
✅ package.json exists
✅ package.json is valid JSON
ℹ️  8 dependencies declared
✅ Bun available for dependency installation
✅ Dependencies are installable

📊 Validation Summary
==============================================

Total checks: 38
Errors:       0
Warnings:     0

🎉 All hooks are valid!
```

---

### 7. count-stats.sh

**Purpose:** Generate statistics for README and documentation

**Usage:**
```bash
./scripts/count-stats.sh              # Display stats
./scripts/count-stats.sh --json       # JSON output
./scripts/count-stats.sh --markdown   # Markdown table
```

**Counts:**
- Total skills
- Total hooks
- Hook libraries
- Context files
- Workflow files
- Example files
- English docs
- Swedish docs
- Lines of code (TypeScript, Python, Markdown)
- Languages supported
- Total repository files

**Example (display):**
```bash
$ ./scripts/count-stats.sh

Ogmios PAI - Repository Statistics
==============================================

📦 Components
  Skills:              11
  Hooks:               17
  Hook Libraries:      3
  Context Files:       8
  Workflow Files:      15
  Example Files:       4

📚 Documentation
  English Docs:        10
  Swedish Docs:        10
  Total Docs:          20

💻 Code
  TypeScript Lines:    3,245
  Python Lines:        567
  Markdown Lines:      4,892
  Total LOC:           8,704

🌍 Languages
  Supported:           2 (English, Swedish)

📊 Repository
  Total Files:         234

Statistics generated successfully!
```

**Example (JSON):**
```bash
$ ./scripts/count-stats.sh --json

{
  "generated": "2025-11-09T18:45:00Z",
  "components": {
    "skills": 11,
    "hooks": 17,
    "hook_libraries": 3,
    "context_files": 8,
    "workflow_files": 15,
    "example_files": 4
  },
  "documentation": {
    "english": 10,
    "swedish": 10,
    "total": 20
  },
  "code": {
    "typescript_lines": 3245,
    "python_lines": 567,
    "markdown_lines": 4892,
    "total_loc": 8704
  },
  "languages": {
    "count": 2,
    "supported": ["English", "Swedish"]
  },
  "repository": {
    "total_files": 234
  }
}
```

**Example (Markdown):**
```bash
$ ./scripts/count-stats.sh --markdown

# Ogmios PAI - Repository Statistics

Generated: Sat Nov  9 18:45:00 CET 2025

## Components

| Component | Count |
|-----------|-------|
| Skills | 11 |
| Hooks | 17 |
| Hook Libraries | 3 |
...
```

---

## Exit Codes

All scripts use standard exit codes:

- **0** - Success (all checks passed)
- **1** - Errors found (critical issues)
- **2** - Warnings only (functional but improvable)

---

## Dependencies

### Required (for full functionality)

- **bash** - All scripts are bash scripts
- **python3** - JSON validation, data extraction
- **find, grep, wc** - File operations (standard Unix tools)

### Optional (enables additional features)

- **bun** - TypeScript validation, dependency checks
- **tsc** - TypeScript syntax validation (alternative to bun)
- **node** - Some dependency checks

### Platform Support

All scripts work on:
- macOS (primary development platform)
- Linux (tested on Ubuntu, Debian, Arch)
- BSD (should work, not extensively tested)

---

## Integration

### CI/CD Pipeline

Use these scripts in your CI/CD:

```yaml
# .github/workflows/validate.yml
name: Validate Repository

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install Bun
        uses: oven-sh/setup-bun@v1

      - name: Security Audit
        run: ./scripts/security-audit.sh

      - name: Verify Installation
        run: ./scripts/verify-installation.sh

      - name: Validate Skills
        run: ./scripts/validate-skills.sh

      - name: Validate Hooks
        run: ./scripts/validate-hooks.sh

      - name: Check Documentation
        run: ./scripts/check-documentation.sh

      - name: Validate Cross-References
        run: ./scripts/validate-cross-references.sh
```

### Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "Running security audit..."
./scripts/security-audit.sh --quick || exit 1

echo "Validating hooks..."
./scripts/validate-hooks.sh || exit 1

echo "All checks passed!"
```

### Development Workflow

Recommended order during development:

1. **Before commit:** `./scripts/security-audit.sh --quick`
2. **After changes:** `./scripts/verify-installation.sh`
3. **Before PR:** All scripts in full mode
4. **After PR merge:** Update stats in README

---

## Troubleshooting

### "Command not found: bun"

Install Bun:
```bash
curl -fsSL https://bun.sh/install | bash
```

Or use TypeScript compiler:
```bash
npm install -g typescript
```

### "Python not found"

Install Python 3:
```bash
# macOS
brew install python3

# Ubuntu/Debian
sudo apt install python3

# Arch Linux
sudo pacman -S python
```

### "Permission denied"

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

### "Invalid JSON in settings.json"

Validate JSON manually:
```bash
python3 -m json.tool templates/settings.json
```

---

## Contributing

When adding new scripts:

1. Follow existing naming convention: `verb-noun.sh`
2. Include `--help` flag with usage instructions
3. Use proper exit codes (0/1/2)
4. Add colored output (GREEN/RED/YELLOW/BLUE)
5. Support both macOS and Linux
6. Document in this README
7. Make executable: `chmod +x scripts/new-script.sh`

---

## License

Same as Ogmios PAI repository (see LICENSE file).

---

**Last Updated:** 2025-11-09
**Version:** 1.0.0
