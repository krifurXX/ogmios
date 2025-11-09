# Documentation Templates

## README Template

```markdown
# Project Name

Brief one-sentence description of the project.

## Features

- Key feature 1
- Key feature 2
- Key feature 3

## Installation

```bash
npm install project-name
```

## Quick Start

```javascript
const project = require('project-name');

// Basic usage example
const result = project.doSomething();
console.log(result);
```

## Usage

### Basic Example

[Show simple use case]

### Advanced Usage

[Show advanced features]

## API Reference

### `functionName(param1, param2)`

Description of what the function does.

**Parameters:**
- `param1` (Type): Description
- `param2` (Type): Description

**Returns:** Description of return value

**Example:**
```javascript
const result = functionName('value1', 'value2');
```

## Configuration

[Configuration options and environment variables]

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

MIT © [Your Name]
```

## API Documentation Template

```markdown
# API Name

Base URL: `https://api.example.com/v1`

## Authentication

All API requests require authentication via Bearer token:

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.example.com/v1/endpoint
```

## Endpoints

### List Resources

```http
GET /resources
```

**Query Parameters:**
- `limit` (integer, optional): Number of results (default: 10)
- `offset` (integer, optional): Pagination offset (default: 0)

**Response:**
```json
{
  "data": [...],
  "total": 100,
  "limit": 10,
  "offset": 0
}
```

**Status Codes:**
- 200: Success
- 401: Unauthorized
- 500: Server error

### Create Resource

```http
POST /resources
```

**Request Body:**
```json
{
  "name": "Resource name",
  "type": "resource_type"
}
```

**Response:**
```json
{
  "id": "123",
  "name": "Resource name",
  "type": "resource_type",
  "created_at": "2024-01-01T00:00:00Z"
}
```

## Rate Limiting

- 1000 requests per hour per API key
- Rate limit headers included in response

## Error Handling

All errors return consistent format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message"
  }
}
```

Common error codes:
- `INVALID_REQUEST`: Malformed request
- `NOT_FOUND`: Resource not found
- `RATE_LIMITED`: Too many requests
```

## Tutorial Template

```markdown
# How to [Accomplish Goal]

In this tutorial, you'll learn how to [specific outcome]. By the end, you'll have [final result].

**Time:** ~20 minutes
**Level:** Beginner

## Prerequisites

- [Required software/knowledge]
- [Required accounts/access]

## What You'll Build

[Brief description and maybe screenshot of final result]

## Step 1: [First Step Title]

[Introduction to this step]

```bash
# Command or code
```

This command [explanation of what it does].

**Expected output:**
```
[Output you should see]
```

## Step 2: [Second Step Title]

[Continue pattern...]

## Testing Your Work

[How to verify it works]

## Troubleshooting

**Problem:** [Common issue]
**Solution:** [How to fix it]

## Next Steps

Now that you've [accomplished goal], you can:
- [Related tutorial or feature]
- [Advanced topic]
- [Different approach]

## Further Reading

- [Link to related docs]
- [Link to API reference]
```

## ADR (Architecture Decision Record) Template

```markdown
# ADR-###: [Decision Title]

**Date:** YYYY-MM-DD
**Status:** [Proposed | Accepted | Deprecated | Superseded]

## Context

[Describe the situation and problem requiring a decision]

## Decision

[State the decision clearly]

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Trade-off 1]
- [Trade-off 2]

### Neutral
- [Implication 1]

## Alternatives Considered

### Option 1: [Alternative]
[Why not chosen]

### Option 2: [Alternative]
[Why not chosen]

## Related Decisions

- [ADR-XXX: Related Decision]

## References

- [Supporting documentation]
- [External resources]
```

## Blog Post Template

```markdown
# [Engaging Title]

[Hook: Start with interesting problem or question]

## The Problem

[Describe the challenge readers face]

## The Solution

[Introduce your approach]

### Step 1: [First Part]

[Explain with code example]

```javascript
// Example code
```

### Step 2: [Second Part]

[Continue pattern...]

## Real-World Example

[Show practical application]

## Results

[Demonstrate the benefits]

## Conclusion

[Summarize key takeaways]

**Key Points:**
- [Takeaway 1]
- [Takeaway 2]
- [Takeaway 3]

**Try it yourself:**
[Call to action]

---

*Want to learn more? Check out [related content]*
```

## Release Notes Template

```markdown
# Version X.Y.Z

**Release Date:** YYYY-MM-DD

## 🎉 New Features

- **[Feature Name]**: Brief description of new capability
  - [Detail 1]
  - [Detail 2]

## 🔧 Improvements

- **[Area]**: What was improved and why it matters

## 🐛 Bug Fixes

- Fixed [specific issue] that caused [problem]
- Resolved [bug] in [component]

## ⚠️ Breaking Changes

- **[Change]**: What changed and how to migrate
  ```javascript
  // Before
  oldWay();

  // After
  newWay();
  ```

## 📚 Documentation

- Added [new guide]
- Updated [existing documentation]

## 🔄 Migration Guide

For users upgrading from X.Y.Z:

1. [Step 1]
2. [Step 2]

## 🙏 Contributors

Thanks to @username1, @username2 for contributions!

---

Full Changelog: [v1.0.0...v1.1.0]
```

## Contributing Guide Template

```markdown
# Contributing to [Project Name]

Thank you for your interest in contributing!

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a branch: `git checkout -b feature/your-feature`

## Development Setup

```bash
npm install
npm run dev
```

## Making Changes

1. Write code
2. Add tests
3. Run tests: `npm test`
4. Update documentation

## Code Style

- Follow existing code style
- Use Prettier for formatting
- Run linter: `npm run lint`

## Commit Messages

Use conventional commits format:
```
type(scope): description

[optional body]
```

Types: feat, fix, docs, style, refactor, test, chore

## Pull Request Process

1. Update README if needed
2. Ensure all tests pass
3. Request review
4. Respond to feedback

## Questions?

Open an issue or contact [email]
```
