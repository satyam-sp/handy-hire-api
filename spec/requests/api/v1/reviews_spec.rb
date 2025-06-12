require 'swagger_helper'

RSpec.describe 'Reviews API', type: :request do
  path '/api/v1/reviews' do
    post 'Submit a Review' do
      tags 'Reviews'
      consumes 'application/json'
      security [Bearer: []]

      parameter name: :review, in: :body, schema: {
        type: :object,
        properties: {
          job_id: { type: :integer },
          rating: { type: :integer, enum: [1, 2, 3, 4, 5] },
          comment: { type: :string },
          anonymous: { type: :boolean, example: false }
        },
        required: ['job_id', 'rating', 'comment']
      }

      response '201', 'Review submitted successfully' do
        schema type: :object, properties: {
          message: { type: :string },
          review: { type: :object }
        }
        run_test!
      end

      response '422', 'Invalid data' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end
  end

  path '/api/v1/reviews/{employee_id}' do
    get 'Get Employee Reviews' do
      tags 'Reviews'
      produces 'application/json'
      parameter name: :employee_id, in: :path, type: :integer, description: 'Employee ID'

      response '200', 'Reviews retrieved successfully' do
        schema type: :object, properties: {
          employee: { type: :string },
          average_rating: { type: :number },
          reviews: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                rating: { type: :integer },
                comment: { type: :string },
                created_at: { type: :string, format: :date },
                reviewer: { type: :string }
              }
            }
          }
        }
        run_test!
      end

      response '404', 'Employee not found' do
        schema type: :object, properties: { error: { type: :string } }
        run_test!
      end
    end
  end
end
