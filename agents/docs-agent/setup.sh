#!/bin/bash

# Docs Agent Setup Script
# Initializes the docs-agent for documentation generation

set -e

AGENT_NAME="docs-agent"
AGENT_DIR="~/.claude/agents/docs-agent"
CONFIG_FILE="$AGENT_DIR/settings.json"

echo "================================"
echo " Docs Agent Setup"
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
export DOCS_AGENT_LOG_LEVEL="${DOCS_AGENT_LOG_LEVEL:-info}"
export DOCS_AGENT_OUTPUT_DIR="${DOCS_AGENT_OUTPUT_DIR:-/tmp/docs-output}"
export DOCS_AGENT_TEMPLATES_DIR="${DOCS_AGENT_TEMPLATES_DIR:-~/.claude/templates/docs}"
export DOCS_AGENT_CACHE_DIR="${DOCS_AGENT_CACHE_DIR:-/tmp/docs-cache}"

# Create required directories
mkdir -p "$DOCS_AGENT_OUTPUT_DIR"
mkdir -p "$DOCS_AGENT_TEMPLATES_DIR"
mkdir -p "$DOCS_AGENT_CACHE_DIR"
echo "  ✓ Environment configured"

# 4. Test MCP server connections
echo "[4/8] Testing MCP server connections..."

# Test Filesystem MCP
echo -n "  → Filesystem MCP: "
if command -v filesystem &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (critical for doc operations)"
fi

# Test Context7 MCP
echo -n "  → Context7 MCP: "
if command -v context7 &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Not found (needed for examples)"
fi

# 5. Check documentation tools
echo "[5/8] Checking documentation tools..."

# Markdown processors
echo -n "  → Markdown support: "
if command -v markdown &> /dev/null || command -v pandoc &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Basic markdown only"
fi

# Spell checkers
echo -n "  → Spell checker: "
if command -v aspell &> /dev/null || command -v hunspell &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ No spell checking available"
fi

# Diagram tools
echo -n "  → Mermaid CLI: "
if command -v mmdc &> /dev/null; then
    echo "✓ Available"
else
    echo "⚠ Mermaid diagrams as code only"
fi

# 6. Initialize documentation templates
echo "[6/8] Initializing templates..."

# Create README template
README_TEMPLATE="$DOCS_AGENT_TEMPLATES_DIR/readme.md"
if [ ! -f "$README_TEMPLATE" ]; then
    cat > "$README_TEMPLATE" << 'EOF'
# {PROJECT_NAME}

{BADGES}

{DESCRIPTION}

## Features

{FEATURES}

## Installation

```bash
{INSTALLATION}
```

## Usage

```{LANGUAGE}
{USAGE_EXAMPLE}
```

## API Reference

{API_REFERENCE}

## Contributing

{CONTRIBUTING}

## License

{LICENSE}
EOF
    echo "  ✓ Created README template"
fi

# Create API documentation template
API_TEMPLATE="$DOCS_AGENT_TEMPLATES_DIR/api.md"
if [ ! -f "$API_TEMPLATE" ]; then
    cat > "$API_TEMPLATE" << 'EOF'
# API Documentation

## Endpoint: {ENDPOINT}

**Method:** `{METHOD}`

**Description:** {DESCRIPTION}

### Request

```json
{REQUEST_BODY}
```

### Response

```json
{RESPONSE_BODY}
```

### Example

```bash
{CURL_EXAMPLE}
```
EOF
    echo "  ✓ Created API template"
else
    echo "  ✓ Templates already exist"
fi

# 7. Grammar and style check
echo "[7/8] Setting up quality checks..."

# Create basic style configuration
STYLE_CONFIG="$DOCS_AGENT_CACHE_DIR/style.yaml"
if [ ! -f "$STYLE_CONFIG" ]; then
    cat > "$STYLE_CONFIG" << 'EOF'
# Documentation Style Guide
rules:
  - name: sentence_length
    max: 25
  - name: paragraph_length
    max: 150
  - name: heading_style
    type: atx
  - name: list_style
    marker: "-"
EOF
    echo "  ✓ Created style configuration"
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
TEST_DOC="$DOCS_AGENT_OUTPUT_DIR/test.md"
if echo "# Test" > "$TEST_DOC" 2>/dev/null; then
    rm "$TEST_DOC"
    echo "  ✓ Can write documentation"
else
    echo "  ✗ Cannot write to output directory"
    exit 1
fi

# Check template directory
if [ -d "$DOCS_AGENT_TEMPLATES_DIR" ] && [ -r "$DOCS_AGENT_TEMPLATES_DIR" ]; then
    echo "  ✓ Templates directory accessible"
else
    echo "  ✗ Templates directory not accessible"
    exit 1
fi

echo ""
echo "================================"
echo " Setup Complete!"
echo "================================"
echo ""
echo "Docs Agent Status:"
echo "  Model: haiku (efficient writing)"
echo "  MCP Servers: filesystem, context7"
echo "  Output Dir: $DOCS_AGENT_OUTPUT_DIR"
echo "  Templates: $DOCS_AGENT_TEMPLATES_DIR"
echo ""
echo "Agent ready for documentation generation."