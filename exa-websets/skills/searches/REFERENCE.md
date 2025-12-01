# Searches

Run searches within a webset to add new items based on search criteria.

## Commands

### webset-search-create

Create a search to add items to a webset.

#### Syntax

```bash
exa-ai webset-search-create WEBSET_ID --query TEXT [OPTIONS]
```

#### Required

- `WEBSET_ID`: Webset ID
- `--query TEXT`: Search query

#### Options

- `--count N`: Number of results to find (default varies by plan)
- `--mode MODE`: `append` or `override` (default: append)
- `--wait`: Wait for search to complete
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Search Modes

- **append**: Add new items to existing collection
- **override**: Replace entire collection with search results

#### ⚠️ Critical: Query Consistency When Appending

**When appending results after a test search, you MUST use the exact same query and explicit criteria.**

```bash
# ✅ CORRECT: Test with count:1, then append more with SAME query
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco founded:2024" \
  --count 1 \
  --wait

# After validating results are good, append more with IDENTICAL query
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco founded:2024" \
  --mode append \
  --count 50

# ❌ WRONG: Different query when appending
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco founded:2024" \
  --count 1

# DON'T DO THIS - different query will return different results
exa-ai webset-search-create ws_abc123 \
  --query "AI startups San Francisco" \  # Missing founded:2024
  --mode append \
  --count 50
```

**Why this matters:**
- Changing the query or criteria means you're no longer scaling up the same search
- Your test search validated one set of results; changing the query invalidates that validation
- You'll end up with inconsistent items in your webset

#### Examples

##### Basic Search

```bash
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco" \
  --count 50
```

##### Search and Wait

```bash
exa-ai webset-search-create ws_abc123 \
  --query "new tech companies 2024" \
  --count 100 \
  --wait
```

##### Append to Existing Items

```bash
exa-ai webset-search-create ws_abc123 \
  --query "SaaS companies Series B" \
  --mode append \
  --count 25
```

##### Override Entire Collection

```bash
exa-ai webset-search-create ws_abc123 \
  --query "top 100 tech companies" \
  --mode override \
  --count 100 \
  --wait
```

##### Save Search ID

```bash
search_id=$(exa-ai webset-search-create ws_abc123 \
  --query "AI research papers" \
  --count 50 | jq -r '.search_id')

echo "Search ID: $search_id"
```

### webset-search-get

Get details and results from a search.

#### Syntax

```bash
exa-ai webset-search-get SEARCH_ID [OPTIONS]
```

#### Required

- `SEARCH_ID`: Search ID

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# Get search details
exa-ai webset-search-get search_xyz789

# Get in JSON format
exa-ai webset-search-get search_xyz789 --output-format json
```

### webset-search-cancel

Cancel a running search.

#### Syntax

```bash
exa-ai webset-search-cancel SEARCH_ID [OPTIONS]
```

#### Required

- `SEARCH_ID`: Search ID

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# Cancel search
exa-ai webset-search-cancel search_xyz789
```

## Search Query Best Practices

### Use Specific Queries

```bash
# Good - specific and targeted
exa-ai webset-search-create ws_abc123 \
  --query "YC W24 batch startups" \
  --count 50

# Less effective - too broad
exa-ai webset-search-create ws_abc123 \
  --query "startups" \
  --count 50
```

### Time-Based Queries

```bash
# Recent content
exa-ai webset-search-create ws_abc123 \
  --query "AI research papers published:2024" \
  --count 100

# Last month
exa-ai webset-search-create ws_abc123 \
  --query "tech news published:last-month" \
  --count 50
```

### Category-Specific Queries

```bash
# Companies
exa-ai webset-search-create ws_abc123 \
  --query "B2B SaaS companies revenue:$10M+" \
  --count 100

# Research papers
exa-ai webset-search-create ws_abc123 \
  --query "machine learning papers arxiv" \
  --count 50

# People
exa-ai webset-search-create ws_abc123 \
  --query "ML engineers at FAANG companies" \
  --count 25
```

## Complete Workflow

### Scaling Up After Test Search

```bash
# 1. Create webset with minimal count to validate
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups founded:2024","count":1}' \
  --wait | jq -r '.webset_id')

# 2. Validate the result is good, then append more with SAME query
exa-ai webset-search-create $webset_id \
  --query "AI startups founded:2024" \
  --mode append \
  --count 49 \
  --wait

# 3. Check results (should have 50 total)
exa-ai webset-item-list $webset_id
```

### Adding Different Search to Same Webset

```bash
# After completing the first search, you can add a DIFFERENT search
# This is different from scaling up - you're adding a new category of items

# 1. Test the new search with count:1
exa-ai webset-search-create $webset_id \
  --query "biotech startups" \
  --mode append \
  --count 1 \
  --wait

# 2. If results are good, scale up with SAME query
exa-ai webset-search-create $webset_id \
  --query "biotech startups" \
  --mode append \
  --count 24 \
  --wait

# 3. Check results
exa-ai webset-item-list $webset_id
```

### Override Entire Collection

```bash
# Replace everything in the webset with new search results
# Always test with count:1 first, even for override

# 1. Test with count:1
exa-ai webset-search-create $webset_id \
  --query "top tech companies 2024" \
  --mode override \
  --count 1 \
  --wait

# 2. Validate, then override with SAME query at scale
exa-ai webset-search-create $webset_id \
  --query "top tech companies 2024" \
  --mode override \
  --count 100 \
  --wait
```

## Monitoring Search Progress

```bash
# Start search
search_id=$(exa-ai webset-search-create ws_abc123 \
  --query "fintech startups" \
  --count 100 | jq -r '.search_id')

# Check status
exa-ai webset-search-get $search_id

# If needed, cancel
exa-ai webset-search-cancel $search_id
```

## Complete Options

For all available options for each command, run:

```bash
exa-ai webset-search-create --help
exa-ai webset-search-get --help
exa-ai webset-search-cancel --help
```
