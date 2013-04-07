require 'thor'
require_relative 'merge'

class MergeCli < Thor
  desc 'local file.yml', %q{Locally merge GitHub repositories as specified in 
                            YAML file.}
  option :all_svn, :type => :boolean
  def local(file)
    Merge.new(file, options).local!
  end

  desc 'push file.yml', %q{Pushes merged GitHub repositories to new GitHub repo.
                           Will do local merge if one wasn't done already.}
  def push(file)
    Merge.new(file, options).push!
  end
end
