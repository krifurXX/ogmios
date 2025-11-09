# Create Atomic Note Workflow

## Overview
Extract concepts into atomic Zettelkasten Cards following Luhmann's principles.

## When to Use
- Extracting concepts from literature
- Capturing insights from research
- Creating evergreen notes
- Building knowledge network

## Prerequisites
Load your vault context:
```
Read: ~/.claude/.claude/context/preferences/vault-structure.md (if exists)
```

## Workflow Steps

### 1. Identify Atomic Concept
Single, clear idea that stands alone:
- One concept per note
- Complete thought
- Reusable across contexts

### 2. Create Card File
Location: `<your_vault>/Cards/`
Naming: `YYYYMMDD-HHMM Concept Title.md`

### 3. Add Metadata
```yaml
---
created: YYYY-MM-DD HH:MM
tags: [concept-tag1, concept-tag2, source-type]
aliases: [Alternative Name]
---
```

### 4. Write Content
- **Title**: Clear, descriptive concept name
- **Content**: Explain in your own words (not copy-paste)
- **Links**: Connect to related Cards [[Related Concept]]
- **Source**: Reference if from literature

### 5. Link to Network
- Add links to related Cards
- Update relevant MOCs
- Create backlinks where appropriate

### 6. Tag Appropriately
Use <YOUR_NAME>'s tag structure:
- Concept area (e.g., `#digital-resiliens`)
- Note type (e.g., `#card`, `#atomic-note`)
- Source type (e.g., `#from-paper`, `#from-research`)

## Quality Criteria
- [ ] Single concept (atomic)
- [ ] Written in own words
- [ ] At least 2-3 links to other notes
- [ ] Proper metadata
- [ ] Appropriate tags
- [ ] Stands alone (context-independent)

## Expected Output
Atomic note in <your_vault>/Cards/ folder, linked into knowledge network.

## Voice Announcement
```
🎯 COMPLETED: [SKILL:knowledge-management] Atomic note created and linked
🗣️ CUSTOM COMPLETED: Knowledge card complete
```
