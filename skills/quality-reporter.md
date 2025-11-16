---
name: quality-reporter
description: Generate quality metrics reports and trend analysis
category: operational
priority: medium
author: framework-team
tags: [quality, metrics, reporting, analytics, trends]
---

# Quality Reporter Skill

## Purpose

Generate comprehensive quality metrics reports for the framework, tracking code quality, test coverage, validation results, and trends over time.

## When to Use

- For regular quality reviews (daily/weekly/monthly)
- Before releases
- For stakeholder reporting
- To identify quality trends
- For compliance documentation
- During retrospectives

## Report Types

### 1. Quick Status Report

**Command:**
```bash
/quality-report today
```

**Output:**
```
📊 QUALITY STATUS - Nov 16, 2025
═══════════════════════════════════════

✅ Build: 100% success (12/12)
✅ Tests: 97.3% pass rate (3742/3847)
✅ Coverage: 82.4% (target: 70%)
✅ Linting: 98.5% pass rate
✅ Security: 0 critical issues
⚠️  2 medium security issues

Overall Score: 🟢 95/100 (Excellent)
```

### 2. Weekly Summary

**Command:**
```bash
/quality-report week --export
```

**Output File:** `quality-report-week-47-2025.md`

```markdown
# Weekly Quality Report
**Period:** Nov 10-16, 2025

## Summary
- **Quality Score:** 95/100 (+2 from last week)
- **Builds:** 48 total, 47 successful (97.9%)
- **Tests:** 18,542 executed, 18,024 passed (97.2%)
- **Coverage:** 82.4% (+1.2%)

## Highlights
✅ Achieved 100% hook coverage (18/18 agents)
✅ Zero critical security vulnerabilities
✅ Improved test coverage by 1.2%

## Areas for Improvement
⚠️  2 medium security issues (under review)
⚠️  Test execution time increased 8%

## Top Contributors
- rust-expert: 100% success, 1.8s avg response
- python-expert: 96% success, 3.5s avg response
- typescript-expert: 94% success, 3.1s avg response
```

### 3. Monthly Executive Report

**Command:**
```bash
/quality-report month --format=html --export
```

**Features:**
- Interactive charts and graphs
- Trend analysis
- Comparative metrics
- Executive summary
- Detailed breakdowns

### 4. Release Readiness Report

**Command:**
```bash
/quality-report --release-ready
```

**Checks:**
- All tests passing?
- No critical/high security issues?
- Coverage above threshold?
- All quality gates passing?
- Documentation updated?
- No known blockers?

**Output:**
```
🚀 RELEASE READINESS CHECK
═══════════════════════════════════════

QUALITY GATES
  ✅ All tests passing (100%)
  ✅ Coverage above 70% (82.4%)
  ✅ No critical security issues
  ✅ All linting passing
  ✅ Documentation updated

BLOCKING ISSUES
  ⚠️  2 medium security issues
      Status: Under review (non-blocking)

RECOMMENDATIONS
  ✓ Ready for release
  ✓ Consider addressing medium security issues
  ✓ Update changelog

STATUS: 🟢 READY FOR RELEASE
```

## Metrics Tracked

### Code Quality
- Build success rate
- Compilation errors
- Linting pass rate
- Code complexity
- Code duplication
- Formatting compliance

### Testing
- Test execution count
- Pass/fail rates
- Test coverage percentage
- Test execution time
- Flaky test identification

### Security
- Vulnerability count by severity
- Dependency security issues
- SAST findings
- Secret detection
- Compliance status

### Performance
- Agent response times
- Validation hook execution times
- Resource usage
- Token efficiency
- Cache hit rates

### Agent Efficiency
- Tasks completed
- Success rates
- Average response time
- Collaboration patterns

## Trend Analysis

### Quality Score Over Time

```
Quality Score Trend (30 Days)

100 ┤
 95 ┤                                   ╭─────
 90 ┤                           ╭───────╯
 85 ┤                   ╭───────╯
 80 ┤           ╭───────╯
 75 ┤   ╭───────╯
 70 ┤───╯
    Oct 17                           Nov 16

Trend: 📈 Improving (+18 points)
```

### Test Coverage Trend

```
Coverage % (90 Days)

85% ┤                                 ╭─────
80% ┤                         ╭───────╯
75% ┤                 ╭───────╯
70% ┤         ╭───────╯
65% ┤ ╭───────╯
60% ┤─╯
    Aug 17           Sep 17         Oct 17      Nov 16

Trend: 📈 Steady Growth (+22%)
```

## Custom Reports

### Technology-Specific Reports

```bash
# Rust quality metrics
/quality-report --language=rust

# Python quality metrics
/quality-report --language=python

# All language experts
/quality-report --category=language
```

### Domain-Specific Reports

```bash
# Security metrics
/quality-report --security

# Performance metrics
/quality-report --performance

# Documentation quality
/quality-report --documentation
```

## Report Formats

### Markdown (Default)
- Human-readable
- Version control friendly
- Can be published to wikis/docs

### JSON
```json
{
  "period": "2025-11-16",
  "quality_score": 95,
  "metrics": {
    "build_success_rate": 0.979,
    "test_pass_rate": 0.973,
    "coverage_percent": 82.4,
    "security_critical": 0,
    "security_high": 0,
    "security_medium": 2
  },
  "trends": {
    "quality_score_change": +2,
    "coverage_change": +1.2
  }
}
```

### HTML
- Interactive dashboards
- Charts and graphs
- Drill-down capabilities
- Export as PDF

### CSV
- For spreadsheet analysis
- Time-series data
- Pivot tables

## Automation

### Scheduled Reports

```bash
# Daily status (cron)
0 9 * * * /quality-report today --export

# Weekly summary (Monday 9 AM)
0 9 * * 1 /quality-report week --export --email

# Monthly executive report (1st of month)
0 9 1 * * /quality-report month --format=html --export
```

### CI/CD Integration

```yaml
# .github/workflows/quality-report.yml
name: Quality Report
on:
  schedule:
    - cron: '0 9 * * 1'  # Weekly on Monday
jobs:
  report:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Generate Report
        run: |
          ./quality-reporter.sh --week --export
      - name: Upload Artifact
        uses: actions/upload-artifact@v3
        with:
          name: quality-report
          path: quality-report-*.md
```

## Data Sources

Reports aggregate data from:
- Build logs
- Test execution results
- Coverage reports
- Validation hook results
- Security scan outputs
- Agent performance metrics
- Git commit history

## Benchmarking

### Quality Score Calculation

```
Quality Score = (
  Build Success     × 0.15 +
  Test Pass Rate    × 0.25 +
  Coverage          × 0.20 +
  Security          × 0.25 +
  Code Quality      × 0.10 +
  Documentation     × 0.05
) × 100
```

### Rating Scale

- 90-100: Excellent ✅
- 80-89: Good ✅
- 70-79: Acceptable ⚠️
- 60-69: Needs Improvement ⚠️
- Below 60: Critical ❌

## Integration

Works with:
- `/analyze-framework` - Current snapshot
- `/agent-status` - Agent metrics
- `/validate-hooks` - Hook validation
- Framework monitoring systems

## Best Practices

1. **Regular Reporting**
   - Run daily for active development
   - Weekly summaries for teams
   - Monthly for stakeholders

2. **Trend Tracking**
   - Monitor metrics over time
   - Identify patterns
   - Celebrate improvements
   - Address degradation

3. **Actionable Insights**
   - Don't just report numbers
   - Provide recommendations
   - Track remediation
   - Follow up on issues

4. **Share Results**
   - Make reports visible
   - Discuss in team meetings
   - Use for sprint planning
   - Guide improvements

## Sample Comprehensive Report

```markdown
# Quality Report: Claude Code CLI Framework
**Period:** November 2025 (Full Month)
**Generated:** Nov 30, 2025 16:00 UTC

## Executive Summary

Overall Quality Score: 🟢 95/100 (Excellent)
- Build Success: 97.9% ✅
- Test Pass Rate: 97.3% ✅
- Code Coverage: 82.4% ✅
- Security: 0 critical ✅
- Performance: 92/100 ✅

### Key Achievements
✅ Achieved 100% validation hook coverage
✅ Maintained zero critical vulnerabilities
✅ Improved test coverage 3.2%
✅ Reduced build time 12%

### Month Highlights
- 312 builds (306 successful)
- 43,847 tests executed
- 18 agents fully operational
- 44 quality gates active

## Detailed Metrics

### Code Quality (94/100)
- Compilation: 97.9% success
- Linting: 98.5% pass
- Complexity: Avg 5.2 (target <10)
- Duplication: 2.1% (target <5%)

### Testing (97/100)
- Unit Tests: 98.2% pass, 89% coverage
- Integration: 96.1% pass, 78% coverage
- E2E: 95.5% pass, 65% coverage
- Overall: 97.3% pass, 82.4% coverage

### Security (98/100)
- Critical: 0 ✅
- High: 0 ✅
- Medium: 2 (under review)
- Dependencies: 2/342 vulnerable (0.6%)

### Performance (92/100)
- Avg Response: 3.8s (target <5s)
- P95: 7.2s
- Token Efficiency: 94%
- Cache Hit Rate: 42%

## Trends

Quality score: 📈 +18 points (77→95)
Test coverage: 📈 +3.2% (79.2%→82.4%)
Build time: 📉 -12% faster
Security issues: → Stable (0 critical)

## Recommendations

### High Priority
1. Address 2 medium security issues
2. Improve E2E test coverage to 70%

### Medium Priority
3. Optimize 3 slow validation hooks
4. Add SAST to 3 agents

### Low Priority
5. Reduce code complexity in 2 functions
6. Update 3 documentation sections

## Conclusion

Framework quality is excellent with consistent
improvements. Continue current practices and
address recommended items for optimal health.

Next Review: December 31, 2025
```

## Summary

Quality Reporter provides:
- Comprehensive metrics tracking
- Trend analysis and forecasting
- Multiple report formats
- Automated scheduling
- Actionable insights
- Compliance documentation

Use regularly to maintain and improve framework quality.
