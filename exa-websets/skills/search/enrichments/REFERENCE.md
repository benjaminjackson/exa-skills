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
```
