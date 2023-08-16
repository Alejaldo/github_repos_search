require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET index' do
    let(:query) { 'Ruby on Rails' }
    let(:repositories) { [repository_data] }
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

    before do
      allow(GithubService).to receive(:search_repositories).with(query).and_return(repositories)
    end

    it 'assigns @repositories' do
      get :index, params: { q: query }, format: :html
      expect(assigns(:repositories)).to eq(repositories)
    end

    it 'renders the index template' do
      get :index, params: { q: query }, format: :html
      expect(response).to render_template(:index)
    end

    it 'responds with JSON format' do
      get :index, params: { q: query }, format: :json
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.body).to eq(repositories.to_json)
    end

    context 'with invalid query parameter' do
      it 'redirects to root path for too long query' do
        get :index, params: { q: 'a' * 256 }
        expect(response).to redirect_to(root_path)
      end

      it 'redirects to root path for query with invalid characters' do
        get :index, params: { q: 'invalid/query!' }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'without query parameter' do
      it 'does not redirect and successfully renders the page' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end
end
