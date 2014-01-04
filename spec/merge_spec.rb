require 'rspec'
require 'github_merge/merge'
require 'fileutils'

describe Merge do
  before :all do
    FileUtils.mkdir_p('/tmp/repo1')
    FileUtils.mkdir_p('/tmp/repo2')
    Dir.chdir('/tmp/repo1') do
      `git init`
      `touch repo1 && git add repo1`
      `git commit -m "repo1 commit 1"`
      `git commit -m "repo1 commit 2" --allow-empty`
      `git commit -m "repo1 commit 3" --allow-empty`
    end

    Dir.chdir('/tmp/repo2') do
      `git init`
      `touch repo2 && git add repo2`
      `git commit -m "repo2 commit 1"`
      `git commit -m "repo2 commit 2" --allow-empty`
    end
  end

  after :all do
    FileUtils.rm_rf('/tmp/repo1')
    FileUtils.rm_rf('/tmp/repo2')
  end

  before :each do
    @options = double()
    @options.stub(:all_svn? => false)
    @merge = Merge.new 'spec/sample-merge-config.yml', @options
  end

  after :each do
    FileUtils.rm_rf(LocalMerge::OUT_DIR)
  end

  it "shouldn't be merged by default" do
    @merge.instance_variable_get("@local_merge").merged?.should be_false
  end

  it "should merge locally into new repository" do
    @options.stub(:new_repo? => true)
    @merge.local!

    # Check clone and rename worked
    %w{github-merge github}.each do |repo|
      Dir.exists?("#{LocalMerge::OUT_DIR}/#{repo}").should be_true
      Dir.exists?("#{LocalMerge::OUT_DIR}/#{repo}/#{repo}").should be_true
    end

    # check that the merge was successful
    merged_dir = "#{LocalMerge::OUT_DIR}/merge-test"
    Dir.exists?(merged_dir).should be_true
    %w{github-merge github}.each do |repo|
      Dir.exists?("#{merged_dir}/#{repo}").should be_true
    end

    @merge.instance_variable_get("@local_merge").merged?.should be_true
  end

  it "should merge locally into existing repository" do
    @options.stub(:new_repo? => false)
    @merge.local!

    # check that the merge was successful
    merged_dir = "#{LocalMerge::OUT_DIR}/github-merge"
    Dir.exists?(merged_dir).should be_true
    Dir.exists?("#{merged_dir}/github").should be_true

    # Ensure there are 6 commits (5 + merge commit)
    Dir.chdir(merged_dir) do
      git_log = IO.popen("git log --oneline").each_with_object([]) do |line, log|
        log << line.chomp
      end
      git_log.size.should eq(6)
    end

    @merge.instance_variable_get("@local_merge").merged?.should be_true
  end
end
