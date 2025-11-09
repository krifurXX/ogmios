# Debugging Workflow

## Purpose
Systematic methodology for identifying and resolving bugs and errors.

## When to Use
- Application crashes or errors
- Unexpected behavior
- Performance degradation
- Test failures

## Process

### 1. Reproduce the Issue (5-15 min)
- Document exact steps to reproduce
- Identify consistent vs intermittent behavior
- Note environment details (OS, versions, config)
- Capture error messages and stack traces

**Deliverable**: Reproducible test case

### 2. Isolate the Problem (10-30 min)
- Use binary search debugging (comment out code sections)
- Add strategic logging statements
- Use debugger with breakpoints
- Check recent code changes (git blame/log)
- Review error logs and metrics

**Tools**: Debugger, logging, git history

**Deliverable**: Narrowed-down problem area

### 3. Root Cause Analysis (15-45 min)
- Examine suspect code carefully
- Check assumptions and edge cases
- Review data flow and state changes
- Verify external dependencies (APIs, databases)
- Test hypotheses with targeted changes

**Deliverable**: Understanding of WHY the bug occurs

### 4. Implement Fix (varies)
- Write minimal fix that addresses root cause
- Avoid "shotgun debugging" (random changes)
- Consider side effects and regressions
- Add defensive programming where appropriate

**Deliverable**: Working fix

### 5. Verify Fix (10-20 min)
- Test original reproduction case
- Test related functionality (regression check)
- Add test case to prevent future recurrence
- Verify in production-like environment

**Deliverable**: Verified, tested fix

### 6. Document & Prevent (5-10 min)
- Document the bug and fix
- Add comments explaining non-obvious fixes
- Consider code improvements to prevent similar bugs
- Update tests and validation

**Deliverable**: Complete solution with preventive measures

## Debugging Techniques

### Rubber Duck Debugging
Explain code line-by-line (even to yourself) to spot logic errors.

### Divide and Conquer
Binary search through code: comment out half, test, repeat.

### Add Logging
Strategic print/log statements to trace execution flow.

### Use Debugger
Breakpoints, watch variables, step through code.

### Check Assumptions
Question everything: variable types, null checks, boundary conditions.

## Common Bug Categories

1. **Logic Errors**: Incorrect algorithm or conditional logic
2. **Type Errors**: Wrong data types or conversions
3. **Null/Undefined**: Missing null checks
4. **Race Conditions**: Async timing issues
5. **Off-by-One**: Array index errors
6. **Memory Issues**: Leaks, excessive allocation
7. **Integration**: External API/service failures

## Completion Checklist

- [ ] Bug reproduced consistently
- [ ] Root cause identified
- [ ] Minimal fix implemented
- [ ] Original issue verified fixed
- [ ] No regressions introduced
- [ ] Test added to prevent recurrence
- [ ] Documentation updated

## Example Output

```
🎯 COMPLETED: [SKILL:engineering] Memory leak in data processor fixed
🗣️ CUSTOM COMPLETED: Bug fixed and tested
```

## Related Workflows

- `implement-feature.md` - Return to after fixing tests during development
- `optimize-code.md` - Use after fixing performance-related bugs
