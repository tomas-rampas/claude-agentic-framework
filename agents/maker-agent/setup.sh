#!/bin/bash

# Maker Agent Setup Script
# Initializes the maker-agent with MCP connections and development environment

set -e

AGENT_NAME="maker-agent"
AGENT_DIR="~/.claude/agents/maker-agent"
CONFIG_FILE="$AGENT_DIR/settings.json"

echo "================================"
echo " Maker Agent Setup"
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
export MAKER_AGENT_LOG_LEVEL="${MAKER_AGENT_LOG_LEVEL:-info}"
export MAKER_AGENT_CACHE_DIR="${MAKER_AGENT_CACHE_DIR:-/tmp/maker-agent-cache}"
export MAKER_AGENT_BACKUP_DIR="${MAKER_AGENT_BACKUP_DIR:-/tmp/maker-agent-backups}"
export MAKER_AGENT_TEMPLATES_DIR="${MAKER_AGENT_TEMPLATES_DIR:-~/.claude/templates/code}"

# Create required directories
mkdir -p "$MAKER_AGENT_CACHE_DIR"
mkdir -p "$MAKER_AGENT_BACKUP_DIR"
mkdir -p "$MAKER_AGENT_TEMPLATES_DIR"
echo "  ✓ Environment configured"

# 4. Test MCP server connections
echo "[4/8] Testing MCP server connections..."

# Test Filesystem MCP
echo -n "  → Filesystem MCP: "
if command -v filesystem &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (critical for maker-agent)"
fi

# Test Serena MCP
echo -n "  → Serena MCP: "
if command -v serena &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (critical for refactoring)"
fi

# Test Context7 MCP
echo -n "  → Context7 MCP: "
if command -v context7 &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (needed for library docs)"
fi

# Test Sequential Thinking MCP
echo -n "  → Sequential Thinking MCP: "
if command -v sequentialthinking &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (will use fallback)"
fi

# 5. Verify development tools
echo "[5/8] Verifying development tools..."
REQUIRED_TOOLS=("git" "grep" "find" "jq")
OPTIONAL_TOOLS=("node" "python" "go" "docker")

for tool in "${REQUIRED_TOOLS[@]}"; do
    echo -n "  → $tool: "
    if command -v $tool &> /dev/null; then
        echo "✓ $(command -v $tool)"
    else
        echo "✗ Missing (required)"
        exit 1
    fi
done

echo "  Optional tools:"
for tool in "${OPTIONAL_TOOLS[@]}"; do
    echo -n "  → $tool: "
    if command -v $tool &> /dev/null; then
        echo "✓ $(${tool} --version 2>&1 | head -1)"
    else
        echo "⚠ Not found"
    fi
done

# 6. Initialize code templates
echo "[6/8] Initializing code templates..."

# Create basic templates if they don't exist
if [ ! -f "$MAKER_AGENT_TEMPLATES_DIR/api-endpoint.js" ]; then
    cat > "$MAKER_AGENT_TEMPLATES_DIR/api-endpoint.js" << 'EOF'
/**
 * [Endpoint Description]
 * @route [METHOD] /api/[path]
 */
async function handler(req, res) {
    try {
        // Validate input
        const { /* params */ } = req.body;
        
        // Business logic
        
        // Return response
        res.status(200).json({
            success: true,
            data: {}
        });
    } catch (error) {
        console.error('[Endpoint] Error:', error);
        res.status(500).json({
            success: false,
            error: 'Internal server error'
        });
    }
}
EOF
    echo "  ✓ Created API endpoint template"
fi

if [ ! -f "$MAKER_AGENT_TEMPLATES_DIR/test-template.js" ]; then
    cat > "$MAKER_AGENT_TEMPLATES_DIR/test-template.js" << 'EOF'
describe('[Component/Function]', () => {
    beforeEach(() => {
        // Setup
    });

    afterEach(() => {
        // Cleanup
    });

    it('should [expected behavior]', async () => {
        // Arrange
        
        // Act
        
        // Assert
    });
});
EOF
    echo "  ✓ Created test template"
else
    echo "  ✓ Templates already initialized"
fi

# 7. Setup git hooks
echo "[7/8] Setting up git hooks..."
HOOKS_FILE="$AGENT_DIR/hooks.yaml"
if [ ! -f "$HOOKS_FILE" ]; then
    echo "  ⚠ hooks.yaml not found, creating..."
    # Will be created separately
else
    echo "  ✓ Hooks configuration found"
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
TEST_FILE="$MAKER_AGENT_CACHE_DIR/test-write"
if echo "test" > "$TEST_FILE" 2>/dev/null; then
    rm "$TEST_FILE"
    echo "  ✓ Write permissions verified"
else
    echo "  ✗ Cannot write to cache directory"
    exit 1
fi

echo ""
echo "================================"
echo " Setup Complete!"
echo "================================"
echo ""
echo "Maker Agent Status:"
echo "  Model: sonnet"
echo "  MCP Servers: filesystem, serena, context7, sequentialthinking"
echo "  Cache Dir: $MAKER_AGENT_CACHE_DIR"
echo "  Backup Dir: $MAKER_AGENT_BACKUP_DIR"
echo "  Templates: $MAKER_AGENT_TEMPLATES_DIR"
echo ""
echo "Agent ready for code creation and development tasks."