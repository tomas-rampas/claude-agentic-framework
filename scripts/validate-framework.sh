#!/bin/bash
# validate-framework.sh - Comprehensive framework validation script
# Validates the Claude Code CLI Agentic Framework integrity

set -e

echo "🔍 Claude Code CLI Agentic Framework Validator"
echo "================================================"
echo ""

ERRORS=0
WARNINGS=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Expected agents (18 total)
EXPECTED_AGENTS=(
  "rust-expert"
  "csharp-expert"
  "go-expert"
  "java-expert"
  "python-expert"
  "typescript-expert"
  "bash-expert"
  "powershell-expert"
  "database-specialist"
  "frontend-specialist"
  "security-specialist"
  "uiux-specialist"
  "devops-orchestrator"
  "system-architect"
  "comprehensive-analyst"
  "code-review-gatekeeper"
  "technical-docs-writer"
  "product-owner"
)

# Old agent names that should NOT exist
OLD_AGENTS=(
  "plan-agent"
  "reader-agent"
  "maker-agent"
  "security-agent"
  "test-agent"
  "docs-agent"
  "debug-agent"
  "rust-systems-expert"
)

echo "📋 Step 1: Validating Core Files"
echo "--------------------------------"

# Check CLAUDE.md
if [ -f "CLAUDE.md" ]; then
  echo -e "${GREEN}✅${NC} CLAUDE.md found"
else
  echo -e "${RED}❌${NC} CLAUDE.md missing"
  ((ERRORS++))
fi

# Check claude.json
if [ -f "claude.json" ]; then
  echo -e "${GREEN}✅${NC} claude.json found"

  # Validate JSON syntax
  if command -v jq &> /dev/null; then
    if jq empty claude.json 2>/dev/null; then
      echo -e "${GREEN}✅${NC} claude.json has valid JSON syntax"
    else
      echo -e "${RED}❌${NC} claude.json has invalid JSON syntax"
      ((ERRORS++))
    fi
  fi
else
  echo -e "${RED}❌${NC} claude.json missing"
  ((ERRORS++))
fi

# Check README.md
if [ -f "README.md" ]; then
  echo -e "${GREEN}✅${NC} README.md found"
else
  echo -e "${YELLOW}⚠️${NC}  README.md missing"
  ((WARNINGS++))
fi

echo ""
echo "📁 Step 2: Validating Directories"
echo "--------------------------------"

# Check required directories
for dir in "agents" "commands" "hooks" "shared" "skills"; do
  if [ -d "$dir" ]; then
    echo -e "${GREEN}✅${NC} $dir/ directory exists"
  else
    echo -e "${RED}❌${NC} $dir/ directory missing"
    ((ERRORS++))
  fi
done

echo ""
echo "🤖 Step 3: Validating Agents (18 expected)"
echo "----------------------------------------"

AGENT_COUNT=0
for agent in "${EXPECTED_AGENTS[@]}"; do
  if [ -f "agents/${agent}.md" ]; then
    echo -e "${GREEN}✅${NC} ${agent}.md"
    ((AGENT_COUNT++))
  else
    echo -e "${RED}❌${NC} ${agent}.md MISSING"
    ((ERRORS++))
  fi
done

echo ""
echo "Agent count: $AGENT_COUNT / 18"

if [ $AGENT_COUNT -eq 18 ]; then
  echo -e "${GREEN}✅${NC} All 18 agents present"
else
  echo -e "${RED}❌${NC} Expected 18 agents, found $AGENT_COUNT"
  ((ERRORS++))
fi

echo ""
echo "🚫 Step 4: Checking for Old Agent Names"
echo "--------------------------------------"

OLD_FOUND=0
for old_agent in "${OLD_AGENTS[@]}"; do
  # Check in claude.json
  if grep -q "\"$old_agent\"" claude.json 2>/dev/null; then
    echo -e "${RED}❌${NC} Found old agent name '$old_agent' in claude.json"
    ((ERRORS++))
    ((OLD_FOUND++))
  fi

  # Check in hooks
  if grep -r "\"$old_agent\"" hooks/ 2>/dev/null | grep -v "archive" >/dev/null; then
    echo -e "${RED}❌${NC} Found old agent name '$old_agent' in hooks/"
    ((ERRORS++))
    ((OLD_FOUND++))
  fi
done

if [ $OLD_FOUND -eq 0 ]; then
  echo -e "${GREEN}✅${NC} No old agent names found"
fi

echo ""
echo "🪝 Step 5: Validating Hooks"
echo "-------------------------"

HOOK_COUNT=$(find hooks/ -maxdepth 1 -name "*.json" -o -name "*.yaml" 2>/dev/null | wc -l)
echo "Found $HOOK_COUNT hook files"

if [ $HOOK_COUNT -gt 0 ]; then
  echo -e "${GREEN}✅${NC} Hook files present"

  # Validate JSON syntax if jq is available
  if command -v jq &> /dev/null; then
    JSON_ERRORS=0
    for file in hooks/*.json; do
      if [ -f "$file" ]; then
        if ! jq empty "$file" 2>/dev/null; then
          echo -e "${RED}❌${NC} Invalid JSON in $(basename "$file")"
          ((ERRORS++))
          ((JSON_ERRORS++))
        fi
      fi
    done

    if [ $JSON_ERRORS -eq 0 ]; then
      echo -e "${GREEN}✅${NC} All JSON hook files have valid syntax"
    fi
  fi
else
  echo -e "${YELLOW}⚠️${NC}  No hook files found"
  ((WARNINGS++))
fi

echo ""
echo "🎯 Step 6: Validating Skills"
echo "---------------------------"

SKILL_COUNT=$(find skills/ -maxdepth 1 -name "*.md" 2>/dev/null | wc -l)
echo "Found $SKILL_COUNT skill files"

if [ $SKILL_COUNT -gt 0 ]; then
  echo -e "${GREEN}✅${NC} Skill files present"
else
  echo -e "${YELLOW}⚠️${NC}  No skill files found"
  ((WARNINGS++))
fi

echo ""
echo "📊 Validation Summary"
echo "===================="
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo -e "${GREEN}🎉 PERFECT!${NC} Framework validation passed with no errors or warnings"
  echo ""
  echo "✅ All core files present"
  echo "✅ All 18 agents configured"
  echo "✅ No old agent names found"
  echo "✅ All hooks valid"
  echo "✅ Skills system in place"
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo -e "${YELLOW}⚠️  WARNINGS FOUND${NC}"
  echo "Errors: 0"
  echo "Warnings: $WARNINGS"
  echo ""
  echo "Framework is functional but has minor issues"
  exit 0
else
  echo -e "${RED}❌ VALIDATION FAILED${NC}"
  echo "Errors: $ERRORS"
  echo "Warnings: $WARNINGS"
  echo ""
  echo "Please fix the errors above before using the framework"
  exit 1
fi
