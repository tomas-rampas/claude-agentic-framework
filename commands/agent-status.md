---
name: agent-status
description: Display configuration status and health information for framework agents
tags: [agents, status, monitoring]
---

# Agent Status Command

## Purpose

Check the configuration status and health of all 18 specialized agents in the framework by inspecting actual configuration files.

## Usage

```
/agent-status [agent-name]
```

## What This Command Does

### 1. Read Agent Configuration

Read `claude.json` and extract all agent entries from the `sub_agents` section. For each agent, report:
- **Name** and **specialization**
- **Model** assignment (opus/sonnet/haiku)
- **Enabled** status
- Whether the agent definition file exists in `agents/`

### 2. Verify Agent Files

For each agent in `claude.json`, check:
- Agent markdown file exists: `agents/{agent-name}.md`
- Agent frontmatter contains required fields: `name`, `description`, `model`, `color`
- Model in frontmatter matches the tier in `claude.json`

### 3. Check Validation Hooks

For each agent, check if a corresponding validation hook exists:
- `hooks/{agent-name}-validation.json`
- `hooks/{agent-name}-configuration.json`
- `hooks/{agent-name}-standards.json`
- `hooks/{agent-name}-audit.json`

### 4. Report Status

Display a summary table:

```
Agent                    | Model   | File | Hook | Status
-------------------------|---------|------|------|-------
rust-expert              | sonnet  | ✓    | ✓    | Ready
csharp-expert            | sonnet  | ✓    | ✓    | Ready
...
```

### 5. Single Agent Detail

When a specific agent name is provided, show detailed information:
- Full configuration from `claude.json`
- Frontmatter fields from the agent `.md` file
- Associated validation hook details
- Category membership

## Status Indicators

- **Ready** — Agent file exists, in claude.json, has validation hook
- **Limited** — Agent file exists but missing hook or configuration mismatch
- **Unavailable** — Agent in claude.json but file missing

## Expected Agent Count

The framework has 18 agents across 7 categories:
- **Language Experts** (6): rust, csharp, go, java, python, typescript
- **Automation Experts** (2): bash, powershell
- **Domain Specialists** (4): database, frontend, security, uiux
- **Infrastructure** (1): devops-orchestrator
- **Architecture & Planning** (2): system-architect, product-owner
- **Quality & Analysis** (2): comprehensive-analyst, code-review-gatekeeper
- **Documentation** (1): technical-docs-writer

## Integration

Works with:
- `/list-agents` — Agent catalog with capabilities
- `/validate-hooks` — Hook coverage verification
- `/analyze-framework` — Overall framework health
