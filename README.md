# Claude Code CLI - Agent Execution Framework

A configuration framework for [Claude Code CLI](https://docs.claude.com/en/docs/claude-code) that adds 18 specialized agents, automated pattern capture, institutional memory, and intelligent task routing.

**This is NOT a standalone tool** — it requires Claude Code CLI as the underlying platform.

---

## Overview

This framework extends Claude Code CLI with:

- **18 Specialized Agents** covering the full development lifecycle
- **44 Quality Gates** with multi-phase validation per agent
- **Self-Learning System** — automated pattern capture, institutional memory, and semantic search
- **MCP Integration** — 4 MCP servers for code intelligence, file ops, documentation, and reasoning

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

Create or update `~/.claude/mcp.json` (or project-level `.mcp.json`):

```json
{
  "mcpServers": {
    "serena": {
      "command": "npx",
      "args": ["-y", "@serenaai/mcp-server"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/your-username"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@sequential-thinking/mcp-server"]
    }
  }
}
```

Replace `/home/your-username` with your actual home directory path.

| MCP Server | Purpose |
|------------|---------|
| **serena** | Semantic code intelligence + institutional memory |
| **filesystem** | Enhanced file operations for large files and atomic updates |
| **context7** | External documentation and best practices |
| **sequential-thinking** | Complex reasoning and multi-step analysis |

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

### Language Experts
| Agent | Focus |
|-------|-------|
| **rust-expert** | Systems programming, memory safety, async/await |
| **csharp-expert** | ASP.NET Core, Entity Framework, Azure |
| **go-expert** | Microservices, gRPC, Kubernetes operators |
| **java-expert** | Spring Boot, Maven/Gradle, enterprise apps |
| **python-expert** | Django/Flask, data science, automation |
| **typescript-expert** | React/Next.js, Node.js, frontend/backend |

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
├── agents/                  # 18 agent definitions (.md with YAML frontmatter)
├── commands/                # 6 commands (delegate, analyze-framework, list-agents, etc.)
├── hooks/                   # 44 quality gates (agent-specific + framework-wide)
├── shared/                  # Shared configs (base-config, mcp-config, memory-categories)
├── skills/                  # 11 operational skills (validation, debugging, analytics)
├── scripts/                 # 3 validation scripts
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
npx -y @serenaai/mcp-server --version  # Test server
```

**Agents not found:**
```bash
ls -1 agents/*.md | wc -l  # Should show 18
./scripts/validate-agents.sh
```

**Delegation not working:**
```bash
cat commands/delegate.md | head -20  # Verify command exists
```

---

## Resources

- [Claude Code CLI Documentation](https://docs.claude.com/en/docs/claude-code)
- [Getting Started Guide](https://docs.claude.com/en/docs/claude-code/getting-started)
- [Configuration Reference](https://docs.claude.com/en/docs/claude-code/configuration)
- [MCP Integration Guide](https://docs.claude.com/en/docs/claude-code/mcp)

---

**Built for Claude Code CLI • 18 Specialized Agents • 44 Quality Gates • Self-Learning • v3.0.0**
