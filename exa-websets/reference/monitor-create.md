# monitor-create

Create a new monitor to automate webset updates on a schedule.

## Syntax

```bash
exa-ai monitor-create WEBSET_ID --cron EXPR --timezone TZ --behavior-type TYPE [OPTIONS]
```

## Required

- `WEBSET_ID`: Webset ID
- `--cron EXPR`: Cron expression (e.g., "0 0 * * *")
- `--timezone TZ`: Timezone (e.g., "America/New_York")
- `--behavior-type TYPE`: `search` or `refresh`

## For Search Behavior

- `--query TEXT`: Search query (required for search)
- `--count N`: Number of results (optional)
- `--behavior-mode MODE`: `override` or `append` (default: append)

## Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

## Monitor Behavior Types

- **search**: Run search periodically to add/update items
- **refresh**: Refresh existing items periodically

## Cron Expression Examples

```
"0 0 * * *"       # Daily at midnight
"0 9 * * 1"       # Weekly on Monday at 9 AM
"0 */6 * * *"     # Every 6 hours
"0 0 1 * *"       # Monthly on the 1st at midnight
"0 12 * * 1-5"    # Weekdays at noon
```

## Examples

### Daily Search Monitor
```bash
exa-ai monitor-create ws_abc123 \
  --cron "0 0 * * *" \
  --timezone "America/New_York" \
  --behavior-type search \
  --query "new AI startups" \
  --count 50
```

### Weekly Search with Append
```bash
exa-ai monitor-create ws_abc123 \
  --cron "0 9 * * 1" \
  --timezone "America/Los_Angeles" \
  --behavior-type search \
  --query "YC latest batch startups" \
  --behavior-mode append
```

### Hourly Refresh Monitor
```bash
exa-ai monitor-create ws_abc123 \
  --cron "0 * * * *" \
  --timezone "UTC" \
  --behavior-type refresh
```

### Daily Refresh (Update Existing Items)
```bash
exa-ai monitor-create ws_abc123 \
  --cron "0 2 * * *" \
  --timezone "America/New_York" \
  --behavior-type refresh
```

### Monthly Search for New Content
```bash
exa-ai monitor-create ws_abc123 \
  --cron "0 0 1 * *" \
  --timezone "UTC" \
  --behavior-type search \
  --query "AI research papers published:last-month" \
  --behavior-mode append
```

## Common Patterns

### Daily Morning Update
```bash
# Search for new items every morning at 9 AM
exa-ai monitor-create ws_abc123 \
  --cron "0 9 * * *" \
  --timezone "America/New_York" \
  --behavior-type search \
  --query "latest tech news" \
  --behavior-mode append \
  --count 25
```

### Nightly Refresh
```bash
# Refresh all items every night at 2 AM
exa-ai monitor-create ws_abc123 \
  --cron "0 2 * * *" \
  --timezone "America/New_York" \
  --behavior-type refresh
```

### Weekly Comprehensive Update
```bash
# Override entire collection weekly
exa-ai monitor-create ws_abc123 \
  --cron "0 0 * * 0" \
  --timezone "UTC" \
  --behavior-type search \
  --query "top tech companies 2024" \
  --behavior-mode override \
  --count 100
```

## Complete Options

For all available options, run:
```bash
exa-ai monitor-create --help
```
