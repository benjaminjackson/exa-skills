---
name: exa-find-similar
description: Find web content similar to a given URL using AI-powered similarity matching. Use when you have an example page and want to discover related articles, papers, or websites with similar content, style, or topic.
---

# Exa Find Similar

Token-efficient strategies for finding similar content using exa-ai.

## Critical Requirements

**MUST follow these rules when using exa-ai find-similar:**

1. **Always run --help first**: Before using the command for the first time, run `exa-ai find-similar --help`
2. **Use object wrapper for schemas**: When using `--summary-schema`, always wrap properties:
   ```json
   {"type":"object","properties":{"field_name":{"type":"string"}}}
   ```
3. **Avoid --text**: Prefer structured output with schemas over raw text extraction

## Token Optimization

**Apply these strategies:**

- **Use toon format**: `--output-format toon` for 40% fewer tokens than JSON (use when reading output directly)
- **Use JSON + jq**: Extract only needed fields with jq (use when piping/processing output)
- **Use --summary**: Get AI-generated summaries instead of full page text
- **Use schemas**: Extract structured data with `--summary-schema` (always pipe to jq)
- **Limit results**: Use `--num-results N` to get only what you need

**IMPORTANT**: Choose one approach, don't mix them:
- **Approach 1: toon only** - Compact YAML-like output for direct reading
- **Approach 2: JSON + jq** - Extract specific fields programmatically
- **Approach 3: Schemas + jq** - Get structured data, always use JSON output (default) and pipe to jq

Examples:
```bash
# ❌ High token usage
exa-ai find-similar "https://example.com" --num-results 10

# ✅ Approach 1: toon format for direct reading (60% reduction)
exa-ai find-similar "https://example.com" --num-results 3 --output-format toon

# ✅ Approach 2: JSON + jq for field extraction (90% reduction)
exa-ai find-similar "https://example.com" --num-results 3 | jq -r '.results[].title'

# ❌ Don't mix toon with jq (toon is YAML-like, not JSON)
exa-ai find-similar "https://example.com" --output-format toon | jq -r '.results[].title'
```

## Quick Start

### Basic Similar Search
```bash
exa-ai find-similar "https://anthropic.com/claude" --num-results 5 --output-format toon
```

### Exclude Source Domain
```bash
exa-ai find-similar "https://openai.com/research/gpt-4" \
  --exclude-source-domain \
  --num-results 10
```

### Find Similar with Structured Data
```bash
exa-ai find-similar "https://techcrunch.com/ai-startup-funding" \
  --summary \
  --summary-schema '{"type":"object","properties":{"company_name":{"type":"string"},"funding_amount":{"type":"string"}}}' \
  --num-results 5 | jq -r '.results[].summary | fromjson | "\(.company_name): \(.funding_amount)"'
```

### Category-Specific Search
```bash
exa-ai find-similar "https://arxiv.org/abs/2305.10601" \
  --category "research paper" \
  --num-results 10
```

## Detailed Reference

For complete options, examples, and advanced usage, consult [REFERENCE.md](REFERENCE.md).
