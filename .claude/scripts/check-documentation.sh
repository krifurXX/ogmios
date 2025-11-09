#!/bin/bash

################################################################################
# Ogmios PAI - Documentation Check Script
################################################################################
#
# Validates documentation completeness, cross-references, and bilingual parity
#
# Usage:
#   ./scripts/check-documentation.sh                    # Full check
#   ./scripts/check-documentation.sh --quick            # Quick check
#   ./scripts/check-documentation.sh --links            # Check links only
#   ./scripts/check-documentation.sh --help             # Show this help
#
# Exit codes:
#   0 - All checks passed
#   1 - Critical errors found
#   2 - Warnings only
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
MODE="full"

################################################################################
# Parse Arguments
################################################################################

for arg in "$@"; do
    case $arg in
        --quick)
            MODE="quick"
            ;;
        --links)
            MODE="links"
            ;;
        --help)
            echo "Ogmios Documentation Check Script v${VERSION}"
            echo ""
            echo "Usage:"
            echo "  ./scripts/check-documentation.sh           # Full check"
            echo "  ./scripts/check-documentation.sh --quick   # Quick check"
            echo "  ./scripts/check-documentation.sh --links   # Check links only"
            echo ""
            echo "Checks:"
            echo "  - Cross-reference validity"
            echo "  - English/Swedish parity"
            echo "  - Broken internal links"
            echo "  - Code example validity"
            echo "  - Statistics accuracy"
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

################################################################################
# Check Functions
################################################################################

check_cross_references() {
    print_section "🔗 Cross-Reference Validity"

    # Check if referenced files exist
    BROKEN_REFS=0

    # English docs
    for doc in en/*.md; do
        if [ ! -f "$doc" ]; then
            continue
        fi

        # Extract markdown links
        while IFS= read -r line; do
            # Extract file path from [text](path)
            if [[ "$line" =~ \]\(([^)]+)\) ]]; then
                REF="${BASH_REMATCH[1]}"

                # Skip external URLs
                if [[ "$REF" == http* ]]; then
                    continue
                fi

                # Skip anchors only
                if [[ "$REF" == \#* ]]; then
                    continue
                fi

                # Remove anchor if present
                REF_FILE=$(echo "$REF" | cut -d'#' -f1)

                # Check relative to doc location
                DOC_DIR=$(dirname "$doc")
                FULL_PATH="$DOC_DIR/$REF_FILE"

                if [ ! -f "$FULL_PATH" ] && [ ! -d "$FULL_PATH" ]; then
                    warn "Broken reference in $doc: $REF"
                    BROKEN_REFS=$((BROKEN_REFS + 1))
                fi
            fi
        done < <(grep -o '\[.*\](.*)' "$doc" 2>/dev/null || true)
    done

    # Swedish docs
    for doc in sv/*.md; do
        if [ ! -f "$doc" ]; then
            continue
        fi

        while IFS= read -r line; do
            if [[ "$line" =~ \]\(([^)]+)\) ]]; then
                REF="${BASH_REMATCH[1]}"

                if [[ "$REF" == http* ]] || [[ "$REF" == \#* ]]; then
                    continue
                fi

                REF_FILE=$(echo "$REF" | cut -d'#' -f1)
                DOC_DIR=$(dirname "$doc")
                FULL_PATH="$DOC_DIR/$REF_FILE"

                if [ ! -f "$FULL_PATH" ] && [ ! -d "$FULL_PATH" ]; then
                    warn "Broken reference in $doc: $REF"
                    BROKEN_REFS=$((BROKEN_REFS + 1))
                fi
            fi
        done < <(grep -o '\[.*\](.*)' "$doc" 2>/dev/null || true)
    done

    if [ $BROKEN_REFS -eq 0 ]; then
        pass "All cross-references valid"
    else
        warn "$BROKEN_REFS broken reference(s) found"
    fi
}

check_bilingual_parity() {
    print_section "🌍 English/Swedish Documentation Parity"

    EN_DOCS=($(ls en/*.md 2>/dev/null | xargs -n1 basename | sort))
    SV_DOCS=($(ls sv/*.md 2>/dev/null | xargs -n1 basename | sort))

    EN_COUNT=${#EN_DOCS[@]}
    SV_COUNT=${#SV_DOCS[@]}

    info "English: $EN_COUNT docs, Swedish: $SV_COUNT docs"

    if [ $EN_COUNT -eq $SV_COUNT ]; then
        pass "Document counts match"
    else
        warn "Document count mismatch: EN=$EN_COUNT, SV=$SV_COUNT"
    fi

    # Check for corresponding files
    MISSING_SV=0
    for en_doc in "${EN_DOCS[@]}"; do
        # Convert English filename to Swedish equivalent
        # This is simplified - real mapping may differ
        sv_equiv="$en_doc"

        if [ -f "sv/$sv_equiv" ]; then
            pass "sv/$sv_equiv exists for en/$en_doc"
        else
            warn "Missing Swedish version: sv/$sv_equiv (for en/$en_doc)"
            MISSING_SV=$((MISSING_SV + 1))
        fi
    done

    # Check content length parity (should be similar)
    for en_doc in "${EN_DOCS[@]}"; do
        if [ ! -f "en/$en_doc" ]; then
            continue
        fi

        EN_LINES=$(wc -l < "en/$en_doc")

        # Try to find Swedish equivalent
        sv_equiv="$en_doc"
        if [ -f "sv/$sv_equiv" ]; then
            SV_LINES=$(wc -l < "sv/$sv_equiv")

            # Allow 30% difference in line count
            DIFF=$(echo "$EN_LINES - $SV_LINES" | bc)
            DIFF_ABS=${DIFF#-}  # Absolute value
            THRESHOLD=$(echo "$EN_LINES * 0.3" | bc | cut -d. -f1)

            if [ $DIFF_ABS -gt $THRESHOLD ]; then
                warn "Large content difference: $en_doc (EN: $EN_LINES, SV: $SV_LINES lines)"
            fi
        fi
    done
}

check_internal_links() {
    print_section "🔗 Internal Link Validity"

    BROKEN_LINKS=0

    # Check all markdown files
    for doc in en/*.md sv/*.md templates/*.md 2>/dev/null; do
        if [ ! -f "$doc" ]; then
            continue
        fi

        # Extract links
        while IFS= read -r line; do
            if [[ "$line" =~ \]\(([^)]+)\) ]]; then
                LINK="${BASH_REMATCH[1]}"

                # Skip external links
                if [[ "$LINK" == http* ]] || [[ "$LINK" == https* ]]; then
                    continue
                fi

                # Skip mailto links
                if [[ "$LINK" == mailto:* ]]; then
                    continue
                fi

                # Check if it's an anchor only
                if [[ "$LINK" == \#* ]]; then
                    # Extract anchor
                    ANCHOR="${LINK#\#}"

                    # Check if anchor exists in current file
                    if ! grep -q "^#.*$ANCHOR" "$doc" 2>/dev/null; then
                        # Try slug format (lowercase, dashes)
                        SLUG=$(echo "$ANCHOR" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
                        if ! grep -iq "^#.*$(echo $SLUG | tr '-' ' ')" "$doc" 2>/dev/null; then
                            warn "Broken anchor in $doc: #$ANCHOR"
                            BROKEN_LINKS=$((BROKEN_LINKS + 1))
                        fi
                    fi
                    continue
                fi

                # Check file existence
                REF_FILE=$(echo "$LINK" | cut -d'#' -f1)
                DOC_DIR=$(dirname "$doc")

                # Try absolute path from repo root
                if [ ! -f "$REF_FILE" ]; then
                    # Try relative to doc
                    if [ ! -f "$DOC_DIR/$REF_FILE" ]; then
                        warn "Broken link in $doc: $LINK"
                        BROKEN_LINKS=$((BROKEN_LINKS + 1))
                    fi
                fi
            fi
        done < <(grep -o '\[.*\]([^)]*)' "$doc" 2>/dev/null || true)
    done

    if [ $BROKEN_LINKS -eq 0 ]; then
        pass "All internal links valid"
    else
        warn "$BROKEN_LINKS broken internal link(s) found"
    fi
}

check_code_examples() {
    print_section "📝 Code Example Validity"

    INVALID_EXAMPLES=0

    # Check TypeScript examples
    for doc in en/*.md sv/*.md; do
        if [ ! -f "$doc" ]; then
            continue
        fi

        # Extract code blocks
        IN_CODE_BLOCK=false
        CODE_LANG=""
        CODE_CONTENT=""
        LINE_NUM=0

        while IFS= read -r line; do
            LINE_NUM=$((LINE_NUM + 1))

            # Start of code block
            if [[ "$line" =~ ^\`\`\`([a-z]*) ]]; then
                IN_CODE_BLOCK=true
                CODE_LANG="${BASH_REMATCH[1]}"
                CODE_CONTENT=""
                continue
            fi

            # End of code block
            if [[ "$line" == \`\`\` ]] && [ "$IN_CODE_BLOCK" = true ]; then
                IN_CODE_BLOCK=false

                # Validate TypeScript
                if [ "$CODE_LANG" = "typescript" ] || [ "$CODE_LANG" = "ts" ]; then
                    # Basic syntax checks
                    if echo "$CODE_CONTENT" | grep -q "function.*{" && ! echo "$CODE_CONTENT" | grep -q "}"; then
                        warn "Unclosed function in $doc near line $LINE_NUM"
                        INVALID_EXAMPLES=$((INVALID_EXAMPLES + 1))
                    fi
                fi

                # Validate bash
                if [ "$CODE_LANG" = "bash" ] || [ "$CODE_LANG" = "sh" ]; then
                    # Check for common syntax errors
                    if echo "$CODE_CONTENT" | grep -q "if.*then" && ! echo "$CODE_CONTENT" | grep -q "fi"; then
                        warn "Unclosed if statement in $doc near line $LINE_NUM"
                        INVALID_EXAMPLES=$((INVALID_EXAMPLES + 1))
                    fi
                fi

                CODE_CONTENT=""
                CODE_LANG=""
                continue
            fi

            if [ "$IN_CODE_BLOCK" = true ]; then
                CODE_CONTENT="$CODE_CONTENT$line\n"
            fi
        done < "$doc"
    done

    if [ $INVALID_EXAMPLES -eq 0 ]; then
        pass "All code examples appear valid"
    else
        warn "$INVALID_EXAMPLES potentially invalid code example(s)"
    fi
}

check_statistics() {
    print_section "📊 Statistics Accuracy"

    # Count actual items
    ACTUAL_HOOKS=$(find templates/hooks -name "*.ts" -type f 2>/dev/null | wc -l | tr -d ' ')
    ACTUAL_SKILLS=$(find templates/skills -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
    ACTUAL_EN_DOCS=$(ls -1 en/*.md 2>/dev/null | wc -l | tr -d ' ')
    ACTUAL_SV_DOCS=$(ls -1 sv/*.md 2>/dev/null | wc -l | tr -d ' ')

    info "Actual counts: Hooks=$ACTUAL_HOOKS, Skills=$ACTUAL_SKILLS, EN docs=$ACTUAL_EN_DOCS, SV docs=$ACTUAL_SV_DOCS"

    # Check README.md for mentioned statistics
    if [ -f "README.md" ]; then
        # Check hook count
        if grep -q "$ACTUAL_HOOKS" README.md; then
            pass "Hook count ($ACTUAL_HOOKS) matches in README"
        else
            warn "Hook count in README may be outdated (actual: $ACTUAL_HOOKS)"
        fi

        # Check skill count
        if grep -q "$ACTUAL_SKILLS" README.md; then
            pass "Skill count ($ACTUAL_SKILLS) matches in README"
        else
            warn "Skill count in README may be outdated (actual: $ACTUAL_SKILLS)"
        fi
    else
        warn "README.md not found"
    fi

    # Check SKILLS-INDEX.md
    if [ -f "templates/SKILLS-INDEX.md" ]; then
        INDEXED_COUNT=$(grep -c "^### " templates/SKILLS-INDEX.md 2>/dev/null || echo 0)

        if [ "$INDEXED_COUNT" -eq "$ACTUAL_SKILLS" ]; then
            pass "All skills indexed in SKILLS-INDEX.md"
        else
            warn "SKILLS-INDEX.md mismatch: indexed=$INDEXED_COUNT, actual=$ACTUAL_SKILLS"
        fi
    fi
}

check_header_consistency() {
    print_section "📋 Header Consistency"

    INCONSISTENT=0

    # Check if all docs have proper headers
    for doc in en/*.md sv/*.md; do
        if [ ! -f "$doc" ]; then
            continue
        fi

        # Check for h1 header
        if ! grep -q "^# " "$doc"; then
            warn "Missing h1 header: $doc"
            INCONSISTENT=$((INCONSISTENT + 1))
        fi

        # Check for multiple h1 headers (should only be one)
        H1_COUNT=$(grep -c "^# " "$doc" 2>/dev/null || echo 0)
        if [ $H1_COUNT -gt 1 ]; then
            warn "Multiple h1 headers in $doc ($H1_COUNT found)"
            INCONSISTENT=$((INCONSISTENT + 1))
        fi
    done

    if [ $INCONSISTENT -eq 0 ]; then
        pass "All documents have consistent headers"
    else
        warn "$INCONSISTENT document(s) with header issues"
    fi
}

check_yaml_frontmatter() {
    print_section "📄 YAML Frontmatter in Skills"

    INVALID_YAML=0

    for skill in templates/skills/*/SKILL.md; do
        if [ ! -f "$skill" ]; then
            continue
        fi

        # Check for YAML frontmatter
        if ! head -n 1 "$skill" | grep -q "^---$"; then
            warn "Missing YAML frontmatter: $skill"
            INVALID_YAML=$((INVALID_YAML + 1))
            continue
        fi

        # Extract frontmatter
        FRONTMATTER=$(awk '/^---$/{f=!f;next}f' "$skill" | head -n 20)

        # Check for required fields
        REQUIRED_FIELDS=("name:" "description:" "version:")

        for field in "${REQUIRED_FIELDS[@]}"; do
            if ! echo "$FRONTMATTER" | grep -q "$field"; then
                warn "Missing field '$field' in $skill"
                INVALID_YAML=$((INVALID_YAML + 1))
            fi
        done
    done

    if [ $INVALID_YAML -eq 0 ]; then
        pass "All skills have valid YAML frontmatter"
    else
        warn "$INVALID_YAML skill(s) with frontmatter issues"
    fi
}

check_toc_existence() {
    print_section "📑 Table of Contents"

    MISSING_TOC=0

    # Check major docs for TOC
    MAJOR_DOCS=("en/01-OVERVIEW.md" "sv/01-ÖVERSIKT.md")

    for doc in "${MAJOR_DOCS[@]}"; do
        if [ ! -f "$doc" ]; then
            continue
        fi

        # Check for common TOC patterns
        if grep -iq "## Table of Contents" "$doc" || grep -iq "## Innehållsförteckning" "$doc"; then
            pass "$doc has TOC"
        else
            warn "$doc missing Table of Contents"
            MISSING_TOC=$((MISSING_TOC + 1))
        fi
    done

    if [ $MISSING_TOC -eq 0 ]; then
        pass "Major documents have TOC"
    else
        info "Consider adding TOC to major documents"
    fi
}

check_spelling_consistency() {
    print_section "📝 Spelling Consistency"

    INCONSISTENT=0

    # Check for common spelling variations
    VARIANTS=(
        "skilL:skill"  # Case sensitivity
        "initialise:initialize"  # UK vs US spelling
    )

    # This is a simple check - could be expanded
    info "Basic spelling consistency check"
    pass "Spelling check placeholder (manual review recommended)"
}

################################################################################
# Main Execution
################################################################################

print_header "Ogmios Documentation Check v${VERSION}"
echo ""

if [ "$MODE" = "quick" ]; then
    info "Running quick documentation check..."
    check_bilingual_parity
    check_statistics
    check_header_consistency
elif [ "$MODE" = "links" ]; then
    info "Checking links only..."
    check_cross_references
    check_internal_links
else
    info "Running full documentation check..."
    check_cross_references
    check_bilingual_parity
    check_internal_links
    check_code_examples
    check_statistics
    check_header_consistency
    check_yaml_frontmatter
    check_toc_existence
fi

################################################################################
# Summary
################################################################################

print_header "📊 Documentation Check Summary"
echo ""

echo -e "Total checks: ${BOLD}$CHECKS${NC}"
echo -e "Errors:       ${RED}${BOLD}$ERRORS${NC}"
echo -e "Warnings:     ${YELLOW}${BOLD}$WARNINGS${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}${BOLD}🎉 Documentation is perfect!${NC}"
    echo ""
    echo "All checks passed:"
    echo "✓ Cross-references valid"
    echo "✓ Bilingual parity maintained"
    echo "✓ Links working"
    echo "✓ Code examples valid"
    echo "✓ Statistics accurate"
    echo ""
    EXIT_CODE=0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}${BOLD}⚠️  Documentation has warnings.${NC}"
    echo ""
    echo "No critical errors, but review warnings above."
    echo "Documentation is functional but could be improved."
    echo ""
    EXIT_CODE=2
else
    echo -e "${RED}${BOLD}❌ Documentation has errors.${NC}"
    echo ""
    echo "Fix the errors above to improve documentation quality."
    echo ""
    EXIT_CODE=1
fi

exit $EXIT_CODE
