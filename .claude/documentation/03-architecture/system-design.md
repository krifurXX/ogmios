# Ogmios Architecture - Complete System Design

**Version**: 1.0.0
**Last Updated**: 2025-11-09
**Status**: Production

---

## Executive Summary

Ogmios is a **Personal AI Infrastructure (PAI)** that transforms Claude Code from a simple chatbot into a sophisticated AI assistant with persistent context, specialized skills, multi-voice feedback, and event-driven automation.

**Key Architectural Principles:**
1. **System > Model**: Great architecture beats great AI
2. **Text as Thought**: Markdown files are one hop from pure thought
3. **Build Once**: Never solve the same problem twice
4. **Context is King**: Right context at right time
5. **Unix Philosophy**: Small, composable, do one thing well

**This document** explains how all Ogmios components fit together to create a unified, intelligent system.

---

## Table of Contents

1. [System Overview](#system-overview)
2. [The Four Foundational Primitives](#the-four-foundational-primitives)
3. [UFC - Universal File-based Context](#ufc---universal-file-based-context)
4. [Skills System](#skills-system)
5. [Hooks and Automation](#hooks-and-automation)
6. [Voice System](#voice-system)
7. [Bilingual Operation](#bilingual-operation)
8. [Integration Patterns](#integration-patterns)
9. [Performance and Scalability](#performance-and-scalability)
10. [Deployment Architecture](#deployment-architecture)

---

## System Overview

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER INTERACTION                         │
└──────────────────┬──────────────────────────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────────────────────────┐
│                         CLAUDE CODE CLI                          │
└──────────────────┬──────────────────────────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────────────────────────┐
│                    OGMIOS PAI LAYER                              │
│  ┌────────────────┬────────────────┬────────────────────────┐  │
│  │ UFC Context    │ Skills System  │ Hooks & Automation     │  │
│  │ - Projects     │ - British Team │ - SessionStart         │  │
│  │ - Preferences  │ - Workflows    │ - UserPromptSubmit     │  │
│  │ - Memory       │ - Resources    │ - Stop                 │  │
│  │ - Tools        │                │ - Tool logging         │  │
│  └────────────────┴────────────────┴────────────────────────┘  │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │             Voice System (Optional)                         │ │
│  │  - Multi-voice feedback via ElevenLabs                     │ │
│  │  - Specialized AI Assistants specialists                             │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────────────────────────┐
│              EXTERNAL SERVICES & INTEGRATIONS                    │
│  - ElevenLabs (TTS)     - MCP Servers (GitHub, Zotero, n8n)   │
│  - Perplexity (Research) - File System (Context storage)       │
└─────────────────────────────────────────────────────────────────┘
```

### Core Components

**1. UFC (Universal File-based Context)**
- Nested directory structure for context organization
- Progressive disclosure (Tier 1: metadata, Tier 2: content, Tier 3: deep dive)
- Persistent memory across sessions
- Project-specific, preference-based, and tool-based contexts

**2. Skills System**
- Modular capabilities (Specialized AI Assistants)
- Auto-activation based on task detection
- Specialized workflows and knowledge
- Progressive loading to minimize token usage

**3. Hooks and Automation**
- Event-driven system (SessionStart, UserPromptSubmit, Stop)
- Automatic context loading
- Skill routing enforcement
- Voice trigger coordination
- Tool usage logging

**4. Voice System (Optional)**
- Multi-voice TTS via ElevenLabs
- 10 unique voices (Specialized AI Assistants)
- Skill-based voice selection
- Bilingual support (English/Swedish)

---

## The Four Foundational Primitives

Ogmios is built on four core primitives that work together to provide sophisticated AI capabilities.

### 1. Skills: Domain Expertise Containers

**What They Are:**
- Self-contained packages of specialized knowledge
- Include workflows, templates, and resources
- Auto-activate based on semantic triggers
- Progressive disclosure (metadata → instructions → resources)

**Structure:**
```
~/.claude/.claude/skills/<skill-name>/
├── SKILL.md                    # Core skill definition (Tier 2)
├── workflows/                  # Specific task workflows
│   ├── workflow-1.md
│   └── workflow-2.md
├── assets/                     # Templates and resources (Tier 3)
│   ├── templates/
│   └── references/
└── scripts/                    # Executable helpers
```

**Example: Engineering Skill**
```yaml
---
name: engineering
description: Code implementation, debugging, optimization.
  USE WHEN user says 'build', 'implement', 'fix bug', 'debug', 'optimize'
voice_id: JBFqnCBsd6RMkjVDRZzb  # George Foster
specialist: George Foster - Senior Engineer
tier: 1
---
```

**When to Use:**
- Need competence in a domain area
- Multiple related tasks in same domain
- Reusable workflows across conversations
- Package expertise for specific topic

### 2. Workflows: Discrete Task Implementations

**What They Are:**
- Specific task implementations within a skill
- Live in `workflows/` subdirectory
- Auto-selected by natural language OR invoked directly
- Like "exported functions" from a skill module

**Structure:**
```markdown
# workflows/implement-feature.md

## Trigger
User says: "build X", "implement Y", "create Z"

## Workflow
1. Analyze requirements
2. Design architecture
3. Implement with TDD
4. Write tests
5. Validate and deliver

## Tools Used
- Bash (code execution)
- Edit/Write (file operations)
- Test runners
```

**Relationship to Skills:**
- Skills provide STRATEGY (how to approach domain)
- Workflows provide TACTICS (specific task steps)
- Skills contain multiple workflows
- Workflows reference skill resources

### 3. Agents: Orchestration Workers (Future)

**What They Are:**
- Specialized AI workers for specific tasks
- Enable parallel execution
- Primarily invoke Skills/Workflows
- Best for background processing

**Pattern:**
```
User Task → Skill Selection → Workflow Choice → Agent Execution (if parallel)
```

**Example Use Case:**
```
Update 10 config files →
  Launch 10 agents in parallel →
    Each agent:
      1. Reads reference file
      2. Updates target file
      3. Follows standards (from skill context)
  Spotcheck agent verifies all 10
```

**Note:** Agents are planned for Phase 2 but not yet implemented in public release.

### 4. MCPs (Model Context Protocol): Platform Services

**What They Are:**
- Standardized interfaces to external services
- Maintained separately from skills
- Reusable across AI systems
- Platform-level abstraction

**When to Use MCPs vs Direct API Code:**

| Use MCPs When... | Use Direct API Code When... |
|-----------------|----------------------------|
| Sharing across teams/orgs | Building personal infrastructure |
| Need standardization | Own the full stack |
| Multiple AI systems | Single AI system |
| Platform-level service | Domain-specific integration |
| Community maintains it | You maintain it |

**Ogmios Approach:**
- Use community MCPs for platform services (GitHub, Zotero, n8n)
- Use direct API code within skills for domain-specific needs
- Provides flexibility and control

---

## UFC - Universal File-based Context

### Philosophy

> **The file system IS the context system.**

UFC organizes knowledge into logical, hierarchical, markdown-based files that load exactly when needed.

### Core Concepts

**1. Text as Thought Primitives**
- Markdown files are one hop from pure thought
- Clean, scannable, human-readable
- Version-controllable knowledge

**2. Build Once, Use Everywhere**
- Define preferences once
- Load context across all projects
- Never re-explain yourself

**3. Progressive Disclosure**
- Tier 1: Metadata (~100 tokens, always loaded)
- Tier 2: Content (~2000 tokens, loaded when triggered)
- Tier 3: Resources (~500-5000 tokens, loaded as needed)

### Directory Structure

```
~/.claude/.claude/context/
├── UFC.md                      # System architecture overview
├── tools/
│   ├── tools.md                # All available tools
│   ├── mcps.md                 # MCP server configurations
│   ├── commands.md             # Slash commands
│   └── fobs.md                 # Fabric-style tools
├── projects/
│   ├── <project-name>.md       # Per-project context
│   └── <another-project>.md
├── preferences/
│   ├── stack.md                # Technology preferences
│   ├── coding-style.md         # Code style guide
│   └── languages.md            # Language handling
├── memory/
│   ├── learnings.md            # Current month insights (~500 lines)
│   ├── learnings-archive/      # Historical insights
│   │   ├── INDEX.md            # Searchable index
│   │   └── YYYY-MM.md          # Archived months
│   ├── decisions/
│   │   ├── INDEX.md            # All ADRs metadata (<5KB)
│   │   ├── active/             # Active architectural decisions
│   │   ├── superseded/         # Superseded decisions
│   │   └── deprecated/         # Deprecated decisions
│   ├── analysis/
│   │   ├── INDEX.md            # Analysis metadata
│   │   ├── <topic>.md          # Topic analyses
│   │   └── incidents/          # Incident post-mortems
│   └── contacts.md             # Professional network
└── languages/
    ├── swedish.md              # Swedish-specific context
    ├── english.md              # English-specific context
    └── bilingual.md            # Language switching rules
```

### Nesting Guidelines

**Maximum 3 levels deep:**

✅ Good: `context/tools/mcps.md`
✅ Good: `context/projects/<project>/collaborators.md`
⚠️ Careful: `context/projects/<project>/team/collaborators.md` (3 levels - max)
❌ Avoid: `context/projects/<project>/team/leads/collaborators.md` (4 levels - too deep)

**Why?** Context hydration becomes unreliable beyond 3 levels.

### 4-Layer Context Enforcement

To ensure Claude **always** has the right context:

**Layer 1: UFC.md**
- Describes overall system architecture
- Loaded via hooks
- Reminds Claude how system works

**Layer 2: UserPromptSubmit Hook**
- Runs on EVERY user prompt
- Loads UFC.md, PAI.md
- Hydrates relevant context based on task

**Layer 3: Aggressive CLAUDE.md**
- Project-level enforcement file
- Psychological barriers to skipping context
- Observable verification required
- Moral framing (skipping = lying)

**Layer 4: Symlinks (Safety Net)**
- `.claude/CLAUDE.md` → `../CLAUDE.md`
- Catches Claude if lost in `.claude/` directory

### Context Loading Flow

**On Session Start:**
```
SessionStart hook →
  Load PAI.md (identity) →
  Load UFC.md (system architecture) →
  Claude knows who he is and how system works
```

**On User Prompt:**
```
UserPromptSubmit hook →
  Detect: Project, language, intent →
  Load: Relevant UFC context →
  Claude has exactly what's needed
```

**Example:**
```
User: "Let's work on my e-commerce project"
  ↓
Hook detects "e-commerce project"
  ↓
Loads: context/projects/ecommerce.md
  ↓
Loads: context/preferences/stack.md (if needed)
  ↓
Claude: "Ready! I see we're using React + FastAPI + PostgreSQL."
```

---

## Skills System

### Architecture

Skills are the organizing principle for AI capabilities. They package domain expertise, workflows, and procedural knowledge into self-contained modules.

### Three-Layer Architecture

**Layer 1: Metadata (Always Loaded)**
```yaml
---
name: skill-name
description: Clear description with activation triggers.
  USE WHEN user says 'trigger1', 'trigger2', 'trigger3'
voice_id: <ELEVENLABS_VOICE_ID>
specialist: <Specialist Name and Title>
tier: 1  # 1 = always load, 2 = load on demand, 3 = rarely used
---
```

- Appears in `<available_skills>` in system prompt
- Used for intent matching
- ~100 tokens per skill

**Layer 2: SKILL.md Body (Loaded When Activated)**
```markdown
## When to Activate This Skill
- Trigger condition 1
- Trigger condition 2

## Core Workflow
[Main instructions]

## Supplementary Resources
For full context: `read ~/.claude/.claude/skills/<name>/workflows/<workflow>.md`
```

- Loads when skill activates
- ~2000 tokens
- Includes main workflows

**Layer 3: Supporting Resources (Loaded As Needed)**
- workflows/*.md (specific task implementations)
- assets/ (templates, references)
- scripts/ (executable helpers)
- ~500-5000 tokens per resource

### Intent Matching & Activation

**How it Works:**
```
User: "Build a REST API"
  ↓
System checks available_skills
  ↓
Matches: "engineering" skill description contains:
  "USE WHEN user says 'build', 'implement', 'create'..."
  ↓
Activates engineering skill
  ↓
Loads SKILL.md instructions
  ↓
George Foster (engineer) personality activated
```

### Skill Categories

**Development & Engineering:**
- **engineering**: Code implementation, debugging (George Foster)
- **architecture**: System design, ADRs (Callum)
- **devops**: Deployment, CI/CD (Chris)

**Research & Analysis:**
- **research**: Multi-source research (Alice Mitchell)
- **data-analysis**: Metrics, statistics (Matilda)
- **academic-research**: Literature review (Prof. Lars Bergström)

**Content & Communication:**
- **knowledge-management**: Content creation (Marcus Thompson)
- **technical-writing**: Documentation (Lily)
- **swedish-content**: Swedish writing (Max Andersson)
- **swedish-academic-writing**: Swedish academic (Prof. Lars Bergström)

**Design & UX:**
- **design**: UI/UX design (Jessica)

**Security:**
- **security**: Security audits, pentesting (Daniel Davies)

### Specialized AI Assistants

Ogmios includes a **10-member specialist team** with unique voices:

| Specialist | Role | Voice Accent | Skills |
|-----------|------|--------------|--------|
| Ogmios (Team Lead) | Main assistant | British | Default responses |
| George Foster | Senior Engineer | British | engineering |
| Alice Mitchell | Research Analyst | British | research, academic-research |
| Daniel Davies | Security Officer | British | security |
| Callum | Technical Architect | Neutral | architecture |
| Lily | Technical Writer | Neutral | technical-writing |
| Jessica | UX/UI Designer | American | design |
| Matilda | Data Analyst | American | data-analysis |
| Chris | DevOps Engineer | American | devops |
| Max Andersson | Swedish Specialist | Swedish | swedish-content |
| Prof. Lars Bergström | Academic | Swedish | swedish-academic-writing |

**Gender Balance:** 5 male, 5 female
**Accent Diversity:** 4 British, 1 Swedish, 3 American, 2 Neutral

---

## Hooks and Automation

### Event-Driven Architecture

Hooks make Ogmios **proactive** rather than reactive. They run automatically on specific events.

### Hook Types

**1. SessionStart Hook**
- **When**: Claude Code session starts
- **What**: Loads core identity (PAI.md) and system architecture (UFC.md)
- **File**: `session-start-load-pai.ts`
- **Impact**: Ensures Claude always knows who he is

**2. UserPromptSubmit Hook**
- **When**: User submits a prompt
- **What**:
  - Loads relevant UFC context
  - Routes to appropriate skill
  - Enforces skill usage (ADR-020)
- **Files**:
  - `load-core-context.ts` (context loading)
  - `user-prompt-skill-routing.ts` (skill enforcement)
- **Impact**: Right context at right time, skill activation guaranteed

**3. Stop Hook**
- **When**: Conversation ends (user stops generation)
- **What**:
  - Validates response format
  - Triggers voice feedback
  - Logs completion
- **File**: `stop-hook.ts`
- **Impact**: Multi-voice feedback, quality assurance

**4. Tool Hooks**
- **When**: Claude uses any tool (Bash, Edit, Read, etc.)
- **What**: Logs tool usage for analytics
- **Files**: Various tool-specific hooks
- **Impact**: Observability, debugging, analytics

### Hook Execution Flow

```
User submits prompt
  ↓
UserPromptSubmit hooks run (in order):
  1. user-prompt-skill-routing.ts
     - Reads SKILLS-INDEX.md
     - Matches user intent to skills
     - Injects enforcement prompt if match
  2. load-core-context.ts
     - Loads UFC.md
     - Loads PAI.md
     - Loads project-specific context
  ↓
Claude processes with full context
  ↓
User stops generation
  ↓
Stop hook runs:
  - Validates COMPLETED line
  - Extracts skill name from [SKILL:name] tag
  - Sends to voice server with correct voice_id
  ↓
Voice feedback plays (if voice system enabled)
```

### Skill Routing Enforcement (ADR-020)

**Problem:** Claude sometimes uses tools directly instead of activating skills

**Solution:** Three-layer enforcement architecture

**Layer 1: SKILLS-INDEX.md**
- Single source of truth for all skills
- Tier metadata, trigger phrases, descriptions
- ~20KB, easily parseable

**Layer 2: UserPromptSubmit Hook (Preventive)**
- Reads SKILLS-INDEX.md on every prompt
- Matches user intent to skill triggers
- Injects enforcement prompt BEFORE processing
- **Result:** Skill activation becomes automatic

**Layer 3: Stop Validator (Detective)**
- Validates response after completion
- Checks for [SKILL:name] tag in COMPLETED line
- Logs violations to skill-violations.jsonl
- **Result:** Catch and learn from bypass attempts

---

## Voice System

### Architecture

The voice system provides **multi-voice audio feedback** using ElevenLabs TTS. Each skill specialist has a unique voice.

### Components

**1. Voice Server (`voice-server/`)**
- Bun/TypeScript HTTP server (port 8888)
- Receives: {message, voice_id}
- Calls: ElevenLabs API
- Plays: Audio via macOS `afplay`

**2. Stop Hook (`stop-hook.ts`)**
- Extracts skill name from [SKILL:name] tag
- Reads SKILL.md to get voice_id
- Sends to voice server
- Fallback to Ogmios voice if no skill

**3. Skill Configuration**
- Each SKILL.md includes voice_id in YAML frontmatter
- Maps skill → specialist → voice

### Voice Selection Logic

```
User completes conversation
  ↓
Stop hook triggers
  ↓
Read transcript, find COMPLETED line
  ↓
Extract [SKILL:name] tag
  ↓
Load ~/.claude/.claude/skills/<name>/SKILL.md
  ↓
Read voice_id from frontmatter
  ↓
Send to voice server: POST /notify {message, voice_id}
  ↓
ElevenLabs TTS generates audio
  ↓
afplay plays audio
  ↓
User hears specialist's voice
```

### Language Detection for Ogmios Voice

For default Ogmios responses (no skill), language is detected:

```typescript
function getOgmiosVoice(text: string): string {
  return isSwedish(text)
    ? MAX_VOICE_ID      // Max Andersson (Swedish)
    : OGMIOS_VOICE_ID   // Ogmios (English)
}
```

### Testing Voice System

```bash
# Start voice server
cd ~/.claude/.claude/voice-server
bun server.ts &

# Test health
curl http://localhost:8888/health

# Test voice
curl -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello from Ogmios", "voice_id": "goT3UYdM9bhm0n2lmKQx"}'
```

---

## Bilingual Operation

Ogmios supports **Swedish and English** as equal first-class languages.

### Language Detection

**Input Language Matching:**
- Hook detects language of user input
- Response generated in same language
- Transparent switching

**Example:**
```
User: "Bygg en REST API"  (Swedish)
  ↓
Language detected: Swedish
  ↓
Response: "Jag bygger en REST API..."  (Swedish)
Voice: Max Andersson (Swedish)

User: "Build a REST API"  (English)
  ↓
Language detected: English
  ↓
Response: "Building a REST API..."  (English)
Voice: George Foster (British)
```

### Swedish-Specific Skills

**swedish-content (Max Andersson):**
- Swedish content creation
- Swedish translation
- Swedish cultural context

**swedish-academic-writing (Prof. Lars Bergström):**
- Swedish academic writing
- Swedish research papers
- Swedish academic conventions

### Bilingual Context Files

**context/languages/:**
- `swedish.md` - Swedish-specific instructions
- `english.md` - English-specific instructions
- `bilingual.md` - Language switching rules

### Voice Matching

**For Skills:**
- Skill voice remains constant regardless of language
- George Foster speaks English (engineering)
- Max Andersson speaks Swedish (swedish-content)
- Prof. Lars speaks Swedish (swedish-academic-writing)

**For Ogmios:**
- English input → Ogmios voice (English British)
- Swedish input → Max voice (Swedish)

---

## Integration Patterns

### Pattern 1: UFC + Skills + Hooks

**Complete workflow:**
```
Session starts →
  SessionStart hook loads PAI.md + UFC.md →

User: "Build payment integration for e-commerce"
  ↓
UserPromptSubmit hook:
  - Matches "build" → engineering skill
  - Loads context/projects/ecommerce.md
  - Injects enforcement prompt
  ↓
Engineering skill activates (George Foster)
  ↓
Skill loads: workflows/implement-feature.md
  ↓
Implementation with TDD methodology
  ↓
User stops
  ↓
Stop hook:
  - Extracts [SKILL:engineering]
  - Sends to voice server
  - George Foster voice plays
```

### Pattern 2: Progressive Disclosure

**Minimize token usage:**
```
All skills metadata loaded (Tier 1)
  ~2000 tokens for 20 skills
  ↓
Match detected → Load SKILL.md (Tier 2)
  ~2000 tokens for skill instructions
  ↓
Workflow needed → Load workflow.md (Tier 3)
  ~500-1000 tokens for specific workflow
  ↓
Total: ~4500 tokens (vs loading all content: ~40,000 tokens)
```

### Pattern 3: Multi-Layer Enforcement

**Ensure context always loaded:**
```
Layer 1: UFC.md
  "System architecture documentation"
  ↓
Layer 2: UserPromptSubmit hook
  "Automatic context loading"
  ↓
Layer 3: Aggressive CLAUDE.md
  "🚨 MANDATORY: Read these files FIRST"
  ↓
Layer 4: Symlink safety net
  ".claude/CLAUDE.md → ../CLAUDE.md"
```

**Result:** Near-impossible to bypass context loading

---

## Performance and Scalability

### Token Optimization

**Without UFC:**
- Load entire codebase + all preferences: ~50,000+ tokens
- Constant context window pressure
- Frequent truncation

**With UFC:**
- Tier 1 (always loaded): ~5,000 tokens (PAI + UFC + skills metadata)
- Tier 2 (on-demand): ~2,000-5,000 tokens (project context + skill content)
- Tier 3 (as needed): ~500-5,000 tokens (specific resources)
- **Total typical**: ~10,000-15,000 tokens (70% reduction)

### Hook Performance

**Measured overhead:**
- SessionStart: ~50ms (one-time per session)
- UserPromptSubmit: ~50-200ms per prompt
  - Skill routing: ~30ms (read + parse SKILLS-INDEX.md)
  - Context loading: ~20-170ms (depends on files)
- Stop: ~100-300ms (includes voice server request)

**Impact:** Negligible - hooks run in parallel with Claude's processing

### Memory System Scalability

**ADR-021 Refactoring:**
- **Before**: Single learnings.md file (growing indefinitely)
- **After**: Monthly archiving to learnings-archive/
- **Current month**: ~500 lines, <20KB
- **Archives**: One file per month, indexed
- **Scaling**: Can grow indefinitely without performance impact

**Decisions:**
- INDEX.md: All ADRs metadata (~5KB)
- Individual ADRs: ~2-5KB each
- Progressive loading: Read INDEX first, then specific ADR if needed

---

## Deployment Architecture

### File System Layout

```
~/.claude/                          # Claude Code directory
└── .claude/                        # Ogmios PAI directory
    ├── PAI.md                      # Core identity
    ├── SKILLS-INDEX.md             # Skill routing source of truth
    ├── context/                    # UFC context system
    │   ├── UFC.md
    │   ├── projects/
    │   ├── preferences/
    │   ├── memory/
    │   ├── tools/
    │   └── languages/
    ├── skills/                     # Skills library
    │   ├── engineering/
    │   ├── research/
    │   ├── architecture/
    │   └── [20 total skills]
    ├── hooks/                      # Event-driven automation
    │   ├── session-start-load-pai.ts
    │   ├── load-core-context.ts
    │   ├── user-prompt-skill-routing.ts
    │   ├── stop-hook.ts
    │   └── [12 total hooks]
    ├── voice-server/               # Voice feedback system
    │   ├── server.ts
    │   ├── package.json
    │   └── node_modules/
    ├── settings.json               # Claude Code configuration
    └── .env                        # API keys (gitignored)
```

### Installation Process

**7-Step Setup:**
```bash
# 1. Prerequisites
# - Claude Code installed
# - Bun installed
# - Git installed

# 2. Clone repository
git clone https://github.com/<username>/ogmios-pai.git
cd ogmios-pai

# 3. Copy templates to Claude directory
cp -r templates/* ~/.claude/.claude/

# 4. Customize PAI identity
nano ~/.claude/.claude/PAI.md  # Replace <PLACEHOLDERS>

# 5. Install hook dependencies
cd ~/.claude/.claude/hooks
bun install

# 6. (Optional) Setup voice system
cd ~/.claude/.claude/voice-server
bun install
# Add ELEVENLABS_API_KEY to ~/.env

# 7. Verify installation
cd /path/to/ogmios-pai
./verify-installation.sh
```

### Environment Variables

**Required:**
```bash
PAI_DIR="$HOME/.claude/.claude"    # Ogmios installation directory
```

**Optional (for voice system):**
```bash
ELEVENLABS_API_KEY="<your-key>"    # ElevenLabs TTS API key
```

### Configuration Files

**settings.json:**
- Hook registration
- Tool permissions
- MCP server configurations

**PAI.md:**
- Core identity and preferences
- Customized per user
- Loaded on SessionStart

**SKILLS-INDEX.md:**
- Single source of truth for skills
- Used by routing enforcement
- Auto-generated from skills/ directory

---

## Best Practices

### UFC Context Organization

✅ **Do:**
- Keep files focused and atomic
- Use clear, descriptive file names
- Link between related contexts
- Update promptly when learning
- Maximum 3 levels deep

❌ **Don't:**
- Duplicate information across files
- Create deeply nested structures (4+ levels)
- Mix concerns in single file
- Let contexts go stale

### Skill Design

✅ **Do:**
- One skill per domain area
- Clear trigger phrases in description
- Progressive disclosure (metadata → content → resources)
- Include voice_id for specialist
- Document tier (1/2/3)

❌ **Don't:**
- Create skills for one-off tasks
- Duplicate knowledge across skills
- Skip voice_id configuration
- Forget tier classification

### Hook Development

✅ **Do:**
- Keep hooks focused (single responsibility)
- Log to stderr for debugging
- Handle errors gracefully
- Test thoroughly before deployment
- Document hook purpose and behavior

❌ **Don't:**
- Create blocking operations
- Ignore error cases
- Log sensitive data
- Skip error handling

### Performance Optimization

✅ **Do:**
- Use progressive disclosure
- Cache frequently-used contexts
- Minimize token usage
- Lazy-load resources
- Monitor hook overhead

❌ **Don't:**
- Load all context upfront
- Duplicate context unnecessarily
- Skip tier classification
- Ignore performance metrics

---

## Security Considerations

### API Key Management

**Never commit:**
- `.env` files with API keys
- Personal data in context files
- Credentials in any form

**Always:**
- Use `.gitignore` for sensitive files
- Store keys in `.env`
- Document placeholder format in templates

### Context Privacy

**Sanitization for public sharing:**
- Replace personal names with `<NAME>`
- Replace project names with `<PROJECT_NAME>`
- Replace company names with `<COMPANY>`
- Use generic examples

**Personal installation:**
- Full personalization allowed
- Real names and projects
- Actual collaborator information
- Private contexts stay private

---

## Troubleshooting

### Common Issues

**Context Not Loading:**
1. Check PAI_DIR environment variable
2. Verify UFC.md exists
3. Check hook registration in settings.json
4. Review hook logs (stderr output)

**Skill Not Activating:**
1. Check SKILLS-INDEX.md includes skill
2. Verify trigger phrases in description
3. Check skill tier (Tier 1 most reliable)
4. Review enforcement hook logs

**Voice Not Playing:**
1. Check voice server running (port 8888)
2. Verify ELEVENLABS_API_KEY set
3. Check voice_id in SKILL.md
4. Test voice server directly (curl)
5. Verify afplay works on system

**Wrong Voice Selected:**
1. Check [SKILL:name] tag in COMPLETED line
2. Verify voice_id in SKILL.md frontmatter
3. Check voice-mappings.ts fallbacks
4. Review stop-hook.ts logic

---

## Future Enhancements

### Planned Features

**Phase 2: Extensions**
- Agent orchestration (parallel task execution)
- Visual workflow builder
- Community skills marketplace
- Mobile companion app
- Additional MCP integrations

**Phase 3: Intelligence**
- Behavioral pattern learning
- Predictive context loading
- Proactive suggestions
- True Digital Assistant capabilities
- Automatic skill creation from usage patterns

### Research Directions

- Hybrid local/cloud LLM deployment
- Custom fine-tuning for specialized skills
- Advanced voice synthesis (emotion, accent control)
- Multi-modal inputs (images, audio)
- Real-time collaboration features

---

## Conclusion

Ogmios transforms Claude Code from a simple chatbot into a sophisticated Personal AI Infrastructure through:

1. **UFC**: Persistent, organized, progressive context
2. **Skills**: Specialized Specialized AI Assistants with domain expertise
3. **Hooks**: Event-driven automation and enforcement
4. **Voice**: Multi-voice feedback for enhanced experience
5. **Bilingual**: Swedish and English as equal citizens

**The result:** Claude Code operating at 100% capacity instead of 30%.

**Philosophy:** System > Model. Great architecture beats great AI.

**Built on the shoulders of:** Daniel Miessler's Kai system and the Personal AI Infrastructure movement.

---

## References

- **Ogmios Repository**: https://github.com/<username>/ogmios-pai
- **Daniel Miessler's Kai**: https://github.com/danielmiessler/kai
- **Claude Code**: https://docs.anthropic.com/claude/docs/claude-code
- **Anthropic Skills Documentation**: https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview
- **ElevenLabs**: https://elevenlabs.io

---

**Document Version:** 1.0.0
**Last Updated:** 2025-11-09
**License:** MIT

**Questions?** See [troubleshooting guide](../docs/01-getting-started/troubleshooting.md) or [FAQ](../docs/08-faq/faq.md)
