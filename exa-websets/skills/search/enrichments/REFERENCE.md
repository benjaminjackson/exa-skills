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

_Note: See main SKILL.md for the complete three-step workflow, enrichment best practices, and credit costs._

