require 'sidekiq/web'

Rails.application.routes.draw do
  resources :keywords
  resources :brands

  devise_for :users
  mount Sidekiq::Web => '/sidekiq'

  root to: "keywords#index"
end
