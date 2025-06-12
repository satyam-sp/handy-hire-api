Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check



  namespace :api do
    namespace :v1 do
      post 'users/register', to: 'users#register'
      post 'users/login', to: 'users#login'
      get 'users/profile', to: 'users#profile'


      post 'wallet/withdraw', to: 'wallet#withdraw'

      resources :jobs
      resources :job_categories, only: [:index] do
      end
      resources :employees, only: [:update] do
        collection do
          post :register_step  # Multi-step registration
          post :login          # Login with username or email
          put  :update_profile # Update after registration
          get :get_employee
          patch  :update_avatar
        end
      end
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
