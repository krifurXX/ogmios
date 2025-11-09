#!/bin/bash
# Consistency Validation Script for Ogmios
# Checks terminology, counts, and cross-references

set -e

REPO_ROOT="/Users/<your_username>/Library/CloudStorage/<cloud_storage>/<your_vault>/Unsorted/claudeogmios/ogmios-github"
REPORT_FILE="$REPO_ROOT/reports/consistency-report.md"

echo "🔍 OGMIOS CONSISTENCY VALIDATION"
echo "================================"
echo ""

# Create reports directory
mkdir -p "$REPO_ROOT/reports"

# Initialize report
cat > "$REPORT_FILE" << EOF
# Consistency Validation Report

**Generated:** $(date)
**Repository:** Ogmios GitHub Release

---

## Component Counts

EOF

# Count actual components
echo "📊 Counting components..."

# Skills
SKILLS_COUNT=$(find "$REPO_ROOT/templates/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
echo "### Skills" >> "$REPORT_FILE"
echo "- **Actual Count:** $SKILLS_COUNT" >> "$REPORT_FILE"
echo "- **Expected (from README):** 11" >> "$REPORT_FILE"
if [ "$SKILLS_COUNT" != "11" ]; then
    echo "- ⚠️ **MISMATCH!** Update README to reflect $SKILLS_COUNT skills" >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# Hooks
HOOKS_COUNT=$(find "$REPO_ROOT/templates/hooks" -name "*.ts" 2>/dev/null | wc -l | tr -d ' ')
echo "### Hooks" >> "$REPORT_FILE"
echo "- **Actual Count:** $HOOKS_COUNT" >> "$REPORT_FILE"
echo "- **Expected (from README):** 14" >> "$REPORT_FILE"
if [ "$HOOKS_COUNT" != "14" ]; then
    echo "- ⚠️ **MISMATCH!** Update README to reflect $HOOKS_COUNT hooks" >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# Scripts
SCRIPTS_COUNT=$(find "$REPO_ROOT/scripts" -name "*.sh" 2>/dev/null | wc -l | tr -d ' ')
echo "### Scripts" >> "$REPORT_FILE"
echo "- **Actual Count:** $SCRIPTS_COUNT" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Documentation files
DOCS_EN=$(find "$REPO_ROOT/en" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
DOCS_SV=$(find "$REPO_ROOT/sv" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
echo "### Documentation" >> "$REPORT_FILE"
echo "- **English Docs:** $DOCS_EN" >> "$REPORT_FILE"
echo "- **Swedish Docs:** $DOCS_SV" >> "$REPORT_FILE"
if [ "$DOCS_EN" != "$DOCS_SV" ]; then
    echo "- ⚠️ **MISMATCH!** English and Swedish doc counts differ" >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# Terminology check
echo "## Terminology Consistency" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

ALL_MD_FILES=$(find "$REPO_ROOT" -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*")

# Check for consistent terminology
echo "### Key Terms Usage" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# PAI vs "Personal AI" vs other variants
PAI_COUNT=$(grep -o "PAI" $ALL_MD_FILES 2>/dev/null | wc -l | tr -d ' ')
PERSONAL_AI_COUNT=$(grep -o "Personal AI" $ALL_MD_FILES 2>/dev/null | wc -l | tr -d ' ')
echo "- **PAI:** $PAI_COUNT occurrences" >> "$REPORT_FILE"
echo "- **Personal AI:** $PERSONAL_AI_COUNT occurrences" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# UFC consistency
UFC_COUNT=$(grep -o "UFC" $ALL_MD_FILES 2>/dev/null | wc -l | tr -d ' ')
echo "- **UFC:** $UFC_COUNT occurrences" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Skills vs Skill vs skill
SKILLS_CAP=$(grep -o "Skills" $ALL_MD_FILES 2>/dev/null | wc -l | tr -d ' ')
SKILL_CAP=$(grep -o "Skill" $ALL_MD_FILES 2>/dev/null | wc -l | tr -d ' ')
echo "- **Skills (capitalized):** $SKILLS_CAP occurrences" >> "$REPORT_FILE"
echo "- **Skill (capitalized):** $SKILL_CAP occurrences" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Version references
echo "## Version References" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
grep -n "version" $REPO_ROOT/README.md 2>/dev/null || echo "No version references found" >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Cross-reference validation
echo "## Cross-Reference Validation" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check if README mentions all skills
echo "### README Coverage" >> "$REPORT_FILE"
for skill_dir in "$REPO_ROOT/templates/skills"/*; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        if grep -q "$skill_name" "$REPO_ROOT/README.md"; then
            echo "- ✅ $skill_name mentioned in README" >> "$REPORT_FILE"
        else
            echo "- ⚠️ $skill_name NOT mentioned in README" >> "$REPORT_FILE"
        fi
    fi
done
echo "" >> "$REPORT_FILE"

# File naming conventions
echo "## File Naming Conventions" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check for inconsistent naming
echo "### Uppercase Documentation Files" >> "$REPORT_FILE"
ls -1 "$REPO_ROOT"/*.md | grep -E '^[A-Z]' >> "$REPORT_FILE" 2>/dev/null || echo "None found" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "### Script Files" >> "$REPORT_FILE"
ls -1 "$REPO_ROOT/scripts"/*.sh >> "$REPORT_FILE" 2>/dev/null || echo "None found" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo ""
echo "✅ Consistency validation complete!"
echo "📄 Report: $REPORT_FILE"
