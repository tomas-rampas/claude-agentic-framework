---
description: Task Routing Engine - Route development tasks to specialized implementation agents
category: workflow
argument-hint: describing the development task or goal to achieve through specialized agent execution
---

# Development Task Router v3.0

This command routes development tasks to specialized implementation agents for direct execution.

## 🎯 AGENT EXECUTION CONTEXT

**IMPORTANT**: Delegated agents have FULL TOOL ACCESS and execute tasks directly within their domains of expertise.

**Agent Context**: When agents receive tasks through this router, they operate in implementation mode with unrestricted access to all necessary tools and capabilities.

---

## 🤖 AVAILABLE IMPLEMENTATION AGENTS

### 📋 PLANNING & REQUIREMENTS
| Agent | Implementation Domain | Direct Capabilities |
|-------|---------------------|-------------------|
| **product-owner** | Product Management | Creates requirements, user stories, acceptance criteria, business specifications |

### 🏗️ ARCHITECTURE & ANALYSIS
| Agent | Implementation Domain | Direct Capabilities |
|-------|---------------------|-------------------|
| **system-architect** | System Design | Creates architecture documents, technical specifications, system designs |
| **comprehensive-analyst** | Deep Analysis | Performs investigations, profiling, security audits, technical research |

### 💻 DEVELOPMENT & QUALITY
| Agent | Implementation Domain | Direct Capabilities |
|-------|---------------------|-------------------|
| **rust-systems-expert** | Rust Development | Writes Rust code, creates modules, implements features, optimizes performance |
| **code-review-gatekeeper** | Quality Assurance | Reviews code, validates quality, enforces standards, runs tests |

### 🚀 INFRASTRUCTURE & DOCS
| Agent | Implementation Domain | Direct Capabilities |
|-------|---------------------|-------------------|
| **devops-orchestrator** | Infrastructure | Creates CI/CD, deployment configs, monitoring, infrastructure automation |
| **technical-docs-writer** | Documentation | Writes technical docs, API documentation, user guides, tutorials |

---

## 🔍 TASK ROUTING MATRIX

### Requirements & Planning
```yaml
"requirements|user.*stories|business.*logic|acceptance.*criteria|feature.*spec":
  → product-owner
  TASK: "Create {deliverable_type} for {feature_name} with detailed specifications and acceptance criteria"
```

### Architecture & Design
```yaml
"architecture|system.*design|technical.*design|database.*schema|api.*specification":
  → system-architect
  TASK: "Design {system_component} architecture for {feature_name} with technical specifications"
```

### Analysis & Investigation
```yaml
"analyze|investigate|profile|diagnose|audit|benchmark|research":
  → comprehensive-analyst
  TASK: "Analyze {target_system} and provide detailed findings with actionable recommendations"
```

### Rust Implementation
```yaml
"rust|implement|develop|create.*code|build.*feature|write.*module":
  → rust-systems-expert
  TASK: "Implement {feature_description} with complete Rust code and comprehensive tests"
```

### Quality & Review
```yaml
"review|validate|test.*coverage|quality.*check|code.*analysis":
  → code-review-gatekeeper
  TASK: "Review {target_code} and ensure quality standards with detailed validation report"
```

### Infrastructure & Deployment
```yaml
"deploy|infrastructure|ci.*cd|pipeline|container|monitoring|devops":
  → devops-orchestrator
  TASK: "Create {infrastructure_component} with complete automation and monitoring setup"
```

### Documentation
```yaml
"document|readme|guide|manual|api.*docs|wiki":
  → technical-docs-writer
  TASK: "Create comprehensive {doc_type} with examples and integration instructions"
```

---

## 📁 PROJECT STRUCTURE DETECTION

### Auto-Detected Variables
```yaml
PROJECT_CONTEXT:
  {project_root}: Detected project root directory
  {source_dir}: Source code directory (src/, lib/, app/)
  {test_dir}: Test directory (tests/, test/, spec/)
  {docs_dir}: Documentation directory (docs/, README location)
  {config_dir}: Configuration directory (config/, settings/)
  {deploy_dir}: Deployment configs (deploy/, k8s/, docker/)

TECHNOLOGY_CONTEXT:
  {tech_stack}: Primary technology (rust, javascript, python, java)
  {framework}: Detected framework (axum, react, fastapi, spring)
  {package_manager}: Package manager (cargo, npm, pip, maven)
  {test_framework}: Testing framework (cargo-test, jest, pytest)
```

### Technology Detection Patterns
```yaml
Rust Projects:
  Files: "*.rs", "Cargo.toml", "Cargo.lock"
  Keywords: "rust", "cargo", "async", "tokio"
  Source: "src/"
  Tests: "tests/"

JavaScript/TypeScript:
  Files: "*.js", "*.ts", "package.json"
  Keywords: "javascript", "typescript", "node", "react"
  Source: "src/"
  Tests: "__tests__/", "test/"

Python:
  Files: "*.py", "requirements.txt", "pyproject.toml"
  Keywords: "python", "django", "fastapi", "flask"
  Source: "src/", "lib/"
  Tests: "tests/"
```

---

## 🎯 TASK TRANSFORMATION PATTERNS

### Concrete Implementation Directives
Transform vague requests into specific implementation tasks:

**Vague**: "Implement authentication"
**Concrete**: "Create authentication module in src/auth.rs with JWT token handling, user validation, and comprehensive tests in tests/auth_tests.rs"

**Vague**: "Add Protocol Buffer support"
**Concrete**: "Create Protocol Buffer definitions in proto/messages.proto and implement Rust bindings in src/proto.rs with serialization benchmarks"

**Vague**: "Improve performance"
**Concrete**: "Profile existing code in src/core.rs and implement specific optimizations with before/after benchmarks in benches/performance.rs"

### Specific File and Path Instructions
Always provide exact file paths and implementation details:
- Source file locations: "Create in src/modules/feature.rs"
- Test file locations: "Add tests to tests/integration/feature_test.rs"
- Configuration files: "Update config/settings.toml with new parameters"
- Documentation files: "Document in docs/api/feature.md with examples"

---

## 📋 TASK EXECUTION TEMPLATES

### Implementation Task Template
```yaml
AGENT: {detected_tech_stack}-expert
TASK: "Implement {specific_feature} by:
1. Creating {exact_file_path} with {specific_functionality}
2. Adding comprehensive tests in {test_file_path}
3. Including error handling and validation
4. Documenting public APIs with examples
5. Adding benchmarks if performance-critical"
```

### Analysis Task Template
```yaml
AGENT: comprehensive-analyst
TASK: "Analyze {specific_target} by:
1. Examining {file_paths_or_components}
2. Identifying {specific_analysis_goals}
3. Measuring {specific_metrics}
4. Creating detailed report in {report_location}
5. Providing actionable recommendations"
```

### Quality Task Template
```yaml
AGENT: code-review-gatekeeper
TASK: "Review {specific_code_location} by:
1. Validating code quality and standards
2. Checking test coverage and effectiveness
3. Verifying security and safety practices
4. Ensuring documentation completeness
5. Creating quality report with specific findings"
```

---

## 🚀 EXECUTION GUIDELINES

### Task Specificity Requirements
- Provide exact file paths and locations
- Specify concrete deliverables and outcomes
- Include testing and validation requirements
- Detail integration and documentation needs

### Agent Empowerment
- Agents have full tool access for their domains
- Agents execute tasks directly without further delegation
- Agents create, modify, and test code as needed
- Agents make implementation decisions within their expertise

### Quality Integration
- All implementation includes comprehensive testing
- Code review validation is mandatory before completion
- Documentation is created alongside implementation
- Performance validation for critical components

---

This router transforms development requests into concrete implementation tasks executed directly by specialized agents with full tool access and implementation authority.