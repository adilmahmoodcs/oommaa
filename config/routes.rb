require "sidekiq/web"

Rails.application.routes.draw do
  resources :roles
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users
  resources :dashboard, only: :index
  resources :licensors do
    collection do
      get :search
    end
    member do
      get :cease_and_desist_email
      get :get_licensors_brands_info
    end
  end
  resources :keywords
  resources :brands do
    resources :brand_logos, only: [:show]
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

  resources :facebook_pages, only: [:index, :destroy, :new, :create, :update] do
    collection do
      get :search
    end
  end
  resources :facebook_posts, only: [:index, :edit, :update], path: "/facebook_ads" do
    collection do
      get :export
      post :mass_change_status
    end
    member do
      post :send_email_to_licensor
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
      get :employees_data
    end
  end

  resources :assigned_domains, only: [:create, :destroy]

  scope :admin do
    resources :users, only: [:index, :edit, :update, :new, :create, :destroy] do
      member do
        get :client_domain_request
      end
    end
  end

  resources :employees

  resources :email_templates, only: [:create, :update] do
    resources :sent_emails, shallow: true do
      collection do
        get :preview
      end
    end
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  root to: "dashboard#index"
end
