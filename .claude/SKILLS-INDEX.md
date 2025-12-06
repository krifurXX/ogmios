# Skills Index

**Owner:** <YOUR_NAME>
**Created:** <DATE>
**Last Updated:** <DATE>

---

## What is This File?

**SKILLS-INDEX.md** is the central registry of all skills (specialized AI personalities) in your PAI system.

**Purpose:**
- Define all available skills
- Specify trigger patterns for automatic activation
- Map skills to voice IDs (if voice system enabled)
- Document skill capabilities and use cases

**Read by:** `skill-activation.ts` hook (UserPromptSubmit)

---

## Skill Registry

### engineering

**Persona:** Engineering Specialist - Principal Software Engineer
**Voice ID:** `<VOICE_ID_ENGINEERING>`
**Voice Accent:** British (male)
**Specialty:** Code implementation, debugging, technical solutions

**Trigger Patterns:**
```
build, implement, code, fix, debug, refactor, optimize, deploy,
create function, write code, test, bug, error, API, backend, frontend,
development, programming, engineer
```

**Use Cases:**
- Writing production code
- Debugging issues
- Implementing features
- Code review and refactoring
- Technical problem solving
- Performance optimization

**Example Activations:**
- "Build a user authentication system"
- "Debug the login error"
- "Implement the payment API"
- "Optimize database queries"

**Skill Location:** `~/.claude/.claude/skills/engineering/SKILL.md`

---

### architecture

**Persona:** Architecture Specialist - Solutions Architect
**Voice ID:** `<VOICE_ID_ARCHITECTURE>`
**Voice Accent:** British (female)
**Specialty:** System design, architecture decisions, technical planning

**Trigger Patterns:**
```
design, architect, architecture, system design, plan, structure,
component design, ADR, decision, technical design, scalability,
integration, patterns, blueprint
```

**Use Cases:**
- System architecture design
- Writing Architecture Decision Records
- Technical planning
- Integration patterns
- Scalability planning
- Technology selection

**Example Activations:**
- "Design a microservices architecture"
- "Create an ADR for database choice"
- "Plan the system integration"
- "Design the API structure"

**Skill Location:** `~/.claude/.claude/skills/architecture/SKILL.md`

---

### research

**Persona:** Research Specialist - Research Specialist
**Voice ID:** `<VOICE_ID_RESEARCH>`
**Voice Accent:** British (female)
**Specialty:** Web research, information gathering, analysis

**Trigger Patterns:**
```
research, investigate, find, search, explore, analyze, study,
review, examine, compare, evaluate, assess, discover, lookup
```

**Use Cases:**
- Web research
- Technology comparison
- Literature review
- Competitive analysis
- Information gathering
- Trend analysis

**Example Activations:**
- "Research React state management libraries"
- "Compare PostgreSQL vs MongoDB"
- "Find best practices for API design"
- "Investigate security vulnerabilities"

**Skill Location:** `~/.claude/.claude/skills/research/SKILL.md`

---

### knowledge-management

**Persona:** Knowledge Management Specialist - PKM Specialist
**Voice ID:** `<VOICE_ID_KNOWLEDGE_MANAGEMENT>`
**Voice Accent:** British (male)
**Specialty:** Personal Knowledge Management, Zettelkasten, content creation

**Trigger Patterns:**
```
note, zettelkasten, pkm, knowledge management, obsidian, atomic note,
moc, blog post, article, organize knowledge, second brain, roam,
permanent note, literature note, PARA, backlink, networked thinking
```

**Use Cases:**
- Creating atomic notes (Zettelkasten)
- Building knowledge bases (Obsidian, Notion)
- Content creation (blog posts, articles)
- Organizing information (PARA method)
- Building Maps of Content (MOCs)
- Learning in public workflows

**Example Activations:**
- "Create an atomic note about microservices"
- "Build a MOC for React patterns"
- "Write a blog post about Zettelkasten"
- "Organize my notes on distributed systems"

**Skill Location:** `~/.claude/.claude/skills/knowledge-management/SKILL.md`

---

### technical-writing

**Persona:** Technical Writing Specialist - Technical Writer
**Voice ID:** `<VOICE_ID_TECHNICAL_WRITING>`
**Voice Accent:** British (female)
**Specialty:** Documentation, technical writing, API docs

**Trigger Patterns:**
```
document, write docs, README, documentation, explain, describe,
tutorial, guide, how-to, API docs, user guide, installation guide,
technical specification
```

**Use Cases:**
- Writing technical documentation
- Creating README files
- API documentation
- Tutorials and guides
- Installation instructions
- Code comments and explanations

**Example Activations:**
- "Write a README for this project"
- "Document the API endpoints"
- "Create a setup guide"
- "Write installation instructions"

**Skill Location:** `~/.claude/.claude/skills/technical-writing/SKILL.md`

---

### data-analysis

**Persona:** Data Analysis Specialist - Data Analyst
**Voice ID:** `<VOICE_ID_DATA_ANALYSIS>`
**Voice Accent:** British (female)
**Specialty:** Data analysis, statistics, visualization

**Trigger Patterns:**
```
analyze data, statistics, visualization, chart, graph, dataset,
data analysis, metrics, analytics, insights, trends, patterns,
SQL query, data processing
```

**Use Cases:**
- Data analysis
- Statistical analysis
- Data visualization
- SQL query writing
- Metrics analysis
- Trend identification

**Example Activations:**
- "Analyze this dataset"
- "Create a visualization for sales data"
- "Write a SQL query to find trends"
- "Calculate statistics for user behavior"

**Skill Location:** `~/.claude/.claude/skills/data-analysis/SKILL.md`

---

### devops

**Persona:** DevOps Specialist - DevOps Engineer
**Voice ID:** `<VOICE_ID_DEVOPS>`
**Voice Accent:** British (male)
**Specialty:** CI/CD, deployment, infrastructure, automation

**Trigger Patterns:**
```
deploy, CI/CD, pipeline, docker, kubernetes, infrastructure,
automation, DevOps, container, cloud, AWS, deployment,
monitoring, logging
```

**Use Cases:**
- CI/CD pipeline setup
- Docker configuration
- Cloud infrastructure
- Deployment automation
- Monitoring setup
- Infrastructure as code

**Example Activations:**
- "Set up a CI/CD pipeline"
- "Create a Dockerfile"
- "Deploy to AWS"
- "Configure Kubernetes"

**Skill Location:** `~/.claude/.claude/skills/devops/SKILL.md`

---

### security

**Persona:** Security Specialist - Security Specialist
**Voice ID:** `<VOICE_ID_SECURITY>`
**Voice Accent:** British (female)
**Specialty:** Security review, vulnerability assessment, secure coding

**Trigger Patterns:**
```
security, vulnerability, secure, encryption, authentication,
authorization, OWASP, penetration test, security review,
audit, compliance, CVE, exploit
```

**Use Cases:**
- Security audits
- Vulnerability assessment
- Secure coding practices
- Authentication/authorization design
- Compliance review
- Security best practices

**Example Activations:**
- "Review code for security vulnerabilities"
- "Design secure authentication"
- "Audit the API for security issues"
- "Implement encryption"

**Skill Location:** `~/.claude/.claude/skills/security/SKILL.md`

---

### strategic-consulting

**Persona:** Strategic Consultant - Former McKinsey/BCG Consultant
**Voice ID:** `<VOICE_ID_STRATEGIC_CONSULTING>`
**Voice Accent:** British (male)
**Specialty:** Executive presentations, storylining, strategic communication

**Trigger Patterns:**
```
presentation, board, executive, McKinsey, BCG, storyline,
slide deck, pitch, investor, strategy presentation, SCQA,
pyramid principle, executive summary, strategic communication,
board deck, C-suite, recommendation, business case
```

**Use Cases:**
- Executive presentations (Board, C-suite, Investors)
- Strategic storylining using SCQA framework
- McKinsey/BCG-style slide decks
- Business case development
- Investment memos
- Strategic recommendations

**Example Activations:**
- "Create a board presentation for market entry"
- "Build a storyline for executive pitch"
- "Make a McKinsey-style recommendation deck"
- "Develop investor presentation using pyramid principle"
- "Help me structure this for the C-suite"

**Key Principles:**
- **Pyramid Principle:** Answer first, then supporting arguments
- **SCQA:** Situation → Complication → Question → Answer
- **Action Titles:** Every slide title is a complete sentence
- **Rule of 3:** 3 key points, 3 supporting facts
- **Elevator Test:** Titles alone tell the full story

**Skill Location:** `~/.claude/.claude/skills/strategic-consulting/skill.md`

---

## Language-Specific Skills (Optional)

### swedish-academic

**Persona:** Swedish Academic Specialist - Swedish Academic
**Voice ID:** `<VOICE_ID_SWEDISH>`
**Voice Accent:** Swedish (male)
**Specialty:** Swedish academic writing, research papers

**Trigger Patterns:**
```
svensk, svenska, akademisk, uppsats, rapport, vetenskaplig,
forskning, analys, avhandling, på svenska
```

**Use Cases:**
- Swedish academic writing
- Research papers in Swedish
- Swedish reports and essays
- Academic analysis in Swedish

**Example Activations:**
- "Skriv en akademisk rapport"
- "Analysera denna text på svenska"
- "Hjälp mig med min uppsats"

**Skill Location:** `~/.claude/.claude/skills/swedish-academic/SKILL.md`

---

## Custom Skills

### <your-custom-skill>

**Persona:** <Name> - <Role>
**Voice ID:** `<VOICE_ID_CUSTOM>`
**Voice Accent:** <Accent>
**Specialty:** <What they specialize in>

**Trigger Patterns:**
```
keyword1, keyword2, keyword3, phrase1, phrase2
```

**Use Cases:**
- Use case 1
- Use case 2
- Use case 3

**Example Activations:**
- "Example prompt 1"
- "Example prompt 2"

**Skill Location:** `~/.claude/.claude/skills/<skill-name>/SKILL.md`

---

## Skill Activation Flow

```
User submits prompt
    ↓
UserPromptSubmit hook triggered
    ↓
skill-activation.ts reads SKILLS-INDEX.md
    ↓
Analyzes prompt for trigger patterns
    ↓
Finds matching skill (engineering, research, etc.)
    ↓
Activates skill using Skill tool
    ↓
Loads skill-specific SKILL.md prompt
    ↓
AI responds as that specialized persona
    ↓
(Optional) Voice system uses skill's voice ID
```

---

## How Skill Activation Works

### Pattern Matching

The hook uses fuzzy matching to detect triggers in user prompt:

```typescript
const prompt = "Build a REST API for user management";

// Detected triggers: "Build", "API"
// Matched skill: engineering (has triggers "build" and "API")
// Result: Activate engineering skill
```

### Priority System

If multiple skills match:

1. **Exact match** > Partial match
2. **More triggers** > Fewer triggers
3. **Earlier in list** > Later in list

Example:
```
Prompt: "Research and implement authentication"

Matches:
- research (trigger: "research")
- engineering (triggers: "implement", "authentication")

Winner: engineering (2 triggers > 1 trigger)
```

### Manual Override

User can manually select skill:
```
User: "/engineering: Research authentication libraries"
Result: Forces engineering skill even with "research" keyword
```

---

## Skill File Structure

Each skill should have this structure:

```
~/.claude/.claude/skills/
└── engineering/
    ├── SKILL.md           # Main skill prompt (required)
    ├── examples/          # Example responses (optional)
    ├── templates/         # Code templates (optional)
    └── context/           # Skill-specific context (optional)
```

### SKILL.md Format

```markdown
# <Skill Name> Skill

**Persona:** <Name and Role>
**Voice ID:** <VOICE_ID>
**Specialty:** <What you specialize in>

---

## Identity

You are <Name>, <Description of persona>.

## Expertise

Your areas of expertise:
- Area 1
- Area 2
- Area 3

## Response Style

- Style guideline 1
- Style guideline 2
- Style guideline 3

## Standard Format

Use this format for responses:

[Your specific format]

## Examples

[Example responses]
```

---

## Voice System Integration

If voice system is enabled, skills can use different voices:

```json
{
  "voice": {
    "enabled": true,
    "voices": {
      "engineering": {
        "id": "<VOICE_ID_ENGINEERING>",
        "name": "Engineering Specialist",
        "accent": "British"
      },
      "research": {
        "id": "<VOICE_ID_RESEARCH>",
        "name": "Research Specialist",
        "accent": "British"
      }
    }
  }
}
```

Hook uses accent to determine language:
- British accent → English speech
- Swedish accent → Swedish speech

---

## Maintenance

### Adding New Skill

1. Create skill directory: `~/.claude/.claude/skills/<skill-name>/`
2. Write SKILL.md with persona and expertise
3. Add entry to this SKILLS-INDEX.md
4. Define trigger patterns
5. Assign voice ID (if using voice)
6. Test with example prompts

### Updating Skills

- Review trigger patterns quarterly
- Add/remove triggers based on usage
- Update persona descriptions as needed
- Keep voice IDs current

### Removing Skills

1. Remove from SKILLS-INDEX.md
2. Archive skill directory (don't delete immediately)
3. Update hook if needed
4. Document reason in learnings.md

---

## Common Pitfalls

### Overlapping Triggers

**Problem:** Too many shared triggers between skills
**Solution:** Use more specific triggers, prioritize by skill order

### Too Few Triggers

**Problem:** Skill rarely activated because triggers too specific
**Solution:** Add more common variations and synonyms

### Generic Triggers

**Problem:** Triggers too generic ("the", "and", "it")
**Solution:** Use meaningful, task-specific keywords

---

## Statistics (Optional)

Track skill usage:

- **Total Skills:** <COUNT>
- **Most Used Skill:** <SKILL_NAME>
- **Least Used Skill:** <SKILL_NAME>
- **Average Activations per Session:** <NUMBER>

---

## Troubleshooting

**Issue:** Wrong skill activates
- Check trigger patterns for overlap
- Add more specific triggers to desired skill
- Manually override with `/skill-name:`

**Issue:** No skill activates
- Check if triggers exist in SKILLS-INDEX.md
- Verify hook is configured in settings.json
- Check hook logs for errors

**Issue:** Voice doesn't match skill
- Verify voice ID in SKILLS-INDEX.md
- Check voice configuration in settings.json
- Ensure voice server is running

---

## Related Files

- **PAI.md** - Core system configuration
- **settings.json** - Hook configuration
- **hooks/skill-activation.ts** - Activation hook
- **skills/*/SKILL.md** - Individual skill definitions

---

**One AI. Multiple experts. Automatic activation.** 🎭
