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
| **rust-systems-expert** | Rust development, implementation, optimization |
| **system-architect** | System design, architecture, technical specifications |
| **technical-docs-writer** | Documentation, guides, API documentation |
| **product-owner** | Requirements, user stories, project planning |

---

## 🎯 TASK ROUTING GUIDELINES

### Direct Implementation
- **Analysis/investigation** → comprehensive-analyst
- **Code implementation** → appropriate technology expert (rust-systems-expert, etc.)
- **Infrastructure/deployment** → devops-orchestrator
- **System design** → system-architect
- **Documentation** → technical-docs-writer
- **Requirements** → product-owner

### Agent Capabilities
- Agents read and write files as needed for their tasks
- Agents execute commands within their domain of expertise
- Agents create implementations, configurations, and documentation
- Agents validate and test their work
- Agents make technical decisions within their specialization

---

## 🚀 EXECUTION PRINCIPLES

### Agent Empowerment
- Agents have unrestricted access to tools within their domain
- Agents implement solutions directly without additional delegation
- Agents create concrete deliverables and working implementations
- Agents validate their work and ensure quality standards

### Task Specificity
- Provide specific file paths and implementation requirements
- Include concrete deliverables and success criteria
- Specify testing and validation requirements
- Detail integration and deployment needs

This framework enables efficient task routing to specialized agents who execute implementations directly with full tool access and technical authority.