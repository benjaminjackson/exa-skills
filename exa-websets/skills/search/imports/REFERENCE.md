# Imports

Upload external data (CSV files) to create websets from existing datasets.

## Commands

### import-create

Create a new import from a CSV file.

#### Syntax

```bash
exa-ai import-create FILE --count N --title TEXT --format csv --entity-type TYPE [OPTIONS]
```

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
# Create import from CSV file (prepare your CSV file first)
import_id=$(exa-ai import-create companies.csv \
  --count 100 \
  --title "Portfolio Companies" \
  --format csv \
  --entity-type company | jq -r '.import_id')

# Create webset from import
webset_id=$(exa-ai webset-create --import $import_id --wait | jq -r '.webset_id')

# Add enrichments
exa-ai enrichment-create $webset_id \
  --description "Employee count" \
  --format text \
  --title "Team Size" \
  --wait

# View items
exa-ai webset-item-list $webset_id
```

