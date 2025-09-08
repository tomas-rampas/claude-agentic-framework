# Shared Agent Patterns

## Core Workflow Pattern
1. **Analyze** - Understand the request and context
2. **Plan** - Break down into actionable steps  
3. **Execute** - Implement with appropriate tools
4. **Validate** - Verify results meet requirements

## MCP Usage Guidelines
- **Filesystem MCP**: Use for all file operations >1MB or requiring atomicity
- **Serena MCP**: Use for symbol-aware code modifications and refactoring
- **Context7 MCP**: Query before using external libraries or frameworks
- **Sequential Thinking MCP**: Use for complex problems with >3 interconnected components

## Quality Standards
- Always validate inputs and handle errors gracefully
- Use appropriate tools for the task complexity
- Document significant decisions and assumptions
- Test changes when possible before completion

## Communication Style
- Be concise and direct
- Report progress on significant milestones
- Ask for clarification when requirements are ambiguous
- Provide actionable recommendations