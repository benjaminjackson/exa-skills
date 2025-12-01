---
name: exa-websets:items
description: Manage individual items in websets. Use when listing, viewing, or deleting webset items. For adding enrichment fields, use the enrichments component instead.
---

# Exa Websets Items

Manage individual items in websets - list, view, and delete operations.

## Critical Requirements

**MUST follow these rules when managing items:**

1. **Use appropriate output formats**: Use `pretty` or `text` for readability, `json` for scripting
2. **Save item IDs for operations**: Use `jq` to extract and save item IDs from list operations
3. **Be cautious with deletions**: Deleted items cannot be recovered

## Quick Start

### List All Items

```bash
# List all items in a webset
exa-ai webset-item-list ws_abc123

# Pretty print for readability
exa-ai webset-item-list ws_abc123 --output-format pretty

# JSON format for scripting
exa-ai webset-item-list ws_abc123 --output-format json
```

### Get Item Details

```bash
# Get specific item details
exa-ai webset-item-get item_xyz789

# Pretty print
exa-ai webset-item-get item_xyz789 --output-format pretty
```

### Delete an Item

```bash
# Delete unwanted item
exa-ai webset-item-delete item_xyz789

# Delete with force (skip confirmation if implemented)
exa-ai webset-item-delete item_xyz789 --force
```

## Common Workflows

### Review Items After Creation

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

### Clean Up Unwanted Items

```bash
# List items to identify unwanted ones
exa-ai webset-item-list ws_abc123 --output-format pretty

# Delete specific items
exa-ai webset-item-delete item_xyz789
exa-ai webset-item-delete item_abc456
```

### Extract Item IDs for Processing

```bash
# Get all item IDs
exa-ai webset-item-list ws_abc123 --output-format json | jq -r '.items[].id'

# Get first 5 item IDs
exa-ai webset-item-list ws_abc123 --output-format json | jq -r '.items[:5] | .[].id'

# Count items
exa-ai webset-item-list ws_abc123 --output-format json | jq '.items | length'
```

## Best Practices

1. **Use pretty format for review**: `--output-format pretty` makes items easier to read
2. **Use JSON format for scripting**: Extract IDs and data with `jq` for automation
3. **Review before deleting**: Always check item details before deletion
4. **Save item IDs**: Use `jq` to extract and save IDs for batch operations
5. **Check item counts**: Verify expected number of items after searches or imports

## Detailed Reference

For complete command reference, syntax, and all options, consult [REFERENCE.md](REFERENCE.md).
