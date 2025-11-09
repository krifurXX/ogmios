#!/bin/bash

################################################################################
# Ogmios PAI - Statistics Counter Script
################################################################################
#
# Generates statistics for README and documentation
#
# Usage:
#   ./scripts/count-stats.sh                    # Display statistics
#   ./scripts/count-stats.sh --json             # Output as JSON
#   ./scripts/count-stats.sh --markdown         # Output as markdown
#   ./scripts/count-stats.sh --help             # Show this help
#
# Exit codes:
#   0 - Success
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

# Output mode
MODE="display"

################################################################################
# Parse Arguments
################################################################################

for arg in "$@"; do
    case $arg in
        --json)
            MODE="json"
            ;;
        --markdown)
            MODE="markdown"
            ;;
        --help)
            echo "Ogmios Statistics Counter Script v${VERSION}"
            echo ""
            echo "Usage:"
            echo "  ./scripts/count-stats.sh              # Display stats"
            echo "  ./scripts/count-stats.sh --json       # JSON output"
            echo "  ./scripts/count-stats.sh --markdown   # Markdown table"
            echo ""
            echo "Counts:"
            echo "  - Total skills"
            echo "  - Total hooks"
            echo "  - Context files"
            echo "  - Lines of code"
            echo "  - Documentation files"
            echo "  - Languages supported"
            echo ""
            exit 0
            ;;
    esac
done

################################################################################
# Helper Functions
################################################################################

print_header() {
    if [ "$MODE" = "display" ]; then
        echo ""
        echo -e "${BOLD}${BLUE}$1${NC}"
        echo "========================================"
    fi
}

info() {
    if [ "$MODE" = "display" ]; then
        echo -e "${BLUE}$1${NC}"
    fi
}

################################################################################
# Counting Functions
################################################################################

count_skills() {
    # Count skill directories with SKILL.md
    local skill_count=0

    for skill_dir in templates/skills/*/; do
        if [ -f "$skill_dir/SKILL.md" ]; then
            skill_count=$((skill_count + 1))
        fi
    done

    echo $skill_count
}

count_hooks() {
    # Count TypeScript hook files (excluding lib)
    local hook_count=$(find templates/hooks -maxdepth 1 -name "*.ts" -type f 2>/dev/null | wc -l | tr -d ' ')
    echo $hook_count
}

count_context_files() {
    # Count context files
    local context_count=0

    if [ -d "templates/context" ]; then
        context_count=$(find templates/context -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    fi

    echo $context_count
}

count_documentation_files() {
    # Count English and Swedish docs
    local en_count=0
    local sv_count=0

    if [ -d "en" ]; then
        en_count=$(ls -1 en/*.md 2>/dev/null | wc -l | tr -d ' ')
    fi

    if [ -d "sv" ]; then
        sv_count=$(ls -1 sv/*.md 2>/dev/null | wc -l | tr -d ' ')
    fi

    echo "$en_count $sv_count"
}

count_lines_of_code() {
    # Count total lines in TypeScript files
    local ts_lines=0

    if command -v wc &> /dev/null; then
        ts_lines=$(find templates/hooks -name "*.ts" -type f -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo 0)
    fi

    # Count total lines in Python files (voice server)
    local py_lines=0

    if [ -d "voice-server" ]; then
        py_lines=$(find voice-server -name "*.py" -type f -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo 0)
    fi

    # Count total lines in markdown (skills)
    local md_lines=0
    md_lines=$(find templates/skills -name "*.md" -type f -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo 0)

    echo "$ts_lines $py_lines $md_lines"
}

count_workflow_files() {
    # Count workflow files in skills
    local workflow_count=0

    if [ -d "templates/skills" ]; then
        workflow_count=$(find templates/skills -path "*/workflows/*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    fi

    echo $workflow_count
}

count_example_files() {
    # Count example files
    local example_count=0

    if [ -d "examples" ]; then
        example_count=$(find examples -type f 2>/dev/null | wc -l | tr -d ' ')
    fi

    echo $example_count
}

get_languages_supported() {
    # Languages: English + Swedish
    echo "2"
}

count_lib_files() {
    # Count library files in hooks/lib
    local lib_count=0

    if [ -d "templates/hooks/lib" ]; then
        lib_count=$(find templates/hooks/lib -name "*.ts" -type f 2>/dev/null | wc -l | tr -d ' ')
    fi

    echo $lib_count
}

count_total_files() {
    # Count all files in repository (excluding .git, node_modules)
    local total=0

    total=$(find . -type f \
        ! -path "./.git/*" \
        ! -path "*/node_modules/*" \
        ! -path "*/__pycache__/*" \
        ! -path "*/.*" \
        2>/dev/null | wc -l | tr -d ' ')

    echo $total
}

################################################################################
# Generate Statistics
################################################################################

generate_stats() {
    # Collect all statistics
    SKILLS=$(count_skills)
    HOOKS=$(count_hooks)
    CONTEXT_FILES=$(count_context_files)
    WORKFLOWS=$(count_workflow_files)
    EXAMPLES=$(count_example_files)
    LANGUAGES=$(get_languages_supported)
    LIB_FILES=$(count_lib_files)
    TOTAL_FILES=$(count_total_files)

    # Documentation counts
    read EN_DOCS SV_DOCS <<< $(count_documentation_files)

    # Lines of code
    read TS_LINES PY_LINES MD_LINES <<< $(count_lines_of_code)
    TOTAL_LOC=$((TS_LINES + PY_LINES + MD_LINES))
}

################################################################################
# Output Functions
################################################################################

output_display() {
    print_header "Ogmios PAI - Repository Statistics"

    echo ""
    info "📦 Components"
    echo "  Skills:              $SKILLS"
    echo "  Hooks:               $HOOKS"
    echo "  Hook Libraries:      $LIB_FILES"
    echo "  Context Files:       $CONTEXT_FILES"
    echo "  Workflow Files:      $WORKFLOWS"
    echo "  Example Files:       $EXAMPLES"

    echo ""
    info "📚 Documentation"
    echo "  English Docs:        $EN_DOCS"
    echo "  Swedish Docs:        $SV_DOCS"
    echo "  Total Docs:          $((EN_DOCS + SV_DOCS))"

    echo ""
    info "💻 Code"
    echo "  TypeScript Lines:    $TS_LINES"
    echo "  Python Lines:        $PY_LINES"
    echo "  Markdown Lines:      $MD_LINES"
    echo "  Total LOC:           $TOTAL_LOC"

    echo ""
    info "🌍 Languages"
    echo "  Supported:           $LANGUAGES (English, Swedish)"

    echo ""
    info "📊 Repository"
    echo "  Total Files:         $TOTAL_FILES"

    echo ""
    echo -e "${GREEN}Statistics generated successfully!${NC}"
    echo ""
}

output_json() {
    cat <<EOF
{
  "generated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "components": {
    "skills": $SKILLS,
    "hooks": $HOOKS,
    "hook_libraries": $LIB_FILES,
    "context_files": $CONTEXT_FILES,
    "workflow_files": $WORKFLOWS,
    "example_files": $EXAMPLES
  },
  "documentation": {
    "english": $EN_DOCS,
    "swedish": $SV_DOCS,
    "total": $((EN_DOCS + SV_DOCS))
  },
  "code": {
    "typescript_lines": $TS_LINES,
    "python_lines": $PY_LINES,
    "markdown_lines": $MD_LINES,
    "total_loc": $TOTAL_LOC
  },
  "languages": {
    "count": $LANGUAGES,
    "supported": ["English", "Swedish"]
  },
  "repository": {
    "total_files": $TOTAL_FILES
  }
}
EOF
}

output_markdown() {
    cat <<EOF
# Ogmios PAI - Repository Statistics

Generated: $(date)

## Components

| Component | Count |
|-----------|-------|
| Skills | $SKILLS |
| Hooks | $HOOKS |
| Hook Libraries | $LIB_FILES |
| Context Files | $CONTEXT_FILES |
| Workflow Files | $WORKFLOWS |
| Example Files | $EXAMPLES |

## Documentation

| Language | Count |
|----------|-------|
| English | $EN_DOCS |
| Swedish | $SV_DOCS |
| **Total** | **$((EN_DOCS + SV_DOCS))** |

## Code Statistics

| Type | Lines |
|------|-------|
| TypeScript | $TS_LINES |
| Python | $PY_LINES |
| Markdown | $MD_LINES |
| **Total LOC** | **$TOTAL_LOC** |

## Languages Supported

- English
- Swedish

## Repository Overview

- **Total Files:** $TOTAL_FILES
- **Languages:** $LANGUAGES

---

*Statistics generated by \`scripts/count-stats.sh\`*
EOF
}

################################################################################
# Main Execution
################################################################################

# Generate all statistics
generate_stats

# Output in requested format
case $MODE in
    json)
        output_json
        ;;
    markdown)
        output_markdown
        ;;
    *)
        output_display
        ;;
esac

exit 0
