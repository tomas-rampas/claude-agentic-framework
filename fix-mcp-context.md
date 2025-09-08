# MCP Context Optimization Guide

## 🚨 Issue Identified
**MCP tools context: ~25,039 tokens > 25,000 limit**

This can cause orchestrator limit issues and needs immediate optimization.

## 📊 Current Breakdown
- **serena**: 25 tools (~14,716 tokens) - 59% of total
- **filesystem**: 14 tools (~6,659 tokens) - 27% of total  
- **sequentialthinking**: 1 tools (~2,321 tokens) - 9% of total
- **context7**: 2 tools (~1,343 tokens) - 5% of total

## 🎯 Optimization Strategy

### 1. Serena MCP Optimization (Priority 1)
**Target: Reduce from 14,716 to ~6,000 tokens (60% reduction)**

**Essential Tools Only:**
```
- read_file (most used)
- find_symbol (core functionality)  
- find_referencing_symbols (refactoring)
- replace_symbol_body (modifications)
- get_symbols_overview (analysis)
```

**Tools to Make Conditional:**
- Advanced symbol operations
- Project-wide search functions
- Specialized language features

### 2. Filesystem MCP Optimization (Priority 2) 
**Target: Reduce from 6,659 to ~4,000 tokens (40% reduction)**

**Essential Tools Only:**
```
- read_text_file (most used)
- write_file (core functionality)
- list_directory (navigation)
- search_files (discovery)  
- edit_file (modifications)
```

**Tools to Make Conditional:**
- Advanced file operations
- Binary file handling
- Batch operations

### 3. Sequential Thinking MCP (Priority 3)
**Target: Reduce from 2,321 to ~1,200 tokens (50% reduction)**

**Optimization:**
- Compress tool descriptions
- Remove verbose examples
- Keep core reasoning functionality

### 4. Context7 MCP (Already Optimal)
**Target: Keep as-is (~1,343 tokens)**

Already well-optimized with only 2 essential tools.

## 🔧 Implementation Steps

### Step 1: Configure MCP Server Tool Filtering
Create MCP server configurations that expose only essential tools by default:

```json
{
  "serena": {
    "essential_tools_only": true,
    "conditional_tools": true,
    "max_context_tokens": 6000
  },
  "filesystem": {
    "essential_tools_only": true,
    "smart_activation": true,
    "max_context_tokens": 4000
  }
}
```

### Step 2: Agent-Specific Tool Exposure
Different agents get different tool sets:

- **reader-agent**: Basic read operations
- **maker-agent**: Full tool suite when needed
- **debug-agent**: Debugging-focused tools
- **security-agent**: Security-relevant tools only

### Step 3: Conditional Tool Activation
Tools activate based on:
- Task complexity
- File types being processed
- Agent specialization
- User request context

## 📈 Expected Results

### Token Usage Reduction
- **Before**: ~25,039 tokens
- **After**: ~12,543 tokens  
- **Reduction**: 50% (well under 25,000 limit)

### Performance Improvements
- ✅ Eliminates orchestrator limit warnings
- ✅ Faster agent initialization
- ✅ Reduced context pollution
- ✅ Maintained essential functionality

### Quality Preservation
- ✅ All core MCP functionality preserved
- ✅ Smart activation for advanced features
- ✅ No loss of agent capabilities
- ✅ Improved efficiency through focus

## ⚠️ Important Notes

1. **Test thoroughly** after implementing changes
2. **Monitor performance** to ensure no functionality loss
3. **Document** which tools are available to which agents
4. **Have rollback plan** if optimization causes issues

## 🎯 Success Criteria

- [ ] MCP context < 15,000 tokens (safe margin under 25,000)
- [ ] No orchestrator limit warnings
- [ ] All agent core functionality preserved
- [ ] Performance improvements measurable
- [ ] No increase in task failures

This optimization will eliminate the orchestrator context warnings while maintaining all essential functionality through smart tool activation.