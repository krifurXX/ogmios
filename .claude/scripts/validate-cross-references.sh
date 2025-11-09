#!/bin/bash

################################################################################
# Ogmios PAI - Cross-Reference Validation Script
################################################################################
#
# Validates all file references across the repository
#
# Usage:
#   ./scripts/validate-cross-references.sh              # Full validation
#   ./scripts/validate-cross-references.sh --verbose    # Detailed output
#   ./scripts/validate-cross-references.sh --help       # Show this help
#
# Exit codes:
#   0 - All references valid
#   1 - Broken references found
#
################################################################################

set -e

VERSION="1.0.0"

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
VERBOSE=false

################################################################################
# Parse Arguments
################################################################################

for arg in "$@"; do
    case $arg in
        --verbose)
            VERBOSE=true
            ;;
        --help)
            echo "Ogmios Cross-Reference Validation Script v${VERSION}"
            echo ""
            echo "Usage:"
            echo "  ./scripts/validate-cross-references.sh           # Full validation"
            echo "  ./scripts/validate-cross-references.sh --verbose # Detailed output"
            echo ""
            echo "Validates:"
            echo "  - Skills in SKILLS-INDEX exist"
            echo "  - ADRs in decisions.md exist"
            echo "  - Examples in README exist"
            echo "  - File references in documentation"
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

verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${BLUE}   $1${NC}"
    fi
}

################################################################################
# Validation Functions
################################################################################

validate_skills_index() {
    print_section "1️⃣  Skills in SKILLS-INDEX"

    if [ ! -f "templates/SKILLS-INDEX.md" ]; then
        fail "SKILLS-INDEX.md not found"
        return
    fi

    pass "SKILLS-INDEX.md exists"

    # Extract skill names from index
    INDEXED_SKILLS=()
    while IFS= read -r line; do
        if [[ "$line" =~ ^###[[:space:]]+(.+)$ ]]; then
            SKILL_NAME="${BASH_REMATCH[1]}"
            INDEXED_SKILLS+=("$SKILL_NAME")
            verbose "Found indexed skill: $SKILL_NAME"
        fi
    done < templates/SKILLS-INDEX.md

    info "Found ${#INDEXED_SKILLS[@]} indexed skills"

    # Check if each indexed skill exists
    MISSING_COUNT=0
    for skill in "${INDEXED_SKILLS[@]}"; do
        # Clean skill name (remove markdown formatting)
        CLEAN_NAME=$(echo "$skill" | sed 's/\*//g' | sed 's/`//g' | xargs)

        # Try to find skill directory
        if [ -d "templates/skills/$CLEAN_NAME" ]; then
            if [ -f "templates/skills/$CLEAN_NAME/SKILL.md" ]; then
                pass "✓ $CLEAN_NAME"
            else
                fail "$CLEAN_NAME/SKILL.md missing"
                MISSING_COUNT=$((MISSING_COUNT + 1))
            fi
        else
            # Try case-insensitive match
            FOUND=false
            for dir in templates/skills/*/; do
                DIR_NAME=$(basename "$dir")
                if [ "$(echo $DIR_NAME | tr '[:upper:]' '[:lower:]')" = "$(echo $CLEAN_NAME | tr '[:upper:]' '[:lower:]')" ]; then
                    pass "✓ $CLEAN_NAME (found as $DIR_NAME)"
                    FOUND=true
                    break
                fi
            done

            if [ "$FOUND" = false ]; then
                fail "$CLEAN_NAME directory missing"
                MISSING_COUNT=$((MISSING_COUNT + 1))
            fi
        fi
    done

    # Check for skills not in index
    UNINDEXED_COUNT=0
    for skill_dir in templates/skills/*/; do
        SKILL_NAME=$(basename "$skill_dir")

        # Check if skill is in index
        IN_INDEX=false
        for indexed in "${INDEXED_SKILLS[@]}"; do
            CLEAN_INDEXED=$(echo "$indexed" | sed 's/\*//g' | sed 's/`//g' | xargs)
            if [ "$SKILL_NAME" = "$CLEAN_INDEXED" ]; then
                IN_INDEX=true
                break
            fi
        done

        if [ "$IN_INDEX" = false ]; then
            warn "$SKILL_NAME not in SKILLS-INDEX.md"
            UNINDEXED_COUNT=$((UNINDEXED_COUNT + 1))
        fi
    done

    if [ $UNINDEXED_COUNT -gt 0 ]; then
        warn "$UNINDEXED_COUNT skill(s) not indexed"
    fi
}

validate_adrs_in_decisions() {
    print_section "2️⃣  ADRs in decisions.md"

    if [ ! -f "templates/context/memory/decisions.md" ]; then
        warn "decisions.md not found (optional)"
        return
    fi

    pass "decisions.md exists"

    # Extract ADR references
    ADR_REFS=()
    while IFS= read -r line; do
        # Look for ADR-XXX patterns
        if [[ "$line" =~ ADR-([0-9]{3,}) ]]; then
            ADR_NUM="${BASH_REMATCH[1]}"
            ADR_REFS+=("ADR-$ADR_NUM")
            verbose "Found ADR reference: ADR-$ADR_NUM"
        fi
    done < templates/context/memory/decisions.md

    if [ ${#ADR_REFS[@]} -eq 0 ]; then
        info "No ADR references found in decisions.md"
        return
    fi

    info "Found ${#ADR_REFS[@]} ADR references"

    # Note: We don't validate ADR files exist since they might be inline
    # Just check for consistency in numbering
    UNIQUE_ADRS=($(echo "${ADR_REFS[@]}" | tr ' ' '\n' | sort -u))
    info "${#UNIQUE_ADRS[@]} unique ADRs referenced"

    # Check for sequential numbering
    EXPECTED=1
    for adr in "${UNIQUE_ADRS[@]}"; do
        if [[ "$adr" =~ ADR-([0-9]+) ]]; then
            NUM="${BASH_REMATCH[1]}"
            NUM=$((10#$NUM))  # Convert to decimal

            if [ $NUM -ne $EXPECTED ]; then
                warn "ADR numbering gap: expected ADR-$(printf "%03d" $EXPECTED), found $adr"
            fi
            EXPECTED=$((NUM + 1))
        fi
    done
}

validate_examples_in_readme() {
    print_section "3️⃣  Examples Referenced in README"

    if [ ! -f "README.md" ]; then
        fail "README.md not found"
        return
    fi

    pass "README.md exists"

    # Extract file references from README
    BROKEN_REFS=0

    while IFS= read -r line; do
        # Extract references to example files
        if [[ "$line" =~ examples/([^)]+) ]]; then
            EXAMPLE_REF="${BASH_REMATCH[1]}"
            FULL_PATH="examples/$EXAMPLE_REF"

            # Remove anchor if present
            FILE_PATH=$(echo "$FULL_PATH" | cut -d'#' -f1)

            if [ -f "$FILE_PATH" ]; then
                pass "✓ $EXAMPLE_REF"
            else
                fail "Referenced example missing: $FILE_PATH"
                BROKEN_REFS=$((BROKEN_REFS + 1))
            fi
        fi

        # Check template references
        if [[ "$line" =~ templates/([^)]+) ]]; then
            TEMPLATE_REF="${BASH_REMATCH[1]}"
            FULL_PATH="templates/$TEMPLATE_REF"

            FILE_PATH=$(echo "$FULL_PATH" | cut -d'#' -f1)

            if [ -f "$FILE_PATH" ] || [ -d "$FILE_PATH" ]; then
                verbose "✓ $TEMPLATE_REF"
            else
                fail "Referenced template missing: $FILE_PATH"
                BROKEN_REFS=$((BROKEN_REFS + 1))
            fi
        fi
    done < README.md

    if [ $BROKEN_REFS -eq 0 ]; then
        pass "All README references valid"
    else
        fail "$BROKEN_REFS broken reference(s) in README"
    fi
}

validate_hook_references() {
    print_section "4️⃣  Hook References in settings.json"

    if [ ! -f "templates/settings.json" ]; then
        fail "settings.json not found"
        return
    fi

    pass "settings.json exists"

    # Validate JSON first
    if ! python3 -m json.tool templates/settings.json > /dev/null 2>&1; then
        fail "settings.json is invalid JSON"
        return
    fi

    pass "settings.json is valid JSON"

    # Extract hook file references
    HOOK_REFS=$(python3 -c "
import json
import sys

try:
    with open('templates/settings.json') as f:
        data = json.load(f)

    hooks = data.get('hooks', [])
    for hook in hooks:
        file = hook.get('file', '')
        if file:
            print(file)
except Exception as e:
    print(f'Error: {e}', file=sys.stderr)
    sys.exit(1)
" 2>&1)

    if [ $? -ne 0 ]; then
        warn "Could not parse hooks from settings.json"
        return
    fi

    # Check each referenced hook file exists
    MISSING_HOOKS=0
    while IFS= read -r hook_file; do
        if [ -z "$hook_file" ]; then
            continue
        fi

        # Hook path is relative to hooks directory
        FULL_PATH="templates/hooks/$hook_file"

        if [ -f "$FULL_PATH" ]; then
            pass "✓ $hook_file"
        else
            fail "Hook file missing: $FULL_PATH"
            MISSING_HOOKS=$((MISSING_HOOKS + 1))
        fi
    done <<< "$HOOK_REFS"

    if [ $MISSING_HOOKS -eq 0 ]; then
        pass "All referenced hooks exist"
    else
        fail "$MISSING_HOOKS hook(s) referenced but missing"
    fi
}

validate_skill_cross_references() {
    print_section "5️⃣  Cross-References Between Skills"

    BROKEN_REFS=0

    for skill_file in templates/skills/*/SKILL.md; do
        if [ ! -f "$skill_file" ]; then
            continue
        fi

        SKILL_NAME=$(dirname "$skill_file" | xargs basename)
        verbose "Checking $SKILL_NAME..."

        # Look for references to other skills
        while IFS= read -r line; do
            # Match skill references like "see SKILL-NAME" or "uses SKILL-NAME"
            if [[ "$line" =~ (see|uses|requires|depends on)[[:space:]]+([A-Z][A-Za-z0-9_-]+) ]]; then
                REFERENCED_SKILL="${BASH_REMATCH[2]}"

                # Check if it's a skill name
                if [ -d "templates/skills/$REFERENCED_SKILL" ]; then
                    verbose "  ✓ References $REFERENCED_SKILL"
                elif [[ "$REFERENCED_SKILL" =~ ^[A-Z]{2,}$ ]]; then
                    # Might be a skill reference
                    warn "$SKILL_NAME references unknown skill: $REFERENCED_SKILL"
                    BROKEN_REFS=$((BROKEN_REFS + 1))
                fi
            fi
        done < "$skill_file"
    done

    if [ $BROKEN_REFS -eq 0 ]; then
        pass "All skill cross-references valid"
    else
        warn "$BROKEN_REFS potential broken skill reference(s)"
    fi
}

validate_documentation_references() {
    print_section "6️⃣  Documentation File References"

    BROKEN_REFS=0

    # Check English docs
    for doc in en/*.md; do
        if [ ! -f "$doc" ]; then
            continue
        fi

        DOC_NAME=$(basename "$doc")
        verbose "Checking $DOC_NAME..."

        # Look for references to templates
        while IFS= read -r line; do
            if [[ "$line" =~ templates/([^)[:space:]]+) ]]; then
                REF_PATH="${BASH_REMATCH[1]}"
                FULL_PATH="templates/$REF_PATH"

                # Remove markdown formatting
                CLEAN_PATH=$(echo "$FULL_PATH" | sed 's/`//g' | cut -d'#' -f1)

                if [ -f "$CLEAN_PATH" ] || [ -d "$CLEAN_PATH" ]; then
                    verbose "  ✓ $REF_PATH"
                else
                    fail "Broken reference in $DOC_NAME: $CLEAN_PATH"
                    BROKEN_REFS=$((BROKEN_REFS + 1))
                fi
            fi
        done < "$doc"
    done

    # Check Swedish docs
    for doc in sv/*.md; do
        if [ ! -f "$doc" ]; then
            continue
        fi

        DOC_NAME=$(basename "$doc")
        verbose "Checking $DOC_NAME..."

        while IFS= read -r line; do
            if [[ "$line" =~ templates/([^)[:space:]]+) ]]; then
                REF_PATH="${BASH_REMATCH[1]}"
                FULL_PATH="templates/$REF_PATH"

                CLEAN_PATH=$(echo "$FULL_PATH" | sed 's/`//g' | cut -d'#' -f1)

                if [ -f "$CLEAN_PATH" ] || [ -d "$CLEAN_PATH" ]; then
                    verbose "  ✓ $REF_PATH"
                else
                    fail "Broken reference in $DOC_NAME: $CLEAN_PATH"
                    BROKEN_REFS=$((BROKEN_REFS + 1))
                fi
            fi
        done < "$doc"
    done

    if [ $BROKEN_REFS -eq 0 ]; then
        pass "All documentation references valid"
    else
        fail "$BROKEN_REFS broken documentation reference(s)"
    fi
}

################################################################################
# Main Execution
################################################################################

print_header "Ogmios Cross-Reference Validation v${VERSION}"
echo ""

if [ "$VERBOSE" = true ]; then
    info "Verbose mode enabled - showing all checks"
fi

echo ""

validate_skills_index
validate_adrs_in_decisions
validate_examples_in_readme
validate_hook_references
validate_skill_cross_references
validate_documentation_references

################################################################################
# Summary
################################################################################

print_header "📊 Validation Summary"
echo ""

echo -e "Total checks: ${BOLD}$CHECKS${NC}"
echo -e "Errors:       ${RED}${BOLD}$ERRORS${NC}"
echo -e "Warnings:     ${YELLOW}${BOLD}$WARNINGS${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}${BOLD}🎉 All cross-references are valid!${NC}"
    echo ""
    echo "✓ Skills in index exist"
    echo "✓ ADR numbering consistent"
    echo "✓ README references valid"
    echo "✓ Hook files exist"
    echo "✓ Skill cross-references valid"
    echo "✓ Documentation references valid"
    echo ""
    EXIT_CODE=0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}${BOLD}⚠️  Validation complete with warnings.${NC}"
    echo ""
    echo "No critical errors, but review warnings above."
    echo ""
    EXIT_CODE=0
else
    echo -e "${RED}${BOLD}❌ Broken references found!${NC}"
    echo ""
    echo "Fix the errors above to ensure all references are valid."
    echo ""
    EXIT_CODE=1
fi

exit $EXIT_CODE
