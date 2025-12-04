---
name: exa-answer
description: Generate answers to questions with structured output using AI search and synthesis. Use when you need factual answers with citations from web sources, or when you want to extract specific structured information in response to a query.
---

# Exa Answer

Token-efficient strategies for generating answers with structured output using exa-ai.

**Use `--help` to see available commands and verify usage before running:**
```bash
exa-ai <command> --help
```

## Critical Requirements

**MUST follow these rules when using exa-ai answer:**

1. **Use object wrapper for schemas**: When using `--output-schema`, always wrap properties:
   ```json
   {"type":"object","properties":{"field_name":{"type":"string"}}}
   ```
2. **Avoid --text**: Use `--text` only when you need full source text; otherwise rely on default behavior

## Cost Optimization

### Pricing
- **Per answer**: $0.005

**Cost strategy:**
- Use `answer` for questions with moderate complexity that need AI synthesis
- For simple lookups, use `search` instead (same cost but gives you URLs for verification)
- Consider whether you need a synthesized answer or just search results

## Token Optimization

**Apply these strategies:**

- **Use toon format**: `--output-format toon` for 40% fewer tokens than JSON (use when reading output directly)
- **Use JSON + jq**: Extract only needed fields with jq (use when piping/processing output)
- **Use schemas**: Structure answers with `--output-schema` for consistent, parseable output
- **Custom system prompts**: Use `--system-prompt` to guide answer style and format

**IMPORTANT**: Choose one approach, don't mix them:
- **Approach 1: toon only** - Compact YAML-like output for direct reading
- **Approach 2: JSON + jq** - Extract specific fields programmatically
- **Approach 3: Schemas + jq** - Get structured data, always use JSON output (default) and pipe to jq

Examples:
```bash
# ❌ High token usage
exa-ai answer "What is Claude?"

# ✅ Approach 1: toon format for direct reading (40% reduction)
exa-ai answer "What is Claude?" --output-format toon

# ✅ Approach 2: JSON + jq for field extraction (80% reduction)
exa-ai answer "What is Claude?" \
  --output-schema '{"type":"object","properties":{"product":{"type":"string"}}}' | jq -r '.answer.product'

# ❌ Don't mix toon with jq (toon is YAML-like, not JSON)
exa-ai answer "What is Claude?" --output-format toon | jq -r '.answer'
```

## Quick Start

### Basic Answer
```bash
exa-ai answer "What is Anthropic's main product?" --output-format toon
```

### Structured Output
```bash
exa-ai answer "What is Claude?" \
  --output-schema '{"type":"object","properties":{"product_name":{"type":"string"},"company":{"type":"string"},"description":{"type":"string"}}}'
```

### Array Output for Lists
```bash
exa-ai answer "What are the top 5 programming languages in 2024?" \
  --output-schema '{"type":"object","properties":{"languages":{"type":"array","items":{"type":"string"}}}}' | jq -r '.answer.languages | map("- " + .) | join("\n")'
```

### Custom System Prompt
```bash
exa-ai answer "Explain quantum computing" \
  --system-prompt "Respond in simple terms suitable for a high school student"
```

## Detailed Reference

For complete options, examples, and schema design tips, consult [REFERENCE.md](REFERENCE.md).
