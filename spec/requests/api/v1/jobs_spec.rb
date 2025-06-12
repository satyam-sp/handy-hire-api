require 'swagger_helper'

RSpec.describe 'Jobs API', type: :request do

  path '/api/v1/jobs' do
    post 'Create a new job' do
      tags 'Jobs'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :job, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: "Plumbing Work" },
          description: { type: :string, example: "Need an experienced plumber for fixing a pipe" },
          job_category_id: { type: :integer, example: 1 },
          location: { type: :string, example: "New Delhi" },
          expected_pay: { type: :number, example: 1000.00 },
          pay_type: { type: :string, enum: ['hourly', 'daily', 'fixed'] },
          start_date: { type: :string, format: :date, example: "2025-04-10" },
          end_date: { type: :string, format: :date, example: "2025-04-12" },
          status: { type: :string, enum: ['open', 'closed', 'in_progress', 'completed'] }
        },
        required: ['title', 'description', 'job_category_id', 'location', 'expected_pay', 'pay_type']
      }

      response '201', 'Job created successfully' do
        schema type: :object, properties: { message: { type: :string } }
        run_test!
      end

      response '422', 'Invalid request' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end
  end

  path '/api/v1/jobs/{id}' do
    put 'Update an existing job' do
      tags 'Jobs'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :job, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: "Updated Job Title" },
          description: { type: :string, example: "Updated Job Description" },
          expected_pay: { type: :number, example: 1200.00 }
        }
      }

      response '200', 'Job updated successfully' do
        schema type: :object, properties: { message: { type: :string } }
        run_test!
      end

      response '404', 'Job not found' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end

    delete 'Delete an existing job' do
      tags 'Jobs'
      security [Bearer: []]
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'Job deleted successfully' do
        schema type: :object, properties: { message: { type: :string } }
        run_test!
      end

      response '404', 'Job not found' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end
  end
end
