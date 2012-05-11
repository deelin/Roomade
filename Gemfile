source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'json'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails', '>= 1.0.12'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# paperclip, for photo attachments, and aws' s3 service for storage
gem "paperclip", "~> 2.7"
gem 'aws-sdk'

# devise, for easy user authentication (https://github.com/plataformatec/devise)
gem 'devise'

# paginate for lazy loading
gem 'will_paginate', '~> 3.0'

group :test, :development do
  gem 'cucumber-rails'
  gem 'cucumber-rails-training-wheels'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'webrat'
end

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'sqlite3'
end

gem 'omniauth-facebook'
gem 'omniauth'