require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users
  resources :dashboard, only: :index
  resources :licensors do
    collection do
      get :search
    end
  end
  resources :keywords
  resources :brands do
    collection do
      get :search
    end
  end
  resources :activities, only: [:index]
  resources :imports, only: [] do
    collection do
      get :url
      post :create_from_url
    end
  end

  resources :facebook_pages, only: [:index, :destroy, :new, :create] do
    collection do
      get :search
    end
  end
  resources :facebook_posts, only: [:index, :edit, :update], path: "/facebook_ads" do
    collection do
      get :export
      post :mass_change_status
    end
  end
  post "/facebook_ads/:post_id/change_status/:status" => "facebook_posts#change_status",
        as: :post_change_status

  resources :domains, only: [:index, :create, :destroy, :update]
  post "/domains/:domain_id/change_status/:status" => "domains#change_status",
       as: :domain_change_status

  resources :reports, only: [] do
    collection do
      get :team_production
    end
  end

  resources :assigned_domains, only: [:create, :destroy]

  scope :admin do
    resources :users, only: [:index, :edit, :update, :destroy] do
      member do
        get :client_domain_request
      end
    end
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  root to: "dashboard#index"
end
