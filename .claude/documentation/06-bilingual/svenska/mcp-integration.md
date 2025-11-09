# MCP Integration

[🇬🇧 English](../../04-guides/mcp-integration.md) | [🇸🇪 Svenska](mcp-integration.md)

---

## Vad är MCP?

**MCP (Model Context Protocol)** = Standard för att koppla AI till externa tjänster och verktyg.

**Exempel MCP servers:**
- **GitHub** - Repository management, issues, PRs
- **Zotero** - Academic research library
- **Playwright** - Browser automation
- **n8n** - Workflow automation

---

## Installation

```bash
# Lägg till MCP server
claude mcp add --scope project github \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=<YOUR_TOKEN> \
  -- bunx -y @modelcontextprotocol/server-github

# Lista servrar
claude mcp list
```

---

## Konfiguration

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

**VIKTIGT:** Lägg `.mcp.json` i `.gitignore` (innehåller credentials!)

---

## Populära MCP Servers

### GitHub
Repository management, code search, issues

### Zotero
Academic research with semantic search

### Playwright
Browser automation and testing

### n8n
Workflow automation

---

**Exempel:** [MCP config](../examples/example-mcp-config.json)

---

**Tillbaka:** [Hooks](06-HOOKS-AUTOMATION.md) | **Nästa:** [Installation](08-INSTALLATION.md)
