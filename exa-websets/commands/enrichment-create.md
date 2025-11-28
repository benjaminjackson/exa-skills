# enrichment-create

Create a new enrichment for a webset.

## Syntax

```bash
exa-ai enrichment-create WEBSET_ID --description TEXT --format TYPE [OPTIONS]
```

## Required

- `WEBSET_ID`: Webset ID
- `--description TEXT`: What to extract
- `--format TYPE`: `text`, `url`, or `options`

## Common Options

- `--title TEXT`: Display title
- `--options JSON`: Array of {"label":"..."} (required if format=options)
- `--instructions TEXT`: Additional instructions
- `--wait`: Wait for enrichment to complete
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

## Enrichment Formats

- **text**: Free-form text extraction
- **url**: Extract URLs
- **options**: Categorical data (predefined options)

## Examples

### Text Enrichment
```bash
exa-ai enrichment-create ws_abc123 \
  --description "Company size (number of employees)" \
  --format text \
  --wait
```

### URL Enrichment
```bash
exa-ai enrichment-create ws_abc123 \
  --description "Company website" \
  --format url \
  --title "Website" \
  --wait
```

### Options Enrichment (Categorical)
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

### Options from File
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

### With Instructions
```bash
exa-ai enrichment-create ws_abc123 \
  --description "Technology stack" \
  --format text \
  --instructions "Focus on backend technologies only" \
  --title "Tech Stack" \
  --wait
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

## Complete Options

For all available options, run:
```bash
exa-ai enrichment-create --help
```
