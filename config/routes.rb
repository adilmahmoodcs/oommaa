require 'sidekiq/web'

Rails.application.routes.draw do
  resources :keywords
  resources :brands
  resources :posts, only: [:index]

  post "/posts/:post_id/change_status/:status" => "posts#change_status", as: :post_change_status

  devise_for :users

  mount Sidekiq::Web => "/sidekiq"

  root to: "keywords#index"
end
