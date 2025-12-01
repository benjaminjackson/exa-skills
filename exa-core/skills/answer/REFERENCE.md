# answer

Generate an answer to a question using Exa AI.

## Syntax

```bash
exa-ai answer QUERY [OPTIONS]
```

## Required Arguments

- `QUERY`: Question or query to answer

## Common Options

### Output Control
- `--output-schema JSON`: JSON schema for structured output (must use object wrapper!)
- `--system-prompt TEXT`: System prompt to guide answer generation
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

### Content Options
- `--text`: Include full text content from sources

## Examples

### Basic Answer
```bash
exa-ai answer "What is Anthropic's main product?" --output-format toon
```

### Streaming Answer
```bash
exa-ai answer "What are the latest developments in LLM reasoning?" --stream
```

### Structured Output with Schema
```bash
exa-ai answer "What is Claude?" \
  --output-schema '{"type":"object","properties":{"product_name":{"type":"string"},"company":{"type":"string"},"description":{"type":"string"}}}' \
  --output-format toon
```

### Extract and Format with jq
```bash
exa-ai answer "What is the capital of France?" \
  --output-schema '{"type":"object","properties":{"city":{"type":"string"},"country":{"type":"string"},"population":{"type":"string"}}}' | jq -r '.answer | "\(.city), \(.country) - Population: \(.population)"'
```

### Array Output for Lists
```bash
exa-ai answer "What are the top 5 programming languages in 2024?" \
  --output-schema '{"type":"object","properties":{"languages":{"type":"array","items":{"type":"string"}}}}' | jq -r '.answer.languages | map("- " + .) | join("\n")'
```

### Nested Object Schema
```bash
exa-ai answer "Compare React and Vue" \
  --output-schema '{
    "type":"object",
    "properties":{
      "react":{
        "type":"object",
        "properties":{
          "pros":{"type":"array","items":{"type":"string"}},
          "cons":{"type":"array","items":{"type":"string"}}
        }
      },
      "vue":{
        "type":"object",
        "properties":{
          "pros":{"type":"array","items":{"type":"string"}},
          "cons":{"type":"array","items":{"type":"string"}}
        }
      }
    }
  }'
```

### Custom System Prompt
```bash
exa-ai answer "Explain quantum computing" \
  --system-prompt "Respond in simple terms suitable for a high school student"
```

### Answer with Source Text
```bash
exa-ai answer "What are the key features of GPT-4?" --text
```

## Schema Design Tips

Always use object wrapper with `properties`. Examples of common patterns:

```json
// Simple fields
{"type":"object","properties":{"answer":{"type":"string"}}}

// Arrays
{"type":"object","properties":{"items":{"type":"array","items":{"type":"string"}}}}
```

_See earlier examples for complex nested schemas._

