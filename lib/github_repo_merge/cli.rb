require 'thor'

class MergeCli < Thor
  desc 'merge file.yml', 'Merge GitHub repositories as specified in YAML file'
  option :dry_run, :type => :boolean, :aliases => '-n'
  def merge(file)
    puts "Merging GitHub repositories specified in #{file}"
  end
end
