# Monitoring Best Practices

## The Four Golden Signals
1. **Latency**: Response time
2. **Traffic**: Request rate
3. **Errors**: Error rate
4. **Saturation**: Resource usage

## Alert Design
- Actionable: Can be fixed
- Specific: Clear what's wrong
- Prioritized: Critical vs warning
- Documented: Runbook available

## SLIs and SLOs
- SLI: Service Level Indicator (metric)
- SLO: Service Level Objective (target)
- Example: "99.9% of requests < 200ms"

## Logging Best Practices
- Structured logging (JSON)
- Include correlation IDs
- Log levels appropriately
- Sensitive data scrubbing
- Retention policies

## Dashboard Design
- Key metrics above fold
- Time ranges selectable
- Alert thresholds visible
- Drill-down capability
