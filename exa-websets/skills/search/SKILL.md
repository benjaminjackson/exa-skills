---
name: exa-websets:search
description: Manage websets through search, imports, and enrichments. Use for creating websets, running searches, importing CSV data, managing items, and adding enrichments to extract structured data.
---

# Exa Websets Search

Comprehensive webset management including creation, search, imports, items, and enrichments.

## When to Use This Skill

Use this skill for any webset operations except monitoring/automation:
- Creating and managing websets (CRUD operations)
- Running searches to add items to websets
- Importing CSV files to create websets
- Managing individual items in websets
- Adding enrichments to extract structured data

For automated scheduled updates, use `exa-websets:monitor` instead.

## Component Loading Instructions

**IMPORTANT**: This skill references specialized component documentation. Load the appropriate component file based on the user's task:

### 1. Webset Management (Creating, Listing, Updating, Deleting)
**When**: User wants to create, list, update, or delete websets
**Load**: [Websets Component](websets/SKILL.md)
**Examples**: "Create a webset", "List my websets", "Delete a webset"

### 2. Search Operations (Adding Items via Search)
**When**: User wants to run searches within a webset to add items
**Load**: [Searches Component](searches/SKILL.md)
**Examples**: "Add more items to my webset", "Search for companies", "Run a query"

### 3. CSV Imports (Creating Websets from External Data)
**When**: User wants to upload CSV files to create websets
**Load**: [Imports Component](imports/SKILL.md)
**Examples**: "Import a CSV file", "Upload my data", "Create webset from spreadsheet"

### 4. Item Management (Listing, Viewing, Deleting Items)
**When**: User wants to list, view, or delete items in a webset
**Load**: [Items Component](items/SKILL.md)
**Examples**: "List items in webset", "Show me the items", "Delete an item", "View item details"

### 5. Enrichments (Adding Structured Data Fields)
**When**: User wants to add enrichment fields to extract structured data
**Load**: [Enrichments Component](enrichments/SKILL.md)
**Examples**: "Add enrichment fields", "Extract email addresses", "Add website URLs", "Categorize companies by industry"

## Quick Reference

### Common Workflows

**Create webset from search** → Load websets component
**Add items to existing webset** → Load searches component
**Import CSV data** → Load imports component
**List/view/delete items** → Load items component
**Add enrichment fields** → Load enrichments component

### Multi-Component Tasks

Some tasks require multiple components. Load them sequentially:

1. **Create webset → Add enrichments**
   - Load websets component first (create)
   - Then load enrichments component (add structured data fields)

2. **Import CSV → Add enrichments**
   - Load imports component first (import)
   - Then load enrichments component (add structured data fields)

3. **Create webset → Add more items → Enrich**
   - Load websets component (create)
   - Then searches component (add items)
   - Then enrichments component (add structured data fields)

4. **Review items → Add enrichments**
   - Load items component first (list/review items)
   - Then load enrichments component (add structured data fields)

## Critical Requirements

**Universal rules across all operations:**

1. **Start with minimal counts (1-5 results)**: Initial searches are test spikes to validate quality. ALWAYS default to count:1 unless user explicitly requests more.
2. **Three-step workflow - Validate, Expand, Enrich**: (1) Create with count:1 to test search quality, (2) Expand search count if results are good, (3) Add enrichments only after validated, expanded results.
3. **No enrichments during validation**: Never add enrichments when testing with count:1. Validate search quality first, expand count second, add enrichments last.
4. **Use --wait strategically**: Use --wait for small searches (count ≤ 5). Avoid --wait for large searches.

## Component-Specific Documentation

For detailed documentation on each component, load the appropriate SKILL.md file using the instructions above. Each component has complete examples, best practices, and reference documentation.
