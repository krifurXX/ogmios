# Core Concepts

Understanding these fundamental systems is key to mastering Ogmios.

## Documentation in This Section

### 1. UFC Context System
**[ufc-system.md](ufc-system.md)**

The Universal Four-layer Context (UFC) system is Ogmios' persistent memory.

**Key Topics:**
- Four-tier context loading
- File-based memory
- Progressive disclosure
- Context hydration
- Project contexts

**Why It Matters:** UFC remembers your preferences across all sessions, eliminating repetitive setup.

---

### 2. Skills System
**[skills-system.md](skills-system.md)**

Transform Claude Code into specialized AI experts with the skills system.

**Key Topics:**
- 11+ specialized personas
- Specialized AI Assistants voices
- Skill structure and components
- Proactive skill activation
- Creating custom skills

**Why It Matters:** Get expert-level responses tailored to specific domains (research, engineering, writing, etc.)

---

### 3. Voice System
**[voice-system.md](voice-system.md)**

Optional multi-voice feedback system for task completion notifications.

**Key Topics:**
- British and Swedish voices
- Voice personality mapping
- ElevenLabs integration
- Voice server setup
- Bilingual voice selection

**Why It Matters:** Hear different voices for different specialists, plus accessibility benefits.

**Note:** Voice is completely optional - Ogmios works perfectly without it.

---

### 4. Hooks & Automation
**[hooks-automation.md](hooks-automation.md)**

Event-driven automation that makes Ogmios proactive and self-managing.

**Key Topics:**
- SessionStart hooks
- UserPromptSubmit hooks
- Stop hooks
- Custom hook creation
- TypeScript implementation

**Why It Matters:** Automation eliminates manual context loading and skill activation.

---

### 5. MCP Integration
**[mcp-integration.md](mcp-integration.md)** (if exists, or link to guide)

Model Context Protocol integration for external tool access.

**Key Topics:**
- Zotero integration
- Obsidian integration
- File system access
- Custom MCP servers

---

## How These Systems Work Together

```
┌─────────────────────────────────────────┐
│         User Input                      │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  Hooks System                           │
│  - Loads UFC context                    │
│  - Activates relevant skills            │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  UFC Context                            │
│  - Project preferences                  │
│  - Technical stack                      │
│  - Past decisions                       │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  Skills System                          │
│  - Select appropriate specialist        │
│  - Load domain expertise                │
│  - Execute with persona                 │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  Voice Feedback (Optional)              │
│  - Task completion notification         │
│  - Specialist-specific voice            │
└─────────────────────────────────────────┘
```

---

## Learning Path

**Beginner:**
1. **Start Here:** [UFC System](ufc-system.md) - Understand persistent memory
2. **Then:** [Skills System](skills-system.md) - Learn about specialists
3. **Finally:** [Hooks](hooks-automation.md) - See automation in action

**Intermediate:**
1. Customize UFC contexts for your projects
2. Create custom skill personas
3. Integrate MCP servers

**Advanced:**
1. Build custom hooks
2. Design multi-agent workflows
3. Extend the enforcement system

---

## Real-World Examples

**UFC in Action:**
- Store "Always use TypeScript, never JavaScript" once → applies to all future sessions
- Define project structure → remembered across all work sessions
- Document coding standards → enforced automatically

**Skills in Action:**
- Academic research task → Dr. Emma Richards activates with Zotero access
- Code debugging → George Foster activates with engineering best practices
- Swedish dissertation → Professor Lars Bergström activates with academic Swedish

**Hooks in Action:**
- New session starts → UFC context automatically loads
- Research question detected → Research skill auto-activates
- Task completes → Voice notification announces completion

---

## Next Steps

**After Understanding Core Concepts:**
- **Deep Dive:** [System Architecture](../03-architecture/system-design.md)
- **Get Hands-On:** [Customization Guide](../04-guides/customizing-templates.md)
- **See Examples:** [Example Configurations](../../examples/)

---

## Quick Reference

| Concept | File Location | Key Benefit |
|---------|--------------|-------------|
| UFC | `~/.claude/.claude/context/` | Persistent memory |
| Skills | `~/.claude/.claude/skills/` | Specialized expertise |
| Hooks | `~/.claude/.claude/hooks/` | Automation |
| Voice | `~/.claude/voice-server/` | Multi-voice feedback |

---

[← Back to Documentation Home](../README.md)
