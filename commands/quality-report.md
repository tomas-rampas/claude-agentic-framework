---
name: quality-report
description: Generate a framework quality assessment based on actual configuration state
tags: [quality, metrics, reporting, validation]
---

# Quality Report Command

## Purpose

Generate a quality assessment of the framework by inspecting actual configuration files, agent definitions, hook coverage, and structural integrity.

## Usage

```
/quality-report [--detailed]
```

## What This Command Does

### 1. Configuration Integrity

Validate core configuration files:
- `claude.json` — Parse JSON, verify 18 agents, check required fields
- `settings.json` — Parse JSON, verify permissions structure
- `.mcp.json` — Parse JSON, verify MCP server definitions
- `shared/*.json` — Validate all shared resource files

### 2. Agent Coverage

Check agent ecosystem completeness:
- All 18 agents have definition files in `agents/`
- All agent files have valid YAML frontmatter (name, description, model, color)
- Agent model fields match claude.json assignments
- No orphaned agent files (files without claude.json entries)

### 3. Hook Coverage

Assess validation hook system:
- Each of the 18 agents has a dedicated validation hook
- All hook JSON files parse without errors
- Hook agent references point to valid agent names
- No references to deprecated agent names

### 4. Structural Integrity

Verify directory structure:
- `agents/` — 18 agent definition files
- `commands/` — Slash command definitions
- `hooks/` — Validation hook configurations
- `shared/` — Shared configuration resources
- `skills/` — Skill definitions
- `scripts/` — Validation scripts

### 5. Quality Score

Calculate a quality score based on:

```
Quality Score = (
  Config Integrity    × 0.20 +
  Agent Coverage      × 0.25 +
  Hook Coverage       × 0.25 +
  Frontmatter Quality × 0.15 +
  Structural Integrity × 0.15
) × 100
```

### Rating Scale

- **90-100**: Excellent — Framework fully configured and consistent
- **80-89**: Good — Minor gaps, fully functional
- **70-79**: Acceptable — Some missing hooks or configuration issues
- **60-69**: Needs Improvement — Significant gaps affecting quality
- **Below 60**: Critical — Structural issues require immediate attention

## Output Format

```
FRAMEWORK QUALITY REPORT
========================

Configuration Integrity:  ✓ claude.json valid (18 agents)
                         ✓ settings.json valid
                         ✓ .mcp.json valid

Agent Coverage:          18/18 agents with definition files
                         18/18 agents with valid frontmatter
                         0 orphaned files

Hook Coverage:           18/18 agents with validation hooks
                         44 total hook files, all valid JSON
                         0 deprecated agent references

Structural Integrity:    ✓ All required directories present
                         ✓ Validation scripts present

Quality Score: 95/100 (Excellent)
```

## Detailed Mode (--detailed)

When `--detailed` is specified, additionally:
- List each agent with its configuration status
- List each hook file with validation result
- Show any mismatches between agent frontmatter and claude.json
- Report specific issues with remediation suggestions

## Integration

Works with:
- `/agent-status` — Individual agent health
- `/validate-hooks` — Deep hook validation
- `/analyze-framework` — Comprehensive framework analysis
