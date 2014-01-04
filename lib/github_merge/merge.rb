require 'yaml'
require 'rbconfig'
require 'fileutils'
require_relative 'local'
require_relative 'push'

class Merge
  VERSION = "0.0.2"
  MOVE_TREE_SCRIPT_PATH = "#{Dir.pwd}/lib/github_merge"

  def initialize(file, options)
    @file = file
    @options = options
    @config = YAML.load_file @file
    @local_merge = LocalMerge.new(@config, @options)
    @push_merge = PushMerge.new(@config, @options)
  end

  def local!
    @local_merge.merge!
  end

  def push!
    @local_merge.merge! unless @local_merge.merged?
    @push_merge.push!
  end
end
