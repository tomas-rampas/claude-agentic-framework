---
name: migration-assistant
description: Assist with framework version migrations and agent reference updates
version: 1.0
priority: low
category: framework-maintenance
---

# Migration Assistant Skill

## Purpose

Help migrate between framework versions, update agent references across all files, refactor hook formats, and validate migration completeness. Ensures smooth transitions when framework structure changes.

## When to Use

- Upgrading to new framework version
- Migrating from old agent names to new ones
- Consolidating or splitting agents
- Updating hook system formats
- Breaking changes in framework structure
- Renaming agents or changing agent categories

## Migration Scenarios

### Scenario 1: Agent Renaming Migration

```yaml
migration_type: "agent_rename"
description: "Update agent references throughout framework"

example:
  from: "rust-systems-expert"
  to: "rust-expert"

affected_files:
  - CLAUDE.md
  - commands/delegate.md
  - hooks/*.json
  - hooks/*.yaml
  - README.md
  - agents/*.md

migration_steps:
  1. Create backup
  2. Update CLAUDE.md agent references
  3. Update delegate.md routing patterns
  4. Update all hooks
  5. Update documentation
  6. Validate all references
  7. Test framework functionality
```

### Scenario 2: Agent Count Migration

```yaml
migration_type: "agent_count_change"
description: "Update from N agents to M agents"

example:
  from: 11
  to: 18
  new_agents:
    - java-expert
    - database-specialist
    - frontend-specialist
    - security-specialist
    - uiux-specialist

migration_steps:
  1. Add new agent files
  2. Update CLAUDE.md with new agents
  3. Add routing patterns to delegate.md
  4. Update all hooks to include new agents
  5. Add new agent-specific hooks
  6. Update README.md count
  7. Update architecture documentation
  8. Validate framework integrity
```

### Scenario 3: Hook Format Migration

```yaml
migration_type: "hook_format_update"
description: "Update hook structure to new format"

example:
  from: "v1.0 hook format"
  to: "v2.0 hook format with enhanced integration"

changes:
  - Add "integration" section
  - Update "agent_responsibilities" structure
  - Add "validation_sequence" details
  - Enhance "quality_gates" configuration

migration_steps:
  1. Backup existing hooks
  2. Update hook schemas
  3. Migrate each hook to new format
  4. Validate JSON/YAML syntax
  5. Test hook functionality
  6. Update hook documentation
```

### Scenario 4: Old Agent Name Cleanup

```yaml
migration_type: "old_agent_cleanup"
description: "Remove references to deprecated agents"

old_agents_to_replace:
  maker: "implementation-expert (or specific language expert)"
  maker-agent: "implementation-expert"
  test: "code-review-gatekeeper"
  test-agent: "code-review-gatekeeper"
  debug: "comprehensive-analyst"
  debug-agent: "comprehensive-analyst"
  reader: "comprehensive-analyst"
  reader-agent: "comprehensive-analyst"
  plan: "system-architect"
  plan-agent: "system-architect"
  security: "security-specialist"
  security-agent: "security-specialist"
  docs: "technical-docs-writer"
  docs-agent: "technical-docs-writer"
  performance: "comprehensive-analyst"
  performance-agent: "comprehensive-analyst"
  devops: "devops-orchestrator"
  devops-agent: "devops-orchestrator"
```

## Migration Tools

### Backup Creation

```bash
#!/bin/bash
# Create comprehensive backup before migration

BACKUP_DIR="backups/migration-$(date +%Y%m%d-%H%M%S)"

create_backup() {
  echo "Creating backup in $BACKUP_DIR..."

  mkdir -p "$BACKUP_DIR"

  # Backup all framework files
  cp -r agents/ "$BACKUP_DIR/"
  cp -r commands/ "$BACKUP_DIR/"
  cp -r hooks/ "$BACKUP_DIR/"
  cp CLAUDE.md "$BACKUP_DIR/"
  cp README.md "$BACKUP_DIR/"

  # Create backup manifest
  cat > "$BACKUP_DIR/manifest.txt" << EOF
Backup Created: $(date)
Framework Version: $(grep version CLAUDE.md)
Total Agents: $(ls agents/*.md | wc -l)
Total Hooks: $(ls hooks/*.{json,yaml} 2>/dev/null | wc -l)
EOF

  echo "✅ Backup created successfully"
  echo "📁 Location: $BACKUP_DIR"
}
```

### Agent Reference Updater

```bash
#!/bin/bash
# Update agent references across all files

update_agent_references() {
  local OLD_AGENT=$1
  local NEW_AGENT=$2

  echo "Updating $OLD_AGENT → $NEW_AGENT"

  # Update CLAUDE.md
  sed -i "s/$OLD_AGENT/$NEW_AGENT/g" CLAUDE.md

  # Update delegate.md
  sed -i "s/$OLD_AGENT/$NEW_AGENT/g" commands/delegate.md

  # Update all hooks
  for file in hooks/*.{json,yaml}; do
    if [ -f "$file" ]; then
      sed -i "s/$OLD_AGENT/$NEW_AGENT/g" "$file"
    fi
  done

  # Update README.md
  sed -i "s/$OLD_AGENT/$NEW_AGENT/g" README.md

  echo "✅ Updated all references"
}

# Usage
update_agent_references "rust-systems-expert" "rust-expert"
update_agent_references "maker-agent" "implementation-expert"
update_agent_references "test-agent" "code-review-gatekeeper"
```

### Hook Migration Script

```python
#!/usr/bin/env python3
import json
import sys
from pathlib import Path

def migrate_hook_v1_to_v2(hook_file: Path) -> dict:
    """Migrate hook from v1 to v2 format"""

    with open(hook_file) as f:
        hook = json.load(f)

    # Add integration section if missing
    if "integration" not in hook:
        hook["integration"] = {
            "coordinates_with": [],
            "blocks_progression_until": []
        }

    # Update agent_responsibilities structure
    if "agent_responsibilities" in hook:
        # Ensure proper structure
        for agent, config in hook["agent_responsibilities"].items():
            if isinstance(config, list):
                hook["agent_responsibilities"][agent] = {
                    "responsibilities": config
                }

    # Add validation_sequence if missing
    if "validation_sequence" not in hook:
        hook["validation_sequence"] = {
            "phase_1": {
                "description": "Primary validation",
                "blocking": True
            }
        }

    # Update version
    hook["version"] = "2.0"

    return hook

def migrate_all_hooks(hooks_dir: Path):
    """Migrate all hooks in directory"""

    for hook_file in hooks_dir.glob("*.json"):
        print(f"Migrating {hook_file.name}...")

        try:
            migrated = migrate_hook_v1_to_v2(hook_file)

            # Write migrated hook
            with open(hook_file, 'w') as f:
                json.dump(migrated, f, indent=2)

            print(f"  ✅ Migrated successfully")

        except Exception as e:
            print(f"  ❌ Error: {e}")

if __name__ == "__main__":
    hooks_dir = Path("hooks")
    migrate_all_hooks(hooks_dir)
```

### Validation Script

```bash
#!/bin/bash
# Validate migration completeness

validate_migration() {
  echo "🔍 Validating migration..."

  ERRORS=0

  # Check for old agent references
  OLD_AGENTS=(
    "maker-agent" "test-agent" "debug-agent"
    "reader-agent" "plan-agent" "security-agent"
    "docs-agent" "performance-agent" "devops-agent"
  )

  for old_agent in "${OLD_AGENTS[@]}"; do
    if grep -r "$old_agent" hooks/ commands/ CLAUDE.md README.md 2>/dev/null; then
      echo "  ❌ Found old agent reference: $old_agent"
      ((ERRORS++))
    fi
  done

  # Validate agent count
  EXPECTED_COUNT=18
  ACTUAL_COUNT=$(ls agents/*.md 2>/dev/null | wc -l)

  if [ "$ACTUAL_COUNT" -ne "$EXPECTED_COUNT" ]; then
    echo "  ❌ Expected $EXPECTED_COUNT agents, found $ACTUAL_COUNT"
    ((ERRORS++))
  fi

  # Validate JSON syntax
  for file in hooks/*.json; do
    if ! jq empty "$file" 2>/dev/null; then
      echo "  ❌ Invalid JSON in $file"
      ((ERRORS++))
    fi
  done

  # Validate README agent count
  if grep -q "11 agents" README.md || grep -q "11 specialized agents" README.md; then
    echo "  ❌ README still references old agent count"
    ((ERRORS++))
  fi

  if [ $ERRORS -eq 0 ]; then
    echo "  ✅ Migration validation passed"
    return 0
  else
    echo "  ❌ Migration validation failed with $ERRORS errors"
    return 1
  fi
}
```

## Migration Workflows

### Complete Migration Workflow

```yaml
complete_migration:
  phase_1_preparation:
    - "Review migration requirements"
    - "Identify all affected files"
    - "Create comprehensive backup"
    - "Document current state"

  phase_2_agent_updates:
    - "Add new agent files"
    - "Update CLAUDE.md agent list"
    - "Update delegate.md routing"
    - "Update agent-capability-registry"

  phase_3_hook_updates:
    - "Update hook agent references"
    - "Add new specialist hooks"
    - "Update integration points"
    - "Migrate to new hook format"

  phase_4_documentation:
    - "Update README.md"
    - "Update architecture docs"
    - "Update agent count everywhere"
    - "Update workflow examples"

  phase_5_validation:
    - "Validate JSON/YAML syntax"
    - "Check agent references"
    - "Verify integration points"
    - "Test framework functionality"

  phase_6_rollback_plan:
    - "Keep backup available"
    - "Document rollback procedure"
    - "Test rollback process"
```

## Rollback Procedure

```bash
#!/bin/bash
# Rollback migration if needed

rollback_migration() {
  local BACKUP_DIR=$1

  echo "⚠️  Rolling back migration..."
  echo "📁 Using backup: $BACKUP_DIR"

  # Verify backup exists
  if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ Backup directory not found!"
    exit 1
  fi

  # Restore files
  echo "Restoring agents..."
  cp -r "$BACKUP_DIR/agents/" ./

  echo "Restoring commands..."
  cp -r "$BACKUP_DIR/commands/" ./

  echo "Restoring hooks..."
  cp -r "$BACKUP_DIR/hooks/" ./

  echo "Restoring CLAUDE.md..."
  cp "$BACKUP_DIR/CLAUDE.md" ./

  echo "Restoring README.md..."
  cp "$BACKUP_DIR/README.md" ./

  echo "✅ Rollback completed"
  echo "💡 Verify framework state"
}

# Usage
rollback_migration "backups/migration-20251116-1449"
```

## Migration Checklist

```markdown
## Pre-Migration Checklist

- [ ] Review migration requirements
- [ ] Document current framework state
- [ ] Create comprehensive backup
- [ ] Identify all affected files
- [ ] Plan migration steps
- [ ] Prepare rollback procedure

## During Migration

- [ ] Update agent files
- [ ] Update CLAUDE.md
- [ ] Update commands/delegate.md
- [ ] Update all hooks
- [ ] Update README.md
- [ ] Update documentation
- [ ] Add new configurations

## Post-Migration

- [ ] Validate JSON/YAML syntax
- [ ] Check agent references
- [ ] Verify integration points
- [ ] Test agent delegation
- [ ] Run framework-validator
- [ ] Update version numbers
- [ ] Document changes
- [ ] Archive backup

## Validation

- [ ] No old agent names in hooks
- [ ] Correct agent count (18)
- [ ] All JSON files valid
- [ ] All agent files exist
- [ ] Documentation updated
- [ ] Tests passing
```

## Usage Examples

### Example 1: Full Version Migration

```bash
User: "Help me migrate from framework v2.0 to v3.0"

Migration Assistant Response:

🔄 Framework Migration: v2.0 → v3.0

📋 Migration Overview:
  Changes:
    - Agent count: 11 → 18
    - New agents: java-expert, database-specialist, frontend-specialist,
                  security-specialist, uiux-specialist
    - Renamed: rust-systems-expert → rust-expert
    - Hook format updated to v2.0

📦 Creating Backup...
  ✅ Backup created: backups/migration-20251116-1449
  📁 Backed up: agents/, commands/, hooks/, CLAUDE.md, README.md

🔧 Phase 1: Agent Updates
  ✅ Added java-expert.md
  ✅ Added database-specialist.md
  ✅ Added frontend-specialist.md
  ✅ Added security-specialist.md
  ✅ Added uiux-specialist.md
  ✅ Renamed rust-systems-expert → rust-expert
  ✅ Updated CLAUDE.md (18 agents)
  ✅ Updated delegate.md routing

🔧 Phase 2: Hook Updates
  ✅ Updated 28 hooks with new agent references
  ✅ Created 5 new specialist hooks
  ✅ Migrated hooks to v2.0 format
  ✅ Updated integration points

🔧 Phase 3: Documentation
  ✅ Updated README.md (11 → 18 agents)
  ✅ Updated architecture section
  ✅ Updated workflow examples

🔍 Phase 4: Validation
  ✅ JSON syntax: All valid
  ✅ Agent references: All current
  ✅ Integration points: All valid
  ✅ Agent count: 18 ✓
  ✅ Framework validation: PASSED

✅ Migration Complete!

📝 Summary:
  - Duration: 2 minutes
  - Files updated: 47
  - Agents: 11 → 18
  - Hooks: 23 → 28
  - Validation: PASSED

💡 Next Steps:
  1. Test agent delegation
  2. Run framework-validator
  3. Update team documentation

🔙 Rollback Available:
  backups/migration-20251116-1449
```

### Example 2: Agent Reference Update

```bash
User: "Update all 'maker-agent' references to appropriate experts"

Migration Assistant Response:

🔄 Updating Old Agent References

📋 Migration Plan:
  Old Agent: maker-agent
  New Agents: implementation-expert (or specific language expert)

🔍 Scanning framework...
  Found 'maker-agent' in:
    - hooks/zero-tolerance-quality.json
    - hooks/dependency-security.json
    - hooks/performance-regression.json
    - hooks/architecture-compliance.json

📦 Creating backup...
  ✅ Backup: backups/agent-update-20251116-1450

🔧 Updating References...
  ✅ Updated zero-tolerance-quality.json
     maker-agent → implementation-experts (grouped)

  ✅ Updated dependency-security.json
     maker-agent → implementation-experts (grouped)

  ✅ Updated performance-regression.json
     maker-agent → implementation-experts (grouped)

  ✅ Updated architecture-compliance.json
     maker-agent → implementation-experts (grouped)

🔍 Validating...
  ✅ No remaining 'maker-agent' references
  ✅ All JSON files valid
  ✅ Integration points updated

✅ Update Complete!

📊 Summary:
  Files updated: 4
  References changed: 12
  Validation: PASSED
```

## Integration

Coordinates with:
- `framework-validator` - Validates migration completeness
- `agent-routing-advisor` - Updates routing patterns
- Backup system - Creates and manages backups

## Success Criteria

- ✅ Complete backup created
- ✅ All agent references updated
- ✅ No old agent names remaining
- ✅ All JSON/YAML syntax valid
- ✅ Framework validation passes
- ✅ Rollback procedure available
- ✅ Documentation updated
