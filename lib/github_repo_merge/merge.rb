require 'yaml'

class Merge
  VERSION = "1.0.0"

  def initialize(file, options)
    @file = file
    @options = options
  end

  def merge!
    config = YAML.load_file @file
  end
end
