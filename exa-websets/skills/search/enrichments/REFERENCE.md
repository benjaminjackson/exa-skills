# Enrichments

Add structured data fields to all items in a webset using AI extraction.

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
- `--options JSON`: Array of {"label":"..."} (required if format=options, supports @file.json)
- `--instructions TEXT`: Additional instructions
- `--metadata JSON`: Custom metadata (supports @file.json)
- `--wait`: Wait for enrichment to complete
- `--api-key KEY`: Exa API key (or set EXA_API_KEY env var)
- `--output-format FMT`: `json`, `pretty`, or `text`

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
  --title "Team Size" \
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
  --title "Funding" \
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

##### With Metadata

```bash
exa-ai enrichment-create ws_abc123 \
  --description "Company valuation" \
  --format text \
  --title "Valuation" \
  --metadata '{"source":"public filings","confidence":"high"}' \
  --wait
```

### enrichment-get

Get details about a specific enrichment.

#### Syntax

```bash
exa-ai enrichment-get WEBSET_ID ENRICHMENT_ID [OPTIONS]
```

#### Required

- `WEBSET_ID`: Webset ID
- `ENRICHMENT_ID`: Enrichment ID

#### Options

- `--api-key KEY`: Exa API key (or set EXA_API_KEY env var)
- `--output-format FMT`: `json`, `pretty`, or `text`

#### Examples

```bash
# Get enrichment details
exa-ai enrichment-get ws_abc123 enr_xyz789

# Get in pretty format
exa-ai enrichment-get ws_abc123 enr_xyz789 --output-format pretty
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

- `--api-key KEY`: Exa API key (or set EXA_API_KEY env var)
- `--output-format FMT`: `json`, `pretty`, or `text`

#### Examples

```bash
# List all enrichments
exa-ai enrichment-list ws_abc123

# List in pretty format
exa-ai enrichment-list ws_abc123 --output-format pretty
```

### enrichment-update

Update an enrichment configuration.

#### Syntax

```bash
exa-ai enrichment-update WEBSET_ID ENRICHMENT_ID [OPTIONS]
```

#### Required

- `WEBSET_ID`: Webset ID
- `ENRICHMENT_ID`: Enrichment ID

#### Options

- `--description TEXT`: Update extraction description
- `--format TYPE`: Update format (`text`, `url`, or `options`)
- `--options JSON`: Update options (for options format, supports @file.json)
- `--metadata JSON`: Update custom metadata (supports @file.json)
- `--api-key KEY`: Exa API key (or set EXA_API_KEY env var)
- `--output-format FMT`: `json`, `pretty`, or `text`

#### Examples

```bash
# Update title
exa-ai enrichment-update ws_abc123 enr_xyz789 --title "Team Size"

# Update description
exa-ai enrichment-update ws_abc123 enr_xyz789 \
  --description "Exact employee count as of latest data"

# Update options
exa-ai enrichment-update ws_abc123 enr_xyz789 \
  --options '[{"label":"1-10"},{"label":"11-50"},{"label":"51-200"},{"label":"201+"}]'

# Update metadata
exa-ai enrichment-update ws_abc123 enr_xyz789 \
  --metadata '{"updated":"2024-01-15","source":"company website"}'
```

### enrichment-delete

Delete an enrichment from a webset.

#### Syntax

```bash
exa-ai enrichment-delete WEBSET_ID ENRICHMENT_ID [OPTIONS]
```

#### Required

- `WEBSET_ID`: Webset ID
- `ENRICHMENT_ID`: Enrichment ID

#### Options

- `--force`: Skip confirmation prompt
- `--api-key KEY`: Exa API key (or set EXA_API_KEY env var)
- `--output-format FMT`: `json`, `pretty`, or `text`

#### Examples

```bash
# Delete enrichment with confirmation
exa-ai enrichment-delete ws_abc123 enr_xyz789

# Delete without confirmation
exa-ai enrichment-delete ws_abc123 enr_xyz789 --force
```

### enrichment-cancel

Cancel a running enrichment.

#### Syntax

```bash
exa-ai enrichment-cancel WEBSET_ID ENRICHMENT_ID [OPTIONS]
```

#### Required

- `WEBSET_ID`: Webset ID
- `ENRICHMENT_ID`: Enrichment ID

#### Options

- `--api-key KEY`: Exa API key (or set EXA_API_KEY env var)
- `--output-format FMT`: `json`, `pretty`, or `text`

#### Examples

```bash
# Cancel running enrichment
exa-ai enrichment-cancel ws_abc123 enr_xyz789
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

# Add funding stage
exa-ai enrichment-create $webset_id \
  --description "Current funding stage" \
  --format options \
  --options '[{"label":"Seed"},{"label":"Series A"},{"label":"Series B+"}]' \
  --title "Stage" \
  --wait

# List all enrichments
exa-ai enrichment-list $webset_id

# View enriched items
exa-ai webset-item-list $webset_id
```

## Complete Workflow: Create Webset with Enrichments

```bash
# Step 1: VALIDATE - Create with count:1 (NO enrichments)
webset_id=$(exa-ai webset-create \
  --search '{"query":"AI startups","count":1}' \
  --wait | jq -r '.webset_id')

# Review result
exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Verify result quality before continuing.**

```bash
# Step 2: EXPAND - Gradually increase count
exa-ai webset-search-create $webset_id \
  --query "AI startups" \
  --mode append \
  --count 2 \
  --wait

# Check quality
exa-ai webset-item-list $webset_id
```

**⚠️ REQUIRED: Repeat expansion (5, 10, 25, 50) until target size reached.**

```bash
# Step 3: ENRICH - Add enrichments after validation
exa-ai enrichment-create $webset_id \
  --description "Company website" --format url --title "Website" --wait

exa-ai enrichment-create $webset_id \
  --description "Funding stage" --format options \
  --options '[{"label":"Seed"},{"label":"Series A"},{"label":"Series B+"}]' \
  --title "Stage" --wait

exa-ai enrichment-create $webset_id \
  --description "Number of employees" --format text --title "Team Size" --wait

# View enriched results
exa-ai webset-item-list $webset_id
```

## Enrichment Best Practices

1. **Enrich after validation and expansion**: Never add enrichments during initial validation with count:1. Follow the three-step workflow.
2. **Use descriptive descriptions**: Clear descriptions help AI extract accurately. "Company website URL" is better than "website".
3. **Choose appropriate formats**:
   - Use `url` for links
   - Use `options` for categorical data with predefined choices
   - Use `text` for free-form data
4. **Add instructions for precision**: Provide additional context when extraction needs guidance
5. **Limit options to 10 or fewer**: Too many options reduce accuracy for categorical enrichments
6. **Use --wait for large websets**: See progress and catch errors early
7. **Review enriched results**: Check a sample before relying on extracted data

## Credit Costs

**Pricing**: $50/month = 8,000 credits ($0.00625 per credit)

**Enrichment costs**:
- Standard enrichment (text, url, options): 2 credits ($0.0125)
- Email enrichment: 5 credits ($0.03125)

**Examples**:
- 100 items + 2 enrichments = 400 credits ($2.50)
- 100 items + 5 enrichments = 1,000 credits ($6.25)
- 1,000 items + 3 enrichments = 6,000 credits ($37.50)

## Complete Options

For all available options for each command, run:

```bash
exa-ai enrichment-create --help
exa-ai enrichment-get --help
exa-ai enrichment-list --help
exa-ai enrichment-update --help
exa-ai enrichment-delete --help
exa-ai enrichment-cancel --help
```
