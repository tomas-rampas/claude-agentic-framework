# Claude Code Agentic Framework

This repository contains a sophisticated, multi-agent workspace for the Claude Code CLI, enhanced with a suite of Model Context Protocol (MCP) servers. It is designed to be a highly modular, extensible, and efficient environment for software development tasks.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Architecture](#architecture)
  - [The `delegate` Command](#the-delegate-command)
  - [Agents](#agents)
  - [MCP Servers](#mcp-servers)
  - [Hooks](#hooks)
- [Usage](#usage)
- [Development](#development)

## Overview

This workspace is built around a multi-agent architecture, where each agent is a specialized expert for a specific domain of software development. These agents are enhanced with MCP servers, which provide them with advanced capabilities beyond their core reasoning skills. The entire system is orchestrated by a central configuration and a set of hooks that enforce best practices and consistent workflows.

The primary mechanism for interacting with this multi-agent system is the `delegate` command.

## Getting Started

To get started with this workspace, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd <repository-name>
    ```

2.  **Set up the environment:**
    *   Create a `.env` file in the root of the workspace by copying the `.env.example` file.
    *   Fill in the required environment variables, such as `CONTEXT7_API_KEY`.

3.  **Run the setup script:**
    ```bash
    chmod +x agents/setup-all.sh
    ./agents/setup-all.sh
    ```
    This script will validate the configuration, check for necessary dependencies, and ensure the workspace is ready for use.

## Architecture

The workspace is composed of four main components: the `delegate` command, Agents, MCP Servers, and Hooks.

### The `delegate` Command

The `delegate` command is the primary entry point for interacting with the multi-agent system. It is responsible for receiving a user's request, selecting the most appropriate agent for the task, and passing the request to that agent.

**Usage:**
```
claude delegate "<task description>"
```

**Example:**
```
claude delegate "refactor the user service to use the new database connection pool"
```

The `delegate` command will analyze the task description and route the request to the `maker-agent`, which is the specialist for refactoring and code modification.

### Agents

There are seven specialized agents in this workspace, each with a specific role:

| Agent            | Model                       | Purpose                               | Key MCPs |
| ---------------- | --------------------------- | ------------------------------------- | --- |
| **plan-agent**   | `claude-opus-4-1-20250805`      | Strategic planning & architecture     | `sequential-thinking`, `context7` |
| **reader-agent** | `claude-sonnet-4-20250514` | Fast file analysis & extraction     | `filesystem`, `serena` |
| **maker-agent**  | `claude-sonnet-4-20250514` | Code creation & development         | `filesystem`, `serena`, `context7` |
| **security-agent**|`claude-sonnet-4-20250514` | Vulnerability scanning & security   | `serena`, `filesystem` |
| **test-agent**   | `claude-sonnet-4-20250514` | Testing & quality assurance         | `filesystem`, `serena` |
| **docs-agent**   | `claude-sonnet-4-20250514` | Documentation generation            | `filesystem`, `context7` |
| **debug-agent**  | `claude-sonnet-4-20250514` | Systematic debugging                | `filesystem`, `serena`, `sequential-thinking` |

Each agent has its own directory in `/agents`, containing its configuration, prompt (`agent.md`), and any specific scripts or resources it needs. The `agent.md` file defines the agent's persona, capabilities, and core workflows.

### MCP Servers

The agents are enhanced with the following MCP servers:

| Server                | Purpose                        | Implementation                                      |
| --------------------- | ------------------------------ | --------------------------------------------------- |
| **sequential-thinking**| Complex reasoning              | `npx mcp-sequentialthinking-tools`                    |
| **serena**            | Semantic code intelligence     | `uvx --from git+https://github.com/oraios/serena` |
| **filesystem**        | Enhanced file operations       | `@modelcontextprotocol/server-filesystem`           |
| **context7**          | External library documentation | `https://mcp.context7.com/mcp`                      |

These servers provide agents with capabilities such as advanced reasoning, code analysis, and efficient file system access.

### Hooks

The workspace uses a system of hooks to enforce standards and automate workflows. There are 49 hooks planned, with 9 currently implemented. The hooks are organized into four categories:

*   **Development:** Core development and code creation.
*   **Quality:** Testing, code review, and quality assurance.
*   **MCP Integration:** MCP server integration and optimization.
*   **Agent Workflows:** Inter-agent coordination and workflows.

The full list of hooks and their status can be found in `hooks/index.yaml` and `hooks/IMPLEMENTATION_STATUS.md`.

#### Implemented Hooks:
*   `development/standards.yaml`
*   `development/mcp-integration.yaml`
*   `development/error-handling.yaml`
*   `quality/testing-strategy.yaml`
*   `mcp-integration/filesystem-optimization.yaml`
*   `mcp-integration/serena-integration.yaml`
*   `mcp-integration/context7-patterns.yaml`
*   `agent-workflows/debug-agent/debugging-methodology.yaml`
*   `agent-workflows/debug-agent/error-patterns.yaml`

## Usage

This workspace is designed to be used with the Claude Code CLI. Once the environment is set up, you can start giving instructions to Claude, and the `delegate` command will route your request to the appropriate agent.

### Example Workflows

*   **New Feature Implementation:**
    1.  **Delegate to `plan-agent`**: `claude delegate "design the architecture for a new user authentication service"`
    2.  **Delegate to `maker-agent`**: `claude delegate "implement the user authentication service based on the plan"`
    3.  **Delegate to `test-agent`**: `claude delegate "write and run unit and integration tests for the new service"`
    4.  **Delegate to `docs-agent`**: `claude delegate "generate API documentation for the authentication service"`

*   **Debugging:**
    1.  **Delegate to `debug-agent`**: `claude delegate "debug the following error: 'TypeError: Cannot read property 'id' of undefined'"`
    2.  The `debug-agent` will investigate and identify the root cause.
    3.  **Delegate to `maker-agent`**: `claude delegate "fix the bug identified by the debug agent"`

## Development

### Adding a New Agent

To add a new agent, create a new directory in `/agents` with the following structure:

```
/agents/
  /new-agent/
    - agent.md
    - config.json
    - mcp-config.json
    - setup.sh
```

Then, register the new agent in `claude.json`.

### Adding a New Hook

To add a new hook, create a new YAML file in the appropriate category under `/hooks`. The hook should follow the standard format defined in the existing hooks.

### Contributing

Please follow the existing coding standards and best practices when contributing to this workspace. All new code should be accompanied by appropriate tests and documentation.
