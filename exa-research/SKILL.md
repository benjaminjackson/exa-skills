---
name: exa-research
description: Use when the user mentions Exa research OR when the workflow benefits from complex, multi-step research and other exa-ai approaches are not yielding satisfactory results.
---

# Exa Research Tasks

Manage asynchronous research tasks with exa-ai for complex, multi-step research workflows.

## Research Overview

Research tasks are asynchronous operations that allow you to:
- Run complex, multi-step research workflows
- Process large amounts of information over time
- Monitor progress of long-running research
- Get structured output from comprehensive research

### When to Use Research vs Search

**Use research-start** when:
- The research requires multiple steps or complex reasoning
- You need comprehensive analysis of a topic
- The task will take significant time to complete
- You want structured, synthesized output

**Use search** (from exa-core) when:
- You need immediate results
- The query is straightforward
- You want quick factual information

## Commands

### research-start
Initiate a new research task with instructions.

```bash
exa-ai research-start --instructions "Find the top 10 Ruby performance optimization techniques" --wait
```

For detailed options and examples, consult [commands/research-start.md](commands/research-start.md).

### research-get
Check status and retrieve results of a research task.

```bash
exa-ai research-get research_abc123
```

For detailed options and examples, consult [commands/research-get.md](commands/research-get.md).

### research-list
List all your research tasks with pagination.

```bash
exa-ai research-list --limit 10
```

For detailed options and examples, consult [commands/research-list.md](commands/research-list.md).

## Research Models

- **exa-research** (default): Balanced speed and quality
- **exa-research-pro**: Higher quality, more comprehensive results
- **exa-research-fast**: Faster results, good for simpler research

## Quick Examples

### Simple Research with Wait
```bash
exa-ai research-start \
  --instructions "Find the latest breakthroughs in quantum computing" \
  --wait
```

### Research with Structured Output
```bash
exa-ai research-start \
  --instructions "Compare TypeScript vs Flow for type checking" \
  --output-schema '{
    "type":"object",
    "properties":{
      "typescript":{
        "type":"object",
        "properties":{
          "pros":{"type":"array","items":{"type":"string"}},
          "cons":{"type":"array","items":{"type":"string"}}
        }
      },
      "flow":{
        "type":"object",
        "properties":{
          "pros":{"type":"array","items":{"type":"string"}},
          "cons":{"type":"array","items":{"type":"string"}}
        }
      }
    }
  }' \
  --wait
```

### Background Research Workflow
```bash
# Start research
research_id=$(exa-ai research-start \
  --instructions "Analyze competitor landscape for project management tools" | jq -r '.research_id')

# Check status later
status=$(exa-ai research-get $research_id | jq -r '.status')

# Get results when complete
if [ "$status" = "completed" ]; then
  exa-ai research-get $research_id --output-format toon | jq -r '.result'
fi
```

### Use Pro Model for Comprehensive Research
```bash
exa-ai research-start \
  --instructions "Comprehensive analysis of microservices vs monolithic architecture with case studies" \
  --model exa-research-pro \
  --wait \
  --events
```
