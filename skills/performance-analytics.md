---
name: performance-analytics
description: Analyze agent and hook performance metrics for optimization opportunities
version: 1.0
priority: medium
category: monitoring
---

# Performance Analytics Skill

## Purpose

Track, analyze, and optimize agent execution performance, hook trigger frequencies, and overall framework efficiency. Identifies bottlenecks and provides data-driven optimization recommendations.

## When to Use

- Analyzing framework performance
- Identifying slow agents or hooks
- Optimizing task routing patterns
- Capacity planning
- Cost analysis and optimization
- Workflow efficiency improvements

## Metrics Collected

### 1. Agent Performance Metrics

```yaml
agent_metrics:
  execution_time:
    metric: "Average time agent takes to complete tasks"
    unit: "seconds"
    tracked_per:
      - agent_type
      - task_complexity
      - task_category

  success_rate:
    metric: "Percentage of successful completions"
    unit: "percentage"
    thresholds:
      excellent: ">95%"
      good: "90-95%"
      needs_improvement: "<90%"

  token_efficiency:
    metric: "Average tokens used per task"
    unit: "tokens"
    target: "800-1200 tokens"
    optimization: "Minimize while maintaining quality"

  quality_score:
    metric: "Code quality produced"
    unit: "score 0-100"
    factors:
      - compilation_success
      - test_coverage
      - linting_compliance
      - security_compliance

  throughput:
    metric: "Tasks completed per hour"
    unit: "tasks/hour"
    tracked_by: "agent_type"
```

### 2. Hook Performance Metrics

```yaml
hook_metrics:
  trigger_frequency:
    metric: "How often hook is triggered"
    unit: "triggers/day"
    analysis: "Identify frequently triggered hooks"

  execution_time:
    metric: "Time hook takes to complete validation"
    unit: "milliseconds"
    thresholds:
      fast: "<100ms"
      acceptable: "100-500ms"
      slow: ">500ms"

  pass_rate:
    metric: "Percentage of successful validations"
    unit: "percentage"
    target: ">95%"

  blocking_rate:
    metric: "How often hook blocks progression"
    unit: "percentage"
    analysis: "Balance between quality and velocity"

  false_positive_rate:
    metric: "Incorrect failures"
    unit: "percentage"
    target: "<5%"
```

### 3. Workflow Efficiency Metrics

```yaml
workflow_metrics:
  end_to_end_time:
    metric: "Total time from task start to completion"
    unit: "minutes"
    breakdown:
      - delegation_time
      - agent_execution_time
      - quality_gate_time
      - handoff_time

  agent_coordination_efficiency:
    metric: "Smoothness of multi-agent workflows"
    factors:
      - handoff_delays
      - rework_frequency
      - coordination_overhead

  resource_utilization:
    metric: "Agent capacity usage"
    analysis: "Identify underutilized or overloaded agents"
```

## Performance Dashboard

### Real-Time Metrics

```yaml
realtime_dashboard:
  agent_status:
    active_agents: "Currently executing agents"
    queued_tasks: "Tasks waiting for agents"
    average_response_time: "Current avg response time"

  quality_gates:
    pass_rate: "Current quality gate pass rate"
    blocking_gates: "Active blocking quality gates"
    average_validation_time: "Avg validation time"

  system_health:
    overall_performance_score: "0-100 score"
    bottlenecks: "Identified performance bottlenecks"
    recommendations: "Optimization suggestions"
```

### Historical Analysis

```yaml
historical_analysis:
  trends:
    performance_over_time: "Weekly/monthly performance trends"
    quality_improvements: "Quality metrics evolution"
    efficiency_gains: "Workflow optimization impact"

  comparisons:
    agent_vs_agent: "Comparative agent performance"
    workflow_patterns: "Most vs least efficient workflows"
    time_periods: "Performance across different periods"
```

## Analysis Functions

### Agent Performance Analysis

```typescript
interface AgentPerformance {
  agent_name: string;
  total_tasks: number;
  avg_execution_time: number;
  success_rate: number;
  avg_tokens_used: number;
  quality_score: number;
  bottleneck_score: number; // 0-100, higher = more problematic
}

function analyzeAgentPerformance(
  agent: string,
  period: TimePeriod
): AgentPerformance {
  const tasks = getTaskHistory(agent, period);

  return {
    agent_name: agent,
    total_tasks: tasks.length,
    avg_execution_time: calculateAverage(tasks.map(t => t.execution_time)),
    success_rate: calculateSuccessRate(tasks),
    avg_tokens_used: calculateAverage(tasks.map(t => t.tokens)),
    quality_score: calculateQualityScore(tasks),
    bottleneck_score: calculateBottleneckScore(tasks)
  };
}
```

### Hook Efficiency Analysis

```typescript
interface HookEfficiency {
  hook_name: string;
  trigger_count: number;
  avg_execution_time: number;
  pass_rate: number;
  blocking_rate: number;
  optimization_potential: "high" | "medium" | "low";
}

function analyzeHookEfficiency(
  hook: string,
  period: TimePeriod
): HookEfficiency {
  const executions = getHookExecutions(hook, period);

  return {
    hook_name: hook,
    trigger_count: executions.length,
    avg_execution_time: calculateAverage(
      executions.map(e => e.execution_time)
    ),
    pass_rate: calculatePassRate(executions),
    blocking_rate: calculateBlockingRate(executions),
    optimization_potential: assessOptimizationPotential(executions)
  };
}
```

### Workflow Pattern Analysis

```typescript
interface WorkflowPattern {
  pattern_name: string;
  frequency: number;
  avg_duration: number;
  success_rate: number;
  agent_sequence: string[];
  efficiency_score: number;
  recommendations: string[];
}

function analyzeWorkflowPattern(
  pattern: string,
  period: TimePeriod
): WorkflowPattern {
  const workflows = getWorkflowsByPattern(pattern, period);

  return {
    pattern_name: pattern,
    frequency: workflows.length,
    avg_duration: calculateAverage(workflows.map(w => w.duration)),
    success_rate: calculateSuccessRate(workflows),
    agent_sequence: extractAgentSequence(workflows),
    efficiency_score: calculateEfficiencyScore(workflows),
    recommendations: generateRecommendations(workflows)
  };
}
```

## Optimization Recommendations

### Performance Optimization

```yaml
optimization_strategies:
  slow_agent_optimization:
    issue: "Agent execution time >5 minutes"
    detection: "avg_execution_time > 300s"
    recommendations:
      - "Break complex tasks into smaller subtasks"
      - "Optimize agent prompt for efficiency"
      - "Consider parallel execution where possible"
      - "Review agent tool usage patterns"

  token_efficiency:
    issue: "High token usage per task"
    detection: "avg_tokens > 2000"
    recommendations:
      - "Reduce context in agent prompts"
      - "Use more concise delegation instructions"
      - "Cache frequently used information"
      - "Optimize agent response patterns"

  hook_optimization:
    issue: "Hook execution time >1 second"
    detection: "avg_hook_time > 1000ms"
    recommendations:
      - "Optimize validation logic"
      - "Use faster validation tools"
      - "Parallelize independent checks"
      - "Cache validation results where safe"
```

### Workflow Optimization

```yaml
workflow_improvements:
  reduce_handoffs:
    issue: "Too many agent handoffs"
    detection: "agent_count > 5 for simple tasks"
    recommendations:
      - "Consolidate related tasks to single agent"
      - "Use more capable agents for complex tasks"
      - "Reduce unnecessary quality gates"

  parallel_execution:
    issue: "Sequential execution of independent tasks"
    detection: "non_dependent_tasks executed serially"
    recommendations:
      - "Execute database and backend work in parallel"
      - "Run security and performance checks concurrently"
      - "Parallelize independent validation hooks"

  eliminate_bottlenecks:
    issue: "Specific agent causing delays"
    detection: "one agent >50% of total workflow time"
    recommendations:
      - "Optimize bottleneck agent performance"
      - "Distribute load across multiple capable agents"
      - "Cache repetitive work"
```

## Performance Reports

### Daily Performance Report

```yaml
daily_report:
  date: "2025-11-16"
  summary:
    total_tasks_completed: 127
    avg_task_duration: "3.2 minutes"
    overall_success_rate: "96.8%"
    quality_gate_pass_rate: "94.5%"

  top_performers:
    - agent: "rust-expert"
      tasks: 23
      avg_time: "2.1 min"
      success: "98.5%"

    - agent: "typescript-expert"
      tasks: 19
      avg_time: "2.4 min"
      success: "97.3%"

  needs_attention:
    - agent: "comprehensive-analyst"
      issue: "Avg execution time 8.3 min (target: <5 min)"
      recommendation: "Break complex analysis into phases"

  quality_metrics:
    compilation_success: "99.2%"
    test_coverage_avg: "84.3%"
    security_scan_pass: "96.1%"
```

### Weekly Optimization Report

```yaml
weekly_report:
  period: "2025-11-10 to 2025-11-16"

  performance_trends:
    avg_task_duration:
      trend: "decreasing"
      improvement: "-12% vs previous week"
      current: "3.2 minutes"
      previous: "3.6 minutes"

    quality_improvements:
      test_coverage:
        trend: "increasing"
        current: "84.3%"
        target: "85%"
        on_track: true

  optimization_opportunities:
    - category: "Hook Optimization"
      hooks: ["dependency-security", "performance-regression"]
      issue: "Avg execution time >2 seconds"
      potential_savings: "15 seconds per task"
      recommendation: "Implement parallel scanning"

    - category: "Agent Efficiency"
      agents: ["comprehensive-analyst"]
      issue: "High token usage (avg 2.3k tokens)"
      potential_savings: "30% token reduction"
      recommendation: "Optimize analysis prompts"

  roi_analysis:
    time_saved: "2.3 hours/day"
    quality_improvement: "+2.1% test coverage"
    cost_reduction: "18% fewer tokens used"
```

## Usage Examples

### Example 1: Analyze Overall Performance

```bash
User: "Show me framework performance metrics"

Performance Analytics Response:

📊 Framework Performance Overview (Last 7 Days)

🎯 Overall Health: 92/100

📈 Key Metrics:
  Total Tasks: 847
  Avg Duration: 3.2 minutes
  Success Rate: 96.8%
  Quality Gate Pass: 94.5%

👥 Agent Performance:
  Best Performers:
    ✅ rust-expert: 2.1 min avg, 98.5% success
    ✅ typescript-expert: 2.4 min avg, 97.3% success
    ✅ java-expert: 2.8 min avg, 96.1% success

  Needs Optimization:
    ⚠️  comprehensive-analyst: 8.3 min avg (target: <5 min)
    💡 Recommendation: Break complex analysis into phases

🔒 Quality Metrics:
  Compilation: 99.2% ✅
  Test Coverage: 84.3% (target: 85%)
  Security: 96.1% ✅
  Linting: 97.8% ✅

🚀 Optimization Opportunities:
  1. Parallelize dependency-security and performance-regression hooks
     Estimated savings: 15 seconds per task

  2. Optimize comprehensive-analyst prompts
     Estimated savings: 30% token reduction

  3. Cache frequent validations
     Estimated savings: 5 seconds per task

💰 ROI This Week:
  Time Saved: 2.3 hours/day
  Quality Improved: +2.1% test coverage
  Cost Reduction: 18% fewer tokens
```

### Example 2: Agent-Specific Analysis

```bash
User: "Analyze rust-expert performance"

Performance Analytics Response:

📊 rust-expert Performance Analysis (Last 30 Days)

⏱️ Execution Metrics:
  Total Tasks: 156
  Avg Duration: 2.1 minutes
  Success Rate: 98.5%
  Token Efficiency: 950 tokens avg (excellent)

📈 Trends:
  Performance: Stable ✅
  Quality: Improving +3.2% ✅
  Efficiency: Improving -8% tokens ✅

🎯 Quality Scores:
  Compilation: 99.5%
  Cargo Clippy: 98.1%
  Test Coverage: 87.3% (above target)
  Security (cargo audit): 97.2%

📊 Task Breakdown:
  Simple Tasks: 62% (avg 1.2 min)
  Moderate Tasks: 31% (avg 2.8 min)
  Complex Tasks: 7% (avg 6.1 min)

💪 Strengths:
  - Fast compilation and testing
  - Excellent type safety
  - High code quality
  - Efficient token usage

💡 Optimization Opportunities:
  - Complex tasks averaging 6.1 min
    → Consider breaking into phases
  - Cargo audit occasionally slow
    → Implement caching for dependencies

⭐ Performance Rating: 96/100 (Excellent)
```

### Example 3: Cost Optimization

```bash
User: "How can I reduce costs?"

Performance Analytics Response:

💰 Cost Optimization Analysis

📊 Current Usage (Last 30 Days):
  Total Tokens: 1,247,000
  Avg per Task: 1,472 tokens
  Estimated Cost: $X.XX

🎯 Optimization Opportunities:

1. High Token Usage Agents:
   ⚠️  comprehensive-analyst: 2,300 tokens avg
   ⚠️  system-architect: 1,950 tokens avg
   💡 Potential Savings: 25% reduction → $X.XX/month

2. Redundant Validations:
   ⚠️  5 hooks run similar security checks
   💡 Consolidate to single security-specialist validation
   💡 Potential Savings: 15% reduction → $X.XX/month

3. Inefficient Workflows:
   ⚠️  Sequential execution adds 18% overhead
   💡 Parallelize independent checks
   💡 Potential Savings: 18% time reduction

4. Caching Opportunities:
   ⚠️  Dependency scans repeat for unchanged deps
   💡 Implement dependency scan caching
   💡 Potential Savings: 12% reduction

📈 Total Potential Savings:
  Token Reduction: 35-45%
  Time Reduction: 18-25%
  Estimated Monthly Savings: $X.XX - $X.XX

🚀 Quick Wins (Implement First):
  1. Optimize comprehensive-analyst prompts
  2. Enable hook result caching
  3. Parallelize security validations

⏱️ Implementation Time: 2-3 hours
💵 Payback Period: <1 week
```

## Integration

Coordinates with:
- `framework-validator` - Performance impact analysis
- `agent-routing-advisor` - Optimize routing based on performance data
- Quality gates - Track validation efficiency

## Output Formats

```json
{
  "performance_report": {
    "period": "2025-11-10 to 2025-11-16",
    "overall_health": 92,
    "metrics": {
      "total_tasks": 847,
      "avg_duration_seconds": 192,
      "success_rate": 96.8,
      "quality_gate_pass_rate": 94.5
    },
    "agent_performance": [
      {
        "agent": "rust-expert",
        "tasks": 156,
        "avg_duration": 126,
        "success_rate": 98.5,
        "tokens_avg": 950,
        "rating": 96
      }
    ],
    "optimization_opportunities": [
      {
        "category": "hook_optimization",
        "potential_savings": "15 seconds per task",
        "recommendation": "Parallelize security scans"
      }
    ],
    "roi": {
      "time_saved_hours_per_day": 2.3,
      "quality_improvement_percent": 2.1,
      "cost_reduction_percent": 18
    }
  }
}
```

## Success Criteria

- ✅ Track all agent executions
- ✅ Monitor hook performance
- ✅ Identify bottlenecks
- ✅ Generate actionable recommendations
- ✅ Measure optimization impact
- ✅ ROI analysis and reporting
