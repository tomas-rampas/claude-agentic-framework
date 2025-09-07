#!/bin/bash

# Reader Agent Setup Script
# Initializes the reader-agent for fast file analysis

set -e

AGENT_NAME="reader-agent"
AGENT_DIR="~/.claude/agents/reader-agent"
CONFIG_FILE="$AGENT_DIR/settings.json"

echo "================================"
echo " Reader Agent Setup"
echo "================================"
echo ""

# 1. Verify agent directory
echo "[1/7] Verifying agent directory..."
if [ ! -d "$AGENT_DIR" ]; then
    echo "  ✗ Agent directory not found: $AGENT_DIR"
    exit 1
fi
echo "  ✓ Agent directory verified"

# 2. Check configuration file
echo "[2/7] Checking configuration..."
if [ ! -f "$CONFIG_FILE" ]; then
    echo "  ✗ Configuration file not found: $CONFIG_FILE"
    exit 1
fi
echo "  ✓ Configuration loaded"

# 3. Setup environment variables
echo "[3/7] Setting up environment..."
export READER_AGENT_LOG_LEVEL="${READER_AGENT_LOG_LEVEL:-warn}"
export READER_AGENT_CACHE_DIR="${READER_AGENT_CACHE_DIR:-/tmp/reader-agent-cache}"
export READER_AGENT_INDEX_DIR="${READER_AGENT_INDEX_DIR:-/tmp/reader-agent-index}"

# Create required directories
mkdir -p "$READER_AGENT_CACHE_DIR"
mkdir -p "$READER_AGENT_INDEX_DIR"
echo "  ✓ Environment configured"

# 4. Test MCP server connections
echo "[4/7] Testing MCP server connections..."

# Test Filesystem MCP
echo -n "  → Filesystem MCP: "
if command -v filesystem &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (critical for reader-agent)"
fi

# Test Serena MCP
echo -n "  → Serena MCP: "
if command -v serena &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (needed for symbol analysis)"
fi

# 5. Verify required tools
echo "[5/7] Verifying required tools..."
REQUIRED_TOOLS=("grep" "find" "wc" "head" "tail")
OPTIONAL_TOOLS=("rg" "ag" "fd")

for tool in "${REQUIRED_TOOLS[@]}"; do
    echo -n "  → $tool: "
    if command -v $tool &> /dev/null; then
        echo "✓"
    else
        echo "✗ Missing (required)"
        exit 1
    fi
done

echo "  Performance tools (optional):"
for tool in "${OPTIONAL_TOOLS[@]}"; do
    echo -n "  → $tool: "
    if command -v $tool &> /dev/null; then
        echo "✓ Available (performance boost)"
    else
        echo "⚠ Not found"
    fi
done

# 6. Performance optimization
echo "[6/7] Optimizing for performance..."

# Check available memory
MEM_AVAILABLE=$(free -m | awk 'NR==2{print $7}')
echo "  → Available memory: ${MEM_AVAILABLE}MB"

# Set cache size based on available memory
if [ "$MEM_AVAILABLE" -gt 2048 ]; then
    export READER_CACHE_SIZE="large"
    echo "  ✓ Large cache enabled"
elif [ "$MEM_AVAILABLE" -gt 1024 ]; then
    export READER_CACHE_SIZE="medium"
    echo "  ✓ Medium cache enabled"
else
    export READER_CACHE_SIZE="small"
    echo "  ⚠ Small cache (limited memory)"
fi

# Check for fast search tools
if command -v rg &> /dev/null; then
    export READER_SEARCH_TOOL="rg"
    echo "  ✓ Using ripgrep for fast search"
elif command -v ag &> /dev/null; then
    export READER_SEARCH_TOOL="ag"
    echo "  ✓ Using silver searcher"
else
    export READER_SEARCH_TOOL="grep"
    echo "  ⚠ Using standard grep (slower)"
fi

# 7. Health check
echo "[7/7] Running health check..."

# Check if agent.md is accessible
if [ -f "$AGENT_DIR/agent.md" ]; then
    echo "  ✓ Agent definition accessible"
else
    echo "  ✗ Agent definition not found"
    exit 1
fi

# Test read performance
TEST_FILE="$READER_AGENT_CACHE_DIR/perf-test"
echo "test content" > "$TEST_FILE"
START_TIME=$(date +%s%N)
cat "$TEST_FILE" > /dev/null 2>&1
END_TIME=$(date +%s%N)
ELAPSED=$((($END_TIME - $START_TIME) / 1000000))
rm "$TEST_FILE"
echo "  ✓ Read performance: ${ELAPSED}ms"

# Check cache directory permissions
if [ -w "$READER_AGENT_CACHE_DIR" ]; then
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
echo "Reader Agent Status:"
echo "  Model: haiku (optimized for speed)"
echo "  MCP Servers: filesystem, serena"
echo "  Cache Dir: $READER_AGENT_CACHE_DIR"
echo "  Index Dir: $READER_AGENT_INDEX_DIR"
echo "  Search Tool: $READER_SEARCH_TOOL"
echo "  Cache Size: $READER_CACHE_SIZE"
echo ""
echo "Agent ready for high-speed file analysis."