# Websets

Core CRUD operations for managing webset collections.

## Commands

### webset-create

Create a new webset from search criteria or an import.

#### Syntax

```bash
exa-ai webset-create (--search JSON | --import ID) [OPTIONS]
```

#### Examples

##### From Search (Most Common)

```bash
# Always start with count:1 to validate search quality before requesting more
exa-ai webset-create \
  --search '{"query":"AI startups in San Francisco","count":1}' \
  --wait
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

_Note: For adding enrichments, follow the three-step validation workflow (Validate → Expand → Enrich) documented in SKILL.md. Never add enrichments during initial validation._

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

#### Examples

```bash
# Delete webset
exa-ai webset-delete ws_abc123

# Delete with confirmation
exa-ai webset-delete ws_abc123 --output-format json
```

## Example Workflow: Create and Manage Webset

_For the complete three-step validation workflow (Validate → Expand → Enrich), see SKILL.md._

```bash
# Create webset with minimal count
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups Series A","count":1}' \
  --metadata '{"project":"market-research"}' \
  --wait | jq -r '.webset_id')

# Update metadata
exa-ai webset-update $webset_id \
  --metadata '{"project":"market-research","status":"active"}'

# List all websets
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

_Note: See main SKILL.md for credit costs, pricing, and best practices._

## Cloning and Templating

_Follow the three-step workflow (Validate → Expand → Enrich) from SKILL.md when creating templates._

```bash
# Create and configure a template webset
template_id=$(exa-ai webset-create \
  --search '{"query":"tech companies","count":1}' \
  --wait | jq -r '.webset_id')

# Clone the template for a new use case
new_webset_id=$(exa-ai webset-create --import $template_id --wait | jq -r '.webset_id')

# Update the clone with a new search
exa-ai webset-search-create $new_webset_id \
  --query "AI startups 2024" \
  --mode override \
  --count 1 \
  --wait
```

