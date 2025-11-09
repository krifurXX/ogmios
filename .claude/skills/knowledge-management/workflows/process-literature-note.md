# Process Literature Note Workflow

## Overview
Transform literature notes from academic papers into atomic Cards and integrate into Zettelkasten.

## When to Use
- After reading academic papers
- Processing Zotero literature notes
- Extracting insights from books
- Converting research notes to Cards

## Prerequisites
- Load Arkivet context
- Zotero entry exists (if paper)
- Literature note created in <your_vault>/Sources/

## Workflow Steps

### 1. Review Literature Note
Read through literature note in <your_vault>/Sources/:
- Identify key concepts (atomic)
- Note important findings
- Mark quotable passages
- Find connections to existing knowledge

### 2. Extract Atomic Concepts
For each distinct concept:
- Create separate Card (see create-atomic-note.md)
- Write in own words
- Add source citation
- Link to literature note

### 3. Add Source Citations
For each Card from literature:
```markdown
## Source
[Author Year] - [[Literature Note Title]]
Citation: (Author, Year, p. XX)
```

### 4. Create Connections
Link Cards to:
- Related existing Cards
- Relevant MOCs
- Project notes (if applicable)
- Other literature notes

### 5. Update MOCs
Add new Cards to relevant Maps of Content:
- Topic MOCs
- Research area MOCs
- Methodology MOCs

### 6. Tag Appropriately
- Source type: `#from-paper`, `#from-book`
- Research area: `#digital-resiliens`, `#totalförsvar`
- Card status: `#card`, `#in-progress`
- Zotero: `#zotero` (if from Zotero)

## Quality Criteria
- [ ] Each concept = separate Card
- [ ] Written in own words (not copy-paste)
- [ ] Source properly cited
- [ ] Links to literature note
- [ ] Connected to knowledge network
- [ ] Added to relevant MOCs

## Expected Output
Multiple atomic Cards extracted from literature, fully integrated into Zettelkasten.

## Voice Announcement
```
🎯 COMPLETED: [SKILL:knowledge-management] Literature processed into Cards
🗣️ CUSTOM COMPLETED: Research integrated
```
