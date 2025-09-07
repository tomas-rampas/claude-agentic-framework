#!/bin/bash

# Security Agent Setup Script
# Initializes the security-agent for vulnerability scanning

set -e

AGENT_NAME="security-agent"
AGENT_DIR="~/.claude/agents/security-agent"
CONFIG_FILE="$AGENT_DIR/settings.json"

echo "================================"
echo " Security Agent Setup"
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
export SECURITY_AGENT_LOG_LEVEL="${SECURITY_AGENT_LOG_LEVEL:-info}"
export SECURITY_AGENT_CACHE_DIR="${SECURITY_AGENT_CACHE_DIR:-/tmp/security-agent-cache}"
export SECURITY_AGENT_REPORTS_DIR="${SECURITY_AGENT_REPORTS_DIR:-/tmp/security-reports}"
export SECURITY_AGENT_PATTERNS_DIR="${SECURITY_AGENT_PATTERNS_DIR:-~/.claude/security/patterns}"

# Create required directories
mkdir -p "$SECURITY_AGENT_CACHE_DIR"
mkdir -p "$SECURITY_AGENT_REPORTS_DIR"
mkdir -p "$SECURITY_AGENT_PATTERNS_DIR"
echo "  ✓ Environment configured"

# 4. Test MCP server connections
echo "[4/8] Testing MCP server connections..."

# Test Serena MCP
echo -n "  → Serena MCP: "
if command -v serena &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (critical for data flow analysis)"
fi

# Test Filesystem MCP
echo -n "  → Filesystem MCP: "
if command -v filesystem &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (needed for pattern scanning)"
fi

# 5. Verify security tools
echo "[5/8] Verifying security tools..."
REQUIRED_TOOLS=("grep" "find" "awk" "sed")
OPTIONAL_TOOLS=("semgrep" "bandit" "gosec" "npm audit")

for tool in "${REQUIRED_TOOLS[@]}"; do
    echo -n "  → $tool: "
    if command -v $tool &> /dev/null; then
        echo "✓"
    else
        echo "✗ Missing (required)"
        exit 1
    fi
done

echo "  Optional security tools:"
for tool in "${OPTIONAL_TOOLS[@]}"; do
    echo -n "  → $tool: "
    if command -v $tool &> /dev/null 2>&1; then
        echo "✓ Available"
    else
        echo "⚠ Not found (enhanced scanning unavailable)"
    fi
done

# 6. Initialize security patterns
echo "[6/8] Initializing security patterns..."

# Create default patterns file if it doesn't exist
PATTERNS_FILE="$SECURITY_AGENT_PATTERNS_DIR/default-patterns.yaml"
if [ ! -f "$PATTERNS_FILE" ]; then
    cat > "$PATTERNS_FILE" << 'EOF'
# Default Security Patterns
patterns:
  sql_injection:
    - pattern: "SELECT .* FROM .* WHERE .* = .*\\$"
      severity: high
      message: "Potential SQL injection vulnerability"
    
  xss:
    - pattern: "innerHTML\\s*=\\s*[^'\"]*\\$"
      severity: high
      message: "Potential XSS vulnerability"
    
  hardcoded_secret:
    - pattern: "(password|secret|key)\\s*=\\s*['\"][^'\"]{8,}['\"]"
      severity: critical
      message: "Hardcoded secret detected"
EOF
    echo "  ✓ Created default patterns"
else
    echo "  ✓ Patterns already initialized"
fi

# 7. Vulnerability database check
echo "[7/8] Checking vulnerability databases..."

# Check for CVE database access
if ping -c 1 nvd.nist.gov &> /dev/null; then
    echo "  ✓ NVD database accessible"
else
    echo "  ⚠ NVD database not accessible (offline mode)"
fi

# Check for local vulnerability cache
VULN_CACHE="$SECURITY_AGENT_CACHE_DIR/vulndb.json"
if [ -f "$VULN_CACHE" ]; then
    AGE=$(($(date +%s) - $(stat -c %Y "$VULN_CACHE")))
    if [ $AGE -gt 86400 ]; then
        echo "  ⚠ Vulnerability cache outdated (>24h)"
    else
        echo "  ✓ Vulnerability cache up-to-date"
    fi
else
    echo "  ⚠ No vulnerability cache (will fetch on first run)"
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

# Test pattern matching performance
TEST_FILE="$SECURITY_AGENT_CACHE_DIR/test.txt"
echo "password = 'test123'" > "$TEST_FILE"
if grep -q "password" "$TEST_FILE" 2>/dev/null; then
    echo "  ✓ Pattern matching working"
else
    echo "  ✗ Pattern matching failed"
    exit 1
fi
rm "$TEST_FILE"

# Check report directory permissions
if [ -w "$SECURITY_AGENT_REPORTS_DIR" ]; then
    echo "  ✓ Reports directory writable"
else
    echo "  ✗ Cannot write to reports directory"
    exit 1
fi

echo ""
echo "================================"
echo " Setup Complete!"
echo "================================"
echo ""
echo "Security Agent Status:"
echo "  Model: haiku (fast scanning)"
echo "  MCP Servers: serena, filesystem"
echo "  Cache Dir: $SECURITY_AGENT_CACHE_DIR"
echo "  Reports Dir: $SECURITY_AGENT_REPORTS_DIR"
echo "  Patterns Dir: $SECURITY_AGENT_PATTERNS_DIR"
echo ""
echo "Agent ready for security vulnerability scanning."