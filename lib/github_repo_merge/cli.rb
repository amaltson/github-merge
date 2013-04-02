require 'thor'
require_relative 'merge'

class MergeCli < Thor
  desc 'merge file.yml', 'Merge GitHub repositories as specified in YAML file'
  option :dry_run, :type => :boolean, :aliases => '-n'
  def merge(file)
    puts "Merging GitHub repositories specified in #{file}"
    Merge.new(file, options).merge!
  end
end
