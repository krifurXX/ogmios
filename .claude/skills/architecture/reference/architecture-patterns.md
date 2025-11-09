# Architecture Patterns Reference

## Overview
Common architectural patterns, their characteristics, and when to use them.

## Monolithic Architecture

### Description
Single, unified application where all components are tightly coupled and deployed together.

### Characteristics
- Single codebase
- Shared database
- Single deployment unit
- In-process communication

### When to Use
- Small to medium applications
- Simple domains
- Limited scalability requirements
- Small development teams

### Pros
- Simple development and deployment
- Easy to test and debug
- Good performance (no network overhead)
- Straightforward data consistency

### Cons
- Scaling is all-or-nothing
- Technology lock-in
- Large codebase can become unwieldy
- Deployment risk (everything deploys together)

## Microservices Architecture

### Description
Application composed of small, independent services communicating over network.

### Characteristics
- Multiple codebases (per service)
- Service-specific databases
- Independent deployment
- Network communication (REST, gRPC, messaging)

### When to Use
- Large, complex applications
- Need for independent scaling
- Multiple development teams
- Different technology needs per service

### Pros
- Independent scaling and deployment
- Technology diversity
- Fault isolation
- Team autonomy

### Cons
- Distributed system complexity
- Network latency
- Data consistency challenges
- Operational overhead

## Event-Driven Architecture

### Description
System where components communicate through events published to an event bus.

### Characteristics
- Asynchronous communication
- Event producers and consumers
- Message broker/event bus
- Eventual consistency

### When to Use
- Real-time data processing
- Complex workflows
- Need for decoupling
- Audit trails required

### Pros
- Loose coupling
- Scalability
- Flexibility
- Event replay and audit

### Cons
- Eventual consistency
- Debugging complexity
- Message broker dependency
- Ordering challenges

## Serverless Architecture

### Description
Application built using managed services and functions that auto-scale.

### Characteristics
- No server management
- Pay-per-use pricing
- Auto-scaling
- Stateless functions

### When to Use
- Variable traffic patterns
- Event-driven workloads
- Rapid prototyping
- Cost optimization focus

### Pros
- No infrastructure management
- Automatic scaling
- Pay only for usage
- Fast time to market

### Cons
- Vendor lock-in
- Cold start latency
- Execution time limits
- Statelessness constraints

## Layered Architecture

### Description
Application organized into horizontal layers (presentation, business logic, data).

### Characteristics
- Separation of concerns
- Layer dependencies (top to bottom)
- Clear boundaries
- Standard pattern

### When to Use
- Traditional enterprise applications
- Clear separation needed
- Team organization by layer
- Standard CRUD applications

### Pros
- Well understood
- Clear separation of concerns
- Easy to organize teams
- Testable layers

### Cons
- Can become rigid
- All requests pass through layers
- Potential performance overhead
- May encourage anemic domain models

## Hexagonal Architecture (Ports & Adapters)

### Description
Core business logic isolated from external concerns through ports and adapters.

### Characteristics
- Core domain in center
- Ports define interfaces
- Adapters implement interfaces
- External concerns pluggable

### When to Use
- Domain-driven design
- Need for testability
- Multiple integration points
- Long-term maintainability focus

### Pros
- Highly testable
- Technology agnostic core
- Easy to swap implementations
- Clear domain boundaries

### Cons
- Initial complexity
- More abstractions
- Learning curve
- May be overkill for simple apps

## Selection Criteria

### Choose Based On
1. **Scale requirements**: Current and projected
2. **Team size and structure**: Single team vs multiple teams
3. **Domain complexity**: Simple vs complex business logic
4. **Deployment needs**: Frequency and independence
5. **Technology diversity**: Single stack vs polyglot
6. **Operational capability**: Team's operational maturity

### Start Simple
- Begin with monolith for most new projects
- Extract microservices when clear boundaries emerge
- Add event-driven patterns where needed
- Consider serverless for specific workloads

### Evolution Path
Monolith → Modular Monolith → Strategic Microservices → Full Microservices

Choose architecture based on actual needs, not trends.
