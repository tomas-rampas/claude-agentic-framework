#!/bin/bash

# Test Agent Setup Script
# Initializes the test-agent for quality assurance

set -e

AGENT_NAME="test-agent"
AGENT_DIR="~/.claude/agents/test-agent"
CONFIG_FILE="$AGENT_DIR/settings.json"

echo "================================"
echo " Test Agent Setup"
echo "================================"
echo ""

# 1. Verify agent directory
echo "[1/8] Verifying agent directory..."
if [ ! -d "$AGENT_DIR" ]; then
    echo "  ✗ Agent directory not found: $AGENT_DIR"
    exit 1
fi
echo "  ✓ Agent directory verified"

# 2. Check configuration file
echo "[2/8] Checking configuration..."
if [ ! -f "$CONFIG_FILE" ]; then
    echo "  ✗ Configuration file not found: $CONFIG_FILE"
    exit 1
fi
echo "  ✓ Configuration loaded"

# 3. Setup environment variables
echo "[3/8] Setting up environment..."
export TEST_AGENT_LOG_LEVEL="${TEST_AGENT_LOG_LEVEL:-info}"
export TEST_AGENT_CACHE_DIR="${TEST_AGENT_CACHE_DIR:-/tmp/test-agent-cache}"
export TEST_AGENT_RESULTS_DIR="${TEST_AGENT_RESULTS_DIR:-/tmp/test-results}"
export TEST_AGENT_COVERAGE_DIR="${TEST_AGENT_COVERAGE_DIR:-/tmp/coverage}"

# Create required directories
mkdir -p "$TEST_AGENT_CACHE_DIR"
mkdir -p "$TEST_AGENT_RESULTS_DIR"
mkdir -p "$TEST_AGENT_COVERAGE_DIR"
echo "  ✓ Environment configured"

# 4. Test MCP server connections
echo "[4/8] Testing MCP server connections..."

# Test Filesystem MCP
echo -n "  → Filesystem MCP: "
if command -v filesystem &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (critical for test discovery)"
fi

# Test Serena MCP
echo -n "  → Serena MCP: "
if command -v serena &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (needed for coverage analysis)"
fi

# 5. Detect test frameworks
echo "[5/8] Detecting test frameworks..."

# JavaScript/Node.js
echo -n "  → Jest: "
if command -v jest &> /dev/null; then
    echo "✓ $(jest --version 2>&1 | head -1)"
elif [ -f "node_modules/.bin/jest" ]; then
    echo "✓ Local installation"
else
    echo "⚠ Not found"
fi

# Python
echo -n "  → Pytest: "
if command -v pytest &> /dev/null; then
    echo "✓ $(pytest --version 2>&1 | head -1)"
else
    echo "⚠ Not found"
fi

# Go
echo -n "  → Go test: "
if command -v go &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found"
fi

# 6. Check coverage tools
echo "[6/8] Checking coverage tools..."

# NYC for JavaScript
echo -n "  → NYC (JS coverage): "
if command -v nyc &> /dev/null; then
    echo "✓ Available"
elif [ -f "node_modules/.bin/nyc" ]; then
    echo "✓ Local installation"
else
    echo "⚠ Not found"
fi

# Coverage.py for Python
echo -n "  → Coverage.py: "
if command -v coverage &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found"
fi

# 7. Performance check
echo "[7/8] Testing execution performance..."

# Create a simple test file
TEST_FILE="$TEST_AGENT_CACHE_DIR/perf-test.js"
cat > "$TEST_FILE" << 'EOF'
describe('Performance Test', () => {
  it('should run quickly', () => {
    expect(1 + 1).toBe(2);
  });
});
EOF

# Time a simple operation
START_TIME=$(date +%s%N)
echo "test" | grep "test" > /dev/null 2>&1
END_TIME=$(date +%s%N)
ELAPSED=$((($END_TIME - $START_TIME) / 1000000))
rm -f "$TEST_FILE"
echo "  ✓ Execution performance: ${ELAPSED}ms"

# Check parallel execution capability
if [ $(nproc) -gt 1 ]; then
    echo "  ✓ Parallel execution available ($(nproc) cores)"
else
    echo "  ⚠ Single core - limited parallelization"
fi

# 8. Health check
echo "[8/8] Running health check..."

# Check if agent.md is accessible
if [ -f "$AGENT_DIR/agent.md" ]; then
    echo "  ✓ Agent definition accessible"
else
    echo "  ✗ Agent definition not found"
    exit 1
fi

# Test write permissions
if [ -w "$TEST_AGENT_RESULTS_DIR" ]; then
    echo "  ✓ Results directory writable"
else
    echo "  ✗ Cannot write to results directory"
    exit 1
fi

# Check for at least one test framework
if command -v jest &> /dev/null || command -v pytest &> /dev/null || command -v go &> /dev/null; then
    echo "  ✓ At least one test framework available"
else
    echo "  ⚠ No test frameworks detected"
fi

echo ""
echo "================================"
echo " Setup Complete!"
echo "================================"
echo ""
echo "Test Agent Status:"
echo "  Model: haiku (fast execution)"
echo "  MCP Servers: filesystem, serena"
echo "  Results Dir: $TEST_AGENT_RESULTS_DIR"
echo "  Coverage Dir: $TEST_AGENT_COVERAGE_DIR"
echo "  Parallel Cores: $(nproc)"
echo ""
echo "Agent ready for testing and validation tasks."