---
name: exa-websets:enrichments
description: Add structured data fields to webset items. Use when extracting specific information like URLs, text fields, or categorical data from webset items using AI.
---

# Exa Websets Enrichments

Add structured data fields to all items in a webset using AI extraction.

## Critical Requirements

**MUST follow these rules when using enrichments:**

1. **Only enrich after validation**: Never add enrichments during initial search validation (count:1). Validate search quality first, expand count second, add enrichments last.
2. **Use descriptive descriptions and titles**: Clear descriptions help AI extract exactly what you need. Titles become column headers.
3. **Choose appropriate formats**: Use `url` for links, `options` for categorical data, `text` for free-form data
4. **Limit options to 10 or fewer**: Too many options reduce accuracy for categorical enrichments
5. **Use --wait for visibility**: Enrichments can take time to process, especially for large websets

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

## Quick Start

### Create Text Enrichment

```bash
# Extract free-form text field
exa-ai enrichment-create ws_abc123 \
  --description "Number of employees as of latest data" \
  --format text \
  --title "Team Size" \
  --wait
```

### Create URL Enrichment

```bash
# Extract website URLs
exa-ai enrichment-create ws_abc123 \
  --description "Primary company website URL" \
  --format url \
  --title "Website" \
  --wait
```

### Create Options Enrichment (Categorical)

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

### Use Options from File

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

### Add Instructions for Precision

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

## Complete Workflow

### End-to-End: Create Webset → Add Enrichments

```bash
# Step 1: VALIDATE - Create webset with count:1 (NO enrichments)
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups in San Francisco","count":1}' \
  --wait | jq -r '.webset_id')

# Review result quality
exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Verify the result is relevant before continuing. If not, adjust query and start over.**

```bash
# Step 2: EXPAND - Gradually increase count
exa-ai webset-search-create $webset_id \
  --query "AI startups in San Francisco" \
  --mode append \
  --count 2 \
  --wait

# Review quality at this scale
exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Check quality. If good, repeat with larger counts (5, 10, 25, 50) until you reach target size.**

```bash
# Step 3: ENRICH - Add enrichments only after validation
exa-ai enrichment-create $webset_id \
  --description "Company website URL" \
  --format url \
  --title "Website" \
  --wait

exa-ai enrichment-create $webset_id \
  --description "Number of employees" \
  --format text \
  --title "Team Size" \
  --wait

exa-ai enrichment-create $webset_id \
  --description "Funding stage" \
  --format options \
  --options '[{"label":"Seed"},{"label":"Series A"},{"label":"Series B+"}]' \
  --title "Stage" \
  --wait

# View enriched results
exa-ai webset-item-list $webset_id
```

## Credit Costs

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

## Best Practices

1. **Enrich after validation and expansion**: Follow the three-step workflow: Validate → Expand → Enrich. Never enrich during validation.
2. **Use descriptive, specific descriptions**: "Company website URL" is better than "website". Helps AI extract accurately.
3. **Choose appropriate formats**: url for links, options for categories, text for everything else
4. **Add instructions when needed**: Provide additional context to guide extraction for complex fields
5. **Limit options to 10 or fewer**: More options reduce accuracy. Group into broader categories if needed.
6. **Use --wait for visibility**: See enrichment progress and catch errors early
7. **Start with essential enrichments**: Add the most important fields first, then iterate
8. **Review enriched results**: Check a sample to ensure AI is extracting correctly before relying on data

## Detailed Reference

For complete command reference, syntax, and all options, consult [REFERENCE.md](REFERENCE.md).
