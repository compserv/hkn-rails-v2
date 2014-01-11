source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.0'

# Assets
gem 'sass-rails', '~> 4.0.0'
gem 'jquery-rails', '2.2.1'
gem 'uglifier', '2.1.1'
gem 'turbolinks', '1.1.1'
gem 'bootstrap-sass-rails', '3.0.0.3'
gem 'jquery-ui-rails'

# User authentication
gem 'devise', '3.2.2'
gem 'rolify', '~> 3.3.0.rc4'

# spam stopper
gem "recaptcha", :require => "recaptcha/rails"

# Annotated models
gem 'annotate', '>= 2.5.0'

# Database
gem 'pg', '0.17.0'

# Performance monitoring
gem 'newrelic_rpm', '~> 3.6.8.168'

# File uploading
gem "paperclip", :git => "git://github.com/thoughtbot/paperclip.git"

# Lists
gem 'will_paginate', '3.0.4'

# Mailing Lists
gem 'mechanize'

# pdf usage
gem 'prawn'

group :development, :test do
  gem 'pry', '0.9.12.2'
  gem 'pry-rails', '0.3.2'
  gem 'awesome_print', '1.2.0'
  gem 'better_errors', '1.0.1'
  gem 'quiet_assets', '1.0.2'
  gem 'bullet', '4.7.1'
  gem 'debugger', '1.6.3'
  gem 'hirb', '0.7.1'
  gem 'airbrake', '3.1.14'
  gem 'rails_best_practices', '1.14.4'
  gem 'rspec-rails', '2.13.1'
end

group :test do
  gem 'rspec-rails', '2.13.1'
  gem 'factory_girl_rails', '4.2.0'
  gem 'selenium-webdriver', '~> 2.35.1'
  gem 'capybara', '2.1.0'
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
end

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'rails_12factor'
end
