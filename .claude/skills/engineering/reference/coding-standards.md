# Coding Standards & Best Practices

## Purpose
Maintain consistent, readable, maintainable code across all projects.

## Core Principles

### 1. Clean Code (Robert C. Martin)
- **Functions do one thing** - Single Responsibility Principle
- **Descriptive names** - Variable and function names explain purpose
- **Small functions** - Ideally < 20 lines, definitely < 50 lines
- **Avoid comments** - Code should be self-documenting
- **DRY** - Don't Repeat Yourself

### 2. SOLID Principles
- **S**ingle Responsibility - One reason to change
- **O**pen/Closed - Open for extension, closed for modification
- **L**iskov Substitution - Subtypes must be substitutable
- **I**nterface Segregation - Many specific interfaces > one general
- **D**dependency Inversion - Depend on abstractions, not concretions

### 3. KISS & YAGNI
- **KISS** - Keep It Simple, Stupid (simplest solution that works)
- **YAGNI** - You Aren't Gonna Need It (don't build for future maybes)

## Language-Specific Standards

### TypeScript

**Naming**:
- Classes: `PascalCase`
- Functions/Variables: `camelCase`
- Constants: `UPPER_SNAKE_CASE`
- Private members: `_leadingUnderscore`

**Style**:
```typescript
// ✅ Good
interface User {
  id: string;
  name: string;
  email: string;
}

function getUserById(id: string): Promise<User | null> {
  // Implementation
}

// ❌ Bad
function get_user(ID: string) { // Wrong naming, no return type
  // Implementation
}
```

**Best Practices**:
- Use `const` by default, `let` when needed, never `var`
- Prefer interfaces over type aliases for objects
- Use async/await over raw promises
- Explicit return types on public functions
- Avoid `any` - use `unknown` if type truly unknown

### Python

**Naming** (PEP 8):
- Classes: `PascalCase`
- Functions/Variables: `snake_case`
- Constants: `UPPER_SNAKE_CASE`
- Private: `_leading_underscore`

**Style**:
```python
# ✅ Good
class UserRepository:
    def get_user_by_id(self, user_id: str) -> Optional[User]:
        """Retrieve user by ID."""
        # Implementation
        pass

# ❌ Bad
class user_repository:  # Wrong case
    def GetUserByID(self, ID):  # Wrong naming, no types
        pass
```

**Best Practices**:
- Type hints on all public functions
- Docstrings for all public functions/classes
- Use list comprehensions for simple transformations
- Prefer f-strings for formatting
- Use context managers (`with`) for resources

## Code Organization

### File Structure
```
project/
├── src/
│   ├── models/         # Data models
│   ├── services/       # Business logic
│   ├── repositories/   # Data access
│   ├── utils/          # Helper functions
│   └── api/            # API routes/controllers
├── tests/              # Mirror src/ structure
└── docs/               # Documentation
```

### Module Size
- Max ~500 lines per file
- Split large files by concern
- Group related functionality

## Error Handling

### TypeScript
```typescript
// ✅ Good - Specific error types
class ValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'ValidationError';
  }
}

try {
  validateUser(data);
} catch (error) {
  if (error instanceof ValidationError) {
    // Handle validation error
  }
  throw error; // Re-throw unknown errors
}

// ❌ Bad - Silent failures
try {
  validateUser(data);
} catch (error) {
  console.log(error); // Just logging
}
```

### Python
```python
# ✅ Good - Specific exceptions
class ValidationError(Exception):
    """Raised when validation fails."""
    pass

try:
    validate_user(data)
except ValidationError as e:
    # Handle validation error
    logger.error(f"Validation failed: {e}")
    raise
except Exception:
    # Handle unexpected errors
    logger.exception("Unexpected error")
    raise

# ❌ Bad - Bare except
try:
    validate_user(data)
except:  # Catches everything including KeyboardInterrupt
    pass
```

## Security Best Practices

### Input Validation
- **Validate all input** - Never trust user input
- **Whitelist > Blacklist** - Define what's allowed, not what's forbidden
- **Type checking** - Verify data types match expectations

### SQL Injection Prevention
```typescript
// ✅ Good - Parameterized queries
const user = await db.query(
  'SELECT * FROM users WHERE id = $1',
  [userId]
);

// ❌ Bad - String concatenation
const user = await db.query(
  `SELECT * FROM users WHERE id = '${userId}'`  // Vulnerable!
);
```

### Secrets Management
- **Never hardcode** secrets, API keys, passwords
- Use environment variables
- Use secret management services in production
- Add `.env` to `.gitignore`

### Authentication & Authorization
- Use established libraries (don't roll your own crypto)
- Hash passwords with bcrypt/argon2
- Use HTTPS for all auth endpoints
- Implement rate limiting

## Testing Standards

### Test Structure (AAA Pattern)
```typescript
describe('UserService', () => {
  it('should create user with valid data', async () => {
    // Arrange
    const userData = { name: 'Test', email: 'test@example.com' };

    // Act
    const user = await userService.create(userData);

    // Assert
    expect(user.name).toBe('Test');
    expect(user.email).toBe('test@example.com');
  });
});
```

### Coverage Goals
- **Unit tests**: 80%+ coverage
- **Integration tests**: Critical paths
- **E2E tests**: Key user workflows

## Performance Guidelines

### Algorithm Complexity
- Know Big O of your algorithms
- O(n) > O(n²) for large datasets
- Use appropriate data structures:
  - Hash maps for lookups: O(1)
  - Sets for membership: O(1)
  - Arrays for ordered data: O(n) search

### Database
- Add indexes for frequently queried fields
- Avoid N+1 queries (use joins or batch loading)
- Limit query results (pagination)
- Use connection pooling

### Async Operations
- Don't block on I/O
- Use async/await for concurrent operations
- Batch API requests when possible

## Documentation Standards

### Code Comments
```typescript
// ✅ Good - Explains WHY
// Using binary search because dataset is pre-sorted
// and can exceed 100K items (O(log n) vs O(n))
const index = binarySearch(items, target);

// ❌ Bad - States the obvious
// Search for target in items
const index = binarySearch(items, target);
```

### Function Documentation
```typescript
/**
 * Retrieves user by ID with caching.
 *
 * @param userId - Unique user identifier
 * @returns User object or null if not found
 * @throws DatabaseError if connection fails
 *
 * @remarks
 * Results are cached for 5 minutes. Use {@link getUserByIdUncached}
 * for real-time data.
 */
async function getUserById(userId: string): Promise<User | null> {
  // Implementation
}
```

## Git Commit Standards

### Commit Messages
```
type(scope): short description

Longer explanation if needed.

- Bullet points for details
- Reference issues: #123
```

**Types**: feat, fix, docs, refactor, test, chore

**Examples**:
```
feat(auth): add JWT token refresh
fix(api): handle null response from user service
docs(readme): update installation instructions
refactor(database): extract query builder
```

## Code Review Checklist

Before submitting code:

- [ ] Code follows project style guide
- [ ] All tests pass
- [ ] New tests added for new functionality
- [ ] No commented-out code
- [ ] No console.log/print statements
- [ ] Error handling implemented
- [ ] Security considerations addressed
- [ ] Performance acceptable
- [ ] Documentation updated
- [ ] Commit messages clear

## Anti-Patterns to Avoid

❌ **Magic Numbers** - Use named constants
❌ **God Objects** - Classes that do too much
❌ **Spaghetti Code** - Tangled dependencies
❌ **Copy-Paste** - Violates DRY
❌ **Premature Optimization** - Optimize after profiling
❌ **Not Invented Here** - Use established libraries
❌ **Gold Plating** - Over-engineering simple solutions

## Resources

- [Clean Code](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882) - Robert C. Martin
- [The Pragmatic Programmer](https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/)
- [PEP 8](https://pep8.org/) - Python Style Guide
- [TypeScript Guidelines](https://github.com/microsoft/TypeScript/wiki/Coding-guidelines)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/) - Security
