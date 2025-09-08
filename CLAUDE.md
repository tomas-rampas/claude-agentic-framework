# Claude Code CLI - Global Configuration v2.0

## 🎯 OPTIMIZED DEVELOPMENT FRAMEWORK

**Core Principle**: Intelligent delegation to specialized agents with smart MCP activation for maximum efficiency within orchestrator limits.

## 🚀 ACTIVE MCP SERVERS (Smart Activation)

| Server | Purpose | Activation | Performance Benefit |
|--------|---------|------------|-------------------|
| **context7** | External documentation | On-demand for framework/library usage | Official patterns, version-specific guidance |
| **filesystem** | Enhanced file operations | Conditional (large files, atomic writes) | 10x faster for large files, atomic safety |
| **serena** | Semantic code intelligence | Conditional (symbol operations, refactoring) | Type-aware operations, cross-reference tracking |
| **sequentialthinking** | Complex reasoning | Conditional (>3 components, systematic analysis) | Multi-step problem decomposition |

## CORE OPERATING PRINCIPLES

### Primary Directive: Intelligent Delegation with Smart MCP Usage
**ALWAYS delegate to specialized agents. MCPs activate automatically based on context, not by default.**

Every request workflow:
1. **Analyze** complexity and required capabilities
2. **Route** to appropriate lean agent(s)
3. **Activate** MCPs conditionally based on task requirements
4. **Execute** efficiently with minimal overhead
5. **Validate** results through automated quality gates

## OPTIMIZED AGENT MATRIX

| Agent | Model | Context | Primary MCPs | Specialization |
|-------|-------|---------|--------------|----------------|
| **plan-agent** | opus | ~1000 tokens | sequentialthinking, context7 | Strategic planning, architecture design |
| **reader-agent** | haiku | ~900 tokens | filesystem, serena | Fast analysis, information extraction |
| **maker-agent** | sonnet | ~1100 tokens | filesystem, serena, context7 | Code implementation, refactoring |
| **security-agent** | haiku | ~870 tokens | filesystem, serena | Vulnerability scanning, security validation |
| **test-agent** | haiku | ~810 tokens | filesystem, serena | Quality validation, test execution |
| **docs-agent** | haiku | ~880 tokens | filesystem, context7 | Documentation generation, maintenance |
| **debug-agent** | sonnet | ~950 tokens | filesystem, serena, sequentialthinking | Systematic debugging, root cause analysis |

## SMART MCP ACTIVATION PATTERNS

### 🧠 Sequential Thinking MCP
**Auto-activates when:**
- Problem complexity >3 interconnected components
- Architectural decision-making required
- Systematic debugging with multiple error categories
- Multi-step planning or strategy development

**Agents that use it:**
- plan-agent: PRIMARY (strategic planning, architecture)
- debug-agent: Complex debugging scenarios
- maker-agent: Complex algorithm implementation

### 📚 Context7 MCP  
**Auto-activates when:**
- External library or framework usage detected
- Best practices or migration guides needed
- API documentation lookup required
- Framework-specific patterns needed

**Agents that use it:**
- plan-agent: Technology selection, best practices
- maker-agent: Implementation following official patterns
- docs-agent: Documentation with official examples

### 🔍 Serena MCP
**Auto-activates when:**
- Symbol operations (refactoring, renaming)
- Reference tracking across codebase
- Type-safe modifications required
- Code analysis or impact assessment needed

**Agents that use it:**
- reader-agent: Semantic code exploration
- maker-agent: Symbol-aware modifications
- security-agent: Data flow tracing
- debug-agent: Call graph traversal

### 📁 Filesystem MCP
**Auto-activates when:**
- File size >1MB or atomic writes required
- Directory tree operations
- Concurrent file access
- Large-scale file processing

**Agents that use it:**
- ALL agents: Replace basic Read/Write for enhanced operations
- reader-agent: Efficient large file analysis
- maker-agent: Safe concurrent writes
- debug-agent: Large log file processing

## DEVELOPMENT WORKFLOW PATTERNS

### Single-Agent Patterns (Preferred for Efficiency)
```
Simple Analysis → reader-agent
Basic Implementation → maker-agent  
Security Scan → security-agent
Documentation → docs-agent
Bug Investigation → debug-agent
```

### Two-Agent Patterns (Common)
```
Understand + Implement:
reader-agent → maker-agent

Debug + Fix:
debug-agent → maker-agent

Plan + Build:
plan-agent → maker-agent
```

### Multi-Agent Patterns (Complex Projects)
```
Full Feature Development:
plan-agent → reader-agent → maker-agent → test-agent → docs-agent

Security-First Development:
security-agent → plan-agent → maker-agent → test-agent → security-agent

Performance Optimization:
debug-agent → reader-agent → maker-agent → test-agent → debug-agent
```

## PROJECT-SPECIFIC USAGE EXAMPLES

### Web Development (React/Next.js)
```
"Build a user authentication system"
→ plan-agent uses context7 for Next.js auth patterns
→ maker-agent implements following official patterns
→ security-agent validates auth implementation
→ test-agent creates comprehensive auth tests
```

### API Development (REST/GraphQL)
```
"Create a scalable API with rate limiting"
→ plan-agent designs API architecture with best practices
→ reader-agent analyzes existing API patterns
→ maker-agent implements with framework-specific patterns
→ security-agent validates rate limiting and auth
```

### Database Operations
```
"Optimize slow database queries"
→ debug-agent uses sequentialthinking for systematic analysis
→ reader-agent analyzes query patterns with serena
→ maker-agent optimizes queries with atomic file updates
→ test-agent validates performance improvements
```

### Mobile Development (React Native/Flutter)
```
"Implement offline data sync"
→ plan-agent uses context7 for platform-specific patterns
→ maker-agent implements following official docs
→ test-agent validates sync across different scenarios
```

### DevOps/Infrastructure
```
"Set up CI/CD pipeline with security scanning"
→ plan-agent designs pipeline architecture
→ maker-agent implements pipeline configuration
→ security-agent validates security scanning integration
→ test-agent ensures pipeline reliability
```

## LANGUAGE-SPECIFIC OPTIMIZATIONS

### JavaScript/TypeScript Projects
- **Context7**: React, Next.js, Node.js, TypeScript best practices
- **Serena**: Component analysis, dependency tracking
- **Filesystem**: Package.json, large bundle analysis
- **Sequential**: Complex async flow design

### Python Projects
- **Context7**: Django, FastAPI, Flask documentation
- **Serena**: Class hierarchy analysis, import optimization
- **Filesystem**: Virtual environment, requirements management
- **Sequential**: Data pipeline architecture

### Java/Spring Projects
- **Context7**: Spring Boot, Maven/Gradle patterns
- **Serena**: Interface analysis, annotation processing
- **Filesystem**: Large JAR analysis, configuration management
- **Sequential**: Microservice architecture design

### Go Projects
- **Context7**: Go standard library, framework patterns
- **Serena**: Package analysis, interface definitions
- **Filesystem**: Module management, binary analysis
- **Sequential**: Concurrent architecture design

## SMART ROUTING DECISION TREE

```
File Analysis → reader-agent
Code Implementation → maker-agent
Architecture Design → plan-agent
Security Review → security-agent
Testing/Validation → test-agent
Documentation → docs-agent
Error Investigation → debug-agent

Complex Multi-Step Task → Start with plan-agent
Unknown Requirements → Start with reader-agent
Performance Issues → Start with debug-agent
```

## QUALITY GATES (Automated)

### Pre-Development
- ✅ Requirements analyzed (reader-agent or plan-agent)
- ✅ Architecture validated (plan-agent with sequentialthinking)
- ✅ Patterns researched (context7 activation)

### During Development  
- ✅ Code compiles and passes linting (maker-agent)
- ✅ Symbol consistency maintained (serena activation)
- ✅ File operations atomic (filesystem activation)

### Post-Development
- ✅ Security vulnerabilities addressed (security-agent)
- ✅ Test coverage adequate (test-agent)
- ✅ Documentation current (docs-agent)

### Production Ready
- ✅ No critical security issues
- ✅ Performance benchmarks met
- ✅ All quality gates passed

## COMMON DEVELOPMENT SCENARIOS

### New Project Setup
```
1. plan-agent: Project architecture with technology selection
2. maker-agent: Initial project structure and configuration
3. security-agent: Security baseline and best practices
4. test-agent: Testing framework setup
5. docs-agent: Initial documentation and README
```

### Feature Development
```
1. reader-agent: Analyze existing codebase (if needed)
2. plan-agent: Feature design and integration strategy (if complex)
3. maker-agent: Implementation following discovered patterns
4. security-agent: Security implications review
5. test-agent: Feature testing and validation
6. docs-agent: Documentation updates
```

### Bug Fixing
```
1. debug-agent: Systematic bug investigation
2. reader-agent: Related code analysis (if needed)
3. maker-agent: Precise fix implementation
4. test-agent: Regression testing
5. docs-agent: Update if user-facing
```

### Code Refactoring
```
1. reader-agent: Current implementation analysis
2. plan-agent: Refactoring strategy (if complex)
3. test-agent: Preserve existing behavior tests
4. maker-agent: Safe refactoring with serena
5. test-agent: Validate behavior unchanged
```

### Dependency Updates
```
1. reader-agent: Current usage analysis
2. plan-agent: Update strategy and risk assessment
3. maker-agent: Systematic updates following migration guides
4. test-agent: Comprehensive regression testing
5. docs-agent: Update version documentation
```

## ERROR HANDLING & RECOVERY

### MCP Server Issues
```
Context7 unavailable → Use cached patterns + flag for review
Filesystem unavailable → Fall back to native Read/Write tools
Serena unavailable → Use text-based search as fallback
Sequential unavailable → Use agent's native reasoning
```

### Agent Overload
```
Agent hits token limit → Break task into smaller chunks
Complex task overwhelming → Route to plan-agent first
Multiple failures → Systematic debug-agent investigation
```

### Quality Gate Failures
```
Security issues found → security-agent → maker-agent → test-agent loop
Test failures → debug-agent → maker-agent → test-agent loop
Performance degradation → debug-agent investigation → optimization cycle
```

## OPTIMIZATION STRATEGIES

### Token Efficiency
1. **Single-agent solutions** when possible
2. **Smart MCP activation** only when needed
3. **Parallel execution** for independent tasks
4. **Context-aware routing** to avoid unnecessary coordination

### Performance Optimization
1. **Cache MCP responses** for repeated queries
2. **Batch operations** when possible
3. **Scope limitation** for large codebases
4. **Incremental processing** for large changes

### Development Speed
1. **Pattern recognition** through context7 caching
2. **Symbol-aware operations** through serena
3. **Atomic operations** through filesystem
4. **Systematic approaches** through sequential thinking

## PROJECT TEMPLATES

### Web Application
- **Primary agents**: plan-agent, maker-agent, security-agent, test-agent
- **Key MCPs**: context7 (React/Next.js), serena (components), filesystem (builds)
- **Workflows**: Architecture-first, security-integrated, test-driven

### API Service
- **Primary agents**: plan-agent, maker-agent, security-agent, docs-agent
- **Key MCPs**: context7 (framework docs), serena (API structure), filesystem (configs)
- **Workflows**: API-first design, comprehensive testing, security validation

### Data Processing
- **Primary agents**: plan-agent, maker-agent, debug-agent, test-agent
- **Key MCPs**: sequentialthinking (pipeline design), filesystem (large data), serena (processing logic)
- **Workflows**: Performance-focused, systematic optimization, data validation

### Mobile Application
- **Primary agents**: plan-agent, maker-agent, test-agent, docs-agent
- **Key MCPs**: context7 (platform docs), filesystem (assets), serena (navigation)
- **Workflows**: Platform-specific, performance-conscious, user-experience focused

---

## 🎯 SUMMARY: INTELLIGENT DEVELOPMENT

Your development workflow is now powered by:

- **🤖 7 specialized agents** operating efficiently within token limits
- **⚡ 4 smart MCP servers** activating conditionally for enhanced capabilities  
- **🔄 Optimized workflows** from single-agent to complex multi-agent orchestration
- **🛡️ Automated quality gates** ensuring production-ready code
- **📊 Performance monitoring** with intelligent routing and fallback strategies

**Remember**: Always delegate to agents, let MCPs activate smartly, never execute tasks directly. This framework scales from simple scripts to enterprise applications while maintaining efficiency and quality.