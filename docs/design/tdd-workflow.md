# Design: tdd-workflow (PreToolUse hard block) — NOT implemented

**Status: deliberately not implemented.** Recorded here so the decision isn't relitigated
by accident.

## The idea

A `PreToolUse` hook on `Write|Edit` that blocks creating a source file (`.rs`, `.py`,
`.ts`, `.cs`, `.go`, `.java`, `.js`, …) when no corresponding test file exists — forcing
the RED phase of red/green/refactor: write a failing test before the implementation.

The legacy dispatcher carried a hardcoded version of this: it probed
`test_<stem>`, `<stem>_test`, `<stem>.test`, `<stem>.spec` in the file's directory,
`tests/`, `spec/`, and the parent `tests/` directory, and hard-failed (`exit 1`) when
nothing matched.

## Why it was not made real

- **False positives dominate.** Scaffolding, generated code, config-as-code, examples,
  docs tooling, and one-off scripts all trip a filename-convention probe. On this very
  repo (mostly `.md`/`.json`/`.ps1`) it would block legitimate work constantly.
- **It fights the agent, not the process.** The framework's quality story is review-based
  (code-review-gatekeeper → peer-review-critic). A file-level pre-write block is the wrong
  altitude: TDD discipline belongs in agent prompts and review criteria, not a tool gate.
- **"Minimal real set" decision (2026-07):** the only hard gate is the peer-review Stop
  gate; everything else is advisory.

## If someone revisits this

Implement it as an opt-in per-project hook (project `.claude/settings.json`), scope it to
source directories explicitly, and prefer `permissionDecision: "ask"` over a hard deny so
the user stays in control.
