---
name: exa-websets:searches
description: Run searches within a webset to add new items based on search criteria. Use when adding items to an existing webset through search queries, with options to append or override the collection.
---

# Exa Websets Searches

Run searches within a webset to add new items based on search criteria.

## Critical Requirements

**MUST follow these rules when using searches:**

1. **Use specific queries**: Targeted queries yield better results than broad ones
2. **Choose the right mode**: Use `append` to add items, `override` to replace entire collection
3. **Use --wait for large searches**: Wait for search to complete before viewing results

## Search Modes

- **append**: Add new items to existing collection (default)
- **override**: Replace entire collection with search results

## Quick Start

### Basic Search

```bash
# Add items to existing webset
exa-ai webset-search-create ws_abc123 \
  --query "AI startups in San Francisco" \
  --count 50 \
  --wait
```

### Append to Collection

```bash
# Add more items without removing existing ones
exa-ai webset-search-create ws_abc123 \
  --query "SaaS companies Series B" \
  --mode append \
  --count 25
```

### Override Collection

```bash
# Replace entire collection
exa-ai webset-search-create ws_abc123 \
  --query "top 100 tech companies" \
  --mode override \
  --count 100 \
  --wait
```

### Monitor Search Progress

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

# 3. Check results
exa-ai webset-item-list $webset_id
```

## Detailed Reference

For complete options, examples, and query patterns, consult [REFERENCE.md](REFERENCE.md).
