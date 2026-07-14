# Design: peer-review-final-gate (Stop hook)

**Status: implemented** — `hooks/stop-peer-review-gate.ps1` + `hooks/record-subagent-run.ps1`,
registered in `settings.json` via `settings.template.json` (see `scripts/install.ps1`).
This document is the design rationale; the scripts are the source of truth for behavior.

## Purpose

Enforce the framework's final quality gate: an independent, diff-scoped review by the
`peer-review-critic` subagent before a coding session ends with committed, unreviewed
feature-branch work. It is the last line of defence after `code-review-gatekeeper`.

## Mechanism

A `Stop` hook. When it decides to block, it emits `{"decision":"block","reason":...}` on
stdout; Claude Code feeds the reason back to the model, which is instructed to launch the
peer-review-critic subagent. A companion `PostToolUse` hook (matcher `Task|Agent`) records
each peer-review-critic run as a per-session marker file under
`~/.claude/.state/peer-review/<session_id>`.

## Block conditions (ALL must hold; anything else allows the stop — fail-open)

1. The stop is not a stop-hook continuation (`stop_hook_active` is not true) — loop safety.
2. The gate has not already fired this session (a `<session_id>.fired` marker is written on
   first block, so the gate fires **at most once per session**).
3. `peer-review-critic` has not run this session (no `<session_id>` marker).
4. `cwd` is inside a git work tree.
5. HEAD is a named branch that is not the integration base (not detached, not main/master).
6. There are commits ahead of the integration base — first existing of `origin/main`,
   `origin/master`, `main`, `master`.
7. The working tree is clean (a committed end-of-work milestone, not a mid-edit pause).

## Rationale

The Stop hook fires at the end of every turn, so the trigger is deliberately narrow —
committed work on a feature branch, clean tree, not yet reviewed — to behave like a
pre-merge review gate that runs once, not a per-turn nag. Any error, parse failure, or
missing tool exits 0 silently: the gate must never trap a user in an unstoppable session.

## Exit criteria for the review itself

Every BLOCKER and MAJOR finding from peer-review-critic resolved (or explicit user
sign-off) before the work is declared done — see CLAUDE.md "Final Quality Gate".
