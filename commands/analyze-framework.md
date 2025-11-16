---
name: analyze-framework
description: Perform comprehensive framework health check and analysis
tags: [framework, validation, health-check, diagnostics]
---

# Framework Health Analysis Command

## Purpose

Perform a comprehensive analysis of the Claude Code CLI Agentic Framework, checking configuration integrity, agent availability, hook coverage, and overall system health.

## Usage

```
/analyze-framework [--detailed] [--export]
```

**Options:**
- `--detailed`: Include detailed analysis of each component
- `--export`: Export results to `framework-health-report.md`

## What This Command Does

### 1. Configuration Validation

Checks all framework configuration files:

- **claude.json**: Verifies all 18 agents are properly configured
- **Core hooks**: Validates core-hooks.json syntax and agent references
- **Shared resources**: Checks base-config.json, mcp-config.json, agent-patterns.md

**Validation:**
```bash
# Check claude.json structure
jq '.sub_agents | length' claude.json
# Expected: 18

# Verify no old agent names
grep -r '"maker"\|"test"\|"debug"\|"plan"\|"reader"' hooks/ claude.json
# Expected: No matches
```

### 2. Agent Availability Assessment

Analyzes all 18 agents:

**Language Experts (8 agents):**
- rust-expert, csharp-expert, go-expert, java-expert
- python-expert, typescript-expert, bash-expert, powershell-expert

**Domain Specialists (4 agents):**
- database-specialist, frontend-specialist, security-specialist, uiux-specialist

**Infrastructure & Planning (3 agents):**
- devops-orchestrator, system-architect, product-owner

**Quality & Analysis (3 agents):**
- comprehensive-analyst, code-review-gatekeeper, technical-docs-writer

**For Each Agent:**
- ✅ Agent file exists (agents/{agent}.md)
- ✅ Agent in claude.json configuration
- ✅ Agent has validation hook
- ✅ Agent referenced in delegation command
- ✅ YAML frontmatter valid

### 3. Hook Coverage Analysis

Examines validation hook system:

**Total Hooks:** 44 (31 framework-wide + 18 agent-specific - may vary)

**Agent-Specific Validation Hooks (18 required):**
- Check each agent has dedicated validation hook
- Validate hook JSON syntax
- Verify agent references are current
- Check for old agent names (maker, test, debug, plan, reader)

**Framework Hooks Coverage:**
- Quality gates (zero-tolerance, TDD, code review)
- Security scanning (dependency security, vulnerability checks)
- Performance monitoring (regression detection, optimization tracking)
- Learning system (pattern capture, lessons learned)
- Coordination (agent health, performance SLA, capability registry)

### 4. Skills System Check

Validates framework enhancement skills:

**Expected Skills (6 minimum):**
1. framework-validator - Framework health validation
2. agent-routing-advisor - Task routing assistance
3. hook-config-generator - Hook generation tools
4. workflow-visualizer - Workflow diagrams
5. performance-analytics - Performance tracking
6. migration-assistant - Framework migrations

**Plus Operational Skills:**
7. agent-debugger - Debug routing issues
8. hook-auditor - Hook coverage verification
9. config-validator - Configuration validation
10. dependency-checker - Dependency verification
11. quality-reporter - Quality metrics reports

### 5. Directory Structure Verification

Validates expected directory structure:

```
claude-agentic-framework/
├── agents/       ✓ (18 agent files)
├── commands/     ✓ (delegate + management commands)
├── hooks/        ✓ (44+ validation hooks)
├── shared/       ✓ (4 configuration files)
├── skills/       ✓ (6-11 skill files)
├── scripts/      ✓ (3 validation scripts)
├── CLAUDE.md     ✓ (agent execution rules)
├── README.md     ✓ (comprehensive documentation)
├── claude.json   ✓ (agent configuration)
└── .gitignore    ✓ (proper exclusions)
```

### 6. Script Validation

Checks validation scripts:

- **validate-framework.sh**: Comprehensive framework validator
- **validate-agents.sh**: Quick agent presence check
- **validate-hooks.sh**: Hook consistency validator

**Tests:**
- Scripts are executable
- Scripts run without errors
- Scripts produce expected output

## Output Format

### Quick Summary (Default)

```
🔍 Claude Code CLI Framework Health Analysis
================================================

✅ CONFIGURATION
   • claude.json: v3.0.0 (18 agents configured)
   • core-hooks.json: v3.0 (no old agent names)
   • Shared resources: 4/4 files present

✅ AGENTS (18/18)
   • Language Experts: 8/8 ✓
   • Domain Specialists: 4/4 ✓
   • Infrastructure & Planning: 3/3 ✓
   • Quality & Analysis: 3/3 ✓

✅ HOOKS (44 total)
   • Agent-specific validation: 18/18 (100% coverage)
   • Framework-wide: 26 hooks
   • All JSON syntax valid
   • No old agent references

✅ SKILLS (11 total)
   • Framework enhancement: 6/6 ✓
   • Operational: 5/5 ✓

✅ SCRIPTS (3/3)
   • All executable and functional

📊 OVERALL HEALTH: 🟢 EXCELLENT
   • Configuration: 100%
   • Agent Coverage: 100%
   • Hook Coverage: 100%
   • Documentation: Complete
```

### Detailed Analysis (--detailed)

Includes:
- Individual agent status and configuration details
- Hook-by-hook validation results
- Skill descriptions and integration status
- Detected issues with remediation steps
- Performance metrics if available
- Recommended improvements

### Export Report (--export)

Generates `framework-health-report.md` with:
- Executive summary
- Detailed findings for each component
- Detected issues and warnings
- Remediation recommendations
- Framework metrics over time
- Timestamp and version information

## Implementation

```typescript
// Pseudo-code for framework analysis
async function analyzeFramework(options: AnalysisOptions) {
  const report = {
    configuration: await validateConfiguration(),
    agents: await checkAgentAvailability(),
    hooks: await analyzeHookCoverage(),
    skills: await validateSkills(),
    structure: await verifyDirectoryStructure(),
    scripts: await testValidationScripts()
  };

  const healthScore = calculateHealthScore(report);

  if (options.detailed) {
    displayDetailedReport(report);
  } else {
    displayQuickSummary(report, healthScore);
  }

  if (options.export) {
    await exportToMarkdown(report, 'framework-health-report.md');
  }

  return report;
}
```

## Use Cases

### 1. Daily Health Check
```bash
/analyze-framework
# Quick check before starting work
```

### 2. Post-Update Validation
```bash
/analyze-framework --detailed
# After updating agents, hooks, or configuration
```

### 3. Documentation/Reporting
```bash
/analyze-framework --detailed --export
# Generate comprehensive health report for documentation
```

### 4. Troubleshooting
```bash
/analyze-framework --detailed
# Diagnose framework issues or configuration problems
```

## Expected Issues and Remediation

### Common Issues

**Missing Agents:**
```
❌ Agent file not found: agents/rust-expert.md
Remediation: Create agent file or update claude.json
```

**Old Agent References:**
```
⚠️  Found old agent name 'maker' in hooks/custom-hook.json
Remediation: Update to use appropriate language expert
```

**Hook Coverage Gaps:**
```
⚠️  No validation hook for: custom-agent
Remediation: Create validation hook or mark as optional
```

**Invalid JSON:**
```
❌ Invalid JSON syntax: hooks/broken-hook.json
Remediation: Fix JSON syntax errors
```

## Integration with Other Commands

- Use with `/validate-hooks` for deeper hook analysis
- Combine with `/list-agents` to see agent details
- Follow up with `/agent-status` for runtime information
- Use `/quality-report` for historical metrics

## Notes

- Analysis is read-only and doesn't modify any files
- Safe to run at any time
- Results are cached for 5 minutes to improve performance
- Export creates file in current directory
- Requires framework scripts to be executable (chmod +x scripts/*.sh)
