require 'rails_helper'

RSpec.feature "GithubRepositorySearch", type: :feature, js: true do
  scenario "User searches for GitHub repositories" do
    stub_request(:get, "https://api.github.com/search/repositories?q=Rails")
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(
        status: 200,
        body: {
          items: [
            {
              name: "rails",
              full_name: "rails/rails",
              description: "Rails is awesome!",
              owner: { login: "rails-owner" },
              html_url: "https://github.com/rails/rails",
              stargazers_count: 100_000
            }
          ]
        }.to_json,
        headers: {}
      )

    visit "/search/index"

    fill_in "q", with: "Rails"
    click_button "Search"

    expect(page).to have_content "Name"
    expect(page).to have_content "Full Name"
    expect(page).to have_content "Description"
    expect(page).to have_content "Owner"
    expect(page).to have_content "URL"
    expect(page).to have_content "Stargazers"
  end
end
