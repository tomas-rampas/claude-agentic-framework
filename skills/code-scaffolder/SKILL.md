---
name: code-scaffolder
description: Generate idiomatic project scaffolding, config files, and boilerplate per language — use when starting a new project, adding a service, or bootstrapping a library/package (e.g. "scaffold a Rust CLI", "set up a new FastAPI project").
---

# Code Scaffolder

Generate idiomatic project structures, configuration files, and boilerplate for new projects across the languages covered by the framework's language expert agents (see the registry, claude.json).

## When to Use

- Starting a new project from scratch
- Adding a new service to an existing system
- Setting up test infrastructure for a project
- Creating CI/CD pipeline configurations
- Bootstrapping a library or package

## Workflow

1. Confirm the language, project type, and project name; ask for any missing requirements (framework choice, package manager, target platform).
2. Create the directory structure and essential files from the matching template below, adapting names and conventions to the project.
3. Generate the language-appropriate config files (see Configuration Files).
4. Hand off implementation to the matching language expert agent from the roster; involve devops-orchestrator for CI/CD and Dockerfiles, database-specialist for migrations.

## Templates by Language

### Rust — CLI Application

```
my-cli/
├── Cargo.toml
├── src/
│   ├── main.rs
│   ├── cli.rs          # clap argument definitions
│   ├── config.rs       # configuration handling
│   └── error.rs        # custom error types (thiserror)
├── tests/integration.rs
├── .github/workflows/ci.yml
├── .gitignore
└── README.md
```

### Rust — Library Crate

```
my-lib/
├── Cargo.toml
├── src/
│   ├── lib.rs
│   └── types.rs
├── tests/integration.rs
├── examples/basic.rs
├── benches/benchmark.rs
└── README.md
```

### Go — HTTP Service

```
my-service/
├── go.mod
├── cmd/server/main.go
├── internal/
│   ├── handler/handler.go
│   ├── service/service.go
│   └── repository/repository.go
├── pkg/models/models.go
├── tests/integration_test.go
├── Dockerfile
├── Makefile
└── README.md
```

### Python — FastAPI Application

```
my-api/
├── pyproject.toml
├── src/my_api/
│   ├── __init__.py
│   ├── main.py         # FastAPI app
│   ├── routes/__init__.py
│   ├── models/__init__.py
│   ├── services/__init__.py
│   └── config.py
├── tests/
│   ├── conftest.py
│   └── test_routes.py
├── Dockerfile
├── .github/workflows/ci.yml
└── README.md
```

### TypeScript — Next.js Application

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
│   ├── components/ui/
│   └── lib/utils.ts
├── tests/setup.ts
├── .eslintrc.json
├── .prettierrc
└── README.md
```

### TypeScript — Node.js API

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
├── tests/setup.ts
├── Dockerfile
└── README.md
```

### C# — ASP.NET Core Web API

```
MyApi/
├── MyApi.sln
├── src/MyApi/
│   ├── MyApi.csproj
│   ├── Program.cs
│   ├── Controllers/
│   ├── Services/
│   ├── Models/
│   └── appsettings.json
├── tests/MyApi.Tests/
│   ├── MyApi.Tests.csproj
│   └── Controllers/
├── Dockerfile
└── README.md
```

### Java — Spring Boot Application

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
│   │   └── resources/application.yml
│   └── test/java/com/example/myapp/MyAppApplicationTests.java
├── Dockerfile
└── README.md
```

## CI/CD Template (GitHub Actions)

```yaml
name: CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup   # language-specific toolchain setup
      - name: Build   # language-specific build
      - name: Test    # language-specific test
      - name: Lint    # language-specific lint
```

## Configuration Files

Generate the appropriate config files per language:

- **Rust**: `Cargo.toml`, `clippy.toml`, `rustfmt.toml`
- **Go**: `go.mod`, `Makefile`, `.golangci.yml`
- **Python**: `pyproject.toml`, `ruff.toml` (or `.flake8`), `mypy.ini`
- **TypeScript**: `tsconfig.json`, `.eslintrc.json`, `.prettierrc`
- **C#**: `.csproj`, `.editorconfig`, `Directory.Build.props`
- **Java**: `pom.xml` or `build.gradle`, `checkstyle.xml`

## Integration

After scaffolding, delegate follow-on work to the appropriate specialists from the roster:

- The matching **language expert agent** — implementation of application logic
- **devops-orchestrator** — CI/CD pipelines and Dockerfile hardening
- **database-specialist** — database schema and migration setup

Scaffolded code should compile/run out of the box (empty but valid), and the test scaffold should pass before handing off.
