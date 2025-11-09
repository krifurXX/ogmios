#!/bin/bash

################################################################################
# Ogmios PAI - Skills Validation Script
################################################################################
#
# Validates skill structure, YAML frontmatter, and content requirements
#
# Usage:
#   ./scripts/validate-skills.sh                    # Validate all skills
#   ./scripts/validate-skills.sh SKILL-NAME         # Validate specific skill
#   ./scripts/validate-skills.sh --strict           # Strict validation
#   ./scripts/validate-skills.sh --help             # Show this help
#
# Exit codes:
#   0 - All skills valid
#   1 - Validation errors found
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
STRICT=false
SPECIFIC_SKILL=""

# Limits
MAX_LINES=180

################################################################################
# Parse Arguments
################################################################################

for arg in "$@"; do
    case $arg in
        --strict)
            STRICT=true
            ;;
        --help)
            echo "Ogmios Skills Validation Script v${VERSION}"
            echo ""
            echo "Usage:"
            echo "  ./scripts/validate-skills.sh              # Validate all"
            echo "  ./scripts/validate-skills.sh CORE         # Validate CORE skill"
            echo "  ./scripts/validate-skills.sh --strict     # Strict mode"
            echo ""
            echo "Validates:"
            echo "  - YAML frontmatter format"
            echo "  - Required fields (name, description, version)"
            echo "  - File size (<180 lines recommended)"
            echo "  - Directory structure (workflows/, reference/)"
            echo "  - Content quality"
            echo ""
            exit 0
            ;;
        *)
            if [ ! -z "$arg" ] && [[ ! "$arg" == -* ]]; then
                SPECIFIC_SKILL="$arg"
            fi
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
# Validation Functions
################################################################################

validate_yaml_frontmatter() {
    local skill_file="$1"
    local skill_name="$2"

    # Check for YAML frontmatter delimiters
    if ! head -n 1 "$skill_file" | grep -q "^---$"; then
        fail "$skill_name: Missing YAML frontmatter opening (---)"
        return 1
    fi

    # Find closing delimiter
    if ! head -n 30 "$skill_file" | tail -n +2 | grep -q "^---$"; then
        fail "$skill_name: Missing YAML frontmatter closing (---)"
        return 1
    fi

    pass "$skill_name: Valid YAML frontmatter delimiters"

    # Extract frontmatter
    local frontmatter=$(awk '/^---$/{f=!f;next}f' "$skill_file" | head -n 50)

    # Check required fields
    local required_fields=("name:" "description:" "version:")
    local missing_fields=0

    for field in "${required_fields[@]}"; do
        if echo "$frontmatter" | grep -q "^$field"; then
            pass "$skill_name: Has $field"
        else
            fail "$skill_name: Missing required field: $field"
            missing_fields=$((missing_fields + 1))
        fi
    done

    # Check optional but recommended fields
    local optional_fields=("category:" "tags:" "author:")

    for field in "${optional_fields[@]}"; do
        if echo "$frontmatter" | grep -q "^$field"; then
            pass "$skill_name: Has $field (optional)"
        else
            if [ "$STRICT" = true ]; then
                warn "$skill_name: Missing optional field: $field"
            fi
        fi
    done

    # Validate YAML syntax
    local yaml_content=$(awk '/^---$/{f=!f;next}f' "$skill_file")

    # Basic YAML validation (check for common errors)
    local line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))

        # Skip empty lines and comments
        if [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]]; then
            continue
        fi

        # Check for key:value format
        if [[ "$line" =~ ^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_-]*:[[:space:]] ]]; then
            continue
        elif [[ "$line" =~ ^[[:space:]]*- ]]; then
            # List item
            continue
        else
            # Check if it's part of a multiline value
            if [[ "$line" =~ ^[[:space:]]{2,} ]]; then
                continue
            else
                warn "$skill_name: Potential YAML syntax issue at line $line_num"
            fi
        fi
    done <<< "$yaml_content"

    return 0
}

validate_file_size() {
    local skill_file="$1"
    local skill_name="$2"

    local lines=$(wc -l < "$skill_file" | tr -d ' ')

    info "$skill_name: $lines lines"

    if [ $lines -gt $MAX_LINES ]; then
        warn "$skill_name: File is $lines lines (recommended: <$MAX_LINES)"
        info "   Consider splitting into sub-skills or using reference files"
    else
        pass "$skill_name: File size OK ($lines/$MAX_LINES lines)"
    fi
}

validate_directory_structure() {
    local skill_dir="$1"
    local skill_name="$2"

    # Check for workflows directory
    if [ -d "$skill_dir/workflows" ]; then
        pass "$skill_name: workflows/ directory exists"

        # Count workflow files
        local workflow_count=$(find "$skill_dir/workflows" -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        info "   $workflow_count workflow file(s)"
    else
        if [ "$STRICT" = true ]; then
            warn "$skill_name: workflows/ directory missing (recommended)"
        fi
    fi

    # Check for reference directory
    if [ -d "$skill_dir/reference" ]; then
        pass "$skill_name: reference/ directory exists"

        # Count reference files
        local ref_count=$(find "$skill_dir/reference" -type f 2>/dev/null | wc -l | tr -d ' ')
        info "   $ref_count reference file(s)"
    else
        if [ "$STRICT" = true ]; then
            warn "$skill_name: reference/ directory missing (recommended)"
        fi
    fi

    # Check for examples directory (optional)
    if [ -d "$skill_dir/examples" ]; then
        pass "$skill_name: examples/ directory exists (optional)"
    fi
}

validate_content_quality() {
    local skill_file="$1"
    local skill_name="$2"

    # Check for essential sections
    local has_description=false
    local has_usage=false
    local has_examples=false

    # Skip YAML frontmatter
    local content=$(awk 'BEGIN{f=0}/^---$/{f++;next}f==2{print}' "$skill_file")

    # Check for description section
    if echo "$content" | grep -iq "## Description\|## Overview\|## Purpose"; then
        pass "$skill_name: Has description section"
        has_description=true
    else
        warn "$skill_name: Missing description section"
    fi

    # Check for usage/how-to section
    if echo "$content" | grep -iq "## Usage\|## How to Use\|## Getting Started"; then
        pass "$skill_name: Has usage section"
        has_usage=true
    else
        warn "$skill_name: Missing usage section"
    fi

    # Check for examples
    if echo "$content" | grep -iq "## Example\|## Examples"; then
        pass "$skill_name: Has examples section"
        has_examples=true
    else
        if [ "$STRICT" = true ]; then
            warn "$skill_name: Missing examples section (recommended)"
        fi
    fi

    # Check for common quality issues
    local word_count=$(echo "$content" | wc -w | tr -d ' ')

    if [ $word_count -lt 100 ]; then
        warn "$skill_name: Content is sparse ($word_count words)"
        info "   Consider adding more detail and examples"
    elif [ $word_count -lt 300 ]; then
        info "$skill_name: $word_count words (could be more detailed)"
    else
        pass "$skill_name: Good content depth ($word_count words)"
    fi

    # Check for code blocks
    local code_blocks=$(echo "$content" | grep -c "^\`\`\`" || true)

    if [ $code_blocks -gt 0 ]; then
        pass "$skill_name: Contains $code_blocks code block(s)"
    else
        if [ "$STRICT" = true ]; then
            warn "$skill_name: No code examples found"
        fi
    fi
}

validate_metadata_consistency() {
    local skill_file="$1"
    local skill_name="$2"
    local skill_dir="$3"

    # Extract name from YAML
    local yaml_name=$(awk '/^---$/{f=!f;next}f' "$skill_file" | grep "^name:" | cut -d: -f2- | xargs)

    if [ ! -z "$yaml_name" ]; then
        # Check if YAML name matches directory name
        if [ "$yaml_name" = "$skill_name" ]; then
            pass "$skill_name: YAML name matches directory"
        else
            warn "$skill_name: YAML name mismatch (dir: $skill_name, yaml: $yaml_name)"
        fi
    fi

    # Check version format
    local version=$(awk '/^---$/{f=!f;next}f' "$skill_file" | grep "^version:" | cut -d: -f2- | xargs)

    if [ ! -z "$version" ]; then
        if [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            pass "$skill_name: Valid version format ($version)"
        else
            warn "$skill_name: Non-standard version format: $version"
            info "   Recommended: Semantic versioning (e.g., 1.0.0)"
        fi
    fi
}

validate_links_in_skill() {
    local skill_file="$1"
    local skill_name="$2"
    local skill_dir="$3"

    local broken_links=0

    # Check internal links
    while IFS= read -r line; do
        if [[ "$line" =~ \]\(([^)]+)\) ]]; then
            local link="${BASH_REMATCH[1]}"

            # Skip external links
            if [[ "$link" == http* ]]; then
                continue
            fi

            # Skip anchors only
            if [[ "$link" == \#* ]]; then
                continue
            fi

            # Check if file exists relative to skill directory
            local link_file=$(echo "$link" | cut -d'#' -f1)
            local full_path="$skill_dir/$link_file"

            if [ ! -f "$full_path" ] && [ ! -d "$full_path" ]; then
                warn "$skill_name: Broken link: $link"
                broken_links=$((broken_links + 1))
            fi
        fi
    done < <(grep -o '\[.*\]([^)]*)' "$skill_file" 2>/dev/null || true)

    if [ $broken_links -eq 0 ]; then
        pass "$skill_name: All internal links valid"
    else
        warn "$skill_name: $broken_links broken link(s)"
    fi
}

validate_single_skill() {
    local skill_dir="$1"
    local skill_name=$(basename "$skill_dir")

    print_section "🔍 Validating: $skill_name"

    # Check SKILL.md exists
    local skill_file="$skill_dir/SKILL.md"

    if [ ! -f "$skill_file" ]; then
        fail "$skill_name: SKILL.md not found"
        return 1
    fi

    pass "$skill_name: SKILL.md exists"

    # Run all validations
    validate_yaml_frontmatter "$skill_file" "$skill_name"
    validate_file_size "$skill_file" "$skill_name"
    validate_directory_structure "$skill_dir" "$skill_name"
    validate_content_quality "$skill_file" "$skill_name"
    validate_metadata_consistency "$skill_file" "$skill_name" "$skill_dir"
    validate_links_in_skill "$skill_file" "$skill_name" "$skill_dir"

    return 0
}

################################################################################
# Main Execution
################################################################################

print_header "Ogmios Skills Validation v${VERSION}"
echo ""

if [ "$STRICT" = true ]; then
    info "Strict mode enabled - all warnings will be reported"
fi

if [ ! -z "$SPECIFIC_SKILL" ]; then
    # Validate specific skill
    SKILL_DIR="templates/skills/$SPECIFIC_SKILL"

    if [ ! -d "$SKILL_DIR" ]; then
        fail "Skill not found: $SPECIFIC_SKILL"
        echo ""
        echo "Available skills:"
        ls -1 templates/skills/ | grep -v "^SKILLS-INDEX" || true
        exit 1
    fi

    validate_single_skill "$SKILL_DIR"
else
    # Validate all skills
    SKILL_COUNT=0

    for skill_dir in templates/skills/*/; do
        if [ ! -d "$skill_dir" ]; then
            continue
        fi

        validate_single_skill "$skill_dir"
        SKILL_COUNT=$((SKILL_COUNT + 1))
    done

    info "Validated $SKILL_COUNT skill(s)"
fi

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
    echo -e "${GREEN}${BOLD}🎉 All skills are valid!${NC}"
    echo ""
    echo "✓ YAML frontmatter correct"
    echo "✓ Required fields present"
    echo "✓ File sizes appropriate"
    echo "✓ Directory structure complete"
    echo "✓ Content quality good"
    echo "✓ Links valid"
    echo ""
    EXIT_CODE=0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}${BOLD}⚠️  Skills valid with warnings.${NC}"
    echo ""
    echo "No critical errors, but review warnings above."
    echo "Skills are functional but could be improved."
    echo ""
    EXIT_CODE=2
else
    echo -e "${RED}${BOLD}❌ Skill validation failed!${NC}"
    echo ""
    echo "Fix the errors above to ensure skills are properly formatted."
    echo ""
    if [ "$STRICT" = false ]; then
        echo "Tip: Run with --strict for additional checks"
        echo ""
    fi
    EXIT_CODE=1
fi

exit $EXIT_CODE
