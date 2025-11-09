# Technical Writing Style Guide

## Core Principles

### 1. Clarity Above All
Write to be understood, not to impress.

**Do:**
- Use simple, direct language
- Short sentences (15-20 words)
- Active voice
- Concrete examples

**Don't:**
- Complex jargon without explanation
- Passive constructions
- Vague descriptions
- Assume knowledge

### 2. Consistency
Maintain uniform style throughout documentation.

**Consistent:**
- Terminology (pick one term, use everywhere)
- Code formatting
- Heading hierarchy
- Example structure

### 3. Audience Awareness
Write for your specific readers.

**Consider:**
- Technical level (beginner/intermediate/advanced)
- Prior knowledge assumptions
- Use cases and goals
- Reading context (quick reference vs. learning)

## Language Guidelines

### Active Voice
✅ "The function returns an object"
❌ "An object is returned by the function"

### Present Tense
✅ "The API validates the input"
❌ "The API will validate the input"

### Second Person
✅ "You can configure the timeout"
❌ "One can configure the timeout"

### Imperative for Instructions
✅ "Install the dependencies"
❌ "You should install the dependencies"

## Content Structure

### Inverted Pyramid
Most important information first:
1. What it does (overview)
2. How to use it (quick start)
3. Why it matters (context)
4. Details (deep dive)

### Progressive Disclosure
Reveal complexity gradually:
- Basic example first
- Then common use cases
- Then advanced scenarios
- Finally edge cases

### Chunking Information
Break content into digestible pieces:
- Use headings liberally
- Keep paragraphs short (3-4 sentences)
- Use lists for series
- Use tables for comparisons

## Code Examples

### Complete and Working
Every code example must:
- Run without errors
- Include necessary imports
- Show expected output
- Be tested before publishing

### Minimal and Focused
✅ Shows only relevant code
```javascript
const user = await db.users.findById(id);
```

❌ Includes unnecessary context
```javascript
const express = require('express');
const app = express();
app.get('/users/:id', async (req, res) => {
  const user = await db.users.findById(req.params.id);
  res.json(user);
});
```

### Well-Commented
```javascript
// Validate user input before processing
if (!email.includes('@')) {
  throw new Error('Invalid email format');
}
```

## Formatting Standards

### Headings
```markdown
# H1: Document Title (one per document)
## H2: Major Sections
### H3: Subsections
#### H4: Specific Topics
```

### Code Blocks
Always specify language for syntax highlighting:
````markdown
```javascript
const example = 'code';
```
````

### Lists
**Unordered:** Related items, no sequence
**Ordered:** Steps, sequential process

### Tables
Use for structured comparisons:
```markdown
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id        | string | Yes    | User ID     |
```

## Common Mistakes to Avoid

### ❌ Assuming Knowledge
"Simply configure the webpack build process"
✅ "Configure webpack by editing webpack.config.js"

### ❌ Vague Language
"The function may return null in some cases"
✅ "The function returns null if the user is not found"

### ❌ Unexplained Jargon
"Enable CORS for your API"
✅ "Enable CORS (Cross-Origin Resource Sharing) to allow browser requests from other domains"

### ❌ Missing Context
"Set DEBUG=true"
✅ "Set the DEBUG environment variable to true: `export DEBUG=true`"

### ❌ Incomplete Examples
```javascript
app.listen(3000);
```
✅
```javascript
const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('Hello'));
app.listen(3000, () => console.log('Server running'));
```

## Documentation Types

### Reference Documentation
- Comprehensive coverage
- Precise technical details
- Searchable structure
- API signatures and parameters

### Tutorials
- Step-by-step instructions
- Learning-focused
- Build something concrete
- Progressive difficulty

### How-To Guides
- Task-oriented
- Solve specific problems
- Assumes some knowledge
- Quick and focused

### Explanation/Conceptual
- Understand the "why"
- Architecture and design
- Background and context
- Big picture thinking

## Writing Process

1. **Outline**: Structure before writing
2. **Draft**: Get words down (imperfect OK)
3. **Test**: Verify all code examples work
4. **Edit**: Clarity, conciseness, consistency
5. **Review**: Fresh eyes on content
6. **Publish**: Release and gather feedback

## Quality Checklist

- [ ] Clear purpose and audience
- [ ] Logical structure and flow
- [ ] Working code examples (tested)
- [ ] Consistent terminology
- [ ] Active voice predominant
- [ ] Short paragraphs and sentences
- [ ] Proper heading hierarchy
- [ ] All links working
- [ ] Images have alt text
- [ ] No jargon without explanation
- [ ] Proofread for typos

## Voice and Tone

**Professional but Approachable:**
- Helpful, not condescending
- Confident, not arrogant
- Clear, not simplistic
- Friendly, not casual

**Example:**
❌ "Obviously, you should use async/await"
✅ "We recommend using async/await for cleaner asynchronous code"
