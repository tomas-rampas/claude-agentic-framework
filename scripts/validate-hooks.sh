#!/bin/bash
# validate-hooks.sh - Hook consistency validation

echo "🪝 Hook Validation Check"
echo "========================"
echo ""

ERRORS=0

# Old agent names that should NOT appear in hooks
OLD_AGENTS=(
  "maker-agent"
  "test-agent"
  "debug-agent"
  "reader-agent"
  "plan-agent"
  "security-agent"
  "docs-agent"
  "rust-systems-expert"
)

echo "Checking for old agent references..."
echo ""

for old_agent in "${OLD_AGENTS[@]}"; do
  if grep -r "\"$old_agent\"" hooks/ 2>/dev/null | grep -v "archive" | grep -q .; then
    echo "❌ Found '$old_agent' in:"
    grep -r "\"$old_agent\"" hooks/ | grep -v "archive"
    ((ERRORS++))
  fi
done

if [ $ERRORS -eq 0 ]; then
  echo "✅ No old agent references found"
fi

echo ""
echo "Validating JSON syntax..."
echo ""

if command -v jq &> /dev/null; then
  JSON_ERRORS=0
  for file in hooks/*.json; do
    if [ -f "$file" ]; then
      if jq empty "$file" 2>/dev/null; then
        echo "✅ $(basename "$file")"
      else
        echo "❌ $(basename "$file") - INVALID JSON"
        ((JSON_ERRORS++))
        ((ERRORS++))
      fi
    fi
  done

  if [ $JSON_ERRORS -eq 0 ]; then
    echo ""
    echo "✅ All JSON files valid"
  fi
else
  echo "⚠️  jq not installed, skipping JSON validation"
fi

echo ""
echo "================================"
if [ $ERRORS -eq 0 ]; then
  echo "✅ Hook validation passed"
  exit 0
else
  echo "❌ Found $ERRORS errors"
  exit 1
fi
