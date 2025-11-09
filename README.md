# Ogmios - Personal AI Infrastructure

Transform Claude Code into a specialized AI system with persistent context and automation.

## Features

- **Specialized Skills**: 20+ domain experts (engineering, research, security, etc.)
- **UFC Context**: File-based persistent memory
- **Automation**: Event-driven hooks
- **Voice System**: Multi-voice feedback (optional)
- **Bilingual**: English and Swedish support

## Quick Start

### Prerequisites

- [Claude Code](https://docs.anthropic.com/claude/docs/claude-code) installed
- [Bun](https://bun.sh) for TypeScript hooks
- macOS or Linux

### Installation

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/ogmios.git
cd ogmios

# Install to home directory
cp -r .claude/ ~/.claude/

# Install dependencies
cd ~/.claude/.claude/hooks
bun install

# Customize configuration
cd ~/.claude/.claude
nano PAI.md  # Replace <PLACEHOLDERS>

# Start Claude Code
claude
```

## How It Works

### UFC Context System

Persistent memory via markdown files:

```
~/.claude/.claude/context/
├── projects/     # Project contexts
├── tools/        # Available MCPs
├── preferences/  # Tech stack, style
└── memory/       # Decisions, learnings
```

### Skills System

Specialized AI personas with domain expertise:

- **Engineering** - Code implementation, debugging, optimization
- **Architecture** - System design, technical planning
- **Research** - Academic research, literature reviews
- **Security** - Security audits, vulnerability assessment
- **Swedish Academic** - Swedish academic writing

### Hooks & Automation

Event-driven automation:

- **SessionStart** - Load core context
- **UserPromptSubmit** - Auto-activate skills
- **Stop** - Voice notifications, metrics

### Voice System (Optional)

Multi-voice feedback via ElevenLabs:

```bash
cd ~/.claude/.claude/voice-server
cp .env.example .env
# Add: ELEVENLABS_API_KEY=your_key
bun run index.ts
```

## Documentation

See `.claude/documentation/` for:
- [Quick Start Guide](.claude/documentation/01-getting-started/quick-start.md)
- [Installation Details](.claude/documentation/01-getting-started/installation.md)
- [System Architecture](.claude/documentation/03-architecture/overview.md)
- [Troubleshooting](.claude/documentation/08-faq/troubleshooting.md)

## Philosophy

Built on [Daniel Miessler's Kai system](https://github.com/danielmiessler/Personal_AI_Infrastructure) principles:

1. **System > Model** - Architecture matters more than AI
2. **Text as Thought** - Markdown for knowledge storage
3. **Build Once** - Reusable solutions
4. **Context is King** - Right info at right time

## Security

- Local-first design (data stays on your machine)
- Encrypted storage recommended for sensitive data
- No API keys in repository
- See [SECURITY.md](SECURITY.md) for vulnerability reporting

## Credits

**Inspired by**: [Daniel Miessler's Kai](https://github.com/danielmiessler/Personal_AI_Infrastructure)

**Thanks to**:
- Daniel Miessler for Kai architecture
- Anthropic for Claude and Claude Code
- MCP community for protocol development

## License

MIT - see [LICENSE](LICENSE) file
