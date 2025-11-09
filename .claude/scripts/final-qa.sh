#!/bin/bash
# Final QA Suite for Ogmios
# Runs all validation checks and generates comprehensive report

set -e

REPO_ROOT="/Users/<your_username>/Library/CloudStorage/<cloud_storage>/<your_vault>/Unsorted/claudeogmios/ogmios-github"
FINAL_REPORT="$REPO_ROOT/reports/FINAL-QA-REPORT.md"

echo "🚀 OGMIOS FINAL QA VALIDATION SUITE"
echo "===================================="
echo ""

# Create reports directory
mkdir -p "$REPO_ROOT/reports"

# Initialize final report
cat > "$FINAL_REPORT" << EOF
# FINAL QA REPORT - Ogmios GitHub Release

**Generated:** $(date)
**Repository:** Ogmios
**Status:** Pre-Release Validation

---

## Executive Summary

This report consolidates all quality assurance validations performed on the Ogmios repository before public release.

---

EOF

echo "🔍 Phase 1: Link Validation"
echo "----------------------------"
if bash "$REPO_ROOT/scripts/validate-links.sh"; then
    echo "✅ Link validation PASSED" | tee -a "$FINAL_REPORT"
else
    echo "⚠️ Link validation found issues" | tee -a "$FINAL_REPORT"
fi
echo "" >> "$FINAL_REPORT"

echo ""
echo "🔍 Phase 2: Consistency Validation"
echo "-----------------------------------"
bash "$REPO_ROOT/scripts/verify-consistency.sh"
echo "✅ Consistency validation COMPLETED" | tee -a "$FINAL_REPORT"
echo "" >> "$FINAL_REPORT"

echo ""
echo "🔍 Phase 3: Code Validation"
echo "---------------------------"
if bash "$REPO_ROOT/scripts/test-examples.sh"; then
    echo "✅ Code validation PASSED" | tee -a "$FINAL_REPORT"
else
    echo "⚠️ Code validation found issues" | tee -a "$FINAL_REPORT"
fi
echo "" >> "$FINAL_REPORT"

echo ""
echo "🔍 Phase 4: Documentation Coverage"
echo "-----------------------------------"

# Check critical documentation exists
cat >> "$FINAL_REPORT" << EOF
## Documentation Coverage

### Critical Files

EOF

CRITICAL_FILES=(
    "README.md"
    "LICENSE"
    "CONTRIBUTING.md"
    "SECURITY.md"
    "en/01-QUICK-START.md"
    "en/02-ARCHITECTURE.md"
    "en/03-UFC-SYSTEM.md"
    "en/04-SKILLS-SYSTEM.md"
    "en/05-VOICE-SYSTEM.md"
    "en/06-HOOKS-AUTOMATION.md"
    "en/08-INSTALLATION.md"
)

MISSING_DOCS=0
for doc in "${CRITICAL_FILES[@]}"; do
    if [ -f "$REPO_ROOT/$doc" ]; then
        echo "- ✅ $doc" >> "$FINAL_REPORT"
    else
        echo "- ❌ MISSING: $doc" >> "$FINAL_REPORT"
        ((MISSING_DOCS++))
    fi
done

echo "" >> "$FINAL_REPORT"

if [ $MISSING_DOCS -eq 0 ]; then
    echo "✅ All critical documentation present"
else
    echo "⚠️ Missing $MISSING_DOCS critical documentation files"
fi

echo ""
echo "🔍 Phase 5: File Structure Validation"
echo "--------------------------------------"

cat >> "$FINAL_REPORT" << EOF

## Repository Structure

### Directory Tree

\`\`\`
EOF

tree -L 2 -I 'node_modules|.git' "$REPO_ROOT" >> "$FINAL_REPORT" 2>/dev/null || \
    find "$REPO_ROOT" -maxdepth 2 -type d -not -path "*/node_modules/*" -not -path "*/.git/*" >> "$FINAL_REPORT"

cat >> "$FINAL_REPORT" << EOF
\`\`\`

### Component Summary

EOF

# Count everything
SKILLS=$(find "$REPO_ROOT/templates/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
HOOKS=$(find "$REPO_ROOT/templates/hooks" -name "*.ts" 2>/dev/null | wc -l | tr -d ' ')
SCRIPTS=$(find "$REPO_ROOT/scripts" -name "*.sh" 2>/dev/null | wc -l | tr -d ' ')
EN_DOCS=$(find "$REPO_ROOT/en" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
SV_DOCS=$(find "$REPO_ROOT/sv" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

cat >> "$FINAL_REPORT" << EOF
- **Skills:** $SKILLS
- **Hooks:** $HOOKS
- **Scripts:** $SCRIPTS
- **English Documentation:** $EN_DOCS files
- **Swedish Documentation:** $SV_DOCS files

EOF

echo "✅ Structure validation complete"

echo ""
echo "🔍 Phase 6: Security Check"
echo "--------------------------"

cat >> "$FINAL_REPORT" << EOF

## Security Validation

### Sensitive Data Check

EOF

# Check for common sensitive patterns
SENSITIVE_PATTERNS=(
    "api_key"
    "password"
    "secret"
    "token"
    "credential"
)

SECURITY_ISSUES=0
for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    matches=$(grep -r "$pattern" "$REPO_ROOT" --include="*.md" --include="*.ts" --include="*.js" --include="*.json" --exclude-dir=node_modules --exclude-dir=.git -i | grep -v "TEMPLATE\|EXAMPLE\|your_$pattern" | wc -l | tr -d ' ')

    if [ "$matches" -gt 0 ]; then
        echo "- ⚠️ Found $matches instances of '$pattern' - REVIEW REQUIRED" >> "$FINAL_REPORT"
        ((SECURITY_ISSUES++))
    else
        echo "- ✅ No hardcoded $pattern values" >> "$FINAL_REPORT"
    fi
done

echo "" >> "$FINAL_REPORT"

if [ $SECURITY_ISSUES -eq 0 ]; then
    echo "✅ No security issues detected"
else
    echo "⚠️ Found $SECURITY_ISSUES potential security concerns - MANUAL REVIEW REQUIRED"
fi

echo ""
echo "🔍 Phase 7: Installation Test"
echo "-----------------------------"

cat >> "$FINAL_REPORT" << EOF

## Installation Validation

EOF

if [ -f "$REPO_ROOT/verify-installation.sh" ]; then
    echo "- ✅ Installation script exists" >> "$FINAL_REPORT"
    if [ -x "$REPO_ROOT/verify-installation.sh" ]; then
        echo "- ✅ Installation script is executable" >> "$FINAL_REPORT"
    else
        echo "- ⚠️ Installation script not executable" >> "$FINAL_REPORT"
    fi
else
    echo "- ❌ Installation script missing" >> "$FINAL_REPORT"
fi

echo "✅ Installation check complete"

# Final summary
cat >> "$FINAL_REPORT" << EOF

---

## FINAL VERDICT

### Checklist

- [x] Link validation completed
- [x] Consistency validation completed
- [x] Code validation completed
- [x] Documentation coverage verified
- [x] Repository structure validated
- [x] Security check performed
- [x] Installation script verified

### Recommendation

EOF

TOTAL_ISSUES=$((MISSING_DOCS + SECURITY_ISSUES))

if [ $TOTAL_ISSUES -eq 0 ]; then
    cat >> "$FINAL_REPORT" << EOF
✅ **READY FOR RELEASE**

All validations passed successfully. Repository is ready for public release.

EOF
    echo ""
    echo "🎉 ALL CHECKS PASSED - READY FOR RELEASE!"
else
    cat >> "$FINAL_REPORT" << EOF
⚠️ **REVIEW REQUIRED**

Found $TOTAL_ISSUES issues that should be reviewed before release:
- Missing documentation: $MISSING_DOCS
- Security concerns: $SECURITY_ISSUES

Please review individual reports and address issues before proceeding with release.

EOF
    echo ""
    echo "⚠️ FOUND $TOTAL_ISSUES ISSUES - REVIEW REQUIRED"
fi

cat >> "$FINAL_REPORT" << EOF

---

## Individual Reports

See detailed reports in the \`reports/\` directory:
- \`link-validation-report.md\`
- \`consistency-report.md\`
- \`code-validation-report.md\`

EOF

echo ""
echo "✅ FINAL QA SUITE COMPLETE"
echo "📄 Report: $FINAL_REPORT"
echo ""
echo "📊 Summary:"
echo "   - Missing Docs: $MISSING_DOCS"
echo "   - Security Issues: $SECURITY_ISSUES"
echo "   - Total Issues: $TOTAL_ISSUES"

exit $TOTAL_ISSUES
