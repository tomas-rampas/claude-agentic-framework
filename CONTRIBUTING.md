# Contributing to the Claude Code CLI Agent Framework

This guide explains the anti-drift consistency system and how to contribute to the framework while maintaining data integrity.

## Single Source of Truth

`claude.json` is the canonical registry for the entire framework. It contains:

- **`.sub_agents`** — the roster, including each agent's model, specialization, and `focus` field
- **`.agent_categories`** — taxonomy that partitions agents into exactly one category group
- **`.consistency`** — metadata controlling generator and validator behavior:
  - `hook_coverage_allowlist` — agents exempt from requiring a per-agent `{agent}-validation.json` hook
  - `deprecated_agent_names` — retired agent identifiers (flagged if re-used)
  - `model_shorthand_map` — e.g., `"opus" -> "claude-opus-4-6-20250805"`
  - `doc_blocks` — registry of machine-generated documentation regions

Do not hand-edit agent counts, rosters, or model assignments in documentation or scripts — they are derived from `claude.json` and the filesystem at validation time.

## Adding or Changing an Agent

Follow these steps in order:

### 1. Create the agent prompt file

Add `agents/<name>.md` with YAML frontmatter:

```yaml
---
name: <agent-name>
description: <one-paragraph summary + examples>
model: <shorthand-key or full id>  # e.g., "opus" or "claude-opus-4-6-20250805"
color: <color-name>
---

## Core Expertise
...
```

### 2. Register in `claude.json`

In the `.sub_agents` object, add an entry with `model` and `focus`:

```json
"your-agent": {
  "enabled": true,
  "path": "~/.claude/agents/your-agent",
  "config_file": "~/.claude/agents/your-agent/agent.json",
  "prompt_file": "~/.claude/agents/your-agent.md",
  "model": "claude-sonnet-4-6-20250514",
  "specialization": "your_domain_area",
  "focus": "Brief focus area (1-2 sentences)"
}
```

Also add the agent to exactly one group in `.agent_categories`.

### 3. Create the validation hook (or allowlist the agent)

One of two approaches:

**Option A (standard):** Create `hooks/<agent>-validation.json` with quality gates and test requirements (see `hooks/rust-expert-validation.json` for a complete example).

**Option B (framework-wide gate):** If the agent shares validation with a framework-wide hook (e.g., all agents are gated by `peer-review-critic`), add the agent to `claude.json .consistency.hook_coverage_allowlist`:

```json
"consistency": {
  "hook_coverage_allowlist": ["peer-review-critic", "your-agent"]
}
```

### 4. Refresh generated documentation

Run the generator to update any `<!-- BEGIN GENERATED: ... -->` marker regions:

```bash
bash scripts/generate-docs.sh --write
```

### 5. Validate the change

Run the full consistency check:

```bash
bash scripts/validate-consistency.sh
```

This runs 11 checks including:
- Registry ↔ filesystem parity
- Category partition (no duplicates, no gaps)
- Hook coverage (every non-allowlisted agent has a validation hook)
- JSON validity (and best-effort YAML — skipped locally when no python/ruby YAML parser is present; runs on CI)
- No use of deprecated names
- Architecture description count accuracy
- Model parity (agents/<name>.md frontmatter vs claude.json) — advisory WARNING only (see note below)
- Roster presence in prose tables (README, CLAUDE.md, list-agents.md)
- README focus-text parity (README Focus cells match claude.json .focus fields)
- Generated blocks are fresh

All blocking checks must pass (exit 0).

### 6. Update prose tables

If the validator reports roster-presence failures in `README.md` or `CLAUDE.md` tables, add the agent row to those hand-written tables. Consult the tables' existing structure for style.

The validator will tell you exactly which tables need updates. Do not hardcode any counts in these tables — omit agent/hook counts and use phrases like "the current roster in claude.json" if needed.

## The Validator

`bash scripts/validate-consistency.sh` is the primary integrity gate. It:

- **Derives all truth at runtime** from `claude.json` and the filesystem — no hardcoded lists
- **Runs 11 checks** (see summary above) and collects all failures before exiting
- **Distinguishes blocking vs. advisory**: exits non-zero on any blocking check failure
- **Model parity is advisory only** (check 7) — it does not block CI. The frontmatter `model:` and claude.json's per-agent model currently diverge for several agents (most `.md` files declare `opus`); mismatches are reported for awareness, not enforced. Reconciling them — and deciding which is authoritative for runtime — is deferred to a separate model-alignment change.

Run it during development and before pushing. CI (`.github/workflows/consistency.yml`) runs it on every PR.

## The Generator

`bash scripts/generate-docs.sh` is a documentation-freshness gate. It:

- **Modes:**
  - `--write`: regenerate all `<!-- BEGIN GENERATED: ... -->` marker regions from claude.json + facts
  - `--check`: verify regions are up to date; fails if any are stale
- **Machine-owned regions**: do not hand-edit content between the markers (the validator enforces freshness)
- **Coverage:** currently generates the `commands/list-agents.md` JSON summary block. Prose tables (README "## Agents", CLAUDE.md roster, list-agents.md textual categories) are hand-written and guarded by roster-presence checks instead (better structural flexibility).

Always run `--write` after editing `claude.json`, then validate.

## CI / Continuous Integration

The workflow `.github/workflows/consistency.yml` runs on every PR and push to main:

```bash
bash scripts/validate-consistency.sh       # runs 11 checks
bash scripts/generate-docs.sh --check      # fails if generated blocks are stale
bash tests/consistency.test.sh             # 10-case test harness
```

To reproduce a CI failure locally, run these three commands from the repo root. All must exit 0.

## Quick Reference

| Task | Command |
|------|---------|
| Add/update an agent | Follow the 6-step process above |
| Regenerate docs | `bash scripts/generate-docs.sh --write` |
| Validate everything | `bash scripts/validate-consistency.sh && echo exit=$?` |
| Check freshness (CI mode) | `bash scripts/generate-docs.sh --check && echo exit=$?` |
| Run all tests | `bash tests/consistency.test.sh && echo exit=$?` |

## Notes

- The framework operates on **LF line endings** (configured in `.gitattributes eol=lf`). Do not commit CRLF.
- `FRAMEWORK_ROOT` environment variable overrides git discovery if set; useful for testing against isolated copies.
- Never suppress hooks with `--no-verify` unless troubleshooting a hook failure. Hook violations indicate real inconsistencies.
- Questions? See the validator output — it names every failure precisely.
