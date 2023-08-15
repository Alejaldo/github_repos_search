Rails.application.routes.draw do
  # Search routes
  get 'search', to: 'search#index', as: 'search'
  get 'search/index'

  # Root path
  root 'search#index'

  # Optional: Sidekiq web interface (if you're using Sidekiq)
  # require 'sidekiq/web'
  # mount Sidekiq::Web => '/sidekiq'
end
