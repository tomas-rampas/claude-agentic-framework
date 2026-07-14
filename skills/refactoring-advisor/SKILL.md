---
name: refactoring-advisor
description: Analyze code for structural issues and code smells, then recommend prioritized refactoring patterns with before/after examples. Use when the user asks to refactor, clean up, or improve code structure, when a module has grown hard to change or test, or when a review surfaces maintainability problems.
---

# Refactoring Advisor

Identify structural problems in code, name the smell, and recommend a specific refactoring that preserves external behavior. Never recommend a rewrite when a targeted refactoring will do.

## When to Apply

- Code review reveals structural issues
- A module or class has grown too large or accumulated responsibilities
- Adding features is increasingly difficult, or test coverage is hard to improve
- Developers report difficulty understanding a piece of code
- Performance bottlenecks trace back to structural issues

## Analysis Workflow

1. **Identify**: Scan the target files (Read/Grep/Glob) for the code smells cataloged below.
2. **Assess impact**: Rank each finding by how much it impairs maintainability, testability, and change safety.
3. **Prioritize by churn**: High-churn files first — frequently modified code yields the highest return. Find churn with:
   `git log --format= --name-only -- <path> | sort | uniq -c | sort -rn | head -20`
4. **Recommend**: For each finding, name the smell, the matching refactoring pattern, and show a before/after sketch in the project's language.
5. **Validate**: State how behavior preservation will be verified — existing tests must pass unchanged; if coverage is thin, recommend characterization tests before refactoring.

Present findings as a prioritized list (highest impact x highest churn first), not an unordered dump.

## Code Smell Catalog

### Bloaters (code too large)

- **Long Method** (>30 lines or >3 levels of nesting) — method does too many things and is hard to name. Fix: **Extract Method** — pull cohesive blocks into named functions.
- **Large Class** (>300 lines or >10 public methods) — class has multiple responsibilities. Fix: **Extract Class** — split into focused, single-responsibility classes.
- **Long Parameter List** (>4 parameters) — signature is hard to read and call correctly. Fix: **Introduce Parameter Object** — group related params into a struct/class.

### Object-orientation abusers

- **Switch Statements** — the same switch/match on a type field is duplicated across methods. Fix: **Replace Conditional with Polymorphism** — strategy pattern or trait objects.
- **Feature Envy** — a method accesses another class's data more than its own. Fix: **Move Method** — relocate the method to the class whose data it uses.

### Change preventers

- **Divergent Change** — one class is modified for multiple unrelated reasons. Fix: **Extract Class** — separate the concerns.
- **Shotgun Surgery** — one small change touches many files. Fix: **Move Method/Field** — consolidate related logic into fewer places.

### Dispensables

- **Dead Code** — unreachable code, unused variables, obsolete methods. Fix: delete it; version control preserves history.
- **Speculative Generality** — abstractions with a single implementation (one-implementor interface, factory that creates one type). Fix: **Inline Class/Method** — remove the unnecessary layer.

## Refactoring Pattern Examples

### Extract Method

Before:
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

After:
```python
def process_order(order):
    validate_order(order)
    discount = calculate_discount(order)
    order.total -= discount
    db.save(order)
```

### Replace Conditional with Polymorphism

Before:
```typescript
function calculateArea(shape: Shape): number {
  switch (shape.type) {
    case "circle": return Math.PI * shape.radius ** 2;
    case "rectangle": return shape.width * shape.height;
    case "triangle": return 0.5 * shape.base * shape.height;
  }
}
```

After:
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

Before:
```go
func createUser(name string, email string, age int, role string, dept string) error {
```

After:
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

## Complexity Thresholds

Use these as flags for investigation, not hard rules:

- **Cyclomatic complexity**: decision points (if, for, while, match) — target <10 per function
- **Cognitive complexity**: nesting depth plus breaks in linear flow — target <15 per function
- **Lines per function**: target <30
- **Parameters per function**: target <4
- **Direct imports per module**: target <7

## Delegation

For work that goes beyond advice, route through the roster in the registry (claude.json):

- Language expert agents (rust-expert, python-expert, typescript-expert, etc.) implement language-specific refactorings.
- `comprehensive-analyst` assesses the blast radius of large refactorings before they start.
- `code-review-gatekeeper` validates quality after the refactoring lands.
- `peer-review-critic` performs the final diff-scoped review before the work is declared done.
