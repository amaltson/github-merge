require 'yaml'

class Merge
  VERSION = "1.0.0"

  def initialize(file, options)
    @file = file
    @options = options
  end

  def local!
    config = YAML.load_file @file
    repo_dir = clone_repos(config)
  end

  def clone_repos(config)
    repo_dir = "#{Dir.pwd}/out"
    FileUtils.mkdir_p repo_dir
    Dir.chdir repo_dir do
      config["repositories"].each do |repo|
        `git clone #{repo["url"]} #{repo["sub directory"]}`
      end
    end
    repo_dir
  end
end
