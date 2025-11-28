# research-list

List research tasks with cursor-based pagination.

## Syntax

```bash
exa-ai research-list [OPTIONS]
```

## Common Options

- `--cursor CURSOR`: Pagination cursor for next page
- `--limit LIMIT`: Number of results per page (default: 10)
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

## Examples

### List All Tasks (Default)
```bash
exa-ai research-list
```

### Limit Results
```bash
exa-ai research-list --limit 20
```

### Paginate Through Results
```bash
# Get first page
page1=$(exa-ai research-list --limit 10)

# Get cursor for next page
cursor=$(echo "$page1" | jq -r '.cursor')

# Get next page
exa-ai research-list --cursor "$cursor" --limit 10
```

### Pretty Print
```bash
exa-ai research-list --output-format pretty
```

### toon Format
```bash
exa-ai research-list --output-format toon
```

### Extract Task IDs and Status
```bash
exa-ai research-list | jq -r '.tasks[] | "\(.research_id): \(.status)"'
```

### Find Completed Tasks
```bash
exa-ai research-list --limit 100 | \
  jq -r '.tasks[] | select(.status == "completed") | .research_id'
```

### Get Recent Tasks Only
```bash
exa-ai research-list --limit 5 | \
  jq -r '.tasks[] | "\(.created_at): \(.research_id)"'
```

## Pagination Workflow

```bash
#!/bin/bash

# Fetch all research tasks across pages
cursor=""
all_tasks=()

while true; do
  if [ -z "$cursor" ]; then
    response=$(exa-ai research-list --limit 25)
  else
    response=$(exa-ai research-list --cursor "$cursor" --limit 25)
  fi

  # Extract tasks
  tasks=$(echo "$response" | jq -r '.tasks[] | .research_id')
  all_tasks+=($tasks)

  # Get next cursor
  cursor=$(echo "$response" | jq -r '.cursor // empty')

  # Break if no more pages
  [ -z "$cursor" ] && break
done

echo "Total tasks: ${#all_tasks[@]}"
```

## Return Value

```json
{
  "tasks": [
    {
      "research_id": "research_abc123",
      "status": "completed",
      "created_at": "2024-01-01T00:00:00Z",
      ...
    },
    ...
  ],
  "cursor": "next_page_cursor_string"
}
```

## Token Optimization

```bash
# ❌ Full JSON
exa-ai research-list

# ✅ toon format
exa-ai research-list --output-format toon

# ✅✅ Extract only IDs
exa-ai research-list | jq -r '.tasks[].research_id'
```

## Complete Options

For all available options, run:
```bash
exa-ai research-list --help
```
