# Tools Context

**Purpose:** Store your preferences and configurations for development tools.

---

## 📁 What Goes Here

Create a separate `.md` file for each tool you frequently use:

### Examples:
- `git.md` - Git preferences, aliases, workflow
- `docker.md` - Docker configurations, compose templates
- `kubernetes.md` - K8s preferences, common commands
- `npm.md` / `bun.md` - Package manager preferences
- `vim.md` / `vscode.md` - Editor configurations

---

## 📝 Template Structure

```markdown
# Tool: <TOOL_NAME>

**Version:** <VERSION YOU USE>
**Purpose:** <WHAT YOU USE IT FOR>

## ⚙️ Configuration

<Your preferred settings>

## 🔧 Common Commands

<Commands you use frequently>

## 📚 Aliases/Shortcuts

<Your custom aliases>

## 🎯 Workflow

<How you typically use this tool>

## 📖 Resources

<Useful links, documentation>
```

---

## 🎯 Why This Helps

When you ask Claude about a tool (e.g., "Help me with git"), the UFC system can automatically load your preferences so Claude knows:
- Your preferred workflow
- Your aliases
- Your configuration
- Common tasks you perform

---

## 📖 Example: git.md

```markdown
# Tool: Git

**Version:** 2.42+
**Purpose:** Version control, collaboration

## ⚙️ Configuration

```bash
git config --global user.name "<YOUR_NAME>"
git config --global user.email "<YOUR_EMAIL>"
git config --global core.editor "vim"
git config --global init.defaultBranch "main"
```

## 🔧 Common Commands

- `git status` - Check working tree
- `git log --oneline --graph --all` - Visual history
- `git add -p` - Stage interactively

## 📚 Aliases

```bash
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --all'
```

## 🎯 Workflow

1. Create feature branch: `git checkout -b feature/name`
2. Make changes, commit frequently
3. Push to remote: `git push -u origin feature/name`
4. Create PR on GitHub
5. Squash merge to main

## 📖 Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)
```

---

**Created:** 2025-11-09
**Customize:** Create tool preference files as needed
