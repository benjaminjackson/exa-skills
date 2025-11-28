# search

Search the web using Exa AI.

## Syntax

```bash
exa-ai search QUERY [OPTIONS]
```

## Required Arguments

- `QUERY`: Search query string

## Common Options

### Results Control
- `--num-results N`: Number of results to return (default: 10)
- `--type TYPE`: Search type: `fast`, `deep`, `keyword`, or `auto` (default: `fast`)

### Output Format
- `--output-format FMT`: Output format: `json`, `pretty`, `text`, or `toon` (recommended for 40% token savings)

### Content Extraction
- `--summary`: Include AI-generated summary
- `--summary-query PROMPT`: Custom prompt for summary generation
- `--summary-schema FILE`: JSON schema for summary structure (@file or inline)
- `--text`: Include full webpage text (avoid when possible - use summaries instead)
- `--text-max-characters N`: Max characters for webpage text

### Filtering
- `--category CAT`: Focus on specific data category
  - Options: `company`, `research paper`, `news`, `pdf`, `github`, `tweet`, `personal site`, `linkedin profile`, `financial report`
- `--include-domains D`: Comma-separated list of domains to include
- `--exclude-domains D`: Comma-separated list of domains to exclude
- `--start-published-date DATE`: Filter by published date (ISO 8601 format)
- `--end-published-date DATE`: Filter by published date (ISO 8601 format)

### LinkedIn
- `--linkedin TYPE`: Search LinkedIn: `company`, `person`, or `all`

## Examples

### Basic Search with toon Format
```bash
exa-ai search "ruby programming tutorials" --output-format toon --num-results 5
```

### Search with Category Filter
```bash
exa-ai search "machine learning architectures" --category "research paper" --num-results 10
```

### Search with Summary
```bash
exa-ai search "Anthropic AI safety research" --summary --num-results 3
```

### Extract Only Summaries with jq
```bash
exa-ai search "React 19 features" --summary --num-results 5 | jq '.results[].summary'
```

### Search with Structured Schema
```bash
exa-ai search "Claude API features" \
  --summary \
  --summary-schema '{"type":"object","properties":{"feature_name":{"type":"string"},"description":{"type":"string"}}}' \
  --num-results 3
```

### Format Schema Results with jq
```bash
exa-ai search "top programming languages 2024" \
  --summary \
  --summary-schema '{"type":"object","properties":{"language":{"type":"string"},"use_case":{"type":"string"}}}' \
  --num-results 5 | jq -r '.results[].summary | fromjson | "- \(.language): \(.use_case)"'
```

### Domain Filtering
```bash
# Only search academic sources
exa-ai search "transformer models" --include-domains arxiv.org,scholar.google.com --num-results 10

# Exclude social media
exa-ai search "AI news" --exclude-domains twitter.com,reddit.com --num-results 10
```

### LinkedIn Search
```bash
# Search for companies
exa-ai search "AI startups San Francisco" --linkedin company --num-results 10

# Search for people
exa-ai search "machine learning researchers" --linkedin person --num-results 5
```

### Date Filtering
```bash
# Only recent content
exa-ai search "ChatGPT updates" --start-published-date "2024-01-01" --num-results 10
```

### Token-Optimized Workflow
```bash
# Maximum token efficiency: toon format + jq extraction + limited results
exa-ai search "best practices for REST APIs" \
  --num-results 3 \
  --output-format toon | jq -r '.results[] | {title: .title, url: .url}'
```

## Token Usage Comparison

```bash
# ❌ Full JSON (~1000 tokens for 5 results)
exa-ai search "AI news" --num-results 5

# ✅ toon format (~600 tokens - 40% savings)
exa-ai search "AI news" --num-results 5 --output-format toon

# ✅✅ toon + jq (~100 tokens - 90% savings)
exa-ai search "AI news" --num-results 5 --output-format toon | jq -r '.results[].title'
```

## Complete Options

For all available options, run:
```bash
exa-ai search --help
```
