#!/bin/bash
# Code Examples Validation Script for Ogmios
# Tests that code examples are syntactically correct

set -e

REPO_ROOT="/Users/<your_username>/Library/CloudStorage/<cloud_storage>/<your_vault>/Unsorted/claudeogmios/ogmios-github"
REPORT_FILE="$REPO_ROOT/reports/code-validation-report.md"

echo "🔍 OGMIOS CODE VALIDATION"
echo "========================="
echo ""

# Create reports directory
mkdir -p "$REPO_ROOT/reports"

# Initialize report
cat > "$REPORT_FILE" << EOF
# Code Validation Report

**Generated:** $(date)
**Repository:** Ogmios GitHub Release

---

## TypeScript Files

EOF

# Check all TypeScript files
echo "📝 Validating TypeScript files..."
TS_FILES=$(find "$REPO_ROOT/templates/hooks" -name "*.ts" 2>/dev/null || true)

TS_COUNT=0
TS_ERRORS=0

for ts_file in $TS_FILES; do
    ((TS_COUNT++))
    relative_path="${ts_file#$REPO_ROOT/}"

    # Basic syntax check - look for common issues
    if grep -q "import.*from.*['\"]" "$ts_file" && \
       grep -q "export.*function\|export.*const" "$ts_file"; then
        echo "- ✅ $relative_path" >> "$REPORT_FILE"
    else
        echo "- ⚠️ $relative_path (check imports/exports)" >> "$REPORT_FILE"
        ((TS_ERRORS++))
    fi
done

echo "" >> "$REPORT_FILE"
echo "**Total TypeScript Files:** $TS_COUNT" >> "$REPORT_FILE"
echo "**Files with Warnings:** $TS_ERRORS" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check bash scripts
echo "## Bash Scripts" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "🔧 Validating bash scripts..."
BASH_FILES=$(find "$REPO_ROOT/scripts" -name "*.sh" 2>/dev/null || true)

BASH_COUNT=0
BASH_ERRORS=0

for bash_file in $BASH_FILES; do
    ((BASH_COUNT++))
    relative_path="${bash_file#$REPO_ROOT/}"

    # Check if script has shebang and is executable
    if head -n 1 "$bash_file" | grep -q "^#!/bin/bash"; then
        if [ -x "$bash_file" ]; then
            echo "- ✅ $relative_path (executable)" >> "$REPORT_FILE"
        else
            echo "- ⚠️ $relative_path (not executable)" >> "$REPORT_FILE"
            ((BASH_ERRORS++))
        fi
    else
        echo "- ❌ $relative_path (missing shebang)" >> "$REPORT_FILE"
        ((BASH_ERRORS++))
    fi
done

echo "" >> "$REPORT_FILE"
echo "**Total Bash Scripts:** $BASH_COUNT" >> "$REPORT_FILE"
echo "**Scripts with Issues:** $BASH_ERRORS" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check markdown code blocks
echo "## Markdown Code Blocks" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "📄 Validating code blocks in markdown..."
MD_FILES=$(find "$REPO_ROOT" -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*")

CODE_BLOCK_COUNT=0
UNCLOSED_BLOCKS=0

for md_file in $MD_FILES; do
    relative_path="${md_file#$REPO_ROOT/}"

    # Count opening and closing code fences
    OPEN=$(grep -c '^```' "$md_file" 2>/dev/null || echo "0")

    # Check if even number (all blocks closed)
    if [ $((OPEN % 2)) -ne 0 ]; then
        echo "- ⚠️ $relative_path (unclosed code block)" >> "$REPORT_FILE"
        ((UNCLOSED_BLOCKS++))
    fi

    CODE_BLOCK_COUNT=$((CODE_BLOCK_COUNT + OPEN / 2))
done

echo "" >> "$REPORT_FILE"
echo "**Total Code Blocks:** $CODE_BLOCK_COUNT" >> "$REPORT_FILE"
echo "**Unclosed Blocks:** $UNCLOSED_BLOCKS" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check example commands
echo "## Example Commands" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "💻 Validating example commands..."

# Extract common commands and check validity
echo "### Common Command Patterns" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check bun commands
BUN_EXAMPLES=$(grep -r "bun install\|bun run" "$REPO_ROOT" --include="*.md" | wc -l | tr -d ' ')
echo "- **bun commands:** $BUN_EXAMPLES examples" >> "$REPORT_FILE"

# Check npm commands (should be minimal)
NPM_EXAMPLES=$(grep -r "npm install\|npm run" "$REPO_ROOT" --include="*.md" | wc -l | tr -d ' ')
if [ "$NPM_EXAMPLES" -gt 0 ]; then
    echo "- ⚠️ **npm commands:** $NPM_EXAMPLES examples (should use bun instead)" >> "$REPORT_FILE"
fi

# Check git commands
GIT_EXAMPLES=$(grep -r "git clone\|git init" "$REPO_ROOT" --include="*.md" | wc -l | tr -d ' ')
echo "- **git commands:** $GIT_EXAMPLES examples" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

# Summary
echo "## Summary" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "- TypeScript files validated: $TS_COUNT" >> "$REPORT_FILE"
echo "- Bash scripts validated: $BASH_COUNT" >> "$REPORT_FILE"
echo "- Code blocks in markdown: $CODE_BLOCK_COUNT" >> "$REPORT_FILE"
echo "- Total issues found: $((TS_ERRORS + BASH_ERRORS + UNCLOSED_BLOCKS))" >> "$REPORT_FILE"

echo ""
echo "✅ Code validation complete!"
echo "📄 Report: $REPORT_FILE"

# Return non-zero if errors found
exit $((TS_ERRORS + BASH_ERRORS + UNCLOSED_BLOCKS))
