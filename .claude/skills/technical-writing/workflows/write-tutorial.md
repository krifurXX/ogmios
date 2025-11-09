# Write Tutorial Workflow

## Overview
Create step-by-step tutorials that teach users how to accomplish specific tasks.

## When to Use
- Onboarding new users
- Teaching complex features
- Integration guides
- Best practices demonstrations

## Workflow Steps

### 1. Define Learning Objectives
- What will users accomplish?
- What prior knowledge is assumed?
- How long should tutorial take?
- What's the end result?

### 2. Structure Tutorial

**Introduction:**
- What user will build/learn
- Prerequisites
- Time estimate
- Final result preview

**Prerequisites Section:**
```markdown
## Prerequisites
- Node.js 18+ installed
- Basic JavaScript knowledge
- Text editor (VS Code recommended)
```

**Step-by-Step Instructions:**
Each step should:
- Start with action verb
- Show command/code
- Explain what it does
- Show expected output

### 3. Write Each Step

**Step Format:**
```markdown
## Step 1: Initialize Project

Create a new directory and initialize npm:

```bash
mkdir my-project
cd my-project
npm init -y
```

This creates a `package.json` file with default settings.

**Expected output:**
```
Wrote to /path/to/my-project/package.json
```
```

### 4. Add Code Examples
- Complete, working examples
- Incremental (build on previous steps)
- Well-commented code
- Highlight important lines

### 5. Include Troubleshooting
Common issues section:
```markdown
## Troubleshooting

**Error: "Module not found"**
- Ensure you ran `npm install`
- Check package.json dependencies

**Port already in use**
- Stop other servers on port 3000
- Or change port in config
```

### 6. Provide Next Steps
- What user learned
- Related tutorials
- Further reading
- Advanced topics to explore

## Quality Standards
- Every step tested and works
- Screenshots where helpful
- Clear, simple language
- Incremental progression
- Working final result

## Tutorial Types

**Quick Start:**
- 5-10 minutes
- Get something working fast
- Basic features only

**Comprehensive Guide:**
- 20-30 minutes
- Cover main features
- Include best practices

**Deep Dive:**
- 45+ minutes
- Advanced topics
- Real-world scenarios

## Voice Announcement
```
🎯 COMPLETED: [SKILL:technical-writing] Tutorial complete and tested
🗣️ CUSTOM COMPLETED: Tutorial ready
```
