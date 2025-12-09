---
name: exa-search
description: Search the web for content matching a query with AI-powered semantic search. Use for finding relevant web pages, research papers, news articles, code repositories, or any web content by meaning rather than just keywords.
---

# Exa Search

Token-efficient strategies for web search using exa-ai.

**Use `--help` to see available commands and verify usage before running:**
```bash
exa-ai <command> --help
```

## Critical Requirements

**MUST follow these rules when using exa-ai search:**

### Shared Requirements

This skill inherits requirements from [Common Requirements](../../../docs/common-requirements.md):
- Schema design patterns → All schema operations
- Output format selection → All output operations

### MUST NOT Rules

1. **Avoid --text flag**: Prefer structured output with schemas over raw text extraction for better token efficiency

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
exa-ai search "AI news" --num-results 10

# ✅ Approach 1: toon format for direct reading (60% reduction)
exa-ai search "AI news" --num-results 3 --output-format toon

# ✅ Approach 2: JSON + jq for field extraction (90% reduction)
exa-ai search "AI news" --num-results 3 | jq -r '.results[].title'

# ❌ Don't mix toon with jq (toon is YAML-like, not JSON)
exa-ai search "AI news" --output-format toon | jq -r '.results[].title'
```

## Quick Start

### Basic Search
```bash
exa-ai search "Anthropic Claude new features" --num-results 5 --output-format toon
```

### Search with Category Filter
```bash
exa-ai search "machine learning architectures" --category "research paper" --num-results 10
```

### Extract Structured Data
```bash
exa-ai search "AI safety research papers 2024" \
  --summary \
  --summary-schema '{"type":"object","properties":{"title":{"type":"string"},"key_finding":{"type":"string"}}}' \
  --num-results 3 | jq -r '.results[].summary | fromjson | "- \(.title): \(.key_finding)"'
```

### LinkedIn Search
```bash
exa-ai search "Anthropic" --linkedin company
exa-ai search "Dario Amodei" --linkedin person
```

## Detailed Reference

For complete options, examples, and advanced usage, consult [REFERENCE.md](REFERENCE.md).
