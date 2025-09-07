#!/bin/bash

# Debug Agent Setup Script
# Initializes the debug-agent for systematic debugging

set -e

AGENT_NAME="debug-agent"
AGENT_DIR="~/.claude/agents/debug-agent"
CONFIG_FILE="$AGENT_DIR/settings.json"

echo "================================"
echo " Debug Agent Setup"
echo "================================"
echo ""

# 1. Verify agent directory
echo "[1/9] Verifying agent directory..."
if [ ! -d "$AGENT_DIR" ]; then
    echo "  ✗ Agent directory not found: $AGENT_DIR"
    exit 1
fi
echo "  ✓ Agent directory verified"

# 2. Check configuration file
echo "[2/9] Checking configuration..."
if [ ! -f "$CONFIG_FILE" ]; then
    echo "  ✗ Configuration file not found: $CONFIG_FILE"
    exit 1
fi
echo "  ✓ Configuration loaded"

# 3. Setup environment variables
echo "[3/9] Setting up environment..."
export DEBUG_AGENT_LOG_LEVEL="${DEBUG_AGENT_LOG_LEVEL:-debug}"
export DEBUG_AGENT_CACHE_DIR="${DEBUG_AGENT_CACHE_DIR:-/tmp/debug-agent-cache}"
export DEBUG_AGENT_DUMPS_DIR="${DEBUG_AGENT_DUMPS_DIR:-/tmp/debug-dumps}"
export DEBUG_AGENT_PROFILES_DIR="${DEBUG_AGENT_PROFILES_DIR:-/tmp/debug-profiles}"

# Create required directories
mkdir -p "$DEBUG_AGENT_CACHE_DIR"
mkdir -p "$DEBUG_AGENT_DUMPS_DIR"
mkdir -p "$DEBUG_AGENT_PROFILES_DIR"
echo "  ✓ Environment configured"

# 4. Test MCP server connections
echo "[4/9] Testing MCP server connections..."

# Test Filesystem MCP
echo -n "  → Filesystem MCP: "
if command -v filesystem &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (critical for log analysis)"
fi

# Test Serena MCP
echo -n "  → Serena MCP: "
if command -v serena &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (critical for call graph analysis)"
fi

# Test Sequential Thinking MCP
echo -n "  → Sequential Thinking MCP: "
if command -v sequentialthinking &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (needed for complex debugging)"
fi

# 5. Check debugging tools
echo "[5/9] Checking debugging tools..."

# System tools
REQUIRED_TOOLS=("grep" "awk" "sed" "tail" "head")
for tool in "${REQUIRED_TOOLS[@]}"; do
    echo -n "  → $tool: "
    if command -v $tool &> /dev/null; then
        echo "✓"
    else
        echo "✗ Missing (required)"
        exit 1
    fi
done

# Optional debuggers
echo "  Language debuggers:"
echo -n "  → GDB: "
if command -v gdb &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found"
fi

echo -n "  → Python debugger: "
if python3 -c "import pdb" 2>/dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found"
fi

echo -n "  → Node.js inspector: "
if command -v node &> /dev/null && node --version &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found"
fi

# 6. Check profiling tools
echo "[6/9] Checking profiling tools..."

echo -n "  → perf: "
if command -v perf &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (CPU profiling limited)"
fi

echo -n "  → strace: "
if command -v strace &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (syscall tracing unavailable)"
fi

echo -n "  → ltrace: "
if command -v ltrace &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (library tracing unavailable)"
fi

# 7. Initialize error pattern database
echo "[7/9] Initializing error patterns..."

PATTERNS_DIR="~/.claude/debug"
PATTERNS_FILE="$PATTERNS_DIR/patterns.json"
mkdir -p "$PATTERNS_DIR"

if [ ! -f "$PATTERNS_FILE" ]; then
    cat > "$PATTERNS_FILE" << 'EOF'
{
  "patterns": [
    {
      "name": "null_pointer",
      "regex": "NullPointerException|null reference|undefined is not",
      "category": "runtime",
      "severity": "high"
    },
    {
      "name": "memory_leak",
      "regex": "memory leak|heap exhausted|OOM|OutOfMemory",
      "category": "performance",
      "severity": "critical"
    },
    {
      "name": "deadlock",
      "regex": "deadlock detected|mutex timeout|lock timeout",
      "category": "concurrency",
      "severity": "critical"
    }
  ]
}
EOF
    echo "  ✓ Created error pattern database"
else
    echo "  ✓ Pattern database exists"
fi

# 8. Performance baseline
echo "[8/9] Setting up performance baseline..."

# Create a simple benchmark
BENCHMARK_FILE="$DEBUG_AGENT_CACHE_DIR/benchmark.txt"
START_TIME=$(date +%s%N)
for i in {1..1000}; do
    echo "test" > /dev/null
done
END_TIME=$(date +%s%N)
ELAPSED=$((($END_TIME - $START_TIME) / 1000000))
echo "$ELAPSED" > "$BENCHMARK_FILE"
echo "  ✓ Baseline performance: ${ELAPSED}ms for 1000 operations"

# 9. Health check
echo "[9/9] Running health check..."

# Check if agent.md is accessible
if [ -f "$AGENT_DIR/agent.md" ]; then
    echo "  ✓ Agent definition accessible"
else
    echo "  ✗ Agent definition not found"
    exit 1
fi

# Test log processing capability
TEST_LOG="$DEBUG_AGENT_CACHE_DIR/test.log"
cat > "$TEST_LOG" << 'EOF'
2024-01-01 10:00:00 INFO Application started
2024-01-01 10:00:01 ERROR Failed to connect to database
2024-01-01 10:00:02 WARN Retrying connection
EOF

if grep -q "ERROR" "$TEST_LOG" 2>/dev/null; then
    echo "  ✓ Log parsing working"
else
    echo "  ✗ Log parsing failed"
    exit 1
fi
rm "$TEST_LOG"

# Check cache directory permissions
if [ -w "$DEBUG_AGENT_CACHE_DIR" ]; then
    echo "  ✓ Cache directory writable"
else
    echo "  ✗ Cannot write to cache directory"
    exit 1
fi

echo ""
echo "================================"
echo " Setup Complete!"
echo "================================"
echo ""
echo "Debug Agent Status:"
echo "  Model: sonnet (complex analysis)"
echo "  MCP Servers: filesystem, serena, sequentialthinking"
echo "  Cache Dir: $DEBUG_AGENT_CACHE_DIR"
echo "  Dumps Dir: $DEBUG_AGENT_DUMPS_DIR"
echo "  Profiles Dir: $DEBUG_AGENT_PROFILES_DIR"
echo ""
echo "Agent ready for debugging and troubleshooting tasks."