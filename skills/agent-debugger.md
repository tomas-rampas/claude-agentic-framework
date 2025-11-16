---
name: agent-debugger
description: Debug agent routing, execution, and integration issues
category: operational
priority: high
author: framework-team
tags: [debugging, troubleshooting, agents, diagnostics]
---

# Agent Debugger Skill

## Purpose

Comprehensive diagnostic and debugging tool for agent routing issues, execution problems, and integration failures in the Claude Code CLI Agentic Framework.

## When to Use

Use this skill when experiencing:
- Tasks routed to wrong agents
- Agents not responding or timing out
- Unexpected agent behavior
- Agent coordination failures
- Performance degradation
- Configuration mismatches

## Diagnostic Capabilities

### 1. Agent Routing Diagnosis

**Problem:** Task routed to wrong agent or multiple agents claim task

**Diagnosis Steps:**
```bash
# Check agent capability registry
cat hooks/agent-capability-registry.json | jq '.agent_capabilities'

# Verify technology detection
cat hooks/technology-detection.json

# Check delegation rules
grep -A 5 "task_type" commands/delegate.md
```

**Common Issues:**
- Overlapping agent capabilities
- Ambiguous task descriptions
- Missing technology detection patterns
- Incorrect delegation rules

**Remediation:**
- Refine agent capability definitions
- Add specific technology patterns
- Update delegation routing logic
- Add explicit routing hints

### 2. Agent Availability Check

**Problem:** Agent appears unavailable or unresponsive

**Diagnosis Steps:**
```bash
# Verify agent file exists
ls -la agents/<agent-name>.md

# Check claude.json configuration
jq '.sub_agents["<agent-name>"]' claude.json

# Verify agent in capability registry
jq '.agent_capabilities["<agent-name>"]' hooks/agent-capability-registry.json

# Check for errors in agent definition
# Look for YAML frontmatter issues
head -20 agents/<agent-name>.md
```

**Common Issues:**
- Agent file missing or misnamed
- Invalid YAML frontmatter
- Agent not in claude.json
- Model specification incorrect
- Path configuration wrong

**Remediation:**
- Recreate missing agent files
- Fix YAML syntax errors
- Add agent to claude.json
- Verify model availability
- Correct file paths

### 3. Agent Execution Failures

**Problem:** Agent starts task but fails to complete

**Diagnosis Steps:**
```bash
# Check validation hooks
ls -la hooks/<agent-name>-*.json

# Verify hook configuration
jq . hooks/<agent-name>-validation.json

# Check for blocking quality gates
jq '.quality_gates.pre_commit.required_phases' hooks/<agent-name>-validation.json

# Review agent-specific errors
# (if logging enabled)
grep "ERROR.*<agent-name>" logs/agent-execution.log
```

**Common Issues:**
- Validation hook failures
- Quality gate timeouts
- Missing dependencies/tools
- Insufficient permissions
- Resource constraints

**Remediation:**
- Fix validation hook configuration
- Adjust timeout values
- Install required tools
- Grant necessary permissions
- Allocate more resources

### 4. Agent Coordination Problems

**Problem:** Agents don't hand off properly or collaborate

**Diagnosis Steps:**
```bash
# Check coordination hooks
cat hooks/agent-coordination.json

# Verify agent health monitoring
cat hooks/agent-health-monitor.json

# Check for circular dependencies
# Review agent-coordination.json dependencies

# Verify escalation rules
cat hooks/progressive-escalation.json
```

**Common Issues:**
- Circular agent dependencies
- Missing coordination rules
- Incorrect escalation paths
- Health check failures
- Timeout configuration issues

**Remediation:**
- Break circular dependencies
- Define coordination patterns
- Fix escalation logic
- Adjust health check intervals
- Increase timeout values

### 5. Performance Issues

**Problem:** Agent slow or consuming excessive resources

**Diagnosis Steps:**
```bash
# Check agent performance metrics
# (if /agent-status available)
/agent-status <agent-name> --metrics

# Review validation phases
jq '.validation_sequence | keys' hooks/<agent-name>-validation.json

# Check for expensive operations
jq '.validation_sequence | .[] | select(.timeout_seconds > 60)' \
  hooks/<agent-name>-validation.json

# Verify tool requirements
jq '.tools_required' hooks/<agent-name>-validation.json
```

**Common Issues:**
- Too many validation phases
- Long-running checks
- Missing tool installations
- Inefficient configurations
- Excessive token usage

**Remediation:**
- Parallelize validation phases
- Optimize expensive checks
- Cache validation results
- Install missing tools
- Optimize prompts for token efficiency

## Debug Workflow

### Step 1: Identify the Problem

```markdown
Problem Checklist:
□ Which agent is affected?
□ What was the expected behavior?
□ What actually happened?
□ When did the problem start?
□ Is it reproducible?
□ Are there error messages?
```

### Step 2: Gather Context

```bash
# Framework health
/analyze-framework --detailed

# Agent status
/agent-status <affected-agent> --metrics

# Hook validation
/validate-hooks --all

# Recent changes
git log --oneline -10 -- agents/ hooks/ claude.json
```

### Step 3: Run Diagnostics

```bash
# Agent file validation
./scripts/validate-agents.sh

# Hook consistency
./scripts/validate-hooks.sh

# Full framework check
./scripts/validate-framework.sh

# JSON syntax for specific agent
jq . hooks/<agent>-validation.json
jq .sub_agents.<agent> claude.json
```

### Step 4: Isolate the Issue

```markdown
Test in isolation:
1. Can the agent file be read? ✓/✗
2. Is the agent in claude.json? ✓/✗
3. Does the validation hook exist? ✓/✗
4. Is the hook JSON valid? ✓/✗
5. Are all referenced agents valid? ✓/✗
6. Do required tools exist? ✓/✗
```

### Step 5: Apply Fix

Based on diagnosis, apply appropriate remediation from common issues above.

### Step 6: Verify Resolution

```bash
# Re-run validations
./scripts/validate-framework.sh

# Test specific functionality
# (manual test or automated)

# Monitor for recurrence
/agent-status <agent> --watch
```

## Common Debugging Scenarios

### Scenario 1: "Agent not found"

**Symptoms:**
```
Error: Agent 'rust-expert' not found in configuration
```

**Debug:**
```bash
# Check if agent exists
ls agents/rust-expert.md  # Should exist
jq '.sub_agents.["rust-expert"]' claude.json  # Should return config
```

**Fix:**
- If file missing: Create agent file
- If not in claude.json: Add agent configuration
- If misnamed: Rename file or update references

### Scenario 2: "Task routing conflict"

**Symptoms:**
```
Warning: Multiple agents can handle this task
Candidates: python-expert, typescript-expert
```

**Debug:**
```bash
# Check capability overlap
jq '.agent_capabilities.["python-expert"]' hooks/agent-capability-registry.json
jq '.agent_capabilities.["typescript-expert"]' hooks/agent-capability-registry.json
```

**Fix:**
- Add more specific task description
- Refine agent capabilities
- Add explicit routing hint in task
- Update delegation command logic

### Scenario 3: "Validation hook timeout"

**Symptoms:**
```
Error: Validation timeout after 300s
Hook: rust-expert-validation
Phase: phase_3_testing
```

**Debug:**
```bash
# Check phase timeout
jq '.validation_sequence.phase_3_testing.timeout_seconds' \
  hooks/rust-expert-validation.json

# Review phase checks
jq '.validation_sequence.phase_3_testing.checks' \
  hooks/rust-expert-validation.json
```

**Fix:**
- Increase timeout for slow tests
- Optimize test execution
- Parallelize test runs
- Mark phase as non-blocking if appropriate

### Scenario 4: "Agent coordination failure"

**Symptoms:**
```
Error: Agent handoff failed
From: system-architect
To: rust-expert
Reason: Required context missing
```

**Debug:**
```bash
# Check coordination configuration
jq '.coordination_patterns' hooks/agent-coordination.json

# Verify both agents configured
jq '.sub_agents.["system-architect"]' claude.json
jq '.sub_agents.["rust-expert"]' claude.json
```

**Fix:**
- Ensure context properly passed between agents
- Add coordination pattern for this handoff
- Verify both agents have compatible interfaces
- Check for missing dependencies

### Scenario 5: "Permission denied"

**Symptoms:**
```
Error: Permission denied executing validation script
Hook: bash-expert-validation
Script: shellcheck
```

**Debug:**
```bash
# Check if tool installed
which shellcheck

# Check script permissions
ls -la $(which shellcheck)

# Verify path accessible
echo $PATH | grep -o "$(dirname $(which shellcheck))"
```

**Fix:**
- Install missing tool
- Add tool to PATH
- Grant execute permissions
- Update hook to use correct path

## Debug Tools

### Built-in Commands
- `/analyze-framework` - Overall framework health
- `/list-agents` - Agent catalog and status
- `/validate-hooks` - Hook validation
- `/agent-status` - Runtime metrics

### Validation Scripts
- `./scripts/validate-framework.sh` - Comprehensive validation
- `./scripts/validate-agents.sh` - Agent presence check
- `./scripts/validate-hooks.sh` - Hook consistency

### Manual Inspection
```bash
# Agent definition
cat agents/<agent>.md

# Agent configuration
jq '.sub_agents.<agent>' claude.json

# Validation hook
jq . hooks/<agent>-validation.json

# Capability registry
jq '.agent_capabilities.<agent>' hooks/agent-capability-registry.json

# Recent git changes
git log --oneline -5 -- agents/<agent>.md hooks/<agent>*.json
```

## Prevention Best Practices

### 1. Regular Health Checks
```bash
# Daily
/analyze-framework

# After changes
./scripts/validate-framework.sh
```

### 2. Version Control
```bash
# Always commit working states
git add agents/ hooks/ claude.json
git commit -m "Working configuration"

# Tag stable versions
git tag -a v1.0-stable -m "Stable framework configuration"
```

### 3. Testing Changes
```bash
# Before committing
./scripts/validate-framework.sh
/validate-hooks --all

# Test specific agent
/agent-status <agent>
```

### 4. Documentation
```markdown
# Document custom configurations
# Add comments in JSON hooks explaining non-standard settings
# Keep README.md updated with agent changes
```

## Advanced Debugging

### Enable Verbose Logging

For deeper debugging, enable verbose logging (if supported):

```bash
# Set log level in claude.json
jq '.global_settings.log_level = "debug"' claude.json > tmp.json
mv tmp.json claude.json

# Check logs
tail -f logs/agent-execution.log
```

### Trace Agent Execution

```bash
# Enable execution tracing
# (implementation-specific)
export CLAUDE_TRACE=1
export CLAUDE_DEBUG_AGENTS=rust-expert,python-expert
```

### Performance Profiling

```bash
# Time validation phases
time ./scripts/validate-hooks.sh

# Profile specific hook
jq '.validation_sequence | to_entries[] | {phase: .key, timeout: .value.timeout_seconds}' \
  hooks/<agent>-validation.json
```

## Getting Help

If debugging doesn't resolve the issue:

1. **Check documentation**: README.md, CLAUDE.md
2. **Review examples**: See working configurations in framework
3. **Search issues**: Look for similar problems in issue tracker
4. **Ask for help**: Provide detailed diagnostic output
5. **File bug report**: If framework issue found

## Summary

The Agent Debugger skill provides systematic approaches to:
- Diagnose agent routing and execution issues
- Identify configuration problems
- Resolve integration failures
- Optimize agent performance
- Prevent future issues

Use this skill proactively for health checks and reactively for troubleshooting.
