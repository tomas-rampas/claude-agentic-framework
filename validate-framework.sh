#!/bin/bash

echo "🔍 Validating Optimized Claude Sub-Agent Framework"
echo "=================================================="

# Function to check file exists and get size
check_file() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        local size=$(wc -c < "$file" 2>/dev/null || echo "0")
        local lines=$(wc -l < "$file" 2>/dev/null || echo "0")
        echo "✅ $description: ${size} bytes, ${lines} lines"
        return 0
    else
        echo "❌ Missing: $description ($file)"
        return 1
    fi
}

# Function to validate JSON
validate_json() {
    local file="$1"
    local description="$2"
    
    if command -v jq >/dev/null 2>&1; then
        if jq empty "$file" >/dev/null 2>&1; then
            echo "✅ $description: Valid JSON"
            return 0
        else
            echo "❌ $description: Invalid JSON"
            return 1
        fi
    else
        echo "⚠️  $description: JSON validation skipped (jq not available)"
        return 0
    fi
}

total_checks=0
passed_checks=0

echo ""
echo "📋 CONFIGURATION VALIDATION"
echo "============================"

# Check main claude.json
if check_file "claude.json" "Main configuration"; then
    ((passed_checks++))
    validate_json "claude.json" "Main configuration"
fi
((total_checks++))

# Check shared resources
echo ""
echo "📁 SHARED RESOURCES"
echo "==================="

for file in "shared/base-config.json" "shared/mcp-config.json" "shared/agent-patterns.md"; do
    if check_file "$file" "$(basename "$file")"; then
        ((passed_checks++))
        if [[ "$file" == *.json ]]; then
            validate_json "$file" "$(basename "$file")"
        fi
    fi
    ((total_checks++))
done

# Check agent configurations
echo ""
echo "🤖 AGENT CONFIGURATIONS"
echo "======================="

for agent in plan-agent maker-agent reader-agent debug-agent security-agent test-agent docs-agent; do
    echo ""
    echo "Checking $agent:"
    
    # Check agent.md (prompt)
    if check_file "agents/$agent/agent.md" "$agent prompt"; then
        ((passed_checks++))
    fi
    ((total_checks++))
    
    # Check agent.json (config)
    if check_file "agents/$agent/agent.json" "$agent config"; then
        ((passed_checks++))
        validate_json "agents/$agent/agent.json" "$agent config"
    fi
    ((total_checks++))
done

# Check hooks system
echo ""
echo "🪝 HOOKS SYSTEM"
echo "==============="

if check_file "hooks/core-hooks.json" "Core hooks registry"; then
    ((passed_checks++))
    validate_json "hooks/core-hooks.json" "Core hooks registry"
fi
((total_checks++))

if check_file "hooks/smart-mcp.json" "Smart MCP activation"; then
    ((passed_checks++))
    validate_json "hooks/smart-mcp.json" "Smart MCP activation"
fi
((total_checks++))

# Check for essential hook implementations
essential_hooks=("development-standards" "mcp-integration" "error-handling" "testing-workflow" "security-check")
for hook in "${essential_hooks[@]}"; do
    if check_file "hooks/$hook.json" "$hook hook"; then
        ((passed_checks++))
        validate_json "hooks/$hook.json" "$hook hook"
    fi
    ((total_checks++))
done

echo ""
echo "📊 OPTIMIZATION METRICS"
echo "======================="

# Calculate agent prompt sizes
echo "Agent prompt sizes:"
for agent in plan-agent maker-agent reader-agent debug-agent security-agent test-agent docs-agent; do
    if [ -f "agents/$agent/agent.md" ]; then
        size=$(wc -c < "agents/$agent/agent.md")
        lines=$(wc -l < "agents/$agent/agent.md")
        if [ "$size" -le 2000 ]; then
            echo "✅ $agent: ${size} bytes (${lines} lines) - Optimized"
        else
            echo "⚠️  $agent: ${size} bytes (${lines} lines) - Could be smaller"
        fi
    fi
done

# Check for auto-engagement disabled
echo ""
echo "MCP Auto-engagement status:"
if grep -q '"auto_engage": false' agents/*/agent.json 2>/dev/null; then
    echo "✅ Auto-engagement disabled in agent configs"
else
    echo "⚠️  Check auto-engagement settings"
fi

if grep -q '"mcp_auto_engagement": false' claude.json 2>/dev/null; then
    echo "✅ Global auto-engagement disabled"
else
    echo "⚠️  Check global auto-engagement setting"
fi

# Count hooks
hook_count=$(find hooks -name "*.json" -type f | wc -l)
echo ""
echo "Hook system:"
echo "✅ Essential hooks implemented: $hook_count files"

echo ""
echo "📈 VALIDATION SUMMARY"
echo "===================="
echo "Passed: $passed_checks / $total_checks checks"

if [ "$passed_checks" -eq "$total_checks" ]; then
    echo "🎉 All validations passed! Framework is ready for use."
    exit 0
elif [ "$passed_checks" -gt $((total_checks * 3 / 4)) ]; then
    echo "⚠️  Most validations passed. Review warnings above."
    exit 1
else
    echo "❌ Multiple validation failures. Check configuration."
    exit 2
fi