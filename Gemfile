source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.5", ">= 7.1.5.1"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
gem 'twilio-ruby'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
gem 'rspec-rails'
gem 'aws-sdk-s3', '~> 1.130'  # AWS SDK for S3

gem 'bcrypt'
gem 'jsonapi-serializer'
gem 'httparty', '~> 0.21.0'

gem 'geocoder'

gem 'fcm'
gem 'google-auth' # <-- Corrected gem name!
gem 'openssl' # Explicitly add the standard OpenSSL gem

gem 'active_storage_validations'  # To validate uploaded files
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem 'jwt'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem 'pry-byebug'

end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'bullet'
end


gem "rswag-api", "~> 2.16"
gem "rswag-ui", "~> 2.16"

gem "rswag-specs", "~> 2.16"
