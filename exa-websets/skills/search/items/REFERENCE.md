# Items

Manage individual items in websets - list, view, and delete operations.

## Item Management Commands

### webset-item-list

List all items in a webset.

#### Syntax

```bash
exa-ai webset-item-list WEBSET_ID [OPTIONS]
```

#### Examples

```bash
# List all items
exa-ai webset-item-list ws_abc123

# List in JSON format
exa-ai webset-item-list ws_abc123 --output-format json
```

### webset-item-get

Get details about a specific item.

#### Syntax

```bash
exa-ai webset-item-get ITEM_ID [OPTIONS]
```

#### Examples

```bash
# Get item details
exa-ai webset-item-get item_xyz789
```

### webset-item-delete

Remove an item from a webset.

#### Syntax

```bash
exa-ai webset-item-delete ITEM_ID [OPTIONS]
```

## Common Workflows

### Review Items After Creation

```bash
# Create webset
webset_id=$(exa-ai webset-create \
  --search '{"query":"tech companies","count":10}' \
  --wait | jq -r '.webset_id')

# Review all items in pretty format
exa-ai webset-item-list $webset_id --output-format pretty
```

### Extract Item IDs for Processing

```bash
# Get all item IDs
exa-ai webset-item-list ws_abc123 --output-format json | jq -r '.items[].id'

# Get first 5 item IDs
exa-ai webset-item-list ws_abc123 --output-format json | jq -r '.items[:5] | .[].id'

# Count total items
exa-ai webset-item-list ws_abc123 --output-format json | jq '.items | length'

# Filter items by criteria (example: items with specific field)
exa-ai webset-item-list ws_abc123 --output-format json | jq '.items[] | select(.title | contains("AI"))'
```

### Clean Up Unwanted Items

```bash
# List items to identify unwanted ones
exa-ai webset-item-list ws_abc123 --output-format pretty

# Delete specific items
exa-ai webset-item-delete item_xyz789
exa-ai webset-item-delete item_abc456
exa-ai webset-item-delete item_def789
```

### Batch Delete Items

```bash
# Get IDs of items to delete (example: using jq filter)
items_to_delete=$(exa-ai webset-item-list ws_abc123 --output-format json | \
  jq -r '.items[] | select(.title | contains("spam")) | .id')

# Delete each item
for item_id in $items_to_delete; do
  exa-ai webset-item-delete $item_id --force
done
```