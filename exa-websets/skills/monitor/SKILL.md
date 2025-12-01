---
name: exa-websets:monitor
description: Use when setting up monitors - periodic searches to add new items or refresh existing items in a webset automatically.
---

# Exa Websets Monitor

Automate webset updates on a schedule using monitors.

## Critical Requirements

**MUST follow these rules when using monitors:**

1. **Use separate monitors for search and refresh**: Create one monitor for adding new items and another for refreshing existing ones
2. **Schedule refreshes during off-peak hours**: Run refresh monitors at night to avoid rate limits
3. **Set appropriate timezones**: Use your local timezone for business-hour schedules

## Monitor Behavior Types

- **search**: Run search periodically to add/update items
- **refresh**: Refresh existing items periodically

## Output Formats

All exa-ai monitor commands support output formats:
- **JSON (default)**: Pipe to `jq` to extract specific fields (e.g., `| jq -r '.monitor_id'`)
- **toon**: Compact, readable format for direct viewing
- **pretty**: Human-friendly formatted output
- **text**: Plain text output

## Quick Start

### Create Search Monitor

```bash
# Daily search for new items
exa-ai monitor-create ws_abc123 \
  --cron "0 9 * * *" \
  --timezone "America/New_York" \
  --behavior-type search \
  --query "new AI startups" \
  --count 50
```

### Create Refresh Monitor

```bash
# Nightly refresh of existing items
exa-ai monitor-create ws_abc123 \
  --cron "0 2 * * *" \
  --timezone "America/New_York" \
  --behavior-type refresh
```

### Common Cron Patterns

```bash
"0 0 * * *"       # Daily at midnight
"0 9 * * 1"       # Weekly on Monday at 9 AM
"0 */6 * * *"     # Every 6 hours
"0 0 1 * *"       # Monthly on the 1st at midnight
"0 12 * * 1-5"    # Weekdays at noon
```

### Manage Monitors

```bash
# List all monitors
exa-ai monitor-list

# Get monitor details
exa-ai monitor-get mon_xyz789

# View execution history
exa-ai monitor-runs-list mon_xyz789
```

## Example Workflow

```bash
# 1. Create webset
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups","count":50}' \
  --wait | jq -r '.webset_id')

# 2. Set up daily search monitor
monitor_id=$(exa-ai monitor-create $webset_id \
  --cron "0 9 * * *" \
  --timezone "America/New_York" \
  --behavior-type search \
  --query "new AI startups" \
  --behavior-mode append \
  --count 10 | jq -r '.monitor_id')

# 3. Set up nightly refresh
exa-ai monitor-create $webset_id \
  --cron "0 2 * * *" \
  --timezone "America/New_York" \
  --behavior-type refresh

# 4. Check execution history
exa-ai monitor-runs-list $monitor_id
```

## Best Practices

1. **Use separate monitors for search and refresh**: Create one monitor for adding new items and another for refreshing existing ones
2. **Schedule refreshes during off-peak hours**: Run refresh monitors at night to avoid rate limits
3. **Use append mode for continuous growth**: Only use override when you want to completely replace the collection
4. **Set appropriate timezones**: Use your local timezone for business-hour schedules
5. **Monitor execution history**: Check runs regularly to ensure monitors are working as expected
6. **Start with conservative schedules**: Begin with daily or weekly runs, then increase frequency if needed

## Detailed Reference

For complete options, examples, and cron patterns, consult [REFERENCE.md](REFERENCE.md).
