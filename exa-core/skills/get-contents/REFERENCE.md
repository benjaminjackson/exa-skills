# get-contents

Retrieve full page contents from URLs.

## Syntax

```bash
exa-ai get-contents URLS [OPTIONS]
```

## Required Arguments

- `URLS`: Comma-separated list of URLs

## Common Options

### Livecrawl (Always Use This)
- `--livecrawl-timeout N`: Timeout for live crawling in milliseconds (recommended: 10000)

### Text Extraction
- `--text`: Include page text in response
- `--text-max-characters N`: Max characters for page text
- `--include-html-tags`: Include HTML tags in text extraction

### Summary
- `--summary`: Include AI-generated summary (recommended over --text)
- `--summary-query PROMPT`: Custom prompt for summary generation
- `--summary-schema FILE`: JSON schema for summary structure (@file or inline)

### Output Format
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

### Additional Extraction
- `--links N`: Number of links to extract per result
- `--image-links N`: Number of image links to extract
- `--subpages N`: Number of subpages to crawl
- `--subpage-target PHRASE`: Subpage target phrases (repeatable)

## Examples

### Basic Content Retrieval with Summary
```bash
exa-ai get-contents "https://anthropic.com" --summary --livecrawl-timeout 10000 --output-format toon
```

### Extract Summary Only
```bash
exa-ai get-contents "https://openai.com/research" --summary --livecrawl-timeout 10000 | jq '.results[].summary'
```

### Custom Summary Query
```bash
exa-ai get-contents "https://techcrunch.com" \
  --summary \
  --livecrawl-timeout 10000 \
  --summary-query "What are the main tech news stories on this page?" | jq '.results[].summary'
```

### Structured Data Extraction with Schema
```bash
exa-ai get-contents "https://www.ycombinator.com/companies" \
  --summary \
  --livecrawl-timeout 10000 \
  --summary-schema '{"type":"object","properties":{"company_name":{"type":"string"},"description":{"type":"string"},"industry":{"type":"string"}}}' | jq -r '.results[].summary | fromjson | "\(.company_name) - \(.industry)\n\(.description)\n"'
```

### Multiple URLs
```bash
exa-ai get-contents "https://anthropic.com,https://openai.com,https://cohere.com" \
  --summary \
  --livecrawl-timeout 10000 \
  --output-format toon
```

### Extract Company Information
```bash
exa-ai get-contents "https://www.stripe.com" \
  --summary \
  --livecrawl-timeout 10000 \
  --summary-schema '{"type":"object","properties":{"company_name":{"type":"string"},"main_product":{"type":"string"},"target_market":{"type":"string"}}}' | jq -r '.results[].summary | fromjson'
```

### Extract Links and Images
```bash
exa-ai get-contents "https://example.com" \
  --links 10 \
  --image-links 5 \
  --livecrawl-timeout 10000 \
  --output-format toon
```

### Get Full Text (Use Sparingly)
```bash
# Only use --text when you need the full page content
exa-ai get-contents "https://docs.anthropic.com" \
  --text \
  --livecrawl-timeout 10000 \
  --text-max-characters 5000
```

### Crawl Subpages
```bash
exa-ai get-contents "https://example.com" \
  --subpages 2 \
  --subpage-target "about" \
  --livecrawl-timeout 10000 \
  --summary
```

## Token Optimization

```bash
# ❌ High token usage - full text
exa-ai get-contents "https://example.com" --text --livecrawl-timeout 10000

# ✅ Better - summary only with jq extraction
exa-ai get-contents "https://example.com" --summary --livecrawl-timeout 10000 | jq '.results[].summary'

# ✅ Best - structured extraction with schema + jq
exa-ai get-contents "https://example.com" \
  --summary \
  --livecrawl-timeout 10000 \
  --summary-schema '{"type":"object","properties":{"key_info":{"type":"string"}}}' | \
  jq -r '.results[].summary | fromjson | .key_info'

# ✅ Alternative - toon format for direct reading (no jq)
exa-ai get-contents "https://example.com" --summary --livecrawl-timeout 10000 --output-format toon
```

## Workflow Example: Extract Product Info from Multiple Companies

```bash
# URLs of companies to analyze
urls="https://anthropic.com,https://openai.com,https://cohere.com"

# Extract structured data
exa-ai get-contents "$urls" \
  --summary \
  --livecrawl-timeout 10000 \
  --summary-schema '{
    "type":"object",
    "properties":{
      "company":{"type":"string"},
      "product":{"type":"string"},
      "key_features":{"type":"array","items":{"type":"string"}}
    }
  }' | jq -r '.results[].summary | fromjson | "## \(.company)\nProduct: \(.product)\nFeatures:\n\(.key_features | map("- " + .) | join("\n"))\n"'
```

