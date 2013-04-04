require 'yaml'

class Merge
  VERSION = "1.0.0"
  MOVE_TREE_SCRIPT_PATH = "#{Dir.pwd}/lib/github_merge"

  def initialize(file, options)
    @file = file
    @options = options
  end

  def local!
    config = YAML.load_file @file

    repo_dir = "#{Dir.pwd}/out"
    FileUtils.mkdir_p repo_dir
    Dir.chdir repo_dir do
      clone_repos(config)
      move_repos_to_subdir(config)
      merged_repo = create_merged_repo(config)
    end
  end

  def clone_repos(config)
    config["repositories"].each do |repo|
      `git clone #{repo["url"]} #{repo["sub directory"]}`
    end
  end

  def move_repos_to_subdir(config)
    config["repositories"].each do |repo|
      git_filter_branch_move(repo["sub directory"])
    end
  end

  def create_merged_repo(config)
    puts 'Creating merged repository'
    merged_repo = config["merged repository"].split('/').last
      `git init #{merged_repo}`
    merged_repo
  end

  def git_filter_branch_move(subdir)
    puts "Moving repository #{subdir} to subdirectory #{subdir}..."
    Dir.chdir subdir do
      %x[git filter-branch --index-filter \
        'git ls-files -s | gsed "s@\t@&#{subdir}/@" |
                GIT_INDEX_FILE=$GIT_INDEX_FILE.new \
                        git update-index --index-info &&
         mv "$GIT_INDEX_FILE.new" "$GIT_INDEX_FILE"']
    end
  end
end
