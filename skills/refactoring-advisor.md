---
name: refactoring-advisor
description: Analyze code for refactoring opportunities and recommend improvement patterns
version: 1.0
priority: medium
category: quality
tags: [refactoring, code-quality, code-smells, patterns, improvement]
---

# Refactoring Advisor Skill

## Purpose

Analyze code for structural issues, identify refactoring opportunities, and recommend specific improvement patterns with before/after examples. Focuses on making code more maintainable, readable, and testable without changing external behavior.

## When to Use

- Code review reveals structural issues
- Module or class has grown too large
- Adding features is increasingly difficult
- Test coverage is hard to improve
- Multiple developers report difficulty understanding code
- Performance bottlenecks traced to structural issues

## Code Smell Detection

### Bloaters (Code Too Large)

**Long Method** (>30 lines or >3 levels of nesting)
```
Symptom: Method does too many things, hard to name
Fix: Extract Method — pull cohesive blocks into named functions
```

**Large Class** (>300 lines or >10 public methods)
```
Symptom: Class has multiple responsibilities
Fix: Extract Class — split into focused, single-responsibility classes
```

**Long Parameter List** (>4 parameters)
```
Symptom: Function signature is hard to read and call correctly
Fix: Introduce Parameter Object — group related params into a struct/class
```

### Object-Orientation Abusers

**Switch Statements** (repeated switch/match on same type field)
```
Symptom: Same conditional logic duplicated across methods
Fix: Replace Conditional with Polymorphism — use strategy pattern or trait objects
```

**Feature Envy** (method uses another class's data more than its own)
```
Symptom: Method mostly accesses fields of another object
Fix: Move Method — relocate the method to the class whose data it uses
```

### Change Preventers

**Divergent Change** (one class changed for multiple unrelated reasons)
```
Symptom: Class modified every time a different feature changes
Fix: Extract Class — separate concerns into distinct classes
```

**Shotgun Surgery** (one change requires modifying many classes)
```
Symptom: Small feature change touches 10+ files
Fix: Move Method/Field — consolidate related logic into fewer classes
```

### Dispensables

**Dead Code** (unreachable code, unused variables, obsolete methods)
```
Symptom: Code that never executes or is never called
Fix: Delete it — version control preserves history if needed
```

**Speculative Generality** (abstractions with only one implementation)
```
Symptom: Interface with one implementor, factory that creates one type
Fix: Inline Class/Method — remove unnecessary abstraction layer
```

## Refactoring Patterns

### Extract Method

**Before:**
```python
def process_order(order):
    # Validate
    if not order.items:
        raise ValueError("Empty order")
    if order.total < 0:
        raise ValueError("Invalid total")

    # Calculate discount
    discount = 0
    if order.customer.is_vip:
        discount = order.total * 0.1
    elif order.total > 100:
        discount = order.total * 0.05

    # Apply and save
    order.total -= discount
    db.save(order)
```

**After:**
```python
def process_order(order):
    validate_order(order)
    discount = calculate_discount(order)
    order.total -= discount
    db.save(order)
```

### Replace Conditional with Polymorphism

**Before:**
```typescript
function calculateArea(shape: Shape): number {
  switch (shape.type) {
    case "circle": return Math.PI * shape.radius ** 2;
    case "rectangle": return shape.width * shape.height;
    case "triangle": return 0.5 * shape.base * shape.height;
  }
}
```

**After:**
```typescript
interface Shape {
  area(): number;
}

class Circle implements Shape {
  constructor(private radius: number) {}
  area(): number { return Math.PI * this.radius ** 2; }
}
```

### Introduce Parameter Object

**Before:**
```go
func createUser(name string, email string, age int, role string, dept string) error {
```

**After:**
```go
type CreateUserRequest struct {
    Name  string
    Email string
    Age   int
    Role  string
    Dept  string
}

func createUser(req CreateUserRequest) error {
```

## Analysis Workflow

1. **Identify**: Scan for code smells using the patterns above
2. **Assess Impact**: Rank by severity (how much it impairs maintainability)
3. **Recommend**: Suggest specific refactoring with before/after examples
4. **Validate**: Ensure refactoring preserves behavior (tests must still pass)
5. **Prioritize**: High-churn files first (frequently modified = highest ROI)

## Complexity Metrics

- **Cyclomatic Complexity**: Count decision points (if, for, while, match). Target: <10 per function
- **Cognitive Complexity**: Count nesting depth and breaks in linear flow. Target: <15 per function
- **Lines per Function**: Target: <30 lines
- **Parameters per Function**: Target: <4 parameters
- **Dependencies per Module**: Target: <7 direct imports

## Integration

Coordinates with:
- All language expert agents (for language-specific refactoring)
- `code-review-gatekeeper` (for quality validation after refactoring)
- `comprehensive-analyst` (for impact analysis of large refactorings)
