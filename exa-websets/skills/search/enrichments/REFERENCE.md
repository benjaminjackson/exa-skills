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

#### Key Parameters

- **description** (required): The primary AI extraction prompt that tells the enrichment what to extract. This drives the extraction logic.
- **format** (required): Output type - text, url, or options
- **instructions** (optional, creation-only): Additional guidance on HOW to extract or format. Cannot be changed after creation - only available during enrichment-create.
- **title** (optional): Display name for the enrichment field
- **options** (required for options format): Array of categorical choices
- **metadata** (optional): Custom metadata object

**TIP**: Check all available parameters with `exa-ai enrichment-create --help`

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
  --title "Team Size"
```

##### URL Enrichment

```bash
exa-ai enrichment-create ws_abc123 \
  --description "Company website" \
  --format url \
  --title "Website"
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
  --title "Funding"
```

##### With Instructions

```bash
exa-ai enrichment-create ws_abc123 \
  --description "Technology stack" \
  --format text \
  --instructions "Focus on backend technologies only" \
  --title "Tech Stack"
```

##### With Metadata

```bash
exa-ai enrichment-create ws_abc123 \
  --description "Company valuation" \
  --format text \
  --title "Valuation" \
  --metadata '{"source":"public filings","confidence":"high"}'
```

### enrichment-update

Update an existing enrichment's properties.

#### What Can Be Updated

You can update:
- **description**: The AI extraction prompt (what to extract)
- **format**: The output type (text, url, options)
- **options**: Available choices (for options format only)
- **metadata**: Custom metadata object

#### Creation-Only Parameters

These parameters can ONLY be set during `enrichment-create` and CANNOT be updated:
- **instructions**: Additional formatting/scope guidance
- **title**: The enrichment field name

**Why this matters**: If you need to change instructions, you must delete and recreate the enrichment.

#### Understanding Description vs Instructions

- **description**: The primary prompt that tells the AI what to extract. This is required and drives the extraction logic.
- **instructions** (creation-only): Optional additional guidance on HOW to extract or format. Examples: "Focus on backend technologies only" or "Use ISO date format".

**TIP**: Check available parameters with `exa-ai enrichment-update --help`

#### Syntax

```bash
exa-ai enrichment-update WEBSET_ID ENRICHMENT_ID [OPTIONS]
```

#### Examples

##### Update Extraction Prompt

```bash
exa-ai enrichment-update ws_abc123 enr_xyz789 \
  --description "Exact employee count from most recent source"
```

##### Update Options for Categorical Data

```bash
exa-ai enrichment-update ws_abc123 enr_xyz789 \
  --format options \
  --options '[
    {"label":"Pre-seed"},
    {"label":"Seed"},
    {"label":"Series A"},
    {"label":"Series B+"}
  ]'
```

##### Update Metadata

```bash
exa-ai enrichment-update ws_abc123 enr_xyz789 \
  --metadata '{"updated":"2024-01-15","source":"manual review"}'
```

##### Update Description and Format Together

```bash
exa-ai enrichment-update ws_abc123 enr_xyz789 \
  --description "Company size category" \
  --format options \
  --options '[
    {"label":"1-10"},
    {"label":"11-50"},
    {"label":"51-200"},
    {"label":"201+"}
  ]'
```

### enrichment-delete

Delete an enrichment from a webset.

#### Syntax

```bash
exa-ai enrichment-delete WEBSET_ID ENRICHMENT_ID [OPTIONS]
```

### enrichment-cancel

Cancel a running enrichment.

#### Syntax

```bash
exa-ai enrichment-cancel WEBSET_ID ENRICHMENT_ID [OPTIONS]
```

## Complete Example: Enrich Company Webset

```bash
webset_id="ws_abc123"

# Add website URL
exa-ai enrichment-create $webset_id \
  --description "Company website" \
  --format url \
  --title "Website"

# Add employee count
exa-ai enrichment-create $webset_id \
  --description "Number of employees" \
  --format text \
  --title "Team Size"

# Add industry category
exa-ai enrichment-create $webset_id \
  --description "Primary industry" \
  --format options \
  --options '[{"label":"SaaS"},{"label":"Hardware"},{"label":"Biotech"},{"label":"Other"}]' \
  --title "Industry"
```
