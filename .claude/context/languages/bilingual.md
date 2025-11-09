# Bilingual Operation - Language Preferences

**User:** <YOUR_NAME>
**Languages:** Swedish + English
**Created:** <DATE>
**Last Updated:** <DATE>

---

## 🌍 Language Configuration

### Primary Languages
- **Swedish (Svenska):** Native, personal communication
- **English:** Professional, technical documentation

### Language Matching Rule
**Match input language in responses**

- User writes in Swedish → Respond in Swedish
- User writes in English → Respond in English
- Mixed input → Use dominant language or context-appropriate choice

---

## 🎯 Language Usage Guidelines

### Swedish (Svenska)

**Use for:**
- Personal notes and reflections
- Quick communication
- Informal discussions
- Family/friend content
- Swedish academic writing
- Local context (Swedish companies, culture)

**Characteristics:**
- Natural Swedish expressions
- Technical terms can be English (standard practice)
- Mixed Swedish-English technical terminology is normal
- Professional but friendly tone

**Example contexts:**
- "Hjälp mig skriva en anteckning om..."
- "Sammanfatta den här artikeln på svenska"
- "Skriv ett mail till min kollega"

### English

**Use for:**
- Technical documentation
- Code comments and documentation
- Open-source contributions
- International communication
- Academic papers (English)
- Professional documentation

**Characteristics:**
- Clear, concise technical English
- Standard terminology
- Professional tone
- International context

**Example contexts:**
- "Write a README for this project"
- "Document this API endpoint"
- "Create a pull request description"

---

## 📝 Response Format Matching

### Swedish Response Structure
```markdown
📅 <Datum och tid>
🗨️ Svenska

📋 SAMMANFATTNING: Kortfattad översikt
🔍 ANALYS: Viktiga fynd
⚡ ÅTGÄRDER: Steg som tagits
✅ RESULTAT: Utfall
📊 STATUS: Nuvarande läge
➡️ NÄSTA: Rekommenderade nästa steg

🎯 COMPLETED: [Beskrivning]
🗣️ CUSTOM COMPLETED: [Röst-optimerad]
```

### English Response Structure
```markdown
📅 <Date and time>
🗨️ English

📋 SUMMARY: Brief overview
🔍 ANALYSIS: Key findings
⚡ ACTIONS: Steps taken
✅ RESULTS: Outcomes
📊 STATUS: Current state
➡️ NEXT: Recommended next steps

🎯 COMPLETED: [Description]
🗣️ CUSTOM COMPLETED: [Voice-optimized]
```

---

## 🔀 Mixed Language Scenarios

### Technical Terms in Swedish Context
**Acceptable mixing:**
```
"Vi behöver implementera en rate limiter för API:et"
"Kolla igenom git commit-historiken"
"Lägg till unit tests för denna funktion"
```

**Standard in Swedish tech communication!**

### Code Documentation
**Always English:**
- Function names
- Variable names
- Code comments (prefer English)
- API documentation
- README files for open-source

**Can be Swedish:**
- Personal project notes
- Internal documentation
- Comments for Swedish-only teams

---

## 🎤 Voice System Language Routing

### Voice Selection by Accent

**British Accent → English Speech**
- George Foster (Engineering) → English
- Dr. Emma Roberts (Architecture) → English
- Dr. Alice Mitchell (Research) → English

**Swedish Accent → Swedish Speech**
- Prof. Lars Bergström (Swedish Academic) → Swedish
- Swedish skills → Swedish

**Rule:** Voice accent determines speech language, not text language!

**Example:**
```
Text response: Swedish
Active skill: Engineering (British accent)
Voice output: English translation of completion message
```

---

## 📚 Documentation Language Rules

### File Types and Language

| File Type | Language | Reason |
|-----------|----------|--------|
| README.md | English | International standard |
| CODE_OF_CONDUCT.md | English | Community standard |
| CONTRIBUTING.md | English | Open-source standard |
| API docs | English | Developer standard |
| Personal notes | Swedish | Personal preference |
| Meeting notes (Swedish team) | Swedish | Context-appropriate |
| Academic writing (SWE) | Swedish | Publication target |
| Academic writing (INT) | English | Publication target |

---

## 🔧 Technical Terminology

### Prefer English Terms
- Git, commit, push, pull, merge, branch
- API, endpoint, REST, GraphQL
- Frontend, backend, fullstack
- Database, query, index, migration
- Docker, container, image, pod
- CI/CD, deployment, pipeline

### Mixed Usage Acceptable
```
"deploymenten" (Swedish plural form)
"committa" (Swedish verb form)
"mergea" (Swedish verb form)
"buggen" (Swedish definite form)
```

**This is natural Swedish technical language!**

---

## 🎯 Language Detection Hints

### Swedish Indicators
- "hjälp", "kan du", "behöver"
- "sammanfatta", "skriv", "skapa"
- "vad är", "hur gör", "varför"
- Swedish spelling: "och", "för", "är"

### English Indicators
- "help", "can you", "need"
- "summarize", "write", "create"
- "what is", "how to", "why"
- English spelling: "and", "for", "is"

### Ambiguous Cases
- Technical terms (handle context-dependent)
- Proper nouns (no language indicator)
- Code snippets (not language-dependent)

**When ambiguous:** Use last known language or English (safer default)

---

## 📖 Translation Guidelines

### When to Translate
- Voice output (accent-based routing)
- User explicitly requests translation
- Context switch (Swedish notes → English docs)

### What NOT to Translate
- Code
- Technical terms (already English)
- Proper names
- URLs and file paths
- Git commands

---

## 🎓 Examples

### Example 1: Swedish Input, Swedish Output
```
User: "Hjälp mig skriva en funktion för att validera email"

Response:
📅 2025-11-09 16:30
🗨️ Svenska

📋 SAMMANFATTNING: Skapar email-valideringsfunktion

[Swedish explanation]
[Code with English comments]
[Swedish testing instructions]

🎯 COMPLETED: Email-valideringsfunktion implementerad
🗣️ CUSTOM COMPLETED: Email-validering klar
```

### Example 2: English Input, English Output
```
User: "Help me write a function to validate email"

Response:
📅 2025-11-09 16:30
🗨️ English

📋 SUMMARY: Creating email validation function

[English explanation]
[Code with English comments]
[English testing instructions]

🎯 COMPLETED: Email validation function implemented
🗣️ CUSTOM COMPLETED: Email validation ready
```

### Example 3: Mixed Technical Swedish
```
User: "Vi behöver deploya den nya featuren till production"

Response:
📅 2025-11-09 16:30
🗨️ Svenska

📋 SAMMANFATTNING: Deployment av ny feature till production

[Swedish explanation with English tech terms]
[Deployment commands]

🎯 COMPLETED: Feature deployad till production
🗣️ CUSTOM COMPLETED: Deployment klar
```

---

## ✅ Checklist for Responses

**Before sending:**
- [ ] Language matches user input
- [ ] Technical terms appropriate for context
- [ ] Code comments in English (or Swedish for internal)
- [ ] COMPLETED messages in correct language
- [ ] Voice routing correct (if applicable)
- [ ] Documentation language follows rules above

---

## 🔄 Edge Cases

### Case 1: User switches language mid-conversation
**Solution:** Match latest message language

### Case 2: User writes mixed Swedish-English
**Solution:** Use dominant language or default to Swedish if equal

### Case 3: Code-only input
**Solution:** Use last known language or English

### Case 4: Translation request
**User:** "Translate this to Swedish"
**Solution:** Provide translation, mark clearly

---

**Configuration Version:** 1.0
**Created:** 2025-11-09
**Customization:** Adjust language preferences and rules as needed
