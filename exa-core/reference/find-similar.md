# find-similar

Find content similar to a given URL.

## Syntax

```bash
exa-ai find-similar URL [OPTIONS]
```

## Required Arguments

- `URL`: URL to find similar content for

## Common Options

### Results Control
- `--num-results N`: Number of results to return (default: 10)
- `--exclude-source-domain`: Exclude results from the source URL's domain

### Output Format
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

### Content Extraction
- `--summary`: Include AI-generated summary
- `--summary-query PROMPT`: Custom prompt for summary generation
- `--summary-schema FILE`: JSON schema for summary structure
- `--text`: Include full webpage text

### Filtering
- `--category CAT`: Same categories as search (company, research paper, news, etc.)
- `--include-domains D`: Comma-separated domains to include
- `--exclude-domains D`: Comma-separated domains to exclude
- `--start-published-date DATE`: Filter by published date (ISO 8601)
- `--end-published-date DATE`: Filter by published date (ISO 8601)

## Examples

### Basic Similar Search
```bash
exa-ai find-similar "https://anthropic.com/claude" --output-format toon --num-results 5
```

### Exclude Source Domain
```bash
exa-ai find-similar "https://openai.com/research/gpt-4" \
  --exclude-source-domain \
  --num-results 10
```

### Find Similar with Summaries
```bash
exa-ai find-similar "https://arxiv.org/abs/1706.03762" \
  --summary \
  --num-results 5 | jq '.results[] | {title: .title, summary: .summary}'
```

### Category-Specific Similar Search
```bash
exa-ai find-similar "https://news.ycombinator.com/item?id=12345" \
  --category "news" \
  --num-results 10
```

### Find Similar Research Papers
```bash
exa-ai find-similar "https://arxiv.org/abs/2305.10601" \
  --category "research paper" \
  --num-results 10 \
  --output-format toon
```

### Extract Structured Data from Similar Content
```bash
exa-ai find-similar "https://techcrunch.com/ai-startup-funding" \
  --summary \
  --summary-schema '{"type":"object","properties":{"company_name":{"type":"string"},"funding_amount":{"type":"string"}}}' \
  --num-results 5 | jq -r '.results[].summary | fromjson | "\(.company_name): \(.funding_amount)"'
```

### Find Similar with Domain Filtering
```bash
# Find similar content only on specific domains
exa-ai find-similar "https://blog.anthropic.com/constitutional-ai" \
  --include-domains "arxiv.org,scholar.google.com" \
  --num-results 10
```

## Complete Options

For all available options, run:
```bash
exa-ai find-similar --help
```
