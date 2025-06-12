require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/api/v1/users/register' do
    post 'Register a new user' do
      tags 'Users'
      consumes 'multipart/form-data'
      parameter name: :user, in: :formData, schema: {
        type: :object,
        properties: {
          full_name: { type: :string },
          username: { type: :string },
          email: { type: :string },
          mobile_number: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string },
          profile_photo: { type: :string, format: :binary },
          address: { type: :string }
        },
        required: %w[full_name username email mobile_number password password_confirmation]
      }
  
      response '201', 'User created' do
        schema type: :object, properties: {
          message: { type: :string },
          user: { type: :object }
        }
        run_test!
      end
  
      response '422', 'Validation error' do
        schema type: :object, properties: { error: { type: :array, items: { type: :string } } }
        run_test!
      end
    end
  end
  

  path '/api/v1/users/login' do
    post 'User login' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          login: { type: :string, description: 'Username or Email' },
          password: { type: :string }
        },
        required: %w[login password]
      }

      response '200', 'Login successful' do
        schema type: :object, properties: {
          message: { type: :string },
          user: { type: :object },
          token: { type: :string }
        }
        run_test!
      end

      response '401', 'Invalid credentials' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end
  end

  path '/api/v1/users/profile' do
    get 'User Profile' do
      tags 'Users'
      produces 'application/json'
      security [Bearer: []]

      response '200', 'Profile retrieved' do
        schema type: :object, properties: { user: { type: :object } }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end
  end
end
