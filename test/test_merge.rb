require 'minitest/spec'
require 'minitest/autorun'
require 'github_merge/merge'
require 'fileutils'

describe Merge do
  before do
    FileUtils.rm_r('out')
    @merge = Merge.new 'test/sample-merge-config.yml', nil
  end

  it "should merge locally" do
    @merge.local!

    # Check clone and rename worked
    %w{github-merge github}.each do |repo|
      Dir.exists?("out/#{repo}").must_equal true
      Dir.exists?("out/#{repo}/#{repo}").must_equal true
    end
  end
end
