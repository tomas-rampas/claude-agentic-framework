---
name: config-validator
description: Validate framework configuration files for correctness and consistency
category: operational
priority: high
author: framework-team
tags: [validation, configuration, json, yaml, integrity]
---

# Config Validator Skill

## Purpose

Validate all framework configuration files (claude.json, hooks, shared resources) for syntax correctness, schema compliance, and logical consistency.

## When to Use

- After modifying configuration files
- Before committing changes
- During framework setup
- When troubleshooting configuration issues
- As part of CI/CD pipeline

## Configuration Files Validated

### 1. claude.json (Main Configuration)

**Validations:**
```bash
# JSON syntax
jq empty claude.json

# Required fields
jq -e '.version' claude.json
jq -e '.sub_agents' claude.json
jq -e '.global_settings' claude.json

# Agent count
agent_count=$(jq '.sub_agents | length' claude.json)
[ $agent_count -eq 18 ] || echo "Expected 18 agents, found $agent_count"

# Agent structure
for agent in $(jq -r '.sub_agents | keys[]' claude.json); do
  jq -e ".sub_agents.${agent}.model" claude.json > /dev/null || \
    echo "Missing model for $agent"
  jq -e ".sub_agents.${agent}.specialization" claude.json > /dev/null || \
    echo "Missing specialization for $agent"
done
```

**Expected Structure:**
```json
{
  "version": "3.0.0",
  "description": "string",
  "sub_agents": {
    "agent-name": {
      "enabled": true,
      "path": "string",
      "config_file": "string",
      "prompt_file": "string",
      "model": "claude-model-id",
      "specialization": "string"
    }
  },
  "global_settings": {},
  "shared_resources": {},
  "optimization_features": {},
  "agent_categories": {}
}
```

### 2. Hook Files (hooks/*.json, hooks/*.yaml)

**Validations:**
```bash
# JSON syntax
for hook in hooks/*.json; do
  jq empty "$hook" || echo "Invalid JSON: $hook"
done

# YAML syntax
for hook in hooks/*.yaml hooks/*.yml; do
  if [ -f "$hook" ]; then
    python3 -c "import yaml; yaml.safe_load(open('$hook'))" || \
      echo "Invalid YAML: $hook"
  fi
done

# Required fields
for hook in hooks/*-validation.json; do
  jq -e '.name' "$hook" > /dev/null || echo "Missing name in $hook"
  jq -e '.agents' "$hook" > /dev/null || echo "Missing agents in $hook"
  jq -e '.validation_sequence' "$hook" > /dev/null || echo "Missing validation_sequence in $hook"
done

# Agent references valid
for hook in hooks/*.json; do
  for agent in $(jq -r '.agents[]?' "$hook" 2>/dev/null); do
    [ -f "agents/${agent}.md" ] || echo "Invalid agent in $hook: $agent"
  done
done
```

### 3. Shared Resources (shared/*.json)

**Validations:**
```bash
# Validate all JSON files
for file in shared/*.json; do
  jq empty "$file" || echo "Invalid JSON: $file"
done

# Check required files exist
required=(base-config.json mcp-config.json memory-categories.json)
for file in "${required[@]}"; do
  [ -f "shared/$file" ] || echo "Missing required file: shared/$file"
done
```

### 4. Agent Files (agents/*.md)

**Validations:**
```bash
# YAML frontmatter
for agent in agents/*.md; do
  # Extract YAML frontmatter (between --- markers)
  sed -n '/^---$/,/^---$/p' "$agent" | \
    python3 -c "import sys, yaml; yaml.safe_load(sys.stdin)" || \
    echo "Invalid frontmatter in $agent"
done

# Required frontmatter fields
for agent in agents/*.md; do
  grep -q "^name:" "$agent" || echo "Missing name in $agent"
  grep -q "^description:" "$agent" || echo "Missing description in $agent"
  grep -q "^model:" "$agent" || echo "Missing model in $agent"
done
```

## Validation Checks

### Syntax Validation

```bash
#!/bin/bash
# validate-syntax.sh

errors=0

# JSON files
for json in claude.json shared/*.json hooks/*.json; do
  if ! jq empty "$json" 2>/dev/null; then
    echo "❌ Invalid JSON: $json"
    ((errors++))
  fi
done

# YAML files
for yaml in hooks/*.yaml hooks/*.yml; do
  if [ -f "$yaml" ]; then
    if ! python3 -c "import yaml; yaml.safe_load(open('$yaml'))" 2>/dev/null; then
      echo "❌ Invalid YAML: $yaml"
      ((errors++))
    fi
  fi
done

if [ $errors -eq 0 ]; then
  echo "✅ All configuration files have valid syntax"
  exit 0
else
  echo "❌ Found $errors syntax errors"
  exit 1
fi
```

### Schema Validation

```bash
# Validate claude.json schema
required_fields=(version description sub_agents global_settings)
for field in "${required_fields[@]}"; do
  jq -e ".$field" claude.json > /dev/null || \
    echo "❌ Missing required field: $field"
done

# Validate each agent has required fields
for agent in $(jq -r '.sub_agents | keys[]' claude.json); do
  for field in enabled model specialization; do
    jq -e ".sub_agents.$agent.$field" claude.json > /dev/null || \
      echo "❌ Agent $agent missing: $field"
  done
done
```

### Cross-Reference Validation

```bash
# Agents in claude.json must have corresponding files
for agent in $(jq -r '.sub_agents | keys[]' claude.json); do
  [ -f "agents/${agent}.md" ] || echo "❌ Missing agent file: $agent.md"
done

# Agents with files must be in claude.json
for agent_file in agents/*.md; do
  agent=$(basename "$agent_file" .md)
  jq -e ".sub_agents.\"$agent\"" claude.json > /dev/null || \
    echo "⚠️  Agent file exists but not in claude.json: $agent"
done

# Hooks reference valid agents
for hook in hooks/*.json; do
  for agent in $(jq -r '.agents[]?' "$hook" 2>/dev/null); do
    jq -e ".sub_agents.\"$agent\"" claude.json > /dev/null || \
      echo "❌ Hook $(basename $hook) references invalid agent: $agent"
  done
done
```

### Logical Consistency

```bash
# No duplicate agent names
duplicates=$(jq -r '.sub_agents | keys[]' claude.json | sort | uniq -d)
[ -z "$duplicates" ] || echo "❌ Duplicate agents: $duplicates"

# No circular dependencies in hooks
# (simplified check - look for hooks that depend on themselves)
for hook in hooks/*.json; do
  name=$(jq -r '.name' "$hook")
  deps=$(jq -r '.depends_on[]?' "$hook" 2>/dev/null)
  if echo "$deps" | grep -q "^$name$"; then
    echo "❌ Circular dependency in $hook"
  fi
done

# Model names valid
valid_models=("claude-opus-4-1-20250805" "claude-sonnet-4-20250514" "claude-haiku-3-20241201")
for agent in $(jq -r '.sub_agents | keys[]' claude.json); do
  model=$(jq -r ".sub_agents.$agent.model" claude.json)
  if [[ ! " ${valid_models[@]} " =~ " ${model} " ]]; then
    echo "⚠️  Agent $agent uses unexpected model: $model"
  fi
done
```

## Validation Report

```
═══════════════════════════════════════════════════════════
CONFIGURATION VALIDATION REPORT
Generated: 2025-11-16 15:50 UTC
═══════════════════════════════════════════════════════════

SYNTAX VALIDATION
  ✅ claude.json: Valid JSON
  ✅ shared/*.json (4 files): All valid
  ✅ hooks/*.json (43 files): All valid
  ✅ hooks/*.yaml (1 file): Valid

SCHEMA VALIDATION
  ✅ claude.json structure: Complete
  ✅ All agents have required fields
  ✅ Global settings present
  ✅ Shared resources configured

CROSS-REFERENCE VALIDATION
  ✅ All 18 agents have definition files
  ✅ All agent files referenced in claude.json
  ✅ All hook agent references valid
  ✅ No orphaned configuration files

LOGICAL CONSISTENCY
  ✅ No duplicate agent names
  ✅ No circular dependencies detected
  ✅ All model names valid
  ✅ Agent count correct (18)

OVERALL STATUS: ✅ PASS
  Files Validated: 67
  Errors Found: 0
  Warnings: 0

Configuration is valid and consistent.
```

## Common Issues

### Issue 1: JSON Syntax Error
```
Error: Invalid JSON in hooks/my-hook.json
Line 42: Expected ',' but found '}'
```
**Fix:** Use `jq . hooks/my-hook.json` to identify and fix syntax error

### Issue 2: Missing Required Field
```
Error: Agent 'rust-expert' missing field 'model' in claude.json
```
**Fix:** Add required field to agent configuration

### Issue 3: Invalid Agent Reference
```
Error: hooks/custom-hook.json references non-existent agent 'old-agent'
```
**Fix:** Update agent reference to valid agent name

### Issue 4: Circular Dependency
```
Error: Hook 'hook-a' depends on 'hook-b' which depends on 'hook-a'
```
**Fix:** Restructure dependencies to eliminate circular references

## Best Practices

1. **Validate Before Committing**
   ```bash
   ./skills/config-validator.sh
   git add .
   git commit -m "Update configuration"
   ```

2. **Use Version Control**
   - Always commit working configurations
   - Test changes before pushing

3. **Automated Validation**
   - Add to CI/CD pipeline
   - Run on every pull request

4. **Document Custom Config**
   - Add comments explaining non-standard settings
   - Maintain changelog for config changes

## Integration

Works with:
- `/analyze-framework` - Overall health check
- `/validate-hooks` - Hook-specific validation
- `./scripts/validate-framework.sh` - Comprehensive validation

## CI/CD Integration

```yaml
# .github/workflows/validate-config.yml
name: Validate Configuration
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Validate Configurations
        run: |
          chmod +x skills/config-validator.sh
          ./skills/config-validator.sh --strict
```

## Summary

Config Validator ensures:
- All configuration files have valid syntax
- Required fields are present
- Cross-references are consistent
- No logical errors in configuration
- Framework integrity maintained

Run regularly to prevent configuration issues.
