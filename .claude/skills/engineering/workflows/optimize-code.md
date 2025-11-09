# Code Optimization Workflow

## Purpose
Systematic approach to improving performance and efficiency without breaking functionality.

## When to Use
- Performance issues identified
- Resource constraints (memory, CPU)
- Scalability concerns
- User complaints about slowness

## Process

### 1. Measure & Profile (15-30 min)
- **NEVER optimize without measuring first**
- Use profiling tools to identify bottlenecks
- Measure baseline performance metrics
- Identify hotspots (where time is actually spent)
- Document current metrics

**Tools**:
- Python: cProfile, line_profiler, memory_profiler
- JavaScript: Chrome DevTools, Node.js profiler
- TypeScript: Same as JavaScript

**Deliverable**: Performance profile with hotspots identified

### 2. Prioritize Targets (10 min)
- Focus on biggest bottlenecks first (80/20 rule)
- Consider ROI of optimization effort
- Avoid premature optimization
- Check if issue is algorithmic vs implementation

**Deliverable**: Ordered list of optimization targets

### 3. Research Solutions (15-30 min)
- Review algorithm complexity (Big O)
- Consider different data structures
- Look for standard optimization patterns
- Check library/framework best practices

**Common Optimizations**:
- O(n²) → O(n log n) with better algorithm
- Linear search → Hash table lookup
- Repeated calculation → Caching/memoization
- Synchronous → Asynchronous processing
- Database: N+1 queries → Batch queries

**Deliverable**: Optimization strategy

### 4. Implement Optimization (varies)
- Make ONE change at a time
- Keep original code commented for comparison
- Maintain correctness while improving performance
- Document trade-offs (memory vs speed, readability vs performance)

**Deliverable**: Optimized code

### 5. Measure Improvement (10-15 min)
- Re-run profiling with same test data
- Compare new metrics to baseline
- Verify correctness maintained
- Test edge cases still work

**Deliverable**: Performance metrics showing improvement

### 6. Iterate or Complete (varies)
- If target met → document and finish
- If not met → return to step 2 with new data
- If regression → rollback and try different approach

**Deliverable**: Optimized, verified code with metrics

## Optimization Techniques

### Algorithmic
- Better algorithm (O(n²) → O(n log n))
- Different data structure (list → set, dict)
- Reduce redundant work

### Caching
- Memoization for expensive calculations
- Query result caching
- Computed property caching

### Database
- Add indexes for frequent queries
- Batch operations to reduce round-trips
- Use connection pooling
- Optimize query complexity

### Async/Parallel
- Async I/O instead of blocking
- Parallel processing for CPU-bound tasks
- Background processing for slow operations

### Memory
- Use generators instead of lists (Python)
- Stream processing for large files
- Limit in-memory data structures

## Anti-Patterns to Avoid

❌ Optimizing before measuring (premature optimization)
❌ Making code unreadable for minor gains
❌ Optimizing the wrong bottleneck
❌ Breaking functionality for speed
❌ Ignoring maintenance costs of complex optimization

## Completion Checklist

- [ ] Baseline metrics captured
- [ ] Profiling identified actual bottlenecks
- [ ] Optimization targets prioritized
- [ ] Implementation maintains correctness
- [ ] Performance improvement measured and documented
- [ ] Trade-offs understood and documented
- [ ] Edge cases still work
- [ ] Code remains maintainable

## Example Output

```
🎯 COMPLETED: [SKILL:engineering] Database query optimized - 80% faster
🗣️ CUSTOM COMPLETED: Query optimized
```

## Metrics to Track

- **Response Time**: Before vs after
- **Throughput**: Requests/second
- **Resource Usage**: CPU, memory, disk I/O
- **Latency**: p50, p95, p99 percentiles
- **Database**: Query time, number of queries

## Related Workflows

- `debug-issue.md` - For investigating performance bugs
- `implement-feature.md` - Optimization during initial development
