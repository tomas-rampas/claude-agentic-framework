---
name: hook-config-generator
description: Generate new validation hooks from templates with proper agent references and integration
version: 1.0
priority: high
category: framework-extension
---

# Hook Configuration Generator Skill

## Purpose

Create new validation hooks from templates, ensuring consistency with existing hooks, proper agent references, and correct integration points. Streamlines adding new quality gates and specialist validations.

## When to Use

- Adding validation for new specialist agents
- Creating domain-specific quality gates
- Extending framework with custom validation
- Standardizing new hook creation
- Ensuring hook consistency across framework

## Hook Templates

### Template 1: Language-Specific Validation Hook

```json
{
  "name": "{language}-expert-configuration",
  "description": "{Language} development standards and best practices enforcement",
  "version": "1.0",
  "disabled": false,
  "agents": ["{language}-expert", "code-review-gatekeeper", "comprehensive-analyst"],
  "triggers": [
    "{language}_code_change",
    "{language}_configuration_change",
    "pre_commit",
    "{language}_pre_build"
  ],

  "{language}_standards": {
    "code_style": {
      "formatter": "{formatter_tool}",
      "linter": "{linter_tool}",
      "naming_conventions": {
        "classes": "{convention}",
        "methods": "{convention}",
        "constants": "{convention}"
      }
    },
    "compilation": {
      "compiler_warnings": "fail_on_warnings",
      "build_command": "{build_command}"
    },
    "testing": {
      "framework": "{test_framework}",
      "minimum_coverage": 80,
      "test_naming": "{test_naming_convention}"
    }
  },

  "quality_gates": {
    "static_analysis": {
      "tools": ["{static_analysis_tools}"],
      "threshold": "zero_violations"
    },
    "code_coverage": {
      "line_coverage": 80,
      "branch_coverage": 75,
      "enforcement": "blocking"
    }
  },

  "validation_sequence": {
    "phase_1_compilation": {
      "command": "{compile_command}",
      "success_criteria": "zero_compilation_errors",
      "blocking": true
    },
    "phase_2_static_analysis": {
      "command": "{linter_command}",
      "success_criteria": "zero_violations",
      "blocking": true
    },
    "phase_3_testing": {
      "command": "{test_command}",
      "success_criteria": "all_tests_pass",
      "blocking": true
    },
    "phase_4_coverage": {
      "command": "{coverage_command}",
      "success_criteria": "minimum_80_percent_coverage",
      "blocking": true
    }
  },

  "integration": {
    "coordinates_with": [
      "zero-tolerance-quality",
      "test-coverage-enforcer",
      "code-review"
    ],
    "blocks_progression_until": [
      "compilation_successful",
      "static_analysis_clean",
      "tests_passing",
      "coverage_threshold_met"
    ]
  }
}
```

### Template 2: Domain-Specialist Validation Hook

```json
{
  "name": "{domain}-specialist-validation",
  "description": "{Domain} standards, best practices, and quality validation",
  "version": "1.0",
  "disabled": false,
  "agents": ["{domain}-specialist", "code-review-gatekeeper", "comprehensive-analyst"],
  "triggers": [
    "{domain}_change",
    "{domain}_configuration_change",
    "pre_commit",
    "{domain}_validation_required"
  ],

  "{domain}_standards": {
    "best_practices": {
      "practice_1": "description",
      "practice_2": "description"
    },
    "quality_metrics": {
      "metric_1": "target_value",
      "metric_2": "target_value"
    },
    "compliance": {
      "standard_1": "requirement",
      "standard_2": "requirement"
    }
  },

  "validation_checks": {
    "check_1": {
      "description": "What to validate",
      "validation_method": "How to validate",
      "failure_action": "What to do on failure"
    },
    "check_2": {
      "description": "What to validate",
      "validation_method": "How to validate",
      "failure_action": "What to do on failure"
    }
  },

  "validation_sequence": {
    "phase_1_standards_check": {
      "check": "Validate against {domain} standards",
      "blocking": true
    },
    "phase_2_quality_validation": {
      "check": "Verify quality metrics",
      "blocking": true
    },
    "phase_3_compliance_check": {
      "check": "Ensure compliance with requirements",
      "blocking": true
    }
  },

  "integration": {
    "coordinates_with": [
      "zero-tolerance-quality",
      "architecture-compliance",
      "code-review"
    ],
    "blocks_progression_until": [
      "standards_validated",
      "quality_metrics_met",
      "compliance_verified"
    ]
  }
}
```

### Template 3: Cross-Cutting Quality Gate

```json
{
  "name": "{quality-aspect}-enforcement",
  "description": "Enforce {quality aspect} across all code changes",
  "version": "1.0",
  "disabled": false,
  "agents": ["all_implementation_agents", "code-review-gatekeeper"],
  "triggers": [
    "code_change",
    "pre_commit",
    "{quality_aspect}_check_required"
  ],

  "enforcement_policy": {
    "blocking": true,
    "enforcement_level": "STRICT",
    "bypass_allowed": false
  },

  "{quality_aspect}_standards": {
    "requirement_1": {
      "description": "What is required",
      "validation": "How to validate",
      "threshold": "Acceptable level"
    },
    "requirement_2": {
      "description": "What is required",
      "validation": "How to validate",
      "threshold": "Acceptable level"
    }
  },

  "validation_sequence": {
    "phase_1": {
      "name": "Initial validation",
      "checks": ["check_1", "check_2"],
      "blocking": true
    },
    "phase_2": {
      "name": "Comprehensive validation",
      "checks": ["check_3", "check_4"],
      "blocking": true
    }
  },

  "integration": {
    "coordinates_with": [
      "zero-tolerance-quality",
      "test-coverage-enforcer"
    ],
    "blocks_progression_until": [
      "{quality_aspect}_validated"
    ]
  }
}
```

## Hook Generation Workflow

### Step 1: Gather Requirements

```yaml
hook_requirements:
  name: "Hook name (kebab-case)"
  type: "language-specific | domain-specialist | cross-cutting"
  target_agent: "Primary agent this hook validates"
  purpose: "What quality aspect does this hook enforce?"

  validation_aspects:
    - "What needs to be validated?"
    - "What standards must be met?"
    - "What tools will be used?"

  integration:
    coordinates_with: ["Existing hooks to coordinate with"]
    blocks_until: ["Conditions that must be met"]

  quality_gates:
    - gate_name: "Description"
      severity: "blocking | warning"
      threshold: "Acceptable level"
```

### Step 2: Select Template

```typescript
function selectTemplate(requirements: HookRequirements): Template {
  if (requirements.type === "language-specific") {
    return LANGUAGE_SPECIFIC_TEMPLATE;
  } else if (requirements.type === "domain-specialist") {
    return DOMAIN_SPECIALIST_TEMPLATE;
  } else {
    return CROSS_CUTTING_TEMPLATE;
  }
}
```

### Step 3: Populate Template

```typescript
function populateTemplate(
  template: Template,
  requirements: HookRequirements
): Hook {
  // Replace placeholders
  const hook = template
    .replace(/{language}/g, requirements.target_language)
    .replace(/{domain}/g, requirements.target_domain)
    .replace(/{quality-aspect}/g, requirements.quality_aspect);

  // Add agent references
  hook.agents = [
    `${requirements.target_agent}`,
    "code-review-gatekeeper",
    "comprehensive-analyst"
  ];

  // Add validation checks
  hook.validation_sequence = generateValidationSequence(requirements);

  // Add integration points
  hook.integration = {
    coordinates_with: requirements.coordinates_with,
    blocks_progression_until: requirements.blocks_until
  };

  return hook;
}
```

### Step 4: Validate Generated Hook

```yaml
validation_checks:
  - name: "JSON syntax"
    check: "Valid JSON structure"
    command: "jq empty {hook_file}"

  - name: "Agent references"
    check: "All agents exist in framework"
    validation: "Cross-reference with EXPECTED_AGENTS list"

  - name: "Integration references"
    check: "All coordinate_with hooks exist"
    validation: "Check hooks/ directory"

  - name: "Required fields"
    check: "All required fields present"
    fields:
      - name
      - description
      - version
      - agents
      - triggers
      - validation_sequence
      - integration
```

## Example Usage

### Example 1: Generate Python Expert Hook

```bash
User: "Create validation hook for python-expert"

Hook Generator Response:

📋 Generating python-expert-configuration.json...

Requirements Detected:
  - Type: Language-specific
  - Target Agent: python-expert
  - Validation Tools: pylint, black, pytest, mypy
  - Coverage Tool: pytest-cov

✅ Generated Hook:
{
  "name": "python-expert-configuration",
  "description": "Python development standards and best practices enforcement",
  "version": "1.0",
  "disabled": false,
  "agents": ["python-expert", "code-review-gatekeeper", "comprehensive-analyst"],

  "python_standards": {
    "code_style": {
      "formatter": "black",
      "linter": "pylint",
      "type_checker": "mypy",
      "import_sorter": "isort"
    },
    "testing": {
      "framework": "pytest",
      "coverage_tool": "pytest-cov",
      "minimum_coverage": 80
    }
  },

  "validation_sequence": {
    "phase_1_type_checking": {
      "command": "mypy src/",
      "success_criteria": "zero_type_errors",
      "blocking": true
    },
    "phase_2_linting": {
      "command": "pylint --fail-under=9.0 src/",
      "success_criteria": "score_above_9",
      "blocking": true
    },
    "phase_3_formatting": {
      "command": "black --check src/",
      "success_criteria": "properly_formatted",
      "blocking": true
    },
    "phase_4_testing": {
      "command": "pytest --cov=src --cov-fail-under=80",
      "success_criteria": "all_tests_pass_coverage_met",
      "blocking": true
    }
  }
}

📁 Saved to: hooks/python-expert-configuration.json
✅ Validation: PASSED
🔗 Integrated with: zero-tolerance-quality, test-coverage-enforcer
```

### Example 2: Generate API Validation Hook

```bash
User: "Create hook to validate REST API design standards"

Hook Generator Response:

📋 Generating api-design-standards.json...

Requirements Detected:
  - Type: Cross-cutting quality gate
  - Applies To: All backend agents
  - Validation Aspects: REST principles, versioning, error handling

✅ Generated Hook:
{
  "name": "api-design-standards",
  "description": "REST API design and implementation standards enforcement",
  "version": "1.0",
  "agents": [
    "rust-expert", "java-expert", "python-expert",
    "typescript-expert", "csharp-expert", "go-expert",
    "code-review-gatekeeper"
  ],

  "api_standards": {
    "rest_principles": {
      "http_methods": "proper_method_usage",
      "status_codes": "appropriate_status_codes",
      "resource_naming": "noun_based_plural",
      "idempotency": "required_for_put_delete"
    },
    "versioning": {
      "strategy": "uri_versioning_preferred",
      "format": "/api/v1/resource",
      "backward_compatibility": "required"
    },
    "error_handling": {
      "format": "RFC7807_problem_details",
      "consistency": "standardized_error_responses",
      "logging": "comprehensive_error_logging"
    }
  },

  "validation_checks": {
    "endpoint_design": {
      "check": "REST principles compliance",
      "blocking": true
    },
    "error_responses": {
      "check": "Standardized error format",
      "blocking": true
    },
    "api_documentation": {
      "check": "OpenAPI/Swagger documentation",
      "blocking": false
    }
  }
}

📁 Saved to: hooks/api-design-standards.json
✅ Validation: PASSED
💡 Suggestion: Add this to architecture-compliance integration
```

## Pre-Built Hook Library

### Available Pre-Built Hooks

```yaml
language_specific:
  - python-expert-configuration
  - ruby-expert-configuration
  - kotlin-expert-configuration
  - swift-expert-configuration

domain_specialist:
  - api-gateway-validation
  - mobile-app-standards
  - data-pipeline-validation
  - ml-model-validation

quality_gates:
  - api-design-standards
  - logging-standards-enforcement
  - monitoring-requirements
  - disaster-recovery-validation
```

### Customization Options

```yaml
customization:
  severity_levels:
    - blocking: "Prevents progression"
    - warning: "Logs but allows progression"
    - info: "Information only"

  thresholds:
    - code_coverage: "Adjust from 80%"
    - complexity: "Cyclomatic complexity limit"
    - duplication: "Code duplication percentage"

  tools:
    - primary: "Main validation tool"
    - fallback: "Alternative if primary unavailable"
    - reporting: "Result reporting format"
```

## Integration Patterns

### Pattern 1: Sequential Integration

```json
{
  "integration": {
    "coordinates_with": [
      "pre-hook-1",
      "pre-hook-2"
    ],
    "runs_after": ["compilation", "linting"],
    "runs_before": ["deployment"],
    "blocks_progression_until": [
      "validation_passed"
    ]
  }
}
```

### Pattern 2: Parallel Integration

```json
{
  "integration": {
    "coordinates_with": [
      "security-scan",
      "performance-check"
    ],
    "parallel_execution": true,
    "wait_for_completion": true,
    "aggregate_results": true
  }
}
```

### Pattern 3: Conditional Integration

```json
{
  "integration": {
    "conditional_activation": {
      "condition": "file_pattern_matches",
      "pattern": "*.api.ts",
      "then": "activate_api_validation"
    },
    "coordinates_with": ["relevant-hooks"]
  }
}
```

## Output Format

```json
{
  "generated_hook": {
    "filename": "python-expert-configuration.json",
    "path": "hooks/python-expert-configuration.json",
    "template_used": "language-specific",
    "validation_status": "PASSED",
    "integration_points": [
      "zero-tolerance-quality",
      "test-coverage-enforcer"
    ],
    "customizations_applied": [
      "Added mypy type checking",
      "Configured black formatter",
      "Set pytest coverage to 80%"
    ]
  },
  "recommendations": [
    "Add to CI/CD pipeline",
    "Update agent documentation",
    "Test with sample Python project"
  ]
}
```

## Success Criteria

- ✅ Valid JSON/YAML syntax
- ✅ All agent references exist
- ✅ Integration points are valid
- ✅ Validation sequence is logical
- ✅ Quality gates are properly defined
- ✅ Documentation is complete
