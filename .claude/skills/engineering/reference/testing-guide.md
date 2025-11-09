# Testing Guide

## Purpose
Comprehensive guide to testing strategies, best practices, and implementation.

## Testing Philosophy

### Why Test?
- **Prevent bugs** reaching production
- **Enable refactoring** with confidence
- **Document behavior** through test cases
- **Faster development** (fix bugs early vs debugging production)

### Test Pyramid
```
        /\
       /  \      E2E (Few)
      /    \     - Full user workflows
     /------\
    /        \   Integration (Some)
   /          \  - Component interaction
  /------------\
 /______________\ Unit (Many)
                  - Individual functions/classes
```

**Ratio**: ~70% unit, ~20% integration, ~10% E2E

## Test Types

### Unit Tests

**Purpose**: Test individual functions/methods in isolation

**Characteristics**:
- Fast (< 1ms per test)
- No external dependencies (mock databases, APIs)
- Test one thing per test
- Predictable and deterministic

**Example (TypeScript/Jest)**:
```typescript
describe('validateEmail', () => {
  it('should return true for valid email', () => {
    expect(validateEmail('user@example.com')).toBe(true);
  });

  it('should return false for invalid email', () => {
    expect(validateEmail('invalid-email')).toBe(false);
  });

  it('should return false for empty string', () => {
    expect(validateEmail('')).toBe(false);
  });

  it('should return false for null', () => {
    expect(validateEmail(null)).toBe(false);
  });
});
```

**Example (Python/pytest)**:
```python
def test_validate_email_valid():
    assert validate_email('user@example.com') is True

def test_validate_email_invalid():
    assert validate_email('invalid-email') is False

def test_validate_email_empty():
    assert validate_email('') is False

def test_validate_email_none():
    assert validate_email(None) is False
```

### Integration Tests

**Purpose**: Test component interaction and data flow

**Characteristics**:
- Slower than unit tests (< 1s per test)
- May use test database or mock services
- Test realistic scenarios
- Verify components work together

**Example**:
```typescript
describe('UserService Integration', () => {
  let db: Database;
  let userService: UserService;

  beforeAll(async () => {
    db = await setupTestDatabase();
    userService = new UserService(db);
  });

  afterAll(async () => {
    await db.close();
  });

  it('should create user and retrieve by ID', async () => {
    // Create user
    const user = await userService.create({
      name: 'Test User',
      email: 'test@example.com'
    });

    // Verify creation
    expect(user.id).toBeDefined();

    // Retrieve user
    const retrieved = await userService.getById(user.id);

    // Verify retrieval
    expect(retrieved).toEqual(user);
  });
});
```

### End-to-End (E2E) Tests

**Purpose**: Test complete user workflows through the UI/API

**Characteristics**:
- Slowest tests (seconds per test)
- Use real or production-like environment
- Test critical user paths
- Most expensive to maintain

**Example (Playwright)**:
```typescript
test('user can complete checkout', async ({ page }) => {
  // Navigate to product
  await page.goto('/products/123');

  // Add to cart
  await page.click('button:text("Add to Cart")');

  // Go to checkout
  await page.click('a:text("Checkout")');

  // Fill form
  await page.fill('#email', 'user@example.com');
  await page.fill('#cardNumber', '4242424242424242');

  // Submit
  await page.click('button:text("Complete Order")');

  // Verify success
  await expect(page.locator('.success-message')).toBeVisible();
});
```

## Test-Driven Development (TDD)

### Red-Green-Refactor Cycle

1. **Red**: Write failing test first
2. **Green**: Write minimal code to pass test
3. **Refactor**: Improve code while keeping tests green

**Example**:
```typescript
// 1. RED - Write failing test
describe('calculateDiscount', () => {
  it('should apply 10% discount for orders over $100', () => {
    expect(calculateDiscount(150)).toBe(15);
  });
});

// 2. GREEN - Minimal implementation
function calculateDiscount(amount: number): number {
  return amount > 100 ? amount * 0.1 : 0;
}

// 3. REFACTOR - Improve (tests still pass)
function calculateDiscount(
  amount: number,
  threshold: number = 100,
  rate: number = 0.1
): number {
  return amount > threshold ? amount * rate : 0;
}
```

## Testing Best Practices

### AAA Pattern (Arrange-Act-Assert)

```typescript
it('should format currency correctly', () => {
  // Arrange - Set up test data
  const amount = 1234.56;
  const currency = 'USD';

  // Act - Execute code under test
  const result = formatCurrency(amount, currency);

  // Assert - Verify outcome
  expect(result).toBe('$1,234.56');
});
```

### Test Naming

**Good test names**:
- Describe what's being tested
- Specify expected behavior
- Readable as sentences

```typescript
// ✅ Good
it('should throw error when email is invalid')
it('should return empty array when no users exist')
it('should cache results for 5 minutes')

// ❌ Bad
it('test email')
it('works')
it('edge case')
```

### One Assertion Per Test (when possible)

```typescript
// ✅ Preferred - Easy to see what failed
it('should create user with correct name', () => {
  const user = createUser({ name: 'John' });
  expect(user.name).toBe('John');
});

it('should create user with correct email', () => {
  const user = createUser({ email: 'john@example.com' });
  expect(user.email).toBe('john@example.com');
});

// ⚠️ Acceptable - Related assertions
it('should create user with all fields', () => {
  const user = createUser({ name: 'John', email: 'john@example.com' });
  expect(user.name).toBe('John');
  expect(user.email).toBe('john@example.com');
  expect(user.id).toBeDefined();
});
```

### Test Isolation

Each test should be independent:
```typescript
// ✅ Good - Each test resets state
describe('UserService', () => {
  let userService: UserService;

  beforeEach(() => {
    userService = new UserService(); // Fresh instance
  });

  it('test 1', () => { /* ... */ });
  it('test 2', () => { /* ... */ });
});

// ❌ Bad - Shared state between tests
let userService = new UserService(); // Shared!

it('test 1', () => {
  userService.addUser(user1); // Affects test 2
});

it('test 2', () => {
  expect(userService.getUsers()).toHaveLength(0); // Fails!
});
```

## Mocking & Stubbing

### When to Mock
- External services (APIs, databases)
- Slow operations (file I/O, network)
- Non-deterministic behavior (random, dates)

### Mock Example (TypeScript/Jest)
```typescript
// Mock external service
jest.mock('./emailService');

it('should send email on user creation', async () => {
  const mockSendEmail = jest.fn();
  emailService.send = mockSendEmail;

  await userService.create({ email: 'user@example.com' });

  expect(mockSendEmail).toHaveBeenCalledWith({
    to: 'user@example.com',
    subject: 'Welcome'
  });
});
```

### Stub Example (Python/pytest)
```python
def test_fetch_user_data(mocker):
    # Stub external API call
    mock_api = mocker.patch('user_service.api.get')
    mock_api.return_value = {'id': '123', 'name': 'Test User'}

    result = fetch_user_data('123')

    assert result['name'] == 'Test User'
    mock_api.assert_called_once_with('/users/123')
```

## Test Coverage

### Coverage Metrics
- **Line coverage**: % of code lines executed
- **Branch coverage**: % of conditional branches tested
- **Function coverage**: % of functions called

### Coverage Goals
- **80%+ overall** - Good baseline
- **100% for critical paths** - Auth, payments, security
- **Don't chase 100%** - Diminishing returns

### Viewing Coverage
```bash
# TypeScript (Jest)
npm test -- --coverage

# Python (pytest with coverage)
pytest --cov=src --cov-report=html
```

## Testing Anti-Patterns

❌ **Testing implementation details** - Test behavior, not internal structure
❌ **Fragile tests** - Break on irrelevant changes
❌ **Slow tests** - Unit tests should be fast
❌ **Interdependent tests** - Tests depend on execution order
❌ **Hidden dependencies** - Setup buried in helper functions
❌ **Testing frameworks** - Don't test library code
❌ **Ignoring failing tests** - Fix or delete, don't skip

## Testing Tools

### TypeScript/JavaScript
- **Jest**: Full-featured test framework
- **Vitest**: Fast Vite-native testing
- **Playwright**: E2E browser testing
- **Supertest**: HTTP API testing

### Python
- **pytest**: Modern testing framework
- **unittest**: Standard library testing
- **mock**: Mocking library (built into unittest.mock)
- **pytest-cov**: Coverage plugin

## Writing Testable Code

### Dependency Injection
```typescript
// ✅ Testable - Dependencies injected
class UserService {
  constructor(private db: Database) {}

  async getUser(id: string) {
    return this.db.query('SELECT * FROM users WHERE id = ?', [id]);
  }
}

// Easy to test with mock database
const mockDb = { query: jest.fn() };
const service = new UserService(mockDb);

// ❌ Hard to test - Hard-coded dependency
class UserService {
  async getUser(id: string) {
    const db = new Database(); // Can't replace!
    return db.query('SELECT * FROM users WHERE id = ?', [id]);
  }
}
```

### Pure Functions
```typescript
// ✅ Testable - Pure function
function calculateTax(amount: number, rate: number): number {
  return amount * rate;
}

// ❌ Hard to test - Side effects
function calculateTax(order: Order): void {
  const tax = order.total * 0.1;
  order.tax = tax; // Side effect!
  database.save(order); // Side effect!
}
```

## Test Organization

### File Structure
```
project/
├── src/
│   ├── services/
│   │   └── userService.ts
│   └── utils/
│       └── validation.ts
└── tests/
    ├── unit/
    │   ├── services/
    │   │   └── userService.test.ts
    │   └── utils/
    │       └── validation.test.ts
    ├── integration/
    │   └── userFlow.test.ts
    └── e2e/
        └── checkout.test.ts
```

### Test File Naming
- `*.test.ts` or `*.spec.ts` for tests
- `*.test.tsx` for React component tests
- `test_*.py` for Python tests (pytest convention)

## Continuous Integration

### Run Tests on CI
```yaml
# GitHub Actions example
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
      - run: npm install
      - run: npm test
      - run: npm run test:e2e
```

### Pre-commit Hooks
```json
{
  "husky": {
    "hooks": {
      "pre-commit": "npm test",
      "pre-push": "npm run test:integration"
    }
  }
}
```

## Resources

- [Test Driven Development](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530) - Kent Beck
- [Growing Object-Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/)
- [Jest Documentation](https://jestjs.io/)
- [Pytest Documentation](https://docs.pytest.org/)
- [Testing Library](https://testing-library.com/) - React/DOM testing
- [Playwright](https://playwright.dev/) - E2E testing
