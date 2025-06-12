require 'swagger_helper'

RSpec.describe 'Job Applications API', type: :request do
  path '/api/v1/job_applications' do
    post 'Apply for a Job' do
      tags 'Job Applications'
      consumes 'application/json'
      security [Bearer: []]

      parameter name: :application, in: :body, schema: {
        type: :object,
        properties: {
          job_id: { type: :integer },
          cover_letter: { type: :string }
        },
        required: ['job_id']
      }

      response '201', 'Application submitted successfully' do
        schema type: :object, properties: {
          message: { type: :string },
          application: { type: :object }
        }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end
  end

  path '/api/v1/job_applications/{id}/update_status' do
    put 'Update Application Status (Employer)' do
      tags 'Job Applications'
      consumes 'application/json'
      security [Bearer: []]

      parameter name: :id, in: :path, type: :integer, description: 'Application ID'
      parameter name: :status, in: :body, schema: {
        type: :object,
        properties: {
          status: { type: :string, enum: ['accepted', 'rejected', 'completed'] }
        },
        required: ['status']
      }

      response '200', 'Application status updated' do
        schema type: :object, properties: {
          message: { type: :string },
          application: { type: :object }
        }
        run_test!
      end

      response '404', 'Application not found' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end
  end

  path '/api/v1/job_applications/{id}/withdraw' do
    put 'Withdraw Application (Employee)' do
      tags 'Job Applications'
      consumes 'application/json'
      security [Bearer: []]

      parameter name: :id, in: :path, type: :integer, description: 'Application ID'

      response '200', 'Application withdrawn' do
        schema type: :object, properties: { message: { type: :string } }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end
  end
end
