# Websets

Core CRUD operations for managing webset collections.

## Commands

### webset-create

Create a new webset from search criteria or an import.

#### Syntax

```bash
exa-ai webset-create (--search JSON | --import ID) [OPTIONS]
```

#### ⚠️ NEVER use same import ID in both --import and search.scope (returns 400)

```bash
# ❌ INVALID
exa-ai webset-create --import import_abc \
  --search '{"scope":[{"source":"import","id":"import_abc"}]}'
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

##### Save Webset ID

```bash
# Validate search with count:1, then scale up if results are good
webset_id=$(exa-ai webset-create \
  --search '{"query":"B2B SaaS companies","count":1}' \
  --wait | jq -r '.webset_id')

echo "Created webset: $webset_id"
```

##### Scoped Search Within Import

```bash
# Search within an existing import (not the entire web)
exa-ai webset-create \
  --search '{"query":"C-level executives","count":10,"scope":[{"source":"import","id":"import_abc123"}]}' \
  --wait
```

##### Scoped Search Within Webset

```bash
# Search within another webset
exa-ai webset-create \
  --search '{"query":"board members","count":5,"scope":[{"source":"webset","id":"webset_abc"}]}' \
  --wait
```

##### Hop Search (Relationship Traversal)

```bash
# Find related entities - e.g., investors of companies in a webset
exa-ai webset-create \
  --search '{"query":"investors","count":1,"scope":[{"source":"webset","id":"webset_abc","relationship":{"definition":"investors of","limit":5}}]}' \
  --wait
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
- `scope`: Array of `{source, id, relationship}` to filter search to specific imports/websets

##### Entities

```json
{
  "query": "AI safety research papers 2024",
  "count": 1,
  "entity": {
    "type": "research_paper"
  }
}
```

```json
{
  "query": "economic justice nonprofits in new york",
  "count": 1,
  "entity": {
    "type": "custom",
    "description": "nonprofit"
  }
}
```

##### Advanced Search with Criteria

Use the `criteria` array to specify detailed requirements for more precise results:

```json
{
  "query": "Technology companies with 50-500 employees focused on developer tools",
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