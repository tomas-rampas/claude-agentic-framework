#!/usr/bin/env bash
# validate-agents.sh - Quick agent validation (dynamic, no hardcoded roster).
#
# Derives the expected agent set from claude.json + the filesystem via the
# shared facts layer. There is NO frozen EXPECTED_AGENTS list and NO hardcoded
# count: registry and filesystem are compared to each other.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/facts.sh
source "$SCRIPT_DIR/lib/facts.sh"

echo "🤖 Agent Validation Check"
echo "=========================="
echo ""

agents="$(fact_agents)"
files="$(fact_agent_files)"
n_agents="$(printf '%s\n' "$agents" | grep -c .)"

MISSING=0

# Every registered agent must have a corresponding agents/<name>.md file.
while IFS= read -r agent; do
  [[ -z "$agent" ]] && continue
  if [[ -f "$FACTS_AGENTS_DIR/${agent}.md" ]]; then
    echo "✅ ${agent}"
  else
    echo "❌ ${agent} MISSING (no agents/${agent}.md)"
    MISSING=$((MISSING + 1))
  fi
done <<< "$agents"

# Report any orphan .md files not registered in claude.json.
ORPHANS="$(comm -13 <(printf '%s\n' "$agents") <(printf '%s\n' "$files"))"
if [[ -n "$ORPHANS" ]]; then
  while IFS= read -r orphan; do
    [[ -z "$orphan" ]] && continue
    echo "❌ ${orphan} ORPHAN (agents/${orphan}.md not in claude.json)"
    MISSING=$((MISSING + 1))
  done <<< "$ORPHANS"
fi

echo ""
echo "================================"
if [[ "$MISSING" -eq 0 ]]; then
  echo "✅ All ${n_agents} agents present and registered"
  exit 0
else
  echo "❌ ${MISSING} agent parity issue(s) found"
  exit 1
fi
