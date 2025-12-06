# Monitors

Automate webset updates on a schedule using monitors. Monitors can periodically run searches to add new items or refresh existing items in a webset.

## Commands

### monitor-create

Create a new monitor to automate webset updates on a schedule.

#### Syntax

```bash
exa-ai monitor-create WEBSET_ID --cron EXPR --timezone TZ --behavior-type TYPE [OPTIONS]
```

#### Monitor Behavior Types

- **search**: Run search periodically to add/update items
- **refresh**: Refresh existing items periodically

#### Cron Expression Examples

```
"0 0 * * *"       # Daily at midnight
"0 9 * * 1"       # Weekly on Monday at 9 AM
"0 */6 * * *"     # Every 6 hours
"0 0 1 * *"       # Monthly on the 1st at midnight
"0 12 * * 1-5"    # Weekdays at noon
```

#### Examples

##### Daily Search Monitor

```bash
exa-ai monitor-create ws_abc123 \
  --cron "0 0 * * *" \
  --timezone "America/New_York" \
  --behavior-type search \
  --query "new AI startups" \
  --count 5
```

##### Weekly Search with Append

```bash
exa-ai monitor-create ws_abc123 \
  --cron "0 9 * * 1" \
  --timezone "America/Los_Angeles" \
  --behavior-type search \
  --query "YC latest batch startups" \
  --behavior-mode append
```

##### Hourly Refresh Monitor

```bash
exa-ai monitor-create ws_abc123 \
  --cron "0 * * * *" \
  --timezone "UTC" \
  --behavior-type refresh
```

##### Daily Refresh (Update Existing Items)

```bash
exa-ai monitor-create ws_abc123 \
  --cron "0 2 * * *" \
  --timezone "America/New_York" \
  --behavior-type refresh
```

##### Monthly Search for New Content

```bash
exa-ai monitor-create ws_abc123 \
  --cron "0 0 1 * *" \
  --timezone "UTC" \
  --behavior-type search \
  --query "AI research papers published:last-month" \
  --behavior-mode append
```

### monitor-get

Get details about a specific monitor.

#### Syntax

```bash
exa-ai monitor-get MONITOR_ID [OPTIONS]
```

#### Examples

```bash
# Get monitor details
exa-ai monitor-get mon_xyz789

# Get in JSON format
exa-ai monitor-get mon_xyz789 --output-format json
```

### monitor-list

List all monitors in your account.

#### Syntax

```bash
exa-ai monitor-list [OPTIONS]
```

#### Examples

```bash
# List all monitors
exa-ai monitor-list

# List in JSON format
exa-ai monitor-list --output-format json
```

### monitor-runs-list

List execution history for a monitor.

#### Syntax

```bash
exa-ai monitor-runs-list MONITOR_ID [OPTIONS]
```

#### Examples

```bash
# List monitor runs
exa-ai monitor-runs-list mon_xyz789

# List in JSON format
exa-ai monitor-runs-list mon_xyz789 --output-format json
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

### Bi-weekly Append

```bash
# Add new items every other Monday
exa-ai monitor-create ws_abc123 \
  --cron "0 9 * * 1" \
  --timezone "America/New_York" \
  --behavior-type search \
  --query "new funding rounds" \
  --behavior-mode append \
  --count 5
```

## Example Workflow

```bash
# 1. Create webset
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups","count":50}' | jq -r '.webset_id')

# 2. Set up daily search monitor to add new startups
monitor_id=$(exa-ai monitor-create $webset_id \
  --cron "0 9 * * *" \
  --timezone "America/New_York" \
  --behavior-type search \
  --query "new AI startups" \
  --behavior-mode append \
  --count 10 | jq -r '.monitor_id')

# 3. Set up nightly refresh to update existing items
exa-ai monitor-create $webset_id \
  --cron "0 2 * * *" \
  --timezone "America/New_York" \
  --behavior-type refresh

# 4. Check monitor details
exa-ai monitor-get $monitor_id

# 5. List all monitors
exa-ai monitor-list

# 6. Check execution history
exa-ai monitor-runs-list $monitor_id
```

## Best Practices

1. **Use separate monitors for search and refresh**: Create one monitor for adding new items and another for refreshing existing ones
2. **Schedule refreshes during off-peak hours**: Run refresh monitors at night to avoid rate limits
3. **Use append mode for continuous growth**: Only use override when you want to completely replace the collection
4. **Set appropriate timezones**: Use your local timezone for business-hour schedules
5. **Monitor execution history**: Check runs regularly to ensure monitors are working as expected
6. **Start with conservative schedules**: Begin with daily or weekly runs, then increase frequency if needed

## Timezone Examples

Common timezone values:
- `America/New_York` (Eastern Time)
- `America/Los_Angeles` (Pacific Time)
- `UTC` (Coordinated Universal Time)
- `Europe/London`

_Use standard IANA timezone names. See tzdata for the full list._

