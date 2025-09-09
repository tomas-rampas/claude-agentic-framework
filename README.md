# Claude Agentic Framework v2.0

**Production-ready multi-agent system for Claude with specialized agents and smart MCP integration.**

## 🎯 Overview

This repository contains a fully optimized multi-agent framework built for Claude with Model Context Protocol (MCP) server integration. The system features specialized agents for different development tasks, smart resource sharing, and efficient token usage.

**Current Status (September 2025):**
- ✅ **Production Ready** - Framework is stable and actively maintained
- ✅ **Token Optimized** - Efficient agent prompts (800-1100 tokens each)
- ✅ **Smart MCP Integration** - Conditional activation based on task needs
- ✅ **Specialized Agents** - 7 focused agents for different development tasks
- ✅ **Security Audited** - Regular security scans with clean audit reports

## 🚀 Quick Start

### 1. Setup
```bash
git clone https://github.com/tomas-rampas/claude-agentic-framework.git
cd claude-agentic-framework
cp .env.example .env  # Create if needed
# Configure any required environment variables
```

### 2. Validation
```bash
# Validate framework integrity and agent configurations
./validate-framework.sh
```

### 3. Usage
The framework operates through Claude's natural conversation interface. Simply describe your task and the system automatically routes to the appropriate specialized agent.

**Examples:**
- "Plan the architecture for a new web application" → `plan-agent`
- "Implement user authentication" → `maker-agent`  
- "Debug this performance issue" → `debug-agent`
- "Analyze these files" → `reader-agent`
- "Check for security vulnerabilities" → `security-agent`

## 📊 Framework Metrics

| Metric | Current Status | Performance |
|--------|----------------|-------------|
| **Active Agents** | 7 specialized agents | Each optimized for specific tasks |
| **Token Usage** | ~900-1100 per agent | Efficient, focused prompts |
| **Response Time** | Sub-second routing | Automatic agent selection |
| **MCP Integration** | 4 smart servers | Conditional activation |
| **Security Status** | ✅ Clean audit | Regular vulnerability scanning |
| **Maintenance** | Active development | Updated September 2025 |

## 🏗️ Architecture

### Agent Specialization with Tool Configuration

Each agent is configured with specific tools tailored to their role, preventing unnecessary permissions while enabling full functionality:

| Agent | Model | Focus Area | Tool Categories | Key Capabilities |
|-------|-------|------------|-----------------|------------------|
| **plan-agent** | Claude Opus 4.1 | Strategic planning & system design | Read-only analysis, Web research, Sequential thinking | Architecture decisions, technology evaluation, planning |
| **maker-agent** | Claude Sonnet 4 | Code implementation & development | Full file manipulation, All MCPs, Web access | Code creation, refactoring, symbol operations |
| **reader-agent** | Claude Haiku 3 | File analysis & code comprehension | Read-only tools, Search & analysis | Fast scanning, pattern detection, no write access |
| **debug-agent** | Claude Sonnet 4 | Debugging & troubleshooting | Read/Write/Edit, Process control, Sequential thinking | Error investigation, fixes, process monitoring |
| **security-agent** | Claude Haiku 3 | Security analysis & vulnerability scanning | Read-only scanning, Pattern detection | Vulnerability detection, data flow tracing |
| **test-agent** | Claude Haiku 3 | Testing & quality assurance | Full test file creation/editing, MCP integration | TDD test creation, test modification, validation |
| **docs-agent** | Claude Haiku 3 | Documentation & technical writing | Documentation writing, Web research | Creating/updating docs, framework patterns |

### Agent Tool Configuration Details

#### **maker-agent** (Most Comprehensive Toolset)
- **File Operations**: Read, Write, Edit, MultiEdit
- **Search & Analysis**: Bash, Grep, Glob
- **MCP Tools**: Full filesystem, serena, context7, sequentialthinking access
- **Web Access**: WebSearch, WebFetch for research
- **Task Management**: TodoWrite

#### **test-agent** (TDD-Focused Tools)
- **Test Creation**: Write, Edit, MultiEdit for test files
- **File Operations**: Read for understanding code to test
- **MCP Integration**: filesystem write/edit capabilities, serena for analysis
- **Execution**: Bash for running tests

#### **reader-agent** (Read-Only Analysis)
- **Analysis Tools**: Read, Grep, Glob for searching
- **MCP Read Operations**: filesystem read/list/search, serena symbol analysis
- **No Write Access**: Cannot modify any files (security by design)

#### **debug-agent** (Debugging Suite)
- **Full Debugging**: Read, Write, Edit for bug fixes
- **Process Control**: BashOutput, KillBash for long-running processes
- **MCP Analysis**: serena for tracing, sequentialthinking for complex issues

#### **security-agent** (Secure Scanning)
- **Read-Only**: No write permissions (security principle)
- **Pattern Detection**: Grep, search tools
- **MCP Analysis**: serena for data flow tracing

#### **docs-agent** (Documentation Management)
- **Documentation**: Write, Edit, MultiEdit for docs
- **Web Research**: WebSearch for standards
- **MCP Docs**: context7 for framework documentation

#### **plan-agent** (Strategic Planning)
- **Planning**: ExitPlanMode for plan completion
- **Research**: WebSearch, WebFetch
- **Analysis**: Read-only file access
- **MCP Strategy**: sequentialthinking, context7

### MCP Servers (Smart Activation)

| Server | Purpose | When Activated | Benefits |
|--------|---------|----------------|----------|
| **filesystem** | Enhanced file operations | Large files, atomic operations | Optimized file handling, batch operations |
| **serena** | Semantic code intelligence | Symbol analysis, refactoring | Type-aware operations, cross-reference tracking |
| **context7** | External documentation | Framework queries, best practices | Official docs, version-specific guidance |
| **sequentialthinking** | Complex reasoning | Multi-step analysis, planning | Structured problem decomposition |

## 📁 Project Structure

```
claude-agentic-framework/
├── claude.json                    # Main framework configuration
├── agents/                        # Agent definitions
│   ├── plan-agent.md             # Strategic planning agent
│   ├── maker-agent.md            # Code implementation agent  
│   ├── reader-agent.md           # File analysis agent
│   ├── debug-agent.md            # Debugging agent
│   ├── security-agent.md         # Security scanning agent
│   ├── test-agent.md             # Testing agent
│   ├── docs-agent.md             # Documentation agent
│   └── setup-*.sh               # Agent setup scripts
├── shared/                        # Shared configurations and patterns
│   ├── base-config.json          # Common agent configuration
│   ├── mcp-config.json           # MCP server definitions
│   └── agent-patterns.md         # Shared workflows and patterns
├── hooks/                        # Essential system hooks (15 total)
│   ├── core-hooks.json           # Hook registry
│   ├── smart-mcp.json            # MCP activation rules
│   └── *.json                    # Individual hook implementations
├── scripts/                      # Utility scripts
├── backup/                       # Automatic backups
├── validate-framework.sh         # Framework validation
├── security-check.sh             # Security audit script
└── README.md                     # This file
```

## 🔧 Key Optimizations

### 1. **Lean Agent Prompts**
- **Before**: 2000+ tokens with embedded MCP documentation
- **After**: 800-1100 tokens focused on specialization
- **Approach**: Extract shared patterns to `shared/agent-patterns.md`

### 2. **Smart MCP Activation** 
- **Before**: Auto-engagement for all MCPs on all agents
- **After**: Conditional activation based on task context
- **Implementation**: `hooks/smart-mcp.json` with activation rules

### 3. **Essential Hooks System**
- **Before**: 49 hooks with verbose YAML (4900+ lines)
- **After**: 15 essential hooks with JSON (150 lines)
- **Result**: 85% reduction while preserving functionality

### 4. **Shared Resources**
- **Configuration inheritance** eliminates duplication
- **Common patterns library** reduces context size
- **Centralized MCP definitions** improve maintainability

### 5. **Role-Based Tool Access**
- **Security Principle**: Each agent only gets tools necessary for their role
- **test-agent Fix**: Now has Write/Edit tools for TDD test creation
- **reader-agent**: Read-only access prevents accidental modifications
- **security-agent**: Read-only scanning for security isolation
- **maker-agent**: Full toolset for comprehensive development

### 6. **Correct Agent Configuration**
- **Valid Parameters**: Only `name`, `description`, and `tools` in YAML frontmatter
- **Model Assignment**: Handled by orchestrator (delegate.md), not in agent files
- **MCP Access**: Via full tool names (e.g., `mcp__filesystem__write_file`)
- **Hooks**: Configured globally in settings.local.json, not per-agent

## 🪝 Essential Hooks (15 Total)

| Category | Hooks | Purpose |
|----------|-------|---------|
| **Core Operations** | `mcp-integration`, `file-operations`, `symbol-operations` | Smart routing and enhanced capabilities |
| **Development** | `development-standards`, `error-handling`, `framework-integration` | Code quality and consistency |
| **Quality** | `testing-workflow`, `security-check`, `quality-gates` | Validation and standards |
| **Coordination** | `workflow-coordination`, `debugging-support`, `planning-support` | Agent orchestration |
| **Monitoring** | `performance-monitor`, `documentation-sync`, `code-analysis` | System health and maintenance |

## 💡 Usage Examples

The framework automatically routes requests to appropriate agents based on the task description:

### Strategic Planning
```
"Design a microservices architecture for an e-commerce platform"
```
→ **Routed to plan-agent** (Claude Opus)
→ Uses sequential thinking for complex architecture decisions
→ Leverages context7 for microservices best practices

### Implementation
```
"Implement JWT authentication for the user service"
```
→ **Routed to maker-agent** (Claude Sonnet)
→ Queries context7 for JWT implementation patterns
→ Uses serena for symbol-aware code generation
→ Employs filesystem for efficient file operations

### Debugging
```
"Investigate why the checkout process is slow"
```
→ **Routed to debug-agent** (Claude Sonnet)
→ Uses sequential thinking for systematic analysis
→ Leverages filesystem for log analysis
→ Employs serena for call graph tracing

### Code Analysis
```
"Analyze this React component and explain its functionality"
```
→ **Routed to reader-agent** (Claude Haiku)
→ Uses filesystem for efficient file reading
→ Leverages serena for symbol and dependency analysis

### Security Assessment
```
"Scan the authentication module for security vulnerabilities"
```
→ **Routed to security-agent** (Claude Haiku)
→ Uses filesystem for comprehensive file scanning
→ Employs serena for data flow analysis
→ Provides actionable remediation recommendations

## 🔒 Security

The framework maintains strict security standards:

- ✅ **Zero hardcoded credentials** - All sensitive data via environment variables
- ✅ **Regular security audits** - Automated scanning with `security-agent`
- ✅ **Clean audit status** - Latest audit: September 2025, no issues found  
- ✅ **Secure defaults** - All configurations follow security best practices
- ✅ **Version control safety** - Sensitive files properly excluded from git

### Security Commands
```bash
# Run security audit
./security-check.sh

# View latest security report
cat SECURITY_AUDIT.md

# Validate framework security
./validate-framework.sh --security
```

## �️ Development & Configuration

### Adding a New Agent

To extend the framework with a custom agent:

1. **Create the agent file:**
```bash
# Create agent definition
touch agents/custom-agent.md
```

2. **Define the agent prompt:**
```yaml
---
name: custom-agent
description: Brief description of agent purpose
tools: Read, Write, Edit, Bash, Grep, mcp__filesystem__read_text_file  # Specify exact tools needed
---

# Custom Agent

Agent specialization and key responsibilities (keep concise, ~800-1000 tokens).

## Focus Areas
- Primary responsibilities
- Key capabilities
- Integration points

## When to Use
- Specific use cases
- Task patterns that trigger this agent

## MCP Integration
- **Server Name**: When and why to use specific MCP servers

Refer to `shared/agent-patterns.md` for common workflows.
```

3. **Register in main configuration:**
Edit `claude.json` to add your agent to the `sub_agents` section.

4. **Validate the setup:**
```bash
./validate-framework.sh
```

### Framework Configuration

Key configuration files:
- `claude.json` - Main framework settings and agent registry
- `shared/base-config.json` - Common agent configuration template  
- `shared/mcp-config.json` - MCP server definitions
- `hooks/core-hooks.json` - Hook system registry

## 📚 Documentation & Resources

- **`claude.json`** - Main framework configuration and agent definitions
- **`shared/agent-patterns.md`** - Common workflows and MCP usage patterns
- **`hooks/core-hooks.json`** - Hook system documentation and registry  
- **`SECURITY_AUDIT.md`** - Latest security audit report (updated regularly)
- **Agent files** - Individual agent documentation in `agents/` directory
- **Setup scripts** - Agent configuration and validation tools

## 🎯 Current Status & Roadmap

### ✅ Completed (v2.0)
- ✅ **Optimized agent system** - 7 specialized agents with focused responsibilities
- ✅ **Smart MCP integration** - Conditional activation based on task requirements
- ✅ **Security hardening** - Regular audits and secure configuration management
- ✅ **Performance optimization** - Efficient token usage and fast response times
- ✅ **Production stability** - Stable, tested framework ready for daily use

### 🔄 Ongoing Maintenance
- 🔄 **Regular security audits** - Monthly vulnerability assessments
- 🔄 **Performance monitoring** - Continuous optimization of token usage and response times
- 🔄 **Agent refinement** - Ongoing improvements to agent specializations
- 🔄 **Documentation updates** - Keeping documentation current with framework changes  

## 🤝 Contributing

When contributing to the framework:

1. **Follow agent design principles:**
   - Keep agent prompts focused and concise (800-1100 tokens)
   - Use shared resources from `shared/` directory for common patterns
   - Implement smart MCP activation (avoid auto-engagement)
   - Focus on essential functionality only

2. **Development workflow:**
   - Test changes with `./validate-framework.sh`
   - Run security checks with `./security-check.sh` 
   - Update documentation for new features
   - Follow existing code patterns and naming conventions

3. **Pull request guidelines:**
   - Include validation test results
   - Update relevant documentation
   - Explain the motivation for changes
   - Ensure security audit passes

## 📋 Requirements

- **Claude Access** - Framework designed for Claude AI models
- **Bash Shell** - Required for setup and validation scripts  
- **Git** - For version control and updates
- **Environment Variables** - For any external API keys (optional)

## 📖 Version History

- **v2.2** (Current, September 2025) - Corrected agent configuration format
  - Removed invalid parameters (mcp_servers, hooks, model) from agent files
  - Clarified that models are assigned by orchestrator, not agents
  - Configured global hooks in settings.local.json
  - MCP tools accessed via full names in tools list
  
- **v2.1** (September 2025) - Enhanced with role-based tool access
  - Each agent now has specific tools tailored to their role
  - test-agent fixed with Write/Edit capabilities for TDD
  - Security improvements through least-privilege tool access
  - Complete tool configuration in agent YAML frontmatter

- **v2.0** (September 2025) - Production-ready optimized framework
  - 7 specialized agents with focused responsibilities
  - Smart MCP integration with conditional activation
  - Regular security auditing and maintenance
  - Comprehensive documentation and validation tools

- **v1.0** (Archived) - Original implementation with extensive per-agent documentation

---

**🚀 Ready for production use with active maintenance and security monitoring.**