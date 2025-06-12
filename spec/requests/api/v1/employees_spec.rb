require 'swagger_helper'

RSpec.describe 'Employees API', type: :request do

  path '/api/v1/employees/register_step' do
    post 'Step-by-Step Employee Registration' do
      tags 'Employees'
      consumes ['multipart/form-data', 'application/json']
      parameter name: :step, in: :query, type: :integer, description: 'Registration Step (1, 2, or 3)'

      # ✅ Step 1: Basic Information (Includes Profile Photo Upload)
      response '200', 'Step 1 completed' do
        let(:step) { 1 }
        parameter name: :employee, in: :formData, schema: {
          type: :object,
          properties: {
            full_name: { type: :string },
            mobile_number: { type: :string },
            username: { type: :string },
            password: { type: :string },
            password_confirmation: { type: :string },
            date_of_birth: { type: :string, format: :date },
            gender: { type: :string, enum: ['male', 'female', 'other'] },
            email: { type: :string },
            profile_photo: { type: :string, format: :binary } # File upload
          },
          required: %w[full_name mobile_number username password password_confirmation]
        }

        schema type: :object, properties: {
          message: { type: :string },
          employee_id: { type: :integer }
        }
        run_test!
      end

      # ✅ Step 2: Identity Verification
      response '200', 'Step 2 completed' do
        let(:step) { 2 }
        parameter name: :employee, in: :body, schema: {
          type: :object,
          properties: {
            aadhaar_number: { type: :string },
            pan_number: { type: :string },
            address: { type: :string }
          },
          required: %w[aadhaar_number address]
        }

        schema type: :object, properties: {
          message: { type: :string }
        }
        run_test!
      end

      # ✅ Step 3: Job Details
      response '200', 'Step 3 completed' do
        let(:step) { 3 }
        parameter name: :employee, in: :body, schema: {
          type: :object,
          properties: {
            job_categories: { type: :jsonb },
            experience_years: { type: :integer },
            work_location: { type: :string },
            availability: { type: :string, enum: ['full-time', 'part-time'] },
            expected_pay: { type: :number }
          },
          required: %w[job_categories experience_years expected_pay]
        }

        schema type: :object, properties: {
          message: { type: :string }
        }
        run_test!
      end

      # ❌ Invalid Step
      response '422', 'Invalid Step' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end
  end

  path '/api/v1/employees/login' do
    post 'Login an Employee' do
      tags 'Employees'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          login: { type: :string, example: "testuser" },
          password: { type: :string, example: "password123" }
        },
        required: ['login', 'password']
      }

      response '200', 'Login successful' do
        schema type: :object, properties: {
          message: { type: :string },
          employee: { type: :object },
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

  path '/api/v1/employees/update_profile' do
    put 'Update Employee Profile (Including Profile Photo)' do
      tags 'Employees'
      consumes ['multipart/form-data', 'application/json']
      security [Bearer: []]

      parameter name: :employee, in: :formData, schema: {
        type: :object,
        properties: {
          full_name: { type: :string, example: "John Doe" },
          job_categories: { type: :jsonb, example: [1,2] },
          expected_pay: { type: :number, example: 500.00 },
          profile_photo: { type: :string, format: :binary } # File upload
        }
      }

      response '200', 'Profile updated successfully' do
        schema type: :object, properties: { 
          message: { type: :string }, 
          employee: { 
            type: :object, 
            properties: { 
              full_name: { type: :string },
              username: { type: :string },
              email: { type: :string },
              profile_photo_url: { type: :string, nullable: true }
            }
          } 
        }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end
  end
end
