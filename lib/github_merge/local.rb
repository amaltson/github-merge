class LocalMerge

  def initialize(config, options)
    @config = config
    @options = options
  end

  def merge!
    repo_dir = "#{Dir.pwd}/out"
    FileUtils.mkdir_p repo_dir
    Dir.chdir repo_dir do
      clone_repos
      move_repos_to_subdir
      create_merged_repo
      merge_repositories
    end
  end

  def clone_repos
    @config["repositories"].each do |repo|
      `git clone #{repo["url"]} #{repo["sub directory"]}`
    end
  end

  def move_repos_to_subdir
    @config["repositories"].each do |repo|
      git_filter_branch_move(repo["sub directory"])
    end
  end

  def create_merged_repo
    puts 'Creating merged repository'
    `git init #{merge_repo_name}`
  end

  def merge_repo_name
    @config["merged repository"].split('/').last
  end

  def merge_repositories
    Dir.chdir merge_repo_name do
      @config["repositories"].each_with_index do |repo, index|
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

  def merged?
    merge_repo_dir = "out/#{merge_repo_name}"
    return false unless Dir.exist? merge_repo_dir
    Dir.chdir merge_repo_dir do
      return false unless Dir.exists? '.git'
      return `git log`.split("\n").size > 0
    end
  end
end
