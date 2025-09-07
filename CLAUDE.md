# Claude Code CLI - Global Configuration with MCP Servers

## 🚀 ACTIVE MCP SERVERS

| Server | Purpose | Status | Primary Use |
|--------|---------|--------|-------------|
| **context7** | External library documentation | ✓ Connected | Framework patterns, API docs |
| **filesystem** | Enhanced file operations | ✓ Connected | Atomic writes, large files |
| **serena** | Semantic code intelligence | ✓ Connected | Symbol navigation, refactoring |
| **sequentialthinking** | Complex reasoning | ✓ Connected | Problem decomposition, planning |

## CORE OPERATING PRINCIPLES

### Primary Directive: Always Delegate with MCP Enhancement
**NEVER execute tasks directly. ALWAYS delegate to specialized agents with appropriate MCP servers.**

Every request must be:
1. Analyzed for complexity (use sequentialthinking if complex)
2. Delegated to appropriate agent(s)
3. Enhanced with relevant MCP servers
4. Orchestrated through proper workflow patterns
5. Validated through quality gates

## MCP-ENHANCED AGENT MATRIX

| Agent | Model | Primary MCPs | Secondary MCPs | Enhanced Capabilities |
|-------|-------|--------------|----------------|----------------------|
| **plan-agent** | opus | sequentialthinking | context7 | Deep reasoning, complex decomposition |
| **reader-agent** | haiku | filesystem, serena | - | Fast file ops, symbol analysis |
| **maker-agent** | sonnet | filesystem, serena, context7 | sequentialthinking | Context-aware generation |
| **security-agent** | haiku/sonnet | serena, filesystem | - | Data flow tracing, vulnerability scanning |
| **test-agent** | haiku | filesystem, serena | - | Test discovery, coverage analysis |
| **docs-agent** | haiku | filesystem, context7 | - | Doc generation with examples |
| **debug-agent** | haiku/sonnet | filesystem, serena | sequentialthinking | Log analysis, call graph tracing |

## Agent Output Configuration

### Plan-Agent
- ALWAYS output step-by-step planning to console
- Show decision tree for architecture choices
- Log performance calculations visibly

### Debug-Agent  
- Stream each error as it's being fixed
- Show compilation output after each fix
- Display error count reduction progress

### Maker-Agent
- Show file being modified
- Display line counts and changes
- Output performance metrics during creation

### Read-Agent
- List all files being analyzed
- Show dependency graph construction
- Output integration points discovered

### Doc-Agent
- Display documentation coverage percentage
- Show files being documented
- Output markdown generation progress

## MCP SERVER USAGE PATTERNS

### 📚 Context7 MCP - External Documentation
**When to use:**
- Before implementing ANY external library/framework code
- When upgrading dependencies
- For best practices and patterns
- API reference lookups

**Key operations:**
```
- Query framework documentation (React, Next.js, etc.)
- Get version-specific patterns
- Find migration guides
- Retrieve code examples
```

**Agent integration:**
- plan-agent: Technology selection with current best practices
- maker-agent: Implementation following official patterns
- docs-agent: Generate docs with official examples

### 📁 Filesystem MCP - Enhanced File Operations
**When to use:**
- Large file operations (>1MB)
- Atomic write requirements
- Directory tree analysis
- Concurrent file access
- Binary file handling

**Key operations:**
```
- filesystem.read(path) - Efficient file reading
- filesystem.write(path, content) - Atomic writes
- filesystem.list(directory) - Structured listing
- filesystem.tree(directory) - Recursive exploration
- filesystem.search(pattern) - Fast pattern matching
- filesystem.watch(path) - Change monitoring
```

**Agent integration:**
- ALL agents: Replace basic Read/Write with filesystem MCP
- reader-agent: Use for large file analysis
- maker-agent: Use for safe concurrent writes
- test-agent: Use for test file discovery

### 🔍 Serena MCP - Semantic Code Intelligence
**When to use:**
- Symbol-aware refactoring
- Finding all references
- Type-safe modifications
- Impact analysis
- Call graph navigation
- Method extraction

**Key operations:**
```
- getSymbolDefinition - Find where symbols are defined
- getSymbolReferences - Find all usages
- getDocumentSymbols - List symbols in file
- getWorkspaceSymbols - Search across project
- renameSymbol - Safe renaming across codebase
- extractMethod - Extract with reference updates
```

**Agent integration:**
- reader-agent: Semantic code exploration
- maker-agent: Symbol-aware modifications
- security-agent: Data flow analysis
- debug-agent: Call graph traversal

### 🧠 Sequential Thinking MCP - Complex Reasoning
**When to use:**
- Complex problem decomposition
- Multi-step planning
- Architectural decisions
- Strategy development
- Root cause analysis
- Algorithm design

**Key operations:**
```
- Break down complex problems into steps
- Maintain reasoning context across steps
- Develop comprehensive strategies
- Analyze trade-offs systematically
- Create detailed implementation plans
```

**Agent integration:**
- plan-agent: PRIMARY - All planning tasks
- debug-agent: Complex debugging scenarios
- maker-agent: Complex algorithm implementation

## MCP-ENHANCED WORKFLOW PATTERNS

### 🏗️ Architecture-First Development (All MCPs)
```
1. sequentialthinking → Break down requirements
2. plan-agent + sequentialthinking → Comprehensive architecture
3. context7 → Gather framework best practices
4. reader-agent + filesystem + serena → Analyze existing code
5. maker-agent + all MCPs → Context-aware implementation
6. security-agent + serena → Data flow security review
7. test-agent + filesystem → Comprehensive testing
8. docs-agent + context7 → Documentation with examples
```

### 🔄 Large-Scale Refactoring (Serena + Filesystem)
```
1. serena → Complete symbol mapping
2. sequentialthinking → Refactoring strategy
3. plan-agent + sequentialthinking → Phased plan
4. reader-agent + serena → Impact analysis
5. maker-agent + serena → Symbol-aware refactoring
6. filesystem → Atomic file updates
7. test-agent + filesystem → Continuous validation
```

### 🚀 New Feature Implementation (All MCPs)
```
1. sequentialthinking → Feature breakdown
2. context7 → Library documentation
3. serena → Current code patterns
4. plan-agent → Integration strategy
5. maker-agent + all MCPs → Implementation
6. filesystem → Safe file operations
7. test-agent → Validation
```

### 🐛 Complex Bug Investigation (Sequential + Serena)
```
1. sequentialthinking → Systematic analysis approach
2. debug-agent + sequentialthinking → Root cause hypothesis
3. serena → Trace through call graph
4. filesystem → Analyze logs efficiently
5. maker-agent + serena → Precise fix
6. test-agent → Regression prevention
```

## MCP COORDINATION MATRIX

| Task Type | Context7 | Filesystem | Serena | Sequential |
|-----------|----------|------------|---------|------------|
| New API endpoint | ✅ | ✅ | ✅ | - |
| Refactor function | - | ✅ | ✅ | - |
| Complex debugging | - | ✅ | ✅ | ✅ |
| Architecture design | ✅ | - | - | ✅ |
| Dependency upgrade | ✅ | ✅ | ✅ | ✅ |
| Security audit | - | ✅ | ✅ | - |
| Performance optimization | ✅ | ✅ | ✅ | ✅ |
| Documentation | ✅ | ✅ | - | - |

## MANDATORY MCP USAGE RULES

### File Operations - ALWAYS use Filesystem MCP
- ❌ DON'T: Use basic Read/Write for large files
- ✅ DO: Use filesystem.read() and filesystem.write()
- ✅ DO: Use filesystem for atomic operations

### Symbol Operations - ALWAYS use Serena MCP
- ❌ DON'T: Use text search for refactoring
- ✅ DO: Use serena for ALL symbol renames
- ✅ DO: Check references before changes

### External Libraries - ALWAYS use Context7 MCP
- ❌ DON'T: Guess at framework patterns
- ✅ DO: Query Context7 before implementation
- ✅ DO: Get version-specific documentation

### Complex Problems - ALWAYS use Sequential Thinking
- ❌ DON'T: Jump to solutions for complex issues
- ✅ DO: Use sequentialthinking for decomposition
- ✅ DO: Break down into manageable steps

## MCP ERROR HANDLING

### Fallback Strategies
```
If context7 fails → Use general best practices + flag for review
If filesystem fails → Fall back to Read/Write tools
If serena fails → Use grep/search for text-based fallback
If sequentialthinking fails → Use plan-agent's native reasoning
```

### Recovery Patterns
- MCP timeout → Reduce scope and retry
- MCP error → Log, fallback, continue
- MCP unavailable → Use native tools with warning

## QUALITY GATES WITH MCP

### Pre-Implementation Gate
- ✅ Context7 queried for patterns
- ✅ Serena analyzed current code
- ✅ Sequential thinking decomposed problem

### Post-Implementation Gate
- ✅ Serena verified all references updated
- ✅ Filesystem confirmed atomic writes
- ✅ No broken symbols detected

### Pre-Deployment Gate
- ✅ All MCP operations succeeded
- ✅ Fallbacks not triggered
- ✅ Symbol integrity maintained

## MCP OPTIMIZATION STRATEGIES

### Performance Tips
1. **Batch MCP operations** when possible
2. **Cache Context7 responses** for common queries
3. **Limit Serena scope** to relevant modules
4. **Use filesystem.tree() sparingly** on large directories
5. **Sequential thinking for truly complex problems only**

### Parallel MCP Usage
When independent, run MCPs in parallel:
```
Context7 (library docs) ──┐
                          ├──→ maker-agent
Serena (current code) ────┘
```

## REPORTING WITH MCP STATUS

### Progress Format
```
✅ Planning complete (plan-agent + sequentialthinking)
🔄 Context gathering (context7 + serena)
🔄 Implementation (maker-agent + filesystem)
⏸️ Testing queued (test-agent)
```

### MCP Health Check
```
MCP Status:
- context7: ✓ Connected
- filesystem: ✓ Connected
- serena: ✓ Connected
- sequentialthinking: ✓ Connected
All systems operational
```

## AGENT-SPECIFIC MCP INSTRUCTIONS

### For plan-agent
ALWAYS use sequentialthinking for:
- Problems with >3 components
- Architectural decisions
- Technology comparisons
- Risk assessments

### For maker-agent
ALWAYS use:
- context7 before using any external library
- serena before modifying existing code
- filesystem for all file writes

### For reader-agent
ALWAYS use:
- filesystem for file operations
- serena for symbol analysis
Priority: filesystem → serena → native tools

### For security-agent
ALWAYS use:
- serena to trace data flows
- filesystem to scan for secrets
Priority: serena for flow analysis

### For debug-agent
ALWAYS use:
- filesystem for ALL file operations (logs, errors, outputs)
- serena for ALL symbol analysis and call graph tracing
- sequentialthinking for problems with >2 error categories

NEVER:
- Use bash commands for file analysis
- Skip serena for symbol-related errors
- Analyze compilation output without filesystem MCP

Specific Debug Workflows
1. Compilation Error Analysis: filesystem → serena → sequentialthinking
2. Performance Debugging: sequentialthinking → filesystem → serena
3. Integration Issues: filesystem → serena → atomic fixes

## PRACTICAL MCP COMMAND EXAMPLES

### "Refactor this function"
```
1. serena: Find all references
2. sequentialthinking: Plan refactor steps
3. maker-agent + serena: Execute refactoring
4. filesystem: Atomic file updates
```

### "Add new REST endpoint"
```
1. context7: Get framework patterns
2. serena: Analyze existing endpoints
3. plan-agent + sequentialthinking: Design endpoint
4. maker-agent: Implement with patterns
```

### "Debug performance issue"
```
1. sequentialthinking: Systematic approach
2. debug-agent + filesystem: Analyze logs
3. serena: Trace hot paths
4. context7: Check for known issues
```

### "Update all dependencies"
```
1. context7: Get migration guides
2. serena: Find all usage points
3. sequentialthinking: Plan update sequence
4. maker-agent: Update systematically
```

---

**Remember**: You now have 4 powerful MCP servers. Use them wisely:
- 🧠 Sequential Thinking for complex reasoning
- 📚 Context7 for external knowledge
- 🔍 Serena for internal code intelligence  
- 📁 Filesystem for robust file operations

Always delegate to agents, always enhance with MCPs, never execute directly.
