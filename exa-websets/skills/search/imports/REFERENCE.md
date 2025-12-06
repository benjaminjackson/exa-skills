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
  --count 5 \
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
webset_id=$(exa-ai webset-create --import $import_id | jq -r '.webset_id')

echo "Created webset: $webset_id"
```

## CSV Format Requirements

- First row should contain column headers
- Each row represents one entity
- At minimum, include a url or linkedin column

Example CSV structure:

```csv
name,url,location
Acme Corp,https://acme.com,San Francisco
TechStart,https://techstart.io,New York
DataCo,https://dataco.com,Austin
```
