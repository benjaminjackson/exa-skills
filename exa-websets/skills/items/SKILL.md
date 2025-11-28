---
name: exa-websets:items
description: Manage individual items in websets and enrich them with structured data. Use when listing, viewing, or deleting webset items, or when adding enrichment fields (text, url, options) to extract specific information.
---

# Exa Websets Items

Manage individual items in websets and enrich them with additional structured data.

## Critical Requirements

**MUST follow these rules when using enrichments:**

1. **Always use --wait for large websets**: Enrichments can take time to process
2. **Use descriptive titles**: Make column headers clear and concise
3. **Choose appropriate formats**: Use `url` for links, `options` for categorical data, `text` for free-form data

## Enrichment Formats

- **text**: Free-form text extraction
- **url**: Extract URLs
- **options**: Categorical data (predefined options)

## Quick Start

### List and Manage Items

```bash
# List all items in a webset
exa-ai webset-item-list ws_abc123

# Get specific item details
exa-ai webset-item-get item_xyz789

# Delete an item
exa-ai webset-item-delete item_xyz789
```

### Create Enrichments

```bash
webset_id="ws_abc123"

# Add website URL
exa-ai enrichment-create $webset_id \
  --description "Company website" \
  --format url \
  --title "Website" \
  --wait

# Add employee count
exa-ai enrichment-create $webset_id \
  --description "Number of employees" \
  --format text \
  --title "Team Size" \
  --wait

# Add industry category
exa-ai enrichment-create $webset_id \
  --description "Primary industry" \
  --format options \
  --options '[{"label":"SaaS"},{"label":"Hardware"},{"label":"Biotech"},{"label":"Other"}]' \
  --title "Industry" \
  --wait
```

### Manage Enrichments

```bash
# List all enrichments
exa-ai enrichment-list ws_abc123

# Get enrichment details
exa-ai enrichment-get enr_xyz789

# Update enrichment
exa-ai enrichment-update enr_xyz789 --title "Team Size"

# Delete enrichment
exa-ai enrichment-delete enr_xyz789
```

## Best Practices

1. **Use descriptive titles**: Make column headers clear and concise
2. **Choose appropriate formats**:
   - Use `url` for links
   - Use `options` for categorical data
   - Use `text` for free-form data
3. **Add instructions for clarity**: Help AI extract exactly what you need
4. **Use --wait for large websets**: Enrichments can take time to process
5. **Limit options to 10 or fewer**: Too many options reduce accuracy

## Detailed Reference

For complete options, examples, and workflows, consult [REFERENCE.md](REFERENCE.md).
