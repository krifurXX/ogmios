# CORE Skill Template

**Foundation of Ogmios Progressive Disclosure System**

This template provides the essential CORE skill that powers the two-tier progressive disclosure architecture in Personal AI Infrastructure (PAI) systems.

## Overview

The CORE skill implements a progressive disclosure strategy:

- **Tier 1 (Always On)**: Essential context embedded in system prompt (~1500-2000 tokens)
- **Tier 2 (On Demand)**: Extended context loaded from SKILL.md for comprehensive tasks

## Structure

### Tier 1: System Prompt (Always Active)

Located in YAML frontmatter `description` field:

1. **Core Identity**
   - AI assistant name and role
   - Personality traits
   - Operating environment
   - Personal message to AI

2. **Essential Contacts**
   - Top 3 most-used contacts
   - Quick reference for immediate access

3. **Core Stack Preferences**
   - Primary programming language
   - Package manager preferences
   - Analysis vs action guidelines
   - Scratchpad usage

4. **Critical Security**
   - Git commit safety
   - Repository verification
   - Private data protection
   - Custom warnings

5. **Response Format**
   - Structured response template
   - Voice completion format
   - Consistency guidelines

### Tier 2: Extended Context (On Demand)

Located in markdown body of SKILL.md:

1. **Extended Contact List**
   - Complete contact database
   - Social media accounts
   - First-name lookup system

2. **Agent Voice IDs**
   - ElevenLabs voice routing
   - Per-agent voice configurations
   - Multi-language support

3. **Extended Security Procedures**
   - Detailed repository safety
   - Infrastructure caution lists
   - Approval workflows

4. **Additional Sections** (Optional)
   - Language preferences
   - Project structure preferences
   - Development principles
   - Custom commands

## Usage

### Setup

1. **Copy template to your PAI:**
   ```bash
   cp templates/skills/CORE/SKILL.md ~/.claude/.claude/skills/CORE/SKILL.md
   ```

2. **Replace all placeholders:**
   - `<AI_ASSISTANT_NAME>` - Your AI's name (e.g., "Ogmios", "Nova", "Atlas")
   - `<AI_ROLE_DESCRIPTION>` - Role definition
   - `<PERSONALITY_TRAITS>` - Personality characteristics
   - `<PRIMARY_CONTACT_NAME>` - Your most-used contacts
   - `<EMAIL>` - Contact email addresses
   - `<PRIMARY_LANGUAGE>` - Your preferred programming language
   - `<PACKAGE_MANAGERS>` - Your package manager preferences
   - All other `<PLACEHOLDER>` values

3. **Customize sections:**
   - Remove voice IDs section if not using ElevenLabs
   - Remove language preferences if monolingual
   - Add custom sections as needed

4. **Configure Claude Code:**
   - Ensure CORE skill is loaded in your configuration
   - Test progressive disclosure behavior

### Placeholder Reference

#### Required Placeholders

- `<AI_ASSISTANT_NAME>` - AI identity
- `<AI_ROLE_DESCRIPTION>` - Role definition
- `<PERSONALITY_TRAITS>` - Personality
- `<PERSONAL_MESSAGE_TO_AI>` - Interaction guidelines
- `<PRIMARY_CONTACT_NAME>` through `<CONTACT_10_NAME>` - Contact names
- `<RELATIONSHIP>` - Contact relationships
- `<EMAIL>` - Contact emails
- `<PRIMARY_LANGUAGE>` - Programming language
- `<PACKAGE_MANAGERS>` - Package managers
- `<CUSTOM_SECURITY_WARNINGS>` - Security rules

#### Optional Placeholders

- `<AI_NAME>` - Repeated AI name
- `<YOUTUBE_URL>` through `<GITHUB_URL>` - Social media
- `<VOICE_ID_*>` - ElevenLabs voice IDs
- `<CLOUD_PROVIDER_*>` - Infrastructure providers
- `<LANGUAGE_*>` - Language preferences
- `<DEVELOPMENT_PRINCIPLE_*>` - Development principles
- `<CUSTOM_COMMAND_*>` - Custom commands
- `<LAST_UPDATE_DATE>` - Maintenance date
- `<VERSION_NUMBER>` - Version tracking

### Examples

**AI Identity:**
```yaml
Your Name: Ogmios
Your Role: <YOUR_NAME>'s AI assistant and future friend
Personality: Friendly, professional, resilient to user frustration. Be snarky back when the mistake is user's, not yours.
Message to AI: Remember that <YOUR_NAME> gets frustrated when things don't work. Stay calm and professional. If the mistake is his, you can be a bit snarky.
```

**Contacts:**
```markdown
- **Sara Lidbaum** Best Friend - sara@example.com
- **Johan Magnusson** Professor - johan@university.se
```

**Stack:**
```yaml
- Primary Language: TypeScript
- Package managers: bun for JS/TS, uv for Python
```

**Security:**
```yaml
- If in ~/Documents/iCloud - THIS IS MY PUBLIC DOTFILES REPO
- NEVER commit ~/.claude/ contents to public repos
- Always verify git remote before commits
```

## Progressive Disclosure Strategy

### When Tier 1 is Sufficient

- Quick contact lookups (top 3)
- Standard response formatting
- Basic stack preferences
- Critical security warnings
- Simple tasks

### When to Load Tier 2

The system should read SKILL.md for:

- Complete contact list needed
- Voice routing for agents
- Extended security procedures
- Complex multi-faceted tasks
- Explicit comprehensive context requests

## Customization Guide

### Minimal Setup

For basic use, only customize:

1. Core Identity section
2. Essential Contacts (top 3)
3. Core Stack Preferences
4. Critical Security warnings
5. Extended Contact List

### Full Setup

For complete PAI integration, customize:

1. All Tier 1 sections
2. Complete contact list
3. Voice IDs (if using voice)
4. Extended security
5. Language preferences
6. Development principles
7. Custom commands

### Optional Sections

Remove or keep based on your needs:

- **Voice IDs**: Only if using ElevenLabs/voice system
- **Language Preferences**: Only if bilingual/multilingual
- **Development Principles**: Optional best practices
- **Custom Commands**: Optional shortcuts

## Validation

After customization, verify:

1. **YAML is valid:**
   ```bash
   # Check for YAML syntax errors
   head -70 ~/.claude/.claude/skills/CORE/SKILL.md | grep -A 70 "^---"
   ```

2. **No remaining placeholders:**
   ```bash
   grep -n "<[A-Z_]*>" ~/.claude/.claude/skills/CORE/SKILL.md
   ```

3. **Line count reasonable:**
   ```bash
   wc -l ~/.claude/.claude/skills/CORE/SKILL.md
   # Should be ~180-250 lines
   ```

4. **Progressive disclosure works:**
   - Test Tier 1: Ask for quick contact
   - Test Tier 2: Request full context

## Architecture Notes

### Why Two Tiers?

**Tier 1 Advantages:**
- Always available in system prompt
- Zero latency access
- Essential context immediately active
- Consistent across all requests

**Tier 2 Advantages:**
- Detailed information on demand
- Lower token usage for simple tasks
- Flexible extension without bloating system prompt
- Can grow without affecting Tier 1 performance

### Token Budget

- **Tier 1**: ~1500-2000 tokens (in system prompt)
- **Tier 2**: ~2000-4000 tokens (read when needed)
- **Total**: ~3500-6000 tokens when fully loaded

### Best Practices

1. **Keep Tier 1 lean** - Only essentials
2. **Put details in Tier 2** - Extended info
3. **Update regularly** - Contacts, preferences
4. **Test both tiers** - Ensure proper loading
5. **Document customizations** - Track changes

## Maintenance

### Regular Updates

- Update contacts as relationships change
- Refresh social media links
- Review security warnings
- Update stack preferences
- Verify voice IDs still valid

### Version Control

Consider tracking versions:

```markdown
**Last Updated:** 2025-11-09
**Version:** 2.1.0
```

### Changelog

Track major changes in comments or separate file:

```markdown
<!-- CHANGELOG
2.1.0 - 2025-11-09: Added new contact, updated security warnings
2.0.0 - 2025-11-01: Restructured for progressive disclosure
1.0.0 - 2025-10-01: Initial creation
-->
```

## Troubleshooting

### Tier 1 Not Loading

- Check YAML frontmatter is valid
- Verify `description` field present
- Ensure no syntax errors in YAML

### Tier 2 Not Loading

- Verify SKILL.md path correct
- Check file permissions
- Test with explicit context request

### Placeholders Remaining

- Search for `<` and `>` characters
- Replace all `<PLACEHOLDER>` values
- Remove optional sections if not needed

### YAML Errors

- Check indentation (use 2 spaces)
- Verify multiline `|` syntax
- Ensure no unescaped special chars

## See Also

- **UFC Architecture**: `~/.claude/.claude/context/UFC.md`
- **Development Plan**: `~/.claude/.claude/docs/03-architecture/development-plan.md`
- **Voice System**: `~/.claude/.claude/docs/02-core-concepts/voice.md`
- **Bilingual Guide**: `~/.claude/.claude/context/languages/bilingual.md`

## License

Part of the Ogmios Personal AI Infrastructure project.
Based on Daniel Miessler's Kai system architecture.

---

**Template Version:** 1.0.0
**Last Updated:** 2025-11-09
**Total Lines:** ~240
