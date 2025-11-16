---
name: validate-hooks
description: Validate hook coverage, consistency, and configuration
tags: [hooks, validation, quality-gates, coverage]
---

# Validate Hooks Command

## Purpose

Comprehensive validation of the framework's hook system, checking for coverage gaps, configuration errors, old agent references, and JSON syntax issues.

## Usage

```
/validate-hooks [--coverage] [--syntax] [--references] [--all]
```

**Options:**
- `--coverage`: Check hook coverage for all agents (default)
- `--syntax`: Validate JSON/YAML syntax only
- `--references`: Check for old agent name references
- `--all`: Run all validation checks (coverage + syntax + references)

## Validation Checks

### 1. Hook Coverage Analysis

Verifies each of the 18 agents has appropriate validation hooks:

**Expected Hook Naming Patterns:**
- `{agent}-validation.json`
- `{agent}-configuration.json`
- `{agent}-standards.json`
- `{agent}-audit.json`

**Coverage Report:**
```
🔍 Hook Coverage Analysis
═══════════════════════════════════════

✅ LANGUAGE EXPERTS (8/8 = 100%)
   ✅ rust-expert         → rust-expert-validation.json
   ✅ csharp-expert       → csharp-expert-validation.json
   ✅ go-expert           → go-expert-validation.json
   ✅ java-expert         → java-expert-configuration.json
   ✅ python-expert       → python-expert-validation.json
   ✅ typescript-expert   → typescript-expert-validation.json
   ✅ bash-expert         → bash-expert-validation.json
   ✅ powershell-expert   → powershell-expert-validation.json

✅ DOMAIN SPECIALISTS (4/4 = 100%)
   ✅ database-specialist → database-specialist-validation.json
   ✅ frontend-specialist → frontend-specialist-standards.json
   ✅ security-specialist → security-specialist-audit.json
   ✅ uiux-specialist     → uiux-specialist-validation.json

✅ INFRASTRUCTURE (1/1 = 100%)
   ✅ devops-orchestrator → devops-orchestrator-validation.json

✅ ARCHITECTURE & PLANNING (2/2 = 100%)
   ✅ system-architect    → system-architect-validation.json
   ✅ product-owner       → product-owner-validation.json

✅ QUALITY & ANALYSIS (3/3 = 100%)
   ✅ comprehensive-analyst     → comprehensive-analyst-validation.json
   ✅ code-review-gatekeeper    → code-review-gatekeeper-validation.json
   ✅ technical-docs-writer     → technical-docs-writer-validation.json

📊 SUMMARY
   Total Agents: 18
   Agents with Hooks: 18
   Coverage: 100% ✅

   Total Hooks: 44
   Agent-Specific: 18
   Framework-Wide: 26
```

### 2. JSON/YAML Syntax Validation

Validates syntax for all hook files:

```bash
# JSON validation
for file in hooks/*.json; do
  jq empty "$file" 2>/dev/null || echo "❌ Invalid JSON: $file"
done

# YAML validation (if applicable)
for file in hooks/*.yaml hooks/*.yml; do
  yamllint "$file" 2>/dev/null || echo "❌ Invalid YAML: $file"
done
```

**Output:**
```
🔍 Syntax Validation
═══════════════════════

Validating 43 JSON files...
✅ agent-capability-registry.json
✅ agent-coordination.json
✅ agent-health-monitor.json
... (all hooks) ...
✅ zero-tolerance-quality.json

Validating 1 YAML file...
✅ delegation-enforcement.yaml

📊 RESULTS
   Total Files: 44
   Valid JSON: 43/43 ✅
   Valid YAML: 1/1 ✅
   Errors: 0
```

### 3. Old Agent Reference Detection

Scans for deprecated agent names that should no longer be used:

**Old Names to Detect:**
- `maker` / `maker-agent`
- `test` / `test-agent`
- `debug` / `debug-agent`
- `reader` / `reader-agent`
- `plan` / `plan-agent`
- `security` / `security-agent` (should be `security-specialist`)
- `docs` / `docs-agent` (should be `technical-docs-writer`)
- `orchestrator` (should be `devops-orchestrator`)
- `rust-systems-expert` (should be `rust-expert`)

**Scan Locations:**
- hooks/*.json
- hooks/*.yaml
- claude.json
- commands/*.md

**Output:**
```
🔍 Old Agent Reference Detection
═════════════════════════════════════

Scanning hooks/ directory...
✅ No references to 'maker'
✅ No references to 'test-agent'
✅ No references to 'debug'
✅ No references to 'reader'
✅ No references to 'plan-agent'
✅ No references to 'security-agent'
✅ No references to 'docs-agent'
✅ No references to 'rust-systems-expert'

Scanning claude.json...
✅ All agent names current

Scanning commands/...
✅ All command references current

📊 RESULTS
   Files Scanned: 48
   Old References Found: 0 ✅
```

### 4. Hook Configuration Validation

Validates hook structure and required fields:

**For Each Hook File:**
- ✅ Has `name` field
- ✅ Has `description` field
- ✅ Has `agents` array with valid agent names
- ✅ Has `triggers` array
- ✅ Has `validation_sequence` or `checks`
- ✅ Agent names in `agents` array exist in framework
- ✅ No duplicate hook names

**Output:**
```
🔍 Hook Structure Validation
══════════════════════════════

Validating hook configurations...

rust-expert-validation.json
  ✅ Required fields present
  ✅ Agents valid: [rust-expert, code-review-gatekeeper, ...]
  ✅ 7 validation phases defined
  ✅ Quality gates configured

... (all hooks) ...

📊 RESULTS
   Hooks Validated: 44
   Structural Issues: 0 ✅
   Invalid Agent References: 0 ✅
```

### 5. Hook Integration Check

Verifies hooks properly integrate with framework:

**Checks:**
- Hooks reference agents that exist in claude.json
- Agent files exist for all referenced agents
- No circular dependencies between hooks
- Hook priorities don't conflict
- Trigger patterns are valid

**Output:**
```
🔍 Hook Integration Check
═══════════════════════════

Checking agent existence...
  ✅ All 18 agents exist
  ✅ All referenced agents valid

Checking for circular dependencies...
  ✅ No circular dependencies detected

Checking trigger patterns...
  ✅ All trigger patterns valid

📊 RESULTS
   Integration Issues: 0 ✅
   Warnings: 0
```

### 6. Coverage Gap Analysis

Identifies potential coverage gaps:

**Analysis:**
- Agents without validation hooks
- File types without associated hooks
- Quality dimensions not covered
- Missing best practice hooks

**Output:**
```
🔍 Coverage Gap Analysis
═══════════════════════════

Checking for coverage gaps...

Agent Coverage:
  ✅ All 18 agents have validation hooks

File Type Coverage:
  ✅ .rs   → rust-expert-validation
  ✅ .cs   → csharp-expert-validation
  ✅ .go   → go-expert-validation
  ✅ .java → java-expert-configuration
  ✅ .py   → python-expert-validation
  ✅ .ts   → typescript-expert-validation
  ✅ .sh   → bash-expert-validation
  ✅ .ps1  → powershell-expert-validation
  ✅ .sql  → database-specialist-validation
  ✅ .yaml → devops-orchestrator-validation
  ✅ .md   → technical-docs-writer-validation

Quality Dimensions:
  ✅ Compilation/Build
  ✅ Linting/Formatting
  ✅ Testing
  ✅ Security
  ✅ Performance
  ✅ Documentation
  ✅ Best Practices

📊 RESULTS
   Coverage Gaps: 0 ✅
   Recommendations: 0
```

## Detailed Output (--all)

When run with `--all`, produces comprehensive report:

```
═══════════════════════════════════════════════════════════
🔍 COMPREHENSIVE HOOK VALIDATION REPORT
═══════════════════════════════════════════════════════════

1. HOOK COVERAGE ANALYSIS
   ├─ Agent Coverage: 18/18 (100%) ✅
   ├─ Language Experts: 8/8 ✅
   ├─ Domain Specialists: 4/4 ✅
   ├─ Infrastructure: 1/1 ✅
   ├─ Architecture & Planning: 2/2 ✅
   └─ Quality & Analysis: 3/3 ✅

2. SYNTAX VALIDATION
   ├─ JSON Files: 43/43 valid ✅
   ├─ YAML Files: 1/1 valid ✅
   └─ Parse Errors: 0 ✅

3. AGENT REFERENCE VALIDATION
   ├─ Old Agent Names: 0 found ✅
   ├─ Invalid References: 0 found ✅
   └─ Deprecated Names: 0 found ✅

4. HOOK STRUCTURE VALIDATION
   ├─ Required Fields: All present ✅
   ├─ Agent Name Validation: All valid ✅
   ├─ Trigger Patterns: All valid ✅
   └─ Configuration Issues: 0 found ✅

5. INTEGRATION VALIDATION
   ├─ Agent Existence: All verified ✅
   ├─ Circular Dependencies: None ✅
   ├─ Priority Conflicts: None ✅
   └─ Integration Issues: 0 ✅

6. COVERAGE GAP ANALYSIS
   ├─ Uncovered Agents: 0 ✅
   ├─ Missing File Types: 0 ✅
   ├─ Quality Dimension Gaps: 0 ✅
   └─ Recommendations: 0

═══════════════════════════════════════════════════════════
📊 OVERALL VALIDATION STATUS: ✅ PASS
═══════════════════════════════════════════════════════════

All validation checks passed successfully!
Hook system is properly configured and comprehensive.

Total Hooks: 44
  • Agent-specific: 18 (100% coverage)
  • Framework-wide: 26
  • Issues Found: 0
  • Warnings: 0

Framework Health: 🟢 EXCELLENT
```

## Common Issues and Fixes

### Issue 1: Missing Hook for Agent

```
❌ Agent 'custom-agent' has no validation hook

Fix:
  1. Create hooks/custom-agent-validation.json
  2. Or add agent to existing hook's agents array
  3. Or mark as intentionally unvalidated in documentation
```

### Issue 2: Invalid JSON Syntax

```
❌ Invalid JSON syntax: hooks/broken-hook.json
   Line 42: Expected ',' but found '}'

Fix:
  Run: jq . hooks/broken-hook.json
  Fix syntax error at indicated line
```

### Issue 3: Old Agent Reference

```
⚠️  Found old agent name 'maker' in hooks/legacy-hook.json:15

Fix:
  Replace 'maker' with appropriate language expert:
  - For Rust → 'rust-expert'
  - For Python → 'python-expert'
  - For TypeScript → 'typescript-expert'
  etc.
```

### Issue 4: Invalid Agent Reference

```
❌ Hook references non-existent agent: 'unknown-agent'
   File: hooks/broken-hook.json
   Line: 8

Fix:
  Update agent name to one of the 18 valid agents
  or remove the invalid reference
```

## Quick Commands

```bash
# Quick coverage check
/validate-hooks

# Just syntax validation
/validate-hooks --syntax

# Find old agent names
/validate-hooks --references

# Comprehensive validation
/validate-hooks --all

# Check specific aspect
/validate-hooks --coverage
```

## Integration

Works with:
- `/analyze-framework` - Overall framework health
- `/list-agents` - See all agents
- `./scripts/validate-hooks.sh` - Scriptable validation

## Implementation

Uses framework validation scripts:

```bash
# Direct script usage
cd /path/to/claude-agentic-framework
./scripts/validate-hooks.sh

# Expected output
✅ Hook validation passed
```

## Exit Codes

- `0` - All validations passed
- `1` - Syntax errors found
- `2` - Coverage gaps detected
- `3` - Old agent references found
- `4` - Configuration errors
- `5` - Multiple errors

## Notes

- Validation is non-destructive (read-only)
- Safe to run at any time
- Recommended to run after:
  - Adding new hooks
  - Modifying existing hooks
  - Updating agent configurations
  - Framework migrations
- Part of CI/CD quality gates
- Results cached for 5 minutes
