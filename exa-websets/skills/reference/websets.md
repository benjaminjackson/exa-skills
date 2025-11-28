# Websets

Core CRUD operations for managing webset collections.

## Commands

### webset-create

Create a new webset from search criteria or an import.

#### Syntax

```bash
exa-ai webset-create (--search JSON | --import ID) [OPTIONS]
```

#### Required (choose one)

- `--search JSON`: Search configuration (supports @file.json)
- `--import ID`: Import or webset ID to create webset from

#### Common Options

- `--enrichments JSON`: Array of enrichment configs (supports @file.json)
- `--exclude JSON`: Array of exclude configs (supports @file.json)
- `--external-id ID`: External identifier for the webset
- `--metadata JSON`: Custom metadata (supports @file.json)
- `--wait`: Wait for webset to reach idle status
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

##### From Search (Most Common)

```bash
exa-ai webset-create \
  --search '{"query":"AI startups in San Francisco","count":50}' \
  --wait
```

##### From Search with File

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

##### From Import

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

##### From Existing Webset

```bash
# Clone an existing webset
exa-ai webset-create --import webset_xyz789 --wait
```

##### With Enrichments

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

##### With Metadata

```bash
exa-ai webset-create \
  --search '{"query":"competitors","count":25}' \
  --metadata '{"project":"market-research","created_by":"team"}' \
  --wait
```

##### Save Webset ID

```bash
webset_id=$(exa-ai webset-create \
  --search '{"query":"B2B SaaS companies","count":100}' \
  --wait | jq -r '.webset_id')

echo "Created webset: $webset_id"
```

#### Search Configuration

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

### webset-get

Get details about a specific webset.

#### Syntax

```bash
exa-ai webset-get WEBSET_ID [OPTIONS]
```

#### Required

- `WEBSET_ID`: Webset ID

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# Get webset details
exa-ai webset-get ws_abc123

# Get in JSON format
exa-ai webset-get ws_abc123 --output-format json
```

### webset-list

List all websets in your account.

#### Syntax

```bash
exa-ai webset-list [OPTIONS]
```

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# List all websets
exa-ai webset-list

# List in JSON format
exa-ai webset-list --output-format json

# Save first webset ID
webset_id=$(exa-ai webset-list --output-format json | jq -r '.websets[0].id')
```

### webset-update

Update webset configuration.

#### Syntax

```bash
exa-ai webset-update WEBSET_ID [OPTIONS]
```

#### Required

- `WEBSET_ID`: Webset ID

#### Options

- `--metadata JSON`: Update custom metadata
- `--external-id ID`: Update external identifier
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# Update metadata
exa-ai webset-update ws_abc123 \
  --metadata '{"status":"active","owner":"research-team"}'

# Update external ID
exa-ai webset-update ws_abc123 --external-id "project-2024-q1"
```

### webset-delete

Delete a webset permanently.

#### Syntax

```bash
exa-ai webset-delete WEBSET_ID [OPTIONS]
```

#### Required

- `WEBSET_ID`: Webset ID

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# Delete webset
exa-ai webset-delete ws_abc123

# Delete with confirmation
exa-ai webset-delete ws_abc123 --output-format json
```

## Complete Workflow: Create and Manage Webset

```bash
# 1. Create webset from search
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups Series A","count":100}' \
  --metadata '{"project":"market-research"}' \
  --wait | jq -r '.webset_id')

echo "Created webset: $webset_id"

# 2. Get webset details
exa-ai webset-get $webset_id

# 3. Add enrichments
exa-ai enrichment-create $webset_id \
  --description "Company website" --format url --title "Website" --wait

exa-ai enrichment-create $webset_id \
  --description "Employee count" --format text --title "Team Size" --wait

# 4. View items
exa-ai webset-item-list $webset_id

# 5. Update metadata
exa-ai webset-update $webset_id \
  --metadata '{"project":"market-research","status":"completed"}'

# 6. List all websets to verify
exa-ai webset-list
```

## Entity Types

When creating websets, you can specify entity types for better results:

- `company`: Companies and organizations
- `person`: Individual people
- `article`: News articles and blog posts
- `research_paper`: Academic papers
- `custom`: Custom entity types (define with --entity-description)

Example:
```bash
exa-ai webset-create \
  --search '{"query":"ML researchers","count":50,"category":"person"}' \
  --wait
```

## Best Practices

1. **Use --wait when creating**: Wait for websets to reach idle status before enriching
2. **Choose appropriate entity types**: Use specific types (company, person, etc.) for better results
3. **Add metadata for organization**: Track project, owner, status, etc.
4. **Save webset IDs**: Use `jq` to extract and save IDs for subsequent commands
5. **Clone websets for experimentation**: Use `--import webset_id` to duplicate existing websets
6. **Use external IDs for integration**: Link websets to your external systems

## Cloning and Templating

```bash
# Create a template webset
template_id=$(exa-ai webset-create \
  --search '{"query":"tech companies","count":10}' \
  --enrichments '[
    {"description":"Company website","format":"url"},
    {"description":"Employee count","format":"text"}
  ]' \
  --wait | jq -r '.webset_id')

# Clone it for a new project
new_webset_id=$(exa-ai webset-create --import $template_id --wait | jq -r '.webset_id')

# Update with new search
exa-ai webset-search-create $new_webset_id \
  --query "AI startups 2024" \
  --mode override \
  --count 100 \
  --wait
```

## Complete Options

For all available options for each command, run:

```bash
exa-ai webset-create --help
exa-ai webset-get --help
exa-ai webset-list --help
exa-ai webset-update --help
exa-ai webset-delete --help
```
