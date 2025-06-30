Rails.application.routes.draw do

  # Agreements
  #
  # Admin > Users
  get "admin/users", to: "admin/users#index", as: :admin_users
  get "admin/users/:id", to: "admin/users#show", as: :admin_user

  get "admin/providers", to: "admin/providers#index", as: :admin_providers
  get "admin/providers/:id", to: "admin/providers#show", as: :admin_provider

  put "admin/providers/:id/approve", to: "admin/providers#approve", as: :approve_admin_provider
  put "admin/providers/:id/reject", to: "admin/providers#reject", as: :reject_admin_provider

  post "admin/impersonate/:id", to: "admin/users#impersonate_user", as: :impersonate_user
  delete "admin/impersonate/:id", to: "admin/users#stop_impersonating_user", as: :stop_impersonating_user

  # Admin
  get "admin", to: "admin/dashboard#dashboard", as: :admin_dashboard
  get "site/toc", as: :toc
  get "site/provider_toc", as: :provider_toc

  resources :providers, param: :slug do
     resources :agreements, param: :slug
      member do
        get "apply"
      end
  end

  namespace :provider do
     resources :bids, only: [ :index ]
  end

  resources :customers

  resources :rfps, param: :slug do
    member do
      get "publish"
      get "unpublish"
      put "complete"
    end
    resources :bids, param: :slug do
      put "accept"
      put "reject"
      put "confirm"
    end
  end

  resource :user do
    get "customer"
    get "provider"
  end

  # Authentication
  get "signup", to: "registrations#new", as: :new_registration
  post "registration/create", to: "registrations#create", as: :registration
  resource :session, except: %i[new]
  get "login", to: "sessions#new", as: :new_session
  resources :passwords, param: :token

  # User Profile
  get "users/edit", to: "users#edit", as: :edit_user_profile
  patch "users/update_profile", to: "users#update_profile", as: :update_user_profile
  get "users/manage_password", to: "users#manage_password", as: :manage_password
  patch "users/update_password", to: "users#update_password", as: :update_password
  get "users/remove_avatar", to: "users#remove_avatar", as: :remove_user_avatar

  match "/my/requests", controller: "rfps", action: "index", via: %i[get]
  get "/users/choose"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "rfps#index"
end
