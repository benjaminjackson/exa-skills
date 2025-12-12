#!/usr/bin/env ruby
# frozen_string_literal: true

# Inline common requirements into SKILL.md files.
#
# This script replaces reference-based common requirements with the actual
# inlined content from docs/common-requirements.md, wrapped in XML tags.

require 'pathname'

# Parse common-requirements.md and extract each section
def parse_common_requirements(content)
  sections = {}

  # Extract content from named XML tags
  sections["Schema Design"] = content[/<schema-design>(.*?)<\/schema-design>/m, 1]&.strip
  sections["Output Format Selection"] = content[/<output-format-selection>(.*?)<\/output-format-selection>/m, 1]&.strip
  sections["Shell Command Best Practices"] = content[/<shell-command-best-practices>(.*?)<\/shell-command-best-practices>/m, 1]&.strip

  # Remove nil entries
  sections.compact
end

# Extract which sections this skill should have
def extract_section_list(skill_content)
  # Try 1: Old reference format with bullet list
  match = skill_content.match(
    /### Shared Requirements\s*\n.*?common-requirements\.md\):\s*\n((?:- .+\n?)+)/m
  )

  if match
    bullets = match[1]
    return bullets.split("\n").filter_map do |line|
      line = line.strip
      next unless line.start_with?('- ')
      line[2..].split('→')[0].strip
    end
  end

  # Try 2: XML-wrapped inlined content
  match = skill_content.match(
    /<shared-requirements>\s*\n(.*?)<\/shared-requirements>/m
  )

  return [] unless match

  section_content = match[1]

  # Extract section titles from #### headers and map back to reference names
  section_content.scan(/^#### (.+)$/).flatten.map do |title|
    case title
    when "Schema Design" then "schema design patterns"
    when "Output Format Selection" then "output format selection"
    when "Shell Command Best Practices" then "shell command best practices"
    else title.downcase
    end
  end
end

# Map section reference name to actual section title
def section_name_to_title(ref)
  mapping = {
    "schema design patterns" => "Schema Design",
    "output format selection" => "Output Format Selection",
    "shell command best practices" => "Shell Command Best Practices"
  }

  mapping[ref.downcase] || ref
end

# Inline requirements into a SKILL.md file
def inline_requirements(skill_path, sections)
  content = skill_path.read

  # Get list of sections to inline
  section_refs = extract_section_list(content)

  if section_refs.empty?
    puts "⚠️  #{skill_path.relative_path_from(Dir.pwd)}: No shared requirements found"
    return
  end

  # Build new inlined content
  new_section = []
  new_section << "### Shared Requirements"
  new_section << ""
  new_section << "<shared-requirements>"
  new_section << ""

  section_refs.each do |ref|
    section_title = section_name_to_title(ref)

    unless sections.key?(section_title)
      puts "⚠️  #{skill_path.relative_path_from(Dir.pwd)}: Section '#{section_title}' not found in common-requirements.md"
      next
    end

    section_content = sections[section_title]

    new_section << "#### #{section_title}"
    new_section << ""
    new_section << section_content
    new_section << ""
  end

  new_section << "</shared-requirements>"

  new_section_text = new_section.join("\n")

  # Replace the entire Shared Requirements section
  # Match from "### Shared Requirements" to next ###/## or end
  new_content = content.sub(
    /^### Shared Requirements\s*$.+?(?=^###|^##|\z)/m,
    new_section_text
  )

  if new_content != content
    skill_path.write(new_content)
    puts "✅ #{skill_path.relative_path_from(Dir.pwd)}: Inlined #{section_refs.size} sections"
  else
    puts "⚠️  #{skill_path.relative_path_from(Dir.pwd)}: No changes needed"
  end
end

# Main execution
root = Pathname.new(__dir__).parent

# Read common requirements
common_req_path = root / "docs" / "common-requirements.md"
unless common_req_path.exist?
  puts "❌ #{common_req_path} not found"
  exit 1
end

common_req_content = common_req_path.read
sections = parse_common_requirements(common_req_content)

puts "📚 Loaded #{sections.size} sections from common-requirements.md:"
sections.keys.each { |title| puts "   - #{title}" }
puts

# Find all SKILL.md files
skill_dirs = %w[exa-core exa-websets exa-research]
skill_files = []

skill_dirs.each do |skill_dir|
  dir_path = root / skill_dir
  skill_files.concat(dir_path.glob("**/SKILL.md")) if dir_path.exist?
end

if skill_files.empty?
  puts "❌ No SKILL.md files found"
  exit 1
end

puts "🔍 Found #{skill_files.size} SKILL.md files\n"

# Process each skill file
skill_files.sort.each do |skill_file|
  inline_requirements(skill_file, sections)
end

puts "\n✨ Done! Processed #{skill_files.size} files"
