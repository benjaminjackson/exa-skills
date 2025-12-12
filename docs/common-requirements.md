# Common Requirements

Critical requirements that apply across multiple exa-ai skills.

**Purpose**: This file consolidates shared rules to reduce duplication across SKILL.md files and improve token efficiency. Individual skills reference these requirements instead of repeating them.

---

## Schema Design

### MUST: Use object wrapper for schemas

**Applies to**: answer, search, find-similar, get-contents

When using schema parameters (`--output-schema` or `--summary-schema`), always wrap properties in an object.

**Note**: This is a JSON Schema requirement, not an Exa-specific limitation.

```json
{"type":"object","properties":{"field_name":{"type":"string"}}}
```

**DO NOT** use bare properties without the object wrapper:
```json
{"properties":{"field_name":{"type":"string"}}}  // ❌ Missing "type":"object"
```

**Why**: The Exa API requires a valid JSON Schema with an object type at the root level. Omitting this causes validation errors.

**Examples**:
```bash
# ✅ CORRECT - object wrapper included
exa-ai search "AI news" \
  --summary-schema '{"type":"object","properties":{"headline":{"type":"string"}}}'

# ❌ WRONG - missing object wrapper
exa-ai search "AI news" \
  --summary-schema '{"properties":{"headline":{"type":"string"}}}'
```

---

## Output Format Selection

### MUST NOT: Mix toon format with jq

**Applies to**: answer, context, search, find-similar, get-contents

`toon` format produces YAML-like output, not JSON. DO NOT pipe toon output to jq for parsing:

```bash
# ❌ WRONG - toon is not JSON
exa-ai search "query" --output-format toon | jq -r '.results'

# ✅ CORRECT - use JSON (default) with jq
exa-ai search "query" | jq -r '.results[].title'

# ✅ CORRECT - use toon for direct reading only
exa-ai search "query" --output-format toon
```

**Why**: jq expects valid JSON input. toon format is designed for human readability and produces YAML-like output that jq cannot parse.

### SHOULD: Choose one output approach

**Applies to**: answer, context, search, find-similar, get-contents

Pick one strategy and stick with it throughout your workflow:

1. **Approach 1: toon only** - Compact YAML-like output for direct reading
   - Use when: Reading output directly, no further processing needed
   - Token savings: ~40% reduction vs JSON
   - Example: `exa-ai search "query" --output-format toon`

2. **Approach 2: JSON + jq** - Extract specific fields programmatically
   - Use when: Need to extract specific fields or pipe to other commands
   - Token savings: ~80-90% reduction (extracts only needed fields)
   - Example: `exa-ai search "query" | jq -r '.results[].title'`

3. **Approach 3: Schemas + jq** - Structured data extraction with validation
   - Use when: Need consistent structured output across multiple queries
   - Token savings: ~85% reduction + consistent schema
   - Example: `exa-ai search "query" --summary-schema '{...}' | jq -r '.results[].summary | fromjson'`

**Why**: Mixing approaches increases complexity and token usage. Choosing one approach optimizes for your use case.

---

## Shell Command Best Practices

### MUST: Run commands directly, parse separately

**Applies to**: monitor, search (websets), research, and all skills using complex commands

When using the Bash tool with complex shell syntax, run commands directly and parse output in separate steps:

```bash
# ❌ WRONG - nested command substitution
webset_id=$(exa-ai webset-create --search '{"query":"..."}' | jq -r '.webset_id')

# ✅ CORRECT - run directly, then parse
exa-ai webset-create --search '{"query":"..."}'
# Then in a follow-up command:
webset_id=$(cat output.json | jq -r '.webset_id')
```

**Why**: Complex nested `$(...)` command substitutions can fail unpredictably in shell environments. Running commands directly and parsing separately improves reliability and makes debugging easier.

### MUST NOT: Use nested command substitutions

**Applies to**: All skills when using complex multi-step operations

Avoid nesting multiple levels of command substitution:

```bash
# ❌ WRONG - deeply nested
result=$(exa-ai search "$(cat query.txt | tr '\n' ' ')" --num-results $(cat config.json | jq -r '.count'))

# ✅ CORRECT - sequential steps
query=$(cat query.txt | tr '\n' ' ')
count=$(cat config.json | jq -r '.count')
exa-ai search "$query" --num-results $count
```

**Why**: Nested command substitutions are fragile and hard to debug when they fail. Sequential steps make each operation explicit and easier to troubleshoot.

### SHOULD: Break complex commands into sequential steps

**Applies to**: All skills when working with multi-step workflows

For readability and reliability, break complex operations into clear sequential steps:

```bash
# ❌ Less maintainable - everything in one line
exa-ai webset-create --search '{"query":"startups","count":1}' | jq -r '.webset_id' | xargs -I {} exa-ai webset-search-create {} --query "AI" --behavior override

# ✅ More maintainable - clear steps
exa-ai webset-create --search '{"query":"startups","count":1}'
webset_id=$(jq -r '.webset_id' < output.json)
exa-ai webset-search-create $webset_id --query "AI" --behavior override
```

**Why**: Sequential steps are easier to understand, debug, and modify. Each step can be verified independently.

---

## Reference Guide

### How Skills Use This File

Individual SKILL.md files have these common requirements **inlined** (not referenced) in their Critical Requirements section.

When you update this file, run `scripts/inline-requirements.rb` to propagate changes to all SKILL.md files.

**Why inlining instead of references?**
Skills are loaded in isolation by Claude Code. Markdown references to other files aren't guaranteed to be loaded, so we inline the content directly to ensure it's always available.

### Token Efficiency Benefits

**Before** (duplicated across 4 skills):
- Schema wrapper rule: ~60 tokens × 4 = 240 tokens
- Output format rule: ~80 tokens × 5 = 400 tokens
- Shell command rule: ~70 tokens × 3 = 210 tokens
- **Total**: 850 tokens

**After** (with common-requirements.md):
- Reference in each skill: ~20 tokens × N skills = ~160 tokens
- Common requirements (loaded once): ~500 tokens
- **Total**: ~660 tokens
- **Savings**: ~22% reduction (increases with more shared rules)

### When to Add New Common Requirements

Add a rule to this file when:
1. The rule applies to 3+ skills
2. The rule has identical wording across skills
3. The rule describes a fundamental constraint or best practice
4. Centralizing it would reduce confusion and maintenance burden

### When to Keep Rules in Individual Skills

Keep a rule in an individual SKILL.md when:
1. The rule is specific to that tool's unique functionality
2. The rule applies to only 1-2 skills
3. The rule requires tool-specific context or examples
4. The rule describes edge cases specific to that tool

---

## Version History

- **2025-12-09**: Initial creation with schema design, output format, and shell command requirements
