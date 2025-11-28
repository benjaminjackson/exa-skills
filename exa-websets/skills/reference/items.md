# Items

Manage individual items in websets and enrich them with additional structured data.

## Item Management Commands

### webset-item-list

List all items in a webset.

#### Syntax

```bash
exa-ai webset-item-list WEBSET_ID [OPTIONS]
```

#### Required

- `WEBSET_ID`: Webset ID

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# List all items
exa-ai webset-item-list ws_abc123

# List in JSON format
exa-ai webset-item-list ws_abc123 --output-format json
```

### webset-item-get

Get details about a specific item.

#### Syntax

```bash
exa-ai webset-item-get ITEM_ID [OPTIONS]
```

#### Required

- `ITEM_ID`: Item ID

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# Get item details
exa-ai webset-item-get item_xyz789

# Get in JSON format
exa-ai webset-item-get item_xyz789 --output-format json
```

### webset-item-delete

Remove an item from a webset.

#### Syntax

```bash
exa-ai webset-item-delete ITEM_ID [OPTIONS]
```

#### Required

- `ITEM_ID`: Item ID

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# Delete item
exa-ai webset-item-delete item_xyz789

# Delete and view response
exa-ai webset-item-delete item_xyz789 --output-format json
```

## Enrichment Commands

Enrichments add structured data fields to all items in a webset. Each enrichment extracts specific information using AI.

### enrichment-create

Create a new enrichment for a webset.

#### Syntax

```bash
exa-ai enrichment-create WEBSET_ID --description TEXT --format TYPE [OPTIONS]
```

#### Required

- `WEBSET_ID`: Webset ID
- `--description TEXT`: What to extract
- `--format TYPE`: `text`, `url`, or `options`

#### Common Options

- `--title TEXT`: Display title
- `--options JSON`: Array of {"label":"..."} (required if format=options)
- `--instructions TEXT`: Additional instructions
- `--wait`: Wait for enrichment to complete
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Enrichment Formats

- **text**: Free-form text extraction
- **url**: Extract URLs
- **options**: Categorical data (predefined options)

#### Examples

##### Text Enrichment

```bash
exa-ai enrichment-create ws_abc123 \
  --description "Company size (number of employees)" \
  --format text \
  --wait
```

##### URL Enrichment

```bash
exa-ai enrichment-create ws_abc123 \
  --description "Company website" \
  --format url \
  --title "Website" \
  --wait
```

##### Options Enrichment (Categorical)

```bash
exa-ai enrichment-create ws_abc123 \
  --description "Funding stage" \
  --format options \
  --options '[
    {"label":"Seed"},
    {"label":"Series A"},
    {"label":"Series B"},
    {"label":"Series C+"}
  ]' \
  --wait
```

##### Options from File

```bash
cat > funding-stages.json <<'EOF'
[
  {"label": "Pre-seed"},
  {"label": "Seed"},
  {"label": "Series A"},
  {"label": "Series B+"},
  {"label": "Public"}
]
EOF

exa-ai enrichment-create ws_abc123 \
  --description "Funding stage" \
  --format options \
  --options @funding-stages.json \
  --title "Funding" \
  --wait
```

##### With Instructions

```bash
exa-ai enrichment-create ws_abc123 \
  --description "Technology stack" \
  --format text \
  --instructions "Focus on backend technologies only" \
  --title "Tech Stack" \
  --wait
```

### enrichment-get

Get details about a specific enrichment.

#### Syntax

```bash
exa-ai enrichment-get ENRICHMENT_ID [OPTIONS]
```

#### Required

- `ENRICHMENT_ID`: Enrichment ID

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# Get enrichment details
exa-ai enrichment-get enr_xyz789

# Get in JSON format
exa-ai enrichment-get enr_xyz789 --output-format json
```

### enrichment-list

List all enrichments for a webset.

#### Syntax

```bash
exa-ai enrichment-list WEBSET_ID [OPTIONS]
```

#### Required

- `WEBSET_ID`: Webset ID

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# List all enrichments
exa-ai enrichment-list ws_abc123

# List in JSON format
exa-ai enrichment-list ws_abc123 --output-format json
```

### enrichment-update

Update an enrichment configuration.

#### Syntax

```bash
exa-ai enrichment-update ENRICHMENT_ID [OPTIONS]
```

#### Required

- `ENRICHMENT_ID`: Enrichment ID

#### Options

- `--title TEXT`: Update display title
- `--description TEXT`: Update extraction description
- `--instructions TEXT`: Update additional instructions
- `--options JSON`: Update options (for options format)
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# Update title
exa-ai enrichment-update enr_xyz789 --title "Team Size"

# Update description
exa-ai enrichment-update enr_xyz789 \
  --description "Exact employee count as of latest data"

# Update options
exa-ai enrichment-update enr_xyz789 \
  --options '[{"label":"1-10"},{"label":"11-50"},{"label":"51-200"},{"label":"201+"}]'
```

### enrichment-delete

Delete an enrichment from a webset.

#### Syntax

```bash
exa-ai enrichment-delete ENRICHMENT_ID [OPTIONS]
```

#### Required

- `ENRICHMENT_ID`: Enrichment ID

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# Delete enrichment
exa-ai enrichment-delete enr_xyz789
```

## Complete Example: Enrich Company Webset

```bash
webset_id="ws_abc123"

# Add website URL
exa-ai enrichment-create $webset_id \
  --description "Company website" \
  --format url \
  --title "Website" \
  --wait

# Add employee count
exa-ai enrichment-create $webset_id \
  --description "Number of employees" \
  --format text \
  --title "Team Size" \
  --wait

# Add industry category
exa-ai enrichment-create $webset_id \
  --description "Primary industry" \
  --format options \
  --options '[{"label":"SaaS"},{"label":"Hardware"},{"label":"Biotech"},{"label":"Other"}]' \
  --title "Industry" \
  --wait

# List all enrichments
exa-ai enrichment-list $webset_id

# View enriched items
exa-ai webset-item-list $webset_id
```

## Complete Workflow: Items and Enrichments

```bash
# 1. Create webset
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups","count":50}' \
  --wait | jq -r '.webset_id')

# 2. Add enrichments
exa-ai enrichment-create $webset_id \
  --description "Company website" --format url --title "Website" --wait

exa-ai enrichment-create $webset_id \
  --description "Funding stage" --format options \
  --options '[{"label":"Seed"},{"label":"Series A"},{"label":"Series B+"}]' \
  --title "Stage" --wait

# 3. View items with enrichments
exa-ai webset-item-list $webset_id

# 4. Get specific item
item_id=$(exa-ai webset-item-list $webset_id --output-format json | jq -r '.items[0].id')
exa-ai webset-item-get $item_id

# 5. Delete unwanted item
exa-ai webset-item-delete $item_id
```

## Enrichment Best Practices

1. **Use descriptive titles**: Make column headers clear and concise
2. **Choose appropriate formats**:
   - Use `url` for links
   - Use `options` for categorical data
   - Use `text` for free-form data
3. **Add instructions for clarity**: Help AI extract exactly what you need
4. **Use --wait for large websets**: Enrichments can take time to process
5. **Limit options to 10 or fewer**: Too many options reduce accuracy

## Complete Options

For all available options for each command, run:

```bash
exa-ai webset-item-list --help
exa-ai webset-item-get --help
exa-ai webset-item-delete --help
exa-ai enrichment-create --help
exa-ai enrichment-get --help
exa-ai enrichment-list --help
exa-ai enrichment-update --help
exa-ai enrichment-delete --help
```
