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

### 💻 LANGUAGE-SPECIFIC DEVELOPMENT
| Agent | Implementation Domain | Direct Capabilities |
|-------|---------------------|-------------------|
| **rust-expert** | Rust Systems Programming | Writes Rust code, high-performance apps, CLI tools, async systems, ownership/lifetime optimization |
| **csharp-expert** | C#/.NET Development | Writes C# code, ASP.NET Core services, Entity Framework integrations, Azure solutions, WPF/MAUI apps |
| **go-expert** | Go Development | Writes Go code, microservices, gRPC services, cloud-native apps, Kubernetes operators, concurrent systems |
| **java-expert** | Java/Spring Boot | Writes Java code, Spring Boot microservices, enterprise applications, Android apps, JVM optimization |
| **python-expert** | Python Development | Writes Python code, web frameworks (Django/FastAPI/Flask), data pipelines, ML/AI apps, async systems |
| **typescript-expert** | TypeScript/JavaScript | Writes TypeScript/JS code, React/Next.js frontends, Node.js backends, npm packages, type-safe systems |

### 🔧 SCRIPTING & AUTOMATION
| Agent | Implementation Domain | Direct Capabilities |
|-------|---------------------|-------------------|
| **bash-expert** | Bash/Shell Scripting | Writes shell scripts, Linux automation, build scripts, deployment pipelines, Unix system administration |
| **powershell-expert** | PowerShell Automation | Writes automation scripts, Windows administration, Azure/AWS cloud scripts, DSC configurations |

### 🎨 UI/UX & FRONTEND
| Agent | Implementation Domain | Direct Capabilities |
|-------|---------------------|-------------------|
| **frontend-specialist** | Frontend Development | Creates React/Vue/Angular components, responsive UI, state management, routing, performance optimization |
| **uiux-specialist** | UI/UX Design | Designs responsive interfaces, design systems, WCAG accessibility, user flows, prototypes |

### 🔒 SPECIALIZED DOMAINS
| Agent | Implementation Domain | Direct Capabilities |
|-------|---------------------|-------------------|
| **database-specialist** | Database Engineering | Designs database schemas, query optimization, SQL/NoSQL solutions, data migrations, indexing strategies |
| **security-specialist** | Security Engineering | Conducts security audits, OWASP assessments, implements OAuth2/JWT/SAML, threat modeling, compliance |
| **devops-orchestrator** | Infrastructure/DevOps | Creates CI/CD pipelines, Docker/Kubernetes configs, Terraform IaC, monitoring, cloud automation |

### 🏗️ ARCHITECTURE & ANALYSIS
| Agent | Implementation Domain | Direct Capabilities |
|-------|---------------------|-------------------|
| **system-architect** | System Architecture | Creates architecture documents, technical specifications, scalable system designs, technology evaluation |
| **comprehensive-analyst** | Deep Analysis | Performs investigations, profiling, risk assessment, technical research, completeness evaluation |
| **code-review-gatekeeper** | Quality Assurance | Reviews code, validates quality, enforces standards, runs tests, security validation |

### 📋 DOCUMENTATION & PLANNING
| Agent | Implementation Domain | Direct Capabilities |
|-------|---------------------|-------------------|
| **technical-docs-writer** | Technical Documentation | Writes technical docs, API documentation, user guides, README files, developer guides |
| **product-owner** | Product Management | Creates requirements, user stories, acceptance criteria, PRDs, backlog management, sprint planning |

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

### Language-Specific Implementation
```yaml
"rust":
  → rust-expert
  TASK: "Implement {feature_description} with complete Rust code and comprehensive tests"

"c#|csharp|\.net|dotnet|asp\.net":
  → csharp-expert
  TASK: "Implement {feature_description} with complete C# code and comprehensive tests"

"go|golang|goroutine|channel":
  → go-expert
  TASK: "Implement {feature_description} with complete Go code and comprehensive tests"

"java|spring.*boot|maven|gradle|jvm":
  → java-expert
  TASK: "Implement {feature_description} with complete Java code and comprehensive JUnit tests"

"python|py|django|flask|fastapi|pandas|asyncio":
  → python-expert
  TASK: "Implement {feature_description} with complete Python code and comprehensive pytest tests"

"typescript|ts|javascript|js|react|next\.js|node\.js|express":
  → typescript-expert
  TASK: "Implement {feature_description} with complete TypeScript code and comprehensive Jest/Vitest tests"

"powershell|ps1|automation|windows.*admin":
  → powershell-expert
  TASK: "Implement {automation_description} with complete PowerShell script and Pester tests"

"bash|shell|sh|linux.*automation|unix.*script":
  → bash-expert
  TASK: "Implement {automation_description} with complete Bash script and bats/shunit2 tests"

"implement|develop|create.*code|build.*feature|write.*module":
  → {language}-expert (auto-detect from project context)
  TASK: "Implement {feature_description} with complete code and comprehensive tests"
```

### Frontend & UI Development
```yaml
"frontend|ui.*component|react.*component|vue.*component|angular":
  → frontend-specialist
  TASK: "Create {component_description} with responsive design, state management, and comprehensive tests"

"ui.*design|ux.*design|user.*flow|accessibility|wcag|design.*system":
  → uiux-specialist
  TASK: "Design {interface_description} with accessibility compliance, responsive patterns, and user flow documentation"
```

### Database & Data
```yaml
"database|schema|query.*optimization|sql|nosql|migration|index":
  → database-specialist
  TASK: "Design {database_component} with optimized schema, indexes, and migration scripts"
```

### Security
```yaml
"security|vulnerability|audit|oauth|jwt|authentication|authorization|compliance":
  → security-specialist
  TASK: "Implement {security_component} with best practices, threat modeling, and comprehensive security tests"
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
  {tech_stack}: Primary technology (rust, csharp, go, java, python, typescript, javascript, powershell, bash)
  {framework}: Detected framework (axum, asp.net-core, gin/echo/fiber, spring-boot, django/fastapi/flask, react/next.js, azure-functions, systemd)
  {package_manager}: Package manager (cargo, dotnet, go-modules, maven/gradle, pip, npm, powershell-gallery, apt/yum)
  {test_framework}: Testing framework (cargo-test, xunit, go-test, junit, pytest, jest/vitest, pester, bats/shunit2)
```

### Technology Detection Patterns
```yaml
Rust Projects:
  Files: "*.rs", "Cargo.toml", "Cargo.lock"
  Keywords: "rust", "cargo", "async", "tokio"
  Source: "src/"
  Tests: "tests/"
  Agent: rust-expert

C#/.NET Projects:
  Files: "*.cs", "*.csproj", "*.sln", "*.cshtml"
  Keywords: "csharp", "c#", "dotnet", ".net", "asp.net", "entity framework"
  Source: "src/", "Controllers/", "Services/"
  Tests: "tests/", "*.Tests/"
  Agent: csharp-expert

Go Projects:
  Files: "*.go", "go.mod", "go.sum"
  Keywords: "go", "golang", "goroutine", "channel", "grpc", "kubernetes"
  Source: "cmd/", "internal/", "pkg/"
  Tests: "*_test.go"
  Agent: go-expert

PowerShell Projects:
  Files: "*.ps1", "*.psm1", "*.psd1", "*.ps1xml"
  Keywords: "powershell", "automation", "azure", "active directory", "dsc"
  Source: "Scripts/", "Modules/", "Functions/"
  Tests: "Tests/", "*.Tests.ps1"
  Agent: powershell-expert

Bash/Shell Projects:
  Files: "*.sh", "*.bash", "Makefile", "*.bats"
  Keywords: "bash", "shell", "linux", "unix", "automation", "deployment"
  Source: "scripts/", "bin/", "tools/"
  Tests: "test/", "tests/", "*.bats"
  Agent: bash-expert

TypeScript/JavaScript:
  Files: "*.ts", "*.tsx", "*.js", "*.jsx", "package.json", "tsconfig.json"
  Keywords: "typescript", "javascript", "node", "react", "next.js", "express"
  Source: "src/", "app/", "lib/"
  Tests: "__tests__/", "test/", "*.test.ts", "*.spec.ts"
  Agent: typescript-expert

Python:
  Files: "*.py", "requirements.txt", "pyproject.toml", "setup.py"
  Keywords: "python", "django", "fastapi", "flask", "pandas", "pytest"
  Source: "src/", "lib/", "app/"
  Tests: "tests/", "test/"
  Agent: python-expert

Java:
  Files: "*.java", "pom.xml", "build.gradle", "settings.gradle"
  Keywords: "java", "spring", "spring boot", "maven", "gradle", "junit"
  Source: "src/main/java/", "app/src/main/"
  Tests: "src/test/java/", "app/src/test/"
  Agent: java-expert
```

---

## 🎯 TASK TRANSFORMATION PATTERNS

### Concrete Implementation Directives
Transform vague requests into specific implementation tasks:

**Vague**: "Implement authentication"
**Concrete (Rust)**: "Create authentication module in src/auth.rs with JWT token handling, user validation, and comprehensive tests in tests/auth_tests.rs"
**Concrete (C#)**: "Create authentication module in src/Auth/AuthService.cs with JWT token handling, ASP.NET Core identity integration, and comprehensive tests in tests/Auth.Tests/AuthServiceTests.cs"
**Concrete (Go)**: "Create authentication package in internal/auth/auth.go with JWT token handling using golang-jwt, context-based middleware, and table-driven tests in auth_test.go"
**Concrete (Java)**: "Create authentication service in src/main/java/com/app/auth/AuthService.java with JWT token handling using java-jwt, Spring Security integration, and comprehensive JUnit 5 tests in src/test/java/com/app/auth/AuthServiceTest.java"
**Concrete (Python)**: "Create authentication module in src/auth/auth.py with JWT token handling using PyJWT, FastAPI dependency injection, type hints, and comprehensive pytest tests in tests/test_auth.py"
**Concrete (TypeScript)**: "Create authentication module in src/auth/auth.ts with JWT token handling, type-safe middleware, proper error types, and comprehensive Jest tests in src/auth/auth.test.ts"
**Concrete (PowerShell)**: "Create authentication module in Modules/Authentication/Authenticate-User.ps1 with Azure AD integration, secure credential handling, and Pester tests in Tests/Authentication.Tests.ps1"
**Concrete (Bash)**: "Create authentication script in scripts/auth/authenticate.sh with PAM integration, secure credential handling with gpg, and bats tests in tests/auth.bats"

**Vague**: "Add Protocol Buffer support"
**Concrete (Rust)**: "Create Protocol Buffer definitions in proto/messages.proto and implement Rust bindings in src/proto.rs with serialization benchmarks"
**Concrete (C#)**: "Create Protocol Buffer definitions in proto/messages.proto and implement C# bindings in src/Proto/Messages.cs with serialization benchmarks"
**Concrete (Go)**: "Create Protocol Buffer definitions in proto/messages.proto and implement Go bindings in internal/proto/messages.pb.go with gRPC service definitions and benchmarks"

**Vague**: "Improve performance"
**Concrete (Rust)**: "Profile existing code in src/core.rs and implement specific optimizations with before/after benchmarks in benches/performance.rs"
**Concrete (C#)**: "Profile existing code in src/Core/Engine.cs using BenchmarkDotNet and implement specific optimizations with before/after benchmarks"
**Concrete (Go)**: "Profile existing code in internal/processor/processor.go using pprof (CPU, memory, goroutine) and implement optimizations with worker pools, sync.Pool, and benchmarks"
**Concrete (Python)**: "Profile existing code in src/processor.py using cProfile/line_profiler and implement optimizations with NumPy vectorization, appropriate data structures, and pytest benchmarks"
**Concrete (TypeScript)**: "Profile existing code in src/processor.ts using Chrome DevTools/clinic.js and implement optimizations with proper type narrowing, memoization, and Jest benchmarks"
**Concrete (PowerShell)**: "Profile existing script in Scripts/Process-Data.ps1 using Measure-Command and implement optimizations with ForEach-Object -Parallel and runspaces"

**Vague**: "Automate deployment"
**Concrete (PowerShell)**: "Create deployment automation script in Scripts/Deploy-Application.ps1 with Azure resource provisioning, environment validation, rollback capabilities, and comprehensive logging"
**Concrete (Bash)**: "Create deployment automation script in scripts/deploy.sh with set -euo pipefail, trap cleanup, environment validation, rollback capabilities, and comprehensive logging to /var/log/deploy.log"

**Vague**: "Build automation"
**Concrete (Bash)**: "Create build script in scripts/build.sh with dependency checking, parallel compilation, error handling with trap, build artifact validation, and integration with CI/CD pipelines"

**Vague**: "Create microservice"
**Concrete (Go)**: "Create microservice in cmd/service/main.go with HTTP/gRPC endpoints, graceful shutdown with context, health checks, structured logging with slog, and comprehensive tests including integration tests"
**Concrete (Java)**: "Create microservice in src/main/java/com/app/service/ServiceApplication.java with Spring Boot REST endpoints, graceful shutdown, actuator health checks, SLF4J logging, and comprehensive tests including @SpringBootTest integration tests"

**Vague**: "Design database schema"
**Concrete (Database)**: "Design database schema in db/schema.sql with normalized tables, proper indexes, foreign key constraints, migration scripts in db/migrations/, and documentation of relationships and data flows"

**Vague**: "Build UI component"
**Concrete (Frontend)**: "Create reusable UI component in src/components/DataTable/DataTable.tsx with props typing, state management via hooks, responsive design, accessibility attributes, and comprehensive React Testing Library tests"

**Vague**: "Improve security"
**Concrete (Security)**: "Conduct security audit of src/api/ endpoints, identify OWASP Top 10 vulnerabilities, implement input validation, parameterized queries, CSRF protection, and create security assessment report in docs/security/audit.md"

**Vague**: "Improve user experience"
**Concrete (UI/UX)**: "Design user flow for checkout process in designs/checkout-flow.md with wireframes, accessibility considerations (WCAG 2.1 AA), responsive breakpoints, error states, and user testing criteria"

### Specific File and Path Instructions
Always provide exact file paths and implementation details:
- Source file locations: "Create in src/modules/feature.{ext}" (use language-appropriate extension)
- Test file locations: "Add tests to tests/integration/feature_test.{ext}"
- Configuration files: "Update config/settings.{format}" (toml, json, xml based on tech stack)
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
- Agents operate autonomously with full technical authority

### Quality Integration
- All implementation includes comprehensive testing
- Code review validation is mandatory before completion
- Documentation is created alongside implementation
- Performance validation for critical components

---

## 🎯 MULTI-AGENT COORDINATION

For complex tasks requiring multiple domains, orchestrate specialized agents in sequence:

### Standard Workflow Pattern
```yaml
1. system-architect:
   - Designs the solution structure and architecture
   - Defines component boundaries and interfaces
   - Selects appropriate technology stack

2. {language}-expert or {specialist}:
   - Implements their respective components
   - Follows architectural specifications
   - Creates unit and integration tests

3. code-review-gatekeeper:
   - Validates code quality and integration
   - Ensures adherence to standards
   - Verifies test coverage and effectiveness

4. comprehensive-analyst:
   - Evaluates completeness and risks
   - Identifies gaps or potential issues
   - Provides optimization recommendations

5. technical-docs-writer:
   - Documents the final solution
   - Creates API documentation and guides
   - Writes deployment and usage instructions
```

### Cross-Domain Example
```yaml
Feature: "User authentication with database persistence and UI"

1. security-specialist:
   → Design authentication flow with OAuth2/JWT, threat model

2. database-specialist:
   → Design user schema, sessions, secure password storage

3. backend ({language}-expert):
   → Implement authentication API endpoints

4. frontend-specialist:
   → Create login/signup UI components

5. code-review-gatekeeper:
   → Review all components for integration

6. technical-docs-writer:
   → Document authentication setup and usage
```

### Delegation Best Practices
When routing tasks:
- **Select the Right Agent**: Match task domain to agent expertise
- **Provide Clear Context**: Include file paths, requirements, constraints
- **Define Success Criteria**: Specify what "done" looks like
- **Enable Autonomy**: Trust agents to make technical decisions
- **Coordinate Dependencies**: Ensure agents have what they need from previous steps

---

This router transforms development requests into concrete implementation tasks executed directly by specialized agents with full tool access and implementation authority.