---
name: search
description: Use for creating websets, running searches, importing CSV data, managing items, and adding enrichments to extract structured data.
---

# Exa Websets Search

Comprehensive webset management including creation, search, imports, items, and enrichments.

## Critical Requirements

**Universal rules across all operations:**

1. **Start with minimal counts (1-5 results)**: Initial searches are test spikes to validate quality. ALWAYS default to count:1 unless user explicitly requests more.
2. **Three-step workflow - Validate, Expand, Enrich**: (1) Create with count:1 to test search quality, (2) Expand search count if results are good, (3) Add enrichments only after validated, expanded results.
3. **No enrichments during validation**: Never add enrichments when testing with count:1. Validate search quality first, expand count second, add enrichments last.
4. **Use --wait strategically**: Use --wait for small searches (count ≤ 5). Avoid --wait for large searches.
5. **Maintain query consistency**: When scaling up searches, use the exact same query and criteria that you validated.

## Credit Costs

**Pricing**: $50/month = 8,000 credits ($0.00625 per credit)

**Cost per operation**:
- Each webset item: 10 credits ($0.0625)
- Standard enrichment: 2 credits ($0.0125)
- Email enrichment: 5 credits ($0.03125)

**Why start with count:1**: Testing with 1 result costs 10 credits ($0.0625). A failed search with count:100 wastes 1,000 credits ($6.25) - 100x more expensive.

**Why enrich last**: Enriching bad results wastes credits. Always validate first, expand second, enrich last.

## Quick Command Reference

`exa-ai --help`

## Output Formats

All exa-ai webset commands support output formats:
- **JSON (default)**: Pipe to `jq` to extract specific fields (e.g., `| jq -r '.webset_id'`)
- **toon**: Compact, readable format for direct viewing
- **pretty**: Human-friendly formatted output
- **text**: Plain text output

# Webset Management

Core operations for managing webset collections.

## Entity Types

- `company`: Companies and organizations
- `person`: Individual people
- `article`: News articles and blog posts
- `research_paper`: Academic papers
- `custom`: Custom entity types (define with --entity-description)

## Create Webset from Search

```bash
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups in San Francisco","count":1}' \
  --wait | jq -r '.webset_id')
```

## Create with Detailed Search Criteria

```bash
exa-ai webset-create \
  --search '{
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
  }' \
  --wait
```

## Create with Custom Entity

```bash
exa-ai webset-create \
  --search '{
    "query": "Nonprofits focused on economic justice",
    "count": 1,
    "entity": {
      "type": "custom",
      "description": "nonprofit"
    },
    "criteria": [
      {
        "description": "Primary focus on economic justice"
      },
      {
        "description": "Annual operating budget between $1M and $10M"
      }
    ]
  }' \
  --wait
```

## Create from CSV Import

```bash
import_id=$(exa-ai import-create companies.csv \
  --count 100 \
  --title "Companies" \
  --format csv \
  --entity-type company | jq -r '.import_id')

exa-ai webset-create --import $import_id --wait
```

## Three-Step Workflow: Validate → Expand → Enrich

### Step 1: VALIDATE - Create with count:1 (NO enrichments)

```bash
webset_id=$(exa-ai webset-create \
  --search '{"query":"tech startups","count":1}' \
  --wait | jq -r '.webset_id')

exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Manually verify the result is relevant before continuing. If not, adjust the query and start over.**

---

### Step 2: EXPAND - Gradually increase count with verification at each stage

```bash
# Expand to 2 results
exa-ai webset-search-create $webset_id \
  --query "tech startups" \
  --mode override \
  --count 2 \
  --wait

exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Check quality at this scale. Repeat with larger counts (5, 10, 25, 50, 100) until you reach your target.**

**Loop this step:** Keep expanding gradually (2 → 5 → 10 → 25 → 50 → 100) with verification between each expansion.

---

### Step 3: ENRICH - Add enrichments only after confirming quality

```bash
exa-ai enrichment-create $webset_id \
  --description "Company website" --format url --title "Website" --wait

exa-ai enrichment-create $webset_id \
  --description "Employee count" --format text --title "Team Size" --wait
```

## Manage Websets

```bash
exa-ai webset-list
exa-ai webset-get ws_abc123
exa-ai webset-update ws_abc123 --metadata '{"status":"active","owner":"team"}'
exa-ai webset-delete ws_abc123
```

---

# Search Operations

Run searches within a webset to add new items.

## Search Modes

- **append**: Add new items to existing collection (default)
- **override**: Replace entire collection with search results

## Query Consistency

When scaling up searches, use the exact same query:

```bash
# Test search
exa-ai webset-search-create ws_abc123 \
  --query "AI startups SF founded:2024" \
  --count 1 \
  --wait

# Scale up with IDENTICAL query
exa-ai webset-search-create ws_abc123 \
  --query "AI startups SF founded:2024" \
  --mode append \
  --count 5
```

## Basic Search Operations

```bash
# Basic search
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco" \
  --count 1 \
  --wait

# Append to collection
exa-ai webset-search-create ws_abc123 \
  --query "SaaS companies Series B" \
  --mode append \
  --count 1

# Override collection
exa-ai webset-search-create ws_abc123 \
  --query "top tech companies" \
  --mode override \
  --count 1 \
  --wait
```

## Monitor Search Progress

```bash
search_id=$(exa-ai webset-search-create ws_abc123 \
  --query "fintech startups" \
  --count 1 | jq -r '.search_id')

exa-ai webset-search-get $search_id
exa-ai webset-search-cancel $search_id
```

---

# CSV Imports

Upload CSV files to create websets from existing datasets.

## CSV Format Requirements

1. First row contains column headers
2. Each row represents one entity
3. Include at minimum a name or identifier column

## Basic Import Workflow

```bash
# Create import
import_id=$(exa-ai import-create companies.csv \
  --count 100 \
  --title "Tech Companies" \
  --format csv \
  --entity-type company | jq -r '.import_id')

# Create webset from import
webset_id=$(exa-ai webset-create --import $import_id --wait | jq -r '.webset_id')
```

## Custom Entity Type

```bash
exa-ai import-create products.csv \
  --count 5 \
  --title "Product List" \
  --format csv \
  --entity-type custom \
  --entity-description "Consumer electronics products"
```

## Manage Imports

```bash
exa-ai import-list
exa-ai import-get imp_abc123
```

---

# Item Management

Manage individual items in websets.

## Basic Operations

```bash
# List items
exa-ai webset-item-list ws_abc123
exa-ai webset-item-list ws_abc123 --output-format pretty

# Get item details
exa-ai webset-item-get item_xyz789

# Delete item
exa-ai webset-item-delete item_xyz789
```

## Extract Item Data

```bash
# Get all item IDs
exa-ai webset-item-list ws_abc123 --output-format json | jq -r '.items[].id'

# Count items
exa-ai webset-item-list ws_abc123 --output-format json | jq '.items | length'
```

---

# Enrichments

Add structured data fields to all items in a webset using AI extraction.

## Enrichment Formats

- **text**: Free-form text extraction (employee count, description, technology stack)
- **url**: Extract URLs only (website, LinkedIn, GitHub)
- **options**: Categorical data with predefined options (industry, funding stage, size range)

## Create Enrichments

```bash
# Text enrichment
exa-ai enrichment-create ws_abc123 \
  --description "Number of employees as of latest data" \
  --format text \
  --title "Team Size" \
  --wait

# URL enrichment
exa-ai enrichment-create ws_abc123 \
  --description "Primary company website URL" \
  --format url \
  --title "Website" \
  --wait

# Options enrichment
exa-ai enrichment-create ws_abc123 \
  --description "Current funding stage" \
  --format options \
  --options '[
    {"label":"Pre-seed"},
    {"label":"Seed"},
    {"label":"Series A"},
    {"label":"Series B"},
    {"label":"Series C+"},
    {"label":"Public"}
  ]' \
  --title "Funding Stage" \
  --wait
```

## Use Options from File

```bash
cat > industries.json <<'EOF'
[
  {"label": "SaaS"},
  {"label": "Developer Tools"},
  {"label": "AI/ML"},
  {"label": "Fintech"},
  {"label": "Healthcare"},
  {"label": "Other"}
]
EOF

exa-ai enrichment-create ws_abc123 \
  --description "Primary industry or sector" \
  --format options \
  --options @industries.json \
  --title "Industry" \
  --wait
```

## Add Instructions for Precision

```bash
exa-ai enrichment-create ws_abc123 \
  --description "Technology stack" \
  --format text \
  --instructions "Focus only on backend technologies and databases. Ignore frontend frameworks." \
  --title "Backend Tech" \
  --wait
```

## Manage Enrichments

```bash
# List enrichments
exa-ai enrichment-list ws_abc123
exa-ai enrichment-list ws_abc123 --output-format pretty

# Get details
exa-ai enrichment-get ws_abc123 enr_xyz789

# Update
exa-ai enrichment-update ws_abc123 enr_xyz789 --title "Company Size"
exa-ai enrichment-update ws_abc123 enr_xyz789 \
  --description "Exact employee count from most recent source"

# Delete
exa-ai enrichment-delete ws_abc123 enr_xyz789

# Cancel running enrichment
exa-ai enrichment-cancel ws_abc123 enr_xyz789
```

## Common Enrichment Patterns

**Company websets**: Website (url), Team Size (text), Funding Stage (options), Industry (options)

**Person websets**: LinkedIn (url), Job Title (text), Company (text), Location (text)

**Research papers**: Publication Year (text), Authors (text), Venue (text), Research Area (options)

---

# Best Practices

1. **Start small, validate, then scale**: Always use count:1 for initial searches
2. **Follow three-step workflow**: Validate → Expand → Enrich
3. **Never enrich during validation**: Only enrich after validated, expanded results
4. **Use --wait strategically**: Use for small searches (count ≤ 5), avoid for large searches
5. **Maintain query consistency**: Use exact same query when scaling up
6. **Choose specific entity types**: Use company, person, etc. for better results
7. **Save IDs**: Use `jq` to extract and save IDs for subsequent commands

---

# Detailed Reference

For complete command references, syntax, and all options, consult [REFERENCE.md](REFERENCE.md) and component-specific reference files.
