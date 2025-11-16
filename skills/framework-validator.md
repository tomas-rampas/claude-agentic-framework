---
name: framework-validator
description: Comprehensive validation of Claude Code agentic framework health, consistency, and integrity
version: 1.0
priority: critical
category: framework-maintenance
---

# Framework Validation & Health Check Skill

## Purpose

Validate the entire Claude Code agentic framework for integrity, consistency, and proper configuration. This skill performs deep analysis of all framework components and generates actionable remediation steps.

## When to Use

- After framework updates or modifications
- Before production deployments
- After adding/removing agents or hooks
- Periodic health checks (weekly/monthly)
- When experiencing unexpected behavior
- After merging major changes

## Validation Checks

### 1. Agent Alignment Validation

**Check all 18 agents are properly configured:**

```bash
# Expected agents
EXPECTED_AGENTS=(
  "rust-expert" "csharp-expert" "go-expert" "java-expert"
  "python-expert" "typescript-expert" "bash-expert" "powershell-expert"
  "database-specialist" "frontend-specialist" "security-specialist" "uiux-specialist"
  "devops-orchestrator" "system-architect" "comprehensive-analyst"
  "code-review-gatekeeper" "technical-docs-writer" "product-owner"
)

# Validation steps:
1. Verify all agent files exist in agents/ directory
2. Check CLAUDE.md lists all 18 agents
3. Verify delegate.md routing covers all agents
4. Ensure README.md references 18 agents (not 11 or other outdated count)
```

**Files to validate:**
- `CLAUDE.md` - Check agent table completeness
- `commands/delegate.md` - Verify routing patterns for all 18 agents
- `README.md` - Validate agent count and architecture section
- `agents/*.md` - Ensure all 18 agent files exist

### 2. Hook Consistency Validation

**Check all hooks reference current agents:**

```bash
# Hooks to validate
HOOKS=(
  "zero-tolerance-quality.json"
  "test-coverage-enforcer.json"
  "tdd-workflow.json"
  "delegation-enforcement.yaml"
  "architecture-compliance.json"
  "architecture-review.json"
  "code-review.json"
  "dependency-security.json"
  "performance-regression.json"
  "agent-health-monitor.json"
  "orchestration-scope-limiter.json"
  "role-resolution.json"
  "agent-capability-registry.json"
  "technology-detection.json"
  "agent-performance-sla.json"
  "progressive-escalation.json"
  "java-expert-configuration.json"
  "database-specialist-validation.json"
  "frontend-specialist-standards.json"
  "security-specialist-audit.json"
  "uiux-specialist-validation.json"
)

# For each hook, validate:
1. All agent references in "agents" field are valid (exist in EXPECTED_AGENTS)
2. Agent references in "agent_responsibilities" match current naming
3. No old agent names (maker, test, debug, reader, plan, security, docs, etc.)
4. Version compatibility across hooks
5. Integration "coordinates_with" references are valid
```

**Old agent names to detect (should NOT exist):**
- `maker`, `maker-agent`
- `test`, `test-agent`
- `debug`, `debug-agent`
- `reader`, `reader-agent`
- `plan`, `plan-agent`
- `security`, `security-agent` (should be `security-specialist`)
- `docs`, `docs-agent`
- `performance`, `performance-agent`
- `devops`, `devops-agent` (should be `devops-orchestrator`)

### 3. File Integrity Validation

**Check all required framework files:**

```yaml
required_files:
  root:
    - CLAUDE.md
    - README.md
    - .gitignore

  agents:
    count: 18
    pattern: "agents/*.md"

  commands:
    - commands/delegate.md

  hooks:
    critical:
      - hooks/zero-tolerance-quality.json
      - hooks/test-coverage-enforcer.json
      - hooks/delegation-enforcement.yaml

    high_priority:
      - hooks/agent-health-monitor.json
      - hooks/orchestration-scope-limiter.json
      - hooks/role-resolution.json
      - hooks/agent-capability-registry.json
      - hooks/technology-detection.json
      - hooks/agent-performance-sla.json
      - hooks/progressive-escalation.json

    specialist:
      - hooks/java-expert-configuration.json
      - hooks/database-specialist-validation.json
      - hooks/frontend-specialist-standards.json
      - hooks/security-specialist-audit.json
      - hooks/uiux-specialist-validation.json
```

### 4. JSON/YAML Syntax Validation

**Validate all configuration files:**

```bash
# Validate JSON files
for file in hooks/*.json; do
  jq empty "$file" 2>&1 || echo "ERROR: Invalid JSON in $file"
done

# Validate YAML files
for file in hooks/*.yaml; do
  python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>&1 || echo "ERROR: Invalid YAML in $file"
done
```

### 5. Cross-Reference Validation

**Verify coordination between components:**

```yaml
checks:
  - name: "Hook coordination"
    validate: All hooks listed in "coordinates_with" actually exist
    files: hooks/*.json, hooks/*.yaml

  - name: "Agent capability registry"
    validate: All agents have entries in agent-capability-registry.json
    files: hooks/agent-capability-registry.json

  - name: "Technology detection"
    validate: All language experts have technology patterns
    files: hooks/technology-detection.json

  - name: "Health monitor coverage"
    validate: All agents listed in agent-health-monitor.json
    files: hooks/agent-health-monitor.json
```

## Implementation Steps

### Step 1: Run Automated Validation

```bash
# Create validation script
cat > scripts/validate-framework.sh << 'EOF'
#!/bin/bash

set -e

echo "🔍 Claude Code Framework Validation"
echo "===================================="
echo ""

ERRORS=0
WARNINGS=0

# Define expected agents
EXPECTED_AGENTS=(
  "rust-expert" "csharp-expert" "go-expert" "java-expert"
  "python-expert" "typescript-expert" "bash-expert" "powershell-expert"
  "database-specialist" "frontend-specialist" "security-specialist" "uiux-specialist"
  "devops-orchestrator" "system-architect" "comprehensive-analyst"
  "code-review-gatekeeper" "technical-docs-writer" "product-owner"
)

echo "✓ Checking agent files..."
for agent in "${EXPECTED_AGENTS[@]}"; do
  if [ ! -f "agents/${agent}.md" ]; then
    echo "  ❌ ERROR: Missing agent file: agents/${agent}.md"
    ((ERRORS++))
  fi
done

echo "✓ Validating CLAUDE.md..."
for agent in "${EXPECTED_AGENTS[@]}"; do
  if ! grep -q "$agent" CLAUDE.md; then
    echo "  ⚠️  WARNING: Agent '$agent' not found in CLAUDE.md"
    ((WARNINGS++))
  fi
done

echo "✓ Validating README.md..."
if grep -q "11 specialized agents" README.md || grep -q "11 agents" README.md; then
  echo "  ❌ ERROR: README.md still references '11 agents' instead of 18"
  ((ERRORS++))
fi

echo "✓ Validating JSON syntax..."
for file in hooks/*.json; do
  if ! jq empty "$file" 2>/dev/null; then
    echo "  ❌ ERROR: Invalid JSON in $file"
    ((ERRORS++))
  fi
done

echo "✓ Checking for old agent references..."
OLD_AGENTS=("maker-agent" "test-agent" "debug-agent" "reader-agent" "plan-agent")
for file in hooks/*.json hooks/*.yaml; do
  for old_agent in "${OLD_AGENTS[@]}"; do
    if grep -q "$old_agent" "$file" 2>/dev/null; then
      echo "  ❌ ERROR: Old agent reference '$old_agent' found in $file"
      ((ERRORS++))
    fi
  done
done

echo ""
echo "===================================="
echo "📊 Validation Results:"
echo "  Errors: $ERRORS"
echo "  Warnings: $WARNINGS"
echo ""

if [ $ERRORS -eq 0 ]; then
  echo "✅ Framework validation PASSED"
  exit 0
else
  echo "❌ Framework validation FAILED"
  exit 1
fi
EOF

chmod +x scripts/validate-framework.sh
./scripts/validate-framework.sh
```

### Step 2: Generate Health Report

```yaml
health_report:
  timestamp: "2025-11-16T14:49:00Z"
  framework_version: "3.0"

  summary:
    overall_health: 95  # 0-100 score
    critical_issues: 0
    high_issues: 0
    medium_issues: 2
    low_issues: 5

  agent_alignment:
    status: "PASS"
    total_agents: 18
    configured_agents: 18
    missing_agents: []
    orphaned_agents: []

  hook_consistency:
    status: "PASS"
    total_hooks: 28
    valid_hooks: 28
    invalid_references: 0
    old_agent_names: 0

  file_integrity:
    status: "PASS"
    missing_files: []
    syntax_errors: 0

  recommendations:
    - "Consider adding performance monitoring skill"
    - "Update hook documentation with new agent structure"
    - "Add integration tests for multi-agent workflows"
```

### Step 3: Remediation Actions

**For detected issues, provide specific remediation:**

```yaml
critical_issues:
  - issue: "Missing agent file: agents/java-expert.md"
    severity: "CRITICAL"
    impact: "Java delegation will fail"
    remediation:
      - "Create agents/java-expert.md with proper frontmatter"
      - "Add Java-specific expertise and responsibilities"
      - "Update CLAUDE.md to reference java-expert"
    auto_fixable: false

  - issue: "Hook references old 'maker-agent' instead of implementation expert"
    severity: "CRITICAL"
    impact: "Hook will fail to activate"
    remediation:
      - "Update hooks/zero-tolerance-quality.json"
      - "Replace 'maker-agent' with appropriate expert (rust-expert, etc.)"
      - "Verify agent responsibilities section"
    auto_fixable: true
    auto_fix_command: "sed -i 's/maker-agent/implementation-experts/g' hooks/zero-tolerance-quality.json"

high_issues:
  - issue: "README.md references '11 agents' instead of 18"
    severity: "HIGH"
    impact: "Documentation misleading"
    remediation:
      - "Update all '11 agents' references to '18 agents'"
      - "Update agent architecture table"
      - "Verify agent file list"
    auto_fixable: true
```

## Output Format

```json
{
  "validation_results": {
    "timestamp": "2025-11-16T14:49:00Z",
    "framework_version": "3.0",
    "overall_health_score": 95,
    "status": "PASS",

    "checks": {
      "agent_alignment": {
        "status": "PASS",
        "details": {
          "expected_count": 18,
          "found_count": 18,
          "missing": [],
          "orphaned": []
        }
      },
      "hook_consistency": {
        "status": "PASS",
        "details": {
          "total_hooks": 28,
          "valid_references": 28,
          "invalid_references": 0,
          "old_agent_names_found": 0
        }
      },
      "file_integrity": {
        "status": "PASS",
        "details": {
          "missing_files": 0,
          "syntax_errors": 0
        }
      }
    },

    "issues": {
      "critical": [],
      "high": [],
      "medium": [
        {
          "category": "documentation",
          "description": "Hook documentation could be more detailed",
          "affected_files": ["hooks/README.md"],
          "remediation": "Add usage examples and integration patterns"
        }
      ],
      "low": []
    },

    "recommendations": [
      "Framework is healthy and well-aligned",
      "Consider adding automated validation to CI/CD pipeline",
      "Update hook documentation with integration examples"
    ]
  }
}
```

## Success Criteria

- ✅ All 18 agents have valid configuration files
- ✅ All hooks reference current agent names
- ✅ No old agent names (maker, test, debug) in any hook
- ✅ CLAUDE.md, README.md, and delegate.md aligned
- ✅ All JSON/YAML files have valid syntax
- ✅ All cross-references are valid
- ✅ Overall health score > 90%

## Integration

This skill coordinates with:
- `agent-health-monitor` - Uses health metrics
- `zero-tolerance-quality` - Validates quality gate configuration
- CI/CD pipelines - Can be integrated as pre-deployment check

## Usage Examples

### Basic Health Check

```bash
# Run framework validation
claude "/framework-validator"

# Expected output:
# 🔍 Validating framework...
# ✅ Agent alignment: PASS (18/18 agents)
# ✅ Hook consistency: PASS (28 hooks)
# ✅ File integrity: PASS
# 📊 Overall Health Score: 95/100
# ✅ Framework is healthy
```

### Detailed Validation

```bash
# Run with detailed output
claude "/framework-validator --detailed"

# Expected output includes:
# - Per-agent validation status
# - Per-hook validation details
# - Cross-reference validation
# - Recommendations for improvements
```

### Auto-Fix Mode

```bash
# Run validation with automatic fixes
claude "/framework-validator --auto-fix"

# Will automatically:
# - Fix old agent name references
# - Update version numbers
# - Regenerate health reports
```
