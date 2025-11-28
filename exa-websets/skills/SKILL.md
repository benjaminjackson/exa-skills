---
name: exa-websets
description: Use when the user mentions Exa websets or when the workflow benefits from creating structured, CSV-like collections of search results validated against multiple independent criteria, enriched with additional search data.
---

# Exa Websets

Manage websets and the complete ecosystem for building, enriching, and monitoring data collections.

## Websets Overview

**Websets** are curated collections of web entities (companies, people, articles, research papers) that you can:
- Build from search results or imports
- Enrich with additional data points
- Search and filter
- Monitor for updates automatically
- Export and integrate with other systems

## Ecosystem Components

1. **Websets**: Core CRUD operations for collections
2. **Searches**: Run searches within a webset to add items
3. **Items**: Manage individual items in a webset
4. **Enrichments**: Add structured data fields to webset items
5. **Imports**: Upload external data (CSV files) to create websets
6. **Monitors**: Automate webset updates on a schedule

## Core Commands

### Websets
- `webset-create`: Create new webset from search or import
- `webset-get`: Get webset details
- `webset-list`: List all websets
- `webset-update`: Update webset configuration
- `webset-delete`: Delete a webset

For detailed syntax, consult [reference/webset-create.md](reference/webset-create.md).

### Webset Searches
- `webset-search-create`: Create search to add items
- `webset-search-get`: Get search details/results
- `webset-search-cancel`: Cancel a running search

### Webset Items
- `webset-item-list`: List items in webset
- `webset-item-get`: Get item details
- `webset-item-delete`: Remove item from webset

### Enrichments
- `enrichment-create`: Create enrichment field (text, url, options)
- `enrichment-get`: Get enrichment details
- `enrichment-list`: List all enrichments for webset
- `enrichment-update`: Update enrichment configuration
- `enrichment-delete`: Delete an enrichment

For detailed syntax, consult [reference/enrichment-create.md](reference/enrichment-create.md).

### Imports
- `import-create`: Upload CSV file to create webset
- `import-list`: List all imports
- `import-get`: Get import details

### Monitors
- `monitor-create`: Create scheduled automation (search or refresh)
- `monitor-get`: Get monitor details
- `monitor-list`: List all monitors
- `monitor-runs-list`: List monitor execution history

For detailed syntax, consult [reference/monitor-create.md](reference/monitor-create.md).

## Quick Start

### Create and Enrich a Webset
```bash
# Create webset from search
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups San Francisco","count":50}' \
  --wait | jq -r '.webset_id')

# Add enrichments
exa-ai enrichment-create $webset_id \
  --description "Company website" --format url --title "Website" --wait

exa-ai enrichment-create $webset_id \
  --description "Employee count" --format text --title "Team Size" --wait
```

### Set Up Monitoring
```bash
# Daily search for new items
exa-ai monitor-create $webset_id \
  --cron "0 9 * * *" \
  --timezone "America/New_York" \
  --behavior-type search \
  --query "new AI startups" \
  --behavior-mode append
```

### Import and Enrich
```bash
# Import CSV
import_id=$(exa-ai import-create companies.csv \
  --count 100 --title "Companies" --format csv --entity-type company | jq -r '.import_id')

# Create webset from import
webset_id=$(exa-ai webset-create --import $import_id --wait | jq -r '.webset_id')

# Add enrichments
exa-ai enrichment-create $webset_id \
  --description "Funding stage" \
  --format options \
  --options '[{"label":"Seed"},{"label":"Series A"},{"label":"Series B+"}]' \
  --wait
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
3. **Use monitors for automation**: Set up monitors instead of manual refreshes
4. **Leverage enrichments**: Add structured fields for better organization
5. **Import for bulk data**: Use imports for large existing datasets

## Common Workflows

For complete workflows and examples, consult [reference/webset-create.md](reference/webset-create.md), [reference/enrichment-create.md](reference/enrichment-create.md), and [reference/monitor-create.md](reference/monitor-create.md).
