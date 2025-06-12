# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # Use '*' to allow all, or specify your frontend URL(s), e.g.:
    # origins 'http://localhost:3000', 'http://127.0.0.1:3000'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: false
  end
end
