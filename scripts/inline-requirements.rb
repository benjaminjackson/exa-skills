#!/usr/bin/env ruby
# frozen_string_literal: true

# Inline common requirements into SKILL.md files.
#
# Replaces content within <shared-requirements> tags or appends them if not found.

require 'pathname'

# Inline requirements into a SKILL.md file
def inline_requirements(skill_path, common_requirements_content)
  content = skill_path.read

  if content.include?("<shared-requirements>")
    # Replace existing tags and content
    new_content = content.gsub(
      /<shared-requirements>.*?<\/shared-requirements>/m,
      "<shared-requirements>\n\n#{common_requirements_content.strip}\n\n</shared-requirements>"
    )

    if new_content != content
      skill_path.write(new_content)
      puts "✅ #{skill_path.relative_path_from(Dir.pwd)}: Updated"
    else
      puts "⚠️  #{skill_path.relative_path_from(Dir.pwd)}: No changes needed"
    end
  else
    # Append to end of file
    new_content = content.rstrip + "\n\n### Shared Requirements\n\n<shared-requirements>\n\n#{common_requirements_content.strip}\n\n</shared-requirements>\n"
    skill_path.write(new_content)
    puts "✅ #{skill_path.relative_path_from(Dir.pwd)}: Added shared requirements"
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

common_requirements_content = common_req_path.read.strip

puts "📚 Loaded common requirements (#{common_requirements_content.lines.count} lines)\n"

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
  inline_requirements(skill_file, common_requirements_content)
end

puts "\n✨ Done! Processed #{skill_files.size} files"
