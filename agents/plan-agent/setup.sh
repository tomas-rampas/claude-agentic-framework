#!/bin/bash

# Plan-Agent Setup Script
# Initializes MCP servers and validates configuration

set -e

AGENT_NAME="plan-agent"
AGENT_DIR="$(dirname "$(readlink -f "$0")")"
CONFIG_FILE="$AGENT_DIR/config.json"
MCP_CONFIG="$AGENT_DIR/mcp-config.json"

echo "=== Setting up $AGENT_NAME ==="

# Check for required files
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERROR: Missing config.json"
    exit 1
fi

if [ ! -f "$MCP_CONFIG" ]; then
    echo "ERROR: Missing mcp-config.json"
    exit 1
fi

# Check MCP server availability
echo "Checking MCP server availability..."

# Check sequential-thinking
if command -v npx &> /dev/null; then
    echo "✓ npx available"
    
    # Test sequential-thinking MCP
    echo -n "  Testing sequential-thinking MCP... "
    if npx -y @modelcontextprotocol/server-sequential-thinking --version &> /dev/null; then
        echo "✓"
    else
        echo "✗ (will be installed on first use)"
    fi
    
    # Test context7 MCP
    echo -n "  Testing context7 MCP... "
    if [ -z "$CONTEXT7_API_KEY" ]; then
        echo "⚠ CONTEXT7_API_KEY not set"
    else
        echo "✓ API key configured"
    fi
else
    echo "ERROR: npx not found. Please install Node.js"
    exit 1
fi

# Validate configuration
echo "Validating configuration..."
if python3 -m json.tool "$CONFIG_FILE" > /dev/null 2>&1; then
    echo "✓ config.json is valid JSON"
else
    echo "ERROR: config.json is not valid JSON"
    exit 1
fi

if python3 -m json.tool "$MCP_CONFIG" > /dev/null 2>&1; then
    echo "✓ mcp-config.json is valid JSON"
else
    echo "ERROR: mcp-config.json is not valid JSON"
    exit 1
fi

# Set environment variables
export SEQUENTIAL_THINKING_MODE="comprehensive"
export MAX_DEPTH="10"
export ENABLE_VALIDATION="true"

echo ""
echo "=== $AGENT_NAME setup complete ==="
echo "MCP servers configured:"
echo "  - sequential-thinking (primary)"
echo "  - context7 (secondary)"
echo ""
echo "To activate: source $0"