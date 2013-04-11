# github-merge

Script that merges multiple GitHub repositories into a new, single repository.

## Installation

This is a CLI app, so you'll have to:

```
$ gem install github-merge
```

## Usage

`github-merge` uses a YAML based configuration that lists the
repositories to merge and the name (and optionally organization) of the
new combined repository. A sample configuration file:

```yaml
merged organization: acme
merged repository: sinatra-templates
repositories:
  - url: https://github.com/rkh/sinatra-template.git
    sub directory: sinatra-base-template
  - url: https://github.com/sinatra/heroku-sinatra-app.git 
    sub directory: sinatra-heroku-template
```

You'd then merge the repositories:

```
$ github-merge local sinatra-templates.yml
```

### Options

*[--all-svn]*

Pass this argument if the repositories being merged started their life
in Subversion and were subsequently migrated to Git. This is required
because the merge has to skip the initial commit because of a weird
git-svn issue that causes the `git filter-branch` to bomb (don't ask
me, it was on Stackoverflow and it works).

### Technical Details

The merge process is done in the following steps

1. Clone repositories.
2. For each repository to be merged, execute a `git filter-branch` to
   move the entire repository contents into the specified subdirectory.
3. Create a new empty Git repository.
4. Add each repository to be merged as a remote repository.
5. Fetch and `git merge --no-edit <remote>/master` for each repository.

Note: a `git merge` is used to preserve the branching history of each
repository being merged.

### Limitations

The following are limitations of github-merge that may, or may not, be
addressed in the future.

* Does not carry over tags
* Does not carry over active (unmerged) branches
* Does not merge repositories with only 1 commit

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
