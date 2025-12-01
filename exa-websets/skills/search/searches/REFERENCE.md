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
  --count 5

# ❌ WRONG: Different query when appending
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco founded in 2024" \
  --count 1

# DON'T DO THIS - different query will return different results
exa-ai webset-search-create ws_abc123 \
  --query "AI startups San Francisco" \  # Missing founded in 2024
  --mode append \
  --count 5
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
  --count 5
```

##### Append to Existing Items

```bash
exa-ai webset-search-create ws_abc123 \
  --query "SaaS companies Series B" \
  --mode append \
  --count 5
```

##### Save Search ID

```bash
search_id=$(exa-ai webset-search-create ws_abc123 \
  --query "AI research papers" \
  --count 5 | jq -r '.search_id')
```

### webset-search-cancel

Cancel a running search.

#### Syntax

```bash
exa-ai webset-search-cancel SEARCH_ID [OPTIONS]
```

## Example Workflows

_Note: Always start with count:1 to validate, then scale up with the identical query. See main SKILL.md for the complete three-step workflow._

### Append Search Results

```bash
exa-ai webset-search-create ws_abc123 \
  --query "AI startups founded in 2024" \
  --mode append \
  --count 1 \
  --wait
```

### Override Entire Collection

```bash
exa-ai webset-search-create ws_abc123 \
  --query "top tech companies 2024" \
  --mode override \
  --count 1 \
  --wait
```
