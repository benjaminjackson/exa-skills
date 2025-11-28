# research-get

Get the status and results of a research task.

## Syntax

```bash
exa-ai research-get RESEARCH_ID [OPTIONS]
```

## Required Arguments

- `RESEARCH_ID`: ID of the research task to retrieve

## Common Options

- `--events`: Include task execution events in response
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

## Status Values

- `pending`: Task has been queued but not started
- `in_progress`: Task is currently running
- `completed`: Task finished successfully
- `failed`: Task encountered an error

## Examples

### Check Research Status
```bash
exa-ai research-get research_abc123
```

### Get Results with Events
```bash
# See what steps the research took
exa-ai research-get research_abc123 --events
```

### Stream Results


### Pretty Print Results
```bash
exa-ai research-get research_abc123 --output-format pretty
```

### Use toon Format (Token Efficient)
```bash
exa-ai research-get research_abc123 --output-format toon
```

### Extract Just the Result
```bash
exa-ai research-get research_abc123 | jq -r '.result'
```

### Extract Structured Data from Result
```bash
# If research was started with --output-schema
exa-ai research-get research_abc123 | jq -r '.result | .key_findings[]'
```

## Polling Pattern

### Check Status in Script
```bash
research_id="research_abc123"

status=$(exa-ai research-get $research_id | jq -r '.status')

if [ "$status" = "completed" ]; then
  echo "Research complete!"
  exa-ai research-get $research_id | jq -r '.result'
elif [ "$status" = "failed" ]; then
  echo "Research failed"
  exit 1
else
  echo "Research still running: $status"
fi
```

### Poll Until Complete
```bash
research_id="research_abc123"

while true; do
  status=$(exa-ai research-get $research_id | jq -r '.status')
  echo "Status: $status"

  if [ "$status" = "completed" ]; then
    echo "Research complete!"
    exa-ai research-get $research_id --events
    break
  elif [ "$status" = "failed" ]; then
    echo "Research failed"
    exit 1
  fi

  sleep 5
done
```

## Return Value

```json
{
  "research_id": "research_abc123",
  "status": "completed",
  "result": "... research results ...",
  "events": [...]  // if --events flag used
}
```

## Token Optimization

```bash
# ❌ Full JSON
exa-ai research-get research_abc123

# ✅ toon format for direct reading (40% savings)
exa-ai research-get research_abc123 --output-format toon

# ✅✅ JSON + jq to extract only result (90% savings)
exa-ai research-get research_abc123 | jq -r '.result'
```

## Complete Options

For all available options, run:
```bash
exa-ai research-get --help
```
