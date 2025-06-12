require 'swagger_helper'

RSpec.describe 'Job Categories API', type: :request do
  path '/api/v1/job_categories' do
    get 'Fetch Job Categories in Parent-Child Format' do
      tags 'Job Categories'
      produces 'application/json'

      response '200', 'Job categories retrieved successfully' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            children: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string }
                }
              }
            }
          }
        }

        run_test!
      end
    end
  end
end
