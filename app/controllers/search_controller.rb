class SearchController < ApplicationController
  def index
    query = params[:q]

    begin
      @repositories = Rails.cache.fetch("github_repos/#{query}", expires_in: 12.hours) do
        GithubService.search_repositories(query)
      end if query
    rescue => e
      Rails.logger.error "Error fetching repositories: #{e.message}"
      @repositories = []
    end

    respond_to do |format|
      format.html
      format.json { render json: @repositories }
    end
  end  
end
