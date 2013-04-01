require "minitest/autorun"
require "github/repo/merge"

module TestGithub; end
module TestGithub::TestRepo; end

class TestGithub::TestRepo::TestMerge < MiniTest::Unit::TestCase
  def test_sanity
    flunk "write tests or I will kneecap you"
  end
end
