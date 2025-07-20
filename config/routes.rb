Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount ActionCable.server => '/cable'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check



  namespace :api do
    namespace :v1 do
      resources :users, only: [:update] do
        post :send_otp, on: :collection
        post :verify_otp, on: :collection
        get :get_current_user, on: :collection
      end
      get 'users/profile', to: 'users#profile'


      post 'wallet/withdraw', to: 'wallet#withdraw'

      resources :jobs
      resources :job_categories, only: [:index] do
      end

      resources :addresses, only: [:index, :create, :destroy] # <--- ADD THIS LINE


      resources :instant_job_applications, only: [:create]
      resources :employees, only: [:update] do
        collection do
          post :upload_video 
          post :register_step  # Multi-step registration
          post :login          # Login with username or email
          put  :update_profile # Update after registration
          get :get_employee
          patch  :update_avatar
        end
      end
      resources :instant_jobs do
        member do 
          resources :instant_job_applications, only: [:create] do
            collection do
              post :cancel_application
            end
          end
        end
        collection do
          get :get_active_jobs
          post :get_jobs_by_cords
        end
      end
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
