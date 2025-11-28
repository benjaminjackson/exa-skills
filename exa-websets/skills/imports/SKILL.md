---
name: exa-websets:imports
description: Upload external data (CSV files) to create websets from existing datasets. Use when importing CSV files to create websets from your own data collections.
---

# Exa Websets Imports

Upload external data (CSV files) to create websets from existing datasets.

## Critical Requirements

**MUST follow these rules when using imports:**

1. **CSV format**: First row should contain column headers, each row represents one entity
2. **Choose appropriate entity types**: Use specific types (company, person, etc.) for better enrichment results
3. **Include key columns**: At minimum, include a name or identifier column

## Entity Types

- `company`: Companies and organizations
- `person`: Individual people
- `article`: News articles and blog posts
- `research_paper`: Academic papers
- `custom`: Custom entity types (define with --entity-description)

## Quick Start

### Basic CSV Import

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

### Custom Entity Type

```bash
exa-ai import-create products.csv \
  --count 50 \
  --title "Product List" \
  --format csv \
  --entity-type custom \
  --entity-description "Consumer electronics products"
```

### Complete Workflow

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

### Manage Imports

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

## Best Practices

1. **Include descriptive column headers**: Make them clear and meaningful
2. **Use appropriate entity types**: This improves enrichment accuracy
3. **Start with a small sample**: Test with 10-20 rows before importing thousands
4. **Verify import details**: Use `import-get` to check status before creating webset
5. **Add enrichments after import**: Enhance imported data with AI-extracted fields

## Detailed Reference

For complete options, examples, and CSV formatting guidelines, consult [REFERENCE.md](REFERENCE.md).
