require 'yaml'
require 'rbconfig'
require 'fileutils'

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
      merge_repositories(merged_repo, config)
    end
  end

  def push!
    github = initialize_github
  end

  def initialize_github
    api_endpoint = config["host"] || "https://api.github.com"
    oauth_token = config["oauth"]

    Github.new do |config|
      config.endpoint = api_endpoint
      config.oauth_token = oauth_token
      config.adapter = :net_http
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

  def merge_repositories(merged_repo, config)
    Dir.chdir merged_repo do
      config["repositories"].each_with_index do |repo, index|
        repo_name = repo["sub directory"]
        `git remote add #{repo_name} ../#{repo_name}`
        `git fetch #{repo_name}`
        `git merge --no-edit #{repo_name}/master`
      end
    end
  end

  def git_filter_branch_move(subdir)
    puts "Moving repository #{subdir} to subdirectory #{subdir}..."

    sed = sed_command_to_use
    Dir.chdir subdir do
      %x[git filter-branch --index-filter \
        'git ls-files -s | #{sed} "s@\t@&#{subdir}/@" |
                GIT_INDEX_FILE=$GIT_INDEX_FILE.new \
                        git update-index --index-info &&
         mv "$GIT_INDEX_FILE.new" "$GIT_INDEX_FILE"' #{beginning_sha}..HEAD]
    end
  end

  def beginning_sha
    if @options.all_svn?
      `git log --pretty=format:%H --reverse`.split("\n")[1]
    else
      `git log --pretty=format:%H --reverse`.split("\n").first
    end
  end

  def sed_command_to_use
    if RbConfig::CONFIG['host_os'] =~ /darwin/
      'gsed'
    else
      'sed'
    end
  end
end
