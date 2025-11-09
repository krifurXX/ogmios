#!/bin/bash

# Link Update Script for Ogmios Documentation Restructure
# This script updates all internal documentation links to the new structure

set -e

PROJECT_ROOT="/Users/carlheath/Library/CloudStorage/OneDrive-Privat/Arkivet/Unsorted/claudeogmios/ogmios-github"
cd "$PROJECT_ROOT"

echo "================================"
echo "Ogmios Link Update Script"
echo "================================"
echo ""

# Create log file
LOG_FILE="LINK-UPDATE-LOG.md"
echo "# Link Update Log" > "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Date: $(date)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "## Updates Applied" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

update_count=0

# Function to update links in a file
update_file_links() {
    local file="$1"
    local temp_file="${file}.tmp"

    # Skip if file doesn't exist
    if [ ! -f "$file" ]; then
        return
    fi

    echo "Updating: $file"

    # Create backup
    cp "$file" "$temp_file"

    # Apply all link transformations
    sed -i '' \
        -e 's|en/01-README\.md|docs/01-getting-started/overview.md|g' \
        -e 's|en/02-ARCHITECTURE\.md|docs/03-architecture/system-design.md|g' \
        -e 's|en/03-UFC-SYSTEM\.md|docs/02-core-concepts/ufc-context.md|g' \
        -e 's|en/04-SKILLS-SYSTEM\.md|docs/02-core-concepts/skills.md|g' \
        -e 's|en/05-VOICE-SYSTEM\.md|docs/02-core-concepts/voice.md|g' \
        -e 's|en/06-HOOKS-AUTOMATION\.md|docs/02-core-concepts/hooks.md|g' \
        -e 's|en/07-BILINGUAL\.md|docs/06-bilingual/bilingual-support.md|g' \
        -e 's|en/08-INSTALLATION\.md|docs/01-getting-started/installation.md|g' \
        -e 's|en/09-CUSTOMIZATION\.md|docs/04-guides/customization.md|g' \
        -e 's|en/10-FAQ\.md|docs/08-faq/faq.md|g' \
        -e 's|en/11-COMPARISON\.md|docs/08-faq/comparison.md|g' \
        -e 's|en/12-TROUBLESHOOTING\.md|docs/01-getting-started/troubleshooting.md|g' \
        -e 's|en/13-MCP-INTEGRATION\.md|docs/02-core-concepts/mcp.md|g' \
        -e 's|sv/01-README\.md|docs/06-bilingual/svenska/oversikt.md|g' \
        -e 's|sv/02-ARKITEKTUR\.md|docs/06-bilingual/svenska/arkitektur.md|g' \
        -e 's|sv/03-UFC-SYSTEM\.md|docs/06-bilingual/svenska/ufc-systemet.md|g' \
        -e 's|sv/04-SKILLS-SYSTEM\.md|docs/06-bilingual/svenska/skills-systemet.md|g' \
        -e 's|sv/05-VOICE-SYSTEM\.md|docs/06-bilingual/svenska/rost-systemet.md|g' \
        -e 's|sv/06-HOOKS-AUTOMATION\.md|docs/06-bilingual/svenska/hooks-automation.md|g' \
        -e 's|sv/08-INSTALLATION\.md|docs/06-bilingual/svenska/installation.md|g' \
        -e 's|sv/09-ANPASSNING\.md|docs/06-bilingual/svenska/anpassning.md|g' \
        -e 's|sv/10-FAQ\.md|docs/06-bilingual/svenska/faq.md|g' \
        -e 's|sv/12-FELSOKNING\.md|docs/06-bilingual/svenska/felsokning.md|g' \
        -e 's|documentation/OGMIOS-DEVELOPMENT-PLAN\.md|docs/03-architecture/development-plan.md|g' \
        -e 's|documentation/voice-system\.md|docs/02-core-concepts/voice.md|g' \
        -e 's|documentation/architecture\.md|docs/03-architecture/system-design.md|g' \
        -e 's|documentation/UFC\.md|docs/02-core-concepts/ufc-context.md|g' \
        -e 's|documentation/skills\.md|docs/02-core-concepts/skills.md|g' \
        -e 's|documentation/hooks\.md|docs/02-core-concepts/hooks.md|g' \
        "$file"

    # Check if file changed
    if ! cmp -s "$file" "$temp_file"; then
        echo "  ✓ Updated links in $file" >> "$LOG_FILE"
        ((update_count++))
    fi

    rm "$temp_file"
}

# Update README.md
echo "Updating root README.md..."
update_file_links "README.md"

# Update CONTRIBUTING.md
echo "Updating CONTRIBUTING.md..."
update_file_links "CONTRIBUTING.md"

# Update all docs/*.md files
echo "Updating documentation files..."
find docs -name "*.md" -type f | while read -r file; do
    update_file_links "$file"
done

# Update template files
echo "Updating template files..."
find templates -name "*.md" -type f | while read -r file; do
    update_file_links "$file"
done

# Update example files
echo "Updating example files..."
find examples -name "*.md" -type f | while read -r file; do
    update_file_links "$file"
done

# Update script files
echo "Updating script documentation..."
find scripts -name "*.md" -type f | while read -r file; do
    update_file_links "$file"
done

echo "" >> "$LOG_FILE"
echo "## Summary" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "- Total files updated: $update_count" >> "$LOG_FILE"
echo "- Date: $(date)" >> "$LOG_FILE"

echo ""
echo "================================"
echo "Link Update Complete"
echo "================================"
echo "Files updated: $update_count"
echo "Log saved to: $LOG_FILE"
echo ""
