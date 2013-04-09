require 'rspec'
require 'github_merge/merge'
require 'fileutils'

describe Merge do
  before :each do
    options = double()
    options.stub(:all_svn? => false)
    @merge = Merge.new 'spec/sample-merge-config.yml', options
  end

  after :each do
    FileUtils.rm_rf('out')
  end

  it "shouldn't be merged by default" do
    @merge.instance_variable_get("@local_merge").merged?.should be_false
  end

  it "should merge locally" do
    @merge.local!

    # Check clone and rename worked
    %w{github-merge github}.each do |repo|
      Dir.exists?("out/#{repo}").should be_true
      Dir.exists?("out/#{repo}/#{repo}").should be_true
    end

    # check that the merge was successful
    merged_dir = "out/merge-test"
    Dir.exists?(merged_dir).should be_true
    %w{github-merge github}.each do |repo|
      Dir.exists?("#{merged_dir}/#{repo}").should be_true
    end

    @merge.instance_variable_get("@local_merge").merged?.should be_true
  end

  it "should merge local when pushing" do
  end
end
