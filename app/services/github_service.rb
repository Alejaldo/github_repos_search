class GithubService
  include HTTParty

  BASE_URL = 'https://api.github.com/search/repositories'

  def self.search_repositories(query)
    response = HTTParty.get("#{BASE_URL}?q=#{query}")

    if response.success?
      JSON.parse(response.body)['items']
    else
      Rails.logger.error "Github API Error: #{response.code} - #{response.message}"
      []
    end
  end
end
