class PushMerge

  def push!(config)
    github = initialize_github(config)
  end

  def initialize_github(config)
    api_endpoint = config["host"] || "https://api.github.com"
    oauth_token = config["oauth"]

    Github.new do |config|
      config.endpoint = api_endpoint
      config.oauth_token = oauth_token
      config.adapter = :net_http
    end
  end

end
