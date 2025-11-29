# Exa Skills

AI-powered search, code context, and data collection for Claude Code via Exa.ai.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Usage](#usage)
- [What's Included](#whats-included)
- [Documentation](#documentation)
- [Example Workflows](#example-workflows)
- [License](#license)
- [Support](#support)

## Overview

Three specialized skills that help Claude use [Exa.ai](https://exa.ai) via the [exa-ruby](https://github.com/benjaminjackson/exa-ruby) library:

- **exa-core**: Core search commands (search, find-similar, answer, context, get-contents)
- **exa-research**: Async research task management
- **exa-websets**: Data collection and automation (websets, enrichments, imports, monitors)

## Installation

Install from the Claude Code plugin marketplace:

```
/plugin marketplace add benjaminjackson/exa-skills
/plugin install exa-core@exa-skills
```

Or browse and install via the `/plugin` menu.

**Prerequisites:**

1. **Exa API key** (get one from [dashboard.exa.ai](https://dashboard.exa.ai) - note: Exa has usage-based pricing)
2. **exa-ai Ruby gem**:
   ```bash
   gem install exa-ai
   ```

3. **Set your API key**:
   ```bash
   export EXA_API_KEY="your-api-key-here"
   ```

The plugin provides all three skills (exa-core, exa-research, exa-websets) in one install.

## Usage

The skills activate automatically when you use the exa-ruby library with Claude:

```
You: "Use exa to search for AI safety research"
Claude: [Uses exa-core skill with best practices]

You: "Create a webset to track competitors"
Claude: [Uses exa-websets skill]

You: "Start a research task analyzing ML trends"
Claude: [Uses exa-research skill]
```

## What's Included

### exa-core
- Core search methods (search, find_similar, answer, context, get_contents)
- Schema validation
- Custom summary queries
- Best practices for Ruby API usage

### exa-research
- Async research task workflows
- Multiple research models (fast, default, pro)
- Structured output
- Event logging

### exa-websets
- Build and manage data collections
- Enrich with structured fields
- Import CSV data
- Automate with monitors
- 28 commands across the websets ecosystem

## Documentation

Each skill includes:
- **SKILL.md**: Quick reference loaded when skill is invoked (~120-135 lines)
- **reference/**: Detailed per-command documentation loaded when needed

Browse the documentation:
- [exa-core/](./exa-core/) - 5 core search commands
- [exa-research/](./exa-research/) - 3 async research commands
- [exa-websets/](./exa-websets/) - 28 commands for data collection

## Example Workflows

### Search and Extract
```
You: "Search for 'AI research papers' and extract titles and summaries"
Claude: [Uses exa-core with the Ruby client]
```

### Build Collection
```
You: "Create a webset of SaaS companies, enrich with website URLs and team size, then set up daily monitoring"
Claude: [Uses exa-websets via the Ruby API]
```

### Research Task
```
You: "Research the top 5 programming languages for 2024 and return as structured data"
Claude: [Uses exa-research with structured output]
```

## License

MIT License - see [LICENSE](./LICENSE)

## Support

- **Author**: Benjamin Jackson ([@benjaminjackson](https://github.com/benjaminjackson))
- **Issues**: [GitHub Issues](https://github.com/benjaminjackson/exa-skills/issues)
- **Exa.ai**: [Exa Documentation](https://docs.exa.ai)
- **Claude Code**: [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
