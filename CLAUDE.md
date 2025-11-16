# Claude Code CLI - Agent Execution Framework

## 🎯 AGENT EXECUTION CONTEXT

**IMPORTANT**: This configuration applies to task routing and agent empowerment.

**Specialized agents have FULL TOOL ACCESS and execute tasks directly within their domains of expertise.**

---

## 🤖 AVAILABLE IMPLEMENTATION AGENTS

| Agent | Implementation Domain |
|-------|---------------------|
| **comprehensive-analyst** | Deep analysis, evaluation, and investigation |
| **code-review-gatekeeper** | Code review, quality validation, testing |
| **devops-orchestrator** | Infrastructure, CI/CD, deployment automation |
| **rust-expert** | Rust systems programming, high-performance applications, CLI tools |
| **csharp-expert** | C#/.NET development, ASP.NET Core, Azure solutions |
| **go-expert** | Go development, microservices, cloud-native applications |
| **java-expert** | Java/Spring Boot development, enterprise applications, Android |
| **python-expert** | Python development, web frameworks, data science, automation |
| **typescript-expert** | TypeScript/JavaScript development, React/Next.js, Node.js backends |
| **powershell-expert** | PowerShell automation, Windows administration, cloud scripting |
| **bash-expert** | Bash/shell scripting, Linux automation, Unix system administration |
| **database-specialist** | Database design, schema optimization, query optimization, SQL/NoSQL |
| **frontend-specialist** | Frontend UI development, React/Vue/Angular, responsive design |
| **security-specialist** | Security audits, vulnerability assessment, authentication, compliance |
| **system-architect** | System architecture design, technical decisions, scalability patterns |
| **technical-docs-writer** | Documentation, guides, API documentation, developer guides |
| **uiux-specialist** | UI/UX design, accessibility, design systems, user flows |
| **product-owner** | Requirements, user stories, project planning, backlog management |

---

## 🎯 TASK ROUTING GUIDELINES

### Language-Specific Development
- **Rust development** → rust-expert
- **C#/.NET development** → csharp-expert
- **Go development** → go-expert
- **Java/Spring Boot** → java-expert
- **Python development** → python-expert
- **TypeScript/JavaScript** → typescript-expert

### Scripting & Automation
- **Bash/shell scripting** → bash-expert
- **PowerShell automation** → powershell-expert
- **Infrastructure automation** → devops-orchestrator

### Specialized Domains
- **Database design/optimization** → database-specialist
- **Frontend UI development** → frontend-specialist
- **UI/UX design** → uiux-specialist
- **Security audits** → security-specialist
- **Infrastructure/CI/CD** → devops-orchestrator
- **System architecture** → system-architect

### Analysis & Quality
- **Deep analysis/investigation** → comprehensive-analyst
- **Code review/validation** → code-review-gatekeeper

### Documentation & Planning
- **Technical documentation** → technical-docs-writer
- **Requirements/user stories** → product-owner

### Agent Capabilities
- Agents have FULL TOOL ACCESS within their domain of expertise
- Agents read and write files directly without requesting permission
- Agents execute commands and run tests as needed
- Agents create implementations, configurations, and documentation
- Agents validate and test their work independently
- Agents make technical decisions within their specialization
- Agents can invoke other agents when cross-domain expertise is needed

---

## 🚀 EXECUTION PRINCIPLES

### Agent Empowerment
- Agents have unrestricted access to tools within their domain
- Agents implement solutions directly without additional delegation
- Agents create concrete deliverables and working implementations
- Agents validate their work and ensure quality standards
- Agents operate autonomously with full technical authority

### Orchestration Guidelines
When delegating tasks to specialized agents:

1. **Select the Right Agent**: Choose the agent whose domain best matches the task
2. **Provide Clear Context**: Include specific file paths, requirements, and constraints
3. **Define Success Criteria**: Specify what "done" looks like (tests passing, documentation complete, etc.)
4. **Enable Autonomy**: Trust agents to make technical decisions within their expertise
5. **Coordinate Multi-Agent Tasks**: For cross-domain tasks, orchestrate between multiple agents

### Task Delegation Template
When routing to an agent, provide:
- **Objective**: Clear statement of what needs to be accomplished
- **Context**: Relevant file paths, existing code, dependencies
- **Requirements**: Functional and non-functional requirements
- **Constraints**: Technical limitations, standards to follow
- **Deliverables**: Specific outputs expected (code, tests, documentation)
- **Validation**: How to verify the implementation is correct

### Multi-Agent Coordination
For complex tasks requiring multiple domains:
1. **system-architect** designs the solution structure
2. **Specialized experts** implement their respective components
3. **code-review-gatekeeper** validates quality and integration
4. **comprehensive-analyst** evaluates completeness and risks
5. **technical-docs-writer** documents the final solution

This framework enables efficient task routing to specialized agents who execute implementations directly with full tool access and technical authority.