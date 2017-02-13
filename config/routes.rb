Rails.application.routes.draw do
  resources :keywords
  resources :brands

  devise_for :users

  root to: "keywords#index"
end
