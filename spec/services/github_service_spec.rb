require 'rails_helper'

RSpec.describe GithubService do
  describe '.search_repositories' do
    let(:query) { 'Ruby on Rails' }
    let(:repository_data) do
      {
        'name' => 'repo1',
        'full_name' => 'user/repo1',
        'description' => 'A great repo',
        'owner' => { 'login' => 'user' },
        'html_url' => 'http://github.com/user/repo1',
        'stargazers_count' => 42
      }
    end

    context 'when the response is successful' do
      before do
        stub_request(:get, "#{GithubService::BASE_URL}?q=#{query}")
          .to_return(body: { items: [repository_data] }.to_json)
      end

      it 'returns the repositories' do
        expect(described_class.search_repositories(query)).to eq([repository_data])
      end
    end

    context 'when the response is unsuccessful' do
      before do
        stub_request(:get, "#{GithubService::BASE_URL}?q=#{query}")
          .to_return(status: 500)
      end

      it 'returns an empty array' do
        expect(described_class.search_repositories(query)).to eq([])
      end
    end
  end
end
