# webset-create

Create a new webset from search criteria or an import.

## Syntax

```bash
exa-ai webset-create (--search JSON | --import ID) [OPTIONS]
```

## Required (choose one)

- `--search JSON`: Search configuration (supports @file.json)
- `--import ID`: Import or webset ID to create webset from

## Common Options

- `--enrichments JSON`: Array of enrichment configs (supports @file.json)
- `--exclude JSON`: Array of exclude configs (supports @file.json)
- `--external-id ID`: External identifier for the webset
- `--metadata JSON`: Custom metadata (supports @file.json)
- `--wait`: Wait for webset to reach idle status
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

## Examples

### From Search (Most Common)
```bash
exa-ai webset-create \
  --search '{"query":"AI startups in San Francisco","count":50}' \
  --wait
```

### From Search with File
```bash
cat > search.json <<'EOF'
{
  "query": "SaaS companies Series A funding",
  "count": 100,
  "category": "company"
}
EOF

exa-ai webset-create --search @search.json --wait
```

### From Import
```bash
# First create an import
import_id=$(exa-ai import-create companies.csv \
  --count 100 \
  --title "Companies" \
  --format csv \
  --entity-type company | jq -r '.import_id')

# Create webset from import
exa-ai webset-create --import $import_id --wait
```

### From Existing Webset
```bash
# Clone an existing webset
exa-ai webset-create --import webset_xyz789 --wait
```

### With Enrichments
```bash
exa-ai webset-create \
  --search '{"query":"tech startups","count":50}' \
  --enrichments '[
    {
      "description": "Company website",
      "format": "url"
    },
    {
      "description": "Employee count",
      "format": "text"
    }
  ]' \
  --wait
```

### With Metadata
```bash
exa-ai webset-create \
  --search '{"query":"competitors","count":25}' \
  --metadata '{"project":"market-research","created_by":"team"}' \
  --wait
```

### Save Webset ID
```bash
webset_id=$(exa-ai webset-create \
  --search '{"query":"B2B SaaS companies","count":100}' \
  --wait | jq -r '.webset_id')

echo "Created webset: $webset_id"
```

## Search Configuration

The `--search` JSON supports these fields:
- `query` (required): Search query string
- `count`: Number of results to find
- `category`: Entity category (company, person, research_paper, etc.)

Example:
```json
{
  "query": "AI safety research papers 2024",
  "count": 100,
  "category": "research paper"
}
```

## Complete Options

For all available options, run:
```bash
exa-ai webset-create --help
```
