# Technical Preferences

**Purpose:** Store your technical stack preferences, coding standards, and development practices.

---

## 📁 What Goes Here

Create files for different aspects of your technical preferences:

### Examples:
- `stack.md` - Preferred technology stack
- `coding-style.md` - Code style and conventions
- `architecture.md` - Architectural preferences
- `testing.md` - Testing philosophy and tools
- `security.md` - Security practices and requirements
- `performance.md` - Performance guidelines

---

## 📝 Template: stack.md

```markdown
# Technology Stack Preferences

**Updated:** <DATE>

## 🎯 Preferred Technologies

### Backend
- **Language:** Python, Node.js (TypeScript)
- **Framework:** FastAPI, Express.js
- **Database:** PostgreSQL (primary), Redis (cache)
- **ORM:** SQLAlchemy, Prisma

### Frontend
- **Framework:** React + TypeScript
- **Styling:** Tailwind CSS
- **State:** React Query, Zustand
- **Build:** Vite

### DevOps
- **Containerization:** Docker, docker-compose
- **CI/CD:** GitHub Actions
- **Cloud:** <AWS/GCP/Azure/etc>
- **Monitoring:** <YOUR_CHOICE>

## ❌ Avoid
- PHP (outdated for new projects)
- jQuery (use modern React instead)
- MongoDB (prefer PostgreSQL for relational data)

## 🎯 Decision Criteria
- Type safety (prefer TypeScript over JavaScript)
- Active community and maintenance
- Performance and scalability
- Developer experience
```

---

## 📝 Template: coding-style.md

```markdown
# Coding Style & Conventions

**Updated:** <DATE>

## 🎨 General Principles

1. **Readability First** - Code is read more than written
2. **Consistency** - Follow project conventions
3. **Simplicity** - Simple solutions over clever ones
4. **Documentation** - Explain why, not what

## 📏 Formatting

### Indentation
- **Spaces:** 2 for JS/TS/React, 4 for Python
- **No tabs** (use spaces)

### Line Length
- **Max:** 100 characters
- **Break long lines** for readability

### Naming Conventions
- **Variables:** camelCase (JS/TS), snake_case (Python)
- **Constants:** UPPER_SNAKE_CASE
- **Classes:** PascalCase
- **Functions:** camelCase (JS/TS), snake_case (Python)
- **Files:** kebab-case for components, snake_case for Python

## 💬 Comments

```javascript
// Good - Explains WHY
// Using debounce to prevent excessive API calls
const debouncedSearch = debounce(handleSearch, 300);

// Bad - Explains WHAT (code already shows this)
// Call handleSearch after 300ms delay
const debouncedSearch = debounce(handleSearch, 300);
```

## 🎯 Functions

- **Single Responsibility** - One function, one purpose
- **Small Functions** - Aim for <20 lines
- **Descriptive Names** - `getUserProfile()` not `getData()`
- **Few Parameters** - Max 3-4, use objects for more

## 📦 File Organization

```
src/
├── components/     # React components
├── hooks/          # Custom hooks
├── utils/          # Utility functions
├── types/          # TypeScript types
├── api/            # API calls
└── pages/          # Page components
```

## ✅ Best Practices

- **DRY** - Don't Repeat Yourself
- **KISS** - Keep It Simple, Stupid
- **YAGNI** - You Aren't Gonna Need It
- **Error Handling** - Always handle errors
- **Type Safety** - Use TypeScript, avoid `any`
```

---

## 🎯 Why This Helps

When Claude helps you write code, it can automatically:
- Follow your preferred stack
- Use your coding style
- Apply your conventions
- Respect your technical decisions

---

**Created:** 2025-11-09
**Customize:** Create technical preference files matching your workflow
