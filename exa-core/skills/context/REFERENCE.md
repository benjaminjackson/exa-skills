# context

Get code context from repositories.

## Syntax

```bash
exa-ai context QUERY [OPTIONS]
```

## Required Arguments

- `QUERY`: Search query for code context

## Common Options

- `--tokens-num NUM`: Number of tokens for response (or `dynamic`, default: `dynamic`)
- `--output-format FMT`: `json`, `pretty`, `text`, or `toon`

## Examples

### Basic Context Retrieval
```bash
exa-ai context "React hooks useState useEffect" --output-format toon
```

### Specific Token Limit
```bash
exa-ai context "Python async/await patterns" --tokens-num 5000
```

### Authentication Patterns
```bash
exa-ai context "JWT authentication with Ruby on Rails" \
  --tokens-num 3000 \
  --output-format toon
```

### Extract Context Text
```bash
exa-ai context "GraphQL schema design best practices" \
  --tokens-num 4000 | jq -r '.context'
```

### Text Format for Direct Use
```bash
# Get raw context text without JSON wrapper
exa-ai context "Docker multi-stage builds" --output-format text
```

### Framework-Specific Context
```bash
exa-ai context "Next.js 14 server components" --tokens-num 5000
```

### Testing Patterns
```bash
exa-ai context "Jest testing async functions" --tokens-num 3000
```

### Database Query Optimization
```bash
exa-ai context "PostgreSQL query optimization indexes" --tokens-num 4000
```

### API Design Patterns
```bash
exa-ai context "RESTful API design principles" --tokens-num 5000 --output-format toon
```

_Note: See SKILL.md for token optimization strategies._

