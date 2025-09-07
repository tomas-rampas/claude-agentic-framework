#!/bin/bash

# Generic Agent Setup Script Template
# Usage: This template validates MCP configurations for all agents

set -e

AGENT_NAME="${1:-agent}"
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

# Check npx
if command -v npx &> /dev/null; then
    echo "✓ npx available"
else
    echo "ERROR: npx not found. Please install Node.js"
    exit 1
fi

# Validate JSON configuration
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

# Parse MCP servers from config
echo "MCP servers configured:"
python3 -c "
import json
with open('$MCP_CONFIG') as f:
    config = json.load(f)
    for server in config.get('mcpServers', {}):
        print(f'  - {server}')
"

echo ""
echo "=== $AGENT_NAME setup complete ==="