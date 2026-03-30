---
name: code-scaffolder
description: Generate idiomatic project scaffolding for supported languages and frameworks
version: 1.0
priority: medium
category: development
tags: [scaffolding, project-setup, boilerplate, templates]
---

# Code Scaffolder Skill

## Purpose

Generate idiomatic project structures, configuration files, and boilerplate for new projects across all languages supported by the framework's language expert agents.

## When to Use

- Starting a new project from scratch
- Adding a new service to an existing system
- Setting up test infrastructure for a project
- Creating CI/CD pipeline configurations
- Bootstrapping a library or package

## Supported Project Types

### Rust Projects

**CLI Application:**
```
my-cli/
├── Cargo.toml
├── src/
│   ├── main.rs
│   ├── cli.rs          # clap argument definitions
│   ├── config.rs       # configuration handling
│   └── error.rs        # custom error types (thiserror)
├── tests/
│   └── integration.rs
├── .github/workflows/
│   └── ci.yml
├── .gitignore
└── README.md
```

**Library Crate:**
```
my-lib/
├── Cargo.toml
├── src/
│   ├── lib.rs
│   └── types.rs
├── tests/
│   └── integration.rs
├── examples/
│   └── basic.rs
├── benches/
│   └── benchmark.rs
└── README.md
```

### Go Projects

**HTTP Service:**
```
my-service/
├── go.mod
├── cmd/
│   └── server/
│       └── main.go
├── internal/
│   ├── handler/
│   │   └── handler.go
│   ├── service/
│   │   └── service.go
│   └── repository/
│       └── repository.go
├── pkg/
│   └── models/
│       └── models.go
├── tests/
│   └── integration_test.go
├── Dockerfile
├── Makefile
└── README.md
```

### Python Projects

**FastAPI Application:**
```
my-api/
├── pyproject.toml
├── src/
│   └── my_api/
│       ├── __init__.py
│       ├── main.py         # FastAPI app
│       ├── routes/
│       │   └── __init__.py
│       ├── models/
│       │   └── __init__.py
│       ├── services/
│       │   └── __init__.py
│       └── config.py
├── tests/
│   ├── conftest.py
│   └── test_routes.py
├── Dockerfile
├── .github/workflows/
│   └── ci.yml
└── README.md
```

### TypeScript Projects

**Next.js Application:**
```
my-app/
├── package.json
├── tsconfig.json
├── next.config.ts
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── globals.css
│   ├── components/
│   │   └── ui/
│   └── lib/
│       └── utils.ts
├── tests/
│   └── setup.ts
├── .eslintrc.json
├── .prettierrc
└── README.md
```

**Node.js API:**
```
my-api/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   ├── routes/
│   ├── middleware/
│   ├── services/
│   └── types/
├── tests/
│   └── setup.ts
├── Dockerfile
└── README.md
```

### C# Projects

**ASP.NET Core Web API:**
```
MyApi/
├── MyApi.sln
├── src/
│   └── MyApi/
│       ├── MyApi.csproj
│       ├── Program.cs
│       ├── Controllers/
│       ├── Services/
│       ├── Models/
│       └── appsettings.json
├── tests/
│   └── MyApi.Tests/
│       ├── MyApi.Tests.csproj
│       └── Controllers/
├── Dockerfile
└── README.md
```

### Java Projects

**Spring Boot Application:**
```
my-app/
├── pom.xml (or build.gradle)
├── src/
│   ├── main/
│   │   ├── java/com/example/myapp/
│   │   │   ├── MyAppApplication.java
│   │   │   ├── controller/
│   │   │   ├── service/
│   │   │   ├── repository/
│   │   │   └── model/
│   │   └── resources/
│   │       └── application.yml
│   └── test/
│       └── java/com/example/myapp/
│           └── MyAppApplicationTests.java
├── Dockerfile
└── README.md
```

## CI/CD Templates

### GitHub Actions (Generic)

```yaml
name: CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup
        # Language-specific setup
      - name: Build
        # Language-specific build
      - name: Test
        # Language-specific test
      - name: Lint
        # Language-specific lint
```

## Configuration Files

The scaffolder generates appropriate config files per language:
- **Rust**: `Cargo.toml`, `clippy.toml`, `rustfmt.toml`
- **Go**: `go.mod`, `Makefile`, `.golangci.yml`
- **Python**: `pyproject.toml`, `.flake8` or `ruff.toml`, `mypy.ini`
- **TypeScript**: `tsconfig.json`, `.eslintrc.json`, `.prettierrc`
- **C#**: `.csproj`, `.editorconfig`, `Directory.Build.props`
- **Java**: `pom.xml` or `build.gradle`, `checkstyle.xml`

## Usage Guidelines

1. Specify the language and project type
2. Provide the project name and any specific requirements
3. The scaffolder creates the directory structure and essential files
4. Route to the appropriate language expert for implementation

## Integration

Coordinates with:
- All language expert agents (for language-specific implementation)
- `devops-orchestrator` (for CI/CD and Dockerfile generation)
- `database-specialist` (for database migration setup)
