#!/bin/bash
# Link Validation Script for Ogmios
# Checks all markdown links for validity

set -e

REPO_ROOT="/Users/<your_username>/Library/CloudStorage/<cloud_storage>/<your_vault>/Unsorted/claudeogmios/ogmios-github"
REPORT_FILE="$REPO_ROOT/reports/link-validation-report.md"
BROKEN_LINKS=0
TOTAL_LINKS=0

echo "🔍 OGMIOS LINK VALIDATION"
echo "========================="
echo ""

# Create reports directory
mkdir -p "$REPO_ROOT/reports"

# Initialize report
cat > "$REPORT_FILE" << 'EOF'
# Link Validation Report

**Generated:** $(date)
**Repository:** Ogmios GitHub Release

---

## Summary

EOF

# Function to check if file exists
check_file_link() {
    local source_file="$1"
    local link_target="$2"
    local source_dir=$(dirname "$source_file")

    # Resolve relative path
    local full_path="$source_dir/$link_target"

    # Check if file exists
    if [ ! -e "$full_path" ]; then
        echo "❌ BROKEN: $source_file -> $link_target"
        echo "- **Broken Link:** \`$source_file\` → \`$link_target\`" >> "$REPORT_FILE"
        ((BROKEN_LINKS++))
        return 1
    else
        return 0
    fi
}

# Find all markdown files
echo "📄 Scanning markdown files..."
MARKDOWN_FILES=$(find "$REPO_ROOT" -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*")

echo "" >> "$REPORT_FILE"
echo "## Files Scanned" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

for md_file in $MARKDOWN_FILES; do
    relative_path="${md_file#$REPO_ROOT/}"
    echo "- $relative_path" >> "$REPORT_FILE"

    # Extract markdown links [text](path)
    while IFS= read -r link; do
        ((TOTAL_LINKS++))

        # Skip external links (http/https)
        if [[ "$link" =~ ^https?:// ]]; then
            continue
        fi

        # Skip anchors
        if [[ "$link" =~ ^# ]]; then
            continue
        fi

        # Check file link
        check_file_link "$md_file" "$link" || true

    done < <(grep -oP '\]\(\K[^)]+' "$md_file" 2>/dev/null || true)
done

echo "" >> "$REPORT_FILE"
echo "## Statistics" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "- **Total Links Checked:** $TOTAL_LINKS" >> "$REPORT_FILE"
echo "- **Broken Links:** $BROKEN_LINKS" >> "$REPORT_FILE"
echo "- **Success Rate:** $(( (TOTAL_LINKS - BROKEN_LINKS) * 100 / TOTAL_LINKS ))%" >> "$REPORT_FILE"

echo ""
echo "✅ Link validation complete!"
echo "📊 Total links: $TOTAL_LINKS"
echo "❌ Broken links: $BROKEN_LINKS"
echo "📄 Report: $REPORT_FILE"

exit $BROKEN_LINKS
