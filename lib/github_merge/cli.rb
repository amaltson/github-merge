require 'thor'
require_relative 'merge'

class MergeCli < Thor
  desc 'local file.yml', %q{Locally merge GitHub repositories as specified in 
                            YAML file.}
  def local(file)
    Merge.new(file, options).local!
  end
end
