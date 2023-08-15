require 'rails_helper'

RSpec.describe "GET /index", type: :request do
  include WebMock::API

  it "returns http success without query" do
    get "/search/index"
    expect(response).to have_http_status(:success)
  end

  context "with query parameter" do
    let(:query) { "rails" }
    let(:repository_data) do
      {
        'name' => 'rails',
        'full_name' => 'rails/rails',
        'description' => 'Ruby on Rails',
        'owner' => { 'login' => 'rails' },
        'html_url' => 'https://github.com/rails/rails',
        'stargazers_count' => 12345
      }
    end

    before do
      stub_request(:get, "https://api.github.com/search/repositories?q=#{query}")
        .to_return(body: { items: [repository_data] }.to_json)
    end

    it "returns http success with query" do
      get "/search/index", params: { q: query }
      expect(response).to have_http_status(:success)
    end

    it "returns the expected repositories" do
      get "/search/index", params: { q: query }, as: :json
      expect(JSON.parse(response.body)).to include(repository_data)
    end
  end
end
