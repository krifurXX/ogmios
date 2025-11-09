# Create Map of Content (MOC) Workflow

## Overview
Create structured Maps of Content to organize related atomic notes and provide navigation through knowledge domains.

## When to Use
- Organizing 10+ related Cards
- Creating topic overviews
- Structuring research domains
- Building navigation for knowledge areas

## Prerequisites
Load your vault context:
```
Read: ~/.claude/.claude/context/preferences/vault-structure.md (if exists)
```

## Workflow Steps

### 1. Identify Topic Scope
Define MOC boundaries:
- Topic area and subtopics
- Related Cards to include
- Target audience (self/others)
- Purpose (navigation/learning/reference)

### 2. Create MOC File
Location: `<your_vault>/MOCs/`
Naming: `MOC - Topic Name.md`

### 3. Add Metadata
```yaml
---
type: moc
created: YYYY-MM-DD
tags: [moc, topic-area]
---
```

### 4. Structure Content

#### Overview Section
Brief introduction explaining the topic and MOC purpose

#### Organized Links
Group Cards by subtopics:
```markdown
## Core Concepts
- [[Card 1 - Fundamental Concept]]
- [[Card 2 - Key Principle]]

## Advanced Topics
- [[Card 3 - Advanced Pattern]]
- [[Card 4 - Implementation Details]]

## Related Areas
- [[MOC - Related Topic]]
```

#### Navigation
- Link to parent MOCs
- Link to related MOCs
- Link to relevant project notes

### 5. Bidirectional Links
- Add MOC link to all included Cards
- Update parent MOCs to include this MOC
- Cross-reference related MOCs

### 6. Ongoing Maintenance
MOCs are living documents:
- Add new Cards as created
- Reorganize when structure emerges
- Update as understanding deepens

## Quality Criteria
- [ ] Clear topic scope
- [ ] Logical organization
- [ ] All Cards linked
- [ ] Bidirectional links complete
- [ ] Navigation to related areas
- [ ] Brief explanatory text

## Expected Output
Structured MOC providing clear navigation through knowledge domain.

## Voice Announcement
```
🎯 COMPLETED: [SKILL:knowledge-management] Map of Content created
🗣️ CUSTOM COMPLETED: Knowledge map ready
```
