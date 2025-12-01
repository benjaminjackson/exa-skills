# Imports

Upload external data (CSV files) to create websets from existing datasets.

## Commands

### import-create

Create a new import from a CSV file.

#### Syntax

```bash
exa-ai import-create FILE --count N --title TEXT --format csv --entity-type TYPE [OPTIONS]
```

#### Required

- `FILE`: Path to CSV file
- `--count N`: Number of rows to import
- `--title TEXT`: Title for the import
- `--format csv`: File format (currently only CSV supported)
- `--entity-type TYPE`: Entity type (company, person, article, research_paper, custom)

#### Options

- `--entity-description TEXT`: Custom description (required if entity-type=custom)
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

##### Basic CSV Import

```bash
exa-ai import-create companies.csv \
  --count 100 \
  --title "Tech Companies" \
  --format csv \
  --entity-type company
```

##### Import with Custom Entity Type

```bash
exa-ai import-create products.csv \
  --count 50 \
  --title "Product List" \
  --format csv \
  --entity-type custom \
  --entity-description "Consumer electronics products"
```

##### Save Import ID and Create Webset

```bash
# Create import
import_id=$(exa-ai import-create companies.csv \
  --count 100 \
  --title "Companies" \
  --format csv \
  --entity-type company | jq -r '.import_id')

# Create webset from import
webset_id=$(exa-ai webset-create --import $import_id --wait | jq -r '.webset_id')

echo "Created webset: $webset_id"
```

### import-list

List all imports in your account.

#### Syntax

```bash
exa-ai import-list [OPTIONS]
```

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# List all imports
exa-ai import-list

# List in JSON format
exa-ai import-list --output-format json
```

### import-get

Get details about a specific import.

#### Syntax

```bash
exa-ai import-get IMPORT_ID [OPTIONS]
```

#### Required

- `IMPORT_ID`: Import ID

#### Options

- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

#### Examples

```bash
# Get import details
exa-ai import-get imp_abc123

# Get in JSON format
exa-ai import-get imp_abc123 --output-format json
```

## CSV Format Requirements

- First row should contain column headers
- Each row represents one entity
- At minimum, include a name or identifier column
- Additional columns will be available in the webset

Example CSV structure:

```csv
name,website,location
Acme Corp,https://acme.com,San Francisco
TechStart,https://techstart.io,New York
DataCo,https://dataco.com,Austin
```

## Example Workflow

```bash
# 1. Prepare CSV file
cat > companies.csv <<'EOF'
name,website,industry
Acme Corp,https://acme.com,SaaS
TechStart,https://techstart.io,AI
DataCo,https://dataco.com,Analytics
EOF

# 2. Create import
import_id=$(exa-ai import-create companies.csv \
  --count 3 \
  --title "Portfolio Companies" \
  --format csv \
  --entity-type company | jq -r '.import_id')

# 3. Check import status
exa-ai import-get $import_id

# 4. Create webset from import
webset_id=$(exa-ai webset-create --import $import_id --wait | jq -r '.webset_id')

# 5. Add enrichments to the webset
exa-ai enrichment-create $webset_id \
  --description "Employee count" \
  --format text \
  --title "Team Size" \
  --wait

# 6. View items
exa-ai webset-item-list $webset_id
```

## Complete Options

For all available options for each command, run:

```bash
exa-ai import-create --help
exa-ai import-list --help
exa-ai import-get --help
```
