# Architecture Documentation

Deep dive into Ogmios system design, architecture decisions, and development roadmap.

## Documentation in This Section

### 1. System Design
**[system-design.md](system-design.md)**

Complete architectural overview of the Ogmios system.

**Covers:**
- High-level architecture
- Component relationships
- Data flow diagrams
- Technology stack
- Design principles
- System boundaries

**Audience:** Developers, architects, contributors

---

### 2. Development Plan
**[development-plan.md](development-plan.md)**

Roadmap and phased development strategy.

**Covers:**
- Phase 1: UFC Foundation
- Phase 2: FOBs System (Tier 1)
- Phase 3: Personal Data Integration
- Phase 4: Intelligence Layer
- Phase 5: Meta-Learning
- Future enhancements

**Audience:** Contributors, project managers, stakeholders

---

## Key Architectural Concepts

### System Layers

```
┌─────────────────────────────────────────┐
│  User Interface Layer                   │
│  - Claude Code CLI                      │
│  - Voice feedback (optional)            │
└──────────────┬──────────────────────────┘
               │
┌─────────────────────────────────────────┐
│  Automation Layer                       │
│  - TypeScript hooks                     │
│  - Event-driven triggers                │
└──────────────┬──────────────────────────┘
               │
┌─────────────────────────────────────────┐
│  Intelligence Layer                     │
│  - Skills system                        │
│  - Specialized personas                 │
│  - Proactive activation                 │
└──────────────┬──────────────────────────┘
               │
┌─────────────────────────────────────────┐
│  Context Layer (UFC)                    │
│  - Tier 1: Core identity & system       │
│  - Tier 2: Tools & preferences          │
│  - Tier 3: Projects & memory            │
│  - Tier 4: Local overrides              │
└──────────────┬──────────────────────────┘
               │
┌─────────────────────────────────────────┐
│  Data Layer                             │
│  - MCP servers                          │
│  - File system                          │
│  - External integrations                │
└─────────────────────────────────────────┘
```

---

## Core Design Principles

### 1. System > Model
Architecture and structure matter more than AI model intelligence. Good systems amplify model capabilities.

### 2. Text as Thought
Markdown files are "one hop from pure thought" - human-readable, version-controllable, AI-native.

### 3. Progressive Disclosure
Load context in layers - start small, expand as needed. Prevents token bloat.

### 4. File-Based Everything
No databases. Context lives in markdown files. Transparent, inspectable, portable.

### 5. Unix Philosophy
- Do one thing well
- Compose small tools
- Text as universal interface
- Separation of concerns

---

## Technology Stack

**Core Runtime:**
- Claude Code (Anthropic)
- Node.js / Bun
- TypeScript (hooks, voice server)

**Context Management:**
- Markdown files
- YAML frontmatter
- JSON configuration

**Voice System (Optional):**
- ElevenLabs API
- Express.js server
- Text-to-speech streaming

**MCP Integration:**
- Zotero MCP
- Obsidian MCP
- File system MCP
- Custom MCPs

---

## Key Architectural Decisions

All major decisions are documented as ADRs (Architecture Decision Records):

**ADR-001**: [UFC System](../../templates/context/memory/decisions/active/001-ufc-system.md)
**ADR-003**: [Skills Over Commands](../../templates/context/memory/decisions/active/003-skills-over-commands.md)
**ADR-007**: [Security-First Approach](../../templates/context/memory/decisions/active/007-security-first-approach.md)
**ADR-008**: [Project Local Claude Minimal](../../templates/context/memory/decisions/active/008-project-local-claude-must-be-minimal.md)
**ADR-011**: [Progressive Disclosure with Tier 1 Metadata](../../templates/context/memory/decisions/active/011-progressive-disclosure-with-tier-1-metadata.md)
**ADR-012**: [Proactive Skill Activation](../../templates/context/memory/decisions/active/012-proactive-skill-activation-dimension-4.md)
**ADR-020**: [Enforcement Architecture](../../templates/context/memory/decisions/active/020-enforcement-architecture.md)
**ADR-021**: [Memory Refactoring System](../../templates/context/memory/decisions/active/021-memory-refactoring-system.md)
**ADR-022**: [Progressive Disclosure Skills](../../templates/context/memory/decisions/active/022-progressive-disclosure-skills.md)

[See all ADRs →](../../templates/context/memory/decisions/)

---

## Data Flow

### Session Start
```
User launches Claude Code
    ↓
SessionStart hook triggers
    ↓
Load UFC Tier 1 (Core identity)
    ↓
Load UFC Tier 2 (Tools, preferences)
    ↓
Load UFC Tier 3 (Projects, memory)
    ↓
Check for UFC Tier 4 (Local overrides)
    ↓
Context hydration complete
```

### User Interaction
```
User submits prompt
    ↓
UserPromptSubmit hook triggers
    ↓
Analyze intent
    ↓
Check skill activation rules
    ↓
Activate relevant skill(s)
    ↓
Process with full context
    ↓
Generate response
    ↓
Stop hook triggers
    ↓
Voice notification (if enabled)
```

---

## Scalability Considerations

**Token Budget Management:**
- Progressive disclosure prevents token bloat
- Tier 1 metadata enables smart loading
- Skills load only when needed

**Performance:**
- File-based context is fast to read
- No database overhead
- MCP connections cached

**Extensibility:**
- New skills: Add to `~/.claude/.claude/skills/`
- New hooks: Add to `~/.claude/.claude/hooks/`
- New MCPs: Configure in `settings.json`

---

## Security Architecture

**Principle: Security by Design**

**Context Isolation:**
- Project contexts separated
- No cross-contamination
- Explicit sharing only

**Secret Management:**
- API keys in `.env` (never committed)
- Credential scanning
- Security audit enforcement

**Input Validation:**
- Hook execution sandboxed
- MCP request validation
- Path traversal prevention

[See Security Details →](../07-advanced/compliance-enforcement.md)

---

## Future Architecture

**Phase 4: Intelligence Layer**
- Multi-agent orchestration
- Collaborative workflows
- Skill composition

**Phase 5: Meta-Learning**
- Pattern recognition
- Automated ADR creation
- Self-optimization

[See Development Plan →](development-plan.md)

---

## For Developers

**Contributing to Architecture:**
1. Read [System Design](system-design.md)
2. Review [ADRs](../../templates/context/memory/decisions/)
3. Understand [Development Plan](development-plan.md)
4. Follow [Contribution Guidelines](../../CONTRIBUTING.md)

**Creating New Components:**
- Skills: See [Skills Template](../../templates/skills/)
- Hooks: See [Hooks Reference](../../templates/hooks/)
- MCPs: See [MCP Integration Guide](../04-guides/mcp-integration.md)

---

## Quick Links

- **[System Design](system-design.md)** - Full architecture
- **[Development Plan](development-plan.md)** - Roadmap
- **[ADRs](../../templates/context/memory/decisions/)** - All decisions
- **[Core Concepts](../02-core-concepts/)** - System fundamentals

---

[← Back to Documentation Home](../README.md)
