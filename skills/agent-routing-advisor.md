---
name: agent-routing-advisor
description: Intelligent task-to-agent mapping recommendations for optimal delegation
version: 1.0
priority: high
category: task-routing
---

# Agent Routing Advisor Skill

## Purpose

Analyze task requirements and recommend the optimal agent(s) for execution. This skill helps users choose the right agent for their task, suggests multi-agent workflows, and provides delegation templates.

## When to Use

- Planning new features or tasks
- Unclear which agent to use for a specific task
- Complex multi-domain tasks requiring coordination
- Optimizing task delegation patterns
- Learning the agent ecosystem
- Quality gate planning

## Agent Selection Logic

### 1. Single Agent Tasks

**Language-Specific Implementation:**

```yaml
task_patterns:
  rust_implementation:
    keywords: ["rust", "cargo", "tokio", "async/await", "systems programming"]
    agent: "rust-expert"
    confidence: "high"
    example: "Implement async HTTP client in Rust with tokio"

  java_implementation:
    keywords: ["java", "spring", "spring boot", "maven", "gradle", "junit"]
    agent: "java-expert"
    confidence: "high"
    example: "Create Spring Boot REST API with JWT authentication"

  python_implementation:
    keywords: ["python", "django", "flask", "pytest", "pandas"]
    agent: "python-expert"
    confidence: "high"
    example: "Build Flask API with SQLAlchemy ORM"

  typescript_implementation:
    keywords: ["typescript", "react", "next.js", "node.js", "jest"]
    agent: "typescript-expert"
    confidence: "high"
    example: "Create React component with TypeScript and tests"

  csharp_implementation:
    keywords: ["c#", ".net", "asp.net core", "entity framework", "azure"]
    agent: "csharp-expert"
    confidence: "high"
    example: "Build ASP.NET Core API with Entity Framework"

  go_implementation:
    keywords: ["go", "golang", "goroutines", "channels", "grpc"]
    agent: "go-expert"
    confidence: "high"
    example: "Implement gRPC service in Go"
```

**Specialized Domain Tasks:**

```yaml
database_tasks:
  keywords: ["database", "schema", "migration", "query optimization", "sql", "nosql"]
  agent: "database-specialist"
  examples:
    - "Design database schema for e-commerce platform"
    - "Optimize slow SQL queries"
    - "Create database migration scripts"

frontend_tasks:
  keywords: ["frontend", "ui component", "responsive design", "css", "html"]
  agent: "frontend-specialist"
  examples:
    - "Create responsive navigation component"
    - "Implement dark mode toggle"
    - "Build accessible form components"

security_tasks:
  keywords: ["security", "authentication", "authorization", "encryption", "vulnerability"]
  agent: "security-specialist"
  examples:
    - "Implement OAuth2 authentication"
    - "Perform security audit"
    - "Fix SQL injection vulnerability"

uiux_tasks:
  keywords: ["ui/ux", "design system", "accessibility", "user flow", "wireframe"]
  agent: "uiux-specialist"
  examples:
    - "Design user onboarding flow"
    - "Create design system tokens"
    - "Conduct accessibility audit"
```

**Infrastructure & Architecture:**

```yaml
devops_tasks:
  keywords: ["deployment", "ci/cd", "kubernetes", "docker", "terraform"]
  agent: "devops-orchestrator"
  examples:
    - "Set up CI/CD pipeline"
    - "Configure Kubernetes deployment"
    - "Create Terraform infrastructure"

architecture_tasks:
  keywords: ["architecture", "system design", "scalability", "patterns", "microservices"]
  agent: "system-architect"
  examples:
    - "Design microservices architecture"
    - "Create technical specification"
    - "Review system architecture"

analysis_tasks:
  keywords: ["analyze", "investigate", "debug", "profile", "benchmark"]
  agent: "comprehensive-analyst"
  examples:
    - "Analyze performance bottleneck"
    - "Investigate security vulnerability"
    - "Debug production issue"
```

### 2. Multi-Agent Workflows

**Common Workflow Patterns:**

```yaml
feature_development:
  pattern: "product-owner → system-architect → [implementation-expert] → code-review-gatekeeper → technical-docs-writer"

  steps:
    - agent: "product-owner"
      task: "Create user stories with acceptance criteria"
      output: "User stories and business requirements"

    - agent: "system-architect"
      task: "Design technical architecture"
      output: "Architecture diagrams and technical specification"

    - agent: "implementation-expert"
      task: "Implement feature with tests"
      output: "Working code with comprehensive tests"
      note: "Choose appropriate expert: rust-expert, java-expert, etc."

    - agent: "code-review-gatekeeper"
      task: "Review code quality and test coverage"
      output: "Quality validation and approval"

    - agent: "technical-docs-writer"
      task: "Create API and user documentation"
      output: "Comprehensive documentation"

  example: "Build new payment processing feature"

security_implementation:
  pattern: "security-specialist → [implementation-expert] → security-specialist → code-review-gatekeeper"

  steps:
    - agent: "security-specialist"
      task: "Define security requirements and threat model"
      output: "Security specification"

    - agent: "implementation-expert"
      task: "Implement security controls"
      output: "Secure implementation"

    - agent: "security-specialist"
      task: "Security audit and penetration testing"
      output: "Security validation"

    - agent: "code-review-gatekeeper"
      task: "Final quality gates"
      output: "Deployment approval"

  example: "Implement OAuth2 authentication with JWT"

performance_optimization:
  pattern: "comprehensive-analyst → [implementation-expert] → comprehensive-analyst"

  steps:
    - agent: "comprehensive-analyst"
      task: "Profile and identify bottlenecks"
      output: "Performance analysis report"

    - agent: "implementation-expert"
      task: "Implement optimizations"
      output: "Optimized code"

    - agent: "comprehensive-analyst"
      task: "Validate performance improvements"
      output: "Performance comparison"

  example: "Optimize database query performance"

full_stack_feature:
  pattern: "system-architect → database-specialist → backend-expert → frontend-specialist → uiux-specialist → code-review-gatekeeper"

  steps:
    - agent: "system-architect"
      task: "Design overall architecture"

    - agent: "database-specialist"
      task: "Design database schema and migrations"

    - agent: "backend-expert"
      task: "Implement API endpoints"
      note: "Choose: rust-expert, java-expert, python-expert, etc."

    - agent: "frontend-specialist"
      task: "Implement UI components"

    - agent: "uiux-specialist"
      task: "Validate user experience and accessibility"

    - agent: "code-review-gatekeeper"
      task: "Final quality validation"

  example: "Build user dashboard with analytics"
```

## Decision Tree

```yaml
routing_decision_tree:
  question_1: "Is this a single-language implementation task?"
  yes:
    question: "Which language?"
    rust: "rust-expert"
    java: "java-expert"
    python: "python-expert"
    typescript: "typescript-expert"
    csharp: "csharp-expert"
    go: "go-expert"
    bash: "bash-expert"
    powershell: "powershell-expert"

  no:
    question_2: "Is this primarily a domain-specific task?"
    yes:
      database: "database-specialist"
      frontend: "frontend-specialist"
      security: "security-specialist"
      uiux: "uiux-specialist"
      devops: "devops-orchestrator"
      architecture: "system-architect"
      analysis: "comprehensive-analyst"
      documentation: "technical-docs-writer"
      requirements: "product-owner"

    no:
      question_3: "Does it span multiple domains?"
      yes: "Use multi-agent workflow"
      no: "Use comprehensive-analyst for general tasks"
```

## Recommendation Engine

### Input Analysis

```typescript
interface TaskAnalysis {
  description: string;
  keywords: string[];
  complexity: "simple" | "moderate" | "complex";
  domains: string[];
  technologies: string[];
  deliverables: string[];
}

function analyzeTask(task: string): TaskAnalysis {
  // Extract keywords
  const keywords = extractKeywords(task);

  // Identify domains
  const domains = identifyDomains(keywords);

  // Detect technologies
  const technologies = detectTechnologies(keywords);

  // Assess complexity
  const complexity = assessComplexity(domains, technologies);

  return {
    description: task,
    keywords,
    complexity,
    domains,
    technologies,
    deliverables: extractDeliverables(task)
  };
}
```

### Routing Recommendations

```typescript
interface RoutingRecommendation {
  confidence: "high" | "medium" | "low";
  primary_agent: string;
  supporting_agents?: string[];
  workflow_type: "single-agent" | "multi-agent" | "sequential" | "parallel";
  delegation_template: string;
  estimated_complexity: string;
  quality_gates: string[];
}

function recommendRouting(analysis: TaskAnalysis): RoutingRecommendation {
  if (analysis.domains.length === 1) {
    return singleAgentRecommendation(analysis);
  } else {
    return multiAgentRecommendation(analysis);
  }
}
```

## Delegation Templates

### Template 1: Simple Implementation

```markdown
Task: Implement [feature] in [language]
Agent: [language-expert]

Delegation:
"Implement [feature description] with the following requirements:
- [Requirement 1]
- [Requirement 2]
- Comprehensive tests (80%+ coverage)
- Documentation

Success Criteria:
- Code compiles without errors
- All tests pass
- Meets coding standards
- Documented"
```

### Template 2: Multi-Agent Feature

```markdown
Task: Build [feature] spanning [domains]
Workflow: Sequential multi-agent

Phase 1 - Requirements & Architecture:
  Agent: system-architect
  Task: "Design architecture for [feature] considering [constraints]"
  Deliverable: Technical specification

Phase 2 - Implementation:
  Agent: [implementation-expert]
  Task: "Implement [feature] according to specification"
  Deliverable: Working code with tests

Phase 3 - Validation:
  Agent: code-review-gatekeeper
  Task: "Validate quality, test coverage, and standards compliance"
  Deliverable: Quality approval

Success Criteria: All phases complete with quality gates passed
```

### Template 3: Security-Critical Task

```markdown
Task: [Security-sensitive feature]
Workflow: Security-focused multi-agent

Phase 1 - Security Design:
  Agent: security-specialist
  Task: "Define security requirements and threat model for [feature]"
  Deliverable: Security specification

Phase 2 - Secure Implementation:
  Agent: [implementation-expert]
  Task: "Implement [feature] following security specification"
  Deliverable: Secure implementation

Phase 3 - Security Audit:
  Agent: security-specialist
  Task: "Perform security audit and penetration testing"
  Deliverable: Security validation

Phase 4 - Final Review:
  Agent: code-review-gatekeeper
  Task: "Final quality and security gates"
  Deliverable: Deployment approval
```

## Usage Examples

### Example 1: Simple Task

```bash
User: "I need to create a REST API in Rust"

Agent Routing Advisor Response:
📊 Task Analysis:
  - Language: Rust
  - Domain: Backend API
  - Complexity: Moderate

🎯 Recommendation:
  - Primary Agent: rust-expert
  - Confidence: HIGH
  - Workflow: Single-agent

📝 Delegation Template:
"/delegate to rust-expert: Implement REST API with the following:
- HTTP server using tokio/axum
- CRUD endpoints for [resources]
- Request validation
- Error handling
- Comprehensive tests (80%+ coverage)
- API documentation"

✅ Quality Gates:
- Compilation (cargo build)
- Linting (cargo clippy)
- Tests (cargo test)
- Coverage (cargo tarpaulin)
```

### Example 2: Complex Multi-Domain Task

```bash
User: "Build a user authentication system with database, API, and frontend"

Agent Routing Advisor Response:
📊 Task Analysis:
  - Domains: Database, Backend, Frontend, Security
  - Technologies: Multiple
  - Complexity: Complex

🎯 Recommendation:
  - Workflow: Multi-agent sequential
  - Confidence: HIGH

📋 Recommended Workflow:

Phase 1 - Security & Architecture:
  Agent: security-specialist
  Task: "Define authentication security requirements:
    - Password policy
    - Session management
    - Token strategy
    - Threat model"

Phase 2 - Database Design:
  Agent: database-specialist
  Task: "Design user authentication schema:
    - Users table
    - Sessions table
    - Permissions/roles
    - Migrations"

Phase 3 - Backend Implementation:
  Agent: [Choose: rust-expert, java-expert, python-expert, typescript-expert]
  Task: "Implement authentication API:
    - Login/logout endpoints
    - Password hashing (bcrypt)
    - JWT token generation
    - Session management
    - Tests"

Phase 4 - Frontend Implementation:
  Agent: frontend-specialist
  Task: "Implement authentication UI:
    - Login form
    - Registration form
    - Password reset
    - Session handling
    - Responsive design"

Phase 5 - Security Validation:
  Agent: security-specialist
  Task: "Security audit:
    - Penetration testing
    - Vulnerability scan
    - OWASP Top 10 check"

Phase 6 - Final Review:
  Agent: code-review-gatekeeper
  Task: "Comprehensive quality validation"

⏱️ Estimated Time: 4-6 hours
✅ Quality Gates: Security audit, test coverage, code review
```

### Example 3: Uncertain Task

```bash
User: "Optimize application performance"

Agent Routing Advisor Response:
📊 Task Analysis:
  - Domain: Performance optimization
  - Specificity: LOW (needs clarification)
  - Complexity: Unknown

❓ Clarifying Questions:
  1. What type of performance issue? (Response time, throughput, memory, CPU)
  2. Which component? (Database, API, Frontend, Infrastructure)
  3. Current metrics vs target metrics?

🎯 Preliminary Recommendation:
  - Primary Agent: comprehensive-analyst
  - Supporting Agent: [language-expert based on stack]

📋 Suggested Workflow:

Phase 1 - Performance Analysis:
  Agent: comprehensive-analyst
  Task: "Profile application and identify bottlenecks:
    - Response time analysis
    - Database query performance
    - Memory profiling
    - CPU profiling
    - Generate performance report"

Phase 2 - Optimization Implementation:
  Agent: [language-expert]
  Task: "Implement optimizations based on analysis"

Phase 3 - Validation:
  Agent: comprehensive-analyst
  Task: "Verify performance improvements"

💡 Tip: Provide more specifics for targeted recommendation
```

## Integration

Coordinates with:
- `framework-validator` - Ensures valid agent references
- Quality gates - Suggests appropriate validation hooks
- `delegate` command - Provides delegation syntax

## Output Format

```json
{
  "task_analysis": {
    "description": "Create REST API in Rust",
    "keywords": ["rest", "api", "rust"],
    "complexity": "moderate",
    "domains": ["backend", "rust"],
    "technologies": ["rust", "tokio", "http"]
  },
  "recommendation": {
    "confidence": "high",
    "primary_agent": "rust-expert",
    "workflow_type": "single-agent",
    "delegation_template": "/delegate to rust-expert: ...",
    "estimated_time": "2-3 hours",
    "quality_gates": ["compilation", "linting", "tests", "coverage"]
  },
  "alternatives": [
    {
      "agent": "comprehensive-analyst",
      "when": "If requirements are unclear",
      "confidence": "medium"
    }
  ]
}
```
