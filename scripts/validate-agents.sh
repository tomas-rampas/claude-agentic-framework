#!/bin/bash
# validate-agents.sh - Quick agent validation script

echo "🤖 Agent Validation Check"
echo "=========================="
echo ""

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

MISSING=0

for agent in "${EXPECTED_AGENTS[@]}"; do
  if [ -f "agents/${agent}.md" ]; then
    echo "✅ ${agent}"
  else
    echo "❌ ${agent} MISSING"
    ((MISSING++))
  fi
done

echo ""
echo "================================"
if [ $MISSING -eq 0 ]; then
  echo "✅ All 18 agents present"
  exit 0
else
  echo "❌ Missing $MISSING agents"
  exit 1
fi
