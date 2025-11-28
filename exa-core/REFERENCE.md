# Exa Core Commands Reference

Complete reference for all exa-ai core search commands.

## Shared Patterns

### Schema Object Wrapper Requirement

**CRITICAL**: When using `--output-schema` or `--summary-schema`, ALWAYS wrap properties in an object:

```json
{
  "type": "object",
  "properties": {
    "field_name": {"type": "string"},
    "another_field": {"type": "number"}
  }
}
```

**Wrong (will fail)**:
```json
{
  "properties": {
    "field_name": {"type": "string"}
  }
}
```

### Token Optimization (toon Format)

The `--output-format toon` option provides a YAML-like format that uses approximately 40% fewer tokens than JSON.

**Note**: `toon` format is not listed in `--help` output, but is fully supported and recommended for token efficiency.

```bash
# Standard formats (documented in --help)
--output-format json    # Default JSON format
--output-format pretty  # Pretty-printed JSON
--output-format text    # Plain text

# Undocumented but supported
--output-format toon    # YAML-like format, 40% fewer tokens
```

### jq Integration Techniques

Extract only what you need to minimize token usage:

```bash
# Extract single field
command | jq -r '.results[].field_name'

# Extract multiple fields
command | jq -r '.results[] | "\(.field1): \(.field2)"'

# Parse JSON from summary
command | jq -r '.results[].summary | fromjson | .field'

# Format as list
command | jq -r '.results[] | "- \(.title)"'
```

### Output Formatting Best Practices

1. Always use `--output-format toon` for minimal tokens
2. Pipe to `jq` to extract specific fields
3. Use `--summary` instead of `--text` when possible
4. Limit results with `--num-results` to only what you need
5. Use schemas to get structured data directly

---

## search

Search the web using Exa AI.

### Syntax

```bash
exa-ai search QUERY [OPTIONS]
```

### Arguments

- `QUERY` (required): Search query

### Options

#### Results Control
- `--num-results N`: Number of results to return (default: 10)
- `--type TYPE`: Search type: `fast`, `deep`, `keyword`, or `auto` (default: `fast`)

#### Filtering
- `--category CAT`: Focus on specific data category
  - Options: `company`, `research paper`, `news`, `pdf`, `github`, `tweet`, `personal site`, `linkedin profile`, `financial report`
- `--include-domains D`: Comma-separated list of domains to include
- `--exclude-domains D`: Comma-separated list of domains to exclude
- `--start-published-date DATE`: Filter by published date (ISO 8601 format)
- `--end-published-date DATE`: Filter by published date (ISO 8601 format)
- `--start-crawl-date DATE`: Filter by crawl date (ISO 8601 format)
- `--end-crawl-date DATE`: Filter by crawl date (ISO 8601 format)
- `--include-text PHRASE`: Include results with exact phrase (repeatable)
- `--exclude-text PHRASE`: Exclude results with exact phrase (repeatable)

#### Content Extraction
- `--text`: Include full webpage text
- `--text-max-characters N`: Max characters for webpage text
- `--include-html-tags`: Include HTML tags in text extraction
- `--summary`: Include AI-generated summary
- `--summary-query PROMPT`: Custom prompt for summary generation
- `--summary-schema FILE`: JSON schema for summary structure (@file or inline)
- `--context`: Format results as context for LLM RAG
- `--context-max-characters N`: Max characters for context string
- `--subpages N`: Number of subpages to crawl
- `--subpage-target PHRASE`: Subpage target phrases (repeatable)
- `--links N`: Number of links to extract per result
- `--image-links N`: Number of image links to extract

#### LinkedIn-Specific
- `--linkedin TYPE`: Search LinkedIn: `company`, `person`, or `all`

#### General
- `--api-key KEY`: Exa API key (or set EXA_API_KEY env var)
- `--output-format FMT`: Output format: `json`, `pretty`, `text`, or `toon` (recommended)

### Examples

```bash
# Basic search with toon format
exa-ai search "ruby programming" --output-format toon

# Deep search with limited results
exa-ai search "machine learning" --num-results 5 --type deep

# Category-specific search
exa-ai search "Latest LLM research" --category "research paper"

# LinkedIn search
exa-ai search "Anthropic" --linkedin company
exa-ai search "Dario Amodei" --linkedin person

# Domain filtering
exa-ai search "AI research" --include-domains arxiv.org,scholar.google.com

# Search with summary
exa-ai search "AI safety" --summary --num-results 3 | jq '.results[].summary'

# Search with structured schema
exa-ai search "Claude features" --summary --summary-schema '{"type":"object","properties":{"feature":{"type":"string"}}}' | jq -r '.results[].summary | fromjson'
```

---

## find-similar

Find content similar to a given URL.

### Syntax

```bash
exa-ai find-similar URL [OPTIONS]
```

### Arguments

- `URL` (required): URL to find similar content for

### Options

#### Results Control
- `--num-results N`: Number of results to return (default: 10)
- `--exclude-source-domain`: Exclude results from the source URL's domain

#### Filtering
- `--category CAT`: Focus on specific data category (same options as search)
- `--include-domains D`: Comma-separated list of domains to include
- `--exclude-domains D`: Comma-separated list of domains to exclude
- `--start-published-date DATE`: Filter by published date (ISO 8601 format)
- `--end-published-date DATE`: Filter by published date (ISO 8601 format)
- `--start-crawl-date DATE`: Filter by crawl date (ISO 8601 format)
- `--end-crawl-date DATE`: Filter by crawl date (ISO 8601 format)
- `--include-text PHRASE`: Include results with exact phrase (repeatable)
- `--exclude-text PHRASE`: Exclude results with exact phrase (repeatable)

#### Content Extraction
- `--text`: Include full webpage text
- `--text-max-characters N`: Max characters for webpage text
- `--include-html-tags`: Include HTML tags in text extraction
- `--summary`: Include AI-generated summary
- `--summary-query PROMPT`: Custom prompt for summary generation
- `--summary-schema FILE`: JSON schema for summary structure (@file or inline)

#### General
- `--api-key KEY`: Exa API key (or set EXA_API_KEY env var)
- `--output-format FMT`: Output format: `json`, `pretty`, `text`, or `toon`

### Examples

```bash
# Basic similar search
exa-ai find-similar "https://example.com/article" --output-format toon

# Exclude source domain
exa-ai find-similar "https://example.com" --exclude-source-domain --num-results 5

# Category-specific
exa-ai find-similar "https://arxiv.org/paper" --category "research paper"

# With summary
exa-ai find-similar "https://blog.anthropic.com/article" --summary | jq '.results[] | {title, summary}'
```

---

## answer

Generate an answer to a question using Exa AI.

### Syntax

```bash
exa-ai answer QUERY [OPTIONS]
```

### Arguments

- `QUERY` (required): Question or query to answer

### Options

- `--text`: Include full text content from sources
- `--output-schema JSON`: JSON schema for structured output (use object wrapper!)
- `--system-prompt TEXT`: System prompt to guide answer generation
- `--api-key KEY`: Exa API key (or set EXA_API_KEY env var)
- `--output-format FMT`: Output format: `json`, `pretty`, `text`, or `toon`

### Examples

```bash
# Basic answer
exa-ai answer "What is the capital of France?" --output-format toon

# Streaming answer
exa-ai answer "Latest AI breakthroughs" --stream

# With full text from sources
exa-ai answer "Latest AI breakthroughs" --text

# Structured output with schema
exa-ai answer "What is Anthropic's main product?" --output-schema '{"type":"object","properties":{"product":{"type":"string"},"description":{"type":"string"}}}' | jq -r '.answer | "\(.product): \(.description)"'

# Array output
exa-ai answer "Top 5 programming languages" --output-schema '{"type":"object","properties":{"languages":{"type":"array","items":{"type":"string"}}}}' | jq -r '.answer | .languages | map("- " + .) | join("\n")'

# Custom system prompt
exa-ai answer "What is Paris?" --system-prompt "Respond in the voice of a pirate"
```

---

## context

Get code context from repositories.

### Syntax

```bash
exa-ai context QUERY [OPTIONS]
```

### Arguments

- `QUERY` (required): Search query for code context

### Options

- `--tokens-num NUM`: Number of tokens for response (or `dynamic`, default: `dynamic`)
- `--api-key KEY`: Exa API key (or set EXA_API_KEY env var)
- `--output-format FMT`: Output format: `json`, `pretty`, `text`, or `toon`

### Examples

```bash
# Basic context retrieval
exa-ai context "React hooks" --output-format toon

# Specific token limit
exa-ai context "authentication with JWT in Ruby" --tokens-num 5000

# Text format for direct use
exa-ai context "React hooks" --output-format text

# Extract specific information
exa-ai context "Python async/await" --tokens-num 3000 | jq -r '.context'
```

---

## get-contents

Retrieve full page contents from URLs.

### Syntax

```bash
exa-ai get-contents URLS [OPTIONS]
```

### Arguments

- `URLS` (required): Comma-separated list of URLs

### Options

#### Text Extraction
- `--text`: Include page text in response
- `--text-max-characters N`: Max characters for page text
- `--include-html-tags`: Include HTML tags in text extraction

#### Summary
- `--summary`: Include AI-generated summary
- `--summary-query PROMPT`: Custom prompt for summary generation
- `--summary-schema FILE`: JSON schema for summary structure (@file or inline)

#### Context
- `--context`: Format results as context for LLM RAG
- `--context-max-characters N`: Max characters for context string

#### Subpages
- `--subpages N`: Number of subpages to crawl
- `--subpage-target PHRASE`: Subpage target phrases (repeatable)

#### Extras
- `--links N`: Number of links to extract per result
- `--image-links N`: Number of image links to extract

#### Livecrawl
- `--livecrawl-timeout N`: Timeout for livecrawling in milliseconds

#### General
- `--api-key KEY`: Exa API key (or set EXA_API_KEY env var)
- `--output-format FMT`: Output format: `json`, `pretty`, `text`, or `toon`

### Examples

```bash
# Basic content retrieval
exa-ai get-contents "https://example.com" --output-format toon

# With full text
exa-ai get-contents "https://example.com" --text

# Text with limits and HTML tags
exa-ai get-contents "https://example.com" --text --text-max-characters 3000 --include-html-tags

# With summary
exa-ai get-contents "https://example.com" --summary | jq '.results[].summary'

# Custom summary query
exa-ai get-contents "https://company.com" --summary --summary-query "What products does this company offer?" | jq '.results[].summary'

# Structured extraction with schema
exa-ai get-contents "https://company.com" --summary --summary-schema '{"type":"object","properties":{"company_name":{"type":"string"},"main_product":{"type":"string"}}}' | jq -r '.results[].summary | fromjson | "\(.company_name): \(.main_product)"'

# Multiple URLs
exa-ai get-contents "https://url1.com,https://url2.com" --summary

# With subpages
exa-ai get-contents "https://example.com" --subpages 1 --subpage-target about

# Extract links and images
exa-ai get-contents "https://example.com" --links 5 --image-links 10
```

---

## Token Usage Comparison

**Example: Basic search for "AI news"**

```bash
# Full JSON (baseline): ~1000 tokens
exa-ai search "AI news" --num-results 5

# Toon format: ~600 tokens (40% savings)
exa-ai search "AI news" --num-results 5 --output-format toon

# Toon + jq extraction: ~100 tokens (90% savings)
exa-ai search "AI news" --num-results 5 --output-format toon | jq -r '.results[] | .title'

# With summary + schema: ~200 tokens (80% savings)
exa-ai search "AI news" --summary --summary-schema '{"type":"object","properties":{"headline":{"type":"string"}}}' --num-results 5 | jq -r '.results[].summary | fromjson | .headline'
```

**Recommendation**: Always combine `--output-format toon` with `jq` extraction for maximum token efficiency.

---

For practical examples and workflows, see [EXAMPLES.md](./EXAMPLES.md).
