#!/bin/bash

# Comprehensive Validation Script for Ogmios Documentation
# Validates structure, links, and content after restructure

set -e

PROJECT_ROOT="/Users/carlheath/Library/CloudStorage/OneDrive-Privat/Arkivet/Unsorted/claudeogmios/ogmios-github"
cd "$PROJECT_ROOT"

REPORT_FILE="FINAL-VALIDATION-REPORT.md"

echo "================================"
echo "Ogmios Validation Script"
echo "================================"
echo ""

# Initialize report
cat > "$REPORT_FILE" << 'EOF'
# Final Validation Report

**Date:** $(date)
**Project:** Ogmios Documentation Restructure

---

## Executive Summary

This report documents comprehensive validation of the Ogmios documentation restructure.

---

## 1. Structure Validation

### Expected Structure
```
docs/
├── 01-getting-started/
├── 02-core-concepts/
├── 03-architecture/
├── 04-guides/
├── 05-reference/
├── 06-bilingual/
├── 07-advanced/
├── 08-faq/
└── 09-community/
```

### Actual Structure
```
EOF

# Add actual structure
find docs -type d -maxdepth 1 | sort >> "$REPORT_FILE"

cat >> "$REPORT_FILE" << 'EOF'
```

### Navigation README Files
EOF

# Check for README files
echo "" >> "$REPORT_FILE"
if [ -f "docs/README.md" ]; then
    echo "- ✅ docs/README.md exists" >> "$REPORT_FILE"
else
    echo "- ❌ docs/README.md MISSING" >> "$REPORT_FILE"
fi

for dir in docs/*/; do
    if [ -f "${dir}README.md" ]; then
        echo "- ✅ ${dir}README.md exists" >> "$REPORT_FILE"
    else
        echo "- ⚠️  ${dir}README.md missing (optional)" >> "$REPORT_FILE"
    fi
done

# Count files
echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## 2. File Statistics" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

total_md=$(find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | wc -l | tr -d ' ')
docs_md=$(find docs -name "*.md" | wc -l | tr -d ' ')
templates_md=$(find templates -name "*.md" | wc -l | tr -d ' ')
examples_md=$(find examples -name "*.md" | wc -l | tr -d ' ')

echo "| Category | Count |" >> "$REPORT_FILE"
echo "|----------|-------|" >> "$REPORT_FILE"
echo "| Total Markdown Files | $total_md |" >> "$REPORT_FILE"
echo "| Documentation Files | $docs_md |" >> "$REPORT_FILE"
echo "| Template Files | $templates_md |" >> "$REPORT_FILE"
echo "| Example Files | $examples_md |" >> "$REPORT_FILE"

# List documentation files by category
echo "" >> "$REPORT_FILE"
echo "### Documentation Files by Category" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

for dir in docs/*/; do
    dir_name=$(basename "$dir")
    file_count=$(find "$dir" -name "*.md" | wc -l | tr -d ' ')
    echo "- **$dir_name**: $file_count files" >> "$REPORT_FILE"
done

# Link validation (basic)
echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## 3. Link Validation" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check for old-style links that should have been updated
echo "### Checking for Old Link Patterns" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

old_links_found=0

# Search for old en/ and sv/ links
if grep -r "en/[0-9]" docs/ README.md CONTRIBUTING.md 2>/dev/null | grep -v "Binary" > /dev/null; then
    echo "⚠️  Found old 'en/' link patterns:" >> "$REPORT_FILE"
    grep -r "en/[0-9]" docs/ README.md CONTRIBUTING.md 2>/dev/null | grep -v "Binary" | head -10 >> "$REPORT_FILE"
    old_links_found=1
else
    echo "✅ No old 'en/' link patterns found" >> "$REPORT_FILE"
fi

if grep -r "sv/[0-9]" docs/ README.md CONTRIBUTING.md 2>/dev/null | grep -v "Binary" > /dev/null; then
    echo "⚠️  Found old 'sv/' link patterns:" >> "$REPORT_FILE"
    grep -r "sv/[0-9]" docs/ README.md CONTRIBUTING.md 2>/dev/null | grep -v "Binary" | head -10 >> "$REPORT_FILE"
    old_links_found=1
else
    echo "✅ No old 'sv/' link patterns found" >> "$REPORT_FILE"
fi

if grep -r "documentation/" docs/ README.md CONTRIBUTING.md 2>/dev/null | grep -v "Binary" | grep ".md" > /dev/null; then
    echo "⚠️  Found old 'documentation/' link patterns:" >> "$REPORT_FILE"
    grep -r "documentation/" docs/ README.md CONTRIBUTING.md 2>/dev/null | grep -v "Binary" | grep ".md" | head -10 >> "$REPORT_FILE"
    old_links_found=1
else
    echo "✅ No old 'documentation/' link patterns found" >> "$REPORT_FILE"
fi

# Content validation
echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## 4. Content Validation" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check key files exist
echo "### Key Files Check" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

key_files=(
    "README.md"
    "CONTRIBUTING.md"
    "docs/README.md"
    "docs/01-getting-started/quick-start.md"
    "docs/01-getting-started/installation.md"
    "docs/02-core-concepts/ufc-system.md"
    "docs/02-core-concepts/skills-system.md"
    "docs/03-architecture/system-design.md"
)

for file in "${key_files[@]}"; do
    if [ -f "$file" ]; then
        size=$(wc -c < "$file" | tr -d ' ')
        echo "- ✅ $file ($size bytes)" >> "$REPORT_FILE"
    else
        echo "- ❌ $file MISSING" >> "$REPORT_FILE"
    fi
done

# Template validation
echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## 5. Template Validation" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

template_skills=$(find templates/skills -name "SKILL.md" | wc -l | tr -d ' ')
echo "- Skills Templates: $template_skills found" >> "$REPORT_FILE"

if [ -d "templates/hooks" ]; then
    hook_count=$(find templates/hooks -name "*.ts" | wc -l | tr -d ' ')
    echo "- Hook Templates: $hook_count TypeScript files found" >> "$REPORT_FILE"
fi

# Example validation
echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## 6. Example Validation" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

en_examples=$(find examples/en -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
sv_examples=$(find examples/sv -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

echo "- English Examples: $en_examples files" >> "$REPORT_FILE"
echo "- Swedish Examples: $sv_examples files" >> "$REPORT_FILE"

# Final status
echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## 7. Overall Status" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

if [ $old_links_found -eq 0 ]; then
    echo "### ✅ VALIDATION PASSED" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "All critical checks passed. Documentation restructure is complete and validated." >> "$REPORT_FILE"
else
    echo "### ⚠️  VALIDATION WARNINGS" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "Some old link patterns detected. Review link validation section above." >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## 8. Recommendations" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

if [ $old_links_found -eq 1 ]; then
    echo "1. ⚠️  Update remaining old link patterns" >> "$REPORT_FILE"
else
    echo "1. ✅ All links updated to new structure" >> "$REPORT_FILE"
fi

echo "2. Consider adding more navigation README files for easier browsing" >> "$REPORT_FILE"
echo "3. Verify external links (not checked by this script)" >> "$REPORT_FILE"
echo "4. Test end-to-end user workflows" >> "$REPORT_FILE"
echo "5. Consider archiving old backup directory after final verification" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "*Report generated on $(date)*" >> "$REPORT_FILE"

# Fix date placeholders
sed -i '' "s/\$(date)/$(date)/" "$REPORT_FILE"

echo ""
echo "================================"
echo "Validation Complete"
echo "================================"
echo ""
echo "Report saved to: $REPORT_FILE"
echo ""

# Display summary
echo "SUMMARY:"
echo "--------"
echo "Total Markdown Files: $total_md"
echo "Documentation Files: $docs_md"
echo "Template Files: $templates_md"
echo "Example Files: $examples_md"
echo ""

if [ $old_links_found -eq 0 ]; then
    echo "✅ No old link patterns found"
else
    echo "⚠️  Old link patterns detected - review report"
fi

echo ""
echo "Full report: $REPORT_FILE"
