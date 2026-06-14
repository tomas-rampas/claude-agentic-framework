#!/usr/bin/env bash
# facts.sh - Single shared facts layer for the anti-drift consistency system.
#
# Every fact exposed here is DERIVED at runtime from claude.json + the
# filesystem. There are NO hardcoded agent names, counts, or lists. This file
# is meant to be SOURCED (not executed) by validators and, later, generators:
#
#     source "$(dirname "$0")/lib/facts.sh"
#     fact_agents
#
# Conventions:
#   - Functions print to stdout, one item per line (or TAB-separated pairs).
#   - The repo root is resolved robustly so callers work from any CWD.
#   - All lookups go through jq against $FACTS_CLAUDE_JSON.
#
# Requirements: bash, jq.

# --- guard against double-sourcing -----------------------------------------
if [[ -n "${__FACTS_SH_LOADED:-}" ]]; then
  return 0 2>/dev/null || exit 0
fi
__FACTS_SH_LOADED=1

# --- repo root resolution ---------------------------------------------------
# Resolution order:
#   1. FRAMEWORK_ROOT env override (explicit, highest precedence). Used by the
#      test harness to pin resolution to an isolated temp copy of the repo even
#      when that copy happens to live inside an unrelated git working tree (where
#      `git rev-parse` would otherwise resolve to the WRONG root). Must point at
#      a directory containing claude.json.
#   2. git (`git rev-parse --show-toplevel`) for normal in-repo use.
#   3. script-relative walk-up from this file's location so the library keeps
#      working inside a tarball / detached / non-git checkout (e.g. a `cp -r`
#      temp copy with no .git).
#   4. CWD as a last resort.
_facts_resolve_root() {
  local here git_root
  # 1. explicit override (must actually look like the framework root)
  if [[ -n "${FRAMEWORK_ROOT:-}" && -f "${FRAMEWORK_ROOT}/claude.json" ]]; then
    ( cd "${FRAMEWORK_ROOT}" 2>/dev/null && pwd ) && return 0
  fi
  # 2. git
  if git_root="$(git rev-parse --show-toplevel 2>/dev/null)" && [[ -n "$git_root" ]]; then
    printf '%s\n' "$git_root"
    return 0
  fi
  # ${BASH_SOURCE[0]} is scripts/lib/facts.sh -> repo root is two levels up.
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd)"
  if [[ -n "$here" && -f "$here/claude.json" ]]; then
    printf '%s\n' "$here"
    return 0
  fi
  # last resort: CWD
  pwd
}

FACTS_REPO_ROOT="${FACTS_REPO_ROOT:-$(_facts_resolve_root)}"
FACTS_CLAUDE_JSON="${FACTS_CLAUDE_JSON:-$FACTS_REPO_ROOT/claude.json}"
FACTS_AGENTS_DIR="${FACTS_AGENTS_DIR:-$FACTS_REPO_ROOT/agents}"
FACTS_HOOKS_DIR="${FACTS_HOOKS_DIR:-$FACTS_REPO_ROOT/hooks}"

export FACTS_REPO_ROOT FACTS_CLAUDE_JSON FACTS_AGENTS_DIR FACTS_HOOKS_DIR

# --- internal helpers -------------------------------------------------------
_facts_require_jq() {
  if ! command -v jq >/dev/null 2>&1; then
    printf 'facts.sh: ERROR: jq is required but not installed.\n' >&2
    return 127
  fi
}

_facts_require_claude_json() {
  if [[ ! -f "$FACTS_CLAUDE_JSON" ]]; then
    printf 'facts.sh: ERROR: claude.json not found at %s\n' "$FACTS_CLAUDE_JSON" >&2
    return 1
  fi
}

# _facts_jq - jq wrapper that normalizes line endings to LF.
# Some Windows/native jq builds emit CRLF on stdout regardless of input; that
# stray CR breaks comm/diff/string comparisons downstream. Strip it here so
# every fact is guaranteed LF-only and byte-clean on every platform.
_facts_jq() {
  jq "$@" | tr -d '\r'
}

# --- agent facts ------------------------------------------------------------

# fact_agents - sorted agent names from claude.json .sub_agents | keys
fact_agents() {
  _facts_require_jq || return $?
  _facts_require_claude_json || return $?
  _facts_jq -r '.sub_agents | keys[]' "$FACTS_CLAUDE_JSON" | LC_ALL=C sort
}

# fact_agent_files - sorted basenames (without .md) of agents/*.md
fact_agent_files() {
  local f base
  shopt -s nullglob
  for f in "$FACTS_AGENTS_DIR"/*.md; do
    base="$(basename "$f")"
    printf '%s\n' "${base%.md}"
  done | LC_ALL=C sort
  shopt -u nullglob
}

# fact_categories - "category<TAB>agent" pairs from .agent_categories
fact_categories() {
  _facts_require_jq || return $?
  _facts_require_claude_json || return $?
  _facts_jq -r '.agent_categories | to_entries[] | .key as $c | .value[] | "\($c)\t\(.)"' \
    "$FACTS_CLAUDE_JSON"
}

# fact_models - "agent<TAB>model_id" from .sub_agents
fact_models() {
  _facts_require_jq || return $?
  _facts_require_claude_json || return $?
  _facts_jq -r '.sub_agents | to_entries[] | "\(.key)\t\(.value.model)"' "$FACTS_CLAUDE_JSON" \
    | LC_ALL=C sort
}

# --- consistency-block facts ------------------------------------------------

# fact_allowlist - agents intentionally exempt from per-agent hook coverage
fact_allowlist() {
  _facts_require_jq || return $?
  _facts_require_claude_json || return $?
  _facts_jq -r '.consistency.hook_coverage_allowlist // [] | .[]' "$FACTS_CLAUDE_JSON" \
    | LC_ALL=C sort
}

# fact_deprecated - dead/legacy agent names that must not appear as references
fact_deprecated() {
  _facts_require_jq || return $?
  _facts_require_claude_json || return $?
  _facts_jq -r '.consistency.deprecated_agent_names // [] | .[]' "$FACTS_CLAUDE_JSON"
}

# fact_model_shorthand <shorthand> - resolve a shorthand (opus/sonnet/haiku)
# to its full model id via .consistency.model_shorthand_map. Prints nothing
# and returns 1 if the shorthand is unknown.
fact_model_shorthand() {
  local sh="${1:-}"
  _facts_require_jq || return $?
  _facts_require_claude_json || return $?
  if [[ -z "$sh" ]]; then
    printf 'facts.sh: fact_model_shorthand requires a shorthand argument\n' >&2
    return 2
  fi
  local id
  id="$(_facts_jq -r --arg s "$sh" '.consistency.model_shorthand_map[$s] // empty' \
        "$FACTS_CLAUDE_JSON")"
  if [[ -z "$id" ]]; then
    return 1
  fi
  printf '%s\n' "$id"
}

# --- derived counts ---------------------------------------------------------

# _facts_count_hook_json - number of hooks/*.json files
_facts_count_hook_json() {
  local f n=0
  shopt -s nullglob
  for f in "$FACTS_HOOKS_DIR"/*.json; do n=$((n + 1)); done
  shopt -u nullglob
  printf '%s\n' "$n"
}

# _facts_count_hook_yaml - number of hooks/*.yaml + hooks/*.yml files
_facts_count_hook_yaml() {
  local f n=0
  shopt -s nullglob
  for f in "$FACTS_HOOKS_DIR"/*.yaml "$FACTS_HOOKS_DIR"/*.yml; do n=$((n + 1)); done
  shopt -u nullglob
  printf '%s\n' "$n"
}

# _facts_count_agent_specific_hooks - number of hooks/*-validation.json files
_facts_count_agent_specific_hooks() {
  local f n=0
  shopt -s nullglob
  for f in "$FACTS_HOOKS_DIR"/*-validation.json; do n=$((n + 1)); done
  shopt -u nullglob
  printf '%s\n' "$n"
}

# fact_counts - emit derived counts as key=value lines.
#   agents               = number of registered sub_agents
#   hook_json            = number of hooks/*.json
#   hook_yaml            = number of hooks/*.yaml(+.yml)
#   agent_specific_hooks = number of hooks/*-validation.json
#   framework_wide_hooks = hook_json - agent_specific_hooks
#   quality_gates        = hook_json   (doc convention: "Total Hooks"/"quality gates")
fact_counts() {
  local agents hook_json hook_yaml agent_specific framework_wide
  agents="$(fact_agents | grep -c . || true)"
  hook_json="$(_facts_count_hook_json)"
  hook_yaml="$(_facts_count_hook_yaml)"
  agent_specific="$(_facts_count_agent_specific_hooks)"
  framework_wide=$((hook_json - agent_specific))
  printf 'agents=%s\n' "$agents"
  printf 'hook_json=%s\n' "$hook_json"
  printf 'hook_yaml=%s\n' "$hook_yaml"
  printf 'agent_specific_hooks=%s\n' "$agent_specific"
  printf 'framework_wide_hooks=%s\n' "$framework_wide"
  # "quality gates" == count of hook JSON files (each hooks/*.json is one gate);
  # this is the number docs render as "N Quality Gates".
  printf 'quality_gates=%s\n' "$hook_json"
}

# fact_count <key> - convenience accessor: print the value for a single count
# key emitted by fact_counts (e.g. fact_count agents).
fact_count() {
  local key="${1:?fact_count requires a key}"
  fact_counts | awk -F= -v k="$key" '$1==k {print $2; found=1} END{exit !found}'
}
