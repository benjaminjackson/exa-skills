# Searches

Run searches within a webset to add new items based on search criteria.

## Commands

### webset-search-create

Create a search to add items to a webset.

#### Syntax

```bash
exa-ai webset-search-create WEBSET_ID --query TEXT [OPTIONS]
```

#### Search Modes

- **append**: Add new items to existing collection
- **override**: Replace entire collection with search results

#### ⚠️ Critical: Query Consistency When Appending

**When appending results after a test search, you MUST use the exact same query and explicit criteria.**

```bash
# ✅ CORRECT: Test with count:1, then append more with SAME query
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco founded in 2024" \
  --count 1 \
  --wait

# After validating results are good, append more with IDENTICAL query
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco founded in 2024" \
  --mode append \
  --count 50

# ❌ WRONG: Different query when appending
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco founded in 2024" \
  --count 1

# DON'T DO THIS - different query will return different results
exa-ai webset-search-create ws_abc123 \
  --query "AI startups San Francisco" \  # Missing founded in 2024
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

##### Append to Existing Items

```bash
exa-ai webset-search-create ws_abc123 \
  --query "SaaS companies Series B" \
  --mode append \
  --count 25
```

##### Save Search ID

```bash
search_id=$(exa-ai webset-search-create ws_abc123 \
  --query "AI research papers" \
  --count 50 | jq -r '.search_id')
```

### webset-search-get

Get details and results from a search.

#### Syntax

```bash
exa-ai webset-search-get SEARCH_ID [OPTIONS]
```

### webset-search-cancel

Cancel a running search.

#### Syntax

```bash
exa-ai webset-search-cancel SEARCH_ID [OPTIONS]
```

## Search Query Best Practices

### Use Specific Queries

```bash
# Good - specific and targeted
exa-ai webset-search-create ws_abc123 \
  --query "YC W24 batch startups"

# Less effective - too broad
exa-ai webset-search-create ws_abc123 \
  --query "startups"
```

### Time-Based Queries

```bash
# Recent content
exa-ai webset-search-create ws_abc123 \
  --query "AI research papers published in 2024" 

# Last month
exa-ai webset-search-create ws_abc123 \
  --query "tech news published in the last-month" 
```

### Category-Specific Queries

```bash
# Companies
exa-ai webset-search-create ws_abc123 \
  --query "B2B SaaS companies with revenue at least $10M+" 

# Research papers
exa-ai webset-search-create ws_abc123 \
  --query "machine learning papers arxiv"

# People
exa-ai webset-search-create ws_abc123 \
  --query "ML engineers at FAANG companies"
```

## Example Workflow

### Scaling Up After Test Search

```bash
# 1. Create webset with minimal count to validate
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups founded in 2024","count":1}' \
  --wait | jq -r '.webset_id')

# 2. Validate the result is good, then append more with SAME query
exa-ai webset-search-create $webset_id \
  --query "AI startups founded in 2024" \
  --mode append \
  --count 2 \
  --wait
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