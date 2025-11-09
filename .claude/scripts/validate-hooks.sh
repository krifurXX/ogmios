#!/bin/bash

################################################################################
# Ogmios PAI - Hooks Validation Script
################################################################################
#
# Validates hook files, TypeScript syntax, and dependencies
#
# Usage:
#   ./scripts/validate-hooks.sh                    # Validate all hooks
#   ./scripts/validate-hooks.sh --syntax           # Syntax check only
#   ./scripts/validate-hooks.sh --deps             # Dependencies check only
#   ./scripts/validate-hooks.sh --help             # Show this help
#
# Exit codes:
#   0 - All hooks valid
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
MODE="full"

################################################################################
# Parse Arguments
################################################################################

for arg in "$@"; do
    case $arg in
        --syntax)
            MODE="syntax"
            ;;
        --deps)
            MODE="deps"
            ;;
        --help)
            echo "Ogmios Hooks Validation Script v${VERSION}"
            echo ""
            echo "Usage:"
            echo "  ./scripts/validate-hooks.sh           # Full validation"
            echo "  ./scripts/validate-hooks.sh --syntax  # Syntax check only"
            echo "  ./scripts/validate-hooks.sh --deps    # Dependencies only"
            echo ""
            echo "Validates:"
            echo "  - Hooks in settings.json exist"
            echo "  - TypeScript syntax valid"
            echo "  - Dependencies installed"
            echo "  - No syntax errors"
            echo "  - Proper exports"
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
# Validation Functions
################################################################################

check_hooks_in_settings() {
    print_section "1️⃣  Hooks in settings.json"

    if [ ! -f "templates/settings.json" ]; then
        fail "settings.json not found"
        return 1
    fi

    pass "settings.json exists"

    # Validate JSON
    if ! python3 -m json.tool templates/settings.json > /dev/null 2>&1; then
        fail "settings.json is invalid JSON"
        return 1
    fi

    pass "settings.json is valid JSON"

    # Extract and check hook files
    local hook_files=$(python3 -c "
import json
with open('templates/settings.json') as f:
    data = json.load(f)
    hooks = data.get('hooks', [])
    for hook in hooks:
        file = hook.get('file', '')
        if file:
            print(file)
" 2>/dev/null)

    local missing_count=0
    local found_count=0

    while IFS= read -r hook_file; do
        if [ -z "$hook_file" ]; then
            continue
        fi

        local full_path="templates/hooks/$hook_file"

        if [ -f "$full_path" ]; then
            pass "✓ $hook_file"
            found_count=$((found_count + 1))
        else
            fail "$hook_file referenced but missing"
            missing_count=$((missing_count + 1))
        fi
    done <<< "$hook_files"

    info "Found $found_count hook(s), $missing_count missing"

    if [ $missing_count -gt 0 ]; then
        return 1
    fi

    return 0
}

check_typescript_syntax() {
    print_section "2️⃣  TypeScript Syntax"

    local has_tsc=false
    local has_bun=false

    # Check for TypeScript compiler
    if command -v tsc &> /dev/null; then
        has_tsc=true
        local tsc_version=$(tsc --version)
        pass "TypeScript compiler available: $tsc_version"
    else
        info "TypeScript compiler (tsc) not installed"
    fi

    # Check for Bun (can also validate TypeScript)
    if command -v bun &> /dev/null; then
        has_bun=true
        local bun_version=$(bun --version)
        pass "Bun available: $bun_version"
    else
        info "Bun not installed"
    fi

    if [ "$has_tsc" = false ] && [ "$has_bun" = false ]; then
        warn "No TypeScript validation tool available"
        warn "Install TypeScript (npm install -g typescript) or Bun (https://bun.sh)"
        return 1
    fi

    # Validate each TypeScript file
    local syntax_errors=0

    for hook_file in templates/hooks/*.ts; do
        if [ ! -f "$hook_file" ]; then
            continue
        fi

        local hook_name=$(basename "$hook_file")

        # Try TypeScript compiler first
        if [ "$has_tsc" = true ]; then
            if tsc --noEmit --skipLibCheck "$hook_file" 2>/dev/null; then
                pass "$hook_name: Valid TypeScript"
            else
                fail "$hook_name: TypeScript syntax errors"
                info "   Run: tsc --noEmit $hook_file"
                syntax_errors=$((syntax_errors + 1))
            fi
        elif [ "$has_bun" = true ]; then
            # Bun can check syntax by attempting to transpile
            if bun build "$hook_file" --target=node --outfile=/dev/null 2>/dev/null; then
                pass "$hook_name: Valid TypeScript"
            else
                fail "$hook_name: Syntax errors detected"
                syntax_errors=$((syntax_errors + 1))
            fi
        fi
    done

    # Check lib files
    for lib_file in templates/hooks/lib/*.ts; do
        if [ ! -f "$lib_file" ]; then
            continue
        fi

        local lib_name=$(basename "$lib_file")

        if [ "$has_tsc" = true ]; then
            if tsc --noEmit --skipLibCheck "$lib_file" 2>/dev/null; then
                pass "lib/$lib_name: Valid TypeScript"
            else
                warn "lib/$lib_name: TypeScript issues"
                syntax_errors=$((syntax_errors + 1))
            fi
        fi
    done

    if [ $syntax_errors -eq 0 ]; then
        pass "All TypeScript files valid"
    else
        fail "$syntax_errors file(s) with syntax errors"
    fi

    return $syntax_errors
}

check_dependencies() {
    print_section "3️⃣  Dependencies"

    if [ ! -f "templates/hooks/package.json" ]; then
        fail "package.json not found"
        return 1
    fi

    pass "package.json exists"

    # Validate package.json
    if ! python3 -m json.tool templates/hooks/package.json > /dev/null 2>&1; then
        fail "package.json is invalid JSON"
        return 1
    fi

    pass "package.json is valid JSON"

    # Extract dependencies
    local dep_count=$(python3 -c "
import json
with open('templates/hooks/package.json') as f:
    data = json.load(f)
    deps = data.get('dependencies', {})
    print(len(deps))
" 2>/dev/null || echo 0)

    info "$dep_count dependencies declared"

    # Check if node_modules would be created
    if command -v bun &> /dev/null; then
        pass "Bun available for dependency installation"

        # Check if dependencies are installable (dry run)
        info "Testing dependency installation..."

        # Create temp directory for test
        local temp_dir=$(mktemp -d)
        cp templates/hooks/package.json "$temp_dir/"

        if (cd "$temp_dir" && bun install --dry-run > /dev/null 2>&1); then
            pass "Dependencies are installable"
        else
            warn "Dependency installation may fail"
        fi

        rm -rf "$temp_dir"
    else
        warn "Bun not available - cannot verify dependencies"
    fi

    return 0
}

check_hook_exports() {
    print_section "4️⃣  Hook Exports"

    # Check that hooks export the correct structure
    local export_errors=0

    for hook_file in templates/hooks/*.ts; do
        if [ ! -f "$hook_file" ]; then
            continue
        fi

        # Skip lib files
        if [[ "$hook_file" == *"/lib/"* ]]; then
            continue
        fi

        local hook_name=$(basename "$hook_file")

        # Check for export default
        if grep -q "export default" "$hook_file"; then
            pass "$hook_name: Has export default"
        else
            warn "$hook_name: Missing export default"
            export_errors=$((export_errors + 1))
        fi

        # Check for async function (common pattern)
        if grep -q "async.*function\|async.*=>\|async.*{" "$hook_file"; then
            pass "$hook_name: Uses async patterns"
        fi
    done

    if [ $export_errors -eq 0 ]; then
        pass "All hooks have proper exports"
    else
        warn "$export_errors hook(s) with export issues"
    fi

    return $export_errors
}

check_common_patterns() {
    print_section "5️⃣  Common Patterns"

    # Check for common hook patterns
    local pattern_issues=0

    for hook_file in templates/hooks/*.ts; do
        if [ ! -f "$hook_file" ]; then
            continue
        fi

        if [[ "$hook_file" == *"/lib/"* ]]; then
            continue
        fi

        local hook_name=$(basename "$hook_file")

        # Check for error handling
        if grep -q "try.*{.*catch\|\.catch(" "$hook_file"; then
            pass "$hook_name: Has error handling"
        else
            if grep -q "async" "$hook_file"; then
                warn "$hook_name: Async code without error handling"
                pattern_issues=$((pattern_issues + 1))
            fi
        fi

        # Check for console.log (should use proper logging)
        if grep -q "console\.log\|console\.error" "$hook_file"; then
            info "$hook_name: Uses console logging"
        fi
    done

    return $pattern_issues
}

check_lib_imports() {
    print_section "6️⃣  Library Imports"

    # Check that hooks importing lib files have correct paths
    local import_errors=0

    for hook_file in templates/hooks/*.ts; do
        if [ ! -f "$hook_file" ]; then
            continue
        fi

        if [[ "$hook_file" == *"/lib/"* ]]; then
            continue
        fi

        local hook_name=$(basename "$hook_file")

        # Extract import statements
        while IFS= read -r line; do
            if [[ "$line" =~ from[[:space:]]+[\'\"](.*)[\'\" ] ]]; then
                local import_path="${BASH_REMATCH[1]}"

                # Check if it's a local import
                if [[ "$import_path" == ./lib/* ]] || [[ "$import_path" == lib/* ]]; then
                    # Extract filename
                    local lib_file=$(basename "$import_path" .ts).ts
                    local lib_path="templates/hooks/lib/$lib_file"

                    if [ -f "$lib_path" ]; then
                        pass "$hook_name: Import $lib_file exists"
                    else
                        fail "$hook_name: Missing import: $lib_file"
                        import_errors=$((import_errors + 1))
                    fi
                fi
            fi
        done < <(grep "import.*from" "$hook_file" 2>/dev/null || true)
    done

    if [ $import_errors -eq 0 ]; then
        pass "All library imports valid"
    else
        fail "$import_errors broken import(s)"
    fi

    return $import_errors
}

################################################################################
# Main Execution
################################################################################

print_header "Ogmios Hooks Validation v${VERSION}"
echo ""

if [ "$MODE" = "syntax" ]; then
    info "Running syntax validation only..."
    check_typescript_syntax
elif [ "$MODE" = "deps" ]; then
    info "Running dependency check only..."
    check_dependencies
else
    info "Running full hook validation..."
    check_hooks_in_settings
    check_typescript_syntax
    check_dependencies
    check_hook_exports
    check_common_patterns
    check_lib_imports
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
    echo -e "${GREEN}${BOLD}🎉 All hooks are valid!${NC}"
    echo ""
    echo "✓ Hooks in settings.json exist"
    echo "✓ TypeScript syntax valid"
    echo "✓ Dependencies correct"
    echo "✓ Exports proper"
    echo "✓ Imports valid"
    echo ""
    EXIT_CODE=0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}${BOLD}⚠️  Hooks valid with warnings.${NC}"
    echo ""
    echo "No critical errors, but review warnings above."
    echo ""
    EXIT_CODE=2
else
    echo -e "${RED}${BOLD}❌ Hook validation failed!${NC}"
    echo ""
    echo "Fix the errors above to ensure hooks work correctly."
    echo ""
    if ! command -v tsc &> /dev/null && ! command -v bun &> /dev/null; then
        echo "Tip: Install TypeScript or Bun for full validation:"
        echo "  npm install -g typescript"
        echo "  # or"
        echo "  curl -fsSL https://bun.sh/install | bash"
        echo ""
    fi
    EXIT_CODE=1
fi

exit $EXIT_CODE
