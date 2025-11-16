---
name: hook-auditor
description: Audit hook coverage, consistency, and effectiveness
category: operational
priority: medium
author: framework-team
tags: [audit, hooks, coverage, quality-gates, compliance]
---

# Hook Auditor Skill

## Purpose

Comprehensive auditing tool for the framework's validation hook system, ensuring complete coverage, configuration consistency, and effective quality enforcement across all 18 agents.

## When to Use

- After adding/modifying hooks
- Before major releases
- During framework health reviews
- When investigating quality gate failures
- For compliance verification
- During framework migrations

## Audit Scope

### 1. Coverage Audit

**Objective:** Verify every agent has appropriate validation hooks

**Audit Steps:**

```bash
# List all agents
AGENTS=($(ls -1 agents/*.md | xargs -n1 basename | sed 's/\.md$//'))

# Check for corresponding hooks
for agent in "${AGENTS[@]}"; do
  hooks=$(ls -1 hooks/${agent}*.json 2>/dev/null | wc -l)
  if [ $hooks -eq 0 ]; then
    echo "❌ Missing hook for: $agent"
  else
    echo "✅ $agent: $hooks hook(s) found"
  fi
done
```

**Expected Coverage:**
- 18/18 agents with validation hooks (100%)
- Each agent has 1+ dedicated hook files
- Hook naming follows convention: `{agent}-validation.json`

**Report Format:**
```
HOOK COVERAGE AUDIT REPORT
═══════════════════════════════════════

✅ COMPLETE COVERAGE (18/18)
   Language Experts: 8/8 ✓
   Domain Specialists: 4/4 ✓
   Infrastructure: 1/1 ✓
   Architecture & Planning: 2/2 ✓
   Quality & Analysis: 3/3 ✓

HOOK INVENTORY (44 total)
   Agent-Specific: 18
   Framework-Wide: 26

COVERAGE: 100% ✅
```

### 2. Consistency Audit

**Objective:** Ensure hooks follow framework standards

**Checks:**

#### Required Hook Fields
```json
{
  "name": "string (required)",
  "version": "semver (required)",
  "description": "string (required)",
  "priority": "critical|high|medium|low (required)",
  "agents": ["array (required)"],
  "triggers": ["array (required)"],
  "validation_sequence": {} || "checks": []
}
```

#### Validation Script
```bash
for hook in hooks/*.json; do
  echo "Auditing: $(basename $hook)"

  # Check required fields
  jq -e '.name' "$hook" > /dev/null || echo "  ❌ Missing: name"
  jq -e '.description' "$hook" > /dev/null || echo "  ❌ Missing: description"
  jq -e '.agents' "$hook" > /dev/null || echo "  ❌ Missing: agents"
  jq -e '.triggers' "$hook" > /dev/null || echo "  ❌ Missing: triggers"

  # Validate agents array
  invalid=$(jq -r '.agents[]' "$hook" 2>/dev/null | while read agent; do
    if [ ! -f "agents/${agent}.md" ]; then
      echo "$agent"
    fi
  done)

  if [ -n "$invalid" ]; then
    echo "  ❌ Invalid agents: $invalid"
  fi
done
```

**Report Format:**
```
CONSISTENCY AUDIT REPORT
═══════════════════════════════════════

FIELD VALIDATION
  ✅ All hooks have 'name'
  ✅ All hooks have 'description'
  ✅ All hooks have 'agents' array
  ✅ All hooks have 'triggers' array
  ⚠️  3 hooks missing 'priority'

AGENT REFERENCES
  ✅ All referenced agents exist
  ✅ No invalid agent names
  ❌ 1 hook references deprecated agent 'maker'

JSON SYNTAX
  ✅ All 44 hooks valid JSON
  ❌ 1 YAML file has indentation issues

CONSISTENCY: 95% (minor issues found)
```

### 3. Effectiveness Audit

**Objective:** Measure how well hooks enforce quality

**Metrics:**

#### Quality Gate Pass Rates
```json
{
  "pre_commit": {
    "executions": 487,
    "passed": 470,
    "failed": 17,
    "pass_rate": 0.965
  },
  "pre_push": {
    "executions": 124,
    "passed": 117,
    "failed": 7,
    "pass_rate": 0.944
  },
  "pre_release": {
    "executions": 12,
    "passed": 12,
    "failed": 0,
    "pass_rate": 1.000
  }
}
```

#### Hook Effectiveness Scoring
```
Hook Effectiveness = (Pass Rate × 0.4) +
                    (Coverage × 0.3) +
                    (Configuration Quality × 0.2) +
                    (Performance × 0.1)
```

**Report Format:**
```
EFFECTIVENESS AUDIT REPORT
═══════════════════════════════════════

QUALITY GATE PERFORMANCE
  Pre-commit: 96.5% pass rate ✅
  Pre-push: 94.4% pass rate ✅
  Pre-release: 100% pass rate ✅

TOP PERFORMING HOOKS
  1. rust-expert-validation (100%, 0.8s avg)
  2. bash-expert-validation (100%, 0.5s avg)
  3. go-expert-validation (99%, 1.2s avg)

UNDERPERFORMING HOOKS
  1. typescript-expert-validation (88%, 8.2s avg)
     Issue: Node modules installation slow
  2. devops-orchestrator-validation (91%, 12.1s avg)
     Issue: Terraform validation timeout

EFFECTIVENESS SCORE: 94/100 ✅
```

### 4. Integration Audit

**Objective:** Verify hooks properly integrate with framework

**Checks:**

#### Hook Dependencies
```bash
# Check for circular dependencies
# Extract all hooks that reference other hooks
for hook in hooks/*.json; do
  deps=$(jq -r '.depends_on[]?' "$hook" 2>/dev/null)
  if [ -n "$deps" ]; then
    echo "$(basename $hook): $deps"
  fi
done | sort
```

#### Agent Integration
```bash
# Verify hooks reference valid agents
for hook in hooks/*.json; do
  agents=$(jq -r '.agents[]' "$hook")
  for agent in $agents; do
    if [ ! -f "agents/${agent}.md" ]; then
      echo "❌ $(basename $hook) references missing agent: $agent"
    fi
  done
done
```

#### Trigger Validation
```bash
# Check trigger patterns are recognized
VALID_TRIGGERS=(
  "code_change" "file_modification" "pre_commit" "pre_push"
  "pre_release" "dependency_update" "security_scan"
)

for hook in hooks/*.json; do
  triggers=$(jq -r '.triggers[]' "$hook")
  for trigger in $triggers; do
    if ! [[ " ${VALID_TRIGGERS[@]} " =~ " ${trigger} " ]]; then
      echo "⚠️  $(basename $hook) has unknown trigger: $trigger"
    fi
  done
done
```

**Report Format:**
```
INTEGRATION AUDIT REPORT
═══════════════════════════════════════

DEPENDENCY ANALYSIS
  ✅ No circular dependencies
  ✅ All dependencies resolvable
  ⚠️  2 hooks with complex dependency chains

AGENT INTEGRATION
  ✅ All agent references valid
  ✅ No orphaned hooks (hooks without agents)
  ✅ No agents without hooks

TRIGGER VALIDATION
  ✅ All triggers recognized
  ⚠️  3 hooks use custom triggers (documented)

INTEGRATION: 98% (excellent)
```

### 5. Security Audit

**Objective:** Ensure hooks enforce security standards

**Checks:**

#### Security Coverage
- Do all agents have security scanning?
- Are vulnerability checks blocking?
- Is credential scanning enabled?
- Are dependency audits configured?

#### Security Hook Analysis
```bash
# Find hooks with security phases
grep -l "security" hooks/*-validation.json | wc -l

# Check for required security tools
for hook in hooks/*-validation.json; do
  security_tools=$(jq -r '.tools_required.recommended[]' "$hook" | \
    grep -i "security\|audit\|scan" || true)
  if [ -z "$security_tools" ]; then
    echo "⚠️  $(basename $hook) has no security tools"
  fi
done
```

**Report Format:**
```
SECURITY AUDIT REPORT
═══════════════════════════════════════

SECURITY PHASE COVERAGE
  ✅ 18/18 agents have security phases
  ✅ All security phases are blocking
  ✅ Vulnerability scanning required

SECURITY TOOLS
  ✅ Dependency scanning: 18/18
  ✅ Static analysis: 15/18
  ⚠️  3 agents missing SAST tools
  ✅ Secret detection: 18/18

COMPLIANCE
  ✅ OWASP Top 10 addressed
  ✅ CWE coverage adequate
  ✅ CVE scanning enabled

SECURITY: 95% (minor gaps)
```

### 6. Performance Audit

**Objective:** Identify slow or inefficient hooks

**Metrics:**

#### Execution Time Analysis
```bash
# Analyze hook timeouts
for hook in hooks/*-validation.json; do
  phases=$(jq -r '.validation_sequence | keys[]' "$hook" 2>/dev/null)
  for phase in $phases; do
    timeout=$(jq -r ".validation_sequence.${phase}.timeout_seconds" "$hook")
    if [ "$timeout" -gt 300 ]; then
      echo "⚠️  $(basename $hook):$phase has long timeout: ${timeout}s"
    fi
  done
done
```

#### Resource Usage
```json
{
  "hook_name": "typescript-expert-validation",
  "avg_execution_time": 8.2,
  "p95_execution_time": 15.3,
  "timeout_rate": 0.02,
  "resource_intensive": true,
  "optimization_potential": "high"
}
```

**Report Format:**
```
PERFORMANCE AUDIT REPORT
═══════════════════════════════════════

EXECUTION TIME STATISTICS
  Avg Hook Time: 3.2s
  Median: 2.1s
  P95: 8.5s
  P99: 15.2s

SLOW HOOKS (>5s avg)
  1. system-architect-validation: 8.1s
  2. devops-orchestrator-validation: 5.5s
  3. csharp-expert-validation: 5.2s

OPTIMIZATION OPPORTUNITIES
  ✓ Parallelize validation phases (3 hooks)
  ✓ Cache validation results (5 hooks)
  ✓ Reduce timeout values (2 hooks)

PERFORMANCE: 88% (good, can improve)
```

## Comprehensive Audit Report

### Full Audit Execution

```bash
# Run all audits
./skills/hook-auditor.sh --full-audit

# Or manual execution
coverage_audit
consistency_audit
effectiveness_audit
integration_audit
security_audit
performance_audit
```

### Combined Report

```
═══════════════════════════════════════════════════════════
COMPREHENSIVE HOOK AUDIT REPORT
Generated: 2025-11-16 15:45 UTC
═══════════════════════════════════════════════════════════

EXECUTIVE SUMMARY
  Overall Hook Health: 🟢 95/100 (Excellent)

  Coverage: 100% ✅
  Consistency: 95% ✅
  Effectiveness: 94% ✅
  Integration: 98% ✅
  Security: 95% ✅
  Performance: 88% ✅

═══════════════════════════════════════════════════════════
1. COVERAGE AUDIT
═══════════════════════════════════════════════════════════
  Agent Coverage: 18/18 (100%) ✅
  Total Hooks: 44
  Agent-Specific: 18
  Framework-Wide: 26

  ✅ All agents have validation hooks
  ✅ No coverage gaps identified

═══════════════════════════════════════════════════════════
2. CONSISTENCY AUDIT
═══════════════════════════════════════════════════════════
  JSON Syntax: 44/44 valid ✅
  Required Fields: 42/44 complete (95%)
  Agent References: 100% valid ✅

  ⚠️  MINOR ISSUES (2)
    • 2 hooks missing 'version' field

  Recommendation: Add version field to all hooks

═══════════════════════════════════════════════════════════
3. EFFECTIVENESS AUDIT
═══════════════════════════════════════════════════════════
  Pre-commit Pass Rate: 96.5% ✅
  Pre-push Pass Rate: 94.4% ✅
  Pre-release Pass Rate: 100% ✅

  Top Performers: rust-expert, bash-expert, go-expert
  Needs Attention: typescript-expert (88% pass rate)

  Recommendation: Investigate typescript-expert failures

═══════════════════════════════════════════════════════════
4. INTEGRATION AUDIT
═══════════════════════════════════════════════════════════
  Agent Integration: 100% ✅
  Dependency Resolution: 100% ✅
  Trigger Validation: 97% ✅

  ⚠️  3 hooks use custom triggers (acceptable)

  Recommendation: Document custom triggers

═══════════════════════════════════════════════════════════
5. SECURITY AUDIT
═══════════════════════════════════════════════════════════
  Security Phase Coverage: 100% ✅
  Vulnerability Scanning: 100% ✅
  SAST Coverage: 83% (15/18)
  Secret Detection: 100% ✅

  ⚠️  3 agents missing static security analysis

  Recommendation: Add SAST to remaining agents

═══════════════════════════════════════════════════════════
6. PERFORMANCE AUDIT
═══════════════════════════════════════════════════════════
  Avg Execution Time: 3.2s ✅
  Timeout Rate: 1.8% ✅
  Optimization Potential: Medium

  Slow Hooks: 3 identified (>5s avg)

  Recommendation: Optimize 3 slow hooks

═══════════════════════════════════════════════════════════
RECOMMENDATIONS
═══════════════════════════════════════════════════════════

HIGH PRIORITY
  1. Investigate typescript-expert validation failures
  2. Add version field to 2 hooks

MEDIUM PRIORITY
  3. Add SAST to 3 agents without static analysis
  4. Optimize 3 hooks with >5s execution time
  5. Document 3 custom trigger patterns

LOW PRIORITY
  6. Consider caching for frequently-run validations
  7. Review and update hook timeouts

═══════════════════════════════════════════════════════════
CONCLUSION
═══════════════════════════════════════════════════════════

The hook system is in excellent health with 95/100 overall score.
Minor improvements recommended but no critical issues found.

Next Audit Recommended: 30 days
```

## Audit Automation

### Scheduled Audits

```bash
# Weekly audit (cron)
0 9 * * 1 /path/to/hook-auditor.sh --weekly

# Monthly comprehensive audit
0 9 1 * * /path/to/hook-auditor.sh --full-audit --export

# Pre-release audit
# Run manually before major releases
./hook-auditor.sh --full-audit --strict
```

### CI/CD Integration

```yaml
# .github/workflows/hook-audit.yml
name: Hook Audit
on:
  push:
    paths:
      - 'hooks/**'
      - 'agents/**'
jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Hook Auditor
        run: |
          chmod +x skills/hook-auditor.sh
          ./skills/hook-auditor.sh --ci
      - name: Upload Report
        uses: actions/upload-artifact@v3
        with:
          name: hook-audit-report
          path: hook-audit-report.md
```

## Compliance Verification

### Regulatory Compliance

**Check hooks enforce:**
- SOC 2 controls
- PCI-DSS requirements
- HIPAA safeguards
- GDPR data protection
- ISO 27001 standards

### Industry Standards

**Verify alignment with:**
- OWASP ASVS
- CIS Benchmarks
- NIST guidelines
- SANS Top 25

## Best Practices

### Regular Auditing
- Run coverage audit after any hook changes
- Full audit monthly
- Performance audit weekly
- Security audit quarterly

### Documentation
- Document all custom configurations
- Maintain audit history
- Track remediation actions
- Update compliance records

### Continuous Improvement
- Address audit findings promptly
- Track metrics over time
- Optimize based on performance data
- Update hooks as tools evolve

## Integration with Framework

Works with:
- `/validate-hooks` - Quick validation
- `/analyze-framework` - Overall health
- `/quality-report` - Historical metrics
- Framework validation scripts

## Summary

The Hook Auditor skill provides systematic auditing of:
- Hook coverage completeness
- Configuration consistency
- Quality enforcement effectiveness
- Framework integration
- Security compliance
- Performance optimization

Use regularly to maintain hook system health and effectiveness.
