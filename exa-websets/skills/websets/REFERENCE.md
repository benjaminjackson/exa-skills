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
# Always start with count:1 to validate search quality before requesting more
exa-ai webset-create \
  --search '{"query":"AI startups in San Francisco","count":1}' \
  --wait
```

##### From Search with File

```bash
# Start with minimal count for validation
cat > search.json <<'EOF'
{
  "query": "SaaS companies Series A funding",
  "count": 1,
  "category": "company"
}
EOF

exa-ai webset-create --search @search.json --wait
```

##### With Detailed Criteria

```bash
# Test detailed criteria with minimal count first
cat > search.json <<'EOF'
{
  "query": "Technology companies focused on developer tools",
  "count": 1,
  "entity": {
    "type": "company"
  },
  "criteria": [
    {
      "description": "Companies with 50-500 employees indicating growth stage"
    },
    {
      "description": "Primary product is developer tools, APIs, or infrastructure"
    }
  ]
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

##### With Enrichments (Not Recommended During Validation)

**DISCOURAGED:** Adding enrichments during initial validation wastes credits if the search returns bad results. Use the three-step workflow below instead.

**Step 1: VALIDATE - Create with count:1 (NO enrichments)**

```bash
webset_id=$(exa-ai webset-create \
  --search '{"query":"tech startups","count":1}' \
  --wait | jq -r '.webset_id')

# Review the result
exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Manually verify the result is relevant before continuing. If not, adjust the query and start over. DO NOT proceed to Step 2 without verification.**

---

**Step 2: EXPAND - Increase count only after validation**

```bash
# Use the webset_id from Step 1
exa-ai webset-search-create $webset_id \
  --query "tech startups" \
  --mode override \
  --count 100 \
  --wait

# Review the expanded results
exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Check for false positives at scale before continuing. DO NOT proceed to Step 3 without verification.**

---

**Step 3: ENRICH - Add enrichments only after confirming quality**

```bash
# Use the webset_id from Steps 1-2
exa-ai enrichment-create $webset_id \
  --description "Company website" --format url --title "Website" --wait
exa-ai enrichment-create $webset_id \
  --description "Employee count" --format text --title "Team Size" --wait
```

##### With Metadata

```bash
# Add metadata while keeping count minimal for initial validation
exa-ai webset-create \
  --search '{"query":"competitors","count":1}' \
  --metadata '{"project":"market-research","created_by":"team"}' \
  --wait
```

##### Save Webset ID

```bash
# Validate search with count:1, then scale up if results are good
webset_id=$(exa-ai webset-create \
  --search '{"query":"B2B SaaS companies","count":1}' \
  --wait | jq -r '.webset_id')

echo "Created webset: $webset_id"
```

#### Search Configuration

The `--search` JSON supports these fields:
- `query` (required): Search query string
- `count`: Number of results to find
- `category`: Entity category (company, person, research_paper, etc.)
- `entity`: Object specifying entity type (alternative to `category`)
  - `type`: Entity type (company, person, article, research_paper, custom)
- `criteria`: Array of detailed search criteria objects
  - `description`: Specific requirement or filter to apply

##### Basic Search

```json
{
  "query": "AI safety research papers 2024",
  "count": 1,
  "category": "research paper"
}
```

##### Advanced Search with Criteria

Use the `criteria` array to specify detailed requirements for more precise results:

```json
{
  "query": "Technology companies focused on developer tools",
  "count": 1,
  "entity": {
    "type": "company"
  },
  "criteria": [
    {
      "description": "Companies with 50-500 employees indicating growth stage"
    },
    {
      "description": "Primary product is developer tools, APIs, or infrastructure"
    }
  ]
}
```

Each criterion provides additional context that helps refine search results. Use criteria to specify:
- Size or scale requirements (budget, employees, reach)
- Core focus areas or mission alignment
- Organizational characteristics (structure, programs, presence)
- Geographic or temporal constraints

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

**Step 1: VALIDATE - Create with count:1 to test search quality**

```bash
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups Series A","count":1}' \
  --metadata '{"project":"market-research"}' \
  --wait | jq -r '.webset_id')

echo "Created webset: $webset_id"

# Review the result
exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Manually verify the result is relevant before continuing. If not, adjust the query and start over. DO NOT proceed to Step 2 without verification.**

---

**Step 2: EXPAND - Increase count only after validation**

```bash
# Use the webset_id from Step 1
exa-ai webset-search-create $webset_id \
  --query "AI startups Series A" \
  --mode override \
  --count 100 \
  --wait

# Review the expanded results
exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Check for false positives at scale before continuing. DO NOT proceed to Step 3 without verification.**

---

**Step 3: ENRICH - Add enrichments only after confirming quality**

```bash
# Use the webset_id from Steps 1-2
exa-ai enrichment-create $webset_id \
  --description "Company website" --format url --title "Website" --wait

exa-ai enrichment-create $webset_id \
  --description "Employee count" --format text --title "Team Size" --wait

# View enriched items
exa-ai webset-item-list $webset_id
```

---

**Step 4: Update metadata and finalize**

```bash
# Update metadata
exa-ai webset-update $webset_id \
  --metadata '{"project":"market-research","status":"completed"}'

# List all websets to verify
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
# Start with count:1 to validate entity type results
exa-ai webset-create \
  --search '{"query":"ML researchers","count":1,"category":"person"}' \
  --wait
```

## Credit Costs

Understanding credit usage helps manage costs effectively:

**Pricing**: $50/month = 8,000 credits ($0.00625 per credit)

**Cost per operation**:
- Each webset item: 10 credits ($0.0625)
- Standard enrichment: 2 credits ($0.0125)
- Email enrichment: 5 credits ($0.03125)

**Example cost calculation**:
- 100 items = 1,000 credits ($6.25)
- 100 items + 2 enrichments each = 1,400 credits ($8.75)
- 100 items + email enrichment = 1,500 credits ($9.38)

**Why start with count:1**: Testing with 1 result costs just 10 credits ($0.0625). A failed search with count:100 wastes 1,000 credits ($6.25) - 100x more expensive.

**Why no enrichments during validation**: Adding 2 enrichments to 1 test item costs 14 credits total. If the search returns bad results, you've wasted the enrichment credits (4 credits). For 100 items with 2 enrichments, bad results waste 1,400 credits ($8.75). Always validate first, expand second, enrich last.

## Best Practices

1. **Start small, validate, then scale**: Always use count:1 for initial searches to verify quality. Only increase count after confirming results are useful and not false positives.
2. **Three-step workflow - Validate, Expand, Enrich**: (1) Create with count:1 to test search quality, (2) Expand search count if results are good, (3) Add enrichments only after you have validated, expanded results. Never enrich during validation.
3. **Use --wait strategically**: Use --wait for small searches (count ≤ 5) to get immediate results. Avoid --wait for large searches to prevent blocking.
4. **Choose appropriate entity types**: Use specific types (company, person, etc.) for better results
5. **Add metadata for organization**: Track project, owner, status, etc.
6. **Save webset IDs**: Use `jq` to extract and save IDs for subsequent commands
7. **Clone websets for experimentation**: Use `--import webset_id` to duplicate existing websets
8. **Use external IDs for integration**: Link websets to your external systems

## Cloning and Templating

**Creating a Template - Step 1: VALIDATE**

```bash
template_id=$(exa-ai webset-create \
  --search '{"query":"tech companies","count":1}' \
  --wait | jq -r '.webset_id')

# Review the template result
exa-ai webset-item-list $template_id
```

**⚠️ REQUIRED: Verify the result before continuing. DO NOT proceed without verification.**

---

**Creating a Template - Step 2: EXPAND**

```bash
# Use the template_id from Step 1
exa-ai webset-search-create $template_id \
  --query "tech companies" \
  --mode override \
  --count 100 \
  --wait

# Review expanded results
exa-ai webset-item-list $template_id
```

**⚠️ REQUIRED: Check for false positives before continuing. DO NOT proceed without verification.**

---

**Creating a Template - Step 3: ENRICH**

```bash
# Use the template_id from Steps 1-2
exa-ai enrichment-create $template_id \
  --description "Company website" --format url --title "Website" --wait
exa-ai enrichment-create $template_id \
  --description "Employee count" --format text --title "Team Size" --wait
```

---

**Using the Template - Step 1: Clone and VALIDATE new search**

```bash
# Clone the validated template
new_webset_id=$(exa-ai webset-create --import $template_id --wait | jq -r '.webset_id')

# Update with new search - validate with count:1 first
exa-ai webset-search-create $new_webset_id \
  --query "AI startups 2024" \
  --mode override \
  --count 1 \
  --wait

# Review new search results
exa-ai webset-item-list $new_webset_id
```

**⚠️ REQUIRED: Verify the new search results before expanding. DO NOT proceed without verification.**

---

**Using the Template - Step 2: EXPAND if validated**

```bash
# Use the new_webset_id from previous step
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
