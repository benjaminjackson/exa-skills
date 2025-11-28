---
name: exa-get-contents
description: Retrieve and extract content from URLs with AI-powered summarization and structured data extraction. Use for scraping web pages, extracting specific information, summarizing articles, or crawling websites with subpages.
---

# Exa Get Contents

Token-efficient strategies for retrieving and extracting content from URLs using exa-ai.

## Critical Requirements

**MUST follow these rules when using exa-ai get-contents:**

1. **Always run --help first**: Before using the command for the first time, run `exa-ai get-contents --help`
2. **Use object wrapper for schemas**: When using `--summary-schema`, always wrap properties:
   ```json
   {"type":"object","properties":{"field_name":{"type":"string"}}}
   ```
3. **Prefer --summary over --text**: Use summaries with schemas for structured extraction instead of full text

## Token Optimization

**Apply these strategies:**

- **Use toon format**: `--output-format toon` for 40% fewer tokens than JSON (use when reading output directly)
- **Use JSON + jq**: Extract only needed fields with jq (use when piping/processing output)
- **Use --summary**: Get AI-generated summaries instead of full page text
- **Use schemas**: Extract structured data with `--summary-schema` (always pipe to jq)
- **Limit extraction**: Use `--text-max-characters`, `--links`, and `--image-links` to control output size

**IMPORTANT**: Choose one approach, don't mix them:
- **Approach 1: toon only** - Compact YAML-like output for direct reading
- **Approach 2: JSON + jq** - Extract specific fields programmatically
- **Approach 3: Schemas + jq** - Get structured data, always use JSON output (default) and pipe to jq

Examples:
```bash
# ❌ High token usage - full text
exa-ai get-contents "https://example.com" --text

# ✅ Approach 1: toon format with summary (70% reduction)
exa-ai get-contents "https://example.com" --summary --output-format toon

# ✅ Approach 2: JSON + jq for summary extraction (80% reduction)
exa-ai get-contents "https://example.com" --summary | jq '.results[].summary'

# ✅ Approach 3: Schema + jq for structured extraction (85% reduction)
exa-ai get-contents "https://example.com" \
  --summary \
  --summary-schema '{"type":"object","properties":{"key_info":{"type":"string"}}}' | \
  jq -r '.results[].summary | fromjson | .key_info'

# ❌ Don't mix toon with jq (toon is YAML-like, not JSON)
exa-ai get-contents "https://example.com" --output-format toon | jq -r '.results'
```

## Quick Start

### Basic Content with Summary
```bash
exa-ai get-contents "https://anthropic.com" --summary --output-format toon
```

### Custom Summary Query
```bash
exa-ai get-contents "https://techcrunch.com" \
  --summary \
  --summary-query "What are the main tech news stories on this page?" | jq '.results[].summary'
```

### Structured Data Extraction
```bash
exa-ai get-contents "https://www.stripe.com" \
  --summary \
  --summary-schema '{"type":"object","properties":{"company_name":{"type":"string"},"main_product":{"type":"string"},"target_market":{"type":"string"}}}' | jq -r '.results[].summary | fromjson'
```

### Multiple URLs
```bash
exa-ai get-contents "https://anthropic.com,https://openai.com,https://cohere.com" \
  --summary \
  --output-format toon
```

## Detailed Reference

For complete options, examples, and advanced usage, consult [REFERENCE.md](REFERENCE.md).
