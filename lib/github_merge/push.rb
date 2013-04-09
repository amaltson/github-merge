class PushMerge

  def initialize(config, options)
    @config = config
    @options = options
  end

  def push!
    github = initialize_github
  end

  def initialize_github
    api_endpoint = config["host"] || "https://api.github.com"
    oauth_token = config["oauth"]

    Github.new do |config|
      config.endpoint = api_endpoint
      config.oauth_token = oauth_token
      config.adapter = :net_http
    end
  end

end
