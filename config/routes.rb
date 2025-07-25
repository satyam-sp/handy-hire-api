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
        post :update_fcm_token, on: :collection
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
      resources :instant_jobs do # This creates routes like /instant_jobs/:instant_job_id
        resources :instant_job_applications, only: [:create, :index] do # This nests applications under a specific instant_job
          member do
            delete :cancel_application 
            put :update_status # This is a member action for an *individual* instant_job_application
          end
          collection do
            get :revoke_application
          end
        end
        collection do
          get :get_active_jobs # Generates: GET /instant_jobs/get_active_jobs
          post :get_jobs_by_cords # Generates: POST /instant_jobs/get_jobs_by_cords
        end
      end
      resources :notifications, only: [:index] do
        member do # `member` creates routes for a specific resource, e.g., /notifications/:id/mark_as_read
          patch :mark_as_read
        end
      end
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
