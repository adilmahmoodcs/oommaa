require "sidekiq/web"

Rails.application.routes.draw do
  resources :licensors
  resources :keywords
  resources :brands
  resources :activities, only: [:index]
  resources :facebook_posts, only: [:index, :new, :create] do
    collection do
      get :export
    end
  end
  post "/facebook_posts/:post_id/change_status/:status" => "facebook_posts#change_status", as: :post_change_status
  resources :domains, only: [:index]
  post "/domains/:domain_id/change_status/:status" => "domains#change_status", as: :domain_change_status

  devise_for :users

  mount Sidekiq::Web => "/sidekiq"

  root to: "keywords#index"
end
