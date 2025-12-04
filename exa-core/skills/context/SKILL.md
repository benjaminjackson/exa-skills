---
name: exa-context
description: Get code context from repositories with examples and documentation. Use when you need code snippets, implementation examples, API usage patterns, or technical documentation for programming concepts, frameworks, or libraries.
---

# Exa Context

Token-efficient strategies for retrieving code context using exa-ai.

**Use `--help` to see available commands and verify usage before running:**
```bash
exa-ai <command> --help
```

## Critical Requirements

**MUST follow these rules when using exa-ai context:**

1. **Use dynamic tokens**: Default `--tokens-num dynamic` adapts to content; specify exact number only when needed
2. **Prefer text format**: Use `--output-format text` for direct use in prompts or documentation

## Cost Optimization

### Pricing
- **1-25 results**: $0.005 per search
- **26-100 results**: $0.025 per search (5x more expensive)

**Cost strategy:**
1. **Default to 1-25 results**: 5x cheaper, sufficient for most queries
2. **Need 50+ results? Run multiple targeted searches**: Two 25-result searches with different angles beats one 50-result search (better quality, more control)
3. **Use 26-100 results sparingly**: Only when you need comprehensive coverage that multiple targeted searches would miss

## Token Optimization

**Apply these strategies:**

- **Use toon format**: `--output-format toon` for 40% fewer tokens than JSON (use when reading output directly)
- **Use text format**: `--output-format text` to get raw context without JSON wrapper (ideal for piping to other commands)
- **Use JSON + jq**: Extract only the context field with jq when processing programmatically
- **Set token limits**: Use `--tokens-num N` to control response size

**IMPORTANT**: Choose one approach, don't mix them:
- **Approach 1: text format** - Raw context output for direct use (no JSON wrapper)
- **Approach 2: toon format** - Compact YAML-like output for direct reading
- **Approach 3: JSON + jq** - Extract context field programmatically

Examples:
```bash
# ❌ High token usage - full JSON wrapper
exa-ai context "React hooks"

# ✅ Approach 1: text format for direct use (removes JSON overhead)
exa-ai context "React hooks" --output-format text

# ✅ Approach 2: toon format for reading (40% reduction)
exa-ai context "React hooks" --output-format toon

# ✅ Approach 3: JSON + jq to extract context only
exa-ai context "React hooks" | jq -r '.context'
```

## Quick Start

### Basic Context Retrieval
```bash
exa-ai context "React hooks useState useEffect" --output-format toon
```

### Specific Token Limit
```bash
exa-ai context "Python async/await patterns" --tokens-num 5000
```

### Authentication Patterns
```bash
exa-ai context "JWT authentication with Ruby on Rails" \
  --tokens-num 3000 \
  --output-format text
```

### Extract Context for Direct Use
```bash
exa-ai context "GraphQL schema design best practices" \
  --tokens-num 4000 | jq -r '.context'
```

## Detailed Reference

For complete options, examples, and advanced usage, consult [REFERENCE.md](REFERENCE.md).
