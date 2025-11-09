# MCP Integration

[🇬🇧 English](mcp-integration.md) | [🇸🇪 Svenska](../06-bilingual/svenska/mcp-integration.md)

---

## What is MCP?

**MCP (Model Context Protocol)** = Standard for connecting AI to external services and tools.

**Example MCP servers:**
- **GitHub** - Repository management, issues, PRs
- **Zotero** - Academic research library
- **Playwright** - Browser automation
- **n8n** - Workflow automation

---

## Installation

```bash
# Add MCP server
claude mcp add --scope project github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=<YOUR_TOKEN> \
  -- bunx -y @modelcontextprotocol/server-github

# List servers
claude mcp list
```

---

## Configuration

### Project .mcp.json

```json
{
  "mcpServers": {
    "github": {
      "type": "stdio",
      "command": "bunx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<YOUR_TOKEN>"
      }
    }
  }
}
```

**IMPORTANT:** Add `.mcp.json` to `.gitignore` (contains credentials!)

---

## Popular MCP Servers

### GitHub
Repository management, code search, issues

### Zotero
Academic research with semantic search

### Playwright
Browser automation and testing

### n8n
Workflow automation

---

**Example:** [MCP config](../examples/example-mcp-config.json)

---

**Back:** [Hooks](06-HOOKS-AUTOMATION.md) | **Next:** [Installation](08-INSTALLATION.md)
