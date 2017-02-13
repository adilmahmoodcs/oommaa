Rails.application.routes.draw do
  devise_for :users

  resources :keywords

  root to: "keywords#index"
end
