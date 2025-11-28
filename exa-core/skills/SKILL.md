---
name: exa-core
description: Use when the user mentions Exa search OR when the workflow benefits from web search, finding similar content, structured data extraction from URLs, summarization of URLs, code samples, or answering questions with citations from web sources. 
---

# Exa Core Search

Token-efficient strategies for using exa-ai core search commands.

## Critical Requirements

**MUST follow these rules when using exa-ai commands:**

1. **Always run --help first**: Before using any command for the first time, run `exa-ai <command> --help`
2. **Use object wrapper for schemas**: When using `--output-schema` or `--summary-schema`, always wrap properties:
   ```json
   {"type":"object","properties":{"field_name":{"type":"string"}}}
   ```
3. **Avoid --text**: Prefer structured output with schemas over raw text extraction

## Token Optimization

**Apply these strategies to all commands:**

- **Use toon format**: `--output-format toon` for 40% fewer tokens than JSON
- **Pipe to jq**: Extract only needed fields instead of full responses
- **Use --summary**: Get AI-generated summaries instead of full page text
- **Use schemas**: Extract structured data directly with `--summary-schema` or `--output-schema`
- **Limit results**: Use `--num-results N` to get only what you need

Example:
```bash
# ❌ High token usage
exa-ai search "AI news" --num-results 10

# ✅ Optimized (90% reduction)
exa-ai search "AI news" --num-results 3 --output-format toon | jq -r '.results[].title'
```

## Commands

### search
Search the web for content matching a query.

```bash
exa-ai search "Anthropic Claude new features" --num-results 5 --output-format toon
```

For detailed options and examples, consult [reference/search.md](reference/search.md).

### find-similar
Find content similar to a given URL.

```bash
exa-ai find-similar "https://anthropic.com/claude" --num-results 3
```

For detailed options and examples, consult [reference/find-similar.md](reference/find-similar.md).

### answer
Generate an answer to a question with structured output.

```bash
exa-ai answer "What is Anthropic's main product?" \
  --output-schema '{"type":"object","properties":{"product":{"type":"string"},"description":{"type":"string"}}}'
```

For detailed options and examples, consult [reference/answer.md](reference/answer.md).

### context
Get code context from repositories.

```bash
exa-ai context "React hooks best practices" --tokens-num 5000 --output-format toon
```

For detailed options and examples, consult [reference/context.md](reference/context.md).

### get-contents
Retrieve page contents with optional summarization.

```bash
exa-ai get-contents "https://anthropic.com" --summary --output-format toon
```

For detailed options and examples, consult [reference/get-contents.md](reference/get-contents.md).

## Quick Examples

### Extract Structured Data from Search
```bash
exa-ai search "AI safety research papers 2024" \
  --summary \
  --summary-schema '{"type":"object","properties":{"title":{"type":"string"},"key_finding":{"type":"string"}}}' \
  --num-results 3 | jq -r '.results[].summary | fromjson | "- \(.title): \(.key_finding)"'
```

### Multi-Step Workflow: Search → Extract
```bash
# Step 1: Search for relevant URLs
urls=$(exa-ai search "Anthropic research" --num-results 3 --output-format toon | jq -r '.results[].url')

# Step 2: Extract structured data from each
for url in $urls; do
  exa-ai get-contents "$url" \
    --summary \
    --summary-schema '{"type":"object","properties":{"topic":{"type":"string"},"summary":{"type":"string"}}}' | \
    jq -r '.results[].summary | fromjson | "## \(.topic)\n\(.summary)\n"'
done
```

### Get Answer with Formatted Output
```bash
exa-ai answer "What are the key differences between Claude and GPT-4?" \
  --output-schema '{
    "type":"object",
    "properties":{
      "claude_strengths":{"type":"array","items":{"type":"string"}},
      "gpt4_strengths":{"type":"array","items":{"type":"string"}}
    }
  }' | jq -r '.answer | "Claude:\n\(.claude_strengths | map("  - " + .) | join("\n"))\n\nGPT-4:\n\(.gpt4_strengths | map("  - " + .) | join("\n"))"'
```
