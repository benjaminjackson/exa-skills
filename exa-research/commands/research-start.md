# research-start

Start a research task using Exa AI.

## Syntax

```bash
exa-ai research-start --instructions "TEXT" [OPTIONS]
```

## Required Options

- `--instructions TEXT`: Research instructions describing what you want to research

## Common Options

### Model Selection
- `--model MODEL`: Research model to use
  - `exa-research` (default): Balanced speed and quality
  - `--research-pro`: Higher quality, more comprehensive results
  - `exa-research-fast`: Faster results, good for simpler research

### Output Control
- `--output-schema JSON`: JSON schema for structured output (must use object wrapper!)
- `--wait`: Wait for task to complete (polls until done)
- `--events`: Include event log in output (only works with `--wait`)
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

## Examples

### Basic Research Task
```bash
exa-ai research-start --instructions "Find the top 10 Ruby performance optimization techniques with code examples"
```

Returns a research ID for later retrieval.

### Research with Wait (Recommended)
```bash
# Start and automatically wait for completion
exa-ai research-start \
  --instructions "Analyze recent trends in AI safety research" \
  --wait
```

### Research with Events Log
```bash
# See what steps the research took
exa-ai research-start \
  --instructions "Compare Rust vs Go for systems programming" \
  --wait \
  --events
```

### Research with Structured Output
```bash
exa-ai research-start \
  --instructions "Find the top 5 JavaScript frameworks and their pros/cons" \
  --output-schema '{
    "type":"object",
    "properties":{
      "frameworks":{
        "type":"array",
        "items":{
          "type":"object",
          "properties":{
            "name":{"type":"string"},
            "pros":{"type":"array","items":{"type":"string"}},
            "cons":{"type":"array","items":{"type":"string"}}
          }
        }
      }
    }
  }' \
  --wait
```

### Using Research Models

#### Fast Research (Simple Queries)
```bash
exa-ai research-start \
  --instructions "What are webhooks and how do they work?" \
  --model exa-research-fast \
  --wait
```

#### Pro Research (Comprehensive Analysis)
```bash
exa-ai research-start \
  --instructions "Comprehensive analysis of microservices vs monolithic architecture with real-world case studies" \
  --model exa-research-pro \
  --wait
```

#### Default Research (Balanced)
```bash
exa-ai research-start \
  --instructions "Latest developments in large language model reasoning capabilities" \
  --wait
```

### Save Research ID for Later
```bash
# Start research and save ID
research_id=$(exa-ai research-start \
  --instructions "Research GraphQL adoption trends 2024" | jq -r '.research_id')

echo "Research ID: $research_id"

# Check later with research-get
# exa-ai research-get $research_id
```

### Complex Research with Nested Schema
```bash
exa-ai research-start \
  --instructions "Compare the top 3 cloud providers: AWS, Azure, and GCP. Include pricing, features, and best use cases" \
  --output-schema '{
    "type":"object",
    "properties":{
      "providers":{
        "type":"array",
        "items":{
          "type":"object",
          "properties":{
            "name":{"type":"string"},
            "pricing_model":{"type":"string"},
            "key_features":{"type":"array","items":{"type":"string"}},
            "best_for":{"type":"string"}
          }
        }
      },
      "recommendation":{"type":"string"}
    }
  }' \
  --model exa-research-pro \
  --wait
```

## Workflow Patterns

### Pattern 1: Quick Research with Wait
```bash
# Simplest approach - start and wait in one command
exa-ai research-start \
  --instructions "Find best practices for React performance optimization" \
  --wait
```

### Pattern 2: Background Research
```bash
# Start research, do other work, check later
research_id=$(exa-ai research-start \
  --instructions "Analyze competitor landscape for AI coding tools" | jq -r '.research_id')

# ... do other work ...

# Check status later
exa-ai research-get $research_id
```

### Pattern 3: Structured Output for Processing
```bash
# Get structured data for further processing
result=$(exa-ai research-start \
  --instructions "Find the top 5 programming languages for web development in 2024" \
  --output-schema '{
    "type":"object",
    "properties":{
      "languages":{"type":"array","items":{"type":"string"}}
    }
  }' \
  --wait)

# Extract and process
echo "$result" | jq -r '.result.languages[]'
```

## Return Values

### Without --wait
```json
{
  "research_id": "research_abc123",
  "status": "pending"
}
```

### With --wait
```json
{
  "research_id": "research_abc123",
  "status": "completed",
  "result": "... research results ..."
}
```

### With --wait --events
```json
{
  "research_id": "research_abc123",
  "status": "completed",
  "result": "... research results ...",
  "events": [
    {"type": "search", "query": "..."},
    {"type": "analyze", "content": "..."}
  ]
}
```

## Complete Options

For all available options, run:
```bash
exa-ai research-start --help
```
