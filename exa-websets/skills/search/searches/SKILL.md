---
name: exa-websets:searches
description: Run searches within a webset to add new items based on search criteria. Use when adding items to an existing webset through search queries, with options to append or override the collection.
---

# Exa Websets Searches

Run searches within a webset to add new items based on search criteria.

## Critical Requirements

**MUST follow these rules when using searches:**

1. **Start with minimal counts (1-5 results)**: Initial searches are test spikes to validate query quality. ALWAYS default to count:1 unless user explicitly requests more. Only increase count after confirming the search returns useful results, not false positives.
2. **Use --wait for quick searches, avoid for long ones**: Use --wait for small searches (count ≤ 5) since they complete quickly. Avoid --wait for large searches to prevent blocking.
3. **Use specific queries**: Targeted queries yield better results than broad ones
4. **Choose the right mode**: Use `append` to add items, `override` to replace entire collection

## Search Modes

- **append**: Add new items to existing collection (default)
- **override**: Replace entire collection with search results

## ⚠️ Critical: Query Consistency When Appending

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

## Quick Start

### Basic Search

```bash
# Start with count:1 to validate search quality before adding more items
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco" \
  --count 1 \
  --wait
```

### Append to Collection

```bash
# Test query with count:1 before appending more items
exa-ai webset-search-create ws_abc123 \
  --query "SaaS companies Series B" \
  --mode append \
  --count 1
```

### Override Collection

```bash
# Validate query with minimal count before overriding entire collection
exa-ai webset-search-create ws_abc123 \
  --query "top tech companies" \
  --mode override \
  --count 1 \
  --wait
```

### Monitor Search Progress

```bash
# Start search with minimal count to test
search_id=$(exa-ai webset-search-create ws_abc123 \
  --query "fintech startups" \
  --count 1 | jq -r '.search_id')

# Check status
exa-ai webset-search-get $search_id

# If needed, cancel
exa-ai webset-search-cancel $search_id
```

## Search Query Best Practices

### Use Specific Queries

```bash
# Good - specific and targeted, start with count:1
exa-ai webset-search-create ws_abc123 \
  --query "YC W24 batch startups" \
  --count 1

# Less effective - too broad (still use count:1 to test)
exa-ai webset-search-create ws_abc123 \
  --query "startups" \
  --count 1
```

### Time-Based Queries

```bash
# Recent content - validate with count:1 first
exa-ai webset-search-create ws_abc123 \
  --query "AI research papers published:2024" \
  --count 1

# Last month - test before scaling up
exa-ai webset-search-create ws_abc123 \
  --query "tech news published:last-month" \
  --count 1
```

### Category-Specific Queries

```bash
# Companies - start with minimal count
exa-ai webset-search-create ws_abc123 \
  --query "B2B SaaS companies revenue:$10M+" \
  --count 1

# Research papers - validate query quality first
exa-ai webset-search-create ws_abc123 \
  --query "machine learning papers arxiv" \
  --count 1
```

## Example Workflow

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
  --count 2 \
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
  --count 2 \
  --wait
```

## Detailed Reference

For complete options, examples, and query patterns, consult [REFERENCE.md](REFERENCE.md).
