---
name: quality-report
description: Generate comprehensive quality metrics and reports
tags: [quality, metrics, reporting, analytics, kpi]
---

# Quality Report Command

## Purpose

Generate comprehensive quality metrics reports for the framework, including code quality, test coverage, validation results, agent performance, and trend analysis.

## Usage

```
/quality-report [period] [--format=<markdown|json|html>] [--export]
```

**Periods:**
- `today`: Today's metrics
- `week`: Last 7 days
- `month`: Last 30 days
- `all`: Complete history (default)

**Formats:**
- `markdown`: Human-readable report (default)
- `json`: Machine-readable data
- `html`: Interactive HTML dashboard
- `csv`: Spreadsheet format for analysis

**Options:**
- `--export`: Save report to file
- `--baseline`: Compare against baseline metrics
- `--trends`: Include trend analysis and forecasts

## Report Sections

### 1. Executive Summary

```markdown
# Quality Report: Claude Code CLI Agentic Framework
**Period:** Last 30 Days (Oct 17 - Nov 16, 2025)
**Generated:** Nov 16, 2025 15:30 UTC

## 📊 Executive Summary

### Overall Quality Score: 🟢 95/100 (Excellent)

| Metric Category | Score | Trend | Status |
|----------------|-------|-------|--------|
| Code Quality | 94/100 | 📈 +3% | ✅ Excellent |
| Test Coverage | 87/100 | → 0% | ✅ Good |
| Security | 98/100 | → 0% | ✅ Excellent |
| Performance | 92/100 | 📈 +5% | ✅ Excellent |
| Documentation | 91/100 | 📈 +2% | ✅ Excellent |
| Agent Efficiency | 96/100 | 📈 +4% | ✅ Excellent |

### Key Highlights
✅ 100% hook coverage achieved (18/18 agents)
✅ Zero critical security vulnerabilities
✅ 97.3% average test success rate
✅ All quality gates passing
⚠️ 3 minor documentation gaps identified
```

### 2. Code Quality Metrics

```markdown
## 🔧 Code Quality

### Compilation & Build
- **Success Rate:** 99.8% (298/299 builds)
- **Failed Builds:** 1 (configuration error - resolved)
- **Avg Build Time:** 3.2s (target: <5s) ✅
- **Build Trends:** 📈 Improving (-12% time)

### Linting & Static Analysis
- **Total Files Analyzed:** 1,247
- **Linting Pass Rate:** 98.5%
- **Critical Issues:** 0 ✅
- **Warnings:** 18 (down from 32)
- **Style Violations:** 5 (auto-fixed)

### Code Complexity
- **Avg Cyclomatic Complexity:** 5.2 (target: <10) ✅
- **Functions >10 Complexity:** 12 (2% of total)
- **Max Complexity:** 18 (function: parseComplexConfig)
- **Code Duplication:** 2.1% (target: <5%) ✅

### Language-Specific Quality

| Language   | Files | Linting | Formatting | Type Check | Grade |
|------------|-------|---------|------------|------------|-------|
| Rust       | 87    | 100%    | 100%       | 100%       | A+ ✅  |
| TypeScript | 324   | 98%     | 100%       | 99%        | A ✅   |
| Python     | 156   | 97%     | 100%       | 95%        | A ✅   |
| Go         | 92    | 99%     | 100%       | N/A        | A+ ✅  |
| C#         | 118   | 98%     | 100%       | 98%        | A ✅   |
| Java       | 76    | 96%     | 100%       | 97%        | A ✅   |
| Shell      | 34    | 94%     | 98%        | N/A        | A- ✅  |
```

### 3. Test Coverage & Results

```markdown
## 🧪 Testing

### Test Execution
- **Total Tests:** 3,847
- **Passed:** 3,742 (97.3%) ✅
- **Failed:** 15 (0.4%)
- **Skipped:** 90 (2.3%)
- **Avg Execution Time:** 2.8 min

### Coverage by Type
| Test Type | Tests | Pass Rate | Coverage |
|-----------|-------|-----------|----------|
| Unit | 2,456 | 98.2% | 89% |
| Integration | 1,124 | 96.1% | 78% |
| E2E | 267 | 95.5% | 65% |

### Coverage by Component
- **Overall Coverage:** 82.4% (target: 70%) ✅
- **Agents:** 85.2%
- **Hooks:** 78.9%
- **Commands:** 92.1%
- **Skills:** 76.3%
- **Shared:** 88.7%

### Coverage Trends (30 Days)
```
85%  ┤                                         ╭─╮
84%  ┤                                     ╭───╯ │
83%  ┤                                 ╭───╯     │
82%  ┤                             ╭───╯         │
81%  ┤                         ╭───╯             │
80%  ┤                     ╭───╯                 │
79%  ┤                 ╭───╯                     │
78%  ┤─────────────────╯                         ╰
     Oct 17                                   Nov 16
```

### 4. Security Metrics

```markdown
## 🔒 Security

### Vulnerability Scanning
- **Critical:** 0 ✅
- **High:** 0 ✅
- **Medium:** 2 ⚠️ (under review)
- **Low:** 8 (informational)
- **Last Scan:** 2 hours ago

### Medium Severity Issues
1. **Dependency:** old-crypto-lib v1.2.3
   - **Impact:** Deprecated crypto algorithm
   - **Remediation:** Upgrade to v2.0.0
   - **Status:** PR #47 in review

2. **Configuration:** Loose CORS policy in dev
   - **Impact:** Development only, not production
   - **Remediation:** Tighten policy or add warning
   - **Status:** Tracked in issue #128

### Security Best Practices
- **Secrets in Code:** 0 detected ✅
- **Hardcoded Credentials:** 0 found ✅
- **SQL Injection Risks:** 0 found ✅
- **XSS Vulnerabilities:** 0 found ✅
- **OWASP Top 10:** All addressed ✅

### Dependency Security
- **Total Dependencies:** 342
- **Outdated:** 23 (6.7%)
- **Vulnerable:** 2 (0.6%)
- **Last Audit:** 2 hours ago
```

### 5. Performance Metrics

```markdown
## ⚡ Performance

### Agent Performance
- **Avg Response Time:** 3.8s (target: <5s) ✅
- **P95 Response Time:** 7.2s
- **P99 Response Time:** 12.1s
- **Success Rate:** 97.3%

### Performance by Agent Category
| Category | Avg Time | P95 | Success |
|----------|----------|-----|---------|
| Language Experts | 3.2s | 5.8s | 98.1% |
| Domain Specialists | 4.1s | 7.9s | 96.8% |
| Infrastructure | 5.5s | 11.2s | 95.2% |
| Architecture | 8.1s | 15.3s | 99.0% |
| Quality & Analysis | 4.2s | 8.1s | 97.5% |

### Resource Usage
- **Avg Tokens/Task:** 5,847
- **Total Tokens (30d):** 1,087,423
- **Token Efficiency:** 94% (baseline: 6,200 tokens)
- **Cache Hit Rate:** 42%

### Performance Trends
```
Avg Response Time (seconds)
5.0s ┤
4.5s ┤     ╭─╮
4.0s ┤ ╭───╯ ╰─╮  ╭─╮
3.5s ┤─╯        ╰──╯ ╰───╮
3.0s ┤                    ╰─────
     Oct 17                   Nov 16
```
```

### 6. Validation & Quality Gates

```markdown
## ✅ Quality Gates

### Hook Validation Results
- **Total Hooks:** 44
- **Active:** 44 (100%)
- **Passing:** 43 (97.7%)
- **Failing:** 1 (2.3%)

### Quality Gate Pass Rates
| Gate | Executions | Pass Rate | Avg Time |
|------|------------|-----------|----------|
| Pre-commit | 487 | 96.5% | 12s |
| Pre-push | 124 | 94.4% | 45s |
| Pre-release | 12 | 100% | 3.2min |
| Code Review | 89 | 95.5% | N/A |

### Current Failing Gate
⚠️ **Hook:** frontend-specialist-standards
- **Phase:** accessibility-validation
- **Issue:** 2 WCAG AA violations in new components
- **Action:** Fix in PR #52 (in progress)

### Validation Coverage
- **Agent Coverage:** 18/18 (100%) ✅
- **File Type Coverage:** 12/12 (100%) ✅
- **Quality Dimensions:** 7/7 (100%) ✅
```

### 7. Documentation Quality

```markdown
## 📚 Documentation

### Completeness
- **Agents Documented:** 18/18 (100%) ✅
- **Hooks Documented:** 44/44 (100%) ✅
- **Commands Documented:** 6/6 (100%) ✅
- **Skills Documented:** 11/11 (100%) ✅

### Documentation Metrics
- **Total Pages:** 87
- **Total Words:** 156,234
- **Code Examples:** 342
- **Diagrams:** 18
- **Broken Links:** 0 ✅

### Documentation Quality Checks
- **Spelling/Grammar:** 98.2% ✅
- **Link Validation:** 100% ✅
- **Code Example Tests:** 95.3% ✅
- **API Docs Sync:** 100% ✅

### Missing Documentation (3 items)
⚠️ 1. Migration guide for hook format v2→v3
⚠️ 2. Troubleshooting guide for agent routing
⚠️ 3. Performance tuning best practices
```

### 8. Agent Efficiency Analysis

```markdown
## 🤖 Agent Efficiency

### Top Performing Agents
1. **bash-expert** - 100% success, 1.8s avg
2. **rust-expert** - 100% success, 3.2s avg
3. **powershell-expert** - 100% success, 2.5s avg

### Most Active Agents
1. **python-expert** - 24 tasks
2. **code-review-gatekeeper** - 22 tasks
3. **typescript-expert** - 18 tasks

### Efficiency Scores (Tasks/Hour × Success Rate)
| Agent | Tasks/Hr | Success | Efficiency |
|-------|----------|---------|------------|
| bash-expert | 15.2 | 100% | 15.2 ⭐⭐⭐ |
| rust-expert | 12.5 | 100% | 12.5 ⭐⭐⭐ |
| typescript-expert | 14.1 | 94% | 13.3 ⭐⭐⭐ |
| python-expert | 13.8 | 96% | 13.2 ⭐⭐⭐ |

### Collaboration Network
Most Frequent Pairs:
- code-review-gatekeeper ↔ [any language expert] (78 times)
- comprehensive-analyst ↔ code-review-gatekeeper (24 times)
- system-architect ↔ devops-orchestrator (15 times)
```

### 9. Trend Analysis & Forecasts

```markdown
## 📈 Trends & Forecasts

### Quality Score Trend (90 Days)
```
100 ┤                                       ╭─────
 95 ┤                               ╭───────╯
 90 ┤                       ╭───────╯
 85 ┤               ╭───────╯
 80 ┤       ╭───────╯
 75 ┤───────╯
     Aug 17          Sep 17         Oct 17       Nov 16
```

### Forecasts (Next 30 Days)
- **Quality Score:** Projected 96-97 (confidence: high)
- **Test Coverage:** Projected 84-86% (confidence: medium)
- **Build Success:** Projected 99.5%+ (confidence: high)
- **Agent Efficiency:** Projected +2-4% (confidence: medium)

### Risk Assessment
- **Technical Debt:** Low (2 items tracked)
- **Dependency Risk:** Low (2 vulnerable deps, fixes planned)
- **Performance Risk:** Very Low (trending positive)
- **Coverage Risk:** Low (above target, stable)
```

### 10. Recommendations

```markdown
## 💡 Recommendations

### High Priority
1. **Address Medium Security Issues (2 items)**
   - Upgrade old-crypto-lib to v2.0.0
   - Review CORS configuration
   - Estimated effort: 2 hours

2. **Fix WCAG Accessibility Violations**
   - 2 violations in frontend components
   - Already tracked in PR #52
   - Estimated effort: 1 hour

3. **Complete Missing Documentation**
   - Add 3 missing guide documents
   - Estimated effort: 4 hours

### Medium Priority
4. **Improve Test Coverage for E2E Tests**
   - Current: 65%, Target: 70%
   - Add 15-20 more E2E scenarios
   - Estimated effort: 8 hours

5. **Optimize python-expert Response Time**
   - Current: 3.5s, Can improve to 3.0s
   - Profile and optimize token usage
   - Estimated effort: 3 hours

### Low Priority
6. **Reduce Code Complexity in parseComplexConfig**
   - Complexity: 18, Target: <15
   - Refactor into smaller functions
   - Estimated effort: 2 hours
```

## Export Formats

### Markdown Export
```bash
/quality-report month --export
# Generates: quality-report-2025-11.md
```

### JSON Export
```bash
/quality-report --format=json --export
# Generates: quality-report-2025-11-16.json
```

### HTML Dashboard
```bash
/quality-report --format=html --export
# Generates: quality-report-2025-11-16.html
# Interactive charts and graphs
```

### CSV for Analysis
```bash
/quality-report --format=csv --export
# Generates: quality-metrics-2025-11-16.csv
# Import into Excel/Google Sheets
```

## Integration

Works with:
- `/analyze-framework` - Current health snapshot
- `/agent-status` - Real-time agent metrics
- `/validate-hooks` - Hook validation details
- CI/CD pipelines for automated reporting

## Automation

Can be automated via:
```bash
# Daily reports
cron: 0 9 * * * /quality-report today --export

# Weekly summary
cron: 0 9 * * 1 /quality-report week --export --trends

# Monthly executive report
cron: 0 9 1 * * /quality-report month --format=html --export
```

## Notes

- Reports based on collected metrics (requires tracking enabled)
- Historical data stored for 90 days
- Trends require minimum 7 days of data
- Forecasts use linear regression (medium confidence)
- Baseline comparisons available after 100 tasks
- Export files saved to current directory
