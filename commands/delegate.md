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
| **csharp-expert** | C#/.NET Development | Writes C# code, ASP.NET Core services, Entity Framework integrations, Azure solutions |
| **go-expert** | Go Development | Writes Go code, microservices, gRPC services, Kubernetes operators, concurrent systems |
| **powershell-expert** | PowerShell Automation | Writes automation scripts, system administration tools, Azure/AWS cloud scripts, DSC configurations |
| **bash-expert** | Bash/Shell Scripting | Writes shell scripts, Linux automation, build scripts, deployment pipelines, Unix system administration |
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

### Language-Specific Implementation
```yaml
"rust":
  → rust-systems-expert
  TASK: "Implement {feature_description} with complete Rust code and comprehensive tests"

"c#|csharp|\.net|dotnet|asp\.net":
  → csharp-expert
  TASK: "Implement {feature_description} with complete C# code and comprehensive tests"

"go|golang|goroutine|channel":
  → go-expert
  TASK: "Implement {feature_description} with complete Go code and comprehensive tests"

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
  {tech_stack}: Primary technology (rust, csharp, go, powershell, bash, javascript, python, java)
  {framework}: Detected framework (axum, asp.net-core, gin/echo/fiber, azure-functions, systemd, react, fastapi, spring)
  {package_manager}: Package manager (cargo, dotnet, go-modules, powershell-gallery, apt/yum, npm, pip, maven)
  {test_framework}: Testing framework (cargo-test, xunit, go-test, pester, bats/shunit2, jest, pytest)
```

### Technology Detection Patterns
```yaml
Rust Projects:
  Files: "*.rs", "Cargo.toml", "Cargo.lock"
  Keywords: "rust", "cargo", "async", "tokio"
  Source: "src/"
  Tests: "tests/"
  Agent: rust-systems-expert

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

JavaScript/TypeScript:
  Files: "*.js", "*.ts", "package.json"
  Keywords: "javascript", "typescript", "node", "react"
  Source: "src/"
  Tests: "__tests__/", "test/"
  Agent: javascript-expert (when available)

Python:
  Files: "*.py", "requirements.txt", "pyproject.toml"
  Keywords: "python", "django", "fastapi", "flask"
  Source: "src/", "lib/"
  Tests: "tests/"
  Agent: python-expert (when available)
```

---

## 🎯 TASK TRANSFORMATION PATTERNS

### Concrete Implementation Directives
Transform vague requests into specific implementation tasks:

**Vague**: "Implement authentication"
**Concrete (Rust)**: "Create authentication module in src/auth.rs with JWT token handling, user validation, and comprehensive tests in tests/auth_tests.rs"
**Concrete (C#)**: "Create authentication module in src/Auth/AuthService.cs with JWT token handling, ASP.NET Core identity integration, and comprehensive tests in tests/Auth.Tests/AuthServiceTests.cs"
**Concrete (Go)**: "Create authentication package in internal/auth/auth.go with JWT token handling using golang-jwt, context-based middleware, and table-driven tests in auth_test.go"
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
**Concrete (PowerShell)**: "Profile existing script in Scripts/Process-Data.ps1 using Measure-Command and implement optimizations with ForEach-Object -Parallel and runspaces"

**Vague**: "Automate deployment"
**Concrete (PowerShell)**: "Create deployment automation script in Scripts/Deploy-Application.ps1 with Azure resource provisioning, environment validation, rollback capabilities, and comprehensive logging"
**Concrete (Bash)**: "Create deployment automation script in scripts/deploy.sh with set -euo pipefail, trap cleanup, environment validation, rollback capabilities, and comprehensive logging to /var/log/deploy.log"

**Vague**: "Build automation"
**Concrete (Bash)**: "Create build script in scripts/build.sh with dependency checking, parallel compilation, error handling with trap, build artifact validation, and integration with CI/CD pipelines"

**Vague**: "Create microservice"
**Concrete (Go)**: "Create microservice in cmd/service/main.go with HTTP/gRPC endpoints, graceful shutdown with context, health checks, structured logging with slog, and comprehensive tests including integration tests"

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

### Quality Integration
- All implementation includes comprehensive testing
- Code review validation is mandatory before completion
- Documentation is created alongside implementation
- Performance validation for critical components

---

This router transforms development requests into concrete implementation tasks executed directly by specialized agents with full tool access and implementation authority.