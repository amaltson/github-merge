require 'minitest/spec'
require 'minitest/autorun'
require 'github_merge/merge'
require 'fileutils'

describe Merge do
  before do
    FileUtils.rm_rf('out')
    options = MiniTest::Mock.new
    options.expect(:all_svn?, false)
    @merge = Merge.new 'test/sample-merge-config.yml', options
  end

  it "shouldn't be merged by default" do
    @merge.instance_variable_get("@local_merge").merged?.must_equal false
  end

  it "should merge locally" do
    @merge.local!

    # Check clone and rename worked
    %w{github-merge github}.each do |repo|
      Dir.exists?("out/#{repo}").must_equal true
      Dir.exists?("out/#{repo}/#{repo}").must_equal true
    end

    # check that the merge was successful
    merged_dir = "out/merge-test"
    Dir.exists?(merged_dir).must_equal true
    %w{github-merge github}.each do |repo|
      Dir.exists?("#{merged_dir}/#{repo}").must_equal true
    end

    @merge.instance_variable_get("@local_merge").merged?.must_equal true
  end
end
