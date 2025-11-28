# Exa Skills

Claude Code skills for using Exa.ai efficiently.

## Overview

Three specialized skills that help Claude use [Exa.ai](https://exa.ai) via the [exa-ruby](https://github.com/benjaminjackson/exa-ruby) library:

- **exa-core**: Core search commands (search, find-similar, answer, context, get-contents)
- **exa-research**: Async research task management
- **exa-websets**: Data collection and automation (websets, enrichments, imports, monitors)

## Installation

### Prerequisites

1. Install the exa-ai Ruby gem:
   ```bash
   gem install exa-ai
   ```

   Or add to your Gemfile:
   ```ruby
   gem 'exa-ai'
   ```

2. Set your API key (get one from [dashboard.exa.ai](https://dashboard.exa.ai)):
   ```bash
   export EXA_API_KEY="your-api-key-here"
   ```

### Install Plugin

```bash
# Clone this repository to ~/github/exa-skills
git clone https://github.com/benjaminjackson/exa-skills.git ~/github/exa-skills

# Claude Code will auto-discover it - no other steps needed!
```

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
- **commands/**: Detailed per-command documentation loaded when needed

Browse the documentation:
- [exa-core/](./exa-core/) - 5 core search commands
- [exa-research/](./exa-research/) - 3 async research commands
- [exa-websets/](./exa-websets/) - 28 commands for data collection

### Documentation Structure

The skills use a token-optimized structure:
- SKILL.md provides essential information and examples
- Each command has its own detailed documentation file
- Claude progressively loads command docs only when needed
- Result: 30% reduction in tokens on skill invocation

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

## Verification

To verify installation:

1. Check the plugin directory exists:
   ```bash
   ls ~/github/exa-skills/.claude-plugin/marketplace.json
   ```

2. Verify the Ruby gem is installed:
   ```bash
   gem list exa-ai
   ```

3. In Claude Code, try:
   ```
   Use exa to search for "test query"
   ```

Claude should automatically use the skills with best practices.

## Contributing

Contributions welcome! See individual skill directories for documentation structure.

1. Fork the repository
2. Create a feature branch
3. Test with Claude Code
4. Submit a pull request

## License

MIT License - see [LICENSE](./LICENSE)

## Credits

Created by Benjamin Jackson ([@benjaminjackson](https://github.com/benjaminjackson))

For [Claude Code](https://claude.com/claude-code) and [Exa.ai](https://exa.ai)

Version 1.0.0
