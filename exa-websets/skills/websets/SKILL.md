---
name: exa-websets:websets
description: Manage webset collections with CRUD operations. Use when creating, retrieving, updating, or deleting websets - curated collections of web entities (companies, people, articles, research papers).
---

# Exa Websets

Core operations for managing webset collections.

## Critical Requirements

**MUST follow these rules when using websets:**

1. **Start with minimal counts (1-5 results)**: Initial webset searches are test spikes to validate results. ALWAYS default to count:1 unless user explicitly requests more. Only increase count after confirming the search returns useful results, not false positives.
2. **Use --wait for quick searches, avoid for long ones**: Use --wait for small searches (count ≤ 5) since they complete quickly. Avoid --wait for large searches to prevent blocking.
3. **Choose appropriate entity types**: Use specific types (company, person, etc.) for better results
4. **Save webset IDs**: Use `jq` to extract and save IDs for subsequent commands

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

### Create with Enrichments

```bash
# Start with count:1 to validate search and enrichment quality
exa-ai webset-create \
  --search '{"query":"tech startups","count":1}' \
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

## Best Practices

1. **Start small, validate, then scale**: Always use count:1 for initial searches to verify quality. Only increase count after confirming results are useful and not false positives.
2. **Use --wait strategically**: Use --wait for small searches (count ≤ 5) to get immediate results. Avoid --wait for large searches to prevent blocking.
3. **Choose appropriate entity types**: Use specific types (company, person, etc.) for better results
4. **Add metadata for organization**: Track project, owner, status, etc.
5. **Save webset IDs**: Use `jq` to extract and save IDs for subsequent commands
6. **Clone websets for experimentation**: Use `--import webset_id` to duplicate existing websets

## Detailed Reference

For complete options, examples, and workflows, consult [REFERENCE.md](REFERENCE.md).
