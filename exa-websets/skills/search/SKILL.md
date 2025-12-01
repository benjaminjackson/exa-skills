---
name: exa-websets:search
description: Manage websets through search, imports, and enrichments. Use for creating websets, running searches, importing CSV data, managing items, and adding enrichments to extract structured data.
---

# Exa Websets Search

Comprehensive webset management including creation, search, imports, items, and enrichments.

## When to Use This Skill

Use this skill for any webset operations except monitoring/automation:
- Creating and managing websets (CRUD operations)
- Running searches to add items to websets
- Importing CSV files to create websets
- Managing individual items in websets
- Adding enrichments to extract structured data

For automated scheduled updates, use `exa-websets:monitor` instead.

## Critical Requirements

**Universal rules across all operations:**

1. **Start with minimal counts (1-5 results)**: Initial searches are test spikes to validate quality. ALWAYS default to count:1 unless user explicitly requests more.
2. **Three-step workflow - Validate, Expand, Enrich**: (1) Create with count:1 to test search quality, (2) Expand search count if results are good, (3) Add enrichments only after validated, expanded results.
3. **No enrichments during validation**: Never add enrichments when testing with count:1. Validate search quality first, expand count second, add enrichments last.
4. **Use --wait strategically**: Use --wait for small searches (count ≤ 5). Avoid --wait for large searches.
5. **Maintain query consistency**: When scaling up searches, use the exact same query and criteria that you validated.

## Quick Command Reference

### Webset Commands
```bash
exa-ai webset-create      # Create new webset
exa-ai webset-list        # List all websets
exa-ai webset-get         # Get webset details
exa-ai webset-update      # Update webset metadata
exa-ai webset-delete      # Delete webset
```

### Search Commands
```bash
exa-ai webset-search-create   # Run search in webset
exa-ai webset-search-get      # Get search status
exa-ai webset-search-cancel   # Cancel running search
```

### Import Commands
```bash
exa-ai import-create      # Upload CSV file
exa-ai import-list        # List all imports
exa-ai import-get         # Get import details
```

### Item Commands
```bash
exa-ai webset-item-list   # List items in webset
exa-ai webset-item-get    # Get item details
exa-ai webset-item-delete # Delete item
```

### Enrichment Commands
```bash
exa-ai enrichment-create  # Add enrichment field
exa-ai enrichment-list    # List enrichments
exa-ai enrichment-get     # Get enrichment details
exa-ai enrichment-update  # Update enrichment
exa-ai enrichment-delete  # Delete enrichment
exa-ai enrichment-cancel  # Cancel running enrichment
```

---

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
# Start with count:1 to validate search quality before requesting more results
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups in San Francisco","count":1}' \
  --wait | jq -r '.webset_id')
```

## Create with Detailed Search Criteria

```bash
# Use minimal count to test detailed criteria before scaling up
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
# Use minimal count to test detailed criteria before scaling up
exa-ai webset-create \
  --search '{
    "query": "Nonprofits focused on economic justice with $1M-$10M annual budget",
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
        "description": "Annual operating budget between $1 million and $10 million"
      }
    ]
  }' \
  --wait
```

## Create from CSV Import

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

## Three-Step Workflow: Validate → Expand → Enrich

### Step 1: VALIDATE - Create with count:1 (NO enrichments)

```bash
webset_id=$(exa-ai webset-create \
  --search '{"query":"tech startups","count":1}' \
  --wait | jq -r '.webset_id')

# Review the result
exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Manually verify the result is relevant before continuing. If not, adjust the query and start over. DO NOT proceed to Step 2 without verification.**

---

### Step 2: EXPAND - Gradually increase count with verification at each stage

```bash
# Use the webset_id from Step 1
# Start very small - expand to 2 results first
exa-ai webset-search-create $webset_id \
  --query "tech startups" \
  --mode override \
  --count 2 \
  --wait

# Review the results at this scale
exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Check quality at this scale. If good, repeat this step with larger counts (5, 10, 25, 50, 100) until you reach your target. If you see false positives, stop and refine your query. DO NOT proceed to Step 3 until you're satisfied with quality at your final count.**

**Loop this step:** Keep expanding gradually (2 → 5 → 10 → 25 → 50 → 100) with verification between each expansion until you reach your desired result set size.

---

### Step 3: ENRICH - Add enrichments only after confirming quality

```bash
# Use the webset_id from Steps 1-2
exa-ai enrichment-create $webset_id \
  --description "Company website" --format url --title "Website" --wait

exa-ai enrichment-create $webset_id \
  --description "Employee count" --format text --title "Team Size" --wait
```

## List and Manage Websets

```bash
# List all websets
exa-ai webset-list

# Get webset details
exa-ai webset-get ws_abc123

# Update metadata
exa-ai webset-update ws_abc123 \
  --metadata '{"status":"active","owner":"research-team"}'

# Delete webset
exa-ai webset-delete ws_abc123
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

---

# Search Operations

Run searches within a webset to add new items based on search criteria.

## Search Modes

- **append**: Add new items to existing collection (default)
- **override**: Replace entire collection with search results

## ⚠️ Critical: Query Consistency When Appending

**When appending results after a test search, you MUST use the exact same query and explicit criteria.**

```bash
# ✅ CORRECT: Test with count:1, then append more with SAME query
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco founded:2024" \
  --count 1 \
  --wait

# After validating results are good, append more with IDENTICAL query
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco founded:2024" \
  --mode append \
  --count 50

# ❌ WRONG: Different query when appending
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco founded:2024" \
  --count 1

# DON'T DO THIS - different query will return different results
exa-ai webset-search-create ws_abc123 \
  --query "AI startups San Francisco" \  # Missing founded:2024
  --mode append \
  --count 50
```

**Why this matters:**
- Changing the query or criteria means you're no longer scaling up the same search
- Your test search validated one set of results; changing the query invalidates that validation
- You'll end up with inconsistent items in your webset

## Basic Search

```bash
# Start with count:1 to validate search quality before adding more items
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco" \
  --count 1 \
  --wait
```

## Append to Collection

```bash
# Test query with count:1 before appending more items
exa-ai webset-search-create ws_abc123 \
  --query "SaaS companies Series B" \
  --mode append \
  --count 1
```

## Override Collection

```bash
# Validate query with minimal count before overriding entire collection
exa-ai webset-search-create ws_abc123 \
  --query "top tech companies" \
  --mode override \
  --count 1 \
  --wait
```

## Monitor Search Progress

```bash
# Start search with minimal count to test
search_id=$(exa-ai webset-search-create ws_abc123 \
  --query "fintech startups" \
  --count 1 | jq -r '.search_id')

# Check status
exa-ai webset-search-get $search_id

# If needed, cancel
exa-ai webset-search-cancel $search_id
```

## Search Query Best Practices

### Use Specific Queries

```bash
# Good - specific and targeted, start with count:1
exa-ai webset-search-create ws_abc123 \
  --query "YC W24 batch startups" \
  --count 1

# Less effective - too broad (still use count:1 to test)
exa-ai webset-search-create ws_abc123 \
  --query "startups" \
  --count 1
```

### Time-Based Queries

```bash
# Recent content - validate with count:1 first
exa-ai webset-search-create ws_abc123 \
  --query "AI research papers published:2024" \
  --count 1

# Last month - test before scaling up
exa-ai webset-search-create ws_abc123 \
  --query "tech news published:last-month" \
  --count 1
```

### Category-Specific Queries

```bash
# Companies - start with minimal count
exa-ai webset-search-create ws_abc123 \
  --query "B2B SaaS companies revenue:$10M+" \
  --count 1

# Research papers - validate query quality first
exa-ai webset-search-create ws_abc123 \
  --query "machine learning papers arxiv" \
  --count 1
```

## Scaling Up After Test Search

```bash
# 1. Create webset with minimal count to validate
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups founded:2024","count":1}' \
  --wait | jq -r '.webset_id')

# 2. Validate the result is good, then append more with SAME query
exa-ai webset-search-create $webset_id \
  --query "AI startups founded:2024" \
  --mode append \
  --count 2 \
  --wait

# 3. Check results (should have 3 total)
exa-ai webset-item-list $webset_id
```

## Adding Different Search to Same Webset

```bash
# After completing the first search, you can add a DIFFERENT search
# This is different from scaling up - you're adding a new category of items

# 1. Test the new search with count:1
exa-ai webset-search-create $webset_id \
  --query "biotech startups" \
  --mode append \
  --count 1 \
  --wait

# 2. If results are good, scale up with SAME query
exa-ai webset-search-create $webset_id \
  --query "biotech startups" \
  --mode append \
  --count 2 \
  --wait
```

---

# CSV Imports

Upload external data (CSV files) to create websets from existing datasets.

## CSV Format Requirements

1. **CSV format**: First row should contain column headers, each row represents one entity
2. **Choose appropriate entity types**: Use specific types (company, person, etc.) for better enrichment results
3. **Include key columns**: At minimum, include a name or identifier column

## Basic CSV Import

```bash
# Create import from CSV file
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
  --count 50 \
  --title "Product List" \
  --format csv \
  --entity-type custom \
  --entity-description "Consumer electronics products"
```

## Complete Import Workflow

```bash
# 1. Prepare CSV file
cat > companies.csv <<'EOF'
name,website,industry
Acme Corp,https://acme.com,SaaS
TechStart,https://techstart.io,AI
DataCo,https://dataco.com,Analytics
EOF

# 2. Create import
import_id=$(exa-ai import-create companies.csv \
  --count 3 \
  --title "Portfolio Companies" \
  --format csv \
  --entity-type company | jq -r '.import_id')

# 3. Create webset from import
webset_id=$(exa-ai webset-create --import $import_id --wait | jq -r '.webset_id')

# 4. Add enrichments
exa-ai enrichment-create $webset_id \
  --description "Employee count" \
  --format text \
  --title "Team Size" \
  --wait

# 5. View items
exa-ai webset-item-list $webset_id
```

## Manage Imports

```bash
# List all imports
exa-ai import-list

# Get import details
exa-ai import-get imp_abc123
```

## CSV Format Example

```csv
name,website,location
Acme Corp,https://acme.com,San Francisco
TechStart,https://techstart.io,New York
DataCo,https://dataco.com,Austin
```

---

# Item Management

Manage individual items in websets - list, view, and delete operations.

## List All Items

```bash
# List all items in a webset
exa-ai webset-item-list ws_abc123

# Pretty print for readability
exa-ai webset-item-list ws_abc123 --output-format pretty

# JSON format for scripting
exa-ai webset-item-list ws_abc123 --output-format json
```

## Get Item Details

```bash
# Get specific item details
exa-ai webset-item-get item_xyz789

# Pretty print
exa-ai webset-item-get item_xyz789 --output-format pretty
```

## Delete an Item

```bash
# Delete unwanted item
exa-ai webset-item-delete item_xyz789

# Delete with force (skip confirmation if implemented)
exa-ai webset-item-delete item_xyz789 --force
```

## Review Items After Creation

```bash
# Create webset
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups","count":10}' \
  --wait | jq -r '.webset_id')

# Review all items
exa-ai webset-item-list $webset_id --output-format pretty

# Get first item details
item_id=$(exa-ai webset-item-list $webset_id --output-format json | jq -r '.items[0].id')
exa-ai webset-item-get $item_id
```

## Clean Up Unwanted Items

```bash
# List items to identify unwanted ones
exa-ai webset-item-list ws_abc123 --output-format pretty

# Delete specific items
exa-ai webset-item-delete item_xyz789
exa-ai webset-item-delete item_abc456
```

## Extract Item IDs for Processing

```bash
# Get all item IDs
exa-ai webset-item-list ws_abc123 --output-format json | jq -r '.items[].id'

# Get first 5 item IDs
exa-ai webset-item-list ws_abc123 --output-format json | jq -r '.items[:5] | .[].id'

# Count items
exa-ai webset-item-list ws_abc123 --output-format json | jq '.items | length'
```

---

# Enrichments

Add structured data fields to all items in a webset using AI extraction.

## Enrichment Formats

### text
Free-form text extraction. Use for information that doesn't fit other formats.

**Examples**: Employee count, company description, technology stack, founder names

### url
Extract URLs only. Validates that results are valid URLs.

**Examples**: Company website, LinkedIn profile, GitHub repository, Twitter account

### options
Categorical data with predefined options. AI chooses the best matching option.

**Examples**: Industry categories, funding stages, company size ranges, geographic regions

## Create Text Enrichment

```bash
# Extract free-form text field
exa-ai enrichment-create ws_abc123 \
  --description "Number of employees as of latest data" \
  --format text \
  --title "Team Size" \
  --wait
```

## Create URL Enrichment

```bash
# Extract website URLs
exa-ai enrichment-create ws_abc123 \
  --description "Primary company website URL" \
  --format url \
  --title "Website" \
  --wait
```

## Create Options Enrichment (Categorical)

```bash
# Extract categorical data
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
# Create options file
cat > industries.json <<'EOF'
[
  {"label": "SaaS"},
  {"label": "Developer Tools"},
  {"label": "AI/ML"},
  {"label": "Fintech"},
  {"label": "Healthcare"},
  {"label": "Hardware"},
  {"label": "Other"}
]
EOF

# Create enrichment with file reference
exa-ai enrichment-create ws_abc123 \
  --description "Primary industry or sector" \
  --format options \
  --options @industries.json \
  --title "Industry" \
  --wait
```

## Add Instructions for Precision

```bash
# Provide additional context to guide extraction
exa-ai enrichment-create ws_abc123 \
  --description "Technology stack" \
  --format text \
  --instructions "Focus only on backend technologies and databases. Ignore frontend frameworks." \
  --title "Backend Tech" \
  --wait
```

## Managing Enrichments

### List All Enrichments

```bash
# View all enrichments for a webset
exa-ai enrichment-list ws_abc123

# Pretty print for readability
exa-ai enrichment-list ws_abc123 --output-format pretty
```

### Get Enrichment Details

```bash
# View specific enrichment configuration
exa-ai enrichment-get ws_abc123 enr_xyz789
```

### Update Enrichment

```bash
# Update title
exa-ai enrichment-update ws_abc123 enr_xyz789 --title "Company Size"

# Update description for better extraction
exa-ai enrichment-update ws_abc123 enr_xyz789 \
  --description "Exact employee count from most recent source"

# Update options for categorical enrichment
exa-ai enrichment-update ws_abc123 enr_xyz789 \
  --options '[{"label":"1-10"},{"label":"11-50"},{"label":"51-200"},{"label":"201+"}]'
```

### Delete Enrichment

```bash
# Remove an enrichment from webset
exa-ai enrichment-delete ws_abc123 enr_xyz789

# Skip confirmation
exa-ai enrichment-delete ws_abc123 enr_xyz789 --force
```

### Cancel Running Enrichment

```bash
# Stop enrichment in progress
exa-ai enrichment-cancel ws_abc123 enr_xyz789
```

## Enrichment Credit Costs

Understanding enrichment credit costs helps manage expenses:

**Pricing**: $50/month = 8,000 credits ($0.00625 per credit)

**Cost per enrichment**:
- Standard enrichment (text, url, options): 2 credits ($0.0125)
- Email enrichment: 5 credits ($0.03125)

**Example cost calculations**:
- 100 items + 2 enrichments each = 400 enrichment credits ($2.50)
- 100 items + 5 enrichments each = 1,000 enrichment credits ($6.25)
- 1,000 items + 3 enrichments each = 6,000 enrichment credits ($37.50)

**Why enrich last**: If you add 3 enrichments to a test webset with count:1, then realize the search returns bad results, you've wasted 6 credits on enrichments. For a webset with 100 items, that same mistake wastes 600 credits ($3.75). Always validate search quality and scale up BEFORE enriching.

## Common Enrichment Patterns

### Company Websets

```bash
webset_id="ws_abc123"

# Website
exa-ai enrichment-create $webset_id \
  --description "Company website" --format url --title "Website" --wait

# Team size
exa-ai enrichment-create $webset_id \
  --description "Number of employees" --format text --title "Team Size" --wait

# Funding stage
exa-ai enrichment-create $webset_id \
  --description "Funding stage" --format options \
  --options '[{"label":"Seed"},{"label":"Series A"},{"label":"Series B"},{"label":"Series C+"},{"label":"Public"}]' \
  --title "Stage" --wait

# Industry
exa-ai enrichment-create $webset_id \
  --description "Primary industry" --format options \
  --options '[{"label":"SaaS"},{"label":"AI/ML"},{"label":"Fintech"},{"label":"Healthcare"},{"label":"Other"}]' \
  --title "Industry" --wait
```

### Person Websets

```bash
webset_id="ws_abc123"

# LinkedIn profile
exa-ai enrichment-create $webset_id \
  --description "LinkedIn profile URL" --format url --title "LinkedIn" --wait

# Job title
exa-ai enrichment-create $webset_id \
  --description "Current job title" --format text --title "Title" --wait

# Company
exa-ai enrichment-create $webset_id \
  --description "Current employer company name" --format text --title "Company" --wait

# Location
exa-ai enrichment-create $webset_id \
  --description "Location or city" --format text --title "Location" --wait
```

### Research Paper Websets

```bash
webset_id="ws_abc123"

# Publication year
exa-ai enrichment-create $webset_id \
  --description "Year of publication" --format text --title "Year" --wait

# Authors
exa-ai enrichment-create $webset_id \
  --description "Primary authors or author list" --format text --title "Authors" --wait

# Conference/Journal
exa-ai enrichment-create $webset_id \
  --description "Publication venue (conference or journal name)" --format text --title "Venue" --wait

# Research area
exa-ai enrichment-create $webset_id \
  --description "Research area" --format options \
  --options '[{"label":"NLP"},{"label":"Computer Vision"},{"label":"Robotics"},{"label":"Theory"},{"label":"Other"}]' \
  --title "Area" --wait
```

## Enrichment Best Practices

1. **Enrich after validation and expansion**: Follow the three-step workflow: Validate → Expand → Enrich. Never enrich during validation.
2. **Use descriptive, specific descriptions**: "Company website URL" is better than "website". Helps AI extract accurately.
3. **Choose appropriate formats**: url for links, options for categories, text for everything else
4. **Add instructions when needed**: Provide additional context to guide extraction for complex fields
5. **Limit options to 10 or fewer**: More options reduce accuracy. Group into broader categories if needed.
6. **Use --wait for visibility**: See enrichment progress and catch errors early
7. **Start with essential enrichments**: Add the most important fields first, then iterate
8. **Review enriched results**: Check a sample to ensure AI is extracting correctly before relying on data

---

# Best Practices Summary

1. **Start small, validate, then scale**: Always use count:1 for initial searches to verify quality
2. **Three-step workflow - Validate, Expand, Enrich**: (1) Create with count:1 to test search quality, (2) Expand search count if results are good, (3) Add enrichments only after you have validated, expanded results
3. **No enrichments during validation**: Never enrich when testing with count:1
4. **Use --wait strategically**: Use --wait for small searches (count ≤ 5) to get immediate results. Avoid --wait for large searches to prevent blocking
5. **Maintain query consistency**: Use exact same query when scaling up searches
6. **Choose appropriate entity types**: Use specific types (company, person, etc.) for better results
7. **Add metadata for organization**: Track project, owner, status, etc.
8. **Save IDs**: Use `jq` to extract and save webset/item/enrichment IDs for subsequent commands

---

# Detailed Reference

For complete command references, syntax, and all options, consult [REFERENCE.md](REFERENCE.md) and component-specific reference files.
