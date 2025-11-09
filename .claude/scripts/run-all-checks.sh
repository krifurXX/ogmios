#!/bin/bash

################################################################################
# Ogmios PAI - Run All Quality Checks
################################################################################
#
# Convenience script to run all validation scripts in sequence
#
# Usage:
#   ./scripts/run-all-checks.sh              # Run all checks
#   ./scripts/run-all-checks.sh --quick      # Quick mode for all
#   ./scripts/run-all-checks.sh --ci         # CI mode (exit on error)
#   ./scripts/run-all-checks.sh --help       # Show this help
#
# Exit codes:
#   0 - All checks passed
#   1 - One or more checks failed
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
PASSED=0
FAILED=0
WARNINGS=0

# Mode
QUICK_MODE=false
CI_MODE=false

################################################################################
# Parse Arguments
################################################################################

for arg in "$@"; do
    case $arg in
        --quick)
            QUICK_MODE=true
            ;;
        --ci)
            CI_MODE=true
            ;;
        --help)
            echo "Ogmios Run All Checks v${VERSION}"
            echo ""
            echo "Usage:"
            echo "  ./scripts/run-all-checks.sh           # Run all checks"
            echo "  ./scripts/run-all-checks.sh --quick   # Quick mode"
            echo "  ./scripts/run-all-checks.sh --ci      # CI mode (fail fast)"
            echo ""
            echo "Runs in order:"
            echo "  1. Security Audit"
            echo "  2. Verify Installation"
            echo "  3. Validate Skills"
            echo "  4. Validate Hooks"
            echo "  5. Check Documentation"
            echo "  6. Validate Cross-References"
            echo "  7. Count Statistics"
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
    echo -e "${BOLD}${BLUE}========================================${NC}"
    echo -e "${BOLD}${BLUE}$1${NC}"
    echo -e "${BOLD}${BLUE}========================================${NC}"
    echo ""
}

print_result() {
    local name="$1"
    local exit_code=$2

    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✅ PASSED: $name${NC}"
        PASSED=$((PASSED + 1))
    elif [ $exit_code -eq 2 ]; then
        echo -e "${YELLOW}⚠️  WARNINGS: $name${NC}"
        WARNINGS=$((WARNINGS + 1))
    else
        echo -e "${RED}❌ FAILED: $name${NC}"
        FAILED=$((FAILED + 1))

        if [ "$CI_MODE" = true ]; then
            echo -e "${RED}CI mode: Stopping on first failure${NC}"
            exit 1
        fi
    fi
}

run_check() {
    local name="$1"
    local script="$2"
    shift 2
    local args="$@"

    print_header "$name"

    if $script $args; then
        print_result "$name" 0
    else
        local exit_code=$?
        print_result "$name" $exit_code
    fi

    echo ""
}

################################################################################
# Main Execution
################################################################################

print_header "Ogmios PAI - Quality Control Suite v${VERSION}"

if [ "$QUICK_MODE" = true ]; then
    echo -e "${BLUE}Running in QUICK mode${NC}"
elif [ "$CI_MODE" = true ]; then
    echo -e "${BLUE}Running in CI mode (fail fast)${NC}"
else
    echo -e "${BLUE}Running FULL validation${NC}"
fi

echo ""
echo "Starting checks..."
echo ""

# Determine arguments for each script
VERIFY_ARGS=""
SECURITY_ARGS=""
DOC_ARGS=""

if [ "$QUICK_MODE" = true ]; then
    VERIFY_ARGS="--quick"
    SECURITY_ARGS="--quick"
    DOC_ARGS="--quick"
fi

# Run all checks
run_check "Security Audit" ./scripts/security-audit.sh $SECURITY_ARGS
run_check "Verify Installation" ./scripts/verify-installation.sh $VERIFY_ARGS
run_check "Validate Skills" ./scripts/validate-skills.sh
run_check "Validate Hooks" ./scripts/validate-hooks.sh
run_check "Check Documentation" ./scripts/check-documentation.sh $DOC_ARGS
run_check "Validate Cross-References" ./scripts/validate-cross-references.sh

# Count stats (always succeeds)
echo ""
print_header "Generating Statistics"
./scripts/count-stats.sh
echo ""

################################################################################
# Summary
################################################################################

print_header "Final Summary"

echo -e "Checks run:   ${BOLD}$((PASSED + FAILED + WARNINGS))${NC}"
echo -e "Passed:       ${GREEN}${BOLD}$PASSED${NC}"
echo -e "Warnings:     ${YELLOW}${BOLD}$WARNINGS${NC}"
echo -e "Failed:       ${RED}${BOLD}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}${BOLD}🎉 ALL CHECKS PASSED!${NC}"
    echo ""
    echo "Repository is in excellent condition:"
    echo "  ✓ No security issues"
    echo "  ✓ All files present and valid"
    echo "  ✓ Skills properly formatted"
    echo "  ✓ Hooks valid and compilable"
    echo "  ✓ Documentation complete"
    echo "  ✓ Cross-references valid"
    echo ""
    echo "Ready for release!"
    echo ""
    EXIT_CODE=0
elif [ $FAILED -eq 0 ]; then
    echo -e "${YELLOW}${BOLD}⚠️  CHECKS PASSED WITH WARNINGS${NC}"
    echo ""
    echo "Repository is functional but has minor issues."
    echo "Review warnings in the checks above."
    echo ""
    EXIT_CODE=0
else
    echo -e "${RED}${BOLD}❌ SOME CHECKS FAILED${NC}"
    echo ""
    echo "Fix the failing checks before proceeding:"
    echo ""

    if [ $FAILED -gt 0 ]; then
        echo "Failed checks: $FAILED"
    fi

    if [ $WARNINGS -gt 0 ]; then
        echo "Warnings: $WARNINGS"
    fi

    echo ""
    echo "Recommended actions:"
    echo "  1. Review error messages above"
    echo "  2. Fix critical issues first"
    echo "  3. Re-run: ./scripts/run-all-checks.sh"
    echo ""

    if [ "$QUICK_MODE" = true ]; then
        echo "Tip: Run full checks for more detail:"
        echo "  ./scripts/run-all-checks.sh"
        echo ""
    fi

    EXIT_CODE=1
fi

exit $EXIT_CODE
