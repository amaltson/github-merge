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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
