---
name: exa-websets:websets
description: Manage webset collections with CRUD operations. Use when creating, retrieving, updating, or deleting websets - curated collections of web entities (companies, people, articles, research papers).
---

# Exa Websets

Core operations for managing webset collections.

## Critical Requirements

**MUST follow these rules when using websets:**

1. **Always use --wait when creating**: Wait for websets to reach idle status before enriching
2. **Choose appropriate entity types**: Use specific types (company, person, etc.) for better results
3. **Save webset IDs**: Use `jq` to extract and save IDs for subsequent commands

## Quick Start

### Create Webset from Search

```bash
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups in San Francisco","count":50}' \
  --wait | jq -r '.webset_id')
```

### Create with Detailed Search Criteria

```bash
exa-ai webset-create \
  --search '{
    "query": "Technology companies focused on developer tools",
    "count": 2,
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

## Best Practices

1. **Use --wait when creating**: Wait for websets to reach idle status before enriching
2. **Choose appropriate entity types**: Use specific types (company, person, etc.) for better results
3. **Add metadata for organization**: Track project, owner, status, etc.
4. **Save webset IDs**: Use `jq` to extract and save IDs for subsequent commands
5. **Clone websets for experimentation**: Use `--import webset_id` to duplicate existing websets

## Detailed Reference

For complete options, examples, and workflows, consult [REFERENCE.md](REFERENCE.md).
