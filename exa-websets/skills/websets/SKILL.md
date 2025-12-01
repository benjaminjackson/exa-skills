---
name: exa-websets:websets
description: Manage webset collections with CRUD operations. Use when creating, retrieving, updating, or deleting websets - curated collections of web entities (companies, people, articles, research papers).
---

# Exa Websets

Core operations for managing webset collections.

## Critical Requirements

**MUST follow these rules when using websets:**

1. **Start with minimal counts (1-5 results)**: Initial webset searches are test spikes to validate results. ALWAYS default to count:1 unless user explicitly requests more. Only increase count after confirming the search returns useful results, not false positives.
2. **No enrichments during validation**: Never add enrichments when testing with count:1. Validate search quality first, expand count second, add enrichments last. Each enrichment costs 2-5 credits per item, so enriching test results wastes credits.
3. **Use --wait for quick searches, avoid for long ones**: Use --wait for small searches (count ≤ 5) since they complete quickly. Avoid --wait for large searches to prevent blocking.
4. **Choose appropriate entity types**: Use specific types (company, person, etc.) for better results
5. **Save webset IDs**: Use `jq` to extract and save IDs for subsequent commands

## Quick Start

### Create Webset from Search

```bash
# Start with count:1 to validate search quality before requesting more results
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups in San Francisco","count":1}' \
  --wait | jq -r '.webset_id')
```

### Create with Detailed Search Criteria

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

### Create from CSV Import

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

### Add Enrichments After Validation

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

### List and Manage Websets

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

## Entity Types

- `company`: Companies and organizations
- `person`: Individual people
- `article`: News articles and blog posts
- `research_paper`: Academic papers
- `custom`: Custom entity types (define with --entity-description)

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

## Detailed Reference

For complete options, examples, and workflows, consult [REFERENCE.md](REFERENCE.md).
