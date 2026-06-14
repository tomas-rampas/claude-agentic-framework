#!/usr/bin/env bash
# validate-hooks.sh - Hook consistency validation (dynamic).
#
# Keeps the original behavior (deprecated-name scan + JSON syntax validity) but
# sources the deprecated list from the shared facts layer instead of hardcoding
# it, and adds a hook-coverage parity check (every non-allowlisted agent has a
# {agent}-validation.json; no orphan validation hooks). No hardcoded agent
# names or counts remain.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/facts.sh
source "$SCRIPT_DIR/lib/facts.sh"

ROOT="$FACTS_REPO_ROOT"
HOOKS_DIR="$FACTS_HOOKS_DIR"

echo "🪝 Hook Validation Check"
echo "========================"
echo ""

ERRORS=0

# ---------------------------------------------------------------------------
# 1. Deprecated agent references in hooks/*.json
#    The deprecated list is DERIVED from claude.json .consistency, not frozen.
#    We match deprecated names as JSON string tokens ("name") inside hook json,
#    excluding any archive paths.
# ---------------------------------------------------------------------------
echo "Checking for deprecated agent references in hooks/..."
echo ""

DEPRECATED="$(fact_deprecated)"
DEP_FOUND=0

while IFS= read -r name; do
  [[ -z "$name" ]] && continue
  esc="$(printf '%s' "$name" | sed 's/[.[\*^$()+?{}|\\]/\\&/g')"
  shopt -s nullglob
  for f in "$HOOKS_DIR"/*.json; do
    case "$f" in *archive*) continue;; esac
    hits="$(grep -nE "\"${esc}\"" "$f" 2>/dev/null)"
    if [[ -n "$hits" ]]; then
      echo "❌ Found deprecated name '$name' in $(basename "$f"):"
      while IFS= read -r ln; do [[ -n "$ln" ]] && echo "     $ln"; done <<< "$hits"
      DEP_FOUND=$((DEP_FOUND + 1))
      ERRORS=$((ERRORS + 1))
    fi
  done
  shopt -u nullglob
done <<< "$DEPRECATED"

if [[ "$DEP_FOUND" -eq 0 ]]; then
  ndep="$(printf '%s\n' "$DEPRECATED" | grep -c . || true)"
  echo "✅ No deprecated agent references found (checked ${ndep} names)"
fi

# ---------------------------------------------------------------------------
# 2. Hook-coverage parity
#    Every agent NOT on the allowlist must have hooks/<agent>-validation.json;
#    every *-validation.json must map to a real agent (no orphan).
# ---------------------------------------------------------------------------
echo ""
echo "Checking hook coverage parity..."
echo ""

AGENTS="$(fact_agents)"
ALLOWLIST="$(fact_allowlist)"
REQUIRED="$(comm -23 <(printf '%s\n' "$AGENTS") <(printf '%s\n' "$ALLOWLIST"))"

shopt -s nullglob
EXISTING=""
for f in "$HOOKS_DIR"/*-validation.json; do
  b="$(basename "$f")"
  EXISTING+="${b%-validation.json}"$'\n'
done
shopt -u nullglob
EXISTING_SORTED="$(printf '%s' "$EXISTING" | grep -v '^$' | LC_ALL=C sort)"

COV_ERRORS=0

NO_HOOK="$(comm -23 <(printf '%s\n' "$REQUIRED") <(printf '%s\n' "$EXISTING_SORTED"))"
if [[ -n "$NO_HOOK" ]]; then
  while IFS= read -r a; do
    [[ -z "$a" ]] && continue
    echo "❌ Missing hooks/${a}-validation.json for agent '${a}'"
    COV_ERRORS=$((COV_ERRORS + 1))
    ERRORS=$((ERRORS + 1))
  done <<< "$NO_HOOK"
fi

ORPHAN_HOOK="$(comm -23 <(printf '%s\n' "$EXISTING_SORTED") <(printf '%s\n' "$AGENTS"))"
if [[ -n "$ORPHAN_HOOK" ]]; then
  while IFS= read -r a; do
    [[ -z "$a" ]] && continue
    echo "❌ Orphan hooks/${a}-validation.json maps to no registered agent"
    COV_ERRORS=$((COV_ERRORS + 1))
    ERRORS=$((ERRORS + 1))
  done <<< "$ORPHAN_HOOK"
fi

if [[ "$COV_ERRORS" -eq 0 ]]; then
  nreq="$(printf '%s\n' "$REQUIRED" | grep -c . || true)"
  echo "✅ Hook coverage complete: all ${nreq} required agents covered; no orphans"
  if [[ -n "$ALLOWLIST" ]]; then
    while IFS= read -r a; do
      [[ -z "$a" ]] && continue
      echo "ℹ️  allowlisted (no per-agent hook required): ${a}"
    done <<< "$ALLOWLIST"
  fi
fi

# ---------------------------------------------------------------------------
# 3. JSON syntax validity for all hooks/*.json
# ---------------------------------------------------------------------------
echo ""
echo "Validating JSON syntax..."
echo ""

if command -v jq >/dev/null 2>&1; then
  JSON_ERRORS=0
  shopt -s nullglob
  for f in "$HOOKS_DIR"/*.json; do
    if jq empty "$f" >/dev/null 2>&1; then
      echo "✅ $(basename "$f")"
    else
      echo "❌ $(basename "$f") - INVALID JSON"
      JSON_ERRORS=$((JSON_ERRORS + 1))
      ERRORS=$((ERRORS + 1))
    fi
  done
  shopt -u nullglob
  if [[ "$JSON_ERRORS" -eq 0 ]]; then
    echo ""
    echo "✅ All JSON files valid"
  fi
else
  echo "⚠️  jq not installed, skipping JSON validation"
fi

echo ""
echo "================================"
if [[ "$ERRORS" -eq 0 ]]; then
  echo "✅ Hook validation passed"
  exit 0
else
  echo "❌ Found $ERRORS error(s)"
  exit 1
fi
