---
name: exa-research
description: Use when the user mentions Exa research OR when the workflow benefits from complex, multi-step research and other exa-ai approaches are not yielding satisfactory results.
---

# Exa Research Tasks

Manage asynchronous research tasks with exa-ai for complex, multi-step research workflows.

**Use `--help` to see available commands and verify usage before running:**
```bash
exa-ai <command> --help
```

## Working with Complex Shell Commands

When using the Bash tool with complex shell syntax, follow these best practices for reliability:

1. **Run commands directly**: Capture JSON output directly rather than nesting command substitutions
2. **Parse in subsequent steps**: Use `jq` to parse output in a follow-up command if needed
3. **Avoid nested substitutions**: Complex nested `$(...)` can be fragile; break into sequential steps

Example:
```bash
# Less reliable: nested command substitution
results=$(exa-ai research-start --instructions "query" | jq -r '.result')

# More reliable: run directly, then parse
exa-ai research-start --instructions "query"
# Then in a follow-up command if needed:
exa-ai research-get research_id | jq -r '.result'
```

## Cost Optimization

### Pricing
Research is the most expensive Exa endpoint:
- **Agent search**: $0.005 per search operation
- **Standard page read**: $0.005 per page
- **Pro page read**: $0.010 per page (2x standard)
- **Reasoning tokens**: $0.000005 per token

**Cost strategy:**
- **Avoid research unless required**: Most expensive option (2-10x cost premium over other endpoints)
- Use only for autonomous, multi-step reasoning tasks that justify the cost
- For simpler queries, use `search`, `answer`, or `get-contents` instead
- Consider using `exa-research` (standard) instead of `exa-research-pro` unless you need the higher quality

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
exa-ai research-start --instructions "Find the top 10 Ruby performance optimization techniques"
```

For detailed options and examples, consult [REFERENCE.md](REFERENCE.md#research-start).

### research-get
Check status and retrieve results of a research task.

```bash
exa-ai research-get research_abc123
```

For detailed options and examples, consult [REFERENCE.md](REFERENCE.md#research-get).

### research-list
List all your research tasks with pagination.

```bash
exa-ai research-list --limit 10
```

For detailed options and examples, consult [REFERENCE.md](REFERENCE.md#research-list).

## Research Models

- **exa-research** (default): Balanced speed and quality
- **exa-research-pro**: Higher quality, more comprehensive results
- **exa-research-fast**: Faster results, good for simpler research

## Quick Examples

### Simple Research
```bash
exa-ai research-start \
  --instructions "Find the latest breakthroughs in quantum computing"
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
  }'
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
  exa-ai research-get $research_id | jq -r '.result'
fi
```

### Use Pro Model for Comprehensive Research
```bash
exa-ai research-start \
  --instructions "Comprehensive analysis of microservices vs monolithic architecture with case studies" \
  --model exa-research-pro \
  --events
```
