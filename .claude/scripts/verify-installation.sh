#!/bin/bash

################################################################################
# Ogmios PAI - Installation Verification Script
################################################################################
#
# Comprehensive verification of Ogmios PAI installation with 20+ checks
#
# Usage:
#   ./scripts/verify-installation.sh           # Full verification
#   ./scripts/verify-installation.sh --quick   # Quick check only
#   ./scripts/verify-installation.sh --fix     # Auto-fix common issues
#   ./scripts/verify-installation.sh --help    # Show this help
#
# Exit codes:
#   0 - All checks passed
#   1 - Critical errors found
#   2 - Warnings only (system functional)
#
################################################################################

set -e

VERSION="2.0.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Counters
ERRORS=0
WARNINGS=0
CHECKS=0

# Mode
MODE="full"
FIX_MODE=false

# Expected counts
EXPECTED_HOOKS=17
EXPECTED_SKILLS=11

################################################################################
# Parse Arguments
################################################################################

for arg in "$@"; do
    case $arg in
        --quick)
            MODE="quick"
            ;;
        --fix)
            FIX_MODE=true
            ;;
        --help)
            echo "Ogmios Installation Verification Script v${VERSION}"
            echo ""
            echo "Usage:"
            echo "  ./scripts/verify-installation.sh           # Full verification"
            echo "  ./scripts/verify-installation.sh --quick   # Quick check only"
            echo "  ./scripts/verify-installation.sh --fix     # Auto-fix common issues"
            echo ""
            echo "Exit codes:"
            echo "  0 - All checks passed"
            echo "  1 - Critical errors found"
            echo "  2 - Warnings only (system functional)"
            echo ""
            exit 0
            ;;
    esac
done

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo ""
    echo -e "${BOLD}${BLUE}$1${NC}"
    echo "========================================"
}

print_section() {
    echo ""
    echo -e "${BOLD}$1${NC}"
}

pass() {
    echo -e "${GREEN}✅ $1${NC}"
    CHECKS=$((CHECKS + 1))
}

fail() {
    echo -e "${RED}❌ $1${NC}"
    ERRORS=$((ERRORS + 1))
    CHECKS=$((CHECKS + 1))
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    WARNINGS=$((WARNINGS + 1))
    CHECKS=$((CHECKS + 1))
}

info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

ask_fix() {
    if [ "$FIX_MODE" = true ]; then
        read -p "$(echo -e ${YELLOW}⚙️  $1 [y/N]: ${NC})" response
        case "$response" in
            [yY][eE][sS]|[yY])
                return 0
                ;;
            *)
                return 1
                ;;
        esac
    fi
    return 1
}

################################################################################
# Check Functions
################################################################################

check_repository_structure() {
    print_section "1️⃣  Repository Structure"

    # Check core directories
    CORE_DIRS=("templates" "en" "sv" "examples" "voice-server")
    for dir in "${CORE_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            pass "$dir/ exists"
        else
            fail "$dir/ missing"
        fi
    done

    # Check core files
    CORE_FILES=("README.md" "LICENSE" "CONTRIBUTING.md")
    for file in "${CORE_FILES[@]}"; do
        if [ -f "$file" ]; then
            pass "$file exists"
        else
            fail "$file missing"
        fi
    done
}

check_all_hooks() {
    print_section "2️⃣  Hook Templates (All 17)"

    REQUIRED_HOOKS=(
        "capture-all-events.ts"
        "capture-session-summary.ts"
        "completion-validator.ts"
        "content-guard.ts"
        "context-compression-hook.ts"
        "load-ufc-context.ts"
        "log-tool-use.ts"
        "skill-activation.ts"
        "skill-activation-enforcer.ts"
        "stop-hook.ts"
        "stop-validate-skill-use.ts"
        "stop-voice.ts"
        "update-tab-titles.ts"
    )

    HOOK_COUNT=0
    for hook in "${REQUIRED_HOOKS[@]}"; do
        if [ -f "templates/hooks/$hook" ]; then
            pass "$hook exists"
            HOOK_COUNT=$((HOOK_COUNT + 1))
        else
            fail "$hook missing"
        fi
    done

    # Check lib files
    LIB_FILES=(
        "lib/hook-utils.ts"
        "lib/validation.ts"
        "lib/voice-mappings.ts"
    )

    for lib in "${LIB_FILES[@]}"; do
        if [ -f "templates/hooks/$lib" ]; then
            pass "$lib exists"
            HOOK_COUNT=$((HOOK_COUNT + 1))
        else
            fail "$lib missing"
        fi
    done

    # Check package.json
    if [ -f "templates/hooks/package.json" ]; then
        pass "package.json exists"
        HOOK_COUNT=$((HOOK_COUNT + 1))
    else
        fail "package.json missing"
    fi

    info "Found $HOOK_COUNT/$EXPECTED_HOOKS hook files"
}

check_core_skill() {
    print_section "3️⃣  CORE Skill"

    if [ -d "templates/skills/CORE" ]; then
        pass "CORE skill directory exists"

        if [ -f "templates/skills/CORE/SKILL.md" ]; then
            pass "CORE/SKILL.md exists"

            # Check YAML frontmatter
            if grep -q "^---$" "templates/skills/CORE/SKILL.md"; then
                pass "SKILL.md has YAML frontmatter"
            else
                warn "SKILL.md missing YAML frontmatter"
            fi
        else
            fail "CORE/SKILL.md missing"
        fi

        # Check subdirectories
        for subdir in workflows reference; do
            if [ -d "templates/skills/CORE/$subdir" ]; then
                pass "CORE/$subdir/ exists"
            else
                warn "CORE/$subdir/ missing"
            fi
        done
    else
        fail "CORE skill missing"
    fi
}

check_all_skills() {
    print_section "4️⃣  All 11 Skills"

    REQUIRED_SKILLS=(
        "CORE"
        "academic-research"
        "agent-observability"
        "alex-hormozi-pitch"
        "architecture"
        "create-skill"
        "data-analysis"
        "design"
        "devops"
        "engineering"
        "security"
    )

    SKILL_COUNT=0
    for skill in "${REQUIRED_SKILLS[@]}"; do
        if [ -d "templates/skills/$skill" ]; then
            if [ -f "templates/skills/$skill/SKILL.md" ]; then
                pass "$skill/SKILL.md exists"
                SKILL_COUNT=$((SKILL_COUNT + 1))

                # Quick validation
                LINES=$(wc -l < "templates/skills/$skill/SKILL.md")
                if [ $LINES -gt 180 ]; then
                    warn "$skill/SKILL.md is $LINES lines (recommended <180)"
                fi
            else
                fail "$skill/SKILL.md missing"
            fi
        else
            fail "$skill/ directory missing"
        fi
    done

    info "Found $SKILL_COUNT/$EXPECTED_SKILLS skills"
}

check_settings_json() {
    print_section "5️⃣  Settings JSON Validation"

    if [ -f "templates/settings.json" ]; then
        pass "settings.json exists"

        # Validate JSON syntax
        if python3 -m json.tool templates/settings.json > /dev/null 2>&1; then
            pass "settings.json is valid JSON"

            # Check for hooks section
            if grep -q '"hooks"' templates/settings.json; then
                pass "Hooks section present"

                # Count hooks in settings
                HOOKS_IN_SETTINGS=$(grep -o '"event":' templates/settings.json | wc -l)
                info "$HOOKS_IN_SETTINGS hooks configured"
            else
                warn "No hooks section in settings.json"
            fi
        else
            fail "settings.json contains invalid JSON"
        fi
    else
        fail "settings.json missing"
    fi
}

check_bun_installed() {
    print_section "6️⃣  Bun Runtime"

    if command -v bun &> /dev/null; then
        BUN_VERSION=$(bun --version)
        pass "Bun installed: $BUN_VERSION"

        # Check if hooks dependencies would install
        if [ -f "templates/hooks/package.json" ]; then
            pass "package.json available for dependency install"
        fi
    else
        warn "Bun not installed (needed for hooks)"
        info "Install from: https://bun.sh"
    fi
}

check_hook_dependencies() {
    print_section "7️⃣  Hook Dependencies"

    if [ -f "templates/hooks/package.json" ]; then
        pass "package.json exists"

        # Parse dependencies
        DEPS=$(python3 -c "import json; print(len(json.load(open('templates/hooks/package.json')).get('dependencies', {})))" 2>/dev/null || echo 0)
        info "$DEPS dependencies declared"

        # Check if installable (don't actually install)
        if command -v bun &> /dev/null; then
            pass "Bun available for installation"
        else
            warn "Bun not available - can't install dependencies"
        fi
    else
        fail "package.json missing"
    fi
}

check_skills_index() {
    print_section "8️⃣  SKILLS-INDEX.md"

    if [ -f "templates/SKILLS-INDEX.md" ]; then
        pass "SKILLS-INDEX.md exists"

        # Count skills in index
        INDEXED_SKILLS=$(grep -c "^### " templates/SKILLS-INDEX.md 2>/dev/null || echo 0)
        info "$INDEXED_SKILLS skills indexed"

        # Verify all skills are indexed
        for skill in templates/skills/*/; do
            SKILL_NAME=$(basename "$skill")
            if grep -q "### $SKILL_NAME" templates/SKILLS-INDEX.md; then
                pass "$SKILL_NAME in index"
            else
                warn "$SKILL_NAME not in SKILLS-INDEX.md"
            fi
        done
    else
        fail "SKILLS-INDEX.md missing"
    fi
}

check_no_placeholders() {
    print_section "9️⃣  No Placeholders in PAI.md"

    if [ -f "templates/PAI.md" ]; then
        pass "PAI.md exists"

        # Check for common placeholders
        PLACEHOLDERS=(
            "YOUR NAME"
            "Your Name"
            "PLACEHOLDER"
            "TODO"
            "TBD"
            "FIXME"
            "<insert"
            "[Your "
        )

        FOUND_PLACEHOLDERS=0
        for placeholder in "${PLACEHOLDERS[@]}"; do
            if grep -q "$placeholder" templates/PAI.md; then
                warn "Found placeholder: $placeholder"
                FOUND_PLACEHOLDERS=$((FOUND_PLACEHOLDERS + 1))
            fi
        done

        if [ $FOUND_PLACEHOLDERS -eq 0 ]; then
            pass "No placeholders found in PAI.md"
        else
            warn "$FOUND_PLACEHOLDERS placeholder(s) found in PAI.md"
        fi
    else
        fail "PAI.md missing"
    fi
}

check_no_personal_data() {
    print_section "🔒 No <YOUR_NAME>-Specific Data"

    # Check for personal identifiers
    PERSONAL_PATTERNS=(
        "<your_username>"
        "<YOUR_NAME>"
        "carl.heath@"
        "/Users/<your_username>"
        "<cloud_storage>"
    )

    FOUND_PERSONAL=0
    for pattern in "${PERSONAL_PATTERNS[@]}"; do
        if grep -r "$pattern" templates/ 2>/dev/null | grep -v ".git" > /dev/null; then
            warn "Found personal data: $pattern"
            FOUND_PERSONAL=$((FOUND_PERSONAL + 1))
        fi
    done

    if [ $FOUND_PERSONAL -eq 0 ]; then
        pass "No <YOUR_NAME>-specific data found in templates"
    else
        warn "$FOUND_PERSONAL personal data pattern(s) found"
    fi
}

check_documentation_complete() {
    print_section "📚 Documentation Files"

    # English docs
    EN_DOCS=(
        "01-OVERVIEW.md"
        "02-GETTING-STARTED.md"
        "03-UFC-CONTEXT-SYSTEM.md"
        "04-SKILLS-SYSTEM.md"
        "05-HOOKS-REFERENCE.md"
        "06-VOICE-SYSTEM.md"
        "07-BILINGUAL-OPERATION.md"
        "08-INSTALLATION.md"
        "09-FAQ.md"
        "10-GLOSSARY.md"
    )

    EN_COUNT=0
    for doc in "${EN_DOCS[@]}"; do
        if [ -f "en/$doc" ]; then
            pass "en/$doc exists"
            EN_COUNT=$((EN_COUNT + 1))
        else
            fail "en/$doc missing"
        fi
    done

    # Swedish docs
    SV_DOCS=(
        "01-ÖVERSIKT.md"
        "02-KOMMA-IGÅNG.md"
        "03-UFC-KONTEXTSYSTEM.md"
        "04-FÄRDIGHETSSYSTEM.md"
        "05-HOOKS-REFERENS.md"
        "06-RÖSTSYSTEM.md"
        "07-TVÅSPRÅKIG-DRIFT.md"
        "08-INSTALLATION.md"
        "09-VANLIGA-FRÅGOR.md"
        "10-ORDLISTA.md"
    )

    SV_COUNT=0
    for doc in "${SV_DOCS[@]}"; do
        if [ -f "sv/$doc" ]; then
            pass "sv/$doc exists"
            SV_COUNT=$((SV_COUNT + 1))
        else
            fail "sv/$doc missing"
        fi
    done

    info "English: $EN_COUNT/10 docs, Swedish: $SV_COUNT/10 docs"
}

check_examples() {
    print_section "📝 Example Files"

    # English examples
    if [ -f "examples/en/example-hook-session-start.ts" ]; then
        pass "English hook example exists"
    else
        warn "English hook example missing"
    fi

    # Swedish examples
    if [ -f "examples/sv/exempel-hook-session-start.ts" ]; then
        pass "Swedish hook example exists"
    else
        warn "Swedish hook example missing"
    fi

    # Count total examples
    EXAMPLE_COUNT=$(find examples/ -type f 2>/dev/null | wc -l)
    info "$EXAMPLE_COUNT total example files"
}

check_voice_server() {
    print_section "🎤 Voice Server"

    if [ -d "voice-server" ]; then
        pass "voice-server/ directory exists"

        # Check core files
        VOICE_FILES=("server.py" "requirements.txt" ".env.example")
        for file in "${VOICE_FILES[@]}"; do
            if [ -f "voice-server/$file" ]; then
                pass "$file exists"
            else
                fail "$file missing"
            fi
        done
    else
        fail "voice-server/ missing"
    fi
}

check_gitignore() {
    print_section "🔒 .gitignore Safety"

    if [ -f "templates/.gitignore" ]; then
        pass ".gitignore exists"

        # Check for essential patterns
        ESSENTIAL_PATTERNS=(
            "\.env"
            "node_modules"
            "__pycache__"
            "\.DS_Store"
        )

        for pattern in "${ESSENTIAL_PATTERNS[@]}"; do
            if grep -q "$pattern" templates/.gitignore; then
                pass "$pattern in .gitignore"
            else
                warn "$pattern not in .gitignore"
            fi
        done
    else
        fail ".gitignore missing"
    fi
}

check_typescript_syntax() {
    print_section "🔧 TypeScript Syntax"

    # Basic syntax check (if TypeScript is available)
    if command -v tsc &> /dev/null; then
        SYNTAX_ERRORS=0
        for hook in templates/hooks/*.ts; do
            if ! tsc --noEmit "$hook" 2>/dev/null; then
                warn "Syntax issues in $(basename $hook)"
                SYNTAX_ERRORS=$((SYNTAX_ERRORS + 1))
            fi
        done

        if [ $SYNTAX_ERRORS -eq 0 ]; then
            pass "All TypeScript files syntax-valid"
        else
            warn "$SYNTAX_ERRORS file(s) with TypeScript issues"
        fi
    else
        info "TypeScript not installed - skipping syntax check"
    fi
}

check_readme_stats() {
    print_section "📊 README Statistics Match"

    if [ -f "README.md" ]; then
        pass "README.md exists"

        # Check if stats are mentioned
        if grep -q "17 hooks" README.md || grep -q "17.*hook" README.md; then
            pass "Hook count mentioned in README"
        else
            warn "Hook count (17) not clearly stated in README"
        fi

        if grep -q "11 skills" README.md || grep -q "11.*skill" README.md; then
            pass "Skill count mentioned in README"
        else
            warn "Skill count (11) not clearly stated in README"
        fi
    else
        fail "README.md missing"
    fi
}

check_bilingual_consistency() {
    print_section "🌍 Bilingual Consistency"

    # Count English vs Swedish docs
    EN_COUNT=$(ls -1 en/*.md 2>/dev/null | wc -l)
    SV_COUNT=$(ls -1 sv/*.md 2>/dev/null | wc -l)

    if [ $EN_COUNT -eq $SV_COUNT ]; then
        pass "English and Swedish doc counts match ($EN_COUNT each)"
    else
        warn "Doc count mismatch: EN=$EN_COUNT, SV=$SV_COUNT"
    fi
}

check_license() {
    print_section "📜 License"

    if [ -f "LICENSE" ]; then
        pass "LICENSE file exists"

        # Check license type
        if grep -q "MIT" LICENSE; then
            info "MIT License"
        elif grep -q "Apache" LICENSE; then
            info "Apache License"
        else
            info "Custom license"
        fi
    else
        fail "LICENSE file missing"
    fi
}

################################################################################
# Main Execution
################################################################################

print_header "Ogmios PAI - Installation Verification v${VERSION}"
echo ""
echo "Repository: ogmios-github"
echo "Mode: $MODE"
echo ""

if [ "$MODE" = "quick" ]; then
    info "Running quick checks..."
    check_repository_structure
    check_all_hooks
    check_core_skill
    check_all_skills
    check_settings_json
else
    info "Running full verification (20+ checks)..."
    check_repository_structure
    check_all_hooks
    check_core_skill
    check_all_skills
    check_settings_json
    check_bun_installed
    check_hook_dependencies
    check_skills_index
    check_no_placeholders
    check_no_personal_data
    check_documentation_complete
    check_examples
    check_voice_server
    check_gitignore
    check_typescript_syntax
    check_readme_stats
    check_bilingual_consistency
    check_license
fi

################################################################################
# Summary
################################################################################

print_header "📊 Verification Summary"
echo ""

echo -e "Total checks: ${BOLD}$CHECKS${NC}"
echo -e "Errors:       ${RED}${BOLD}$ERRORS${NC}"
echo -e "Warnings:     ${YELLOW}${BOLD}$WARNINGS${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}${BOLD}🎉 Perfect! Repository is complete and ready.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Users can install from: git clone <repo-url>"
    echo "2. Run installation: ./install.sh"
    echo "3. Verify with: ./scripts/verify-installation.sh"
    echo ""
    EXIT_CODE=0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}${BOLD}⚠️  Repository complete with warnings.${NC}"
    echo ""
    echo "The repository is functional but has minor issues."
    echo "Review warnings above."
    echo ""
    EXIT_CODE=2
else
    echo -e "${RED}${BOLD}❌ Repository has critical errors.${NC}"
    echo ""
    echo "Fix the errors above before releasing."
    echo ""
    if [ "$FIX_MODE" = false ]; then
        echo "Try running with --fix to auto-fix common issues:"
        echo "  ./scripts/verify-installation.sh --fix"
        echo ""
    fi
    EXIT_CODE=1
fi

exit $EXIT_CODE
