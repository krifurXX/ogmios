#!/bin/bash

################################################################################
# Ogmios PAI - Security Audit Script
################################################################################
#
# Scans the repository for potential personal data leaks and security issues
#
# Usage:
#   ./scripts/security-audit.sh                    # Full audit
#   ./scripts/security-audit.sh --quick            # Quick scan only
#   ./scripts/security-audit.sh --report FILE      # Save report to file
#   ./scripts/security-audit.sh --help             # Show this help
#
# Exit codes:
#   0 - No security issues found
#   1 - Security issues found
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
CRITICAL=0
WARNINGS=0
TOTAL_SCANNED=0

# Mode
MODE="full"
REPORT_FILE=""

# Directories to scan
SCAN_DIRS=("templates" "en" "sv" "examples" "voice-server")

################################################################################
# Parse Arguments
################################################################################

for arg in "$@"; do
    case $arg in
        --quick)
            MODE="quick"
            ;;
        --report)
            shift
            REPORT_FILE="$1"
            shift
            ;;
        --help)
            echo "Ogmios Security Audit Script v${VERSION}"
            echo ""
            echo "Usage:"
            echo "  ./scripts/security-audit.sh                    # Full audit"
            echo "  ./scripts/security-audit.sh --quick            # Quick scan"
            echo "  ./scripts/security-audit.sh --report FILE      # Save to file"
            echo ""
            echo "Checks for:"
            echo "  - Email addresses"
            echo "  - Phone numbers"
            echo "  - Real names (except documented personas)"
            echo "  - API keys and tokens"
            echo "  - Private file paths"
            echo "  - IP addresses"
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

critical() {
    echo -e "${RED}🔴 CRITICAL: $1${NC}"
    CRITICAL=$((CRITICAL + 1))
}

warn() {
    echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
    WARNINGS=$((WARNINGS + 1))
}

pass() {
    echo -e "${GREEN}✅ $1${NC}"
}

info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_to_report() {
    if [ ! -z "$REPORT_FILE" ]; then
        echo "$1" >> "$REPORT_FILE"
    fi
}

################################################################################
# Scanning Functions
################################################################################

scan_for_emails() {
    print_section "📧 Email Addresses"

    EMAIL_PATTERN='[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'

    # Allowed emails (examples, documentation)
    ALLOWED_EMAILS=(
        "noreply@anthropic.com"
        "example@example.com"
        "user@example.com"
        "your.email@example.com"
    )

    FOUND_COUNT=0
    for dir in "${SCAN_DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            continue
        fi

        while IFS= read -r line; do
            FILE=$(echo "$line" | cut -d: -f1)
            LINENUM=$(echo "$line" | cut -d: -f2)
            CONTENT=$(echo "$line" | cut -d: -f3-)

            # Extract email
            EMAIL=$(echo "$CONTENT" | grep -oE "$EMAIL_PATTERN" | head -1)

            # Check if allowed
            IS_ALLOWED=false
            for allowed in "${ALLOWED_EMAILS[@]}"; do
                if [[ "$EMAIL" == "$allowed" ]]; then
                    IS_ALLOWED=true
                    break
                fi
            done

            if [ "$IS_ALLOWED" = false ]; then
                critical "Email found: $FILE:$LINENUM"
                info "   Content: $EMAIL"
                log_to_report "EMAIL: $FILE:$LINENUM - $EMAIL"
                FOUND_COUNT=$((FOUND_COUNT + 1))
            fi
        done < <(grep -rn -E "$EMAIL_PATTERN" "$dir" 2>/dev/null | grep -v ".git" | grep -v "node_modules" || true)
    done

    if [ $FOUND_COUNT -eq 0 ]; then
        pass "No unauthorized emails found"
    else
        critical "$FOUND_COUNT email address(es) found - MUST REMOVE"
    fi
}

scan_for_phone_numbers() {
    print_section "📱 Phone Numbers"

    # Various phone number patterns
    PHONE_PATTERNS=(
        '\+[0-9]{1,3}[- ]?[0-9]{3,4}[- ]?[0-9]{4,}'  # International
        '\([0-9]{3}\)[- ]?[0-9]{3}[- ]?[0-9]{4}'     # US format
        '[0-9]{3}[-. ]?[0-9]{3}[-. ]?[0-9]{4}'       # Generic
    )

    FOUND_COUNT=0
    for pattern in "${PHONE_PATTERNS[@]}"; do
        for dir in "${SCAN_DIRS[@]}"; do
            if [ ! -d "$dir" ]; then
                continue
            fi

            while IFS= read -r line; do
                FILE=$(echo "$line" | cut -d: -f1)
                LINENUM=$(echo "$line" | cut -d: -f2)
                CONTENT=$(echo "$line" | cut -d: -f3-)

                critical "Phone number found: $FILE:$LINENUM"
                info "   Content: $CONTENT"
                log_to_report "PHONE: $FILE:$LINENUM - $CONTENT"
                FOUND_COUNT=$((FOUND_COUNT + 1))
            done < <(grep -rn -E "$pattern" "$dir" 2>/dev/null | grep -v ".git" | grep -v "node_modules" || true)
        done
    done

    if [ $FOUND_COUNT -eq 0 ]; then
        pass "No phone numbers found"
    else
        critical "$FOUND_COUNT phone number(s) found - MUST REMOVE"
    fi
}

scan_for_real_names() {
    print_section "👤 Real Names (Non-Persona)"

    # Personal names to check for (excluding documented personas)
    PERSONAL_NAMES=(
        "<YOUR_NAME>"
        "<your_username>"
        "Heath, <YOUR_NAME>"
    )

    # Allowed names (personas in documentation)
    ALLOWED_NAMES=(
        "Claude"
        "Ogmios"
        "Daniel Miessler"
    )

    FOUND_COUNT=0
    for name in "${PERSONAL_NAMES[@]}"; do
        for dir in "${SCAN_DIRS[@]}"; do
            if [ ! -d "$dir" ]; then
                continue
            fi

            while IFS= read -r line; do
                FILE=$(echo "$line" | cut -d: -f1)
                LINENUM=$(echo "$line" | cut -d: -f2)

                critical "Personal name found: $FILE:$LINENUM"
                info "   Name: $name"
                log_to_report "NAME: $FILE:$LINENUM - $name"
                FOUND_COUNT=$((FOUND_COUNT + 1))
            done < <(grep -rn -i "$name" "$dir" 2>/dev/null | grep -v ".git" | grep -v "node_modules" || true)
        done
    done

    if [ $FOUND_COUNT -eq 0 ]; then
        pass "No personal names found"
    else
        critical "$FOUND_COUNT personal name(s) found - MUST REMOVE"
    fi
}

scan_for_api_keys() {
    print_section "🔑 API Keys and Tokens"

    # Common API key patterns
    API_PATTERNS=(
        'api[_-]?key["\s:=]+[a-zA-Z0-9]{20,}'
        'token["\s:=]+[a-zA-Z0-9]{20,}'
        'secret["\s:=]+[a-zA-Z0-9]{20,}'
        'ELEVENLABS_API_KEY\s*=\s*["\x27][a-zA-Z0-9]+'
        'ANTHROPIC_API_KEY\s*=\s*["\x27]sk-ant-[a-zA-Z0-9]+'
        'sk-ant-[a-zA-Z0-9]{95,}'  # Anthropic key format
        'sk-[a-zA-Z0-9]{48}'        # OpenAI key format
    )

    FOUND_COUNT=0
    for pattern in "${API_PATTERNS[@]}"; do
        for dir in "${SCAN_DIRS[@]}"; do
            if [ ! -d "$dir" ]; then
                continue
            fi

            # Skip .env.example files (they contain templates)
            while IFS= read -r line; do
                FILE=$(echo "$line" | cut -d: -f1)

                # Skip example files
                if [[ "$FILE" == *".example"* ]] || [[ "$FILE" == *".env.example"* ]]; then
                    continue
                fi

                LINENUM=$(echo "$line" | cut -d: -f2)
                CONTENT=$(echo "$line" | cut -d: -f3-)

                critical "Potential API key found: $FILE:$LINENUM"
                info "   Pattern: $(echo $CONTENT | sed 's/[a-zA-Z0-9]\{20,\}/***REDACTED***/g')"
                log_to_report "API_KEY: $FILE:$LINENUM"
                FOUND_COUNT=$((FOUND_COUNT + 1))
            done < <(grep -rn -iE "$pattern" "$dir" 2>/dev/null | grep -v ".git" | grep -v "node_modules" | grep -v ".example" || true)
        done
    done

    if [ $FOUND_COUNT -eq 0 ]; then
        pass "No API keys found"
    else
        critical "$FOUND_COUNT potential API key(s) found - VERIFY AND REMOVE"
    fi
}

scan_for_private_paths() {
    print_section "📁 Private File Paths"

    # Private path patterns
    PRIVATE_PATTERNS=(
        "/Users/[a-zA-Z0-9_-]+"
        "/home/[a-zA-Z0-9_-]+"
        "C:\\\\Users\\\\[a-zA-Z0-9_-]+"
        "OneDrive"
        "Dropbox"
        "Google Drive"
    )

    # Allowed patterns (documentation examples)
    ALLOWED_PATTERNS=(
        "/Users/username"
        "~/.claude"
        "\$HOME"
    )

    FOUND_COUNT=0
    for pattern in "${PRIVATE_PATTERNS[@]}"; do
        for dir in "${SCAN_DIRS[@]}"; do
            if [ ! -d "$dir" ]; then
                continue
            fi

            while IFS= read -r line; do
                FILE=$(echo "$line" | cut -d: -f1)
                LINENUM=$(echo "$line" | cut -d: -f2)
                CONTENT=$(echo "$line" | cut -d: -f3-)

                # Check if it's an allowed pattern
                IS_ALLOWED=false
                for allowed in "${ALLOWED_PATTERNS[@]}"; do
                    if [[ "$CONTENT" == *"$allowed"* ]]; then
                        IS_ALLOWED=true
                        break
                    fi
                done

                if [ "$IS_ALLOWED" = false ]; then
                    warn "Private path found: $FILE:$LINENUM"
                    info "   Content: $(echo $CONTENT | cut -c1-80)"
                    log_to_report "PATH: $FILE:$LINENUM - $CONTENT"
                    FOUND_COUNT=$((FOUND_COUNT + 1))
                fi
            done < <(grep -rn -E "$pattern" "$dir" 2>/dev/null | grep -v ".git" | grep -v "node_modules" || true)
        done
    done

    if [ $FOUND_COUNT -eq 0 ]; then
        pass "No private paths found"
    else
        warn "$FOUND_COUNT private path(s) found - REVIEW"
    fi
}

scan_for_ip_addresses() {
    print_section "🌐 IP Addresses"

    IP_PATTERN='[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'

    # Allowed IPs (localhost, examples)
    ALLOWED_IPS=(
        "127.0.0.1"
        "0.0.0.0"
        "localhost"
        "192.168"  # Local network examples are OK
    )

    FOUND_COUNT=0
    for dir in "${SCAN_DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            continue
        fi

        while IFS= read -r line; do
            FILE=$(echo "$line" | cut -d: -f1)
            LINENUM=$(echo "$line" | cut -d: -f2)
            CONTENT=$(echo "$line" | cut -d: -f3-)

            # Extract IP
            IP=$(echo "$CONTENT" | grep -oE "$IP_PATTERN" | head -1)

            # Check if allowed
            IS_ALLOWED=false
            for allowed in "${ALLOWED_IPS[@]}"; do
                if [[ "$IP" == "$allowed"* ]] || [[ "$IP" == *"$allowed" ]]; then
                    IS_ALLOWED=true
                    break
                fi
            done

            if [ "$IS_ALLOWED" = false ]; then
                warn "IP address found: $FILE:$LINENUM"
                info "   IP: $IP"
                log_to_report "IP: $FILE:$LINENUM - $IP"
                FOUND_COUNT=$((FOUND_COUNT + 1))
            fi
        done < <(grep -rn -E "$IP_PATTERN" "$dir" 2>/dev/null | grep -v ".git" | grep -v "node_modules" || true)
    done

    if [ $FOUND_COUNT -eq 0 ]; then
        pass "No unauthorized IP addresses found"
    else
        warn "$FOUND_COUNT IP address(es) found - REVIEW"
    fi
}

scan_for_credentials() {
    print_section "🔐 Hardcoded Credentials"

    # Credential patterns
    CRED_PATTERNS=(
        'password\s*=\s*["\x27][^"\x27]{3,}'
        'passwd\s*=\s*["\x27][^"\x27]{3,}'
        'pwd\s*=\s*["\x27][^"\x27]{3,}'
        'auth\s*=\s*["\x27][^"\x27]{3,}'
    )

    FOUND_COUNT=0
    for pattern in "${CRED_PATTERNS[@]}"; do
        for dir in "${SCAN_DIRS[@]}"; do
            if [ ! -d "$dir" ]; then
                continue
            fi

            while IFS= read -r line; do
                FILE=$(echo "$line" | cut -d: -f1)

                # Skip example and documentation files
                if [[ "$FILE" == *".example"* ]] || [[ "$FILE" == *".md"* ]]; then
                    continue
                fi

                LINENUM=$(echo "$line" | cut -d: -f2)

                critical "Hardcoded credential found: $FILE:$LINENUM"
                info "   Pattern matched: password/auth assignment"
                log_to_report "CREDENTIAL: $FILE:$LINENUM"
                FOUND_COUNT=$((FOUND_COUNT + 1))
            done < <(grep -rn -iE "$pattern" "$dir" 2>/dev/null | grep -v ".git" | grep -v "node_modules" | grep -v ".example" | grep -v ".md" || true)
        done
    done

    if [ $FOUND_COUNT -eq 0 ]; then
        pass "No hardcoded credentials found"
    else
        critical "$FOUND_COUNT hardcoded credential(s) found - MUST REMOVE"
    fi
}

scan_for_sensitive_comments() {
    print_section "💬 Sensitive Comments"

    # Patterns that might indicate sensitive info in comments
    SENSITIVE_PATTERNS=(
        "# TODO.*password"
        "# TODO.*secret"
        "// FIXME.*auth"
        "# NOTE:.*production"
        "# XXX"
    )

    FOUND_COUNT=0
    for pattern in "${SENSITIVE_PATTERNS[@]}"; do
        for dir in "${SCAN_DIRS[@]}"; do
            if [ ! -d "$dir" ]; then
                continue
            fi

            while IFS= read -r line; do
                FILE=$(echo "$line" | cut -d: -f1)
                LINENUM=$(echo "$line" | cut -d: -f2)
                CONTENT=$(echo "$line" | cut -d: -f3-)

                warn "Sensitive comment found: $FILE:$LINENUM"
                info "   Content: $(echo $CONTENT | cut -c1-80)"
                log_to_report "COMMENT: $FILE:$LINENUM - $CONTENT"
                FOUND_COUNT=$((FOUND_COUNT + 1))
            done < <(grep -rn -iE "$pattern" "$dir" 2>/dev/null | grep -v ".git" | grep -v "node_modules" || true)
        done
    done

    if [ $FOUND_COUNT -eq 0 ]; then
        pass "No sensitive comments found"
    else
        warn "$FOUND_COUNT sensitive comment(s) found - REVIEW"
    fi
}

check_env_files() {
    print_section "📄 .env Files"

    # Check for .env files (should not be in repo)
    FOUND_COUNT=0
    for dir in "${SCAN_DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            continue
        fi

        while IFS= read -r file; do
            # .env.example is OK
            if [[ "$file" == *".env.example"* ]]; then
                continue
            fi

            critical ".env file found (should not be in repo): $file"
            log_to_report "ENV_FILE: $file"
            FOUND_COUNT=$((FOUND_COUNT + 1))
        done < <(find "$dir" -name ".env" -o -name "*.env" 2>/dev/null | grep -v ".env.example" || true)
    done

    if [ $FOUND_COUNT -eq 0 ]; then
        pass "No .env files in repository"
    else
        critical "$FOUND_COUNT .env file(s) found - MUST REMOVE from git"
    fi
}

count_scanned_files() {
    TOTAL_SCANNED=0
    for dir in "${SCAN_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            COUNT=$(find "$dir" -type f 2>/dev/null | wc -l)
            TOTAL_SCANNED=$((TOTAL_SCANNED + COUNT))
        fi
    done
}

################################################################################
# Main Execution
################################################################################

print_header "Ogmios PAI - Security Audit v${VERSION}"
echo ""

if [ ! -z "$REPORT_FILE" ]; then
    echo "# Ogmios Security Audit Report" > "$REPORT_FILE"
    echo "Generated: $(date)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    info "Report will be saved to: $REPORT_FILE"
fi

count_scanned_files
info "Scanning $TOTAL_SCANNED files in ${#SCAN_DIRS[@]} directories"
echo ""

if [ "$MODE" = "quick" ]; then
    info "Running quick security scan..."
    scan_for_emails
    scan_for_api_keys
    check_env_files
else
    info "Running full security audit..."
    scan_for_emails
    scan_for_phone_numbers
    scan_for_real_names
    scan_for_api_keys
    scan_for_private_paths
    scan_for_ip_addresses
    scan_for_credentials
    scan_for_sensitive_comments
    check_env_files
fi

################################################################################
# Summary
################################################################################

print_header "📊 Security Audit Summary"
echo ""

echo -e "Files scanned:    ${BOLD}$TOTAL_SCANNED${NC}"
echo -e "Critical issues:  ${RED}${BOLD}$CRITICAL${NC}"
echo -e "Warnings:         ${YELLOW}${BOLD}$WARNINGS${NC}"
echo ""

if [ ! -z "$REPORT_FILE" ]; then
    echo "Critical issues: $CRITICAL" >> "$REPORT_FILE"
    echo "Warnings: $WARNINGS" >> "$REPORT_FILE"
    info "Full report saved to: $REPORT_FILE"
    echo ""
fi

if [ $CRITICAL -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}${BOLD}🎉 No security issues found!${NC}"
    echo ""
    echo "Repository is clean and ready for public release."
    echo ""
    EXIT_CODE=0
elif [ $CRITICAL -eq 0 ]; then
    echo -e "${YELLOW}${BOLD}⚠️  Warnings found.${NC}"
    echo ""
    echo "No critical issues, but review warnings above."
    echo "These may be false positives or acceptable content."
    echo ""
    EXIT_CODE=2
else
    echo -e "${RED}${BOLD}❌ CRITICAL SECURITY ISSUES FOUND!${NC}"
    echo ""
    echo "DO NOT COMMIT OR PUSH until these are resolved:"
    echo ""
    echo "1. Review all CRITICAL items above"
    echo "2. Remove or redact sensitive data"
    echo "3. Update .gitignore if needed"
    echo "4. Run this script again to verify"
    echo ""
    echo "REMEMBER: Once pushed to GitHub, data is PERMANENT in git history!"
    echo ""
    EXIT_CODE=1
fi

exit $EXIT_CODE
