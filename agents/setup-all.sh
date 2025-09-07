#!/bin/bash

# Master Setup Script for All Claude Code Agents
# Validates all MCP configurations and agent setups

set -e

AGENTS_DIR="$(dirname "$(readlink -f "$0")")"
CLAUDE_CONFIG="$HOME/.claude/claude.json"

echo "╔═══════════════════════════════════════════════════════╗"
echo "║     Claude Code MCP-Enhanced Agents Setup            ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo ""

# Check main configuration
if [ ! -f "$CLAUDE_CONFIG" ]; then
    echo "ERROR: Missing main claude.json configuration"
    exit 1
fi

echo "Validating main configuration..."
if python3 -m json.tool "$CLAUDE_CONFIG" > /dev/null 2>&1; then
    echo "✓ claude.json is valid"
else
    echo "ERROR: claude.json is not valid JSON"
    exit 1
fi

# Check Node.js and npx
echo ""
echo "Checking system requirements..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✓ Node.js installed: $NODE_VERSION"
else
    echo "ERROR: Node.js not found. Please install Node.js 16+ to use MCP servers"
    exit 1
fi

if command -v npx &> /dev/null; then
    echo "✓ npx available"
else
    echo "ERROR: npx not found"
    exit 1
fi

# Check Python for JSON validation
if command -v python3 &> /dev/null; then
    echo "✓ Python3 available for validation"
else
    echo "WARNING: Python3 not found, skipping JSON validation"
fi

if command -v uvx &> /dev/null; then
    echo "✓ uvx available for Serena MCP"
else
    echo "WARNING: uvx not found, Serena MCP may not work"
fi

# Environment variables check
echo ""
echo "Checking environment variables..."
if [ -z "$CONTEXT7_API_KEY" ]; then
    echo "⚠ CONTEXT7_API_KEY not set - context7 MCP will not work"
    echo "  To set: export CONTEXT7_API_KEY='your-api-key'"
else
    echo "✓ CONTEXT7_API_KEY configured"
fi

# List of agents to setup
AGENTS=(
    "plan-agent"
    "reader-agent"
    "maker-agent"
    "security-agent"
    "test-agent"
    "docs-agent"
    "debug-agent"
)

# Validate each agent
echo ""
echo "Validating individual agents..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

FAILED_AGENTS=()
SUCCESS_AGENTS=()

for agent in "${AGENTS[@]}"; do
    AGENT_DIR="$AGENTS_DIR/$agent"
    echo ""
    echo "[$agent]"
    # Configuration Auditing
    echo -n "  - Auditing config: "
    if python3 -c "
import json
with open('$AGENT_DIR/mcp-config.json') as f:
    agent_config = json.load(f).get('mcpServers', {})
with open('$CLAUDE_CONFIG') as f:
    main_config = json.load(f).get('mcpServers', {})
valid = True
for server, config in agent_config.items():
    if server not in main_config:
        valid = False
        break
    if config.get('command') != main_config[server].get('command'):
        valid = False
        break
if valid:
    print('✓ consistent')
else:
    print('✗ inconsistent')
" 2>/dev/null; then
        : # pass
    else
        echo "error auditing"
    fi
    
    # Check directory exists
    if [ ! -d "$AGENT_DIR" ]; then
        echo "  ✗ Directory not found"
        FAILED_AGENTS+=("$agent")
        continue
    fi
    
    # Check required files
    FILES_OK=true
    
    if [ -f "$AGENT_DIR/config.json" ]; then
        echo "  ✓ config.json exists"
        if python3 -m json.tool "$AGENT_DIR/config.json" > /dev/null 2>&1; then
            echo "  ✓ config.json valid"
        else
            echo "  ✗ config.json invalid JSON"
            FILES_OK=false
        fi
    else
        echo "  ✗ config.json missing"
        FILES_OK=false
    fi
    
    if [ -f "$AGENT_DIR/mcp-config.json" ]; then
        echo "  ✓ mcp-config.json exists"
        if python3 -m json.tool "$AGENT_DIR/mcp-config.json" > /dev/null 2>&1; then
            echo "  ✓ mcp-config.json valid"
            
            # List MCP servers for this agent
            echo -n "  MCP servers: "
            python3 -c "
import json
with open('$AGENT_DIR/mcp-config.json') as f:
    config = json.load(f)
    servers = list(config.get('mcpServers', {}).keys())
    print(', '.join(servers) if servers else 'none')
" 2>/dev/null || echo "error reading"
        else
            echo "  ✗ mcp-config.json invalid JSON"
            FILES_OK=false
        fi
    else
        echo "  ✗ mcp-config.json missing"
        FILES_OK=false
    fi
    
    if [ -f "$AGENT_DIR/agent.md" ]; then
        echo "  ✓ agent.md exists"
    else
        echo "  ⚠ agent.md missing (optional)"
    fi
    
    if [ -f "$AGENT_DIR/setup.sh" ]; then
        if [ -x "$AGENT_DIR/setup.sh" ]; then
            echo "  ✓ setup.sh executable"
        else
            echo "  ⚠ setup.sh not executable"
        fi
    else
        echo "  ⚠ setup.sh missing (optional)"
    fi
    
    if [ "$FILES_OK" = true ]; then
        SUCCESS_AGENTS+=("$agent")
    else
        FAILED_AGENTS+=("$agent")
    fi
done

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "SETUP SUMMARY"
echo "============="
echo ""
echo "✓ Successful agents (${#SUCCESS_AGENTS[@]}):"
for agent in "${SUCCESS_AGENTS[@]}"; do
    echo "  - $agent"
done

if [ ${#FAILED_AGENTS[@]} -gt 0 ]; then
    echo ""
    echo "✗ Failed agents (${#FAILED_AGENTS[@]}):"
    for agent in "${FAILED_AGENTS[@]}"; do
        echo "  - $agent"
    done
fi

# MCP Server Status
echo ""
echo "MCP SERVER STATUS"
echo "================="
echo ""
echo "Global MCP servers configured in claude.json:"
python3 -c "
import json
with open('$CLAUDE_CONFIG') as f:
    config = json.load(f)
    for server in config.get('mcpServers', {}):
        print(f'  - {server}')
" 2>/dev/null || echo "  Error reading claude.json"

# Test MCP availability
echo ""
echo "Testing MCP server packages..."
echo ""

MCP_PACKAGES=(
    "@modelcontextprotocol/server-sequential-thinking"
    "@modelcontextprotocol/server-filesystem"
    "context7-mcp"
    "serena-mcp"
)

for package in "${MCP_PACKAGES[@]}"; do
    echo -n "  $package ... "
    # Try to check if package exists (will be downloaded on first use)
    if npx -y "$package" --help &> /dev/null || npx -y "$package" --version &> /dev/null; then
        echo "✓ available"
        # Liveness Probe
        echo -n "    - Liveness probe: "
        if npx -y "$package" --health &> /dev/null; then
            echo "✓ healthy"
        else
            echo "⚠ liveness probe failed"
        fi
    else
        echo "⚠ will be installed on first use"
    fi
done

# Final status
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ${#FAILED_AGENTS[@]} -eq 0 ]; then
    echo "✅ All agents configured successfully!"
    echo ""
    echo "MCP-enhanced agent system is ready for use."
else
    echo "⚠️  Some agents have configuration issues."
    echo "Please fix the issues above before using the system."
    exit 1
fi

echo ""
echo "To use the system:"
echo "  1. Ensure CONTEXT7_API_KEY is set (if using context7)"
echo "  2. The Claude Code CLI will automatically engage agents"
echo "  3. MCP servers will be started on-demand"
echo ""
echo "Configuration files:"
echo "  Main: $CLAUDE_CONFIG"
echo "  Agents: $AGENTS_DIR/*/config.json"
echo ""