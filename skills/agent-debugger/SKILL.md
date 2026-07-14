---
name: agent-debugger
description: Diagnose and fix agent routing, loading, and configuration issues by inspecting agents/*.md frontmatter, the claude.json registry, hook registration, and validator output — use when an agent is "not found", tasks route to the wrong specialist, models mismatch, hooks do not fire, or validate-consistency.sh fails.
---

# Agent Debugger

Systematic diagnosis of agent configuration problems in this framework. Every check below is grounded in real files — inspect configuration, run the validators, fix the source of truth, then re-verify. Do not invent runtime logs or metrics; this framework has none.

## Ground Truth: Where Configuration Lives

- `agents/<name>.md` — agent definition. YAML frontmatter carries `name` (must equal the filename), `description` (the routing trigger text Claude Code matches tasks against), `model` (tier shorthand, e.g. `sonnet`), and `color`. The body is the agent's system prompt.
- `claude.json` — the registry. `.sub_agents` maps each agent to its config (including `model` shorthand and `focus`); `.agent_categories` partitions the roster into the canonical categories; `.consistency.model_shorthand_map` defines the only legal model values; `.consistency.deprecated_agent_names` lists dead names that must never be referenced.
- `settings.template.json` — the tracked `hooks` block registering the PowerShell 7 scripts in `hooks/` (Stop → `stop-peer-review-gate.ps1`, PostToolUse `Task|Agent` → `record-subagent-run.ps1`, SessionStart → `session-start-context.ps1`, PreToolUse `Write|Edit` → `pretooluse-delegation-hint.ps1`). `scripts/install.ps1` copies the scripts to `~/.claude/hooks/` and creates/merges `~/.claude/settings.json` from the template.
- Validators: `scripts/validate-consistency.sh` (the full anti-drift battery), `scripts/validate-hooks.sh` (hook parity), `scripts/validate-framework.sh`, `scripts/generate-docs.sh --check`. Tests: `tests/hooks.test.ps1`, `tests/consistency.test.sh`.
- Slash commands for quick inspection: `/list-agents`, `/agent-status`, `/analyze-framework`, `/validate-hooks`, `/quality-report`.

## Debug Workflow

1. **Classify the symptom**: not found / wrong routing / model error / hook not firing / validator failure.
2. **Run the battery first** — it localizes most problems for you:
   ```bash
   bash scripts/validate-consistency.sh   # numbered checks, PASS/FAIL per check, aggregates all failures
   ```
3. **Apply the matching playbook below.**
4. **Verify** (see Verify the Fix).

## Playbook: Agent Not Found or Not Loading

```bash
ls agents/<name>.md                       # file exists, exactly matching name?
jq '.sub_agents["<name>"]' claude.json    # registered?
head -10 agents/<name>.md                 # frontmatter sane?
jq -r '.consistency.deprecated_agent_names[]' claude.json   # is the name dead/legacy?
```

Check 1 of `validate-consistency.sh` reports both failure directions: `missing-md` (registered in `claude.json` but no `agents/<name>.md`) and `orphan-md` (file exists but not registered). Fix by adding the missing side, never by deleting the working side.

Frontmatter requirements: opens and closes with `---`; `name:` equals the filename stem; `description:` is a single line with concrete trigger phrasing; `model:` is a key of `.consistency.model_shorthand_map`; `color:` present. A malformed frontmatter block silently prevents loading — validate YAML before anything else.

Also confirm the agent appears in exactly one `.agent_categories` category (check 2 fails on missing or duplicated membership).

## Playbook: Task Routed to the Wrong Agent

Routing is driven by the `description` frontmatter of each agent (Claude Code matches the task against it) plus the routing tables in `CLAUDE.md` and the `/delegate` command logic in `commands/delegate.md`.

1. Read the `description` of both the expected agent and the one that won. Overlapping trigger phrasing is the usual cause.
2. Sharpen the losing agent's description with concrete technologies, file types, and example triggers; remove ambiguous claims from the winner.
3. Check `CLAUDE.md`'s routing table lists the agent under the right domain, and that `.agent_categories` places it in the correct category.
4. For a one-off, add an explicit routing hint in the task itself ("use rust-expert").

Remember the review chain: `code-review-gatekeeper` reviews first; `peer-review-critic` is the mandatory final reviewer of branch-vs-base before work is declared done. Routing review work anywhere else is a routing bug.

## Playbook: Model Mismatch (Parity Check 7)

Both sides must hold the SAME tier shorthand, and each value must be a declared key of `.consistency.model_shorthand_map`:

```bash
grep -m1 '^model:' agents/<name>.md
jq -r '.sub_agents["<name>"].model' claude.json
jq -r '.consistency.model_shorthand_map | keys[]' claude.json
```

Check 7 fails on: missing frontmatter `model:`, empty registry model, a value not in the map (typos like `sonnett`), or any md-vs-registry divergence. Fix by editing BOTH files to the same shorthand — never introduce full model IDs in either place; the shorthand map is the single source of truth.

## Playbook: Hook Not Firing or Stop Gate Misbehaving

Hooks are real Claude Code hooks — PowerShell 7 scripts executed only when registered in the live settings file.

```bash
jq '.hooks' settings.template.json        # tracked registration (event -> matcher -> command)
jq '.hooks' ~/.claude/settings.json       # what actually runs; created by scripts/install.ps1
ls hooks/*.ps1 && ls ~/.claude/hooks/     # scripts on disk, repo and installed copies
bash scripts/validate-hooks.sh            # registration <-> script parity
pwsh -NoProfile -Command '$PSVersionTable.PSVersion'   # pwsh 7 must be on PATH
```

Common causes, in order of likelihood:
- `install.ps1` never ran (or refused to overwrite an existing `hooks` block — re-run with `-Force`), so `~/.claude/settings.json` lacks the registration.
- The session predates the install: hooks load at session start, so restart Claude Code after installing.
- Matcher mismatch: `record-subagent-run.ps1` fires on PostToolUse `Task|Agent`; `pretooluse-delegation-hint.ps1` on PreToolUse `Write|Edit`. An event without a matching tool never fires.
- Script edited in repo but not re-copied to `~/.claude/hooks/`.

Check 3 of `validate-consistency.sh` asserts parity between scripts referenced in the template's `hooks` block and `hooks/*.ps1` on disk. Behavior is covered by `tests/hooks.test.ps1`.

Stop-gate specifics: `stop-peer-review-gate.ps1` blocks session end only when a feature branch has committed work ahead of its base and `peer-review-critic` has not run this session (recorded by `record-subagent-run.ps1`). It is loop-safe and fail-open — if it appears to "block forever", verify the recorder hook is registered and firing, since the gate clears based on its records. Design rationale lives in `docs/design/`.

## Playbook: Consistency Validator Failures

`validate-consistency.sh` derives all truth at runtime from `claude.json` plus the filesystem — nothing is hardcoded. Read each FAIL line; it names the check and the offending items. Frequent ones:

- Check 5 (deprecated names): a doc or config still references a dead agent name. Replace with the current name from the registry.
- Check 8 (stated-count scan): a doc states a headline count that no longer matches derived reality. Do not hand-edit numbers into docs — remove the count or let the generator own it.
- Check 11 (stale generated blocks): run `bash scripts/generate-docs.sh --write` to regenerate, then re-check.
- Checks 9/10 (prose tables / README focus text): update the table cell to match `.sub_agents[<agent>].focus` or the roster exactly.

## Verify the Fix

```bash
bash scripts/validate-consistency.sh && echo OK   # must exit 0
bash scripts/validate-hooks.sh
bash scripts/generate-docs.sh --check
pwsh -NoProfile -File tests/hooks.test.ps1        # after any hook change
```

Then confirm the original symptom is gone (e.g. re-issue the task and watch it route correctly, or restart a session and confirm the hook fires).

## Prevention

- Edit `agents/<name>.md` and `claude.json` together, in the same commit; the validators treat divergence as a blocking failure.
- Never hardcode rosters, counts, or model IDs into docs — reference the registry (`claude.json`) and let `generate-docs.sh` produce derived content.
- Run the validator battery before every commit touching `agents/`, `hooks/`, `claude.json`, or `settings.template.json`.
- After changing hook scripts or registration, re-run `scripts/install.ps1` and restart the session.
