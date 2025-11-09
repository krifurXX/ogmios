# Feature Implementation Workflow

## Purpose
Systematic approach for implementing new features with quality and testing built-in.

## When to Use
- Building new functionality
- Adding capabilities to existing systems
- Creating new modules or components

## Process

### 1. Requirements Analysis (5-10 min)
- Review feature specification
- Identify edge cases and error scenarios
- Clarify acceptance criteria
- List technical dependencies

**Deliverable**: Clear understanding of what to build

### 2. Design Planning (10-15 min)
- Sketch component architecture
- Identify data structures needed
- Plan API interfaces or function signatures
- Consider extensibility and maintenance

**Deliverable**: Technical design notes

### 3. Implementation (varies)
- Write code incrementally
- Follow coding standards (see `reference/coding-standards.md`)
- Add inline documentation for complex logic
- Handle errors gracefully
- Use stack preferences (TypeScript/bun, Python/uv)

**Deliverable**: Working implementation

### 4. Testing (15-30 min)
- Write unit tests for core functionality
- Test edge cases and error paths
- Verify integration with existing code
- Check performance if relevant

**Deliverable**: Tested, verified code

### 5. Documentation (5-10 min)
- Update relevant documentation
- Add usage examples if needed
- Document configuration options
- Note any breaking changes

**Deliverable**: Complete, documented feature

### 6. Review & Refactor (10-15 min)
- Self-review for code quality
- Refactor for clarity if needed
- Verify adherence to SOLID principles
- Check for security issues

**Deliverable**: Production-ready code

## Completion Checklist

- [ ] Requirements understood and addressed
- [ ] Code follows project standards
- [ ] Error handling implemented
- [ ] Tests written and passing
- [ ] Documentation updated
- [ ] Security considerations addressed
- [ ] Performance acceptable
- [ ] Code reviewed (self or peer)

## Example Output

```
🎯 COMPLETED: [SKILL:engineering] User authentication with JWT implemented
🗣️ CUSTOM COMPLETED: Auth feature ready
```

## Related Workflows

- `debug-issue.md` - For fixing bugs discovered during testing
- `optimize-code.md` - For performance improvements after initial implementation
