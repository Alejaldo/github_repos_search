class SearchController < ApplicationController
  before_action :validate_query, only: [:index], if: -> { params[:q].present? }

  def index
    query = params[:q]

    if query
      begin
        @repositories = Rails.cache.fetch("github_repos/#{query}", expires_in: 12.hours) do
          GithubService.search_repositories(query)
        end
      rescue => e
        Rails.logger.error "Error fetching repositories: #{e.message}"
        @repositories = []
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: @repositories }
    end
  end

  private

  def validate_query
    query = params[:q]

    unless query.length <= 255 && query =~ /\A[\w\s\-\.]+\z/
      Rails.logger.error "Invalid query parameter: #{query}"
      redirect_to root_path, alert: "Invalid search query."
    end
  end
end
