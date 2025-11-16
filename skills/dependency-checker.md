---
name: dependency-checker
description: Check framework dependencies and tool requirements
category: operational
priority: medium
author: framework-team
tags: [dependencies, tools, requirements, setup]
---

# Dependency Checker Skill

## Purpose

Verify all required tools and dependencies for the framework and agent validation hooks are properly installed and configured.

## When to Use

- During initial framework setup
- After system updates
- Before running validation hooks
- When troubleshooting "command not found" errors
- For new team member onboarding

## Dependency Categories

### 1. Essential Tools (Required)

```bash
# Check essential tools
essential_tools=(
  "git"
  "jq"
  "python3"
  "bash"
)

for tool in "${essential_tools[@]}"; do
  if command -v "$tool" &> /dev/null; then
    version=$($tool --version 2>&1 | head -1)
    echo "✅ $tool: $version"
  else
    echo "❌ $tool: NOT FOUND (REQUIRED)"
  fi
done
```

### 2. Language-Specific Tools

#### Rust Tools
```bash
rust_tools=("cargo" "rustc" "rustfmt" "clippy")
for tool in "${rust_tools[@]}"; do
  command -v "$tool" &> /dev/null && \
    echo "✅ $tool" || echo "⚠️  $tool (for Rust development)"
done
```

#### .NET Tools
```bash
dotnet_tools=("dotnet")
command -v dotnet &> /dev/null && \
  echo "✅ dotnet: $(dotnet --version)" || \
  echo "⚠️  dotnet (for C# development)"
```

#### Go Tools
```bash
go_tools=("go" "gofmt" "staticcheck" "golangci-lint")
for tool in "${go_tools[@]}"; do
  command -v "$tool" &> /dev/null && \
    echo "✅ $tool" || echo "⚠️  $tool (for Go development)"
done
```

#### Python Tools
```bash
python_tools=("python3" "pip3" "black" "flake8" "mypy" "pytest")
for tool in "${python_tools[@]}"; do
  command -v "$tool" &> /dev/null && \
    echo "✅ $tool" || echo "⚠️  $tool (for Python development)"
done
```

#### TypeScript/Node Tools
```bash
node_tools=("node" "npm" "tsc" "eslint" "prettier")
for tool in "${node_tools[@]}"; do
  command -v "$tool" &> /dev/null && \
    echo "✅ $tool" || echo "⚠️  $tool (for TypeScript development)"
done
```

#### Shell Script Tools
```bash
shell_tools=("shellcheck" "shfmt")
for tool in "${shell_tools[@]}"; do
  command -v "$tool" &> /dev/null && \
    echo "✅ $tool" || echo "⚠️  $tool (for Bash development)"
done
```

#### PowerShell Tools
```bash
command -v pwsh &> /dev/null && \
  echo "✅ pwsh: $(pwsh --version)" || \
  echo "⚠️  pwsh (for PowerShell development)"
```

### 3. Infrastructure Tools

```bash
infra_tools=(
  "terraform"
  "docker"
  "kubectl"
  "helm"
  "ansible"
)

for tool in "${infra_tools[@]}"; do
  if command -v "$tool" &> /dev/null; then
    echo "✅ $tool"
  else
    echo "⚠️  $tool (for infrastructure work)"
  fi
done
```

### 4. Security Tools

```bash
security_tools=(
  "trivy"
  "bandit"
  "gosec"
  "snyk"
)

for tool in "${security_tools[@]}"; do
  command -v "$tool" &> /dev/null && \
    echo "✅ $tool" || echo "⚠️  $tool (for security scanning)"
done
```

## Comprehensive Dependency Report

```
═══════════════════════════════════════════════════════════
DEPENDENCY CHECK REPORT
Generated: 2025-11-16 15:55 UTC
═══════════════════════════════════════════════════════════

ESSENTIAL TOOLS (4/4) ✅
  ✅ git v2.42.0
  ✅ jq v1.6
  ✅ python3 v3.11.5
  ✅ bash v5.2.15

LANGUAGE EXPERTS

  Rust Development (4/6)
    ✅ cargo v1.74.0
    ✅ rustc v1.74.0
    ✅ rustfmt v1.6.0
    ✅ clippy v0.1.74
    ⚠️  cargo-tarpaulin (optional - code coverage)
    ⚠️  cargo-audit (optional - security scanning)

  C#/.NET Development (1/3)
    ✅ dotnet v8.0.100
    ⚠️  dotnet-format (install via: dotnet tool install -g dotnet-format)
    ⚠️  coverlet (install via NuGet)

  Go Development (3/5)
    ✅ go v1.21.4
    ✅ gofmt (included with go)
    ✅ staticcheck v0.4.6
    ⚠️  golangci-lint (install: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest)
    ⚠️  gosec (install: go install github.com/securego/gosec/v2/cmd/gosec@latest)

  Python Development (6/8)
    ✅ python3 v3.11.5
    ✅ pip3 v23.2.1
    ✅ black v23.10.1
    ✅ flake8 v6.1.0
    ✅ mypy v1.6.1
    ✅ pytest v7.4.3
    ⚠️  bandit (install: pip install bandit)
    ⚠️  safety (install: pip install safety)

  TypeScript/JavaScript (5/6)
    ✅ node v20.9.0
    ✅ npm v10.1.0
    ✅ tsc v5.2.2
    ✅ eslint v8.52.0
    ✅ prettier v3.0.3
    ⚠️  jest (install: npm install -g jest)

  Shell Scripting (1/2)
    ✅ shellcheck v0.9.0
    ⚠️  shfmt (install: brew install shfmt or go install mvdan.cc/sh/v3/cmd/shfmt@latest)

  PowerShell (1/2)
    ✅ pwsh v7.4.0
    ⚠️  PSScriptAnalyzer (install in PowerShell: Install-Module PSScriptAnalyzer)

INFRASTRUCTURE TOOLS (3/5)
  ✅ docker v24.0.7
  ✅ kubectl v1.28.3
  ✅ terraform v1.6.3
  ⚠️  helm (install: brew install helm)
  ⚠️  ansible (install: pip install ansible)

SECURITY TOOLS (2/4)
  ✅ trivy v0.47.0
  ✅ bandit v1.7.5
  ⚠️  gosec (see Go tools)
  ⚠️  snyk (install: npm install -g snyk)

═══════════════════════════════════════════════════════════
SUMMARY
═══════════════════════════════════════════════════════════

Essential: 4/4 (100%) ✅
Recommended: 17/31 (55%) ⚠️
Optional: 10 available

Status: FUNCTIONAL ✅
  • All essential tools present
  • Core development tools available
  • Some optional tools missing

Recommendation: Install missing recommended tools for
full framework functionality.
```

## Installation Guides

### Rust Tools
```bash
# Install Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install additional tools
cargo install cargo-tarpaulin cargo-audit cargo-deny
```

### .NET Tools
```bash
# Install .NET SDK (download from microsoft.com)
# Then install tools:
dotnet tool install -g dotnet-format
dotnet tool install -g dotnet-coverage
```

### Go Tools
```bash
# Install Go (download from golang.org)
# Then install tools:
go install honnef.co/go/tools/cmd/staticcheck@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/securego/gosec/v2/cmd/gosec@latest
```

### Python Tools
```bash
pip3 install black flake8 mypy pytest pytest-cov bandit safety pip-audit
```

### TypeScript Tools
```bash
npm install -g typescript eslint prettier jest
```

### Shell Tools
```bash
# macOS
brew install shellcheck shfmt

# Linux
sudo apt-get install shellcheck
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

### Infrastructure Tools
```bash
# Docker (download from docker.com)
# Terraform (download from terraform.io)

# Kubernetes
brew install kubectl helm

# Or Linux:
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

## Automated Installation

```bash
#!/bin/bash
# install-deps.sh - Install recommended dependencies

echo "Installing Python tools..."
pip3 install black flake8 mypy pytest bandit safety

echo "Installing Node tools..."
npm install -g typescript eslint prettier jest

echo "Installing Go tools..."
go install honnef.co/go/tools/cmd/staticcheck@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

echo "Installing Rust tools..."
cargo install cargo-tarpaulin cargo-audit

echo "Installing shell tools..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install shellcheck shfmt
else
  sudo apt-get install -y shellcheck
  go install mvdan.cc/sh/v3/cmd/shfmt@latest
fi

echo "✅ Installation complete!"
```

## Dependency Validation for Hooks

### Check Hook Requirements

```bash
# Extract required tools from all validation hooks
for hook in hooks/*-validation.json; do
  echo "=== $(basename $hook) ==="
  jq -r '.tools_required.essential[]?' "$hook" 2>/dev/null
  jq -r '.tools_required.recommended[]?' "$hook" 2>/dev/null
done | sort -u

# Check if each tool is available
```

## CI/CD Dependency Check

```yaml
# .github/workflows/check-deps.yml
name: Check Dependencies
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check Dependencies
        run: |
          chmod +x skills/dependency-checker.sh
          ./skills/dependency-checker.sh --ci
```

## Platform-Specific Notes

### macOS
- Use Homebrew for most tools: `brew install <tool>`
- Some tools require Xcode Command Line Tools

### Linux (Ubuntu/Debian)
- Use apt-get for system tools
- Use language-specific package managers (pip, npm, cargo, go install)

### Windows
- Use Chocolatey or Scoop for package management
- PowerShell tools via PowerShell Gallery
- WSL2 recommended for Unix tools

## Summary

Dependency Checker:
- Verifies all required tools installed
- Identifies missing optional tools
- Provides installation instructions
- Supports multiple platforms
- Integrates with CI/CD

Run regularly to ensure framework dependencies are current.
