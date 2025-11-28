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

```bash
# 1. Create webset
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups","count":50}' \
  --wait | jq -r '.webset_id')

# 2. Add more items with search
exa-ai webset-search-create $webset_id \
  --query "biotech startups" \
  --mode append \
  --count 25 \
  --wait

# 3. Check search results
exa-ai webset-item-list $webset_id

# 4. Run another search to replace everything
exa-ai webset-search-create $webset_id \
  --query "top 100 tech companies 2024" \
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
