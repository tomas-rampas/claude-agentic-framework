---
name: git-workflow-assistant
description: Guide git branching strategies, commit conventions, PR workflows, and conflict resolution
version: 1.0
priority: high
category: development
tags: [git, workflow, branching, commits, pull-requests]
---

# Git Workflow Assistant Skill

## Purpose

Provide structured guidance for git operations including branching strategies, commit message conventions, PR descriptions, merge conflict resolution, and release workflows.

## When to Use

- Setting up a branching strategy for a new project
- Writing commit messages that follow conventions
- Creating PR descriptions with proper context
- Resolving merge conflicts
- Planning release workflows
- Cleaning up git history

## Branching Strategies

### Trunk-Based Development (Recommended for CI/CD)

```
main ─────●───●───●───●───●───●──→
           \     /   \       /
feature/a   ●──●     \     /
                       ●──●
                   feature/b
```

- Short-lived feature branches (1-3 days max)
- Merge to main via PR with required reviews
- Feature flags for incomplete work
- Best for: small teams, continuous deployment

### GitHub Flow

```
main ────●───●───●───●───●──→
          \         /
feature    ●──●──●─┘
```

- Branch from main, PR back to main
- Deploy from main after merge
- Best for: SaaS products, web applications

### GitFlow (For Scheduled Releases)

```
main    ──●─────────────●──→
           \           /
release     \    ●──●─┘
             \  /
develop ●──●──●──●──●──→
          \     /
feature    ●──●
```

- `develop` as integration branch
- `release/*` for release prep
- `hotfix/*` branches from main
- Best for: products with versioned releases

## Commit Message Conventions

### Conventional Commits

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature (bumps minor version)
- `fix`: Bug fix (bumps patch version)
- `docs`: Documentation only
- `style`: Formatting, no code change
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvement
- `test`: Adding or updating tests
- `chore`: Build process, tooling, dependencies
- `ci`: CI/CD configuration changes

**Examples:**
```
feat(auth): add JWT refresh token rotation

Implement automatic token refresh when access token expires.
Refresh tokens are single-use and rotated on each refresh.

Closes #142
```

```
fix(api): prevent SQL injection in user search endpoint

Parameterize the search query instead of string interpolation.
Added input validation for search terms.

Fixes #287
BREAKING CHANGE: search API now rejects special characters
```

## PR Description Template

```markdown
## Summary
Brief description of what this PR does and why.

## Changes
- Change 1: description
- Change 2: description

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Notes for Reviewers
Any context that helps reviewers understand the changes.
```

## Merge Conflict Resolution

### Strategy

1. **Understand both sides**: Read the conflicting changes to understand intent
2. **Choose the right merge strategy**:
   - `theirs` for upstream dependency updates
   - `ours` for intentional divergence
   - Manual merge for logic conflicts
3. **Test after resolution**: Always run tests after resolving conflicts
4. **Commit with context**: Explain resolution in merge commit message

### Common Patterns

```bash
# Update branch before PR
git fetch origin main
git rebase origin/main

# Interactive rebase to clean up commits
git rebase -i origin/main

# Abort a bad rebase
git rebase --abort

# Squash merge for clean history
git merge --squash feature-branch
```

## Release Workflow

### Semantic Versioning

```
MAJOR.MINOR.PATCH
  │      │     └── Bug fixes (backward compatible)
  │      └──────── New features (backward compatible)
  └─────────────── Breaking changes
```

### Release Checklist

1. Create release branch: `release/v1.2.0`
2. Update version numbers in config files
3. Update CHANGELOG.md
4. Run full test suite
5. Create release tag: `git tag -a v1.2.0 -m "Release v1.2.0"`
6. Push tag: `git push origin v1.2.0`
7. Merge release branch to main and develop

## Integration

Coordinates with:
- All language expert agents (for language-specific tooling)
- `devops-orchestrator` (for CI/CD pipeline integration)
- `code-review-gatekeeper` (for PR review workflows)
