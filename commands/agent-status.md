---
name: agent-status
description: Display runtime status and performance metrics for agents
tags: [agents, status, metrics, monitoring, performance]
---

# Agent Status Command

## Purpose

Display real-time status, performance metrics, and health information for framework agents during active sessions.

## Usage

```
/agent-status [agent-name] [--metrics] [--history] [--watch]
```

**Options:**
- `<agent-name>`: Show status for specific agent
- `--metrics`: Include detailed performance metrics
- `--history`: Show historical execution data
- `--watch`: Continuous monitoring mode (updates every 5s)

## Output Format

### 1. All Agents Summary (Default)

```
🤖 Agent Status Dashboard
═══════════════════════════════════════════════════════════
Last Updated: 2025-11-16 15:30:45 UTC

┌───────────────────────────┬──────────┬─────────┬──────────┬────────────┐
│ Agent                     │ Status   │ Tasks   │ Avg Time │ Success    │
├───────────────────────────┼──────────┼─────────┼──────────┼────────────┤
│ 🦀 rust-expert            │ 🟢 Ready │ 12      │ 3.2s     │ 100%       │
│ 🔷 csharp-expert          │ 🟢 Ready │ 8       │ 4.1s     │ 95%        │
│ 🐹 go-expert              │ 🟢 Ready │ 15      │ 2.8s     │ 98%        │
│ ☕ java-expert            │ 🟢 Ready │ 6       │ 5.2s     │ 100%       │
│ 🐍 python-expert          │ 🟡 Busy  │ 24 (+1) │ 3.5s     │ 96%        │
│ 📘 typescript-expert      │ 🟢 Ready │ 18      │ 3.1s     │ 94%        │
│ 🐚 bash-expert            │ 🟢 Ready │ 9       │ 1.8s     │ 100%       │
│ 💠 powershell-expert      │ 🟢 Ready │ 4       │ 2.5s     │ 100%       │
│ 🗄️  database-specialist   │ 🟢 Ready │ 7       │ 4.0s     │ 100%       │
│ 🎨 frontend-specialist    │ 🟢 Ready │ 11      │ 3.8s     │ 92%        │
│ 🔒 security-specialist    │ 🟢 Ready │ 5       │ 6.2s     │ 100%       │
│ 🖼️  uiux-specialist       │ 🟢 Ready │ 3       │ 2.1s     │ 100%       │
│ 🚀 devops-orchestrator    │ 🟢 Ready │ 10      │ 5.5s     │ 95%        │
│ 🏛️  system-architect      │ 🟢 Ready │ 4       │ 8.1s     │ 100%       │
│ 📋 product-owner          │ 🟢 Ready │ 6       │ 3.3s     │ 100%       │
│ 🔍 comprehensive-analyst  │ 🟢 Ready │ 14      │ 4.7s     │ 98%        │
│ ✅ code-review-gatekeeper │ 🟢 Ready │ 22      │ 3.9s     │ 97%        │
│ 📚 technical-docs-writer  │ 🟢 Ready │ 8       │ 2.6s     │ 100%       │
└───────────────────────────┴──────────┴─────────┴──────────┴────────────┘

📊 SUMMARY
   Total Agents: 18
   Ready: 17 (94%)
   Busy: 1 (6%)
   Error: 0 (0%)

   Total Tasks: 186
   Active: 1
   Success Rate: 97.3%
   Avg Response: 3.8s
```

### 2. Specific Agent Detail (agent-name)

```
🤖 Agent Status: python-expert
═══════════════════════════════════════════════════════════

📊 CURRENT STATUS
   Status: 🟡 Busy
   Current Task: "Add FastAPI validation middleware"
   Started: 2 minutes ago
   Estimated Completion: 30 seconds

📈 SESSION STATISTICS
   Tasks Completed: 24
   Tasks Active: 1
   Tasks Failed: 1
   Success Rate: 96.0%

   Avg Response Time: 3.5s
   Min Response Time: 1.2s
   Max Response Time: 8.3s

   Total Tokens Used: 125,430
   Avg Tokens/Task: 5,226

🔧 RECENT TASKS (Last 5)
   1. ✅ "Implement pytest fixtures" - 2.8s (5 min ago)
   2. ✅ "Add type hints to API" - 4.2s (12 min ago)
   3. ✅ "Configure black formatter" - 1.9s (18 min ago)
   4. ❌ "Debug async performance" - Failed (25 min ago)
      Error: Insufficient context about async implementation
   5. ✅ "Create Pydantic models" - 3.1s (32 min ago)

🎯 SPECIALIZATION USAGE
   ┌─────────────────────────┬────────┬──────────┐
   │ Area                    │ Count  │ Percent  │
   ├─────────────────────────┼────────┼──────────┤
   │ Web Frameworks          │ 12     │ 48%      │
   │ Testing & QA            │ 6      │ 24%      │
   │ Data Science            │ 4      │ 16%      │
   │ Automation              │ 2      │ 8%       │
   │ Other                   │ 1      │ 4%       │
   └─────────────────────────┴────────┴──────────┘

🔗 COLLABORATION
   Most Used With:
   • code-review-gatekeeper (18 times)
   • comprehensive-analyst (12 times)
   • database-specialist (5 times)

⚡ PERFORMANCE TRENDS
   Last Hour: 📈 Improving (avg 3.2s → 2.9s)
   Last Day: → Stable
   Success Rate Trend: 📈 Improving (94% → 96%)
```

### 3. With Metrics (--metrics)

```
🤖 Agent Metrics: rust-expert
═══════════════════════════════════════════════════════════

⏱️  RESPONSE TIME METRICS
   Mean: 3.2s
   Median: 2.8s
   P50: 2.8s
   P95: 5.1s
   P99: 6.8s
   Std Dev: 1.2s

📊 THROUGHPUT
   Tasks/Hour: 12.5
   Tasks/Day: 150 (projected)
   Peak Hour: 14:00-15:00 (18 tasks)

🎯 ACCURACY METRICS
   Success Rate: 100%
   Retry Rate: 5%
   Error Rate: 0%
   Validation Pass Rate: 98%

💾 RESOURCE USAGE
   Avg Tokens/Task: 8,234
   Total Tokens: 98,808
   Token Efficiency: High (±10% from baseline)
   Cache Hit Rate: 45%

🔄 QUALITY GATES
   Pre-commit Checks: 12/12 passed
   Pre-push Checks: 8/8 passed
   Code Review: 12 reviews, 11 approved
   Test Coverage: Avg 85% (target: 70%)

📈 TRENDS (Last 7 Days)
   Task Volume: 📈 +15%
   Success Rate: → Stable (100%)
   Response Time: 📉 Improving (-8%)
   Token Usage: → Stable
```

### 4. With History (--history)

```
🤖 Agent History: typescript-expert
═══════════════════════════════════════════════════════════

📅 SESSION HISTORY (Last 10 Sessions)

Session 1: Nov 16, 15:00-15:45 (45 min)
  Tasks: 12
  Success: 11/12 (92%)
  Avg Time: 3.2s
  Focus: React component development

Session 2: Nov 16, 10:30-11:15 (45 min)
  Tasks: 8
  Success: 8/8 (100%)
  Avg Time: 2.9s
  Focus: Next.js API routes

Session 3: Nov 15, 16:00-16:30 (30 min)
  Tasks: 6
  Success: 6/6 (100%)
  Avg Time: 3.1s
  Focus: TypeScript type refinement

... (more sessions) ...

📊 HISTORICAL TRENDS (Last 30 Days)
   Total Tasks: 186
   Success Rate: 94.6%
   Avg Response Time: 3.1s
   Most Active: Weekdays 14:00-17:00
   Least Active: Weekends

🏆 ACHIEVEMENTS
   ✨ Perfect Week: Nov 8-14 (100% success)
   🚀 Speed Record: 0.8s (Nov 12)
   🎯 Quality Streak: 15 consecutive successful reviews
   📚 Knowledge Growth: 12 new patterns learned
```

## Status Indicators

### Agent Status
- 🟢 **Ready** - Available for new tasks
- 🟡 **Busy** - Currently executing a task
- 🔴 **Error** - Error state, requires attention
- ⚪ **Idle** - Not used in current session
- 🔵 **Warming Up** - Initializing

### Performance Indicators
- 📈 **Improving** - Metrics trending better
- → **Stable** - Consistent performance
- 📉 **Degrading** - Performance declining
- ⚠️ **Warning** - Approaching thresholds
- 🔥 **Critical** - Immediate attention needed

## Use Cases

### 1. Quick Status Check
```bash
/agent-status
# See all agents at a glance
```

### 2. Deep Dive on Specific Agent
```bash
/agent-status python-expert --metrics
# Detailed performance metrics for Python expert
```

### 3. Historical Analysis
```bash
/agent-status rust-expert --history
# See past sessions and trends
```

### 4. Continuous Monitoring
```bash
/agent-status --watch
# Live updates every 5 seconds
```

### 5. Troubleshooting
```bash
/agent-status code-review-gatekeeper --metrics
# Investigate slow performance or high error rates
```

## Metrics Explained

### Response Time
- **Mean**: Average time to complete tasks
- **Median**: Middle value (less affected by outliers)
- **P95/P99**: 95th/99th percentile (worst-case scenarios)

### Success Rate
- **Percentage** of tasks completed without errors
- **Target**: >95% for production agents
- **Warning**: <90% indicates issues

### Token Efficiency
- **Tokens per task** compared to baseline
- **High**: Within ±10% of expected
- **Medium**: 10-25% variance
- **Low**: >25% variance (investigate)

### Collaboration Score
- How often agent works with other agents
- **High**: Frequently delegates or collaborates
- **Low**: Works independently

## Performance Benchmarks

### Response Time Targets
- **Fast**: <2s (simple tasks)
- **Normal**: 2-5s (moderate complexity)
- **Slow**: 5-10s (complex tasks)
- **Very Slow**: >10s (architectural/design tasks)

### Success Rate Targets
- **Excellent**: 98-100%
- **Good**: 95-97%
- **Acceptable**: 90-94%
- **Needs Improvement**: <90%

### Token Efficiency
- **Excellent**: ±5% of baseline
- **Good**: ±10% of baseline
- **Acceptable**: ±20% of baseline
- **Review Needed**: >20% variance

## Alerts and Warnings

### Automatic Alerts

**Performance Degradation:**
```
⚠️  Warning: python-expert response time increased 40%
   Current: 5.8s (baseline: 3.5s)
   Recommendation: Check for complex tasks or context issues
```

**High Error Rate:**
```
🔴 Critical: csharp-expert error rate at 15%
   Normal: <5%
   Recent Errors: Missing SDK, configuration issues
   Action: Review recent tasks and configuration
```

**Resource Usage:**
```
⚠️  Warning: typescript-expert token usage +35%
   Average: 8,234 tokens/task (baseline: 6,100)
   Possible Cause: More complex tasks or verbose outputs
```

## Integration

Works with:
- `/analyze-framework` - Overall framework health
- `/list-agents` - Agent catalog
- `/quality-report` - Historical metrics
- Agent health monitoring hooks

## Data Sources

Status information from:
1. **Active session tracking** - Current task execution
2. **Performance logs** - Historical execution data
3. **Quality gate results** - Validation outcomes
4. **Agent coordination hooks** - Inter-agent communication

## Watch Mode

When run with `--watch`:
- Updates display every 5 seconds
- Shows real-time task progress
- Highlights status changes
- Press Ctrl+C to exit

```
🤖 Agent Status Dashboard (Live - Updates every 5s)
═══════════════════════════════════════════════════════════
🔄 Refreshing... Last update: 15:30:55

[Status display here - auto-refreshes]

Press Ctrl+C to exit watch mode
```

## Notes

- Metrics require session tracking enabled
- Historical data stored for 30 days
- Performance baselines calculated from first 100 tasks
- Some metrics may not be available in fresh installations
- Use `/quality-report` for exported metrics
