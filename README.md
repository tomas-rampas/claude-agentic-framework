# Claude Code CLI - Agent Execution Framework

A configuration framework for [Claude Code CLI](https://docs.claude.com/en/docs/claude-code) that adds 20 specialized agents, automated pattern capture, institutional memory, and intelligent task routing.

**This is NOT a standalone tool** — it requires Claude Code CLI as the underlying platform.

---

## Overview

This framework extends Claude Code CLI with:

- **20 Specialized Agents** covering the full development lifecycle
- **45 Quality Gates** with multi-phase validation per agent
- **Self-Learning System** — automated pattern capture, institutional memory, and semantic search
- **MCP Integration** — 5 MCP servers for code intelligence, file ops, documentation, .NET tooling, and shell execution

---

## Prerequisites

| Requirement | Purpose |
|-------------|---------|
| **[Claude Code CLI](https://docs.claude.com/en/docs/claude-code)** | Agent execution platform (required) |
| **Node.js/npm** | Running MCP servers via npx |
| **Git** | Version control |

### Install Claude Code CLI

```bash
# macOS
brew install --cask claude-code

# Linux / WSL
curl -fsSL https://anthropic.com/install-claude.sh | sh

# Verify
claude --version
```

### Configure MCP Servers

Create or update the project-level `.mcp.json` (or `~/.claude/mcp.json`):

```json
{
  "mcpServers": {
    "serena": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-serena"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/your-username"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-context7"]
    },
    "dotnet": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-dotnet"]
    },
    "bash": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-bash"]
    }
  }
}
```

Replace `/home/your-username` with the directory you want the filesystem server scoped to.

| MCP Server | Purpose |
|------------|---------|
| **serena** | Semantic code intelligence, symbol operations + institutional memory |
| **filesystem** | Enhanced file operations for large files and atomic updates |
| **context7** | External documentation and best practices |
| **dotnet** | .NET/C# build, test, and project tooling |
| **bash** | Shell command execution for automation tasks |

---

## Installation

```bash
# Clone into Claude Code CLI config directory
git clone <your-framework-repo> ~/.claude
cd ~/.claude

# Validate framework integrity
./scripts/validate-framework.sh
```

---

## Quick Start

```bash
# Start Claude Code CLI
claude

# Or start with a specific task
claude "Create a REST API in Rust with JWT authentication"
```

Tasks are automatically routed to the appropriate agent. Examples:

```
"Create user stories for authentication feature"        → product-owner
"Design microservices architecture"                      → system-architect
"Implement JWT authentication in Rust"                   → rust-expert
"Create ASP.NET Core REST API with Entity Framework"     → csharp-expert
"Build gRPC microservice in Go"                          → go-expert
"Build a Fisher Transform indicator for MetaTrader 5"    → mql-trading-dev
"Review pull request for code quality"                   → code-review-gatekeeper
"Set up Kubernetes deployment with Helm"                 → devops-orchestrator
"Write API documentation for REST endpoints"             → technical-docs-writer
"Analyze codebase security vulnerabilities"              → comprehensive-analyst
```

---

## Agents

### Planning & Requirements
| Agent | Focus |
|-------|-------|
| **product-owner** | User stories, backlog management, acceptance criteria |

### Architecture & Analysis
| Agent | Focus |
|-------|-------|
| **system-architect** | System design, technology selection, SOLID principles |
| **comprehensive-analyst** | Security audits, performance profiling, investigation |
| **code-review-gatekeeper** | Code review, quality gates, standards compliance |
| **peer-review-critic** | Final independent peer review — diff-scoped gatekeeper (branch vs base) |

### Language Experts
| Agent | Focus |
|-------|-------|
| **rust-expert** | Systems programming, memory safety, async/await |
| **csharp-expert** | ASP.NET Core, Entity Framework, Azure |
| **go-expert** | Microservices, gRPC, Kubernetes operators |
| **java-expert** | Spring Boot, Maven/Gradle, enterprise apps |
| **python-expert** | Django/Flask, data science, automation |
| **typescript-expert** | React/Next.js, Node.js, frontend/backend |
| **mql-trading-dev** | MQL4/MQL5, C/C++ DLLs, MetaTrader trading systems |

### Scripting & Automation
| Agent | Focus |
|-------|-------|
| **bash-expert** | Shell scripting, Linux automation, CLI tools |
| **powershell-expert** | Windows administration, Azure/AWS automation |

### Specialized Domains
| Agent | Focus |
|-------|-------|
| **database-specialist** | Schema design, query optimization, SQL/NoSQL |
| **frontend-specialist** | React/Vue/Angular, responsive design, accessibility |
| **security-specialist** | Vulnerability assessment, compliance, auth |
| **uiux-specialist** | User flows, design systems, wireframing |

### Infrastructure & Documentation
| Agent | Focus |
|-------|-------|
| **devops-orchestrator** | CI/CD, containers, cloud deployment, monitoring |
| **technical-docs-writer** | API docs, user guides, architecture docs |

---

## Project Structure

```
~/.claude/
├── CLAUDE.md                # Agent execution rules and task routing
├── claude.json              # Agent configuration (v3.0.0)
├── .mcp.json                # MCP server definitions (serena, filesystem, context7, dotnet, bash)
├── agents/                  # 20 agent definitions (.md with YAML frontmatter)
├── commands/                # 6 commands (delegate, analyze-framework, list-agents, etc.)
├── hooks/                   # 45 quality gates (agent-specific + framework-wide)
├── shared/                  # Shared configs (base-config, mcp-config, agent-patterns, memory-categories)
├── skills/                  # 14 operational skills (validation, debugging, analytics, scaffolding)
├── scripts/                 # Validation, anti-drift consistency, and doc-generation scripts
├── tests/                   # Consistency test harness
├── .github/workflows/       # CI (anti-drift consistency gate)
└── security-check.sh        # Security validation
```

---

## Management Commands

| Command | Purpose |
|---------|---------|
| `/delegate` | Intelligent task routing to specialized agents |
| `/analyze-framework` | Framework health checking and validation |
| `/list-agents` | Agent catalog with filtering and multiple output formats |
| `/validate-hooks` | Hook coverage and consistency verification |
| `/agent-status` | Real-time agent monitoring and performance metrics |
| `/quality-report` | Quality metrics, trend analysis, and reporting |

---

## Skills

The framework ships 14 operational skills in `skills/` that support validation, debugging, and analytics:

| Skill | Purpose |
|-------|---------|
| **framework-validator** | Comprehensive framework health, consistency, and integrity checks |
| **config-validator** | Validate framework configuration files for correctness |
| **dependency-checker** | Check framework dependencies and tool requirements |
| **agent-debugger** | Debug agent routing, execution, and integration issues |
| **agent-routing-advisor** | Intelligent task-to-agent mapping recommendations |
| **hook-auditor** | Audit hook coverage, consistency, and effectiveness |
| **hook-config-generator** | Generate new validation hooks from templates |
| **code-scaffolder** | Generate idiomatic project scaffolding for supported languages |
| **refactoring-advisor** | Identify refactoring opportunities and improvement patterns |
| **git-workflow-assistant** | Guide branching, commit conventions, and PR workflows |
| **migration-assistant** | Assist with framework version migrations |
| **performance-analytics** | Analyze agent and hook performance metrics |
| **quality-reporter** | Generate quality metrics reports and trend analysis |
| **workflow-visualizer** | Visualize multi-agent workflows and coordination patterns |

---

## Self-Learning System

The framework learns from every interaction through 8 memory categories:

- **Workflow Patterns** — successful agent combinations and sequences
- **Solution Patterns** — proven solutions for common problems
- **Optimization Insights** — performance improvements and efficiency gains
- **Lessons Learned** — knowledge from successes and failures
- **Code Patterns** — reusable architectural and implementation patterns
- **Project Context** — project-specific standards and decisions
- **Quality Insights** — quality-related discoveries and improvements
- **Integration Knowledge** — system integrations and API knowledge

Pattern capture, lesson extraction, and optimization tracking are handled automatically via hooks in the `hooks/` directory.

---

## Troubleshooting

**Claude Code CLI not found:**
```bash
which claude  # If missing, reinstall per the Prerequisites section
```

**MCP servers not available:**
```bash
cat ~/.claude/.mcp.json          # Check configuration
npx -y @modelcontextprotocol/server-serena --version  # Test server
```

**Agents not found:**
```bash
ls -1 agents/*.md | wc -l  # Should show 20
./scripts/validate-agents.sh
```

**Delegation not working:**
```bash
cat commands/delegate.md | head -20  # Verify command exists
```

---

## Contributing

To add or modify agents, manage framework consistency, or understand the anti-drift validation system, see [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Resources

- [Claude Code CLI Documentation](https://docs.claude.com/en/docs/claude-code)
- [Getting Started Guide](https://docs.claude.com/en/docs/claude-code/getting-started)
- [Configuration Reference](https://docs.claude.com/en/docs/claude-code/configuration)
- [MCP Integration Guide](https://docs.claude.com/en/docs/claude-code/mcp)

---

**Built for Claude Code CLI • 20 Specialized Agents • 45 Quality Gates • 14 Skills • Self-Learning • v3.0.0**
