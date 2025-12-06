# Exa Websets Search - Complete Reference

This reference covers all webset operations except monitoring/automation.

## Component References

For detailed command references, consult the appropriate component documentation:

### Webset Management
[Websets Reference](websets/REFERENCE.md) - Creating, listing, updating, and deleting websets

### Search Operations
[Searches Reference](searches/REFERENCE.md) - Running searches within websets, search modes, query patterns

### CSV Imports
[Imports Reference](imports/REFERENCE.md) - Uploading CSV files, entity types, import workflows

### Item Management
[Items Reference](items/REFERENCE.md) - Listing, viewing, and deleting webset items

### Enrichments
[Enrichments Reference](enrichments/REFERENCE.md) - Adding structured data fields, enrichment formats, extraction patterns

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

## Example Workflows

### End-to-End Webset Creation with Enrichments

```bash
# 1. Create webset with minimal count (validate)
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups","count":1}' | jq -r '.webset_id')

# 2. Verify result quality
exa-ai webset-item-list $webset_id

# 3. Expand search if quality is good
exa-ai webset-search-create $webset_id \
  --query "AI startups" \
  --mode append \
  --count 2

# 4. Add enrichments after validation
exa-ai enrichment-create $webset_id \
  --description "Company website" \
  --format url \
  --title "Website"

exa-ai enrichment-create $webset_id \
  --description "Employee count" \
  --format text \
  --title "Team Size"
```

### CSV Import with Enrichments

```bash
# 1. Create import
import_id=$(exa-ai import-create companies.csv \
  --count 100 \
  --title "Companies" \
  --entity-type company | jq -r '.import_id')

# 2. Create webset from import
webset_id=$(exa-ai webset-create --import $import_id | jq -r '.webset_id')

# 3. Add enrichments
exa-ai enrichment-create $webset_id \
  --description "LinkedIn profile" \
  --format url \
  --title "LinkedIn"
```

## Best Practices Summary

1. **Start small, validate, then scale**: Use count:1 for initial searches
2. **Three-step workflow**: Validate → Expand → Enrich
3. **No enrichments during validation**: Add enrichments only after confirmed results
4. **Avoid --wait flag**: Do NOT use `--wait` in commands. It's designed for human interactive use, not automated workflows.
5. **Maintain query consistency**: Use exact same query when scaling up searches
6. **Choose appropriate entity types**: For better enrichment results
7. **Use descriptive titles**: For enrichment fields

## Component Documentation

For complete details on each component including all options, examples, and advanced workflows, load the appropriate REFERENCE.md file listed above.
