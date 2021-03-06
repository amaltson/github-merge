class LocalMerge

  OUT_DIR = "#{Dir.pwd}/merged"

  attr_accessor :merge_repo_name, :repositories

  def initialize(merge_repo_name, repositories, options)
    @merge_repo_name = merge_repo_name
    @repositories = repositories
    @options = options
  end

  def merge!
    FileUtils.mkdir_p OUT_DIR
    @merge_repo_name = repositories.first['sub directory']
    Dir.chdir OUT_DIR do
      clone_repos(repositories)
      sub_repos = repositories[1..-1]
      move_repos_to_subdir(sub_repos)
      merge_repositories(sub_repos)
    end
  end

  def merge_new!
    FileUtils.mkdir_p OUT_DIR
    Dir.chdir OUT_DIR do
      clone_repos(repositories)
      move_repos_to_subdir(repositories)
      create_empty_merged_repo
      merge_repositories(repositories)
    end
  end

  def clone_repos(repos)
    repos.each do |repo|
      `git clone #{repo["url"]} #{repo["sub directory"]}`
    end
  end

  def move_repos_to_subdir(repos)
    repos.each do |repo|
      git_filter_branch_move(repo["sub directory"])
    end
  end

  def create_empty_merged_repo
    puts 'Creating merged repository'
    `git init #{merge_repo_name}`
  end

  def merge_repositories(repos)
    Dir.chdir merge_repo_name do
      repos.each_with_index do |repo, index|
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
    merge_repo_dir = "#{OUT_DIR}/#{merge_repo_name}"
    return false unless Dir.exist? merge_repo_dir
    Dir.chdir merge_repo_dir do
      return false unless Dir.exists? '.git'
      return `git log`.split("\n").size > 0
    end
  end
end
